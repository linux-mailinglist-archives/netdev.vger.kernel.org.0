Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46C7E2B997E
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729495AbgKSRiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:38:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46156 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729470AbgKSRiO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:38:14 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJHUjCE024652
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=p7AL5MEv67PXm8tsjFCWY0aTmPqyKn82sJgTxCQ6mgI=;
 b=czAlBR2vM2dQP3q/NoridqeoLQW8BIbUM3ysHsYG+rBypraiHA4gdZITYTJ88k86sslq
 fiYhQ/wKgAVnCUNykno6nCEHlrEkESTBDMOUafZ1N/C2s4Z0eMOr9MPeQY2rdn1RALqs
 m8QuP41VknuR6RrLEaltrd/2b/6E7h4qnbo= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34wgckp8ya-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:14 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 09:38:02 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id BBA30145BCF5; Thu, 19 Nov 2020 09:37:56 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v7 15/34] bpf: memcg-based memory accounting for bpf local storage maps
Date:   Thu, 19 Nov 2020 09:37:35 -0800
Message-ID: <20201119173754.4125257-16-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119173754.4125257-1-guro@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0 mlxscore=0
 suspectscore=13 clxscore=1015 adultscore=0 spamscore=0 impostorscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=792
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Account memory used by bpf local storage maps:
per-socket, per-inode and per-task storages.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/bpf_local_storage.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storag=
e.c
index 5d3a7af9ba9b..abd0ea385274 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -67,7 +67,9 @@ bpf_selem_alloc(struct bpf_local_storage_map *smap, voi=
d *owner,
 	if (charge_mem && mem_charge(smap, owner, smap->elem_size))
 		return NULL;
=20
-	selem =3D kzalloc(smap->elem_size, GFP_ATOMIC | __GFP_NOWARN);
+	selem =3D bpf_map_kmalloc_node(&smap->map, smap->elem_size,
+				     GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO |
+				     __GFP_ACCOUNT, NUMA_NO_NODE);
 	if (selem) {
 		if (value)
 			memcpy(SDATA(selem)->data, value, smap->map.value_size);
@@ -264,7 +266,9 @@ int bpf_local_storage_alloc(void *owner,
 	if (err)
 		return err;
=20
-	storage =3D kzalloc(sizeof(*storage), GFP_ATOMIC | __GFP_NOWARN);
+	storage =3D bpf_map_kmalloc_node(&smap->map, sizeof(*storage),
+				       GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO |
+				       __GFP_ACCOUNT, NUMA_NO_NODE);
 	if (!storage) {
 		err =3D -ENOMEM;
 		goto uncharge;
@@ -546,7 +550,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_a=
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
@@ -564,7 +568,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_a=
lloc(union bpf_attr *attr)
 	}
=20
 	smap->buckets =3D kvcalloc(sizeof(*smap->buckets), nbuckets,
-				 GFP_USER | __GFP_NOWARN);
+				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!smap->buckets) {
 		bpf_map_charge_finish(&smap->map.memory);
 		kfree(smap);
--=20
2.26.2

