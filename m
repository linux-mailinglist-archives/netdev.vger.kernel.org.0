Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD8811EFCA
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 02:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfLNBrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 20:47:25 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54354 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726769AbfLNBrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Dec 2019 20:47:24 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBE1j69s017025
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:47:23 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=x/ft1qXOaG4vbwkOlFcjZBPsiOZZ6GJQmpe9ltjq3gU=;
 b=TxZeYw5yFWV69mny5Fz4W3O03GnWkDrumrAriI+m3Jo56vhmaWOvyGGdS4MzhTNTwNl9
 tn6WS7z/yISZvwgjHjNoG6WVgsj/IYukgL9tRxjfHVl3GUwIGSNQKNvf+Pf6psGuBZVu
 1aKFk0yXWWDA2SSW/lOGQI5YzuoqavnxiwE= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvdw4j96r-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 13 Dec 2019 17:47:23 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 13 Dec 2019 17:47:22 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id D66272EC1D7C; Fri, 13 Dec 2019 17:47:18 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v4 bpf-next 3/4] bpftool: generate externs datasec in BPF skeleton
Date:   Fri, 13 Dec 2019 17:47:09 -0800
Message-ID: <20191214014710.3449601-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191214014710.3449601-1-andriin@fb.com>
References: <20191214014710.3449601-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-13_09:2019-12-13,2019-12-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 impostorscore=0
 suspectscore=8 mlxscore=0 mlxlogscore=999 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140007
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for generation of mmap()-ed read-only view of libbpf-provided
extern variables. As externs are not supposed to be provided by user code
(that's what .data, .bss, and .rodata is for), don't mmap() it initially. Only
after skeleton load is performed, map .extern contents as read-only memory.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/bpf/bpftool/gen.c |  4 ++++
 tools/lib/bpf/libbpf.c  | 10 +++++-----
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
index 7379dae35dca..a07c80429c7a 100644
--- a/tools/bpf/bpftool/gen.c
+++ b/tools/bpf/bpftool/gen.c
@@ -82,6 +82,8 @@ static const char *get_map_ident(const struct bpf_map *map)
 		return "rodata";
 	else if (str_has_suffix(name, ".bss"))
 		return "bss";
+	else if (str_has_suffix(name, ".extern"))
+		return "externs"; /* extern is a C keyword */
 	else
 		return NULL;
 }
@@ -109,6 +111,8 @@ static int codegen_datasec_def(struct bpf_object *obj,
 		sec_ident = "bss";
 	else if (strcmp(sec_name, ".rodata") == 0)
 		sec_ident = "rodata";
+	else if (strcmp(sec_name, ".extern") == 0)
+		sec_ident = "externs"; /* extern is a C keyword */
 	else
 		return 0;
 
diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 26144706ba0b..c9f90bfd2f0d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7472,7 +7472,8 @@ int bpf_object__open_skeleton(struct bpf_object_skeleton *s,
 			return -ESRCH;
 		}
 
-		if (mmaped)
+		/* externs shouldn't be pre-setup from user code */
+		if (mmaped && (*map)->libbpf_type != LIBBPF_MAP_EXTERN)
 			*mmaped = (*map)->mmaped;
 	}
 
@@ -7505,7 +7506,6 @@ int bpf_object__load_skeleton(struct bpf_object_skeleton *s)
 		size_t mmap_sz = bpf_map_mmap_sz(map);
 		int prot, map_fd = bpf_map__fd(map);
 		void **mmaped = s->maps[i].mmaped;
-		void *remapped;
 
 		if (!mmaped)
 			continue;
@@ -7530,9 +7530,9 @@ int bpf_object__load_skeleton(struct bpf_object_skeleton *s)
 		 * as per normal clean up procedure, so we don't need to worry
 		 * about it from skeleton's clean up perspective.
 		 */
-		remapped = mmap(*mmaped, mmap_sz, prot, MAP_SHARED | MAP_FIXED,
-				map_fd, 0);
-		if (remapped == MAP_FAILED) {
+		*mmaped = mmap(map->mmaped, mmap_sz, prot,
+				MAP_SHARED | MAP_FIXED, map_fd, 0);
+		if (*mmaped == MAP_FAILED) {
 			err = -errno;
 			*mmaped = NULL;
 			pr_warn("failed to re-mmap() map '%s': %d\n",
-- 
2.17.1

