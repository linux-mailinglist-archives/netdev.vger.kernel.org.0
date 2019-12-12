Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E00A11D2E9
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 17:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729961AbfLLQ56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 11:57:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52660 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729771AbfLLQ56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 11:57:58 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBCGv3c4012485
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:57:56 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=fxFTz/nH5cWvMP7IOZ6lsJ5VlXxMLtQ4z3m5TPJnLrQ=;
 b=hD/go61Htmf0v2NblW+XKptN5pS99NMrIMOWlUup9YbYosCfO1VmHuEj87ELBoh0wGNT
 svjnJIXvZN2BKEgsjRPG67x/SUr/Ngnc5RadJzvkpUbiBmdTCDwosT9exFgygHncy7WC
 I5ip57iTjWVGmUyr1MppFk/wv7K81+6eWGY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wu4ehnagv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 08:57:56 -0800
Received: from intmgw004.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 12 Dec 2019 08:57:54 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id BE54A2EC1AD2; Thu, 12 Dec 2019 08:41:42 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 04/15] libbpf: add BPF_EMBED_OBJ macro for embedding BPF .o files
Date:   Thu, 12 Dec 2019 08:41:17 -0800
Message-ID: <20191212164129.494329-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191212164129.494329-1-andriin@fb.com>
References: <20191212164129.494329-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-12_05:2019-12-12,2019-12-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 bulkscore=0 malwarescore=0
 priorityscore=1501 mlxscore=0 phishscore=0 spamscore=0 suspectscore=9
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912120130
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

