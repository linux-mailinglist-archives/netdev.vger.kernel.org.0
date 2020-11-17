Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C05F2B575D
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 03:59:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727750AbgKQC4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 21:56:41 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:7884 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726963AbgKQCzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 21:55:47 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH2sDwJ023481
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=qdqw2vIRlP2yIbod8BHIh3XnNn0ZSs325Y5RG0+0/sU=;
 b=EdnNVLpl9Y2neFCB7LniIcAuJRwJXH+xAYrUhdSudZ5jMEsNxfi3J3U5GEd/VdODa1+o
 E1N1+mZTzlOYu9d8bHKYE+yX+Z8Q2Nr35DnC84/VTm1fRFsDp4RZq9D4SInrB+XILv6R
 l8dZIXIzNC1J5rYp5umItUJ0QiAe5sIJsCY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34uphj4xw3-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 18:55:46 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 18:55:42 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 38EBCC5F7F6; Mon, 16 Nov 2020 18:55:34 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH v6 27/34] bpf: eliminate rlimit-based memory accounting for bpf ringbuffer
Date:   Mon, 16 Nov 2020 18:55:22 -0800
Message-ID: <20201117025529.1034387-28-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117025529.1034387-1-guro@fb.com>
References: <20201117025529.1034387-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-16_13:2020-11-13,2020-11-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=677 priorityscore=1501
 malwarescore=0 clxscore=1015 suspectscore=38 adultscore=0 spamscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170023
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for bpf ringbuffer.
It has been replaced with the memcg-based memory accounting.

bpf_ringbuf_alloc() can't return anything except ERR_PTR(-ENOMEM)
and a valid pointer, so to simplify the code make it return NULL
in the first case. This allows to drop a couple of lines in
ringbuf_map_alloc() and also makes it look similar to other memory
allocating function like kmalloc().

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
Acked-by: Andrii Nakryiko <andriin@fb.com>
---
 kernel/bpf/ringbuf.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/kernel/bpf/ringbuf.c b/kernel/bpf/ringbuf.c
index ee5f55d9276e..c8892b58501e 100644
--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -48,7 +48,6 @@ struct bpf_ringbuf {
=20
 struct bpf_ringbuf_map {
 	struct bpf_map map;
-	struct bpf_map_memory memory;
 	struct bpf_ringbuf *rb;
 };
=20
@@ -135,7 +134,7 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t d=
ata_sz, int numa_node)
=20
 	rb =3D bpf_ringbuf_area_alloc(data_sz, numa_node);
 	if (!rb)
-		return ERR_PTR(-ENOMEM);
+		return NULL;
=20
 	spin_lock_init(&rb->spinlock);
 	init_waitqueue_head(&rb->waitq);
@@ -151,8 +150,6 @@ static struct bpf_ringbuf *bpf_ringbuf_alloc(size_t d=
ata_sz, int numa_node)
 static struct bpf_map *ringbuf_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_ringbuf_map *rb_map;
-	u64 cost;
-	int err;
=20
 	if (attr->map_flags & ~RINGBUF_CREATE_FLAG_MASK)
 		return ERR_PTR(-EINVAL);
@@ -174,26 +171,13 @@ static struct bpf_map *ringbuf_map_alloc(union bpf_=
attr *attr)
=20
 	bpf_map_init_from_attr(&rb_map->map, attr);
=20
-	cost =3D sizeof(struct bpf_ringbuf_map) +
-	       sizeof(struct bpf_ringbuf) +
-	       attr->max_entries;
-	err =3D bpf_map_charge_init(&rb_map->map.memory, cost);
-	if (err)
-		goto err_free_map;
-
 	rb_map->rb =3D bpf_ringbuf_alloc(attr->max_entries, rb_map->map.numa_no=
de);
-	if (IS_ERR(rb_map->rb)) {
-		err =3D PTR_ERR(rb_map->rb);
-		goto err_uncharge;
+	if (!rb_map->rb) {
+		kfree(rb_map);
+		return ERR_PTR(-ENOMEM);
 	}
=20
 	return &rb_map->map;
-
-err_uncharge:
-	bpf_map_charge_finish(&rb_map->map.memory);
-err_free_map:
-	kfree(rb_map);
-	return ERR_PTR(err);
 }
=20
 static void bpf_ringbuf_free(struct bpf_ringbuf *rb)
--=20
2.26.2

