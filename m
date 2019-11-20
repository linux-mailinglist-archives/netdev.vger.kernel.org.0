Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA75104530
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726568AbfKTUfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:35:54 -0500
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:18430
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbfKTUfx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:35:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RovUjtPMe92+3c0KDFsSuULYpyVD/lZn75Y85TX3kDPpqC2UR+dQTJGviqzsBy/wdjyhyEw99ruQjN9eFyK3nCN+bVbUlJlll77o+0f/nvrzg714fu2BB9khZKJvkHPnfdueQF2qYEUag2xKkdqVQ6ROILDoW0M2pmGj5itF87pcQ6z+wRp1AzJM4Pdq2uOCTqeq16Iyn2wiO5aeJ/PbLFLMz07kI3wFh175KqWl8OHwgTQuBOUB3XWCcIajjjKy//cGuqOij6bCZ1nOFViTaOLtUBoHCLNnD+Pzl3kMYwl1/qVbhGPB5K1Dn8IoDfg+rM7VVJQyQLaPtTfPP085Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh5Ax7GHUOHdRi1ocFVZsrW+mYNGmETWv1dKAm3Lo4Y=;
 b=gVAiOex0kNwiJIQ0yFYHqSkTPZVcSBOjgsEcVx0kmAvLo6ycyI/onXrBIcarkEFXluo8T2+ngh7Yvrh+1kItMDdpWeUmjcd/9L9hTqYwuwfU37pGCQI7GVjEDxbKaKY1Y1EWiTV1IHdsZ5wZHYQ+0l0bl5QuoVoYDFZscFMRmDkO9rHcWKIJuhO3mwH9tsNXXyY0C5HSD/qmGjE5SCI52BoX8WWrjUGdm1WWXdQqYt/Out/36tdBzNZHEHR9xWtDJdZS7HvhzTg7FNtKpK+pFVLEiLgjCZAx7ASYQR+ULn1k4G/78/dquAnBZAD8W6befuxbFPmmsc838lJ0Y3k9UQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Sh5Ax7GHUOHdRi1ocFVZsrW+mYNGmETWv1dKAm3Lo4Y=;
 b=sXiHK0AYtv1f7JdawiHjRd8A+cKd/LGneg6OIjwKr7cf6CiAkX1oJJ4KJQ0HnONW4C+lIocNtBxJSstHJY6cSvKJ12NmYyLMJkE2Ll6gSkhnBWXfUdFgZX8P4S0JP+IJveExBl7EZGpJIIu0wG9f50gA7uFMtZFjfoz618WWn/U=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:35:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:35:45 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eli Cohen <eli@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 02/12] net/mlx5e: Fix ingress rate configuration for
 representors
Thread-Topic: [net 02/12] net/mlx5e: Fix ingress rate configuration for
 representors
Thread-Index: AQHVn+IV5biLfafBWkW9ZvZuJ4jtzQ==
Date:   Wed, 20 Nov 2019 20:35:45 +0000
Message-ID: <20191120203519.24094-3-saeedm@mellanox.com>
References: <20191120203519.24094-1-saeedm@mellanox.com>
In-Reply-To: <20191120203519.24094-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0044.namprd02.prod.outlook.com
 (2603:10b6:a03:54::21) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e15aef90-3030-4c6c-4d03-08d76df937f3
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6110634EC1FF8C650C171A75BE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:586;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jp8l9liIs2e6ScD8EbC1G6C6w49EGYHbVqeG+jYwOY2ePfSCm/lLzgUt9CMwLpu2fyQvnvDTJ4Vo+3O71OgL2hEGr99R5WlEcgLRCwCQ7/pCxbjzutw5CCzmsYpP9EN2UH+Gx/6Ic79ShV1nCUqmIPDbRLX7+StTzMNCBBNWqNDqFd1oju/mdNDNrBB0cXq9gZ6EJls1HXwzMdth4NiWJk5pyVpbzu5WPegcJbD0yOQvcdkVZGetE/VvYB7qtr8gpYwJv4/i3gJ/TGQ8GKb2RkQ2er/qQ1fDgocGpBJ5wqX85nmVBbW5JNJqEt/ftrt5butNIucBwhHF8Uv6m9+tA9AiAZmLErrkkN54fSKnmaVxdh8IUQ4/1fT4ZD/yd+STh6CMQo47HQCQ/D2Ap9FAuUt3CTRjPmtD5AituRFfSts79oV+kPrkYZVn5vLsWVeV
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e15aef90-3030-4c6c-4d03-08d76df937f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:35:45.3098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: d/LAAKgh1iykvDO9HRClgEmFl8zNsUGt+K38yEHdr4hP9uUxcqE140jtC7vNzmba0vaWjR5j/FO9GDFVtSjTAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

Current code uses the old method of prio encoding in
flow_cls_common_offload. Fix to follow the changes introduced in
commit ef01adae0e43 ("net: sched: use major priority number as hardware pri=
ority").

Fixes: fcb64c0f5640 ("net/mlx5: E-Switch, add ingress rate support")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index fda0b37075e8..b7889d93ddca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4000,9 +4000,8 @@ int mlx5e_tc_configure_matchall(struct mlx5e_priv *pr=
iv,
 				struct tc_cls_matchall_offload *ma)
 {
 	struct netlink_ext_ack *extack =3D ma->common.extack;
-	int prio =3D TC_H_MAJ(ma->common.prio) >> 16;
=20
-	if (prio !=3D 1) {
+	if (ma->common.prio !=3D 1) {
 		NL_SET_ERR_MSG_MOD(extack, "only priority 1 is supported");
 		return -EINVAL;
 	}
--=20
2.21.0

