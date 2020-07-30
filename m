Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5189D233AD7
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 23:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbgG3V0S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 17:26:18 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26576 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730659AbgG3VXS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 17:23:18 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06ULEqWZ024305
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:23:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=jE0vXs+gQW10rH0feF6C0U96CAqBPpOSd/wymRApFnE=;
 b=G+WZ1X7Hw0vyfHZMbFGQNUvANmLbcPAHlA3hmDGfdo18c76D1IXJVOEhpIY51CkA93/4
 K8foR75IQ0U8eGjQ+XUJW4UABN2HT48o+okBx3eAgsSgl3bW9h2QgpwK9JqDGkLHhPmF
 Irv/C1o2vg8VXuVjaA7b+zWKSJzSyXN+o2E= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 32m01cj9v4-13
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 30 Jul 2020 14:23:17 -0700
Received: from intmgw002.41.prn1.facebook.com (2620:10d:c085:208::11) by
 mail.thefacebook.com (2620:10d:c085:11d::7) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 30 Jul 2020 14:23:16 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id C906420B00B4; Thu, 30 Jul 2020 14:23:12 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>,
        Song Liu <songliubraving@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v3 12/29] bpf: refine memcg-based memory accounting for xskmap maps
Date:   Thu, 30 Jul 2020 14:22:53 -0700
Message-ID: <20200730212310.2609108-13-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200730212310.2609108-1-guro@fb.com>
References: <20200730212310.2609108-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-30_15:2020-07-30,2020-07-30 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 adultscore=0 lowpriorityscore=0 suspectscore=13 mlxlogscore=811
 phishscore=0 clxscore=1015 impostorscore=0 bulkscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007300150
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend xskmap memory accounting to include the memory taken by
the xsk_map_node structure.

Signed-off-by: Roman Gushchin <guro@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 net/xdp/xskmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xskmap.c b/net/xdp/xskmap.c
index 8367adbbe9df..e574b22defe5 100644
--- a/net/xdp/xskmap.c
+++ b/net/xdp/xskmap.c
@@ -28,7 +28,8 @@ static struct xsk_map_node *xsk_map_node_alloc(struct x=
sk_map *map,
 	struct xsk_map_node *node;
 	int err;
=20
-	node =3D kzalloc(sizeof(*node), GFP_ATOMIC | __GFP_NOWARN);
+	node =3D kzalloc(sizeof(*node),
+		       GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
=20
--=20
2.26.2

