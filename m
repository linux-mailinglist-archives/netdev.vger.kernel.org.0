Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9CA3104531
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfKTUf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:35:57 -0500
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:18430
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbfKTUfz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:35:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jd/HjttKfmoEg2PsgRBpUNHyMSu+THXFcE3XhmhK+6f9bB5U1fMvkCZY9ljibLDM9G7vGG5WWMxItqVMw0TF3IR3dOfn7aIEI2Bl1hBBD+CyWPEvjdIVy3WkeI/Nzszhg7Oxjj8oo3ZcvUvI7sWwG9KjlnJT4+yy8rDq8Fn+PEBOK+wP3AlLj/tImAQRX0soBuZzLOPAkNdAnSL8IHlcWmWYCgA3W1XvnjS/VSalfirIUbwclABtrxFDOEoa5RQZ1EH8WdCl0CaLA0wd0nnE03RW8i3KMCQNo11y4p2EhMMy3+ICAtoGMCGcqGT2lxsvrh5Fgj7XrI1QHRgVniXhug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whUkcntRr2vw3GapCcSpWIHdoFXaHqtqfROeUFd8Krk=;
 b=dH23sXZYLfmCCUXM0ra+Z8rvwNSnj6tygAvfhh4JwLITJRKJLBkQiFAUjuX5UyS3SPfcyucmMKamt4wnqn98jBD134Fl1Ip8Y5D1jveV9yYODgFsxm+Jjy2tR44du3uIDAT2c8z7iSAvrxg6d+Zh+scYDp9st/jn5w44YHEpKXCnF8Zu9jy3TnHwKxzlMBQftXfKtvkMgWJTGdvQPqvqwzzcPjm224c7E9COAKI9l4buaJ1n69Q4vxoUTyhsHJHPUFCjBc7mt2TYoSZIWQnzRWdKDg7qp97fnBjZbWFBkTQLkaawqiaowfmX+khtmwa+kKn34R4zI580F7xEoqt5kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=whUkcntRr2vw3GapCcSpWIHdoFXaHqtqfROeUFd8Krk=;
 b=Njqn2vIsYa6iRXicsDEkrNaZE10KwOR37hl7tTg9dUWLbRNnv5y+kISng4g9iZ5FTzIZCCDV5BoH2nc8NR/sUe1NPi9aGBScfjfjtUc3B+KAhOPWawY5MQdn1hDSItoWk1jGUYXJiHd5UpStZI524EtI8ZPz3oizAdsVtYTJ5o4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:35:47 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:35:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 03/12] net/mlx5e: Reorder mirrer action parsing to check for
 encap first
Thread-Topic: [net 03/12] net/mlx5e: Reorder mirrer action parsing to check
 for encap first
Thread-Index: AQHVn+IWuH54kVXSWESoB8LycBpl2Q==
Date:   Wed, 20 Nov 2019 20:35:47 +0000
Message-ID: <20191120203519.24094-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: e444649d-ff4d-4055-b593-08d76df93921
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB61109E7AEDCB259BFA73165BBE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(14444005)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 05htfIiXMuwPcZNFUuyYeml1RTeLxKfj2w2oEaqOGsnoz0nLeiSjCJaqyxXh36xrpoIlFl/VeVvN/LWvOXq93R5jCx2/oRclxNL92nvX36FgHJ0Qf6zGMpk6DfZVRvJIr2rJfvs0geypLyNWcYoxYV+R41bkYL7o7ncZO8K/QE0E4P9wNq7pvMy2haflU/BmC5UdPNmrNfURwiqyR/Cxnnlgb0W0OLzd92OLAbghCRh8B04z8+wySElkEZiTNR+dKDaOK/0zkJR3XtR85kLE4u5ZgUO2V056pwnFcXCDGV2MXjD6oszoqGoDziLJMv/d011bieXTXTbNP8RUK9IHQHgVWoX2Ck61+4/BQWDgCiPrhSD9gtiyU3O+83ibJBNBOzYempMCRJz04lpyZJi1IturuR7hV21DISvE5EFU2rIJTPWXhbEkBZJ7oaryHInU
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e444649d-ff4d-4055-b593-08d76df93921
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:35:47.2437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9nUB7KMEE4kRBmGLZjhOUMUa14U6j/h+tWjptwQvH0ro5urR7pUWoxO8Gkv94ER1dwESvUxZVaTaSmE7LgwSzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vlad Buslov <vladbu@mellanox.com>

Mirred action parsing code in parse_tc_fdb_actions() first checks if
out_dev has same parent id, and only verifies that there is a pending encap
action that was parsed before. Recent change in vxlan module made function
netdev_port_same_parent_id() to return true when called for mlx5 eswitch
representor and vxlan device created explicitly on mlx5 representor
device (vxlan devices created with "external" flag without explicitly
specifying parent interface are not affected). With call to
netdev_port_same_parent_id() returning true, incorrect code path is chosen
and encap rules fail to offload because vxlan dev is not a valid eswitch
forwarding dev. Dmesg log of error:

[ 1784.389797] devices ens1f0_0 vxlan1 not on same switch HW, can't offload=
 forwarding

In order to fix the issue, rearrange conditional in parse_tc_fdb_actions()
to check for pending encap action before checking if out_dev has the same
parent id.

Fixes: 0ce1822c2a08 ("vxlan: add adjacent link to limit depth level")
Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   | 28 +++++++++----------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_tc.c
index b7889d93ddca..f90a9f8e0fc6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -3268,7 +3268,20 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *p=
riv,
=20
 			action |=3D MLX5_FLOW_CONTEXT_ACTION_FWD_DEST |
 				  MLX5_FLOW_CONTEXT_ACTION_COUNT;
-			if (netdev_port_same_parent_id(priv->netdev, out_dev)) {
+			if (encap) {
+				parse_attr->mirred_ifindex[attr->out_count] =3D
+					out_dev->ifindex;
+				parse_attr->tun_info[attr->out_count] =3D dup_tun_info(info);
+				if (!parse_attr->tun_info[attr->out_count])
+					return -ENOMEM;
+				encap =3D false;
+				attr->dests[attr->out_count].flags |=3D
+					MLX5_ESW_DEST_ENCAP;
+				attr->out_count++;
+				/* attr->dests[].rep is resolved when we
+				 * handle encap
+				 */
+			} else if (netdev_port_same_parent_id(priv->netdev, out_dev)) {
 				struct mlx5_eswitch *esw =3D priv->mdev->priv.eswitch;
 				struct net_device *uplink_dev =3D mlx5_eswitch_uplink_get_proto_dev(es=
w, REP_ETH);
 				struct net_device *uplink_upper;
@@ -3310,19 +3323,6 @@ static int parse_tc_fdb_actions(struct mlx5e_priv *p=
riv,
 				attr->dests[attr->out_count].rep =3D rpriv->rep;
 				attr->dests[attr->out_count].mdev =3D out_priv->mdev;
 				attr->out_count++;
-			} else if (encap) {
-				parse_attr->mirred_ifindex[attr->out_count] =3D
-					out_dev->ifindex;
-				parse_attr->tun_info[attr->out_count] =3D dup_tun_info(info);
-				if (!parse_attr->tun_info[attr->out_count])
-					return -ENOMEM;
-				encap =3D false;
-				attr->dests[attr->out_count].flags |=3D
-					MLX5_ESW_DEST_ENCAP;
-				attr->out_count++;
-				/* attr->dests[].rep is resolved when we
-				 * handle encap
-				 */
 			} else if (parse_attr->filter_dev !=3D priv->netdev) {
 				/* All mlx5 devices are called to configure
 				 * high level device filters. Therefore, the
--=20
2.21.0

