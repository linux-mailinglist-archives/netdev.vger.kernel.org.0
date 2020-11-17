Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D8462B5755
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:59:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727006AbgKQCzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:55:43 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59060 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726930AbgKQCzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:55:42 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AH2nP3j026471
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=uV1QmpX+sHiIS6zZq39nGBhSS4LXhUFf7K6kAhpKOIY=;
 b=W3XKZWu3iqaBUPVURC7xzH9M/AAcc8musaDVGxpPbcP1pWedyvAndtjHzMmAdWFvj/q4
 Nmm2mA3ocvpq9vGKMUfn43oK5A2aW5lLqqI3rFSZ/c2UgZSs69b/STO5M5Wpiqrxu8op
 SAf7QK7ABXnnhAvANxNwMG7oz7XrDNszHcM= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34tbm4una8-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:41 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 18:55:37 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id EF4D6C5F7DC; Mon, 16 Nov 2020 18:55:33 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH v6 15/34] bpf: memcg-based memory accounting for bpf local storage maps
Date:   Mon, 16 Nov 2020 18:55:10 -0800
Message-ID: <20201117025529.1034387-16-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
References: <20201117025529.1034387-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 mlxlogscore=876 bulkscore=0 suspectscore=13 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170022
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Account memory used by bpf local storage maps:
per-socket and per-inode storages.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/bpf_local_storage.c | 7 ++++---
 net/core/bpf_sk_storage.c      | 2 +-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storag=
e.c
index 5d3a7af9ba9b..fd4f9ac1d042 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -67,7 +67,8 @@ bpf_selem_alloc(struct bpf_local_storage_map *smap, voi=
d *owner,
 	if (charge_mem && mem_charge(smap, owner, smap->elem_size))
 		return NULL;
=20
-	selem =3D kzalloc(smap->elem_size, GFP_ATOMIC | __GFP_NOWARN);
+	selem =3D kzalloc(smap->elem_size, GFP_ATOMIC | __GFP_NOWARN |
+			__GFP_ACCOUNT);
 	if (selem) {
 		if (value)
 			memcpy(SDATA(selem)->data, value, smap->map.value_size);
@@ -546,7 +547,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_a=
lloc(union bpf_attr *attr)
 	u64 cost;
 	int ret;
=20
-	smap =3D kzalloc(sizeof(*smap), GFP_USER | __GFP_NOWARN);
+	smap =3D kzalloc(sizeof(*smap), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT=
);
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
 	bpf_map_init_from_attr(&smap->map, attr);
@@ -564,7 +565,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_a=
lloc(union bpf_attr *attr)
 	}
=20
 	smap->buckets =3D kvcalloc(sizeof(*smap->buckets), nbuckets,
-				 GFP_USER | __GFP_NOWARN);
+				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!smap->buckets) {
 		bpf_map_charge_finish(&smap->map.memory);
 		kfree(smap);
diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index a32037daa933..3d80dee3a4aa 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -524,7 +524,7 @@ bpf_sk_storage_diag_alloc(const struct nlattr *nla_st=
gs)
 	}
=20
 	diag =3D kzalloc(sizeof(*diag) + sizeof(diag->maps[0]) * nr_maps,
-		       GFP_KERNEL);
+		       GFP_KERNEL_ACCOUNT);
 	if (!diag)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

