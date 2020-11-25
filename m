Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90FDB2C3763
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728535AbgKYDD0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:03:26 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35474 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727362AbgKYDBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:01:30 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AP2s9Ll020711
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=cm0lsbYZ6mJomOEgr38hJGXr7jwC9GgPjM60AoqAOEI=;
 b=Y32o+U1UOq8uPEoiQVuquOTfnw4lFFZ+NYVDMO/Ekl2n7bk/tSgYNSUqe1AZyDKLP0Sj
 Z/HxOLG9TtsOh+x5thHddwZscup1KuhhcwLIN5c5hk3SxNNdoObtyrsUlB9ZMxBcodf0
 JJfio5RVR6u8swpZCQnZIqpXT8UJ3A7tzYI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34yx1t31xr-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:29 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 19:01:27 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 4293116A18A7; Tue, 24 Nov 2020 19:01:22 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v8 19/34] bpf: eliminate rlimit-based memory accounting for bpf_struct_ops maps
Date:   Tue, 24 Nov 2020 19:01:04 -0800
Message-ID: <20201125030119.2864302-20-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201125030119.2864302-1-guro@fb.com>
References: <20201125030119.2864302-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_11:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 mlxscore=0
 phishscore=0 adultscore=0 bulkscore=0 suspectscore=38 spamscore=0
 mlxlogscore=880 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011250018
X-FB-Internal: deliver
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
index 4c3b543bb33b..1a666a975416 100644
--- a/kernel/bpf/bpf_struct_ops.c
+++ b/kernel/bpf/bpf_struct_ops.c
@@ -548,12 +548,10 @@ static int bpf_struct_ops_map_alloc_check(union bpf=
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
@@ -573,20 +571,11 @@ static struct bpf_map *bpf_struct_ops_map_alloc(uni=
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
@@ -597,14 +586,12 @@ static struct bpf_map *bpf_struct_ops_map_alloc(uni=
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

