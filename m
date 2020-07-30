Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43DDC233A9B
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:24:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730872AbgG3VY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:24:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55338 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730746AbgG3VXY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:23:24 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ULFbLL011474
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:23:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=aJhxUwc8CQWldWv2VHn/REvyN245rZYwC4rTdQ9c38E=;
 b=VEzzoM4ovnJBIpbgBfrXZILoUeIvg04oavUBqDeskupzb5O8emAzjZaEetaNCMg3Y4/q
 HOZL7ay+cgwNxDmRjbogMrbFOL9bUlALlyKsJ+XGvCh8W6vJ+34q7FfXkzSDzaE8v7EG
 uPnq/VzQQ6IM7UnhxZpr623hh5Erc2QDMH0= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32kcbuy100-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:23:24 -0700
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 14:23:21 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id D2AAE20B00B8; Thu, 30 Jul 2020 14:23:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v3 14/29] bpf: eliminate rlimit-based memory accounting for bpf_struct_ops maps
Date:   Thu, 30 Jul 2020 14:22:55 -0700
Message-ID: <20200730212310.2609108-15-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200730212310.2609108-1-guro@fb.com>
References: <20200730212310.2609108-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=973
 bulkscore=0 clxscore=1015 suspectscore=38 phishscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007300150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for bpf_struct_ops maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/bpf_struct_ops.c | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
index 969c5d47f81f..22bfa236683b 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -550,12 +550,10 @@ static int bpf_struct_ops_map_alloc_check(union bpf=
_attr *attr)
 static struct bpf_map *bpf_struct_ops_map_alloc(union bpf_attr *attr)
 {
 	const struct bpf_struct_ops *st_ops;
-	size_t map_total_size, st_map_size;
+	size_t st_map_size;
 	struct bpf_struct_ops_map *st_map;
 	const struct btf_type *t, *vt;
-	struct bpf_map_memory mem;
 	struct bpf_map *map;
-	int err;
=20
 	if (!bpf_capable())
 		return ERR_PTR(-EPERM);
@@ -575,20 +573,11 @@ static struct bpf_map *bpf_struct_ops_map_alloc(uni=
on bpf_attr *attr)
 		 * struct bpf_struct_ops_tcp_congestions_ops
 		 */
 		(vt->size - sizeof(struct bpf_struct_ops_value));
-	map_total_size =3D st_map_size +
-		/* uvalue */
-		sizeof(vt->size) +
-		/* struct bpf_progs **progs */
-		 btf_type_vlen(t) * sizeof(struct bpf_prog *);
-	err =3D bpf_map_charge_init(&mem, map_total_size);
-	if (err < 0)
-		return ERR_PTR(err);
=20
 	st_map =3D bpf_map_area_alloc(st_map_size, NUMA_NO_NODE);
-	if (!st_map) {
-		bpf_map_charge_finish(&mem);
+	if (!st_map)
 		return ERR_PTR(-ENOMEM);
-	}
+
 	st_map->st_ops =3D st_ops;
 	map =3D &st_map->map;
=20
@@ -599,14 +588,12 @@ static struct bpf_map *bpf_struct_ops_map_alloc(uni=
on bpf_attr *attr)
 	st_map->image =3D bpf_jit_alloc_exec(PAGE_SIZE);
 	if (!st_map->uvalue || !st_map->progs || !st_map->image) {
 		bpf_struct_ops_map_free(map);
-		bpf_map_charge_finish(&mem);
 		return ERR_PTR(-ENOMEM);
 	}
=20
 	mutex_init(&st_map->lock);
 	set_vm_flush_reset_perms(st_map->image);
 	bpf_map_init_from_attr(map, attr);
-	bpf_map_charge_move(&map->memory, &mem);
=20
 	return map;
 }
--=20
2.26.2

