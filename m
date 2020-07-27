Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 073A422F83E
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732370AbgG0SrP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:47:15 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:64350 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729238AbgG0Sps (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:45:48 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06RIcpBD022575
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:47 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=VdNVeo/r7n5BeWPKriNc/78VSdoV1W6Zt7B5MFzVu6Y=;
 b=ks0aDragbunp1jFR4LkwXzfvVYUpTQp4nc/AoSW2plq1JSxK4q9yoIXJ9f0zHHGk/liw
 6BtGiV0nrvuJMK98kM6kDr6+9BheTBFI+A2a1OSaZlaBhDRvqyTZNfWdDabMojLfHWhT
 W94ZToazeUvfa31LAb5R00ohYhb3T6bVnmo= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 32gjjerav3-10
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:47 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 11:45:16 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id C506C1DAFE89; Mon, 27 Jul 2020 11:45:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v2 12/35] bpf: refine memcg-based memory accounting for xskmap maps
Date:   Mon, 27 Jul 2020 11:44:43 -0700
Message-ID: <20200727184506.2279656-13-guro@fb.com>
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
 mlxlogscore=800 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007270126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extend xskmap memory accounting to include the memory taken by
the xsk_map_node structure.

Signed-off-by: Roman Gushchin <guro@fb.com>
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

