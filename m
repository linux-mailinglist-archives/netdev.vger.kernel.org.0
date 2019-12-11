Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B3A11A4B8
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 07:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbfLKGuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 01:50:39 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32758 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725800AbfLKGuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 01:50:39 -0500
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBB6ob2v028889
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 22:50:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=3QFm4hGtsLP7Bvs82g3Rl4rViw0PjNvbSI+gFrrxaIQ=;
 b=MvYa+DMhmVcgJrPQXQ59LbqXYvWf0xm/v/ZDWSHRw58CBsiVvTPx15uGDlCcIMxM4Dti
 oWvl0+V0WlwAeZQGQ3wGJpWIe+fEQAu68bZ43Osct0Sddj/Hfunpr/Ib48NRCIOOgC1f
 kj+Ucase/AZysUiaaEPVU1C/mNgACyp+A9c= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2wtk8whwsy-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 22:50:37 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Tue, 10 Dec 2019 22:50:10 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 6E9342EC194D; Tue, 10 Dec 2019 22:50:10 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH v2 bpf-next 2/3] bpftool: generate externs datasec in BPF skeleton
Date:   Tue, 10 Dec 2019 22:50:01 -0800
Message-ID: <20191211065002.2074074-3-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191211065002.2074074-1-andriin@fb.com>
References: <20191211065002.2074074-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-11_01:2019-12-10,2019-12-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 suspectscore=8 impostorscore=0 malwarescore=0
 phishscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912110058
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
index ea2cb251af94..9b8b9c228c85 100644
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
index 36b82463b467..7f3c1306faee 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -7392,7 +7392,8 @@ int bpf_object__open_skeleton(struct bpf_object_skeleton *s,
 			return -ESRCH;
 		}
 
-		if (mmaped)
+		/* externs shouldn't be pre-setup from user code */
+		if (mmaped && (*map)->libbpf_type != LIBBPF_MAP_EXTERN)
 			*mmaped = (*map)->mmaped;
 	}
 
@@ -7425,7 +7426,6 @@ int bpf_object__load_skeleton(struct bpf_object_skeleton *s)
 		size_t mmap_sz = bpf_map_mmap_sz(map);
 		int prot, map_fd = bpf_map__fd(map);
 		void **mmaped = s->maps[i].mmaped;
-		void *remapped;
 
 		if (!mmaped)
 			continue;
@@ -7450,9 +7450,9 @@ int bpf_object__load_skeleton(struct bpf_object_skeleton *s)
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

