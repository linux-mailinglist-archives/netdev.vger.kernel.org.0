Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF60E8F3E1
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 20:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732189AbfHOSrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 14:47:12 -0400
Received: from mail-eopbgr00074.outbound.protection.outlook.com ([40.107.0.74]:55213
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730559AbfHOSrL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 14:47:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c8V6lsQb5/8ENTaJ2RBUjNcbJDlA1H27QCrRl8lhQopf7f0+9NpLGFrIAKVnzkzeRtKDvby7gVR5rDYuKUTfBbLLQOdY1hUM3CIXagKiL0U/INZ8VOsp09BTKxtgtlYu81sWgPY8Q/pZ9G9lj6C3DOeOZNwQrLk/IVq0nQAyHRG6NejyoNwuo6iajSuFGFaTHbKaexGPWWofhxsHDs6kDMx7mlHt1y7facZiiD0Rloqe6vjiH+CnJG7W7pCoJ+ssqmNEvwFGsHcWN2CekTLar2Gwkg8tGNXBGP0ACs/SwE2sHhH4ya+Nk/iIoh1f/61IeoEDZrBIFT7w3h5S4QiVyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+B61Isy88tMOLuRA/hOJYeo41FNz1uDxlHFBWf+pTy8=;
 b=FBm67FD9/YWuPGcxTDV5+AHfJpcCFqtJ9X2FO2MYeW6tYLjeTbRPpQG7Ufo+/Mc3CRoks2Hv1xAqnZaOnReft2ClWqEjc45VQ5tsx95ontkPcnKMYykUT5H8v7Wt4z2HR3sXtS5PnQW/IoLSTFruluL3fYME7XYXpKECCnlqGiEM2LWk9e+oqOOEnNyhWl/GaXV7ZEz3lgT8LSJqHEW9p0tl5v6kjOpV5UydvaykE16gIC7SY5Q4IEZyUEJzihFELMhXnIqmevZrNDbp/7p9MJNHZWuavvpnla7ZlfUHNd8bv62ftEWtffzm5Pzlvqs1N5l6/mv/bNWqxYy1XSl9tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+B61Isy88tMOLuRA/hOJYeo41FNz1uDxlHFBWf+pTy8=;
 b=pCxcw3F7FFB3TRvf//QZm29Pa1McZPT69JpxTRK20WU5QvegcXg8rzj9W3uuXwdCeMzhO9EnVZ8bMZ7A9N60JdOJC68m8p1nrqlZvvNK3cIfPRDceaXx1GvmpPsW5dTDboxUaJdj3TSB2iQRK5eZ1ruAo6pzS4pk0sMLrgyKRCU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2663.eurprd05.prod.outlook.com (10.172.225.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Thu, 15 Aug 2019 18:47:07 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2178.016; Thu, 15 Aug 2019
 18:47:07 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 1/2] net/mlx5e: Fix a race with XSKICOSQ in XSK wakeup flow
Thread-Topic: [net 1/2] net/mlx5e: Fix a race with XSKICOSQ in XSK wakeup flow
Thread-Index: AQHVU5nWL94NIQx/t0esFgaRgdiiLQ==
Date:   Thu, 15 Aug 2019 18:47:06 +0000
Message-ID: <20190815184639.8206-2-saeedm@mellanox.com>
References: <20190815184639.8206-1-saeedm@mellanox.com>
In-Reply-To: <20190815184639.8206-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d99c1b2-58af-46b0-4e1e-08d721b0f89e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2663;
x-ms-traffictypediagnostic: DB6PR0501MB2663:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB26638F0BB3030E0F15A361E6BEAC0@DB6PR0501MB2663.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(346002)(39860400002)(366004)(376002)(189003)(199004)(53936002)(11346002)(446003)(52116002)(26005)(107886003)(6916009)(386003)(76176011)(102836004)(476003)(36756003)(478600001)(8676002)(14454004)(66066001)(81156014)(2616005)(81166006)(6506007)(486006)(50226002)(4326008)(1076003)(6486002)(6436002)(5660300002)(71190400001)(64756008)(6116002)(66946007)(2906002)(3846002)(71200400001)(14444005)(305945005)(54906003)(66556008)(316002)(186003)(256004)(25786009)(7736002)(66446008)(66476007)(86362001)(99286004)(8936002)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2663;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: FB1eS6fGa7RIm5W0u4G5fQkhqxUwRMgnkK8M0iOkZp6hEplS5Q9KMluV7jHhBgYnruKQfh7QWJ/xeqB+pqnbRmhjMqr3xt2I0pwCdotOFwRsGJ8+H7siCm5d9jJirSc/HS5iZcuixB+XwgUih5UX9aQ0sj1y6DJ/EAUZHiUUk55QTD5V7/EzfFj+fjCn8bD6pdloYtO5SvW5oQvj6MI+HttTMxwyVuG+ysQdt4VXyATi24S1e7X3REYKa+ON7dCQ6J1u1ZESZmHIB4L92r3HX9ZyokJX8aYfcpFz3Uv66s0yPVjFfzs8oH+0kcxpU5QnuG9Q9zMZkFGRsndwLD7K0CaeqfZiX72T5P1h4ed9FmXHHUaPDUIz+wWt67X2tfz6sd/+TNEZCqkmtXwglniqKh74/UMsMgjCVZdMVKN7Kvg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d99c1b2-58af-46b0-4e1e-08d721b0f89e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 18:47:07.0057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kG7xX8d4ynigECIp0Hp8D3IB/NNHJBDsJBrwq1JLNH8ptdCbUG05/KtzXR0DluGRsG/mJkwQ6h8wN2kjYEYAsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2663
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

Add a missing spinlock around XSKICOSQ usage at the activation stage,
because there is a race between a configuration change and the
application calling sendto().

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c b/drive=
rs/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
index aaffa6f68dc0..7f78c004d12f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xsk/setup.c
@@ -143,7 +143,10 @@ void mlx5e_activate_xsk(struct mlx5e_channel *c)
 {
 	set_bit(MLX5E_RQ_STATE_ENABLED, &c->xskrq.state);
 	/* TX queue is created active. */
+
+	spin_lock(&c->xskicosq_lock);
 	mlx5e_trigger_irq(&c->xskicosq);
+	spin_unlock(&c->xskicosq_lock);
 }
=20
 void mlx5e_deactivate_xsk(struct mlx5e_channel *c)
--=20
2.21.0

