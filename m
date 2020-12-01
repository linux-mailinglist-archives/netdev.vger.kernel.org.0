Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1502CAF5C
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391213AbgLAWAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:00:08 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60266 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391077AbgLAWAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:00:06 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LnqHR027004
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=IUW+VKqBW1pXRUheLRAX/d4DEY1Uqhmr82cFLap6ovw=;
 b=GkrzZxf06LA3kZuSigzIsvwlPhnlQMQR6nk9OBMGL96GoR21UTvyXqvb0gdU53X65LUx
 BwJ5K0GFaY9KG6qoYHXXPqrlKUSMIzZyv7jfLemd7hZ7eLtExgHV3KCZmJOGc5jSSO0X
 m8NzZZMKEndg0lYKLwuvf8Hmh2MXF8shrVY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 355vfk0t9d-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:25 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:15 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 67B2019702B0; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 09/34] bpf: refine memcg-based memory accounting for cpumap maps
Date:   Tue, 1 Dec 2020 13:58:35 -0800
Message-ID: <20201201215900.3569844-10-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201201215900.3569844-1-guro@fb.com>
References: <20201201215900.3569844-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-01_11:2020-11-30,2020-12-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 adultscore=0
 clxscore=1015 priorityscore=1501 mlxscore=0 bulkscore=0 lowpriorityscore=0
 mlxlogscore=941 malwarescore=0 spamscore=0 suspectscore=38 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include metadata and percpu data into the memcg-based memory
accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/cpumap.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index c61a23b564aa..90b949666605 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -97,7 +97,7 @@ static struct bpf_map *cpu_map_alloc(union bpf_attr *at=
tr)
 	    attr->map_flags & ~BPF_F_NUMA_NODE)
 		return ERR_PTR(-EINVAL);
=20
-	cmap =3D kzalloc(sizeof(*cmap), GFP_USER);
+	cmap =3D kzalloc(sizeof(*cmap), GFP_USER | __GFP_ACCOUNT);
 	if (!cmap)
 		return ERR_PTR(-ENOMEM);
=20
@@ -412,7 +412,8 @@ static int __cpu_map_load_bpf_program(struct bpf_cpu_=
map_entry *rcpu, int fd)
 }
=20
 static struct bpf_cpu_map_entry *
-__cpu_map_entry_alloc(struct bpf_cpumap_val *value, u32 cpu, int map_id)
+__cpu_map_entry_alloc(struct bpf_map *map, struct bpf_cpumap_val *value,
+		      u32 cpu)
 {
 	int numa, err, i, fd =3D value->bpf_prog.fd;
 	gfp_t gfp =3D GFP_KERNEL | __GFP_NOWARN;
@@ -422,13 +423,13 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value,=
 u32 cpu, int map_id)
 	/* Have map->numa_node, but choose node of redirect target CPU */
 	numa =3D cpu_to_node(cpu);
=20
-	rcpu =3D kzalloc_node(sizeof(*rcpu), gfp, numa);
+	rcpu =3D bpf_map_kmalloc_node(map, sizeof(*rcpu), gfp | __GFP_ZERO, num=
a);
 	if (!rcpu)
 		return NULL;
=20
 	/* Alloc percpu bulkq */
-	rcpu->bulkq =3D __alloc_percpu_gfp(sizeof(*rcpu->bulkq),
-					 sizeof(void *), gfp);
+	rcpu->bulkq =3D bpf_map_alloc_percpu(map, sizeof(*rcpu->bulkq),
+					   sizeof(void *), gfp);
 	if (!rcpu->bulkq)
 		goto free_rcu;
=20
@@ -438,7 +439,8 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u=
32 cpu, int map_id)
 	}
=20
 	/* Alloc queue */
-	rcpu->queue =3D kzalloc_node(sizeof(*rcpu->queue), gfp, numa);
+	rcpu->queue =3D bpf_map_kmalloc_node(map, sizeof(*rcpu->queue), gfp,
+					   numa);
 	if (!rcpu->queue)
 		goto free_bulkq;
=20
@@ -447,7 +449,7 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u=
32 cpu, int map_id)
 		goto free_queue;
=20
 	rcpu->cpu    =3D cpu;
-	rcpu->map_id =3D map_id;
+	rcpu->map_id =3D map->id;
 	rcpu->value.qsize  =3D value->qsize;
=20
 	if (fd > 0 && __cpu_map_load_bpf_program(rcpu, fd))
@@ -455,7 +457,8 @@ __cpu_map_entry_alloc(struct bpf_cpumap_val *value, u=
32 cpu, int map_id)
=20
 	/* Setup kthread */
 	rcpu->kthread =3D kthread_create_on_node(cpu_map_kthread_run, rcpu, num=
a,
-					       "cpumap/%d/map:%d", cpu, map_id);
+					       "cpumap/%d/map:%d", cpu,
+					       map->id);
 	if (IS_ERR(rcpu->kthread))
 		goto free_prog;
=20
@@ -571,7 +574,7 @@ static int cpu_map_update_elem(struct bpf_map *map, v=
oid *key, void *value,
 		rcpu =3D NULL; /* Same as deleting */
 	} else {
 		/* Updating qsize cause re-allocation of bpf_cpu_map_entry */
-		rcpu =3D __cpu_map_entry_alloc(&cpumap_value, key_cpu, map->id);
+		rcpu =3D __cpu_map_entry_alloc(map, &cpumap_value, key_cpu);
 		if (!rcpu)
 			return -ENOMEM;
 		rcpu->cmap =3D cmap;
--=20
2.26.2

