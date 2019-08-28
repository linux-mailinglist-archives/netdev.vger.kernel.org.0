Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 545FDA0A18
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbfH1S56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:57:58 -0400
Received: from mail-eopbgr10058.outbound.protection.outlook.com ([40.107.1.58]:44526
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726836AbfH1S55 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 14:57:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jm6D0e+inXrt45NFi0hMKjln3lGEWbOHxFKjOwAknyxh2QgUdWEweIxU32Kra/hReA+FQA7GKWodeDO7oKkLE7x4osWnZj0EFbPFDVUJyvwrv5gmyFAIf57fBaQYqlphwd+rgEfFv4Bw2ZuLntI8UlG0y4b0jfWtAwjhxzPDIlpCrZluBo+e8mIqXmcUnFaxuQOt8E+ohxVdA7iWneyFcvtIrLD93vtFRIojtFS5sox182unh7t+1t23oI2e47I3JraPRIuuwqUr0s23C4IpcMP7ighCQHnF5cKlqzFx5PncOfLx7seZOqWfnnZ87orF9H/y/UbrKTJMkJLepXMgyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Stpclvb9lMU/JnALQuSnh9Pl+ZLnTiTiw4FM7nTjNNk=;
 b=BHwf0tkEdEukATCCkrG+v2CKDF+IuQ9s6r21okWcs40rGi6xGunKYEBY7eWO1iq3x/L499u0B/dE5OE13cQLqYBePoqQ8zGqPj0cIhnGO6u0wum9GLpWarOQU+KEWZ1VSddmKLKlQUsbQFDJ2gW94nKc93mLbABmaLQR4r77W0C0gfimIpvtZwHlQ1/WwLagV4gMzliWC9/98ndRZ0lQOoIwTQpe9V2pl5lWte+ILt425/NOeIFIVdZpLmcelTQncoPDer2mOHbMto/PMDiAHgr+TCBguqfvfTQUZw3bdku+m7oaw6ijK7PdEgMDr/zK42MmmQHLGB5/Cqwy8TL7sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Stpclvb9lMU/JnALQuSnh9Pl+ZLnTiTiw4FM7nTjNNk=;
 b=SLrnB+m+tyCB2dHc4tkTeYQZfkfYmfHimiil4pl6BMsgpi4yGNbB4jbfmYJ6/r0yBTDcIStrE7RkIXsRGqP6JvVtQep8gNDyvJ4Y5kXXvmq9/xOb7xb9pCFsbeYhxiWBLwSvHpo7R9X0R5ZsoZtf0bOk6cguCsmqk4lXYZeuChA=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2751.eurprd05.prod.outlook.com (10.172.82.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 18:57:52 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 18:57:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Aya Levin <ayal@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 6/8] net/mlx5e: Support RSS for IP-in-IP and IPv6
 tunneled packets
Thread-Topic: [net-next v2 6/8] net/mlx5e: Support RSS for IP-in-IP and IPv6
 tunneled packets
Thread-Index: AQHVXdJ+nxDh3Z7DfEKlS5f7hlj/Iw==
Date:   Wed, 28 Aug 2019 18:57:51 +0000
Message-ID: <20190828185720.2300-7-saeedm@mellanox.com>
References: <20190828185720.2300-1-saeedm@mellanox.com>
In-Reply-To: <20190828185720.2300-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0069.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::46) To VI1PR0501MB2765.eurprd05.prod.outlook.com
 (2603:10a6:800:9a::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8579de16-9306-49e8-9a1e-08d72be9a05d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2751;
x-ms-traffictypediagnostic: VI1PR0501MB2751:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB27515C245DA274506E7A687BBEA30@VI1PR0501MB2751.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(199004)(189003)(66446008)(99286004)(81166006)(6506007)(386003)(81156014)(86362001)(8676002)(26005)(6116002)(2906002)(71200400001)(25786009)(76176011)(1076003)(102836004)(71190400001)(36756003)(186003)(7736002)(66066001)(107886003)(8936002)(52116002)(256004)(14444005)(64756008)(4326008)(54906003)(478600001)(316002)(14454004)(6916009)(50226002)(5660300002)(3846002)(66946007)(6436002)(11346002)(6486002)(6512007)(446003)(486006)(2616005)(476003)(66476007)(53936002)(66556008)(305945005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2751;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: WMiFXsOgKhTqAbYFOIxSIiKpZSTFvdmToTMPms3BeLm5/OULelyVTmc84+1FYW26uGBDwkxZJrksz5deDGhhsVfH288UlBafRLYRruhUI7nu9bXj6hwiIchyBtPUPzFlb2u6auIGSKgVNpUMyDylxLojsgbZXJvQibnv7SuTwxIa+GrA+P+9isM26ZR8wAfgU9QzklGzCyaqoSDW7e9M/5m/ZYfizRx7cg8UkPs1847pxhw+o7vBM3ZtmN72Em2azwVj7MEfoHlRP9uuHwY82pE1DFBsf3N7fyQ6bESdT/PEf/DDP/vEhIEzeTxp5Lv9XoQj7w6LOdbTKhG1YgPFygrHm4xM+Msvtce6PT7wGKLfPCLUmpqeS8xYd0q5BISjMYHUsT9D+lRawXkdXMuwwbSLHohVOPKe8N+df5fqKHU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8579de16-9306-49e8-9a1e-08d72be9a05d
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 18:57:51.7796
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fjrafORlNbAD6iJ3IHWQpFa+XGh569hMRfHPWuAgT/rOoChV4Ri7pnRyhYrm1Qsjhl33/K6Aht2Kw0aHIVN0dg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2751
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

