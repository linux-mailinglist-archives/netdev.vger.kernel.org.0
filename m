Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939CE2DD393
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 16:02:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728953AbgLQPBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 10:01:47 -0500
Received: from gofer.mess.org ([88.97.38.141]:34059 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728781AbgLQPBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Dec 2020 10:01:46 -0500
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 968C011A001; Thu, 17 Dec 2020 15:01:02 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1608217262; bh=qwTTyCxEAzSEaQKYD8zY8b7vlNqO68xHkST3ZUNBE9c=;
        h=Date:From:To:Subject:From;
        b=jYx1M5oMnTMP+35GOb1o3Vm/8kqyX54IA0hlOhXJybCELL3Dt1aFR18GmFSkdyU/S
         48TtKiiEAuvlwmtRgoImptBfvsdDOwbUpsEOTfJBoGYeIEofo+W3rFlvcMox8I6Zie
         lwsaJMvKpoeKZDt9sFkFrgfUSQDFetWptc6lKpJtz87E3UldLlOE4xBdlsBsjl5J/5
         hhTvZXr378YMfaI3VTI0N9egxGMKQVbKAdlIz9O/7aw8IEO9ITV8gp0CmhfeTYnchM
         Ri6XMh/DxT4FXU1ipaXHbhqf2FpR9ctRPu1lAUpnZ8qoK7zsen0G6zDu8nYPNHaZxp
         Fo6IaVjcpOOwA==
Date:   Thu, 17 Dec 2020 15:01:02 +0000
From:   Sean Young <sean@mess.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH] btf: support ints larger than 128 bits
Message-ID: <20201217150102.GA13532@gofer.mess.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

clang supports arbitrary length ints using the _ExtInt extension. This
can be useful to hold very large values, e.g. 256 bit or 512 bit types.

Larger types (e.g. 1024 bits) are possible but I am unaware of a use
case for these.

This requires the _ExtInt extension to enabled for BPF in clang, which
is under review.

Link: https://clang.llvm.org/docs/LanguageExtensions.html#extended-integer-types
Link: https://reviews.llvm.org/D93103

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/bpf/btf.rst      |  4 ++--
 include/uapi/linux/btf.h       |  2 +-
 tools/bpf/bpftool/btf_dumper.c | 39 ++++++++++++++++++++++++++++++++++
 tools/include/uapi/linux/btf.h |  2 +-
 4 files changed, 43 insertions(+), 4 deletions(-)

diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
index 44dc789de2b4..784f1743dbc7 100644
--- a/Documentation/bpf/btf.rst
+++ b/Documentation/bpf/btf.rst
@@ -132,7 +132,7 @@ The following sections detail encoding of each kind.
 
   #define BTF_INT_ENCODING(VAL)   (((VAL) & 0x0f000000) >> 24)
   #define BTF_INT_OFFSET(VAL)     (((VAL) & 0x00ff0000) >> 16)
-  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000000ff)
+  #define BTF_INT_BITS(VAL)       ((VAL)  & 0x000003ff)
 
 The ``BTF_INT_ENCODING`` has the following attributes::
 
@@ -147,7 +147,7 @@ pretty print. At most one encoding can be specified for the int type.
 The ``BTF_INT_BITS()`` specifies the number of actual bits held by this int
 type. For example, a 4-bit bitfield encodes ``BTF_INT_BITS()`` equals to 4.
 The ``btf_type.size * 8`` must be equal to or greater than ``BTF_INT_BITS()``
-for the type. The maximum value of ``BTF_INT_BITS()`` is 128.
+for the type. The maximum value of ``BTF_INT_BITS()`` is 512.
 
 The ``BTF_INT_OFFSET()`` specifies the starting bit offset to calculate values
 for this int. For example, a bitfield struct member has:
diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
index 5a667107ad2c..1696fd02b302 100644
--- a/include/uapi/linux/btf.h
+++ b/include/uapi/linux/btf.h
@@ -84,7 +84,7 @@ struct btf_type {
  */
 #define BTF_INT_ENCODING(VAL)	(((VAL) & 0x0f000000) >> 24)
 #define BTF_INT_OFFSET(VAL)	(((VAL) & 0x00ff0000) >> 16)
-#define BTF_INT_BITS(VAL)	((VAL)  & 0x000000ff)
+#define BTF_INT_BITS(VAL)	((VAL)  & 0x000003ff)
 
 /* Attributes stored in the BTF_INT_ENCODING */
 #define BTF_INT_SIGNED	(1 << 0)
diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
index 0e9310727281..45ed45ea9962 100644
--- a/tools/bpf/bpftool/btf_dumper.c
+++ b/tools/bpf/bpftool/btf_dumper.c
@@ -271,6 +271,40 @@ static void btf_int128_print(json_writer_t *jw, const void *data,
 	}
 }
 
+static void btf_bigint_print(json_writer_t *jw, const void *data, int nr_bits,
+			     bool is_plain_text)
+{
+	char buf[nr_bits / 4 + 1];
+	bool first = true;
+	int i;
+
+#ifdef __BIG_ENDIAN_BITFIELD
+	for (i = 0; i < nr_bits / 64; i++) {
+#else
+	for (i = nr_bits / 64 - 1; i >= 0; i++) {
+#endif
+		__u64 v = ((__u64 *)data)[i];
+
+		if (first) {
+			if (!v)
+				continue;
+
+			snprintf(buf, sizeof(buf), "%llx", v);
+
+			first = false;
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
@@ -373,6 +407,11 @@ static int btf_dumper_int(const struct btf_type *t, __u8 bit_offset,
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
diff --git a/tools/include/uapi/linux/btf.h b/tools/include/uapi/linux/btf.h
index 5a667107ad2c..1696fd02b302 100644
--- a/tools/include/uapi/linux/btf.h
+++ b/tools/include/uapi/linux/btf.h
@@ -84,7 +84,7 @@ struct btf_type {
  */
 #define BTF_INT_ENCODING(VAL)	(((VAL) & 0x0f000000) >> 24)
 #define BTF_INT_OFFSET(VAL)	(((VAL) & 0x00ff0000) >> 16)
-#define BTF_INT_BITS(VAL)	((VAL)  & 0x000000ff)
+#define BTF_INT_BITS(VAL)	((VAL)  & 0x000003ff)
 
 /* Attributes stored in the BTF_INT_ENCODING */
 #define BTF_INT_SIGNED	(1 << 0)
-- 
2.29.2

