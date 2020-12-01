Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0FF2CAF6C
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403782AbgLAWAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:00:41 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:11266 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390785AbgLAWAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:00:00 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1Lnqxt027031
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=1TNJesfl1oxuKQnrfRZjkj4tO+Qz4V0StDL2BbNRsq0=;
 b=HiSMpzhi6h9cU7Sk0EyI5McYPmh7YpTYdztoGCHG4Gnl/jmYUCO58fvA0bE0dBYyqb6P
 /OCVmbQ9rNqjQNXnl3gz4Z28bQQDrY13ANvafqv3+CbBesM6Tkf87V8kGLWRArl2SA/M
 rs9+nTpJ28NcHr+/xkNMonEeqNXBjxHWU18= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355vfk0t9y-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:18 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:16 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id AAD5019702CC; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 23/34] bpf: eliminate rlimit-based memory accounting for hashtab maps
Date:   Tue, 1 Dec 2020 13:58:49 -0800
Message-ID: <20201201215900.3569844-24-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=871 malwarescore=0 spamscore=0 suspectscore=38 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for hashtab maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/hashtab.c | 19 +------------------
 1 file changed, 1 insertion(+), 18 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index bf70fb3ed9c1..fe7a0733a63a 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -443,7 +443,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr =
*attr)
 	bool prealloc =3D !(attr->map_flags & BPF_F_NO_PREALLOC);
 	struct bpf_htab *htab;
 	int err, i;
-	u64 cost;
=20
 	htab =3D kzalloc(sizeof(*htab), GFP_USER | __GFP_ACCOUNT);
 	if (!htab)
@@ -481,26 +480,12 @@ static struct bpf_map *htab_map_alloc(union bpf_att=
r *attr)
 	    htab->n_buckets > U32_MAX / sizeof(struct bucket))
 		goto free_htab;
=20
-	cost =3D (u64) htab->n_buckets * sizeof(struct bucket) +
-	       (u64) htab->elem_size * htab->map.max_entries;
-
-	if (percpu)
-		cost +=3D (u64) round_up(htab->map.value_size, 8) *
-			num_possible_cpus() * htab->map.max_entries;
-	else
-	       cost +=3D (u64) htab->elem_size * num_possible_cpus();
-
-	/* if map size is larger than memlock limit, reject it */
-	err =3D bpf_map_charge_init(&htab->map.memory, cost);
-	if (err)
-		goto free_htab;
-
 	err =3D -ENOMEM;
 	htab->buckets =3D bpf_map_area_alloc(htab->n_buckets *
 					   sizeof(struct bucket),
 					   htab->map.numa_node);
 	if (!htab->buckets)
-		goto free_charge;
+		goto free_htab;
=20
 	for (i =3D 0; i < HASHTAB_MAP_LOCK_COUNT; i++) {
 		htab->map_locked[i] =3D bpf_map_alloc_percpu(&htab->map,
@@ -541,8 +526,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr =
*attr)
 	for (i =3D 0; i < HASHTAB_MAP_LOCK_COUNT; i++)
 		free_percpu(htab->map_locked[i]);
 	bpf_map_area_free(htab->buckets);
-free_charge:
-	bpf_map_charge_finish(&htab->map.memory);
 free_htab:
 	lockdep_unregister_key(&htab->lockdep_key);
 	kfree(htab);
--=20
2.26.2

