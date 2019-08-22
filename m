Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14FCB9A3E3
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 01:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbfHVXgo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 19:36:44 -0400
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:39558
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726823AbfHVXgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 19:36:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVQ8mhwyyfdK8d3JIPHNcGW3rbaKVVg2AxgZCso7slqmFIKU1AEY070FhOoy/5XXCRw2PlECPRRixU5fg4z/gPqUrIVHk6ixgN+llOpsVlEtdRaBW2mUGTQir1TWx54hbWAXADq0+i9nocMTx3zjIz1m5zoMIqqP+y2G6Gu7ForNLdvi8obkzbl5w7C09q2fFD3xH9dUWCeeuF1LXoWrgMcK0Z+e29UtzzVug0lAYooY27rI/jiebAunvrSiVwaG+DkHbm/o99yaf1YoG11syyQoK9pyXL7ZzKCUgx7Dt5EEvhcRdfAklWSR/W03denR4tIbDKDLgZkb9YQyRgt08A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Stpclvb9lMU/JnALQuSnh9Pl+ZLnTiTiw4FM7nTjNNk=;
 b=letAPWcfnGOBd3Tp7rdE1yoSxNOOV+XKh+CafKiBRFMI1JgiMnYdeQz3Q4gWbuaWlCqgyBzZW9tB8l2ubpYl6rdeB2SmkxbUG8j+znSjwz+UxYf+PS47H+KQ4vqTLntN7QAFSLNExjMP8UBM8tcKJeAUkBKJa5YaE9QmYN/gbmaB2pydMfHqB3wyY6bF6hOUbjD0GC2xG+1e/+yboy+ovbLeTapCE/t/yUJl6Yzx9MFqkuuMHnpAcZJhssX5V7XDPFazgB4cgFi33jGP/9bVI9ZwP4ZjH23nj8mnyEm4tmS6Yl2BjihjE+4wm2I7NTt8kjyv1FwyKVPxdx0mGGeEDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Stpclvb9lMU/JnALQuSnh9Pl+ZLnTiTiw4FM7nTjNNk=;
 b=Kc/QGCBfpfD1daNeOY/NsaActDQV/pwy7fhdG1IutwHaloVIzpTYOb5g7QRjNzkvcAHbVC2TX9LoPSBwU5BleUUSiHmSgeRLbm6uqWs47SCTIOA7PTeD+cv99hEpeve40kSyIf2hTq6JYdCLVTaXqUpGKyondpbEl5KPWt3DENQ=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2817.eurprd05.prod.outlook.com (10.172.215.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Thu, 22 Aug 2019 23:35:56 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 23:35:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 6/8] net/mlx5e: Support RSS for IP-in-IP and IPv6 tunneled
 packets
Thread-Topic: [net-next 6/8] net/mlx5e: Support RSS for IP-in-IP and IPv6
 tunneled packets
Thread-Index: AQHVWUJYnUoWxncWhEGZ73cw5Au3ow==
Date:   Thu, 22 Aug 2019 23:35:56 +0000
Message-ID: <20190822233514.31252-7-saeedm@mellanox.com>
References: <20190822233514.31252-1-saeedm@mellanox.com>
In-Reply-To: <20190822233514.31252-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0036.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::49) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 01bfdb07-2675-494b-5155-08d727597ac4
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2817;
x-ms-traffictypediagnostic: AM4PR0501MB2817:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2817093E7CB248E5F91E280EBEA50@AM4PR0501MB2817.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(346002)(39860400002)(396003)(136003)(189003)(199004)(256004)(14444005)(53936002)(14454004)(107886003)(6436002)(4326008)(8676002)(8936002)(81166006)(99286004)(81156014)(50226002)(25786009)(76176011)(316002)(54906003)(52116002)(5660300002)(71190400001)(71200400001)(186003)(386003)(66066001)(6506007)(476003)(102836004)(305945005)(1076003)(486006)(446003)(11346002)(66446008)(64756008)(66556008)(66476007)(66946007)(36756003)(6916009)(6512007)(2906002)(2616005)(26005)(3846002)(86362001)(7736002)(478600001)(6486002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2817;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +yX6LDuoGGkm6y2L1HEzxbRGpaa14SoXN8kZE+wkPjLwHIl6QbphepM8FNv51lVglBrvCYkB0CL4WU+d4u+Qryh9smSD2+m3HxT2ZRGLiqZsOAKdwzunJf7qYJUw/GmbjONs+p9PmZtRz1AteIg1Unuc0LeDfjXVzvSwfNn40pQt3XlXq0dbkgE5peuinXcqDw3ABRo/DNzegf2p4nsXY4nEqXZaejP6NUABK/7q3fXdKXrPV9UTmOwnGDFgW/6ccgIlNt13O1cFg4FS5RMP2BHDIsOeJ5l042XN5ChrLEl3bgcybg8bSBt+Q6iqPWeHbw1tZtxOJ39BXD5P3Be93a4xF0AJhN2JINDW1BVLzjGPr3ukE5NkaeBNiJ3+IdN+G/ZnyR0mMZCGB/5OSjLhqGwgz4r1BOKryiTQSdMAGBU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01bfdb07-2675-494b-5155-08d727597ac4
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 23:35:56.3312
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vQXAadR5tEN74MXiLqQpE8TzBCFoa69rLXenGt9DwWv+Afqrq6hieHbnKclmx7g1rmKPNPJbAFwcM45hcnzbPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2817
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@mellanox.com>

Add support for inner header RSS on IP-in-IP and IPv6 tunneled packets.

Add rules to the steering table regarding outer IP header, with
IPv4/6->IP-in-IP. Tunneled packets with protocol numbers: 0x4 (IP-in-IP)
and 0x29 (IPv6) are RSS-ed on the inner IP header.
Separate FW dependencies between flow table inner IP capabilities and
GRE offload support. Allowing this feature even if GRE offload is not
supported.  Tested with multi stream TCP traffic tunneled with IPnIP.
Verified that:
Without this patch, only a single RX ring was processing the traffic.
With this patch, multiple RX rings were processing the traffic.
Verified with and without GRE offload support.

Signed-off-by: Aya Levin <ayal@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en/fs.h   |  4 ++
 .../net/ethernet/mellanox/mlx5/core/en_fs.c   | 46 ++++++++++++++++++-
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/=
ethernet/mellanox/mlx5/core/en/fs.h
index 5acd982ff228..5aae3a7a5497 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -95,6 +95,10 @@ struct mlx5e_tirc_config {
 enum mlx5e_tunnel_types {
 	MLX5E_TT_IPV4_GRE,
 	MLX5E_TT_IPV6_GRE,
+	MLX5E_TT_IPV4_IPIP,
+	MLX5E_TT_IPV6_IPIP,
+	MLX5E_TT_IPV4_IPV6,
+	MLX5E_TT_IPV6_IPV6,
 	MLX5E_NUM_TUNNEL_TT,
 };
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_fs.c
index a8340e4fb0b9..b99b17957543 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -747,11 +747,52 @@ static struct mlx5e_etype_proto ttc_tunnel_rules[] =
=3D {
 		.etype =3D ETH_P_IPV6,
 		.proto =3D IPPROTO_GRE,
 	},
+	[MLX5E_TT_IPV4_IPIP] =3D {
+		.etype =3D ETH_P_IP,
+		.proto =3D IPPROTO_IPIP,
+	},
+	[MLX5E_TT_IPV6_IPIP] =3D {
+		.etype =3D ETH_P_IPV6,
+		.proto =3D IPPROTO_IPIP,
+	},
+	[MLX5E_TT_IPV4_IPV6] =3D {
+		.etype =3D ETH_P_IP,
+		.proto =3D IPPROTO_IPV6,
+	},
+	[MLX5E_TT_IPV6_IPV6] =3D {
+		.etype =3D ETH_P_IPV6,
+		.proto =3D IPPROTO_IPV6,
+	},
+
 };
=20
+static bool mlx5e_tunnel_proto_supported(struct mlx5_core_dev *mdev, u8 pr=
oto_type)
+{
+	switch (proto_type) {
+	case IPPROTO_GRE:
+		return MLX5_CAP_ETH(mdev, tunnel_stateless_gre);
+	case IPPROTO_IPIP:
+	case IPPROTO_IPV6:
+		return MLX5_CAP_ETH(mdev, tunnel_stateless_ip_over_ip);
+	default:
+		return false;
+	}
+}
+
+static bool mlx5e_any_tunnel_proto_supported(struct mlx5_core_dev *mdev)
+{
+	int tt;
+
+	for (tt =3D 0; tt < MLX5E_NUM_TUNNEL_TT; tt++) {
+		if (mlx5e_tunnel_proto_supported(mdev, ttc_tunnel_rules[tt].proto))
+			return true;
+	}
+	return false;
+}
+
 bool mlx5e_tunnel_inner_ft_supported(struct mlx5_core_dev *mdev)
 {
-	return (MLX5_CAP_ETH(mdev, tunnel_stateless_gre) &&
+	return (mlx5e_any_tunnel_proto_supported(mdev) &&
 		MLX5_CAP_FLOWTABLE_NIC_RX(mdev, ft_field_support.inner_ip_version));
 }
=20
@@ -844,6 +885,9 @@ static int mlx5e_generate_ttc_table_rules(struct mlx5e_=
priv *priv,
 	dest.type =3D MLX5_FLOW_DESTINATION_TYPE_FLOW_TABLE;
 	dest.ft   =3D params->inner_ttc->ft.t;
 	for (tt =3D 0; tt < MLX5E_NUM_TUNNEL_TT; tt++) {
+		if (!mlx5e_tunnel_proto_supported(priv->mdev,
+						  ttc_tunnel_rules[tt].proto))
+			continue;
 		rules[tt] =3D mlx5e_generate_ttc_rule(priv, ft, &dest,
 						    ttc_tunnel_rules[tt].etype,
 						    ttc_tunnel_rules[tt].proto);
--=20
2.21.0

