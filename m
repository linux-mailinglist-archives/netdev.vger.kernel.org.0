Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64C9EE3C17
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 21:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393021AbfJXTiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 15:38:50 -0400
Received: from mail-eopbgr140041.outbound.protection.outlook.com ([40.107.14.41]:7745
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387655AbfJXTit (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Oct 2019 15:38:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yx8IGDpAT0gLuGHJU/5QEznaNgHe15NiTjdiyBybYrzJmFL3Fq8d55ZvKkcaFTrS6CuGBZRURJgxA3RSkFU7PH1xBDyPGVJEiWgV+IXCeXorJaAMyhCNmwS65BvGZSOB28GLjEp+pF1QuDQI+MEr59MMCugw3B1RjWMlu+2TNOpy7KCJXDUt/UOpdDU+nF59uQeNM3+wZW57Tvld7dFNeSJaRZB3TOY2fRwSsjE2zjPRvTbgx0QKJncTtfXRV49FAhN5J4J27rSghk86UIEvhIRA/iXxa+QVa4jDIKirdgmDbkR5iCGxccb3C3man9KarfTs8sNHhtHXHGL62cJAlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gEnkdy6hoGumI7fXtARHMo7Wu1sus6zxdjwXW4mRN0=;
 b=c1NtTv1VxTsxSI9g9KDgqhmANax3GBG2zQ36tjvvz4fTd4j+SdxbdtMjfV056ue+4kFZo/Xc8oZqtuH4/Vw/UwsW/Tzk+fgOStwbJIMUFsfnE2TTnr5IwyELkZpBbcg85yxQpkXQA/C6aUYDhPHgogxavYnbHgjXgrLG8hQON+A+XeBY0jLISOaBa22+oX9ZDvaJJeCDOzOA5PYuwotLN4igoKsJheNLxPJRIFGd1tdKVpYuu1jr8pgMUNwBIf8hgTnqfK5f3TTUqLifuLU7hpTj54i1wGbAgkbakOjFkBQgB2Ua4CuG7og4StWDuVTFV5B7MtDji+Ov3kZ7xrJL0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1gEnkdy6hoGumI7fXtARHMo7Wu1sus6zxdjwXW4mRN0=;
 b=KmVUThucQxa/imSNDj/ObDOl0vSeF3u4NbWkgYDeBGTJkkrcyCf//SnKGLL+xFMrYQyKIZkMDVOC2n5bFgONlTKSGKweW0cZONpF4l0mFxPmNw31eHwx6+kk17bW48obOJddutBQGy53TDyfOjwuAmOAd+nLWw/B+MsCsUDSUh0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4623.eurprd05.prod.outlook.com (20.176.8.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 24 Oct 2019 19:38:45 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.030; Thu, 24 Oct 2019
 19:38:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmytro Linkin <dmitrolin@mellanox.com>,
        Jianbo Liu <jianbol@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 02/11] net/mlx5e: Determine source port properly for vlan push
 action
Thread-Topic: [net 02/11] net/mlx5e: Determine source port properly for vlan
 push action
Thread-Index: AQHViqKlBoDPn6EiDEOAvDMXy2U9WA==
Date:   Thu, 24 Oct 2019 19:38:44 +0000
Message-ID: <20191024193819.10389-3-saeedm@mellanox.com>
References: <20191024193819.10389-1-saeedm@mellanox.com>
In-Reply-To: <20191024193819.10389-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0018.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8a62da24-cd8e-45c5-e9c8-08d758b9c81e
x-ms-traffictypediagnostic: VI1PR05MB4623:|VI1PR05MB4623:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB462390A509F9DDF3AB4652A7BE6A0@VI1PR05MB4623.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-forefront-prvs: 0200DDA8BE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(6486002)(8936002)(316002)(478600001)(50226002)(81166006)(81156014)(256004)(14444005)(7736002)(8676002)(305945005)(2906002)(52116002)(6512007)(54906003)(5660300002)(99286004)(186003)(476003)(486006)(102836004)(4326008)(6506007)(386003)(11346002)(6916009)(26005)(107886003)(6116002)(76176011)(3846002)(14454004)(66066001)(36756003)(66946007)(6436002)(446003)(86362001)(1076003)(71200400001)(25786009)(66476007)(64756008)(66446008)(66556008)(2616005)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4623;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9ezKSLMBMkpJh6m+Mo1wIwV6bB/nrK+kE1AzgjplNczkLHCcln17lBj0C3rzZ0uj9Mb2pfSlZbXztxUbMbH0RDpLUU22lbxk9vFsgHQoEoS3+hoiRj17/WNfay8u5u6pQdFd8gl2yO/oYvYPRWBE6qmYGwvVoGUdDjLPz/9sXIGXJSieTn18aAaDAonMA/DxWBVeiT1crbod1LzH++tP35uXY2EPFxXFxpah7ordeoftnBghjyv7BEnAUyfftgMMLWX08JBCJqB+e73zErXH/X9zXs+3yfqUVg567sdCLXQZ/Dpj1Iq8+USnRUfZMwzc5ogAto3LVoMIVtAXF02044lSoxXvE9iJoJxN7l1/V67ejZfecVp/BHdw1cndUphT8mzZABK1hvT2iOoAufcfbhRqtXJTtTN+ov2oAUv+GtS/L54IuXJKge9lwRmrwxyd
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a62da24-cd8e-45c5-e9c8-08d758b9c81e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2019 19:38:44.7996
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yBpNmsTTl6P7D7Li15fPNjkz8bQf4q+j7CYGlOJeZIn3mywn4okz0NlBtAv1bVKB3OTrS1Yk8WZwKbBwkswv5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4623
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dmytro Linkin <dmitrolin@mellanox.com>

Termination tables are used for vlan push actions on uplink ports.
To support RoCE dual port the source port value was placed in a register.
Fix the code to use an API method returning the source port according to
the FW capabilities.

Fixes: 10caabdaad5a ("net/mlx5e: Use termination table for VLAN push action=
s")
Signed-off-by: Dmytro Linkin <dmitrolin@mellanox.com>
Reviewed-by: Jianbo Liu <jianbol@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mlx5/core/eswitch_offloads_termtbl.c      | 22 ++++++++++++++-----
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termt=
bl.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
index 1d55a324a17e..7879e1746297 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c
@@ -177,22 +177,32 @@ mlx5_eswitch_termtbl_actions_move(struct mlx5_flow_ac=
t *src,
 	memset(&src->vlan[1], 0, sizeof(src->vlan[1]));
 }
=20
+static bool mlx5_eswitch_offload_is_uplink_port(const struct mlx5_eswitch =
*esw,
+						const struct mlx5_flow_spec *spec)
+{
+	u32 port_mask, port_value;
+
+	if (MLX5_CAP_ESW_FLOWTABLE(esw->dev, flow_source))
+		return spec->flow_context.flow_source =3D=3D MLX5_VPORT_UPLINK;
+
+	port_mask =3D MLX5_GET(fte_match_param, spec->match_criteria,
+			     misc_parameters.source_port);
+	port_value =3D MLX5_GET(fte_match_param, spec->match_value,
+			      misc_parameters.source_port);
+	return (port_mask & port_value & 0xffff) =3D=3D MLX5_VPORT_UPLINK;
+}
+
 bool
 mlx5_eswitch_termtbl_required(struct mlx5_eswitch *esw,
 			      struct mlx5_flow_act *flow_act,
 			      struct mlx5_flow_spec *spec)
 {
-	u32 port_mask =3D MLX5_GET(fte_match_param, spec->match_criteria,
-				 misc_parameters.source_port);
-	u32 port_value =3D MLX5_GET(fte_match_param, spec->match_value,
-				  misc_parameters.source_port);
-
 	if (!MLX5_CAP_ESW_FLOWTABLE_FDB(esw->dev, termination_table))
 		return false;
=20
 	/* push vlan on RX */
 	return (flow_act->action & MLX5_FLOW_CONTEXT_ACTION_VLAN_PUSH) &&
-		((port_mask & port_value) =3D=3D MLX5_VPORT_UPLINK);
+		mlx5_eswitch_offload_is_uplink_port(esw, spec);
 }
=20
 struct mlx5_flow_handle *
--=20
2.21.0

