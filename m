Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A64A0A1C
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 20:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfH1S6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 14:58:08 -0400
Received: from mail-eopbgr50073.outbound.protection.outlook.com ([40.107.5.73]:26958
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727004AbfH1S6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Aug 2019 14:58:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RJ5UxuL7XLZieBWYkXmWdfQhDzDU/yLEsd/iyI25+7A0ncnI71WszxEnI175ay/aCxnYQTtf+J77X02/CgqTLas75LnOaC8pY6wR5RgEE+I2fkGhDWqQJNo43SIRegvGum4EStb4aWsY0hKFiYmWuS15FCKTJuCyiuNlHzKQ+USeByo8T/vTYN97ULKuR6jjk2nwtgW9jC27CzQoYY2d3U1tOl9a4K/EtSKO7DMM2lXSRm/feHcsTfgMT2k5c4nBCi0qko3+E5ZsmyrbA/mpLRTgzUdgw/esmdfqIuLq2Ib8HYvDSASy8I8Q2cQOZZG5p9WM6Ux8l1TreRQT0xGV/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osVGCURc4ZTGgXqZnka6ErWstaEuIAGAt/KI3m4ij5w=;
 b=CW0CsUjc/HqaKxHAlFuv8ITC1yTVrm98jaU+Z87iFKXt9cNXlBTMHw28cIpxTBWz2bcuCEfp4nabc0+elGY+Sq5CecArv57ukE7fvL68p7DNVOVuf9TxHYHXtFk9fdfyH8WyTH0QPz+yfKsbHL5/e5SGcKCl2nM5gio95Rm3mNX9WfzYhkFCUzfpaFZZUKcCBz4I+AI5U9gbcMnK7Tm/s8JgE6M7lE6fATq6yeOcP2PuUDsWwnu2neywJUlzN+wngMjttaDPKJYVfTXhP+CyzDYSNUpKQZRiih+9Wna+JMpJeOqN4gIVgokjQ8vh/7WjQfCPKE9VjTns2jf1FUleKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=osVGCURc4ZTGgXqZnka6ErWstaEuIAGAt/KI3m4ij5w=;
 b=Twswy+3CJS/SVzM3TEce0H9zilEj5MCyVyqFTy8alqHN72/b5crBzeb7dBGHg8YjMYnro/cBUHaq/VMXASOWoQDUY7CGzVj5p1chR3Z2XE0OahaVeeqi3lXibxRa/cY5qJq/OECxX9vARjxXFbHiyIggcS7gBfZ8PJ/n1/c95k8=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2638.eurprd05.prod.outlook.com (10.172.80.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Wed, 28 Aug 2019 18:57:47 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::5cab:4f5c:d7ed:5e27%6]) with mapi id 15.20.2199.021; Wed, 28 Aug 2019
 18:57:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 4/8] net/mlx5e: Add device out of buffer counter
Thread-Topic: [net-next v2 4/8] net/mlx5e: Add device out of buffer counter
Thread-Index: AQHVXdJ74yJNDVRKWUKx5FlhsPiA8g==
Date:   Wed, 28 Aug 2019 18:57:47 +0000
Message-ID: <20190828185720.2300-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: a9ec0fbc-081c-4e6f-a56e-08d72be99dd2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2638;
x-ms-traffictypediagnostic: VI1PR0501MB2638:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2638A1F13CB7F03C9D50D110BEA30@VI1PR0501MB2638.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2150;
x-forefront-prvs: 014304E855
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(346002)(396003)(39860400002)(189003)(199004)(8676002)(6512007)(107886003)(6486002)(54906003)(1076003)(25786009)(3846002)(316002)(186003)(8936002)(5660300002)(6116002)(53936002)(81156014)(6436002)(478600001)(86362001)(14454004)(2906002)(6916009)(4326008)(81166006)(36756003)(7736002)(50226002)(66446008)(305945005)(256004)(66946007)(486006)(476003)(11346002)(2616005)(66066001)(446003)(66556008)(66476007)(71200400001)(52116002)(26005)(6506007)(386003)(102836004)(14444005)(71190400001)(76176011)(64756008)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2638;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 5sSqBNJudWFxFCxvOXFR34YIHikGmoSUYY6qtus8ZdRX+umWLozuH0IT9YP1vLfO7SrYkFZixNf0RBiSYkOp9EZZozVdy20PZKp4RZxIjcjjOCkJqMD4B+Bcu0NCcHkwmgOQqZ+JmWSyeT2a+OYWuHU4iArH627C96OpZnAxs+Etdk4J+xPgvvr5pluAOxk2yvUUeMLFA7YcmUHz/rsQKnPFeqEaA8ijX4jWjs5VHWruGbAlLkh7GhZCtElmjH7YX4f61CAC3dFoyoPWvOb6NTVVkAU+w4YFdXg9K80YET2W4Bw8vejjafnDqCV42iJkbsf6l4Efst/46go+RCSxiAYT5dKZKvtfJmW4827xXqhT44Zoj7GrKg28Yv0S9a1HSVpIurxTk7MKlEb/hfs3DXt1Btn+DqCgtYeQ4ikU5FQ=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9ec0fbc-081c-4e6f-a56e-08d72be99dd2
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Aug 2019 18:57:47.5035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2ksw7ZAfpU8LxyqPAFcEWXWWLdbNDoiSE0bLA7qdeNY/IWeL08Q/bbimDuIzMnwc2d5hC6UIb5Kkz1PLhuRBWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

Added the following packets drop counter:
Device out of buffer - counts packets which were dropped due to full
device internal receive queue.
This counter will be shown on ethtool as a new counter called
dev_out_of_buffer.
The counter is read from FW by command QUERY_VNIC_ENV.

Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../ethernet/mellanox/mlx5/core/en_stats.c    | 38 ++++++++++++-------
 1 file changed, 25 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c b/drivers/n=
et/ethernet/mellanox/mlx5/core/en_stats.c
index 18e4c162256a..f1065e78086a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_stats.c
@@ -369,17 +369,27 @@ static void mlx5e_grp_q_update_stats(struct mlx5e_pri=
v *priv)
 }
=20
 #define VNIC_ENV_OFF(c) MLX5_BYTE_OFF(query_vnic_env_out, c)
-static const struct counter_desc vnic_env_stats_desc[] =3D {
+static const struct counter_desc vnic_env_stats_steer_desc[] =3D {
 	{ "rx_steer_missed_packets",
 		VNIC_ENV_OFF(vport_env.nic_receive_steering_discard) },
 };
=20
-#define NUM_VNIC_ENV_COUNTERS		ARRAY_SIZE(vnic_env_stats_desc)
+static const struct counter_desc vnic_env_stats_dev_oob_desc[] =3D {
+	{ "dev_internal_queue_oob",
+		VNIC_ENV_OFF(vport_env.internal_rq_out_of_buffer) },
+};
+
+#define NUM_VNIC_ENV_STEER_COUNTERS(dev) \
+	(MLX5_CAP_GEN(dev, nic_receive_steering_discard) ? \
+	 ARRAY_SIZE(vnic_env_stats_steer_desc) : 0)
+#define NUM_VNIC_ENV_DEV_OOB_COUNTERS(dev) \
+	(MLX5_CAP_GEN(dev, vnic_env_int_rq_oob) ? \
+	 ARRAY_SIZE(vnic_env_stats_dev_oob_desc) : 0)
=20
 static int mlx5e_grp_vnic_env_get_num_stats(struct mlx5e_priv *priv)
 {
-	return MLX5_CAP_GEN(priv->mdev, nic_receive_steering_discard) ?
-		NUM_VNIC_ENV_COUNTERS : 0;
+	return NUM_VNIC_ENV_STEER_COUNTERS(priv->mdev) +
+		NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev);
 }
=20
 static int mlx5e_grp_vnic_env_fill_strings(struct mlx5e_priv *priv, u8 *da=
ta,
@@ -387,12 +397,13 @@ static int mlx5e_grp_vnic_env_fill_strings(struct mlx=
5e_priv *priv, u8 *data,
 {
 	int i;
=20
-	if (!MLX5_CAP_GEN(priv->mdev, nic_receive_steering_discard))
-		return idx;
+	for (i =3D 0; i < NUM_VNIC_ENV_STEER_COUNTERS(priv->mdev); i++)
+		strcpy(data + (idx++) * ETH_GSTRING_LEN,
+		       vnic_env_stats_steer_desc[i].format);
=20
-	for (i =3D 0; i < NUM_VNIC_ENV_COUNTERS; i++)
+	for (i =3D 0; i < NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev); i++)
 		strcpy(data + (idx++) * ETH_GSTRING_LEN,
-		       vnic_env_stats_desc[i].format);
+		       vnic_env_stats_dev_oob_desc[i].format);
 	return idx;
 }
=20
@@ -401,12 +412,13 @@ static int mlx5e_grp_vnic_env_fill_stats(struct mlx5e=
_priv *priv, u64 *data,
 {
 	int i;
=20
-	if (!MLX5_CAP_GEN(priv->mdev, nic_receive_steering_discard))
-		return idx;
-
-	for (i =3D 0; i < NUM_VNIC_ENV_COUNTERS; i++)
+	for (i =3D 0; i < NUM_VNIC_ENV_STEER_COUNTERS(priv->mdev); i++)
 		data[idx++] =3D MLX5E_READ_CTR64_BE(priv->stats.vnic.query_vnic_env_out,
-						  vnic_env_stats_desc, i);
+						  vnic_env_stats_steer_desc, i);
+
+	for (i =3D 0; i < NUM_VNIC_ENV_DEV_OOB_COUNTERS(priv->mdev); i++)
+		data[idx++] =3D MLX5E_READ_CTR32_BE(priv->stats.vnic.query_vnic_env_out,
+						  vnic_env_stats_dev_oob_desc, i);
 	return idx;
 }
=20
--=20
2.21.0

