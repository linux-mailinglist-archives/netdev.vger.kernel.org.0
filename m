Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C99422F85A
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbgG0SsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:48:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5196 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731643AbgG0SpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:45:21 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06RIe5To024050
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=yZVcgIKOzM2xyUhwAi8wclQ8zsNO09LHWnp3/VpJR04=;
 b=nTyh+uP+hfW854C5Yf2vCD/aDe25wJ5CgxdrkCRKqbZPUFNNq5Ik427IQDpHWvMG9d8o
 YpMrUknhZnsUj/3MhKx49Kyza9lJF+/hBLkn0k706sgTdXS46G5u0bnEAM5A3gaLgxqG
 +rxTsnY26hXNwynoJvroidrf9go2bG9oSvM= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 32gg7xrhh5-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:19 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 11:45:16 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id DE4341DAFE93; Mon, 27 Jul 2020 11:45:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v2 17/35] bpf: eliminate rlimit-based memory accounting for devmap maps
Date:   Mon, 27 Jul 2020 11:44:48 -0700
Message-ID: <20200727184506.2279656-18-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727184506.2279656-1-guro@fb.com>
References: <20200727184506.2279656-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_13:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=38
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=971 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for devmap maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/devmap.c | 18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 05bf93088063..8148c7260a54 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -109,8 +109,6 @@ static inline struct hlist_head *dev_map_index_hash(s=
truct bpf_dtab *dtab,
 static int dev_map_init_map(struct bpf_dtab *dtab, union bpf_attr *attr)
 {
 	u32 valsize =3D attr->value_size;
-	u64 cost =3D 0;
-	int err;
=20
 	/* check sanity of attributes. 2 value sizes supported:
 	 * 4 bytes: ifindex
@@ -135,21 +133,13 @@ static int dev_map_init_map(struct bpf_dtab *dtab, =
union bpf_attr *attr)
=20
 		if (!dtab->n_buckets) /* Overflow check */
 			return -EINVAL;
-		cost +=3D (u64) sizeof(struct hlist_head) * dtab->n_buckets;
-	} else {
-		cost +=3D (u64) dtab->map.max_entries * sizeof(struct bpf_dtab_netdev =
*);
 	}
=20
-	/* if map size is larger than memlock limit, reject it */
-	err =3D bpf_map_charge_init(&dtab->map.memory, cost);
-	if (err)
-		return -EINVAL;
-
 	if (attr->map_type =3D=3D BPF_MAP_TYPE_DEVMAP_HASH) {
 		dtab->dev_index_head =3D dev_map_create_hash(dtab->n_buckets,
 							   dtab->map.numa_node);
 		if (!dtab->dev_index_head)
-			goto free_charge;
+			return -ENOMEM;
=20
 		spin_lock_init(&dtab->index_lock);
 	} else {
@@ -157,14 +147,10 @@ static int dev_map_init_map(struct bpf_dtab *dtab, =
union bpf_attr *attr)
 						      sizeof(struct bpf_dtab_netdev *),
 						      dtab->map.numa_node);
 		if (!dtab->netdev_map)
-			goto free_charge;
+			return -ENOMEM;
 	}
=20
 	return 0;
-
-free_charge:
-	bpf_map_charge_finish(&dtab->map.memory);
-	return -ENOMEM;
 }
=20
 static struct bpf_map *dev_map_alloc(union bpf_attr *attr)
--=20
2.26.2

