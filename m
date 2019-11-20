Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2478F104532
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:36:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfKTUf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:35:58 -0500
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:18430
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725787AbfKTUf5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 15:35:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUvK8nlrZWS8HsLpQemYsmc+mu/9IXWki0rqNsekWLMnif+hOm9X0FHUawWTZlCKN8RjtdeerExLI66pdA6+4NJPbwdP5uWw53KLRGPlaaY+5oYLKmIX8ioYHGiz6OlvOl93ot+JkRyM8jK2B6e3R9i81apqGCcsSWiwTNOzRXhEbbztw2RTjiiJFF/UW9rpA0S7mJ+woVHa+B6Zz8dw3ui/1VAm9cU3llW+3TdOBvyf9x7/pQM5WkZtPukmDxyiRS6JhOrV5y6WP2uCB0YtpOWvPa0WW9DvGXHiNv/HypbndzFTsUOU+bNeNgYHl2WFO7q8uhWHm5reHIHB0KZ0YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsWQYFvO1JgrRTx5H93/ou8XD8vpFmcq0bqhEmgJCM0=;
 b=hTFBaRbd9jdGLBdqk22t8E5VLKyTuDnN/oevGifADeyBp9ZTRQbk5BG6tnQT9q8kUaxxkrXMvDJodfa8d9xT7rpQZR/kNoQRyjtJ51xaDvLTw9L0prKl0PCtLhdZIqtYQ0+r5/lWj7SkmcrbXMQOc8BnsV7m9ya/wClkbTIKi2rHSTFlPUPRg4VnaHiOqG6HYHr2rM1bcXZvJkwFCQ9V+FZG8/4v5vcY2PR7rw8JsFt1LgIyCwiItuUxHruIgySMDFnYcRUfUtQ9Q9q/sJ/41E79tw/sFWYiiQdhXpQ112g281rNEM8AyZ+ajdxCkaLbk/sTbnKo2J2N4TokTG91zQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IsWQYFvO1JgrRTx5H93/ou8XD8vpFmcq0bqhEmgJCM0=;
 b=lacNbz0gpmsnR147SEU1DE8CCztYnt7bo/hAPOzUsky7OF4hOKRBuY0go8tTtEh2DqFtHJ/pDRBFHXSxqSWVDvVntk7CQpr6k0dSHhvcwBv7AqyLbGWrckhPvnfW+zJrXnxkfrjGNIoxKSsmVUfr6Nyj7qPHILDlzZWw3P+RZdg=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6110.eurprd05.prod.outlook.com (20.178.204.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.23; Wed, 20 Nov 2019 20:35:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 20:35:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 04/12] net/mlx5: DR, Fix invalid EQ vector number on CQ creation
Thread-Topic: [net 04/12] net/mlx5: DR, Fix invalid EQ vector number on CQ
 creation
Thread-Index: AQHVn+IYCkD1pFmHAUCKs2BY0SwZLQ==
Date:   Wed, 20 Nov 2019 20:35:49 +0000
Message-ID: <20191120203519.24094-5-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 2db5c4f7-09c2-4dd8-87cc-08d76df93a78
x-ms-traffictypediagnostic: VI1PR05MB6110:|VI1PR05MB6110:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6110E56F29209C363183DA3FBE4F0@VI1PR05MB6110.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(396003)(366004)(376002)(346002)(189003)(199004)(66946007)(6512007)(446003)(11346002)(66476007)(64756008)(2616005)(476003)(52116002)(14444005)(76176011)(107886003)(5660300002)(8936002)(66446008)(66556008)(186003)(26005)(478600001)(25786009)(14454004)(6506007)(6436002)(386003)(8676002)(50226002)(81156014)(102836004)(99286004)(2906002)(81166006)(6486002)(71200400001)(256004)(7736002)(305945005)(36756003)(4326008)(486006)(6916009)(54906003)(316002)(71190400001)(1076003)(66066001)(3846002)(6116002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6110;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fa3NtVFAEne/y4p4w7NJLrefNd1mKCtVypRqTvZMwRVL0q6uXooSBHesyflAglt7cRZz+nDHAyemL74zVxKpUVEAri2ASHe+hmxbwJvOlWhsUOW4uIZ70QEiUq19JhBwRipAHsdyMjPmewcljobJpLSATeCSCK4dtdE09nRQYUEnU0JzJLp9IWIiv/R3o9cQigG3YemYb2NEouNZz/I/Gxkg8un113PzirqRe8n+Vqe+mdjn/0lPn8HvkILNL1d4jdrEqiggBCCJb6/l8r/G6BslqnudhmZQP8CYM+r9kXpUymDdroznWugXzYSOx+3VbrZw97q9IJH3THTRCLF78Id1n8uQfAcORa7En12hlSQyCseT9WSJU3pe9MTJAC14tZq1FAc/it6J/NWCR6ak+mxt+RJYXpfQ9SXrqVkocj15eQafWcMqa0ZMJFI5K/OL
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2db5c4f7-09c2-4dd8-87cc-08d76df93a78
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 20:35:49.3945
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SCaEyrb/nI/iZv8VXQDnNoMcE/VdaArf/oRcvgI3n2TDwhPRGh9Xyr/drshrH40MBaxxXyZX8kL5zqPhRJp8HA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6110
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

When creating a CQ, the CPU id is used for the vector value.
This would fail in-case the CPU id was higher than the maximum
vector value.

Fixes: 297cccebdc5a ("net/mlx5: DR, Expose an internal API to issue RDMA op=
erations")
Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index 5df8436b2ae3..51803eef13dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -700,6 +700,7 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_=
dev *mdev,
 	unsigned int irqn;
 	void *cqc, *in;
 	__be64 *pas;
+	int vector;
 	u32 i;
=20
 	cq =3D kzalloc(sizeof(*cq), GFP_KERNEL);
@@ -728,7 +729,8 @@ static struct mlx5dr_cq *dr_create_cq(struct mlx5_core_=
dev *mdev,
 	if (!in)
 		goto err_cqwq;
=20
-	err =3D mlx5_vector2eqn(mdev, smp_processor_id(), &eqn, &irqn);
+	vector =3D smp_processor_id() % mlx5_comp_vectors_count(mdev);
+	err =3D mlx5_vector2eqn(mdev, vector, &eqn, &irqn);
 	if (err) {
 		kvfree(in);
 		goto err_cqwq;
--=20
2.21.0

