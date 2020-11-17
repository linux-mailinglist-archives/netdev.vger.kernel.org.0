Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AD4C2B582B
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgKQDmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:42:11 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38710 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727235AbgKQDlW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:41:22 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AH3dSBE013761
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=VhHa5gszG9R4T/IasTotDuefG6HkPOwLYD8EfJMNV9Y=;
 b=Iydu3GUiSJWLGXkCMHzjJ1fEy2FpUAJ/yPLZSHugrXZKD9UrPGAWHs6ACzWCjMe5Iq9c
 /00OpNrcUgDRCCdqeL2iKHpRehcOE1ahdYTFd3FcGmNdNEDYsaPrnTo7ohXHU7opo4j3
 izPKAaJPZBK6qfd2pg+YEWucwFeIFrLLH3o= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by m0089730.ppops.net with ESMTP id 34tbm4usqg-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:21 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 19:41:14 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 90AB3C63A8F; Mon, 16 Nov 2020 19:41:10 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v6 28/34] bpf: eliminate rlimit-based memory accounting for sockmap and sockhash maps
Date:   Mon, 16 Nov 2020 19:41:02 -0800
Message-ID: <20201117034108.1186569-29-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117034108.1186569-1-guro@fb.com>
References: <20201117034108.1186569-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_01:2020-11-13,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 mlxscore=0
 mlxlogscore=670 bulkscore=0 suspectscore=38 malwarescore=0 phishscore=0
 impostorscore=0 priorityscore=1501 adultscore=0 lowpriorityscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170027
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for sockmap and sockhash maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 net/core/sock_map.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index 30455d1952e7..1552eceaa01b 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -27,8 +27,6 @@ struct bpf_stab {
 static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_stab *stab;
-	u64 cost;
-	int err;
=20
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -46,22 +44,15 @@ static struct bpf_map *sock_map_alloc(union bpf_attr =
*attr)
 	bpf_map_init_from_attr(&stab->map, attr);
 	raw_spin_lock_init(&stab->lock);
=20
-	/* Make sure page count doesn't overflow. */
-	cost =3D (u64) stab->map.max_entries * sizeof(struct sock *);
-	err =3D bpf_map_charge_init(&stab->map.memory, cost);
-	if (err)
-		goto free_stab;
-
 	stab->sks =3D bpf_map_area_alloc(stab->map.max_entries *
 				       sizeof(struct sock *),
 				       stab->map.numa_node);
-	if (stab->sks)
-		return &stab->map;
-	err =3D -ENOMEM;
-	bpf_map_charge_finish(&stab->map.memory);
-free_stab:
-	kfree(stab);
-	return ERR_PTR(err);
+	if (!stab->sks) {
+		kfree(stab);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	return &stab->map;
 }
=20
 int sock_map_get_from_fd(const union bpf_attr *attr, struct bpf_prog *pr=
og)
@@ -1104,7 +1095,6 @@ static struct bpf_map *sock_hash_alloc(union bpf_at=
tr *attr)
 {
 	struct bpf_shtab *htab;
 	int i, err;
-	u64 cost;
=20
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -1132,21 +1122,10 @@ static struct bpf_map *sock_hash_alloc(union bpf_=
attr *attr)
 		goto free_htab;
 	}
=20
-	cost =3D (u64) htab->buckets_num * sizeof(struct bpf_shtab_bucket) +
-	       (u64) htab->elem_size * htab->map.max_entries;
-	if (cost >=3D U32_MAX - PAGE_SIZE) {
-		err =3D -EINVAL;
-		goto free_htab;
-	}
-	err =3D bpf_map_charge_init(&htab->map.memory, cost);
-	if (err)
-		goto free_htab;
-
 	htab->buckets =3D bpf_map_area_alloc(htab->buckets_num *
 					   sizeof(struct bpf_shtab_bucket),
 					   htab->map.numa_node);
 	if (!htab->buckets) {
-		bpf_map_charge_finish(&htab->map.memory);
 		err =3D -ENOMEM;
 		goto free_htab;
 	}
--=20
2.26.2

