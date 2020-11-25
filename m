Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA4552C3742
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgKYDCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:02:22 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:31820 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727019AbgKYDBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:01:36 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AP2sdd3000440
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=mtIjSDYWWmw4Li7CA+9a5qUeSSopzyAJ8NyDIn/Z8ho=;
 b=KMVMtakvlWMG8zXpKGE6cNhoGoRzM0C9XrJHUyVmnCCa4qzX3L/2lZNawPUIzli4r+xI
 EStTw9NruHRBdri5wn3yoIwI2uJigKl2Da9UcbaWNHwAd8O7BGf45m/H2EwJuAqFh01Q
 h3zg5yA5e9kqi/e77zlUfuQ0M7jBx7t19xk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 351aqe0uns-7
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:34 -0800
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 19:01:32 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 17C4016A1895; Tue, 24 Nov 2020 19:01:22 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v8 10/34] bpf: memcg-based memory accounting for cgroup storage maps
Date:   Tue, 24 Nov 2020 19:00:55 -0800
Message-ID: <20201125030119.2864302-11-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201125030119.2864302-1-guro@fb.com>
References: <20201125030119.2864302-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_11:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 phishscore=0 mlxlogscore=999
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Account memory used by cgroup storage maps including metadata
structures.

Account the percpu memory for the percpu flavor of cgroup storage.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/local_storage.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/local_storage.c b/kernel/bpf/local_storage.c
index 571bb351ed3b..aae17d29538e 100644
--- a/kernel/bpf/local_storage.c
+++ b/kernel/bpf/local_storage.c
@@ -164,10 +164,10 @@ static int cgroup_storage_update_elem(struct bpf_ma=
p *map, void *key,
 		return 0;
 	}
=20
-	new =3D kmalloc_node(sizeof(struct bpf_storage_buffer) +
-			   map->value_size,
-			   __GFP_ZERO | GFP_ATOMIC | __GFP_NOWARN,
-			   map->numa_node);
+	new =3D bpf_map_kmalloc_node(map, sizeof(struct bpf_storage_buffer) +
+				   map->value_size, __GFP_ZERO | GFP_ATOMIC |
+				   __GFP_NOWARN | __GFP_ACCOUNT,
+				   map->numa_node);
 	if (!new)
 		return -ENOMEM;
=20
@@ -313,7 +313,7 @@ static struct bpf_map *cgroup_storage_map_alloc(union=
 bpf_attr *attr)
 		return ERR_PTR(ret);
=20
 	map =3D kmalloc_node(sizeof(struct bpf_cgroup_storage_map),
-			   __GFP_ZERO | GFP_USER, numa_node);
+			   __GFP_ZERO | GFP_USER | __GFP_ACCOUNT, numa_node);
 	if (!map) {
 		bpf_map_charge_finish(&mem);
 		return ERR_PTR(-ENOMEM);
@@ -496,9 +496,9 @@ static size_t bpf_cgroup_storage_calculate_size(struc=
t bpf_map *map, u32 *pages)
 struct bpf_cgroup_storage *bpf_cgroup_storage_alloc(struct bpf_prog *pro=
g,
 					enum bpf_cgroup_storage_type stype)
 {
+	const gfp_t gfp =3D __GFP_ZERO | GFP_USER | __GFP_ACCOUNT;
 	struct bpf_cgroup_storage *storage;
 	struct bpf_map *map;
-	gfp_t flags;
 	size_t size;
 	u32 pages;
=20
@@ -511,20 +511,18 @@ struct bpf_cgroup_storage *bpf_cgroup_storage_alloc=
(struct bpf_prog *prog,
 	if (bpf_map_charge_memlock(map, pages))
 		return ERR_PTR(-EPERM);
=20
-	storage =3D kmalloc_node(sizeof(struct bpf_cgroup_storage),
-			       __GFP_ZERO | GFP_USER, map->numa_node);
+	storage =3D kmalloc_node(sizeof(struct bpf_cgroup_storage), gfp,
+			       map->numa_node);
 	if (!storage)
 		goto enomem;
=20
-	flags =3D __GFP_ZERO | GFP_USER;
-
 	if (stype =3D=3D BPF_CGROUP_STORAGE_SHARED) {
-		storage->buf =3D kmalloc_node(size, flags, map->numa_node);
+		storage->buf =3D kmalloc_node(size, gfp, map->numa_node);
 		if (!storage->buf)
 			goto enomem;
 		check_and_init_map_lock(map, storage->buf->data);
 	} else {
-		storage->percpu_buf =3D __alloc_percpu_gfp(size, 8, flags);
+		storage->percpu_buf =3D __alloc_percpu_gfp(size, 8, gfp);
 		if (!storage->percpu_buf)
 			goto enomem;
 	}
--=20
2.26.2

