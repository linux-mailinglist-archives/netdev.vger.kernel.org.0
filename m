Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE9D9E235D
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391404AbfJWTjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:39:09 -0400
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:11076
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389916AbfJWTjJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 15:39:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/qsn5EwDr9CLTCIShtp5LPun6hhgnCL3JtFEFBgsTBAyBULQ8AigmXOMVme59cPXTsJx2Fh5jHAIkPGN6smCBs+oYJ8nB7XhiyRZfB4K7jb/JsRcsyj1wQJNnA+lvxUEae1rPoXIC9/WriwfeSWaW5E76X2VZrM305zGQjxMhckqhWbiIFVxz7cxy2imYnbAv22CxB28COebPE4CVbCtK2dUB7h0eyBOXns0sheVRA8q7eDQ+MnaUY5PnWo56peZSa2QTod4sMP7sOBQQRTKpprHjSvdKM5IcDK3RPz3tXY96FGhvJkP3LIEYFHp3NkvMFrPghjEGkwM5E4KeGpHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+g0zX87AFMnM+MrB/A97R8L9OA033go2y2k5ub194RU=;
 b=n8ypqsDLYNTYTfZZSzi/Qffs5FRIMmHlSsNkixXwaTJE3dC8cmOr574K0l2JVmTRb0kqby6yUpisCZ3zgf3/yJtTSlYjW4eVpZK6RtGD0jPI5c7HWQ2BGjgALgvdYVzmqfOGviBJXScdyohNoqydthxYMmdvneZrAkHpQTThie0xDH6BeaVXB1g97R0PwI0ixNNoXhKEX+BCizoBkd7RZ8SmFqq75oSp+L9aUqS3kYWXdi/rLuEPzQNUPBRaMQ1SePs1KEHja6pe2wGJQDXjCih7aeUA8glZMhrt+MSIZf0NFVPuVs7kNC2avk/4T5LZWmcf+w+W6nHKLJjPHAds9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+g0zX87AFMnM+MrB/A97R8L9OA033go2y2k5ub194RU=;
 b=Tb7HZVjalAoM+jUxHL2zFAb8GdR36YKO1jUct9sxyvbgjYDCE/DNpS50fI2FU7dOe6gN0P6sVzWvAjIiMOJR6WWHqqtJZok8DL82e2SX04KJxdKdUq2+QMa+qs+XCe07m5BoTNT3hTHbdGhP9W+/vYac40IYxGXiQpulCdWEHK8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5744.eurprd05.prod.outlook.com (20.178.121.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Wed, 23 Oct 2019 19:37:02 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Wed, 23 Oct 2019
 19:37:02 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-nex V2 3/3] net/mlx5e: Rx, Update page pool numa node when
 changed
Thread-Topic: [PATCH net-nex V2 3/3] net/mlx5e: Rx, Update page pool numa node
 when changed
Thread-Index: AQHVidk+dz4gDCbPkUqhHlKqqzYupQ==
Date:   Wed, 23 Oct 2019 19:37:02 +0000
Message-ID: <20191023193632.26917-4-saeedm@mellanox.com>
References: <20191023193632.26917-1-saeedm@mellanox.com>
In-Reply-To: <20191023193632.26917-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0035.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::48) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2219d1dd-e34e-4ab8-e715-08d757f060ce
x-ms-traffictypediagnostic: VI1PR05MB5744:|VI1PR05MB5744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5744314E45762FC8A718C1DDBE6B0@VI1PR05MB5744.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(199004)(189003)(76176011)(11346002)(446003)(15650500001)(6506007)(66066001)(186003)(6116002)(25786009)(8676002)(3846002)(66446008)(14454004)(66476007)(36756003)(71190400001)(2616005)(71200400001)(478600001)(102836004)(107886003)(26005)(66556008)(99286004)(4326008)(52116002)(81156014)(8936002)(386003)(50226002)(6436002)(6486002)(81166006)(14444005)(1076003)(5660300002)(64756008)(6512007)(110136005)(486006)(256004)(2906002)(305945005)(7736002)(66946007)(54906003)(476003)(316002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5744;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1sV0ftx0fS7tv5r39N23u6E4akFX/l2l3BXb98xldtQoNlLHByo7+X4SUudV7wsrio4WsqGOSQ9sxhHtiiFIaFH4STNzPsa0/oxXtI3SlQQ4q/JtUN7YVOPMDI3IqqLoCOzncW60SefGwz9BzvdFn8WEAHQf03UIE9n7Dq8010TXRDziVdGQnzx7a7c+2OzQmCGR5DXZu7v/uRGEC2Hl4d/oykw7QMBw/sUJsaghFyFleIdDsOnQ+uQDirD1SCmNErZTlTU+VH/1zONlM1F8xuU2Zgw+b1v2mfW9mblE2YojYD1jgTgydqTJmfWgc6URjLNJ+d5VtvtzkORwQFUf9vs06VjuPQdaINP0XDWPNtk0Rt7l2Omh5n63yIm3wfn3Q5suuBXZPaKJjC1NUS0RyMaQ91yyb9xRE/9Cb2l+G+FwBIwPRXbvRaVK225Jk3Xf
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2219d1dd-e34e-4ab8-e715-08d757f060ce
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 19:37:02.6093
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Q9ZNtXa/8BJCvAJUavb3O9DkUzlKmCfedEEHUW7ypu6nj4ibCFLq8R0neiUbW9UvWPDolhCZR3xYlIfGUyMQFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5744
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Once every napi poll cycle, check if numa node is different than
the page pool's numa id, and update it using page_pool_update_nid().

Alternatively, we could have registered an irq affinity change handler,
but page_pool_update_nid() must be called from napi context anyways, so
the handler won't actually help.

Performance testing:
XDP drop/tx rate and TCP single/multi stream, on mlx5 driver
while migrating rx ring irq from close to far numa:

mlx5 internal page cache was locally disabled to get pure page pool
results.

CPU: Intel(R) Xeon(R) CPU E5-2603 v4 @ 1.70GHz
NIC: Mellanox Technologies MT27700 Family [ConnectX-4] (100G)

XDP Drop/TX single core:
NUMA  | XDP  | Before    | After
---------------------------------------
Close | Drop | 11   Mpps | 10.9 Mpps
Far   | Drop | 4.4  Mpps | 5.8  Mpps

Close | TX   | 6.5 Mpps  | 6.5 Mpps
Far   | TX   | 3.5 Mpps  | 4  Mpps

Improvement is about 30% drop packet rate, 15% tx packet rate for numa
far test.
No degradation for numa close tests.

TCP single/multi cpu/stream:
NUMA  | #cpu | Before  | After
--------------------------------------
Close | 1    | 18 Gbps | 18 Gbps
Far   | 1    | 15 Gbps | 18 Gbps
Close | 12   | 80 Gbps | 80 Gbps
Far   | 12   | 68 Gbps | 80 Gbps

In all test cases we see improvement for the far numa case, and no
impact on the close numa case.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/=
ethernet/mellanox/mlx5/core/en_rx.c
index d6a547238de0..3b6d55797c0f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1386,6 +1386,9 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 	if (unlikely(!test_bit(MLX5E_RQ_STATE_ENABLED, &rq->state)))
 		return 0;
=20
+	if (rq->page_pool)
+		page_pool_nid_changed(rq->page_pool, numa_mem_id());
+
 	if (rq->cqd.left)
 		work_done +=3D mlx5e_decompress_cqes_cont(rq, cqwq, 0, budget);
=20
--=20
2.21.0

