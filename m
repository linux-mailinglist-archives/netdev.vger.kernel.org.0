Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20FE12B99A4
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:44:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729470AbgKSRja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:39:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:1836 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729489AbgKSRiQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:38:16 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AJHTu35026463
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0Hg4Zqve8ZpzwnT8YgIaVKDVn2Ev9kRtYpqCQupY5Gw=;
 b=HJHhJmmhl1tYVsv376ofsNuIE7Kl+XZt/+xSNDqzI2zkEdJlk8WV7agpOywj58vopkkb
 2aaiE8FRMCD2cXfUqf8OZKhJe/wsL5PIwhBeTS9iRHmNIojiHPgMNCunXlBcTuxuRF7H
 9DFWslBjaS1sjmzaH+2Ly45kNH4TrfWLBNg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34wfdq70ae-17
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:15 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 09:38:04 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id D93CC145BD01; Thu, 19 Nov 2020 09:37:56 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v7 21/34] bpf: eliminate rlimit-based memory accounting for cgroup storage maps
Date:   Thu, 19 Nov 2020 09:37:41 -0800
Message-ID: <20201119173754.4125257-22-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119173754.4125257-1-guro@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=999 malwarescore=0 bulkscore=0 suspectscore=38
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011190125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for cgroup storage maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/local_storage.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index aae17d29538e..d7d4587415a6 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -287,8 +287,6 @@ static struct bpf_map *cgroup_storage_map_alloc(union=
 bpf_attr *attr)
 {
 	int numa_node =3D bpf_map_attr_numa_node(attr);
 	struct bpf_cgroup_storage_map *map;
-	struct bpf_map_memory mem;
-	int ret;
=20
 	if (attr->key_size !=3D sizeof(struct bpf_cgroup_storage_key) &&
 	    attr->key_size !=3D sizeof(__u64))
@@ -308,18 +306,10 @@ static struct bpf_map *cgroup_storage_map_alloc(uni=
on bpf_attr *attr)
 		/* max_entries is not used and enforced to be 0 */
 		return ERR_PTR(-EINVAL);
=20
-	ret =3D bpf_map_charge_init(&mem, sizeof(struct bpf_cgroup_storage_map)=
);
-	if (ret < 0)
-		return ERR_PTR(ret);
-
 	map =3D kmalloc_node(sizeof(struct bpf_cgroup_storage_map),
 			   __GFP_ZERO | GFP_USER | __GFP_ACCOUNT, numa_node);
-	if (!map) {
-		bpf_map_charge_finish(&mem);
+	if (!map)
 		return ERR_PTR(-ENOMEM);
-	}
-
-	bpf_map_charge_move(&map->map.memory, &mem);
=20
 	/* copy mandatory map attributes */
 	bpf_map_init_from_attr(&map->map, attr);
@@ -508,9 +498,6 @@ struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(s=
truct bpf_prog *prog,
=20
 	size =3D bpf_cgroup_storage_calculate_size(map, &pages);
=20
-	if (bpf_map_charge_memlock(map, pages))
-		return ERR_PTR(-EPERM);
-
 	storage =3D kmalloc_node(sizeof(struct bpf_cgroup_storage), gfp,
 			       map->numa_node);
 	if (!storage)
@@ -532,7 +519,6 @@ struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(s=
truct bpf_prog *prog,
 	return storage;
=20
 enomem:
-	bpf_map_uncharge_memlock(map, pages);
 	kfree(storage);
 	return ERR_PTR(-ENOMEM);
 }
@@ -559,16 +545,11 @@ void bpf_cgroup_storage_free(struct bpf_cgroup_stor=
age *storage)
 {
 	enum bpf_cgroup_storage_type stype;
 	struct bpf_map *map;
-	u32 pages;
=20
 	if (!storage)
 		return;
=20
 	map =3D &storage->map->map;
-
-	bpf_cgroup_storage_calculate_size(map, &pages);
-	bpf_map_uncharge_memlock(map, pages);
-
 	stype =3D cgroup_storage_type(map);
 	if (stype =3D=3D BPF_CGROUP_STORAGE_SHARED)
 		call_rcu(&storage->rcu, free_shared_cgroup_storage_rcu);
--=20
2.26.2

