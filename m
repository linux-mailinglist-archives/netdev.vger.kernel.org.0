Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1DD22F860
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:48:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732401AbgG0SsX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:48:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:62602 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731381AbgG0SpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:45:19 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RIcpHJ022555
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=RpUddOT0dq+RsTfIsNk4vSgUxj0W3ImY+p6qvZrfUCw=;
 b=aitPf/NNvPUOnNVjv9fSwgzzEfswCC3RqsIlW3OG5Hx/c0KYkz1A0Wyuv4CaRiu7O3Su
 eJt7a2Iqk1/GW0Ben2NXoYv3WKb4nS8hK6Qv4NQnIBQjHbv5uIK/bYl/3o7/K66qqRjN
 aqlG2I5a1vBcS/g2Phh2E6GgqIgn306/sBg= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32gjjerasn-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:17 -0700
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 11:45:15 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id BBD5E1DAFE85; Mon, 27 Jul 2020 11:45:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v2 10/35] bpf: memcg-based memory accounting for socket storage maps
Date:   Mon, 27 Jul 2020 11:44:41 -0700
Message-ID: <20200727184506.2279656-11-guro@fb.com>
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
 phishscore=0 spamscore=0 adultscore=0 malwarescore=0 suspectscore=13
 lowpriorityscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 mlxlogscore=983 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Account memory used by the socket storage.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 net/core/bpf_sk_storage.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index eafcd15e7dfd..fbcd03cd00d3 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -130,7 +130,8 @@ static struct bpf_sk_storage_elem *selem_alloc(struct=
 bpf_sk_storage_map *smap,
 	if (charge_omem && omem_charge(sk, smap->elem_size))
 		return NULL;
=20
-	selem =3D kzalloc(smap->elem_size, GFP_ATOMIC | __GFP_NOWARN);
+	selem =3D kzalloc(smap->elem_size,
+			GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (selem) {
 		if (value)
 			memcpy(SDATA(selem)->data, value, smap->map.value_size);
@@ -337,7 +338,8 @@ static int sk_storage_alloc(struct sock *sk,
 	if (err)
 		return err;
=20
-	sk_storage =3D kzalloc(sizeof(*sk_storage), GFP_ATOMIC | __GFP_NOWARN);
+	sk_storage =3D kzalloc(sizeof(*sk_storage),
+			     GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!sk_storage) {
 		err =3D -ENOMEM;
 		goto uncharge;
@@ -677,7 +679,7 @@ static struct bpf_map *bpf_sk_storage_map_alloc(union=
 bpf_attr *attr)
 	u64 cost;
 	int ret;
=20
-	smap =3D kzalloc(sizeof(*smap), GFP_USER | __GFP_NOWARN);
+	smap =3D kzalloc(sizeof(*smap), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT=
);
 	if (!smap)
 		return ERR_PTR(-ENOMEM);
 	bpf_map_init_from_attr(&smap->map, attr);
@@ -695,7 +697,7 @@ static struct bpf_map *bpf_sk_storage_map_alloc(union=
 bpf_attr *attr)
 	}
=20
 	smap->buckets =3D kvcalloc(sizeof(*smap->buckets), nbuckets,
-				 GFP_USER | __GFP_NOWARN);
+				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!smap->buckets) {
 		bpf_map_charge_finish(&smap->map.memory);
 		kfree(smap);
@@ -1024,7 +1026,7 @@ bpf_sk_storage_diag_alloc(const struct nlattr *nla_=
stgs)
 	}
=20
 	diag =3D kzalloc(sizeof(*diag) + sizeof(diag->maps[0]) * nr_maps,
-		       GFP_KERNEL);
+		       GFP_KERNEL | __GFP_ACCOUNT);
 	if (!diag)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

