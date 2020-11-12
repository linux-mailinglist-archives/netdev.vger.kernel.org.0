Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 865B72B112D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 23:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727553AbgKLWQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 17:16:07 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727249AbgKLWQF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 17:16:05 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0ACMAB9O014023
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:16:04 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=LT/P2YCBJepX7Y97jIn2IxLZNISStw+CF2wJlVWzoL0=;
 b=XUnC40EJIYHf9CsCNbzq9kvVmHbeUytxt5Ej/SWdANa8sx0ZO0xyNcOo1YzetlE+GTRU
 aqG4j3MMaZUp9RwgPWbmcLxIkp0G2ZRP9ExQoPH9ElU2S9Kngdrq/eT5ReJydtfO+YUY
 3EpoxDS+b7sQIHjjSDGgWSBvTReNdiwFh8A= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 34rva9dn9e-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 14:16:04 -0800
Received: from intmgw004.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 12 Nov 2020 14:16:03 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 67272A7D244; Thu, 12 Nov 2020 14:16:01 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        <netdev@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Shakeel Butt <shakeelb@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kernel-team@fb.com>,
        Roman Gushchin <guro@fb.com>
Subject: [PATCH bpf-next v5 31/34] bpf: eliminate rlimit-based memory accounting for bpf local storage maps
Date:   Thu, 12 Nov 2020 14:15:40 -0800
Message-ID: <20201112221543.3621014-32-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201112221543.3621014-1-guro@fb.com>
References: <20201112221543.3621014-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-12_14:2020-11-12,2020-11-12 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=643
 malwarescore=0 clxscore=1015 spamscore=0 priorityscore=1501
 suspectscore=13 phishscore=0 adultscore=0 impostorscore=0 bulkscore=0
 mlxscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2011120126
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do not use rlimit-based memory accounting for bpf local storage maps.
It has been replaced with the memcg-based memory accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/bpf_local_storage.c | 11 -----------
 1 file changed, 11 deletions(-)

diff --git a/kernel/bpf/bpf_local_storage.c b/kernel/bpf/bpf_local_storag=
e.c
index fd4f9ac1d042..3b0da5a04d55 100644
--- a/kernel/bpf/bpf_local_storage.c
+++ b/kernel/bpf/bpf_local_storage.c
@@ -544,8 +544,6 @@ struct bpf_local_storage_map *bpf_local_storage_map_a=
lloc(union bpf_attr *attr)
 	struct bpf_local_storage_map *smap;
 	unsigned int i;
 	u32 nbuckets;
-	u64 cost;
-	int ret;
=20
 	smap =3D kzalloc(sizeof(*smap), GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT=
);
 	if (!smap)
@@ -556,18 +554,9 @@ struct bpf_local_storage_map *bpf_local_storage_map_=
alloc(union bpf_attr *attr)
 	/* Use at least 2 buckets, select_bucket() is undefined behavior with 1=
 bucket */
 	nbuckets =3D max_t(u32, 2, nbuckets);
 	smap->bucket_log =3D ilog2(nbuckets);
-	cost =3D sizeof(*smap->buckets) * nbuckets + sizeof(*smap);
-
-	ret =3D bpf_map_charge_init(&smap->map.memory, cost);
-	if (ret < 0) {
-		kfree(smap);
-		return ERR_PTR(ret);
-	}
-
 	smap->buckets =3D kvcalloc(sizeof(*smap->buckets), nbuckets,
 				 GFP_USER | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!smap->buckets) {
-		bpf_map_charge_finish(&smap->map.memory);
 		kfree(smap);
 		return ERR_PTR(-ENOMEM);
 	}
--=20
2.26.2

