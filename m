Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D429C2C374B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 04:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728203AbgKYDCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 22:02:36 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46104 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727434AbgKYDBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 22:01:35 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 0AP2sovo000549
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:34 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=CtZU/Z66pJ6HgtncJzdrIc0HAIs7vBKCZj6Sx0S+MSs=;
 b=hpG+SSpU80fnsqGy5woAxxrDyKT3SzHQXpLjleL4dWzv5/FoMAbe9ZDlQzL2fh8OFo8l
 JThAiN0d8jNSULGx5DH0b/XOP7QBwSIpEqoaTJox229Cqj5zp6IJAcjpdil2xBKkUXx5
 1lQkUQmV6LQDYXRC56xNbnQjBlUaJgrT7qs= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 351aqe0unq-8
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 19:01:34 -0800
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 24 Nov 2020 19:01:28 -0800
Received: by devvm3388.prn0.facebook.com (Postfix, from userid 111017)
        id 38D5816A18A3; Tue, 24 Nov 2020 19:01:22 -0800 (PST)
From:   Roman Gushchin <guro@fb.com>
To:     <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <netdev@vger.kernel.org>,
        <andrii@kernel.org>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kernel-team@fb.com>
Subject: [PATCH bpf-next v8 17/34] bpf: refine memcg-based memory accounting for xskmap maps
Date:   Tue, 24 Nov 2020 19:01:02 -0800
Message-ID: <20201125030119.2864302-18-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201125030119.2864302-1-guro@fb.com>
References: <20201125030119.2864302-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-24_11:2020-11-24,2020-11-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 spamscore=0 bulkscore=0
 priorityscore=1501 lowpriorityscore=0 adultscore=0 impostorscore=0
 malwarescore=0 mlxscore=0 clxscore=1015 phishscore=0 mlxlogscore=732
 suspectscore=13 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011250018
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend xskmap memory accounting to include the memory taken by
the xsk_map_node structure.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 net/xdp/xskmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 49da2b8ace8b..eceea51182d9 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -28,7 +28,9 @@ static struct xsk_map_node *xsk_map_node_alloc(struct x=
sk_map *map,
 	struct xsk_map_node *node;
 	int err;
=20
-	node =3D kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
+	node =3D bpf_map_kmalloc_node(&map->map, sizeof(*node),
+				    GFP_ATOMIC | __GFP_NOWARN | __GFP_ZERO |
+				    __GFP_ACCOUNT, NUMA_NO_NODE);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

