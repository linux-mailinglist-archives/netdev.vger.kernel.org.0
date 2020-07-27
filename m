Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71D8F22F818
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732171AbgG0SqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:46:02 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48738 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732162AbgG0SqA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:46:00 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RIcpf4022547
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=80YNCeL+Zd9r13LAFwVO8PDzN4li7zYXXciecfUd7fs=;
 b=o5CU2OCIPAEsqib/3+QExIGTJg6L26Q+i62zFtIxkq7etiw0orG1rz2FtINVKvtYWVc1
 PpUUirR0Ji5+GgTFWNTu4jnrrsW6AeWEE2F6a0pcgEDCeZauZbReiP7iatYCSSwF67wx
 05iTBPKaToIMEGWNZPJm2TWbrKHqhihrx5U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32gjjeravt-20
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:59 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 11:45:22 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id 07EB51DAFE9F; Mon, 27 Jul 2020 11:45:11 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v2 23/35] bpf: eliminate rlimit-based memory accounting for sockmap and sockhash maps
Date:   Mon, 27 Jul 2020 11:44:54 -0700
Message-ID: <20200727184506.2279656-24-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727184506.2279656-1-guro@fb.com>
References: <20200727184506.2279656-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_13:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015 bulkscore=0
 phishscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=38
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 mlxlogscore=682 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for sockmap and sockhash maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 net/core/sock_map.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/net/core/sock_map.c b/net/core/sock_map.c
index bc797adca44c..07c90baf8db1 100644
--- a/net/core/sock_map.c
+++ b/net/core/sock_map.c
@@ -26,8 +26,6 @@ struct bpf_stab {
 static struct bpf_map *sock_map_alloc(union bpf_attr *attr)
 {
 	struct bpf_stab *stab;
-	u64 cost;
-	int err;
=20
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -45,22 +43,15 @@ static struct bpf_map *sock_map_alloc(union bpf_attr =
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
@@ -999,7 +990,6 @@ static struct bpf_map *sock_hash_alloc(union bpf_attr=
 *attr)
 {
 	struct bpf_shtab *htab;
 	int i, err;
-	u64 cost;
=20
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
@@ -1027,21 +1017,10 @@ static struct bpf_map *sock_hash_alloc(union bpf_=
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

