Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95FE122F84D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:47:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728921AbgG0Sp2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:45:28 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:46110 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731732AbgG0Sp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:45:26 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RIcv6a016654
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=e8dDwyndoKeHX4F6eolkc+471Uk00TT7E+B8DVXufVI=;
 b=YvaUIzWvKZ4m17nFch5rbNJch2pQYSw1bWX1UdDUJhOePthXtLO5kavRHkndlTq/O4gR
 pDDgqUo1No4E3+0Eh4nkiadeoVW0QCmlnGR7JmJmS3idJKEF/jEZc1QihkGdtJkt/UdU
 ZHv3p3zAKwokdYH8iYlj95RzmHdPOdpnimI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h4q9dvj9-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:26 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 11:45:22 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 0CA4D1DAFEA1; Mon, 27 Jul 2020 11:45:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v2 24/35] bpf: eliminate rlimit-based memory accounting for stackmap maps
Date:   Mon, 27 Jul 2020 11:44:55 -0700
Message-ID: <20200727184506.2279656-25-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727184506.2279656-1-guro@fb.com>
References: <20200727184506.2279656-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_13:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxlogscore=775
 malwarescore=0 adultscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 suspectscore=38 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for stackmap maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/stackmap.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 5beb2f8c23da..9ac0f405beef 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -90,7 +90,6 @@ static struct bpf_map *stack_map_alloc(union bpf_attr *=
attr)
 {
 	u32 value_size =3D attr->value_size;
 	struct bpf_stack_map *smap;
-	struct bpf_map_memory mem;
 	u64 cost, n_buckets;
 	int err;
=20
@@ -119,15 +118,9 @@ static struct bpf_map *stack_map_alloc(union bpf_att=
r *attr)
=20
 	cost =3D n_buckets * sizeof(struct stack_map_bucket *) + sizeof(*smap);
 	cost +=3D n_buckets * (value_size + sizeof(struct stack_map_bucket));
-	err =3D bpf_map_charge_init(&mem, cost);
-	if (err)
-		return ERR_PTR(err);
-
 	smap =3D bpf_map_area_alloc(cost, bpf_map_attr_numa_node(attr));
-	if (!smap) {
-		bpf_map_charge_finish(&mem);
+	if (!smap)
 		return ERR_PTR(-ENOMEM);
-	}
=20
 	bpf_map_init_from_attr(&smap->map, attr);
 	smap->map.value_size =3D value_size;
@@ -135,20 +128,17 @@ static struct bpf_map *stack_map_alloc(union bpf_at=
tr *attr)
=20
 	err =3D get_callchain_buffers(sysctl_perf_event_max_stack);
 	if (err)
-		goto free_charge;
+		goto free_smap;
=20
 	err =3D prealloc_elems_and_freelist(smap);
 	if (err)
 		goto put_buffers;
=20
-	bpf_map_charge_move(&smap->map.memory, &mem);
-
 	return &smap->map;
=20
 put_buffers:
 	put_callchain_buffers();
-free_charge:
-	bpf_map_charge_finish(&mem);
+free_smap:
 	bpf_map_area_free(smap);
 	return ERR_PTR(err);
 }
--=20
2.26.2

