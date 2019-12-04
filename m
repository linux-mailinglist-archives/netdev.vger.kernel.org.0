Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 475A111231C
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 08:00:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727193AbfLDHAd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 02:00:33 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:19326 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725958AbfLDHAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 02:00:30 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xB46xk2H025820
        for <netdev@vger.kernel.org>; Tue, 3 Dec 2019 23:00:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=ShYTKISBkXInhOYH3/z+4WZ3y83iWQuE2uNpZm+8iKU=;
 b=YDGv3mrI/wL3v8uyqWFM5vsuR0fiodtPJDDR3LHNiYd4QA2bBJzaTAl2Gh24xHIKb8C5
 sSVOT77AIW4LDnaoNKaV2rhBTLNDp6tPHU10qfhfIYSgLTTI5ZkIiC5me0wpQaL9XTjj
 tGBY0cp0BxbnJkg8n7cOoWNjj6Vqn0H0XUI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wp7kar4qv-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 03 Dec 2019 23:00:29 -0800
Received: from 2401:db00:30:6012:face:0:17:0 (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 3 Dec 2019 23:00:27 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 0D92C2EC1853; Tue,  3 Dec 2019 23:00:27 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [RFC PATCH bpf-next 04/16] libbpf: add BPF_EMBED_OBJ macro for embedding BPF .o files
Date:   Tue, 3 Dec 2019 23:00:03 -0800
Message-ID: <20191204070015.3523523-5-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191204070015.3523523-1-andriin@fb.com>
References: <20191204070015.3523523-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-04_01:2019-12-04,2019-12-03 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 mlxlogscore=999 malwarescore=0 suspectscore=9 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912040051
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

