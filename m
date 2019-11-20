Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDA9210453F
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKTUgt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:36:49 -0500
Received: from mail-eopbgr20048.outbound.protection.outlook.com ([40.107.2.48]:53742
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726722AbfKTUgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:36:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H0AZlLy8J6EesfJa0lpBDlDDhBf0woERTy26YBlvHrtBiaPB5g61Rbik3NlkpEOhOH0+bJX7vd6T2mGeWD44I/bfQHyF9+SJjfxw9L+0HLHtszWm1LaFP+b05anBgEadmgeHNstZefhJpKuiYgQKTQp2ZZYNrUzn5Va7xrFLAzusMsVjDr8kJJJDdKmFfzjO/w7lFX5P7q8wVllwvFTfW67zD1Pvor1oBjq8mR5GLCvoSbc/Kfr2Wa+dD1yeEg/wcf5XDGrMA1TQn7cdOR+AK1XZN/OB6L4BW8VrU1HaHiN3+6tvfwWdISu3QOtpQsN+HDfO6XKHzdJasXz5JdNBkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZW/YNQDjdcwdXhrdjitq8U/xf/DVl0Cwppb3iT0saD0=;
 b=MBwDi1vBSk8mRg/X1uf1JJYqHBUHgYkSXB0t+Es85T/kpZU2/xHI43hLkERXZeM4KkQncjjTEI47kNREhVoV5QQewxzJAOgJaeR4L/Wl4Qcfvi0goOGCUsGhs3Q88iAbnrjHDeyhZc8Fq+VwFHi2a/gR2l351z5VgdMBaJgK/NBGXZWBC+x9thDqfgP0BmYtJd/naeXJu+eTNC4O0yFvwpguK4wJK5iOhXzElzqXA3JkI/k37wQFvbQU6PpfRtDFl+tbC3CBLuMoRVpBO9wxMOKtlgTUHX2cpvpHqwXppN1DDvfsFgrlmLZuAIJBEhQUVPpcTqhc4bw/mXs9HJElHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZW/YNQDjdcwdXhrdjitq8U/xf/DVl0Cwppb3iT0saD0=;
 b=X+G9G7Ym3uGOd4o/F1xJSZ+WY7HO5guhZftspElIdjOOpQERv8qgfydc60xYpW4mVVPcxSYt6Yacxf6ZnXxdV8T11ORt1v56heMWlCXKjvCCHy94cwHQM+DFGd1aKtTD1inpKL4pVT3xprIlhOXmfIdPL1J8ecazeqU3PLbcww8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:35:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:35:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 08/12] net/mlx5e: Do not use non-EXT link modes in EXT mode
Thread-Topic: [net 08/12] net/mlx5e: Do not use non-EXT link modes in EXT mode
Thread-Index: AQHVn+IcJKpMN3NXb0m/zslGww/V7g==
Date:   Wed, 20 Nov 2019 20:35:57 +0000
Message-ID: <20191120203519.24094-9-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 6c9ec6f8-4a97-4b7a-ad31-08d76df93f23
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6110285C2E7762CA54EBB7EDBE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(14444005)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M7frtrQSF6uuK4t4rLtXpLL5hOStANcbLQ/oUnw/fOSGVvq/mEL3Y5WE+Tl71vtzgODFLJUgtNyKT0zs3ZGAIKB2v//RsMBoxWCH+K/fmi23HRZbp5O3cKCXdyqMVYwI4dbgP5bTYmuCSwkgeV5V5yo6QfZaLg5ezuHDPF8vLBERyxNfuvWmJ4ahULJgG6BndFWhmm9eHQVc+9+PMguRxmB4OrbvugH0AP8/sXFl+dEq3X+Nb+xVlYttSApzMXd59G6fypfpjJBBMvC9JGq3wJtQkOHk2joRBESC30nuDInjbvji2+idVP2ZKRkxEmdGq29skY3bOrGv+c8sDZVMqmQlv+FnG6hz8C1L0vgvJILFW1W/L7/ZZdix9Ooeji+Yh2jxfk4dtlz+w7l4DAIaUGaUT8fBYCdWI6JZTszd/NmHFq8wcljW4CDmo0ihZ/91
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c9ec6f8-4a97-4b7a-ad31-08d76df93f23
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:35:57.3159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZrBJcxX6VPdBDwZg7Sed3vmdySPeXsoJTvoXLm/7bVDPK/amVGt9b7ftIX9OXFE8PfMqM59BVpt7g8aYij5fMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@mellanox.com>

On some old Firmwares, connector type value was not supported, and value
read from FW was 0. For those, driver used link mode in order to set
connector type in link_ksetting.

After FW exposed the connector type, driver translated the value to ethtool
definitions. However, as 0 is a valid value, before returning PORT_OTHER,
driver run the check of link mode in order to maintain backward
compatibility.

Cited patch added support to EXT mode.  With both features (connector type
and EXT link modes) ,if connector_type read from FW is 0 and EXT mode is
set, driver mistakenly compare EXT link modes to non-EXT link mode.
Fixed that by skipping this comparison if we are in EXT mode, as connector
type value is valid in this scenario.

Fixes: 6a897372417e ("net/mlx5: ethtool, Add ethtool support for 50Gbps per=
 lane link modes")
Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
Reviewed-by: Aya Levin <ayal@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c b/drivers=
/net/ethernet/mellanox/mlx5/core/en_ethtool.c
index 327c93a7bd55..95601269fa2e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_ethtool.c
@@ -708,9 +708,9 @@ static int get_fec_supported_advertised(struct mlx5_cor=
e_dev *dev,
=20
 static void ptys2ethtool_supported_advertised_port(struct ethtool_link_kse=
ttings *link_ksettings,
 						   u32 eth_proto_cap,
-						   u8 connector_type)
+						   u8 connector_type, bool ext)
 {
-	if (!connector_type || connector_type >=3D MLX5E_CONNECTOR_TYPE_NUMBER) {
+	if ((!connector_type && !ext) || connector_type >=3D MLX5E_CONNECTOR_TYPE=
_NUMBER) {
 		if (eth_proto_cap & (MLX5E_PROT_MASK(MLX5E_10GBASE_CR)
 				   | MLX5E_PROT_MASK(MLX5E_10GBASE_SR)
 				   | MLX5E_PROT_MASK(MLX5E_40GBASE_CR4)
@@ -842,9 +842,9 @@ static int ptys2connector_type[MLX5E_CONNECTOR_TYPE_NUM=
BER] =3D {
 		[MLX5E_PORT_OTHER]              =3D PORT_OTHER,
 	};
=20
-static u8 get_connector_port(u32 eth_proto, u8 connector_type)
+static u8 get_connector_port(u32 eth_proto, u8 connector_type, bool ext)
 {
-	if (connector_type && connector_type < MLX5E_CONNECTOR_TYPE_NUMBER)
+	if ((connector_type || ext) && connector_type < MLX5E_CONNECTOR_TYPE_NUMB=
ER)
 		return ptys2connector_type[connector_type];
=20
 	if (eth_proto &
@@ -945,9 +945,9 @@ int mlx5e_ethtool_get_link_ksettings(struct mlx5e_priv =
*priv,
 	eth_proto_oper =3D eth_proto_oper ? eth_proto_oper : eth_proto_cap;
=20
 	link_ksettings->base.port =3D get_connector_port(eth_proto_oper,
-						       connector_type);
+						       connector_type, ext);
 	ptys2ethtool_supported_advertised_port(link_ksettings, eth_proto_admin,
-					       connector_type);
+					       connector_type, ext);
 	get_lp_advertising(mdev, eth_proto_lp, link_ksettings);
=20
 	if (an_status =3D=3D MLX5_AN_COMPLETE)
--=20
2.21.0

