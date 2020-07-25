Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2917722D2C4
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727844AbgGYAEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:04:42 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:18882 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727107AbgGYAEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:39 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONmcBr012900
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=+B2E7moQ5wccXm5Qug0MMytIJWZXqnF6CSHLPrEB7X4=;
 b=kfdzCaJm17dlvZFhoPonYEnn4PpgZe+WW6NYnT/ozfzfG7xt/426FpqpAdAbkk1/MygY
 JKFvPW+0PA3f/cDCL5TH1W5ZZoDY66pcP+IskVK6wJ1+efz4ysYovZjxg8+e/W6yQW6S
 UCMlzDHkL6flUytCaHqR/QJD+pKyajkbuDY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32embcegmk-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:37 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:36 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 3481E1B35AA0; Fri, 24 Jul 2020 17:04:27 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 26/35] bpf: eliminate rlimit-based memory accounting for xskmap maps
Date:   Fri, 24 Jul 2020 17:04:01 -0700
Message-ID: <20200725000410.3566700-27-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 mlxlogscore=878 impostorscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 adultscore=0 phishscore=0 mlxscore=0 suspectscore=13
 spamscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for xskmap maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 net/xdp/xskmap.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index e574b22defe5..0366013f13c6 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -74,7 +74,6 @@ static void xsk_map_sock_delete(struct xdp_sock *xs,
=20
 static struct bpf_map *xsk_map_alloc(union bpf_attr *attr)
 {
-	struct bpf_map_memory mem;
 	int err, numa_node;
 	struct xsk_map *m;
 	u64 size;
@@ -90,18 +89,11 @@ static struct bpf_map *xsk_map_alloc(union bpf_attr *=
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

