Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1DA946C457
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 21:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbhLGUZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 15:25:17 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53304 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231753AbhLGUZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 15:25:16 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B7AnO6r024329
        for <netdev@vger.kernel.org>; Tue, 7 Dec 2021 12:21:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=facebook; bh=MD3VRuNNBs5l15yofSIeHSY8my01VfYdtVjhd3dJcl8=;
 b=pqcWRfAk48DGHPxld0CgSaKdLZ7+1gmO6bPx/OfPFka5dHa3UDH09LMLi6XWBqaofJyg
 W1VA/IKMmfoKFp5f3yyGt1QnLom3oExDyPhZRiYgyKiFvNj1F8buKSsKsl1PL6sUIeUi
 WruXlST1FLyDw5wzBF1DxN/EXdws/Et0iU4= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 3ct66gbp81-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 07 Dec 2021 12:21:45 -0800
Received: from intmgw001.25.frc3.facebook.com (2620:10d:c085:208::f) by
 mail.thefacebook.com (2620:10d:c085:11d::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 7 Dec 2021 12:21:43 -0800
Received: by devbig612.frc2.facebook.com (Postfix, from userid 115148)
        id 2F12D5C6803B; Tue,  7 Dec 2021 12:21:38 -0800 (PST)
From:   Joanne Koong <joannekoong@fb.com>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <kafai@fb.com>,
        <Kernel-team@fb.com>, Joanne Koong <joannekoong@fb.com>
Subject: [PATCH net-next] net: Enable unix sysctls to be configurable by non-init user namespaces
Date:   Tue, 7 Dec 2021 12:21:01 -0800
Message-ID: <20211207202101.2457994-1-joannekoong@fb.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-FB-Source: Intern
X-Proofpoint-GUID: Ch21lwgXETFZkdcACcqLxXKyI4Zv4el_
X-Proofpoint-ORIG-GUID: Ch21lwgXETFZkdcACcqLxXKyI4Zv4el_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-07_08,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=fb_outbound_notspam policy=fb_outbound score=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 impostorscore=0 bulkscore=0 clxscore=1011
 adultscore=0 priorityscore=1501 mlxlogscore=557 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112070125
X-FB-Internal: deliver
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, when a networking namespace is initialized, its unix sysctls
are exposed only if the user namespace that "owns" it is the init user
namespace.

If there is a non-init user namespace that "owns" a networking
namespace (for example, in the case after we call clone() with both
CLONE_NEWUSER and CLONE_NEWNET set), the sysctls are hidden from view
and not configurable.

This patch enables the unix networking sysctls (there is currently only
1, "sysctl_max_dgram_qlen", which is used as the default
"sk_max_ack_backlog" value when a unix socket is created) to be exposed
to non-init user namespaces.

This is safe because any changes made to these sysctls will be limited
in scope to the networking namespace the non-init user namespace "owns"
and has privileges over.

Signed-off-by: Joanne Koong <joannekoong@fb.com>
---
 net/unix/sysctl_net_unix.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index c09bea89151b..01d44e2598e2 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -30,10 +30,6 @@ int __net_init unix_sysctl_register(struct net *net)
 	if (table =3D=3D NULL)
 		goto err_alloc;
=20
-	/* Don't export sysctls to unprivileged users */
-	if (net->user_ns !=3D &init_user_ns)
-		table[0].procname =3D NULL;
-
 	table[0].data =3D &net->unx.sysctl_max_dgram_qlen;
 	net->unx.ctl =3D register_net_sysctl(net, "net/unix", table);
 	if (net->unx.ctl =3D=3D NULL)
--=20
2.30.2

