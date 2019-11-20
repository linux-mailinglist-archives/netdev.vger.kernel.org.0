Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4A2104534
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfKTUgH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:36:07 -0500
Received: from mail-eopbgr20048.outbound.protection.outlook.com ([40.107.2.48]:53742
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725815AbfKTUgG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:36:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iEdQCwEFeL8E6vLEEFIN51wfSq5GVoLiFrhIJhS19xZhA/1LGKH63LwJPFqCFumkOUTfcRfxWq97957I6uRmAXJmXp0KWPE14UWpsO6W8USVqev9JUFDfkoCDPmbE5dY6Yc5FR6tbiDqM3K22uypFe8PX63e054JavZiIXBAA6IiHNl7nn8BD0aufmOcOv01qzfPUcZY2dDckbeanw8FGyXnqTUpx9Kv0/MDmSf+WDcHRaQHyS6WewIKehM9bu6HBIWHkSESgi7kkibuTJRPMtXL8e+m5csaVHjD750NxAE+1+WbEgLCg4KarSQhk3fAffT3Q5WkARnX8YV2HklLsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mod/ZMjDvnBmqLr/E4Twq0CLi4sB5V/xZgS2ehYYUFE=;
 b=CUcAwFnTowvdMmo26m4SOuVszoPRp8Vx11qPMvq7IswO1EabzWl5zLoZSFx1mK/VqSrsaD2/cKJuNlGAO1Rf0jNZ6AsTymXuVBDcrkmfPOdATkCB8dlvoe7uyK3/5kIZ+yvUR5jKuv2K2WCvLHi6GXnu4ciE77MFe8s8hajcdFBXNW/ZN3AuZHl4QWV+lQnZi1ICVOYc8zzdbhBUNDwvc5/EN0+s2QLbqACy3It+NpSIqhQBEvEQBYprqoTAqp0V2xuxwIUIYIhS68pTxUMSNsqfv7OJTzs6AlKDvy0U7wpyhk+i2Wox+/yJdvmB/chsp6LdajBZRIM6yieUPnsDHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mod/ZMjDvnBmqLr/E4Twq0CLi4sB5V/xZgS2ehYYUFE=;
 b=BwfRFe9IeCmCPEcuJISZcHTEVtSlzk4KMt+UvHLd1egX5b4KlAf8ki/azOOWY9/5MLH5TKfZedVNoJyVFHZEShQkZVD+3xHXARweVH3Iovrjv1HJyFL7gPuita+MexBy7qnf4cYig28shsw5EtANUTWBNPDHBNZEku+vak72os8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:35:55 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:35:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 07/12] net/mlx5e: Fix set vf link state error flow
Thread-Topic: [net 07/12] net/mlx5e: Fix set vf link state error flow
Thread-Index: AQHVn+IbapD+3YVfqEG/PiwcZd9ezA==
Date:   Wed, 20 Nov 2019 20:35:55 +0000
Message-ID: <20191120203519.24094-8-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 5a899b86-32f4-41fa-99c6-08d76df93e0c
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6110858CAACBE6496BE717A4BE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:125;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(14444005)(4744005)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DgskO7THUVC/lVjusOOEo6KkRnU9ysuqni3pNvPk74AwAyyEASTkJSa0R6YCxnqMKRSAQuethXKIvF5YmtqDatsbFcLMhshV6HMLoS0c+cvu9/auorQOWYom2PJylqOoTkQVKfCnMnjgM0+Zb6j8bgqKj9VbeOVboRbFbRFLb2D5b93dwcJAmEhH3TAqiWpn8UyXW6tleeJPgw4vaLFL+71URbbxLeevXKPvpNu2hTuw8NAxUQHeMYXx4YnjvTWjBDrLQnNJ1Vwzlq6yh7J4xhaVe/6pNXDSWmkeAweLwRNT3mjHzprTjaaZ8KUNFd2JualwyyRH0C0/b7lMytpNXtLpOKAnQLPwqDhWRgLFgOEsHQgM65FD+68qD35HuKldA9/K2+Z79s8VkuiVYQVvwn6La6OTiYS1XG6ks5OB7iuMaD/VVkr/9z+kz3mJviRs
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a899b86-32f4-41fa-99c6-08d76df93e0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:35:55.5219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tj5Y8qRL6SHDmrkF8dSf8FilvA6xMDwZ5k4/BF4PdcJU+oKj3fO1SdYtAzolBlQgsKCyBNfrmgbTaGK726LROQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

Before this commit the ndo always returned success.
Fix that.

Fixes: 1ab2068a4c66 ("net/mlx5: Implement vports admin state backup/restore=
")
Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/eswitch.c
index 30aae76b6a1d..60fddf8afc99 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -2117,7 +2117,7 @@ int mlx5_eswitch_set_vport_state(struct mlx5_eswitch =
*esw,
=20
 unlock:
 	mutex_unlock(&esw->state_lock);
-	return 0;
+	return err;
 }
=20
 int mlx5_eswitch_get_vport_config(struct mlx5_eswitch *esw,
--=20
2.21.0

