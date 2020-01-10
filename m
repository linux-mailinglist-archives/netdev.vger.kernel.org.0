Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 273611365DF
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 04:43:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731169AbgAJDnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 22:43:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6644 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731156AbgAJDnD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 22:43:03 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00A3gFT3030459
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 19:43:01 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=WMQdM3Yc1ZLVoIH2D7ePm3eIluLs6r/rpw4ZG5y8Y1Y=;
 b=kVhyK5rYmmfybZHv0lD+oeychFqbIVjoc3oOYLhCe6ALK2rQODEw8AwGqgn/sW4Vo21M
 qRa/J2ATu57lWNgTYTCAYG9+QMv7NzdRBANZNPqJdyp6+XL+DYYltwp/In+NSBc/rF/k
 S2y13WdNiD2gT55qukmny2ggg+7a4bEsjwc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2xdrhwyaab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 19:43:01 -0800
Received: from intmgw005.03.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 9 Jan 2020 19:43:01 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id C98E32EC1652; Thu,  9 Jan 2020 19:42:55 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>, <kafai@fb.com>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next] libbpf: make bpf_map order and indices stable
Date:   Thu, 9 Jan 2020 19:42:46 -0800
Message-ID: <20200110034247.1220142-1-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-09_06:2020-01-09,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 suspectscore=8
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100030
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, libbpf re-sorts bpf_map structs after all the maps are added and
initialized, which might change their relative order and invalidate any
bpf_map pointer or index taken before that. This is inconvenient and
error-prone. For instance, it can cause .kconfig map index to point to a wrong
map.

Furthermore, libbpf itself doesn't rely on any specific ordering of bpf_maps,
so it's just an unnecessary complication right now. This patch drops sorting
of maps and makes their relative positions fixed. If efficient index is ever
needed, it's better to have a separate array of pointers as a search index,
instead of reordering bpf_map struct in-place. This will be less error-prone
and will allow multiple independent orderings, if necessary (e.g., either by
section index or by name).

Fixes: 166750bc1dd2 ("libbpf: Support libbpf-provided extern variables")
Reported-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/lib/bpf/libbpf.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 35a4422ef655..ee2620b2aa55 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -1123,16 +1123,6 @@ bpf_object__init_kversion(struct bpf_object *obj, void *data, size_t size)
 	return 0;
 }
 
-static int compare_bpf_map(const void *_a, const void *_b)
-{
-	const struct bpf_map *a = _a;
-	const struct bpf_map *b = _b;
-
-	if (a->sec_idx != b->sec_idx)
-		return a->sec_idx - b->sec_idx;
-	return a->sec_offset - b->sec_offset;
-}
-
 static bool bpf_map_type__is_map_in_map(enum bpf_map_type type)
 {
 	if (type == BPF_MAP_TYPE_ARRAY_OF_MAPS ||
@@ -2196,10 +2186,6 @@ static int bpf_object__init_maps(struct bpf_object *obj,
 	if (err)
 		return err;
 
-	if (obj->nr_maps) {
-		qsort(obj->maps, obj->nr_maps, sizeof(obj->maps[0]),
-		      compare_bpf_map);
-	}
 	return 0;
 }
 
-- 
2.17.1

