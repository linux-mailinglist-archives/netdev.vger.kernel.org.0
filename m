Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDA911EEE0
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 00:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726787AbfLMXwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 18:52:05 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10854 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725747AbfLMXwF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 18:52:05 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xBDNpONP012067
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:52:03 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=3jgv214W+Q1bUsa5u2arH8z75kMp8T9DZ0N63qmHTfc=;
 b=KyLlW1tYew5QCHx5oufl/BUJGFNSLpvroQqOa2or/FprdxTzYnIL71WM/GwriXyHUQOC
 WpKi9OZI1gCmp9Uu6rng0uqaVed7Mwrtp4WvTXatk7plRuIk2kRCCHPDCXFYFw66MpKL
 uYEgVsc1LLQm61HW7IgwbZPoHwR6K5I1xNs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2wvfg8sejy-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 15:52:03 -0800
Received: from intmgw005.05.ash5.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 15:51:48 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 67A0D2EC1A1D; Fri, 13 Dec 2019 15:51:48 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v3 bpf-next 1/4] libbpf: extract internal map names into constants
Date:   Fri, 13 Dec 2019 15:51:41 -0800
Message-ID: <20191213235144.3063354-2-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191213235144.3063354-1-andriin@fb.com>
References: <20191213235144.3063354-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 suspectscore=9 mlxscore=0
 mlxlogscore=844 phishscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912130165
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
index 8388f8321170..5800ea0ed33e 100644
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
@@ -1681,10 +1685,10 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
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
@@ -1714,7 +1718,8 @@ static int bpf_object__elf_collect(struct bpf_object *obj)
 
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

