Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F406E235C
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391396AbfJWTjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:39:07 -0400
Received: from mail-eopbgr40041.outbound.protection.outlook.com ([40.107.4.41]:11076
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2391366AbfJWTjG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 15:39:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZU9qMmUy9js/c09xa1brwXayplea1c2q+3QjkzG3PfxfkJnsoHc8YoX6wsXrCxecOJxcLdLCzkK+44kYKFydbb9xLgK1MUChf2aZkQROx9x7LQ7vEc4NPS3gdvT/HeXLKINq8ARrjlYpaYwY+Ls3HFUf+tludjg4Dh8Cgb5/pudWtUVBR19RyifUUNqR2WKCPHCW7/+qDC0dj38hvvtg68ZPSCuw46jswsQobKCJG8P4Te486dAEAomGAO5Qk6q9ZkcsPdYOwrYPDeyNmnKDvQBxTlTLIl3W4p/dS5UozfVSzr984N4Mw4ZolUWMCflCl5c4CIR0/SaqqrNQsGxlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=942P4QV0p2cFWCLIubMzB5xYXpflwCnnzmC3Y/SsEUc=;
 b=N4bKx7u93E0tHaaM/NzZGIVvyAC+/yaPEIAID9sEGWtlXCzVAEqv4lFOaRU3Ad9EFbXonavfIe+p4swGGLUNebYniT+BS4sB/hIjRD5peFXbLidsaDHAMxQqvCBCPAyEPmzERTQD/2MgrLVGGMNNCutNvbxdRRcY5B5/oeg2D/jIiH5BEPHR3mfw9XMnJBTl/nDwhRyTdAyufuGzlKtZx2hsyHzy1smQEy+BzS3DjkcFrCzpsks4B5n+ak3N/5zXXe4dg/AQM2f0jDlx4ObYq65nUr+249cUjZoMwA7BKCRtu3CrW7MjwxoCKRl+buukUDixOB3ofa3Kr1KDEtoEzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=942P4QV0p2cFWCLIubMzB5xYXpflwCnnzmC3Y/SsEUc=;
 b=Q0E7fToifxOXpci23zNhonvRP2F5hu8cPqKarwPBduPH/Z0L8BNIggKaIoEUZqU7doGhdMzbyd2xzSWVwo756y8RQZ67/7oWQ3qj//5g5ezHjeu5OlCxcrjp40OaCAtJPrTd5vXnJm7xm6Tt+qU5fHRu5mKVxy+qriVIFRhTc4A=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5744.eurprd05.prod.outlook.com (20.178.121.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.24; Wed, 23 Oct 2019 19:37:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Wed, 23 Oct 2019
 19:37:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-nex V2 2/3] page_pool: Don't recycle non-reusable pages
Thread-Topic: [PATCH net-nex V2 2/3] page_pool: Don't recycle non-reusable
 pages
Thread-Index: AQHVidk91v+5ha9RXkyIDz/qcdenMg==
Date:   Wed, 23 Oct 2019 19:37:00 +0000
Message-ID: <20191023193632.26917-3-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 1e57e5ef-502c-438a-53b3-08d757f05f99
x-ms-traffictypediagnostic: VI1PR05MB5744:|VI1PR05MB5744:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB57444B61E6C739AA90B28853BE6B0@VI1PR05MB5744.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 019919A9E4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(199004)(189003)(76176011)(11346002)(446003)(6506007)(66066001)(186003)(6116002)(25786009)(8676002)(3846002)(66446008)(14454004)(66476007)(36756003)(71190400001)(2616005)(71200400001)(478600001)(102836004)(107886003)(26005)(66556008)(99286004)(4326008)(52116002)(81156014)(8936002)(386003)(50226002)(6436002)(6486002)(81166006)(14444005)(1076003)(5660300002)(64756008)(6512007)(110136005)(486006)(256004)(2906002)(305945005)(7736002)(66946007)(54906003)(476003)(316002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5744;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4fckEULkUR3rkig/Pl8JTgBMr7l+bKXgC+0v7oMBGDuug2DKOlrdXYyzfbLTpcgqzl5GGFdevbTs2Yk7J99Di4Bbuhe4UDtvxyCtBQzMH4Kw0ke/pyXBpnSTGCMz7dvws2N/ffA8oRc23gE1pFKe2tHSuM71HR5j/LhgIf+Ot3Pi7+ZCXYkxhJmo9kpfk5xq19Xhfvmbre/qUvH1Dx1STWxPYhGHjT6JFRq8avsPO4GzUTtR8IVYfC51eRhkb58JId9qkUnBdoaKi4XyJutncn0KRek/8rBtQDomhW3ctHvOOd0mdEydVbm4XTIIh/tCmRpBJ5aiDCILQHelbXpnFcEt2GxsfMKNHeY+v9UEmXZ4Mhn1HASARTd+dJ2B8jvlRuPxG0L6MJP6EQtRoXQMlC+aXyuOvVercH4m76TO+p5idXwHbxAvC4CGg/jHPwr4
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e57e5ef-502c-438a-53b3-08d757f05f99
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Oct 2019 19:37:00.6024
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YkR8IWhSG2fHcJg38AH/qorRz13hsYcRf2OYV8owzKoTaK8cjV+aiMNCrgDmq7xn0lwi6pKUi6ppi+LB9vzICg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5744
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
---
 net/core/page_pool.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 953af6d414fb..73e4173c4dce 100644
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

