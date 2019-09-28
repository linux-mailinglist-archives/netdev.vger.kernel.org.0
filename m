Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00CD1C1113
	for <lists+netdev@lfdr.de>; Sat, 28 Sep 2019 16:47:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfI1Ors (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Sep 2019 10:47:48 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:64404 "EHLO smtp5-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbfI1Ors (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Sep 2019 10:47:48 -0400
Received: from heffalump.sk2.org (unknown [88.186.243.14])
        by smtp5-g21.free.fr (Postfix) with ESMTPS id 0C4925FF6C;
        Sat, 28 Sep 2019 16:47:45 +0200 (CEST)
Received: from steve by heffalump.sk2.org with local (Exim 4.92)
        (envelope-from <steve@sk2.org>)
        id 1iEE1L-00012P-KS; Sat, 28 Sep 2019 16:48:27 +0200
From:   Stephen Kitt <steve@sk2.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>
Cc:     linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org,
        "Gustavo A . R . Silva" <gustavo@embeddedor.com>,
        Stephen Kitt <steve@sk2.org>
Subject: [PATCH] bpf: use flexible array members, not zero-length
Date:   Sat, 28 Sep 2019 16:48:14 +0200
Message-Id: <20190928144814.27002-1-steve@sk2.org>
X-Mailer: git-send-email 2.20.1
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
- T fld[0];
+ T fld[];
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
index 2e83a34f8c79..26eaa3f594aa 100644
--- a/tools/lib/bpf/libbpf_internal.h
+++ b/tools/lib/bpf/libbpf_internal.h
@@ -86,7 +86,7 @@ struct btf_ext_info_sec {
 	__u32	sec_name_off;
 	__u32	num_info;
 	/* Followed by num_info * record_size number of bytes */
-	__u8	data[0];
+	__u8 data[];
 };
 
 /* The minimum bpf_func_info checked by the loader */
-- 
2.20.1

