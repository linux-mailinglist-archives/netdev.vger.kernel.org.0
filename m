Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 884132C375A
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728419AbgKYDDG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:03:06 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:21952 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726039AbgKYDBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:01:31 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AP2sxkd004055
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=lrse4+nNFUKe7VgNSIyyWmMRrmZU02LZX7oRvPXq/Pw=;
 b=hnjlZipI17tkIWMdf5bFsFN68lJzJgULtxJs9hvcqQDrLzw5deagNfNSBCjLly1AVtRM
 JVD73JW3m7dfLYsPz60BurNQCExR/1iZJk968SceLNuFFGas5MPJTPfUk0mZ9gj4kRH4
 9QP7LcS3ri9vWMhJ0rz/wXrKfgleqah2UdQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3516xbsv6p-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:30 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 19:01:27 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 54DE916A18AF; Tue, 24 Nov 2020 19:01:22 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v8 23/34] bpf: eliminate rlimit-based memory accounting for hashtab maps
Date:   Tue, 24 Nov 2020 19:01:08 -0800
Message-ID: <20201125030119.2864302-24-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201125030119.2864302-1-guro@fb.com>
References: <20201125030119.2864302-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_11:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=862
 clxscore=1015 bulkscore=0 spamscore=0 suspectscore=38 impostorscore=0
 phishscore=0 malwarescore=0 adultscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250018
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
index 2b8bbdbec872..eed12427ddd5 100644
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
 		htab->map_locked[i] =3D __alloc_percpu_gfp(sizeof(int),
@@ -539,8 +524,6 @@ static struct bpf_map *htab_map_alloc(union bpf_attr =
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

