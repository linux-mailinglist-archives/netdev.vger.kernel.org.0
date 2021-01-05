Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03C1F2EADAB
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 15:46:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728217AbhAEOqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 09:46:21 -0500
Received: from gofer.mess.org ([88.97.38.141]:46111 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728023AbhAEOqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 09:46:19 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 01ED6C63A5; Tue,  5 Jan 2021 14:45:34 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1609857935; bh=g86agJ+LPCw8ZkNJiHIjn0DJBtQq5JIr7Xq67deH28w=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=XHOybA/r4qqH1zaC2uKTFdjC2EijfmJkW3d1TIyxp0nrJ3ZBi+LQthgf5jiCUFEb5
         zR+ZMU3J3k6BCc0FOnZuBWL5oVjbdlhIJpd7Hp7Mp5j1Sc4bF/vY84Kbfcc011OUpC
         LZLRppiXbiEV5ko1jHT4gPGaBJ2LbDbhTxkbHl0aouRai2FM98PG13HatJzHYbJX0C
         6YRHdrobCpiPQwTp0K+OaV8gOwSNmuhhV97jW77PufdLz3CILYqcJduwwjsxKqtTl4
         7gu5rHs/siDqlhWC+aa2QhOrIClNp8CagKEOoQiKJZcCTDh76JRPYUcJ0vryfv/N+P
         E4tn0ykEpX8gw==
From:   Sean Young <sean@mess.org>
To:     Yonghong Song <yhs@fb.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH v3 3/4] bpftool: add support for ints larger than 128 bits
Date:   Tue,  5 Jan 2021 14:45:33 +0000
Message-Id: <67ffe6998af5cf88bdda6eaa1e6b085db1e093ed.1609855479.git.sean@mess.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1609855479.git.sean@mess.org>
References: <cover.1609855479.git.sean@mess.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang supports arbitrary length ints using the _ExtInt extension. This
can be useful to hold very large values, e.g. 256 bit or 512 bit types.

This requires the _ExtInt extension enabled in clang, which is under
review.

Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
Link: https://reviews.llvm.org/D93103

Signed-off-by: Sean Young <sean@mess.org>
---
 tools/bpf/bpftool/btf_dumper.c | 40 ++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 0e9310727281..8b5318ec5c26 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -271,6 +271,41 @@ static void btf_int128_print(json_writer_t *jw, const void *data,
 	}
 }
 
+static void btf_bigint_print(json_writer_t *jw, const void *data, int nr_bits,
+			     bool is_plain_text)
+{
+	char buf[nr_bits / 4 + 1];
+	int last_u64 = nr_bits / 64 - 1;
+	bool seen_nonzero = false;
+	int i;
+
+	for (i = 0; i <= last_u64; i++) {
+#ifdef __BIG_ENDIAN_BITFIELD
+		__u64 v = ((__u64 *)data)[i];
+#else
+		__u64 v = ((__u64 *)data)[last_u64 - i];
+#endif
+
+		if (!seen_nonzero) {
+			if (!v && i != last_u64)
+				continue;
+
+			snprintf(buf, sizeof(buf), "%llx", v);
+
+			seen_nonzero = true;
+		} else {
+			size_t off = strlen(buf);
+
+			snprintf(buf + off, sizeof(buf) - off, "%016llx", v);
+		}
+	}
+
+	if (is_plain_text)
+		jsonw_printf(jw, "0x%s", buf);
+	else
+		jsonw_printf(jw, "\"0x%s\"", buf);
+}
+
 static void btf_int128_shift(__u64 *print_num, __u16 left_shift_bits,
 			     __u16 right_shift_bits)
 {
@@ -373,6 +408,11 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
 		return 0;
 	}
 
+	if (nr_bits > 128) {
+		btf_bigint_print(jw, data, nr_bits, is_plain_text);
+		return 0;
+	}
+
 	if (nr_bits == 128) {
 		btf_int128_print(jw, data, is_plain_text);
 		return 0;
-- 
2.29.2

