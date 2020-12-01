Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65E372CAF75
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403952AbgLAWA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:00:57 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31516 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390698AbgLAV77 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:59:59 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LonQn025407
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=aUxDr9vXwVIRYb58TUOfA1eGmm/KQJyaXGG8Oo9BCxk=;
 b=OwV7/NEr5wCS7s759kSO2Omsi8xNOuimiFUcE9z7XC4mv0FMqwjTEuZwFVjtEc2/YtL8
 ++wQiSOUTNPLCS/DLtymKKbMoO6jITrAHd1NMRS4B1+EhocDgrXCB5tN2Rf2ykuSpe75
 v6oNAYIikxcnzdmeO162ioxNKbuBx/oinpY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 3547g8q51t-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:18 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:15 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 7645B19702B6; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 12/34] bpf: refine memcg-based memory accounting for hashtab maps
Date:   Tue, 1 Dec 2020 13:58:38 -0800
Message-ID: <20201201215900.3569844-13-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 clxscore=1015
 spamscore=0 suspectscore=38 phishscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 malwarescore=0 mlxlogscore=816 priorityscore=1501
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include percpu objects and the size of map metadata into the
accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/hashtab.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index ec46266aaf1c..bf70fb3ed9c1 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -292,7 +292,8 @@ static int prealloc_init(struct bpf_htab *htab)
 		u32 size =3D round_up(htab->map.value_size, 8);
 		void __percpu *pptr;
=20
-		pptr =3D __alloc_percpu_gfp(size, 8, GFP_USER | __GFP_NOWARN);
+		pptr =3D bpf_map_alloc_percpu(&htab->map, size, 8,
+					    GFP_USER | __GFP_NOWARN);
 		if (!pptr)
 			goto free_elems;
 		htab_elem_set_ptr(get_htab_elem(htab, i), htab->map.key_size,
@@ -346,8 +347,8 @@ static int alloc_extra_elems(struct bpf_htab *htab)
 	struct pcpu_freelist_node *l;
 	int cpu;
=20
-	pptr =3D __alloc_percpu_gfp(sizeof(struct htab_elem *), 8,
-				  GFP_USER | __GFP_NOWARN);
+	pptr =3D bpf_map_alloc_percpu(&htab->map, sizeof(struct htab_elem *), 8=
,
+				    GFP_USER | __GFP_NOWARN);
 	if (!pptr)
 		return -ENOMEM;
=20
@@ -444,7 +445,7 @@ static struct bpf_map *htab_map_alloc(union bpf_attr =
*attr)
 	int err, i;
 	u64 cost;
=20
-	htab =3D kzalloc(sizeof(*htab), GFP_USER);
+	htab =3D kzalloc(sizeof(*htab), GFP_USER | __GFP_ACCOUNT);
 	if (!htab)
 		return ERR_PTR(-ENOMEM);
=20
@@ -502,8 +503,10 @@ static struct bpf_map *htab_map_alloc(union bpf_attr=
 *attr)
 		goto free_charge;
=20
 	for (i =3D 0; i < HASHTAB_MAP_LOCK_COUNT; i++) {
-		htab->map_locked[i] =3D __alloc_percpu_gfp(sizeof(int),
-							 sizeof(int), GFP_USER);
+		htab->map_locked[i] =3D bpf_map_alloc_percpu(&htab->map,
+							   sizeof(int),
+							   sizeof(int),
+							   GFP_USER);
 		if (!htab->map_locked[i])
 			goto free_map_locked;
 	}
@@ -925,8 +928,9 @@ static struct htab_elem *alloc_htab_elem(struct bpf_h=
tab *htab, void *key,
 				l_new =3D ERR_PTR(-E2BIG);
 				goto dec_count;
 			}
-		l_new =3D kmalloc_node(htab->elem_size, GFP_ATOMIC | __GFP_NOWARN,
-				     htab->map.numa_node);
+		l_new =3D bpf_map_kmalloc_node(&htab->map, htab->elem_size,
+					     GFP_ATOMIC | __GFP_NOWARN,
+					     htab->map.numa_node);
 		if (!l_new) {
 			l_new =3D ERR_PTR(-ENOMEM);
 			goto dec_count;
@@ -942,8 +946,8 @@ static struct htab_elem *alloc_htab_elem(struct bpf_h=
tab *htab, void *key,
 			pptr =3D htab_elem_get_ptr(l_new, key_size);
 		} else {
 			/* alloc_percpu zero-fills */
-			pptr =3D __alloc_percpu_gfp(size, 8,
-						  GFP_ATOMIC | __GFP_NOWARN);
+			pptr =3D bpf_map_alloc_percpu(&htab->map, size, 8,
+						    GFP_ATOMIC | __GFP_NOWARN);
 			if (!pptr) {
 				kfree(l_new);
 				l_new =3D ERR_PTR(-ENOMEM);
--=20
2.26.2

