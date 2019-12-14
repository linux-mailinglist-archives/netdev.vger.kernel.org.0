Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B31F311EFC3
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfLNBrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:47:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:6244 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726668AbfLNBrR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:47:17 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE1jqRX001022
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:47:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=/Kf5k76f9dHg7m8EaKvtUvbsvEtUBfI48mYUWGI0lPY=;
 b=EERD8fDOW51qRBOBR2M3zy3zNXWgGhtD0/ewwLv44bRU0ZIv+Y4mS8vfBYNrOMtJE2HM
 JgcW90cH3+qeQwFdbCa9l8xt7pxpGwhoKQqTyFt94WHFx7skjDDLt+/XeHGhBKsw2Ebo
 JggBe23nvB55UYUNC/ncAXaRmkNrCBjHfQM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvp7hg0v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:47:16 -0800
Received: from intmgw002.05.ash5.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Fri, 13 Dec 2019 17:47:15 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 5AA6C2EC1D1F; Fri, 13 Dec 2019 17:47:14 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 1/4] libbpf: extract internal map names into constants
Date:   Fri, 13 Dec 2019 17:47:07 -0800
Message-ID: <20191214014710.3449601-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214014710.3449601-1-andriin@fb.com>
References: <20191214014710.3449601-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 mlxlogscore=829 suspectscore=9 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of duplicating string literals, keep them in one place and consistent.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a1a902fa6e0c..f6c135869701 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -195,6 +195,10 @@ struct bpf_program {
 	__u32 prog_flags;
 };
 
+#define DATA_SEC ".data"
+#define BSS_SEC ".bss"
+#define RODATA_SEC ".rodata"
+
 enum libbpf_map_type {
 	LIBBPF_MAP_UNSPEC,
 	LIBBPF_MAP_DATA,
@@ -203,9 +207,9 @@ enum libbpf_map_type {
 };
 
 static const char * const libbpf_type_to_btf_name[] = {
-	[LIBBPF_MAP_DATA]	= ".data",
-	[LIBBPF_MAP_BSS]	= ".bss",
-	[LIBBPF_MAP_RODATA]	= ".rodata",
+	[LIBBPF_MAP_DATA]	= DATA_SEC,
+	[LIBBPF_MAP_BSS]	= BSS_SEC,
+	[LIBBPF_MAP_RODATA]	= RODATA_SEC,
 };
 
 struct bpf_map {
@@ -736,13 +740,13 @@ int bpf_object__section_size(const struct bpf_object *obj, const char *name,
 	*size = 0;
 	if (!name) {
 		return -EINVAL;
-	} else if (!strcmp(name, ".data")) {
+	} else if (!strcmp(name, DATA_SEC)) {
 		if (obj->efile.data)
 			*size = obj->efile.data->d_size;
-	} else if (!strcmp(name, ".bss")) {
+	} else if (!strcmp(name, BSS_SEC)) {
 		if (obj->efile.bss)
 			*size = obj->efile.bss->d_size;
-	} else if (!strcmp(name, ".rodata")) {
+	} else if (!strcmp(name, RODATA_SEC)) {
 		if (obj->efile.rodata)
 			*size = obj->efile.rodata->d_size;
 	} else {
@@ -1684,10 +1688,10 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 						name, obj->path, cp);
 					return err;
 				}
-			} else if (strcmp(name, ".data") == 0) {
+			} else if (strcmp(name, DATA_SEC) == 0) {
 				obj->efile.data = data;
 				obj->efile.data_shndx = idx;
-			} else if (strcmp(name, ".rodata") == 0) {
+			} else if (strcmp(name, RODATA_SEC) == 0) {
 				obj->efile.rodata = data;
 				obj->efile.rodata_shndx = idx;
 			} else {
@@ -1717,7 +1721,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 
 			obj->efile.reloc_sects[nr_sects].shdr = sh;
 			obj->efile.reloc_sects[nr_sects].data = data;
-		} else if (sh.sh_type == SHT_NOBITS && strcmp(name, ".bss") == 0) {
+		} else if (sh.sh_type == SHT_NOBITS &&
+			   strcmp(name, BSS_SEC) == 0) {
 			obj->efile.bss = data;
 			obj->efile.bss_shndx = idx;
 		} else {
-- 
2.17.1

