Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E03122D304
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 02:07:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727942AbgGYAHk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 20:07:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18804 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726985AbgGYAEc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 20:04:32 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ONmed7013832
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LemzQmSpwUqh0yVmoBb6ZzTmt1hoW0QS3JNG8xksTno=;
 b=WVC2sxLqas284GRqLrGekFaqw9GTeD5UKWYFopjXNYm/kEf7mzYFGPVsKAXrj6xgQX9A
 +bkL86fIiOO3vIVr4fBuGy83V4fLY4XxVuoNJRIqQo/ZLuwfTUCJ/7mFdlUAtG0QjkKm
 QrndHDOfeTDsoZAURAfJDQABQhBM84ZDEbs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32fh7kpdm6-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 17:04:32 -0700
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 24 Jul 2020 17:04:31 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id EAEBA1B35A86; Fri, 24 Jul 2020 17:04:26 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next 13/35] bpf: eliminate rlimit-based memory accounting for arraymap maps
Date:   Fri, 24 Jul 2020 17:03:48 -0700
Message-ID: <20200725000410.3566700-14-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200725000410.3566700-1-guro@fb.com>
References: <20200725000410.3566700-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-24_10:2020-07-24,2020-07-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 clxscore=1015
 priorityscore=1501 bulkscore=0 spamscore=0 mlxlogscore=862 adultscore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=38 malwarescore=0
 impostorscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007240164
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for arraymap maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/arraymap.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index 9597fecff8da..41581c38b31d 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -75,11 +75,10 @@ int array_map_alloc_check(union bpf_attr *attr)
 static struct bpf_map *array_map_alloc(union bpf_attr *attr)
 {
 	bool percpu =3D attr->map_type =3D=3D BPF_MAP_TYPE_PERCPU_ARRAY;
-	int ret, numa_node =3D bpf_map_attr_numa_node(attr);
+	int numa_node =3D bpf_map_attr_numa_node(attr);
 	u32 elem_size, index_mask, max_entries;
 	bool bypass_spec_v1 =3D bpf_bypass_spec_v1();
-	u64 cost, array_size, mask64;
-	struct bpf_map_memory mem;
+	u64 array_size, mask64;
 	struct bpf_array *array;
=20
 	elem_size =3D round_up(attr->value_size, 8);
@@ -120,44 +119,29 @@ static struct bpf_map *array_map_alloc(union bpf_at=
tr *attr)
 		}
 	}
=20
-	/* make sure there is no u32 overflow later in round_up() */
-	cost =3D array_size;
-	if (percpu)
-		cost +=3D (u64)attr->max_entries * elem_size * num_possible_cpus();
-
-	ret =3D bpf_map_charge_init(&mem, cost);
-	if (ret < 0)
-		return ERR_PTR(ret);
-
 	/* allocate all map elements and zero-initialize them */
 	if (attr->map_flags & BPF_F_MMAPABLE) {
 		void *data;
=20
 		/* kmalloc'ed memory can't be mmap'ed, use explicit vmalloc */
 		data =3D bpf_map_area_mmapable_alloc(array_size, numa_node);
-		if (!data) {
-			bpf_map_charge_finish(&mem);
+		if (!data)
 			return ERR_PTR(-ENOMEM);
-		}
 		array =3D data + PAGE_ALIGN(sizeof(struct bpf_array))
 			- offsetof(struct bpf_array, value);
 	} else {
 		array =3D bpf_map_area_alloc(array_size, numa_node);
 	}
-	if (!array) {
-		bpf_map_charge_finish(&mem);
+	if (!array)
 		return ERR_PTR(-ENOMEM);
-	}
 	array->index_mask =3D index_mask;
 	array->map.bypass_spec_v1 =3D bypass_spec_v1;
=20
 	/* copy mandatory map attributes */
 	bpf_map_init_from_attr(&array->map, attr);
-	bpf_map_charge_move(&array->map.memory, &mem);
 	array->elem_size =3D elem_size;
=20
 	if (percpu && bpf_array_alloc_percpu(array)) {
-		bpf_map_charge_finish(&array->map.memory);
 		bpf_map_area_free(array);
 		return ERR_PTR(-ENOMEM);
 	}
--=20
2.26.2

