Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A86ADFCCF
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 06:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387590AbfJVEo6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 00:44:58 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:34154
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387544AbfJVEo5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 00:44:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnG3dXqMb+EIYhCTX1Iu9py5hzuuX6h9hYH8stBXtnf1+p5N8ERNN25obFzzMOtzNDpkz0Yx3fwZbP7OXhuRvSmTWGDdcljJiAndYECKPbXKuKxaAyIqnWoJM7akfZMPE+AmvXrVRJbg2QWGA130HQStB9tneaWCuFsqxc7ADTX6Y70ktqK6W3ElIfoSb5tj75AeJBtgH9QT3RCqQxdo+QOYtwDEQV9tzhMXv9PvL87L8IrTdb4jqnkJtfftq9qRtwx/RcpMmTRGdZEk7BJeXregIB2wNS2UhOnb7TsnWF+K+w3fofiKBJ2sL6MLBcT/vO7OFhL6GhDAnG9wLkvVkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAvJSs71QqGBvsgqtBDtqE0JiKw71leMXaWIOCFnyNk=;
 b=XTEFLP9tZjkzOOaAYaRTu2WuiW52RPo48EunG32A6BFkV1+e3uwhZjy89sWY07eGveeaQqyO8fWPD7okqQwfn6K1tjaj1in2M0KeLRg/gNj5me1Yd/BoFFOE5ecGY2uj0O+FASOnPPMNqjQqk57GuVigwUL5pXu2zrvXxrPR8Zv4OVfHCb8bhtEDqn+6XHtKu0cil+Ub9hLuFs0t16WlgRfv8QJ6ggPkD3EaAz7RL8ugbdwKeuz7IK1T3bLYJL4g2huRZA2ARK6lzoB7BQg8SHbusVfmwEzHpxuBj/Kag3T58Dot5jI47/xQaEBUfU2sWEPhshJog4VDdpvZm642eQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qAvJSs71QqGBvsgqtBDtqE0JiKw71leMXaWIOCFnyNk=;
 b=gt7Jubak85JjtDguBctfryDCwAS5rhCqBQCqRbb0UFpZn4Yifhx3VEag/fflKBzNSPftmdqVisffbIj1+cQiBrLck2dvoG00DDMcsPqBpspuyihMPAz436An5CE5UO9rFBn7S3Rj6shHjBC5riav1vt45iMC/wZEFJx2KMHNULk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4272.eurprd05.prod.outlook.com (10.171.182.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Tue, 22 Oct 2019 04:44:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 04:44:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 2/4] page_pool: Don't recycle non-reusable pages
Thread-Topic: [PATCH net-next 2/4] page_pool: Don't recycle non-reusable pages
Thread-Index: AQHViJNfDryJ+xPlQUSOm+5NjxXjMg==
Date:   Tue, 22 Oct 2019 04:44:21 +0000
Message-ID: <20191022044343.6901-3-saeedm@mellanox.com>
References: <20191022044343.6901-1-saeedm@mellanox.com>
In-Reply-To: <20191022044343.6901-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BY5PR17CA0021.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::34) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 78f48ae9-7150-4805-e583-08d756aa81c3
x-ms-traffictypediagnostic: VI1PR05MB4272:|VI1PR05MB4272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4272D2A417AE67CCAC8F18E8BE680@VI1PR05MB4272.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(199004)(189003)(4326008)(81166006)(36756003)(316002)(110136005)(25786009)(14444005)(81156014)(256004)(8676002)(305945005)(7736002)(14454004)(54906003)(8936002)(478600001)(2906002)(1076003)(71200400001)(71190400001)(66476007)(50226002)(52116002)(6116002)(11346002)(6436002)(76176011)(3846002)(446003)(386003)(26005)(102836004)(86362001)(6506007)(6486002)(6512007)(5660300002)(186003)(66446008)(66946007)(486006)(99286004)(476003)(64756008)(66066001)(107886003)(2616005)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4272;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oc31MiHYN8bWLvMmQn23N30cnbN/IJ4PvU6LWLVbfJyEf3xaoB9qXAdRxviWYJmJgqxbzEnArTl3hJVCaPUp13isTCa4+U0PU1Hh2guNGtxS94eW6sfDiJTFWRJhkX/wDKBpeJFx3sf7yGjKaGGOcwtrN+nVJ3KPYP/O8TZP+VPQtY51CzF3FBTbrMtsTtG0bKc39Ubi2KqpW7UUklfDvRt8rNlBza+ARlCvqGJwHKj8134hTL3jbtF83EOe4GWtbYFnfN+/cJlB6tnmQHUm7U060TJ55LS/gdvxCn53pX7v+M1TCFXC6qo8lckJYVJk5YCBFz+VYxGJmYLgpLqSo3uAguWe8BDTgP43N6uwIhgsAZAChFzCRMXtRsUEX0Ek4FEyvjlMKwygbs8Gh+1pKgUuSMF0G/ZsxqsQRwiDg0lZpec64INO9JPHjNxKTVOH
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78f48ae9-7150-4805-e583-08d756aa81c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 04:44:21.9071
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KBAxW0Jqymint0PxAiahLsnUePVtVghy739H1YJ04YX4PoQ+a0O3PWETt8omzjWmPDg4aElAJj1gXf3PMa7+NQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4272
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
Close | Drop | 11   Mpps | 10.8 Mpps
Far   | Drop | 4.4  Mpps | 5.8  Mpps

Close | TX   | 6.5 Mpps  | 6.5 Mpps
Far   | TX   | 4   Mpps  | 3.5  Mpps

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
---
 net/core/page_pool.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 08ca9915c618..8120aec999ce 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -283,6 +283,17 @@ static bool __page_pool_recycle_direct(struct page *pa=
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
@@ -292,7 +303,8 @@ void __page_pool_put_page(struct page_pool *pool,
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

