Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABBC222F822
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732254AbgG0SqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:46:19 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8334 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731979AbgG0Spy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:45:54 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RIjgAQ027137
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=O7wK7OpoLwEqV4eCalhKTu3CREJohf19fBj1cE/GZUA=;
 b=QrlISjydqMZ0eUSUQZzk3B3fm+lQrEBsE2S0AbQUxKNAAsCRMA2vI3aqRUELbKfnvnyq
 WKfKMz22YzXbFwhkI+KV6Dk1HXelDuFCnq4xCABgjAWpvqyE7MCVYWFxbNYsP0CjHJp3
 IeKkkkxUr+yI41qgONI2dx+Yy6cQnUZ4keU= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32h50vnsxu-14
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:53 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 11:45:22 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id F2C1F1DAFE9B; Mon, 27 Jul 2020 11:45:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v2 21/35] bpf: eliminate rlimit-based memory accounting for reuseport_array maps
Date:   Mon, 27 Jul 2020 11:44:52 -0700
Message-ID: <20200727184506.2279656-22-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727184506.2279656-1-guro@fb.com>
References: <20200727184506.2279656-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_13:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=38
 phishscore=0 mlxscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0
 malwarescore=0 bulkscore=0 mlxlogscore=781 priorityscore=1501 adultscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270127
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for reuseport_array maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/reuseport_array.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/reuseport_array.c b/kernel/bpf/reuseport_array.c
index 90b29c5b1da7..9d0161fdfec7 100644
--- a/kernel/bpf/reuseport_array.c
+++ b/kernel/bpf/reuseport_array.c
@@ -150,9 +150,8 @@ static void reuseport_array_free(struct bpf_map *map)
=20
 static struct bpf_map *reuseport_array_alloc(union bpf_attr *attr)
 {
-	int err, numa_node =3D bpf_map_attr_numa_node(attr);
+	int numa_node =3D bpf_map_attr_numa_node(attr);
 	struct reuseport_array *array;
-	struct bpf_map_memory mem;
 	u64 array_size;
=20
 	if (!bpf_capable())
@@ -161,20 +160,13 @@ static struct bpf_map *reuseport_array_alloc(union =
bpf_attr *attr)
 	array_size =3D sizeof(*array);
 	array_size +=3D (u64)attr->max_entries * sizeof(struct sock *);
=20
-	err =3D bpf_map_charge_init(&mem, array_size);
-	if (err)
-		return ERR_PTR(err);
-
 	/* allocate all map elements and zero-initialize them */
 	array =3D bpf_map_area_alloc(array_size, numa_node);
-	if (!array) {
-		bpf_map_charge_finish(&mem);
+	if (!array)
 		return ERR_PTR(-ENOMEM);
-	}
=20
 	/* copy mandatory map attributes */
 	bpf_map_init_from_attr(&array->map, attr);
-	bpf_map_charge_move(&array->map.memory, &mem);
=20
 	return &array->map;
 }
--=20
2.26.2

