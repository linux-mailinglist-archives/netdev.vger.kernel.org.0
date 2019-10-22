Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD9CDFCD0
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 06:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387604AbfJVEpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 00:45:01 -0400
Received: from mail-eopbgr10055.outbound.protection.outlook.com ([40.107.1.55]:34154
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387567AbfJVEpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 00:45:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Li4eM2x8AFzBzaXcStLH5dDtOka7uw1B6ZRk3lwxT0OddVXwJkfJEpZUrexzleDDtG/YgpQ5SKkB2NSmltCwTvFX+NUBnfw8y8r0iQVkX74oR7Gc4mvsrc25S5a4X83ZVgrYOvvVKCI73zKHfhxTyVeE9FcQqzaHz8nv6tjQczsCEi2KN5+Vt+ZeMHsv9qsD+R5SSiQl5QhBxAuZKZlkO6X3oawy57UbbDHVJN1DEEDAGbdL4IcL9YaQhUnKtjIEaUy/w9U66xi3UMvM9Pc9Tod5Uj1vrpzNBBmtB6HzsB1+2N3/H8m13h+hee6ZK7oMkipwo8XQ1CKDMGAjcKuWzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdffY/tqdOFPmrF6nS8nksD/iu994gESDo7Trtip2AM=;
 b=T0yfioGg+aOE2Pit5m3n7rjdDN4nLGUIDtkrddZVcOhfMim1OAd1INEFUerx48uT6OR+xO3DuTqhQZkpukzv6lRNAM0eyxJltiIPDB7gBe8+Ca3CvWp+ehDbWwsor7X3FJZeEUzSlHI/Qh1Gzo0glgZXebAyfVwLzs7VL5MVReMovD+6VlDE+vNgoHJ60BvhHVACH9nDVls8iDFKoyybHMCFWxX+W6o+qx9Gx/IGg9yuinWAZVQ8oYfsJ1oLG8ZFsjg8+Ie1MG+tbxMOA+u6P85IsjlNjYyX0L3dVvanMRM/Nbagy+yFHWHgHSbF3ZTupjb8ca8zCOOq2ynuwQX6fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NdffY/tqdOFPmrF6nS8nksD/iu994gESDo7Trtip2AM=;
 b=q7N6EyPArA/GjR05cbdf4bYAqnZ65CJFNEQOI0R+O7pLHJ6BkvPyR6eOGm3w4PbotNZtXDtDVFoVAmHjlthf08eVNrWx7oyjs0H6KSwZH5G4g/+766sr61abLedwsUyTeVkPdhShjuOX+zlZxMamxkFTzk5QBx9FjnSP8qlhNqs=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4272.eurprd05.prod.outlook.com (10.171.182.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.22; Tue, 22 Oct 2019 04:44:24 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::f42d:b87a:e6b2:f841%7]) with mapi id 15.20.2347.029; Tue, 22 Oct 2019
 04:44:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH net-next 3/4] page_pool: Restructure __page_pool_put_page()
Thread-Topic: [PATCH net-next 3/4] page_pool: Restructure
 __page_pool_put_page()
Thread-Index: AQHViJNgKuuKGDOcK06kNreIia0L5w==
Date:   Tue, 22 Oct 2019 04:44:24 +0000
Message-ID: <20191022044343.6901-4-saeedm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 0d178cf5-e40b-4b96-edbe-08d756aa830b
x-ms-traffictypediagnostic: VI1PR05MB4272:|VI1PR05MB4272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4272739267E5B497F47F252DBE680@VI1PR05MB4272.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(199004)(189003)(4326008)(81166006)(36756003)(316002)(110136005)(25786009)(14444005)(81156014)(256004)(8676002)(305945005)(7736002)(14454004)(54906003)(8936002)(478600001)(2906002)(1076003)(71200400001)(71190400001)(66476007)(50226002)(52116002)(6116002)(11346002)(6436002)(76176011)(3846002)(446003)(386003)(26005)(102836004)(86362001)(6506007)(6486002)(6512007)(5660300002)(186003)(66446008)(66946007)(486006)(99286004)(476003)(64756008)(66066001)(107886003)(2616005)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4272;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: S5hXY3aDcBidLOWo15+4sevpEaC5yCDSkkO4C7iwQbdMhtQWSj2y8g9CkhowhldMD+l1U+6AGd2h5jotwoVz0LvR3zTaVF3IPafvBiX+Uxd7IqqtVElaOFcuWZ4VfnxF8LJZXi6vNaNJ8aremaVSIUKFfVHrISFq6als+BOXjyq1LINwuP60sbB/RtSs+YBf+tTtzHSCyRhFNKDkaLEB6viSTM0EMuTLIH6hctRNrj1eq0qUYmySyaWSsHUIDViNg+Q5YRvGzdbQhSzt6SU1lUk60aQPBKBjLByIhnwAWMfK6kEPUS6fYiq0sjE4t4AG3lnYX2kbABjrtR4VAGL657K7FBuWeG9ud7sww/4+5QfijbDajVDKu7Hn6uERVk5BsPgPdMGw0qy3/BvuB8f13mCmWK4eztnCpDT4u7XrW66zZIhdcZ1Kx/dCxH64OWJp
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d178cf5-e40b-4b96-edbe-08d756aa830b
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 04:44:24.0419
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mEcxJ/NkEsP4IViLWGmYO5KHxGCQVizIDO4oQDzftuiu+iK28yiNRHisXe7CYr3NoIodcbN8iQ2JGfyhXe4t8A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4272
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonathan Lemon <jonathan.lemon@gmail.com>

1) Rename functions to reflect what they are actually doing.

2) Unify the condition to keep a page.

3) When page can't be kept in cache, fallback to releasing page to page
allocator in one place, instead of calling it from multiple conditions,
and reuse __page_pool_return_page().

Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 net/core/page_pool.c | 38 +++++++++++++++++++-------------------
 1 file changed, 19 insertions(+), 19 deletions(-)

diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 8120aec999ce..65680aaa0818 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -258,6 +258,7 @@ static bool __page_pool_recycle_into_ring(struct page_p=
ool *pool,
 				   struct page *page)
 {
 	int ret;
+
 	/* BH protection not needed if current is serving softirq */
 	if (in_serving_softirq())
 		ret =3D ptr_ring_produce(&pool->ring, page);
@@ -272,8 +273,8 @@ static bool __page_pool_recycle_into_ring(struct page_p=
ool *pool,
  *
  * Caller must provide appropriate safe context.
  */
-static bool __page_pool_recycle_direct(struct page *page,
-				       struct page_pool *pool)
+static bool __page_pool_recycle_into_cache(struct page *page,
+					   struct page_pool *pool)
 {
 	if (unlikely(pool->alloc.count =3D=3D PP_ALLOC_CACHE_SIZE))
 		return false;
@@ -283,15 +284,18 @@ static bool __page_pool_recycle_direct(struct page *p=
age,
 	return true;
 }
=20
-/* page is NOT reusable when:
- * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
- * 2) belongs to a different NUMA node than pool->p.nid.
+/* Keep page in caches only if page:
+ * 1) wasn't allocated when system is under some pressure (page_is_pfmemal=
loc).
+ * 2) belongs to pool's numa node (pool->p.nid).
+ * 3) refcount is 1 (owned by page pool).
  *
  * To update pool->p.nid users must call page_pool_update_nid.
  */
-static bool pool_page_reusable(struct page_pool *pool, struct page *page)
+static bool page_pool_keep_page(struct page_pool *pool, struct page *page)
 {
-	return !page_is_pfmemalloc(page) && page_to_nid(page) =3D=3D pool->p.nid;
+	return !page_is_pfmemalloc(page) &&
+	       page_to_nid(page) =3D=3D pool->p.nid &&
+	       page_ref_count(page) =3D=3D 1;
 }
=20
 void __page_pool_put_page(struct page_pool *pool,
@@ -300,22 +304,19 @@ void __page_pool_put_page(struct page_pool *pool,
 	/* This allocator is optimized for the XDP mode that uses
 	 * one-frame-per-page, but have fallbacks that act like the
 	 * regular page allocator APIs.
-	 *
-	 * refcnt =3D=3D 1 means page_pool owns page, and can recycle it.
 	 */
-	if (likely(page_ref_count(page) =3D=3D 1 &&
-		   pool_page_reusable(pool, page))) {
+
+	if (likely(page_pool_keep_page(pool, page))) {
 		/* Read barrier done in page_ref_count / READ_ONCE */
=20
 		if (allow_direct && in_serving_softirq())
-			if (__page_pool_recycle_direct(page, pool))
+			if (__page_pool_recycle_into_cache(page, pool))
 				return;
=20
-		if (!__page_pool_recycle_into_ring(pool, page)) {
-			/* Cache full, fallback to free pages */
-			__page_pool_return_page(pool, page);
-		}
-		return;
+		if (__page_pool_recycle_into_ring(pool, page))
+			return;
+
+		/* Cache full, fallback to return pages */
 	}
 	/* Fallback/non-XDP mode: API user have elevated refcnt.
 	 *
@@ -330,8 +331,7 @@ void __page_pool_put_page(struct page_pool *pool,
 	 * doing refcnt based recycle tricks, meaning another process
 	 * will be invoking put_page.
 	 */
-	__page_pool_clean_page(pool, page);
-	put_page(page);
+	__page_pool_return_page(pool, page);
 }
 EXPORT_SYMBOL(__page_pool_put_page);
=20
--=20
2.21.0

