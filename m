Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2D722B577C
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbgKQC5x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:57:53 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44674 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726881AbgKQCzl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:55:41 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH2nwNe020830
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=IyuiulO53PMtZqC2mFSdmwUnaE6dUMcKJTWo694qzRI=;
 b=Rlj7gYSvP/gsnhIMtnoMdvZnlKNPauYExXwz9H7a5pym5NtiKyNp2l2ZOJialmJSXFEy
 KFFeUqTpwEWKmg1GH/pTBTcRkQGe8i454zU9U4FY6fqFjXNfFCYn41ePV8AEqaoaRfNA
 AI7+nPeJFQixudhaBatUx/JnziI7fvpeV2Q= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34tdmrucrn-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:40 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 18:55:39 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id E109EC5F7D6; Mon, 16 Nov 2020 18:55:33 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH v6 12/34] bpf: refine memcg-based memory accounting for hashtab maps
Date:   Mon, 16 Nov 2020 18:55:07 -0800
Message-ID: <20201117025529.1034387-13-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
References: <20201117025529.1034387-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 lowpriorityscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 suspectscore=38 adultscore=0 phishscore=0 mlxlogscore=945 spamscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include percpu objects and the size of map metadata into the
accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
---
 kernel/bpf/hashtab.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index ec46266aaf1c..d1fa61ab7c76 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -289,10 +289,11 @@ static int prealloc_init(struct bpf_htab *htab)
 		goto skip_percpu_elems;
=20
 	for (i =3D 0; i < num_entries; i++) {
+		const gfp_t gfp =3D GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT;
 		u32 size =3D round_up(htab->map.value_size, 8);
 		void __percpu *pptr;
=20
-		pptr =3D __alloc_percpu_gfp(size, 8, GFP_USER | __GFP_NOWARN);
+		pptr =3D __alloc_percpu_gfp(size, 8, gfp);
 		if (!pptr)
 			goto free_elems;
 		htab_elem_set_ptr(get_htab_elem(htab, i), htab->map.key_size,
@@ -347,7 +348,7 @@ static int alloc_extra_elems(struct bpf_htab *htab)
 	int cpu;
=20
 	pptr =3D __alloc_percpu_gfp(sizeof(struct htab_elem *), 8,
-				  GFP_USER | __GFP_NOWARN);
+				  GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
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
@@ -892,6 +893,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_h=
tab *htab, void *key,
 					 bool percpu, bool onallcpus,
 					 struct htab_elem *old_elem)
 {
+	const gfp_t gfp =3D GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT;
 	u32 size =3D htab->map.value_size;
 	bool prealloc =3D htab_is_prealloc(htab);
 	struct htab_elem *l_new, **pl_new;
@@ -925,8 +927,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_h=
tab *htab, void *key,
 				l_new =3D ERR_PTR(-E2BIG);
 				goto dec_count;
 			}
-		l_new =3D kmalloc_node(htab->elem_size, GFP_ATOMIC | __GFP_NOWARN,
-				     htab->map.numa_node);
+		l_new =3D kmalloc_node(htab->elem_size, gfp, htab->map.numa_node);
 		if (!l_new) {
 			l_new =3D ERR_PTR(-ENOMEM);
 			goto dec_count;
@@ -942,8 +943,7 @@ static struct htab_elem *alloc_htab_elem(struct bpf_h=
tab *htab, void *key,
 			pptr =3D htab_elem_get_ptr(l_new, key_size);
 		} else {
 			/* alloc_percpu zero-fills */
-			pptr =3D __alloc_percpu_gfp(size, 8,
-						  GFP_ATOMIC | __GFP_NOWARN);
+			pptr =3D __alloc_percpu_gfp(size, 8, gfp);
 			if (!pptr) {
 				kfree(l_new);
 				l_new =3D ERR_PTR(-ENOMEM);
--=20
2.26.2

