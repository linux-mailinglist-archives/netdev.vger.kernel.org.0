Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CA99A155
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404497AbfHVUlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:41:42 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:41706
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731895AbfHVUll (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:41:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P98PtXc9G5FE7koQQMD5KKFIMy4HUIthazQ+qqWJENONyk+gXuDCR45TZdq5U9LTg3A8h7s4K62NKx9uJlrx74doWhRGdbH5gch6enVgBjXsl2hGEUQhaYYl0S5yE/X2gFM7GQOh9zZhxzoJx9ZtwJdwoi091TY9IYT033cTQV1vHmkhYS8G99h1SEcVwulJj6XMaavYFHdi4G2AnNuhyP/kMqIShGtko7LMA2G0EpAvlUNLmv/HiQpDfHYB7Zft3dWIawMEcOl16MLeSVsFiI3lU0pDV9HJ/ebAXxQDhO74kMjFuhFP6pHrPpRi81kR/U1MH1l18AnqxDzf3HFwgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQKSa01uJvbLuIxZ96ysb5zXdHQm5vERBdEQ4YleOvU=;
 b=XnYAWFmlFD6OSif9yYai+cRvJsAFhlGadiF0fWQo9K6xOfdTGs1RE4TXVqRk5KT75kxeO5ieDtijdV9/0W3RP7XbpxoA7cqh0F/ATz5EkgZ9pKwoNvtBXm2V4iiL80voFT7y6I6YLc/tHlxQrSeLe5rO0UhVEGh0mjulp9VbhP0S0exKx3miF31Y7fXR9p4nG0HXUA3AUMMzEp6XLhAsRv9nh1iq34OjsAkT2dynXSMV2gkEVn49Ed9lLtI5wAF+CBNm9l0glwv6Y51vI1Tho3/Z4WMqfrmqIKw/R97hZg2TW6HjwKH18reIqeXaTDEahffLKizgJ1ytfHRQfMl26w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FQKSa01uJvbLuIxZ96ysb5zXdHQm5vERBdEQ4YleOvU=;
 b=KcV7nj2GWo4mG0h7s1M610glGzYDurxJyyRhUjsikuILqsADNcBc+MJhduu4wH9gLhijbp5HxRmsad/6TE1xxMg96E4N8hX3XEvDzQ5CdWHvLpoA64jPZTHnLRl6zo82/5emO8uhJmasowXJUj4wDCG+kanno7TL94AnBNzuics=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2724.eurprd05.prod.outlook.com (10.172.221.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 20:41:38 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 20:41:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Moshe Shemesh <moshe@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 2/4] net/mlx5: Fix delay in fw fatal report handling due to fw
 report
Thread-Topic: [net 2/4] net/mlx5: Fix delay in fw fatal report handling due to
 fw report
Thread-Index: AQHVWSn/xdtHF+6s7Ui8SBD2Onb17Q==
Date:   Thu, 22 Aug 2019 20:41:38 +0000
Message-ID: <20190822204121.16954-3-saeedm@mellanox.com>
References: <20190822204121.16954-1-saeedm@mellanox.com>
In-Reply-To: <20190822204121.16954-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7e5ef87a-30e0-4ebd-15e8-08d727412192
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2724;
x-ms-traffictypediagnostic: AM4PR0501MB2724:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2724B8A25D07ACA06D587B2BBEA50@AM4PR0501MB2724.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(199004)(189003)(446003)(36756003)(316002)(54906003)(478600001)(476003)(66946007)(64756008)(11346002)(8936002)(81156014)(50226002)(66556008)(8676002)(81166006)(4326008)(66476007)(486006)(2616005)(102836004)(66066001)(386003)(1076003)(6506007)(7736002)(305945005)(5660300002)(66446008)(26005)(6486002)(6916009)(71190400001)(71200400001)(6116002)(53936002)(256004)(14444005)(3846002)(14454004)(107886003)(186003)(25786009)(99286004)(76176011)(52116002)(2906002)(6512007)(6436002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2724;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 1diohK/Kwx2eB0/8pvtA/eTPXzAigvmry4J6VqOnXi3L86dVcLwQbXZgrzDwe2rf5KV3gxeIbjbo4hMeGlaSjWIv1SSaNSGZKh5GVQVQxfycncEeQ8FTVowTdY+TJ7wPbf0OMN6mzbmTfjlFW5HNjLzX4V/lR/8wxx/Jhci9+DAy0skLd6m7RNLJzQ1AFYetBntP9oq+CGGUjO8r/IL3rbnTL69m0HB47RXDnYI1F1Omwv/juS1wuBCY89cw7+WQCvSP9BI1l8pJKyezd2gqGirdbHt+n8gogMttDb4s6WoQmH0HX9LIDhLH7qiG5klNN4nr1jDmyaJ+QTJBUYn/4wWqbPLn5ApO0UQWzXtU+6EEW/RS0mRL4EKIS3KBPVyUT/VYFEgeuJfRSSUUYmXxKWfcv5R0/23+4CbA5M505Ec=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7e5ef87a-30e0-4ebd-15e8-08d727412192
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 20:41:38.7623
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cwmaVKTKB/Wrar6dxAAl3qpCgw2nL+kuAaygLYpv8qW6ib0dasRUc/evRNqxLAYRghbFBArzgch2OVvqQPBy4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2724
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moshe Shemesh <moshe@mellanox.com>

When fw fatal error occurs, poll health() first detects and reports on a
fw error. Afterwards, it detects and reports on the fw fatal error
itself.

That can cause a long delay in fw fatal error handling which waits in a
queue for the fw error handling to be finished. The fw error handle will
try asking for fw core dump command while fw in fatal state may not
respond and driver will wait for command timeout.

Changing the flow to detect and handle first fw fatal errors and only if
no fatal error detected look for a fw error to handle.

Fixes: d1bf0e2cc4a6 ("net/mlx5: Report devlink health on FW issues")
Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/health.c  | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/health.c b/drivers/net=
/ethernet/mellanox/mlx5/core/health.c
index cc5887f52679..d685122d9ff7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/health.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/health.c
@@ -701,6 +701,16 @@ static void poll_health(struct timer_list *t)
 	if (dev->state =3D=3D MLX5_DEVICE_STATE_INTERNAL_ERROR)
 		goto out;
=20
+	fatal_error =3D check_fatal_sensors(dev);
+
+	if (fatal_error && !health->fatal_error) {
+		mlx5_core_err(dev, "Fatal error %u detected\n", fatal_error);
+		dev->priv.health.fatal_error =3D fatal_error;
+		print_health_info(dev);
+		mlx5_trigger_health_work(dev);
+		goto out;
+	}
+
 	count =3D ioread32be(health->health_counter);
 	if (count =3D=3D health->prev)
 		++health->miss_counter;
@@ -719,15 +729,6 @@ static void poll_health(struct timer_list *t)
 	if (health->synd && health->synd !=3D prev_synd)
 		queue_work(health->wq, &health->report_work);
=20
-	fatal_error =3D check_fatal_sensors(dev);
-
-	if (fatal_error && !health->fatal_error) {
-		mlx5_core_err(dev, "Fatal error %u detected\n", fatal_error);
-		dev->priv.health.fatal_error =3D fatal_error;
-		print_health_info(dev);
-		mlx5_trigger_health_work(dev);
-	}
-
 out:
 	mod_timer(&health->timer, get_next_poll_jiffies());
 }
--=20
2.21.0

