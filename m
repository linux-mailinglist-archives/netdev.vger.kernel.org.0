Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9880310309C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 01:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbfKTAPc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 19:15:32 -0500
Received: from mail-eopbgr50065.outbound.protection.outlook.com ([40.107.5.65]:50450
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727428AbfKTAPb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 19:15:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QEmZodCKI9MHqgmCoEtnPCUtEAjrUO9fI2dQEVBqz61La/FAwMARg5sB5bveSJJU4e4SZtaGADEURtIc1LkZb/2Ec0mgghj0OW2A9G6Wxi/7sTZch0RL9iHvFIXdebneJd610U2p7tLYTgC/Lt8qGxVgHpFMBDvTxjLw3nq2lHZHVhkWzSaQFbk+GlVGcPqhCAqorZq7YTFrIVI1te8L3yqJ+StNllSF9FaMvXF8O2yCBzUgEbVEyKvLfXek0FXnxRwbB90K9V3XnCSuWK++LFCzuNsNsCwCiPT9ZDALp0zmywvpIydW2ZYN0RSisXhBG3HsZx6gxl0jhmP7YX/tjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA2eqqC7dIlXyRPyEfmiKTf9OA1E2vpeJgzKJFyfFi4=;
 b=kepLaTKx5oz7rRyU567FHTcR3x2xMrw4WB5THqlldI2uWay77Mxak/8xAtxzzDzRoaQQOG1/6Qeyp+rqy3FgwaCl/ML2t1gv5RmB64pGop9wlvlH9tJ6a5tRiWlG/qr3XWrBJdQF1h/V1W25icVbY2Fa6/AuP6RnDkSmZHyAiJ56SQAjk5V5IlsH6L5Jii5X3+X2e53I7L9PIycFUlARp7X0bZA0jR4fhYlhPXFx7uwF/aVHlbGKEyWCpF2ahm8f8VEkWoIFLr8YYj+2II4k3tV4bhCraCqAW2xS2WVuNmdeZ3kpzf+yjcNlIZcRTw3Ix83IQuE4FSCUpch/qRb8Ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EA2eqqC7dIlXyRPyEfmiKTf9OA1E2vpeJgzKJFyfFi4=;
 b=H9r8e9fqTG05NfJVOAWaBOLE3jYjXod/8eonbrT/rfBOgTilScOR70dOgd6sKs5nDPwbYzKIfNirDWoYqSlRN3z+QWnHxzpHXgjsSSPvawzul2aPAgaJqPLhbjCqrBzYhpnG6vBn1lgw7dUd1DXJp8xZpDuYT5IUYEOQehC6waw=
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (20.177.34.93) by
 AM6PR05MB5378.eurprd05.prod.outlook.com (20.177.188.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 00:15:19 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::5cde:d406:1656:17b4]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::5cde:d406:1656:17b4%6]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 00:15:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH net-next V3 2/3] page_pool: Don't recycle non-reusable pages
Thread-Topic: [PATCH net-next V3 2/3] page_pool: Don't recycle non-reusable
 pages
Thread-Index: AQHVnzeXudYWmdhKVEqshEe1j4Fwzw==
Date:   Wed, 20 Nov 2019 00:15:19 +0000
Message-ID: <20191120001456.11170-3-saeedm@mellanox.com>
References: <20191120001456.11170-1-saeedm@mellanox.com>
In-Reply-To: <20191120001456.11170-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BY5PR13CA0008.namprd13.prod.outlook.com
 (2603:10b6:a03:180::21) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0ae0e867-b306-47cf-c75c-08d76d4eba0c
x-ms-traffictypediagnostic: AM6PR05MB5378:|AM6PR05MB5378:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB53788CDC844AF83CAD9F580CBE4F0@AM6PR05MB5378.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(376002)(39860400002)(346002)(396003)(189003)(199004)(6116002)(3846002)(256004)(14444005)(66946007)(110136005)(446003)(305945005)(81156014)(6506007)(386003)(81166006)(36756003)(6512007)(2906002)(54906003)(14454004)(71190400001)(71200400001)(11346002)(316002)(7736002)(64756008)(66556008)(66476007)(66446008)(486006)(476003)(2616005)(102836004)(50226002)(99286004)(52116002)(186003)(5660300002)(6486002)(86362001)(478600001)(8936002)(76176011)(25786009)(6436002)(26005)(4326008)(1076003)(66066001)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5378;H:AM6PR05MB5094.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pkbnSFvBAb48zH+4eCnb/tkwpgNEC0G45jDbKFvFpshBi/s1wj01akWqAB7XaqcSA55G7a8WikWLvvcq1XQwwT8UFFOmChIB1mnFa+t2DJI60ZYHsyub2HFslym0NZVXU+wDludv3IjI00pp/NShNLIzbVxIyaaOm8kN2WKojEPTRFzTGuXRKlzFAAIzlcOi5CQveX6c5fX7QhVh0MayTSA4jFuUyXB0s5Xp71Aj8cN1f/atwz32mIc5neSKnGeBiUZW93HE6DeCFU7GvPNPwQLHRgEEqPbcR3wqxi4yQcdXIp+EJ0AKtd8qEnI49ESTh6GYg7mGyq4CbF7rfETWEutJxiBS/xf7bFfdpWvT/W2bE/XIBPzjXHMKkGmYUmtt7/XoaT0tMBWrVviHmRgw7RpBWfqnF3RfibEwsGtBeiwHMcY8U88c9VjjfJIKN9w3
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ae0e867-b306-47cf-c75c-08d76d4eba0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 00:15:19.4689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: goeVihM29lAPwwWA9pl9MeECVBjOMQ/nDUuiyIff3WR2o9jdVac6mnBZ1KYVi1kc9jWAWFX7SFSE34xEkvo/EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5378
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A page is NOT reusable when at least one of the following is true:
1) allocated when system was under some pressure. (page_is_pfmemalloc)
2) belongs to a different NUMA node than pool->p.nid.

To update pool->p.nid users should call page_pool_update_nid().

Holding on to such pages in the pool will hurt the consumer performance
when the pool migrates to a different numa node.

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

The impact of adding a check per page is very negligible, and shows no
performance degradation whatsoever, also functionality wise it seems more
correct and more robust for page pool to verify when pages should be
recycled, since page pool can't guarantee where pages are coming from.

Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 net/core/page_pool.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9b704ea3f4b2..6c7f78bd6421 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -281,6 +281,17 @@ static bool __page_pool_recycle_direct(struct page *pa=
ge,
 	return true;
 }
=20
+/* page is NOT reusable when:
+ * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
+ * 2) belongs to a different NUMA node than pool->p.nid.
+ *
+ * To update pool->p.nid users must call page_pool_update_nid.
+ */
+static bool pool_page_reusable(struct page_pool *pool, struct page *page)
+{
+	return !page_is_pfmemalloc(page) && page_to_nid(page) =3D=3D pool->p.nid;
+}
+
 void __page_pool_put_page(struct page_pool *pool,
 			  struct page *page, bool allow_direct)
 {
@@ -290,7 +301,8 @@ void __page_pool_put_page(struct page_pool *pool,
 	 *
 	 * refcnt =3D=3D 1 means page_pool owns page, and can recycle it.
 	 */
-	if (likely(page_ref_count(page) =3D=3D 1)) {
+	if (likely(page_ref_count(page) =3D=3D 1 &&
+		   pool_page_reusable(pool, page))) {
 		/* Read barrier done in page_ref_count / READ_ONCE */
=20
 		if (allow_direct && in_serving_softirq())
--=20
2.21.0

