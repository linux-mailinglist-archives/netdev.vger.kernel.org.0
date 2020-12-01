Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDC582CAF7E
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404111AbgLAWBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:01:16 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:36604 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390458AbgLAV76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 16:59:58 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LntCD020479
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=ES3cWPYvClXDzGb13CZW5kfbgQXGFlr+XCV/6rkCyXM=;
 b=bUldmS0OPogb/kApFM59RTvomlkYCXI3+U7HE7A8OctOJT7G4EQqVW3Xar59XkQW2oSl
 2hJxVj+Amu62vg4SAJXcrbHzpWISUY4eNpucci1SfFP4eTKBIReITcOczWOAHjwW6feu
 EnZW7EPm1JizFKjgKTeNombKFDYH8sE26/8= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355t7y1xaa-18
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:17 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:11 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 8460719702BC; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 15/34] bpf: memcg-based memory accounting for bpf local storage maps
Date:   Tue, 1 Dec 2020 13:58:41 -0800
Message-ID: <20201201215900.3569844-16-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=767 phishscore=0
 mlxscore=0 suspectscore=13 impostorscore=0 spamscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Account memory used by bpf local storage maps:
per-socket, per-inode and per-task storages.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/bpf_local_storage.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storag=
e.c
index 5d3a7af9ba9b..023a3eaa4d74 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -67,7 +67,8 @@ bpf_selem_alloc(struct bpf_local_storage_map *smap, voi=
d *owner,
 	if (charge_mem && mem_charge(smap, owner, smap->elem_size))
 		return NULL;
=20
-	selem =3D kzalloc(smap->elem_size, GFP_ATOMIC | __GFP_NOWARN);
+	selem =3D bpf_map_kzalloc(&smap->map, smap->elem_size,
+				GFP_ATOMIC | __GFP_NOWARN);
 	if (selem) {
 		if (value)
 			memcpy(SDATA(selem)->data, value, smap->map.value_size);
@@ -264,7 +265,8 @@ int bpf_local_storage_alloc(void *owner,
 	if (err)
 		return err;
=20
-	storage =3D kzalloc(sizeof(*storage), GFP_ATOMIC | __GFP_NOWARN);
+	storage =3D bpf_map_kzalloc(&smap->map, sizeof(*storage),
+				  GFP_ATOMIC | __GFP_NOWARN);
 	if (!storage) {
 		err =3D -ENOMEM;
 		goto uncharge;
@@ -546,7 +548,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_a=
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
@@ -564,7 +566,7 @@ struct bpf_local_storage_map *bpf_local_storage_map_a=
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

