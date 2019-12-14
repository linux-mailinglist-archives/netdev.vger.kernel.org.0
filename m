Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF2D711EFA5
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbfLNBn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:43:59 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:45176 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726820AbfLNBn5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:43:57 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBE1f4st029935
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:43:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=fxFTz/nH5cWvMP7IOZ6lsJ5VlXxMLtQ4z3m5TPJnLrQ=;
 b=icGU4ISxFPhRE0W9G6qMcum0AxqhWc6k0yXOSTxBeiDFcPgS/7pKq7Iy1atl35RpTAiQ
 Xk5GvMlxxZ7DImM1yQ227ouTI2QZKNuT3kV256/atbfwNx9RwpRe8+O7c4+lHNlgwLoF
 x/lkZWbBlpIW+QBncpiADvkQcp8ZttADD3A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2wv8b03nrt-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:43:55 -0800
Received: from intmgw002.08.frc2.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 17:43:54 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 930522EC1D51; Fri, 13 Dec 2019 17:43:52 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 04/17] libbpf: add BPF_EMBED_OBJ macro for embedding BPF .o files
Date:   Fri, 13 Dec 2019 17:43:28 -0800
Message-ID: <20191214014341.3442258-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214014341.3442258-1-andriin@fb.com>
References: <20191214014341.3442258-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 phishscore=0 priorityscore=1501 mlxlogscore=999 clxscore=1015 mlxscore=0
 adultscore=0 bulkscore=0 suspectscore=9 spamscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140006
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a convenience macro BPF_EMBED_OBJ, which allows to embed other files
(typically used to embed BPF .o files) into a hosting userspace programs. To
C program it is exposed as struct bpf_embed_data, containing a pointer to
raw data and its size in bytes.

Acked-by: Martin KaFai Lau <kafai@fb.com>
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

