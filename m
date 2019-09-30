Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7282FC1C2F
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 09:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbfI3Hlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 03:41:53 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:21216 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726425AbfI3Hlx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 03:41:53 -0400
Received: from heffalump.sk2.org (unknown [88.186.243.14])
        by smtp5-g21.free.fr (Postfix) with ESMTPS id 53E2D5FF88;
        Mon, 30 Sep 2019 09:41:50 +0200 (CEST)
Received: from steve by heffalump.sk2.org with local (Exim 4.92)
        (envelope-from <steve@sk2.org>)
        id 1iEqKE-0003vP-FK; Mon, 30 Sep 2019 09:42:30 +0200
From:   Stephen Kitt <steve@sk2.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Stephen Kitt <steve@sk2.org>
Subject: [PATCH v2] bpf: use flexible array members, not zero-length
Date:   Mon, 30 Sep 2019 09:38:59 +0200
Message-Id: <20190930073858.7639-1-steve@sk2.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <F15E974F-4B7F-4819-B640-682A0A3A47C5@fb.com>
References: <F15E974F-4B7F-4819-B640-682A0A3A47C5@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This switches zero-length arrays in variable-length structs to C99
flexible array members. GCC will then ensure that the arrays are
always the last element in the struct.

Coccinelle:
@@
identifier S, fld;
type T;
@@

struct S {
  ...
  T fld[
- 0
  ];
  ...
};

Signed-off-by: Stephen Kitt <steve@sk2.org>
---
 Documentation/bpf/btf.rst       | 2 +-
 tools/lib/bpf/libbpf.c          | 2 +-
 tools/lib/bpf/libbpf_internal.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/bpf/btf.rst b/Documentation/bpf/btf.rst
index 4d565d202ce3..24ce50fc1fc1 100644
--- a/Documentation/bpf/btf.rst
+++ b/Documentation/bpf/btf.rst
@@ -670,7 +670,7 @@ func_info for each specific ELF section.::
         __u32   sec_name_off; /* offset to section name */
         __u32   num_info;
         /* Followed by num_info * record_size number of bytes */
-        __u8    data[0];
+        __u8    data[];
      };
 
 Here, num_info must be greater than 0.
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index e0276520171b..c02ea0e1a588 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -5577,7 +5577,7 @@ static struct perf_buffer *__perf_buffer__new(int map_fd, size_t page_cnt,
 struct perf_sample_raw {
 	struct perf_event_header header;
 	uint32_t size;
-	char data[0];
+	char data[];
 };
 
 struct perf_sample_lost {
diff --git a/tools/lib/bpf/libbpf_internal.h b/tools/lib/bpf/libbpf_internal.h
index 2e83a34f8c79..930ada2276bf 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -86,7 +86,7 @@ struct btf_ext_info_sec {
 	__u32	sec_name_off;
 	__u32	num_info;
 	/* Followed by num_info * record_size number of bytes */
-	__u8	data[0];
+	__u8	data[];
 };
 
 /* The minimum bpf_func_info checked by the loader */
-- 
2.20.1

