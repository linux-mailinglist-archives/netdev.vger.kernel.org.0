Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8132CAF52
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:02:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391047AbgLAWAD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:00:03 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:6916 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390997AbgLAWAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:00:02 -0500
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B1LnrGs027045
        for <netdev@vger.kernel.org>; Tue, 1 Dec 2020 13:59:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=TKhWeVbwR1+R38BO5gP0xFo0Jf94/jQSVtmS2N+ugC0=;
 b=lihPOytFW3p3cWQb8ROWYV2hESmc+yZIv0KqMq0NTNoRiK/BwzRoLHOutUNi6N8E1GO/
 o5ReOWyGe59La4+celj7jNBKycPFWQECYWZh3YDlcyfBiDeUaIZGhpBMa2INGJ9MUehW
 L4ZYK9LfHgrCIxqhjmT5NcyLRZlsTZkxNfQ= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 355vfk0t9t-15
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 01 Dec 2020 13:59:21 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 1 Dec 2020 13:59:11 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 9265419702C2; Tue,  1 Dec 2020 13:59:06 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v9 18/34] bpf: eliminate rlimit-based memory accounting for arraymap maps
Date:   Tue, 1 Dec 2020 13:58:44 -0800
Message-ID: <20201201215900.3569844-19-guro@fb.com>
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
 mlxlogscore=842 malwarescore=0 spamscore=0 suspectscore=38 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012010131
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for arraymap maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/arraymap.c | 24 ++++--------------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/kernel/bpf/arraymap.c b/kernel/bpf/arraymap.c
index d837e0603c89..1f8453343bf2 100644
--- a/kernel/bpf/arraymap.c
+++ b/kernel/bpf/arraymap.c
@@ -81,11 +81,10 @@ int array_map_alloc_check(union bpf_attr *attr)
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
@@ -126,44 +125,29 @@ static struct bpf_map *array_map_alloc(union bpf_at=
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

