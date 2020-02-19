Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E64E6163AC4
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 04:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728279AbgBSDG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 22:06:29 -0500
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:44883
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728203AbgBSDG2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 22:06:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlX1C9thHtkNeLodvan4hVcq2B4DbkiZkb+HbGj0voJ9IyIXucmIHKgzqF46uTNotOD/waTynoUKjF1Vk9Wt7uTxSKjlMr5XXvPJgS+IfooRHE7yz3nGnYESc/uAK6zLDCb2Immc/rIDKq4pb+0JeMyEfetHkx5TsL6vUAWbELpUUhsAC0MKS0uF4iXg3swWFNVmN6wNL0CVx9709gfpR4b0fw9XXctRURn4GyPLap/bnkwLYyaIdaHUq+fvU53a0H3KL3wTUayRVjOkLIxTbOQLZCH59Lbbx0w+cX2ZabsBzRBXEAD4bEwhO68WaeOscngFaTfSVeD5OzRoa6udlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkYV9dNo9qm6oiUQ+eUwYsRS06FhRHHsBTwKl9+/b3E=;
 b=H6TNLF7JR6AAbz9IjSg3fUKDZmGnnSzwS/nVSkFlnpc00KXMm8VSs37mKkBTRlvgK0BoAd7gZiK1Zb9lqAOBeiE+CkJ0TyXRVDiEZY7QGCP93qgabTedezCm2wIpz3BMA2jwNNXDO0oK22sVqbT22iTOFWewOGmm1mfnghwPHyzbRY6mfO+bwzolk5raxtHdsAZSVbekEegDS0U+cYXovpS4SrWIdj4nnV1UgjPZZCMZt5qE+qD5qZGUCsQ37RtKVWqKABFM80MuSKr76iYfN6gaemTamCMuJjeb4UdJn07dbeHAU6ychdfe1/HpyuLs9jVAgfLuwvgq/j/RSms9jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xkYV9dNo9qm6oiUQ+eUwYsRS06FhRHHsBTwKl9+/b3E=;
 b=Qp1WBjsFd7A56/wFySPVAlTkyQnzISake5+8+7BuJqN+FPZ8/AMM5hc/ws4y360dCZZqmlt6JxviYYJ53IBBkcCDf8bjGdj+IZONCCu8K5tIsWQzT3vfRe4HVsk1OgCp777Sd9GxVXciyWypE3HQBAkqAQmAKhpv6BymKb3ZxPo=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5853.eurprd05.prod.outlook.com (20.178.125.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.25; Wed, 19 Feb 2020 03:06:23 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.028; Wed, 19 Feb 2020
 03:06:23 +0000
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0089.namprd05.prod.outlook.com (2603:10b6:a03:e0::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.6 via Frontend Transport; Wed, 19 Feb 2020 03:06:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Huy Nguyen <huyn@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/7] net/mlx5: Fix sleep while atomic in mlx5_eswitch_get_vepa
Thread-Topic: [net 1/7] net/mlx5: Fix sleep while atomic in
 mlx5_eswitch_get_vepa
Thread-Index: AQHV5tGQ42IhwEODjEaGp70Cf+rnCQ==
Date:   Wed, 19 Feb 2020 03:06:23 +0000
Message-ID: <20200219030548.13215-2-saeedm@mellanox.com>
References: <20200219030548.13215-1-saeedm@mellanox.com>
In-Reply-To: <20200219030548.13215-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR05CA0089.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b94ed09d-20d7-4200-1ca4-08d7b4e8b308
x-ms-traffictypediagnostic: VI1PR05MB5853:|VI1PR05MB5853:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB58538E1DBE0E8BDB23740E44BE100@VI1PR05MB5853.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0318501FAE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(396003)(39860400002)(366004)(346002)(189003)(199004)(956004)(2616005)(5660300002)(26005)(16526019)(81166006)(52116002)(4326008)(110136005)(316002)(6506007)(186003)(81156014)(2906002)(8936002)(66476007)(8676002)(54906003)(1076003)(64756008)(6512007)(71200400001)(478600001)(66556008)(66446008)(86362001)(36756003)(6486002)(107886003)(66946007)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5853;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 5rpPRAlov+9O1bHB52gJ6lSDgl8bVVWaz+jV6keWzmIhFvmuAgHWgeZyxXAkPY+0Ng3ikD5JOhVv5IDRVceaRfyhd483jLhlbtSVjwF8Sa8jSIBLoGWtnNdjkdHsPu4d5nnYMTxkLz89+gX1voJjYAHdGH3VHneTWhJGw8BvpHPvUmed06UN1sxFeclo6/VW+696vAXfam+kRhsButTAVHiztHDliETqK++RHfEPDpukUR+T1VxMsExqleJxdhl1VvCZdK7Qywkektc0UVGOg3VYE1IuWxkybEQzZ/Hu0mDVBQCmA1HJP9cRaP8ftuoslZbSMkkrIBZjHLy9pb1YhhUgR57pVCVK8wx468R0ZW6AGZnzqnEhrUM/bDEAatFfYU7h8s9YOfPD4mTMSdnnYzFBykoI6kREt+1vNDiXI8u3cNzA+t7r9Tsjd2BH+S51zDlhB1w0pw+ValuG4d5S7RA0xZTwQLdPmS9fHU6SUUfl9CF3/et7qGAC5TmhDpNMv4w3Bv+KWujk+hjmLG2jQJSR8vCd+3YrwS3XmBFaUCE=
x-ms-exchange-antispam-messagedata: /FXAGFDDjm/Kqp9aOD1eWmIM3f2+XnoNB1tz7FvAYbLzzSVer2G00oz88ezjKBtzAfnPKmioV0fTy8LhyrGVZuJYSdJXHkYXJHzDWF57MmUK6ckjqNlEstji86qIrS/5P7QqmavDHHeBvsjGdcXXzw==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b94ed09d-20d7-4200-1ca4-08d7b4e8b308
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Feb 2020 03:06:23.0697
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: esHLdNDTNhSPqre2pN1ym49Z5FTOjrXF1FZtJ4UBrWAQyWdTmU5sml/N7YNQYzzTh4CUCH5AhQG/eiJp0oaCPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5853
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Huy Nguyen <huyn@mellanox.com>

rtnl_bridge_getlink is protected by rcu lock, so mlx5_eswitch_get_vepa
cannot take mutex lock. Two possible issues can happen:
1. User at the same time change vepa mode via RTM_SETLINK command.
2. User at the same time change the switchdev mode via devlink netlink
interface.

Case 1 cannot happen because rtnl executes one message in order.
Case 2 can happen but we do not expect user to change the switchdev mode
when changing vepa. Even if a user does it, so he will read a value
which is no longer valid.

Fixes: 8da202b24913 ("net/mlx5: E-Switch, Add support for VEPA in legacy mo=
de.")
Signed-off-by: Huy Nguyen <huyn@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 5acf60b1bbfe..564d42605892 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2452,25 +2452,17 @@ int mlx5_eswitch_set_vepa(struct mlx5_eswitch *esw,=
 u8 setting)
=20
 int mlx5_eswitch_get_vepa(struct mlx5_eswitch *esw, u8 *setting)
 {
-	int err =3D 0;
-
 	if (!esw)
 		return -EOPNOTSUPP;
=20
 	if (!ESW_ALLOWED(esw))
 		return -EPERM;
=20
-	mutex_lock(&esw->state_lock);
-	if (esw->mode !=3D MLX5_ESWITCH_LEGACY) {
-		err =3D -EOPNOTSUPP;
-		goto out;
-	}
+	if (esw->mode !=3D MLX5_ESWITCH_LEGACY)
+		return -EOPNOTSUPP;
=20
 	*setting =3D esw->fdb_table.legacy.vepa_uplink_rule ? 1 : 0;
-
-out:
-	mutex_unlock(&esw->state_lock);
-	return err;
+	return 0;
 }
=20
 int mlx5_eswitch_set_vport_trust(struct mlx5_eswitch *esw,
--=20
2.24.1

