Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543432B99BF
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 18:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgKSRk1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 12:40:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:15896 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729430AbgKSRiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 12:38:11 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AJHTu2p026463
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:10 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=8ebA+INnP+S9dh1GI2+WmeYXpW5UeJvL7rqO27RxywU=;
 b=Vo6LRX9BU2o/Yb4HMs14fgwD/AitFLNhrmerAZUvDJj2WXqWGrj5HWioSoe41m22eRpc
 Eef599gP+dxpgYEG0UCMKPAc34E0OPsP5jymriYO2vbBZOEfwOf9RoDZeqDMl9bJCQol
 yYklE0PhssYlheOQ45c1O2+6tns+BoXXrKU= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34wfdq70ae-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 09:38:10 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:21d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 19 Nov 2020 09:38:01 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 0FD7C145BD13; Thu, 19 Nov 2020 09:37:57 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v7 30/34] bpf: eliminate rlimit-based memory accounting for xskmap maps
Date:   Thu, 19 Nov 2020 09:37:50 -0800
Message-ID: <20201119173754.4125257-31-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201119173754.4125257-1-guro@fb.com>
References: <20201119173754.4125257-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 phishscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=840 malwarescore=0 bulkscore=0 suspectscore=13
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011190125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for xskmap maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 net/xdp/xskmap.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index eceea51182d9..217e224698b9 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -75,9 +75,8 @@ static void xsk_map_sock_delete(struct xdp_sock *xs,
=20
 static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 {
-	struct bpf_map_memory mem;
-	int err, numa_node;
 	struct xsk_map *m;
+	int numa_node;
 	u64 size;
=20
 	if (!capable(CAP_NET_ADMIN))
@@ -91,18 +90,11 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *=
attr)
 	numa_node =3D bpf_map_attr_numa_node(attr);
 	size =3D struct_size(m, xsk_map, attr->max_entries);
=20
-	err =3D bpf_map_charge_init(&mem, size);
-	if (err < 0)
-		return ERR_PTR(err);
-
 	m =3D bpf_map_area_alloc(size, numa_node);
-	if (!m) {
-		bpf_map_charge_finish(&mem);
+	if (!m)
 		return ERR_PTR(-ENOMEM);
-	}
=20
 	bpf_map_init_from_attr(&m->map, attr);
-	bpf_map_charge_move(&m->map.memory, &mem);
 	spin_lock_init(&m->lock);
=20
 	return &m->map;
--=20
2.26.2

