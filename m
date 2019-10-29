Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B956E93DD
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfJ2XqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:15 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:58441
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726752AbfJ2XqN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PatNCipXvNSCJX58lJyomYKtToueF/DK7RduAGO7gY1AZ5ed1yIN/Ckhwt0fV47nxDPo9ZFNWZbyIPKT9ltpr2kFWfqsXPiNCQz+y8VtqfiOZ77VO9WmWpT8soBaEboBQBkGNH48KgqPJIRO38KRvPILIjWxXwIRLfHd2mSyhCqswleZI3BiIIbMZz3UGXxOogPqKEgZKQPUtKRhQumTyb8FsYtVGGrJomO60YfZjxkX8alfL2Cpw6177ZCLWE8eMlveyBQbf1AkrczoRG76TDFd/g2gJLGAnNZXbm4vUU5CEUH8UJk2qMVGTwsnx//i0U5/KuxyT3dUlnIy2byFjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0y3A3AuxZxk+oKvoERiekfm7iuR7NKnerAgXmIN5oM=;
 b=Y8sJqYLvHPTWOSKCPfukvQje8eBUdX6r/CiRkuNO1Ib9TBv/Pi/fQwasVeDONXWhCfnTP6WykRyBp3uivr+oRE3w49fra0TDo+dIPojGTFmev/ZLfFcUGcdLnrphp4e6XZ1vqxA5eNiwnHW489RXBMc6rMFLsGyRRSRqEun3f5Sm1vNaKKQNl8sVM2O5IAlIJydofxHms4iI/aazs0l9L+rs6O0v2cXtV7SOwSl3qLtqVRYIn2AV5nCx5s1R48b3P7EN2MO0rl6Cv92cJy3dpY8IqdT9S4gmcLdFFb06xiL/k4vMhGbsPdbWCSWIZvkuSSTtTZLhPwjIWo9hNqNUUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0y3A3AuxZxk+oKvoERiekfm7iuR7NKnerAgXmIN5oM=;
 b=eWEoKRwupgYEc/iC/wOXzUwmF49zs0A8IdmhzZYhthSgOjM4x5eHlja9SfCdwgz/ZvMbs39ydXpkfLa3MWd9T+E4FpaN+G/9H2mkU1FGPEOYohFtnMtRbE3fzuq/Xh6sGufwudK23g9RyxqubmS0Xd0pJ/tL/ODPTT51veBWJs8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6157.eurprd05.prod.outlook.com (20.178.123.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 23:46:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:46:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net V2 09/11] net/mlx5e: Fix handling of compressed CQEs in case of
 low NAPI budget
Thread-Topic: [net V2 09/11] net/mlx5e: Fix handling of compressed CQEs in
 case of low NAPI budget
Thread-Index: AQHVjrMKlgzx+0yin0aPXKX8qmQBgw==
Date:   Tue, 29 Oct 2019 23:46:10 +0000
Message-ID: <20191029234526.3145-10-saeedm@mellanox.com>
References: <20191029234526.3145-1-saeedm@mellanox.com>
In-Reply-To: <20191029234526.3145-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR08CA0050.namprd08.prod.outlook.com
 (2603:10b6:a03:117::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2234acc8-7fbd-4f07-2e85-08d75cca2cf1
x-ms-traffictypediagnostic: VI1PR05MB6157:|VI1PR05MB6157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6157C4A2FDC3E21824796C80BE610@VI1PR05MB6157.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2657;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(6486002)(486006)(4326008)(2616005)(476003)(6512007)(66556008)(71200400001)(66446008)(66066001)(11346002)(6116002)(8676002)(54906003)(2906002)(7736002)(316002)(6916009)(81166006)(81156014)(478600001)(107886003)(8936002)(50226002)(6436002)(1076003)(446003)(25786009)(36756003)(3846002)(14454004)(71190400001)(86362001)(305945005)(14444005)(99286004)(256004)(26005)(6506007)(386003)(66476007)(76176011)(52116002)(66946007)(102836004)(186003)(64756008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6157;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VKWmGwXDneO2H7j5sn6RFxOBp4JTImiqpusI0xolq2dMHKtMrzWLSp2WNzmgO6JnJlqgw6trV6+5xEiLXyY1KLppfOvQ7/itzUbdRijhxTcd2KoJSo1/PgzxASI+ax6gGiVQlDsU92xYEEgNzk2OzPkAMWkiD3wIzbVYLO+HTdIIDz25wppIUwb+Sy2a3C+mm2ROBu1p4E4HG22vpS5Bplqa4UEc9d1cI29Fyv/qNhX+iwT/YyUm2mMzYikFq+cdmCIwYdazawx3kiw/bLZfRIGpaNLt967wk+4/8WoaNqn8KPEpdLZ6JjSBDEta2O1bb9OxiPeNcY7iZDfRhXEXkOyuWjwI2mQH+M9ZbZHliJmHxyZbQuupIsmSkIjRR9W7FS6VIn1arLCDyE/fxORzzadp4EUTWbYc7r/e2zFqBo99aPezUivFbjA1GW4LP4LM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2234acc8-7fbd-4f07-2e85-08d75cca2cf1
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:46:10.5675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AMeJ0IhS08bynj8ipNeXrqUwiFwIjAZJuuqarn+f+VE6xwJV9hwr7aQnuNHzOccLmaFepM5gvFeCJyCuNwiuZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

When CQE compression is enabled, compressed CQEs use the following
structure: a title is followed by one or many blocks, each containing 8
mini CQEs (except the last, which may contain fewer mini CQEs).

Due to NAPI budget restriction, a complete structure is not always
parsed in one NAPI run, and some blocks with mini CQEs may be deferred
to the next NAPI poll call - we have the mlx5e_decompress_cqes_cont call
in the beginning of mlx5e_poll_rx_cq. However, if the budget is
extremely low, some blocks may be left even after that, but the code
that follows the mlx5e_decompress_cqes_cont call doesn't check it and
assumes that a new CQE begins, which may not be the case. In such cases,
random memory corruptions occur.

An extremely low NAPI budget of 8 is used when busy_poll or busy_read is
active.

This commit adds a check to make sure that the previous compressed CQE
has been completely parsed after mlx5e_decompress_cqes_cont, otherwise
it prevents a new CQE from being fetched in the middle of a compressed
CQE.

This commit fixes random crashes in __build_skb, __page_pool_put_page
and other not-related-directly places, that used to happen when both CQE
compression and busy_poll/busy_read were enabled.

Fixes: 7219ab34f184 ("net/mlx5e: CQE compression")
Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index d6a547238de0..82cffb3a9964 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1386,8 +1386,11 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget=
)
 	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
 		return 0;
=20
-	if (rq->cqd.left)
+	if (rq->cqd.left) {
 		work_done +=3D mlx5e_decompress_cqes_cont(rq, cqwq, 0, budget);
+		if (rq->cqd.left || work_done >=3D budget)
+			goto out;
+	}
=20
 	cqe =3D mlx5_cqwq_get_cqe(cqwq);
 	if (!cqe) {
--=20
2.21.0

