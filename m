Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F8F62C375C
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728456AbgKYDDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:03:07 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22114 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727391AbgKYDBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:01:31 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AP2rZcC008344
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=fShRlN12PteWYDnw3TVdgXGeGVHnDgFpbsGeNZoyKzs=;
 b=f0fNu2/D7ZcrZ6ZLmlNoD4qXf3OYZ5W7r5xru/YXdzwt73+YaBmXnHxuYt7TfwtxKYqM
 Q6RikTTbQlCNGDhTb8NshmxVz1EiPZJ+4Kgz2WJLACEYgoKZTIni3U8Le174/W9yhlt+
 8T66UnTqFP2GYHEnZrdKPMbOxhcWjqrlaXM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 351dspg6yr-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:30 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 19:01:26 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 0E29A16A1891; Tue, 24 Nov 2020 19:01:22 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v8 08/34] bpf: refine memcg-based memory accounting for arraymap maps
Date:   Tue, 24 Nov 2020 19:00:53 -0800
Message-ID: <20201125030119.2864302-9-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201125030119.2864302-1-guro@fb.com>
References: <20201125030119.2864302-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_11:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 adultscore=0
 malwarescore=0 suspectscore=38 spamscore=0 mlxscore=0 impostorscore=0
 lowpriorityscore=0 clxscore=1015 mlxlogscore=902 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250018
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

