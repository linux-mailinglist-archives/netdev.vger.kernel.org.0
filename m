Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91B712B576F
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgKQC5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:57:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:56122 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727031AbgKQCzo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:55:44 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AH2qXhI012988
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=EbPWI8uXU5DI+ycWdCdtFEh/IbfL8Ny2eiIpejWlJl0=;
 b=TB/p45IMO35CO9NmXgcSyl9RSkRqKz4hWB+OWASm2/GY8yjFLCLNp/JGu9g3okKcFzda
 kZ9VSA6JrvCeQ+DzfAWEwEhaSya8id0rlstExXw9UoZfiDyzYB3XUt6pqejvrDAtm7Xo
 njtjqmyY2XDqi31pTvYp3F5wLGzYyqnkKW0= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0001303.ppops.net with ESMTP id 34tbssbns9-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:43 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 18:55:37 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 26461C5F7EE; Mon, 16 Nov 2020 18:55:34 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH v6 23/34] bpf: eliminate rlimit-based memory accounting for hashtab maps
Date:   Mon, 16 Nov 2020 18:55:18 -0800
Message-ID: <20201117025529.1034387-24-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
References: <20201117025529.1034387-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 suspectscore=38 impostorscore=0 adultscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 spamscore=0 bulkscore=0 mlxlogscore=827
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170023
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
index d1fa61ab7c76..2ec635b76b33 100644
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

