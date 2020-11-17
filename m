Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1F0D2B577B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727920AbgKQC5w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:57:52 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21176 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726904AbgKQCzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:55:42 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH2nTpI031204
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fShRlN12PteWYDnw3TVdgXGeGVHnDgFpbsGeNZoyKzs=;
 b=jXvXF5rxKJRv+KRxVw2iDMf9cZPULFEWH3ik/xn57izJINJ0L/jknqEJFTXiFreNMCLK
 yU0FsteLuXFLSZZpNp7rcCOdfVYd/d/Fy5UgxXITjTg9qkRo1hH2Pjc9QI6Tbg1mPFJb
 EIDpkk80ZVcB4Z8DnXRo9NsS6+MPqUnZmOg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34uwyg2pnp-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:41 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 18:55:37 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id CE4C0C5F7CE; Mon, 16 Nov 2020 18:55:33 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH v6 08/34] bpf: refine memcg-based memory accounting for arraymap maps
Date:   Mon, 16 Nov 2020 18:55:03 -0800
Message-ID: <20201117025529.1034387-9-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
References: <20201117025529.1034387-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=862 priorityscore=1501 clxscore=1015 mlxscore=0
 impostorscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0 spamscore=0
 phishscore=0 suspectscore=38 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include percpu arrays and auxiliary data into the memcg-based memory
accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/arraymap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index c6c81eceb68f..92b650123c22 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -30,12 +30,12 @@ static void bpf_array_free_percpu(struct bpf_array *a=
rray)
=20
 static int bpf_array_alloc_percpu(struct bpf_array *array)
 {
+	const gfp_t gfp =3D GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT;
 	void __percpu *ptr;
 	int i;
=20
 	for (i =3D 0; i < array->map.max_entries; i++) {
-		ptr =3D __alloc_percpu_gfp(array->elem_size, 8,
-					 GFP_USER | __GFP_NOWARN);
+		ptr =3D __alloc_percpu_gfp(array->elem_size, 8, gfp);
 		if (!ptr) {
 			bpf_array_free_percpu(array);
 			return -ENOMEM;
@@ -1018,7 +1018,7 @@ static struct bpf_map *prog_array_map_alloc(union b=
pf_attr *attr)
 	struct bpf_array_aux *aux;
 	struct bpf_map *map;
=20
-	aux =3D kzalloc(sizeof(*aux), GFP_KERNEL);
+	aux =3D kzalloc(sizeof(*aux), GFP_KERNEL_ACCOUNT);
 	if (!aux)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

