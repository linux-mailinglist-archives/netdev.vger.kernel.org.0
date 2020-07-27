Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7D3122F865
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732445AbgG0Sse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:48:34 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:47220 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731050AbgG0SpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 14:45:18 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 06RIe5Ti024050
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=Vcb83+f74UvJlIacjBTHLSV5Z+RJgcds2HrEoDLq7rQ=;
 b=pAGjg0sWm26270qVUARbmO1CevIgEWs96GihltrIT306PGhcGjQ8YZO8JVOM/poBoCnz
 4j0M1mAiPLqF9BgnCXcF/yF+F2/Mh2SHrB0Cl3i6NBSkCZzNs2VczGHfLispghLwqp4F
 G4G+HDoVY3jAkVoKLKXQQTue56izQKirwdA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 32gg7xrhh5-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 11:45:17 -0700
Received: from intmgw001.06.prn3.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 27 Jul 2020 11:45:15 -0700
Received: by devvm1096.prn0.facebook.com (Postfix, from userid 111017)
        id A87171DAFE7D; Mon, 27 Jul 2020 11:45:10 -0700 (PDT)
Smtp-Origin-Hostprefix: devvm
From:   Roman Gushchin <guro@fb.com>
Smtp-Origin-Hostname: devvm1096.prn0.facebook.com
To:     <bpf@vger.kernel.org>
CC:     <netdev@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, <kernel-team@fb.com>,
        <linux-kernel@vger.kernel.org>, Roman Gushchin <guro@fb.com>
Smtp-Origin-Cluster: prn0c01
Subject: [PATCH bpf-next v2 06/35] bpf: refine memcg-based memory accounting for devmap maps
Date:   Mon, 27 Jul 2020 11:44:37 -0700
Message-ID: <20200727184506.2279656-7-guro@fb.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200727184506.2279656-1-guro@fb.com>
References: <20200727184506.2279656-1-guro@fb.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-27_13:2020-07-27,2020-07-27 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=13
 malwarescore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 spamscore=0 adultscore=0 phishscore=0 mlxscore=0 bulkscore=0
 mlxlogscore=851 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2007270126
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Include map metadata and the node size (struct bpf_dtab_netdev) on
element update into the accounting.

Signed-off-by: Roman Gushchin <guro@fb.com>
---
 kernel/bpf/devmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index 10abb06065bb..05bf93088063 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -175,7 +175,7 @@ static struct bpf_map *dev_map_alloc(union bpf_attr *=
attr)
 	if (!capable(CAP_NET_ADMIN))
 		return ERR_PTR(-EPERM);
=20
-	dtab =3D kzalloc(sizeof(*dtab), GFP_USER);
+	dtab =3D kzalloc(sizeof(*dtab), GFP_USER | __GFP_ACCOUNT);
 	if (!dtab)
 		return ERR_PTR(-ENOMEM);
=20
@@ -603,7 +603,8 @@ static struct bpf_dtab_netdev *__dev_map_alloc_node(s=
truct net *net,
 	struct bpf_prog *prog =3D NULL;
 	struct bpf_dtab_netdev *dev;
=20
-	dev =3D kmalloc_node(sizeof(*dev), GFP_ATOMIC | __GFP_NOWARN,
+	dev =3D kmalloc_node(sizeof(*dev),
+			   GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT,
 			   dtab->map.numa_node);
 	if (!dev)
 		return ERR_PTR(-ENOMEM);
--=20
2.26.2

