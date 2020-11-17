Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DED712B5807
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:44:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbgKQDlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:41:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:2930 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726889AbgKQDlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:41:17 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3etIT007531
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=i22VzsfYXFhHUbHUyBRo4SfAiYTea7Ssop+WPV0F4gA=;
 b=MGDUAjIpFpHU5mTNvK0Qyg6DBkiIoLnMb09/Xn675fo+iHjF9IfyXIzzNJDaKWkAdgzH
 i7PPc91bO4z94wRGUs5ZhBpskzH+Oj+U8XfhghT5nhzsv1b8d2aluAzVHeaF1IZPoWzO
 V7d8pySiVnkbLFe1WbH3WVLxAn0GddS9uYY= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 34tykx8txm-9
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:16 -0800
Received: from intmgw003.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 19:41:13 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 63998C63A7A; Mon, 16 Nov 2020 19:41:10 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v6 18/34] bpf: eliminate rlimit-based memory accounting for arraymap maps
Date:   Mon, 16 Nov 2020 19:40:52 -0800
Message-ID: <20201117034108.1186569-19-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117034108.1186569-1-guro@fb.com>
References: <20201117034108.1186569-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_01:2020-11-13,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=38 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 impostorscore=0 mlxscore=0 mlxlogscore=857 spamscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011170027
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
index 92b650123c22..20f751a1d993 100644
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

