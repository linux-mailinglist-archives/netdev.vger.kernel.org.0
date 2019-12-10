Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D382117CF9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 02:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727683AbfLJBPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 20:15:10 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:30224 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727664AbfLJBPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 20:15:08 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBA1F6JQ027001
        for <netdev@vger.kernel.org>; Mon, 9 Dec 2019 17:15:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=ShYTKISBkXInhOYH3/z+4WZ3y83iWQuE2uNpZm+8iKU=;
 b=jz7i90b6rNQ5KqNWAiNPJ9KJGfXoMl7QObj/uJzYNRrUGjkgCZ8ekDGJviWprWPmlWvI
 1SzVsGVSJq1BouGrsvMhHwbn6F/WfQbgVNJzxn6lGRPjFSZmpH7PERueHJNOTx2WZ87G
 oAP0wVFDr/9x329hLoej3SiORZzI1SLCw1g= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wrvye7yvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 17:15:07 -0800
Received: from intmgw004.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 9 Dec 2019 17:14:56 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id DFA192EC16B5; Mon,  9 Dec 2019 17:14:55 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 04/15] libbpf: add BPF_EMBED_OBJ macro for embedding BPF .o files
Date:   Mon, 9 Dec 2019 17:14:27 -0800
Message-ID: <20191210011438.4182911-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191210011438.4182911-1-andriin@fb.com>
References: <20191210011438.4182911-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-09_05:2019-12-09,2019-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 clxscore=1015 adultscore=0 impostorscore=0
 lowpriorityscore=0 mlxlogscore=999 suspectscore=9 spamscore=0
 priorityscore=1501 bulkscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-1910280000
 definitions=main-1912100009
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a convenience macro BPF_EMBED_OBJ, which allows to embed other files
(typically used to embed BPF .o files) into a hosting userspace programs. To
C program it is exposed as struct bpf_embed_data, containing a pointer to
raw data and its size in bytes.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.h                        | 35 +++++++++++++++++++
 .../selftests/bpf/prog_tests/attach_probe.c   | 23 ++----------
 2 files changed, 38 insertions(+), 20 deletions(-)

diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
index 2698fbcb0c79..fa803dde1f46 100644
--- a/tools/lib/bpf/libbpf.h
+++ b/tools/lib/bpf/libbpf.h
@@ -615,6 +615,41 @@ bpf_program__bpil_offs_to_addr(struct bpf_prog_info_linear *info_linear);
  */
 LIBBPF_API int libbpf_num_possible_cpus(void);
 
+struct bpf_embed_data {
+	void *data;
+	size_t size;
+};
+
+#define BPF_EMBED_OBJ_DECLARE(NAME)					\
+extern struct bpf_embed_data NAME##_embed;				\
+extern char NAME##_data[];						\
+extern char NAME##_data_end[];
+
+#define __BPF_EMBED_OBJ(NAME, PATH, SZ, ASM_TYPE)			\
+asm (									\
+"	.pushsection \".rodata\", \"a\", @progbits		\n"	\
+"	.global "#NAME"_data					\n"	\
+#NAME"_data:							\n"	\
+"	.incbin \"" PATH "\"					\n"	\
+"	.global "#NAME"_data_end				\n"	\
+#NAME"_data_end:						\n"	\
+"	.global "#NAME"_embed					\n"	\
+"	.type "#NAME"_embed, @object				\n"	\
+"	.size "#NAME"_size, "#SZ"				\n"	\
+"	.align 8,						\n"	\
+#NAME"_embed:							\n"	\
+"	"ASM_TYPE" "#NAME"_data					\n"	\
+"	"ASM_TYPE" "#NAME"_data_end - "#NAME"_data 		\n"	\
+"	.popsection						\n"	\
+);									\
+BPF_EMBED_OBJ_DECLARE(NAME)
+
+#if __SIZEOF_POINTER__ == 4
+#define BPF_EMBED_OBJ(NAME, PATH) __BPF_EMBED_OBJ(NAME, PATH, 8, ".long")
+#else
+#define BPF_EMBED_OBJ(NAME, PATH) __BPF_EMBED_OBJ(NAME, PATH, 16, ".quad")
+#endif
+
 #ifdef __cplusplus
 } /* extern "C" */
 #endif
diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
index a83111a32d4a..b2e7c1424b07 100644
--- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
+++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
@@ -1,24 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <test_progs.h>
 
-#define EMBED_FILE(NAME, PATH)						    \
-asm (									    \
-"      .pushsection \".rodata\", \"a\", @progbits              \n"	    \
-"      .global "#NAME"_data                                    \n"	    \
-#NAME"_data:                                                   \n"	    \
-"      .incbin \"" PATH "\"                                    \n"	    \
-#NAME"_data_end:                                               \n"	    \
-"      .global "#NAME"_size                                    \n"	    \
-"      .type "#NAME"_size, @object                             \n"	    \
-"      .size "#NAME"_size, 4                                   \n"	    \
-"      .align 4,                                               \n"	    \
-#NAME"_size:                                                   \n"	    \
-"      .int "#NAME"_data_end - "#NAME"_data                    \n"	    \
-"      .popsection                                             \n"	    \
-);									    \
-extern char NAME##_data[];						    \
-extern int NAME##_size;
-
 ssize_t get_base_addr() {
 	size_t start;
 	char buf[256];
@@ -39,7 +21,7 @@ ssize_t get_base_addr() {
 	return -EINVAL;
 }
 
-EMBED_FILE(probe, "test_attach_probe.o");
+BPF_EMBED_OBJ(probe, "test_attach_probe.o");
 
 void test_attach_probe(void)
 {
@@ -73,7 +55,8 @@ void test_attach_probe(void)
 	uprobe_offset = (size_t)&get_base_addr - base_addr;
 
 	/* open object */
-	obj = bpf_object__open_mem(probe_data, probe_size, &open_opts);
+	obj = bpf_object__open_mem(probe_embed.data, probe_embed.size,
+				   &open_opts);
 	if (CHECK(IS_ERR(obj), "obj_open_mem", "err %ld\n", PTR_ERR(obj)))
 		return;
 
-- 
2.17.1

