Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3682B584E
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 04:44:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728022AbgKQDnP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 22:43:15 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:10488 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727014AbgKQDlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 22:41:18 -0500
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AH3eXev024889
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=rKGNszCW/P6dvmhm3p060mdAyE8dspU8E8AG4YPMM50=;
 b=murQ0mchcXXIEZpJZvMR6ZPz5/Gpouj0m2zRcDKfjxK695cZTNvxMVdDcDXkU8EUKSd5
 EuKm3fvHm38d4XlI/q+0TrRkDIg5a/r4YQq5qFQGa621JSh6Nw5okc+4kaULx/0wiL9z
 7ppctWs9uLcKmjsl23Zzv5NBRsrSWXwb3BY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 34u0698p82-16
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 19:41:17 -0800
Received: from intmgw002.06.prn3.facebook.com (2620:10d:c085:108::8) by
 mail.thefacebook.com (2620:10d:c085:21d::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 16 Nov 2020 19:41:14 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 83329C63A89; Mon, 16 Nov 2020 19:41:10 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v6 25/34] bpf: eliminate rlimit-based memory accounting for queue_stack_maps maps
Date:   Mon, 16 Nov 2020 19:40:59 -0800
Message-ID: <20201117034108.1186569-26-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201117034108.1186569-1-guro@fb.com>
References: <20201117034108.1186569-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-17_01:2020-11-13,2020-11-17 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 impostorscore=0 phishscore=0 suspectscore=13 priorityscore=1501
 spamscore=0 mlxlogscore=999 adultscore=0 lowpriorityscore=0 bulkscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011170027
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for queue_stack maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 kernel/bpf/queue_stack_maps.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/kernel/bpf/queue_stack_maps.c b/kernel/bpf/queue_stack_maps.=
c
index 0ee2347ba510..f9c734aaa990 100644
--- a/kernel/bpf/queue_stack_maps.c
+++ b/kernel/bpf/queue_stack_maps.c
@@ -66,29 +66,21 @@ static int queue_stack_map_alloc_check(union bpf_attr=
 *attr)
=20
 static struct bpf_map *queue_stack_map_alloc(union bpf_attr *attr)
 {
-	int ret, numa_node =3D bpf_map_attr_numa_node(attr);
-	struct bpf_map_memory mem =3D {0};
+	int numa_node =3D bpf_map_attr_numa_node(attr);
 	struct bpf_queue_stack *qs;
-	u64 size, queue_size, cost;
+	u64 size, queue_size;
=20
 	size =3D (u64) attr->max_entries + 1;
-	cost =3D queue_size =3D sizeof(*qs) + size * attr->value_size;
-
-	ret =3D bpf_map_charge_init(&mem, cost);
-	if (ret < 0)
-		return ERR_PTR(ret);
+	queue_size =3D sizeof(*qs) + size * attr->value_size;
=20
 	qs =3D bpf_map_area_alloc(queue_size, numa_node);
-	if (!qs) {
-		bpf_map_charge_finish(&mem);
+	if (!qs)
 		return ERR_PTR(-ENOMEM);
-	}
=20
 	memset(qs, 0, sizeof(*qs));
=20
 	bpf_map_init_from_attr(&qs->map, attr);
=20
-	bpf_map_charge_move(&qs->map.memory, &mem);
 	qs->size =3D size;
=20
 	raw_spin_lock_init(&qs->lock);
--=20
2.26.2

