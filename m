Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE485ECA9A
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727413AbfKAV7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:59:19 -0400
Received: from mail-eopbgr20063.outbound.protection.outlook.com ([40.107.2.63]:44510
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727316AbfKAV7T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:59:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FUQIGYCH9i/wTkiS8lDQZIiVKVVO9zuGU2Wy/1TUULgnS+/grMqLmWPQvk7G9Iya/knrl0Iu/DG4qdYYDTbqi6lYuC2e7sUu86+VAzKNApNkF1v1CsFLtlo2imAm3pB5uapo7DaqelVMKOWTv4dBVRKttc5ER0nsn/e8+a0UTw5UrgHgIR27uDHEOEZEAbQnE47wnm6tnIZJpA/a4zFmZ68JEE0XCRerZZt27ioF+dGtLVR6GyehB/FqAib4LttufD+mGp5XSpJzPeeqAaT0AKM1b9SLYlhcyRWNUQFuAFU8+ZKN/jUJK60L+XWiAUZaHtzDmUHKN36ZJRWmNsopPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmRnUc8rC9AE7BacgqOYEymq9ruObte36wd+u8SzcLE=;
 b=NX32OJS0RcLFuKO04rari2F531/yq451HCCHu358I+iYk2juuqcAUmQUROdB1wwqZplOBnBO6pwtLrt2o6YZGFtL+39LV8p6fB+YyBvCTJHwSq/bHt0yhtiemCM+zpGIX3ic4OcKj1oUDMij2pbCckjWtJ4Vf/GT2IEC6xxXLo5X0Ft8wM51qcW1wr0PoUgTrE3DTu+tBAzHigcoM7WmIyAY/BU9G9p3dxQ7hmgSgsJuaWdhx5q5hFafufg3ScAlWdgGot2cXiqpR3HRDVmXyBqjcE0v1zrithy4DJQBQYbD2sXzRV5DbysRHbV7GMDVkVnoCTwbmjyAn3s3mnLzVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmRnUc8rC9AE7BacgqOYEymq9ruObte36wd+u8SzcLE=;
 b=hU1d4sQyaUruUwkwDONJ/5S29skIeNQr1ahaJ0ffsCB4/oQOtJGrm/WxVQELFn1F1if87u/m4v6HjxqcmghMzZDJ1hgfeXp7XPRJiPIExNOpTrxfrg7yqNrmDeaEIIiVPXT05DJBpK0njtw2fkGVw9DKdqtLyRV2y3DYoL0EBrM=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6173.eurprd05.prod.outlook.com (20.178.123.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 21:59:09 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:59:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/15] net/mlx5: Support lockless FTE read lookups
Thread-Topic: [net-next 07/15] net/mlx5: Support lockless FTE read lookups
Thread-Index: AQHVkP+WiBheWLJSmUeDsWxLZbXpDQ==
Date:   Fri, 1 Nov 2019 21:59:09 +0000
Message-ID: <20191101215833.23975-8-saeedm@mellanox.com>
References: <20191101215833.23975-1-saeedm@mellanox.com>
In-Reply-To: <20191101215833.23975-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0076.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 83815d59-ed44-410d-8afd-08d75f16b907
x-ms-traffictypediagnostic: VI1PR05MB6173:|VI1PR05MB6173:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB617326C21D6B6E218687A0FABE620@VI1PR05MB6173.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(396003)(376002)(39860400002)(136003)(189003)(199004)(476003)(5660300002)(486006)(14454004)(107886003)(76176011)(7736002)(478600001)(66066001)(52116002)(2906002)(71190400001)(8676002)(71200400001)(6486002)(102836004)(81166006)(36756003)(81156014)(50226002)(6436002)(386003)(8936002)(6506007)(25786009)(66446008)(66476007)(6512007)(6116002)(3846002)(6916009)(26005)(99286004)(11346002)(66946007)(64756008)(86362001)(305945005)(54906003)(4326008)(316002)(1076003)(14444005)(186003)(446003)(2616005)(256004)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6173;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kuOV2NY5quvSlR2x073EI318hRteilCm2WBS85H9cbItUy3vzHJQ+LfQ9Fw0Wnl6lSJfML0fMqe7KhyvTfjEH8jQonjGIQggM3OFKMJw1/2QkBrf+6Jjbd4l/VYVtMB+k8rrQCu9gFhLP4uj+UwiAdZRcPzcEmzR6zOFNTfEOqF4nhMdW/ZiPvpVALAeJ/8+07GozyFPZDtbQ/DQ6+o74nCzDeaMXtOPyW6XLzZ9Jt1vQ26r+v9HLRRoLHzY8cWMJ51Vn5P5oHMqHprjLPQpt3OQ1teWHODK9g7E8WDeLKDZQukbi+kGfsbTv1T+N5gepHAABxHifP9WNlF+o/VwrhxIR9BjWKJZrwr0Y7SlK/wCAgsWIIomec8ur5meq4IKaAZDy51LlQMmGgoSIsA+To6+apfCHG/levmp9n8oOJHRQuJMVQMKZAvHHoo+w/Pu
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83815d59-ed44-410d-8afd-08d75f16b907
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:59:09.6301
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZcXGJ6hL4bjp0xR2iUX6kAEJRjMgQtJDd/PqmwVq37PeW2W0dQFLcfKKschCnyRytEkv7S1NhLMp39ZJUOJ+AQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6173
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

During connection tracking offloads with high number of connections,
(40K connections per second), flow table group lock contention is
observed.
To improve the performance by reducing lock contention, lockless
FTE read lookup is performed as described below.

Each flow table entry is refcounted.
Flow table entry is removed when refcount drops to zero.
rhash table allows rcu protected lookup.
Each hash table entry insertion and removal is write lock protected.

Hence, it is possible to perform lockless lookup in rhash table using
following scheme.

(a) Guard FTE entry lookup per group using rcu read lock.
(b) Before freeing the FTE entry, wait for all readers to finish
accessing the FTE.

Below example of one reader and write in parallel racing, shows
protection in effect with rcu lock.

lookup_fte_locked()
  rcu_read_lock();
  search_hash_table()
                                  existing_flow_group_write_lock();
                                  tree_put_node(fte)
                                    drop_ref_cnt(fte)
                                    del_sw_fte(fte)
                                    del_hash_table_entry();
                                    call_rcu();
                                  existing_flow_group_write_unlock();
  get_ref_cnt(fte) fails
  rcu_read_unlock();
                                  rcu grace period();
                                    [..]
                                    kmem_cache_free(fte);

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_core.c | 70 +++++++++++++++----
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |  1 +
 2 files changed, 56 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.c
index e5591f4f19b7..0246f5cdd355 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -531,9 +531,16 @@ static void del_hw_fte(struct fs_node *node)
 	}
 }
=20
+static void del_sw_fte_rcu(struct rcu_head *head)
+{
+	struct fs_fte *fte =3D container_of(head, struct fs_fte, rcu);
+	struct mlx5_flow_steering *steering =3D get_steering(&fte->node);
+
+	kmem_cache_free(steering->ftes_cache, fte);
+}
+
 static void del_sw_fte(struct fs_node *node)
 {
-	struct mlx5_flow_steering *steering =3D get_steering(node);
 	struct mlx5_flow_group *fg;
 	struct fs_fte *fte;
 	int err;
@@ -546,7 +553,8 @@ static void del_sw_fte(struct fs_node *node)
 				     rhash_fte);
 	WARN_ON(err);
 	ida_simple_remove(&fg->fte_allocator, fte->index - fg->start_index);
-	kmem_cache_free(steering->ftes_cache, fte);
+
+	call_rcu(&fte->rcu, del_sw_fte_rcu);
 }
=20
 static void del_hw_flow_group(struct fs_node *node)
@@ -1623,22 +1631,47 @@ static u64 matched_fgs_get_version(struct list_head=
 *match_head)
 }
=20
 static struct fs_fte *
-lookup_fte_locked(struct mlx5_flow_group *g,
-		  const u32 *match_value,
-		  bool take_write)
+lookup_fte_for_write_locked(struct mlx5_flow_group *g, const u32 *match_va=
lue)
 {
 	struct fs_fte *fte_tmp;
=20
-	if (take_write)
-		nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
-	else
-		nested_down_read_ref_node(&g->node, FS_LOCK_PARENT);
-	fte_tmp =3D rhashtable_lookup_fast(&g->ftes_hash, match_value,
-					 rhash_fte);
+	nested_down_write_ref_node(&g->node, FS_LOCK_PARENT);
+
+	fte_tmp =3D rhashtable_lookup_fast(&g->ftes_hash, match_value, rhash_fte)=
;
 	if (!fte_tmp || !tree_get_node(&fte_tmp->node)) {
 		fte_tmp =3D NULL;
 		goto out;
 	}
+
+	if (!fte_tmp->node.active) {
+		tree_put_node(&fte_tmp->node, false);
+		fte_tmp =3D NULL;
+		goto out;
+	}
+	nested_down_write_ref_node(&fte_tmp->node, FS_LOCK_CHILD);
+
+out:
+	up_write_ref_node(&g->node, false);
+	return fte_tmp;
+}
+
+static struct fs_fte *
+lookup_fte_for_read_locked(struct mlx5_flow_group *g, const u32 *match_val=
ue)
+{
+	struct fs_fte *fte_tmp;
+
+	if (!tree_get_node(&g->node))
+		return NULL;
+
+	rcu_read_lock();
+	fte_tmp =3D rhashtable_lookup(&g->ftes_hash, match_value, rhash_fte);
+	if (!fte_tmp || !tree_get_node(&fte_tmp->node)) {
+		rcu_read_unlock();
+		fte_tmp =3D NULL;
+		goto out;
+	}
+	rcu_read_unlock();
+
 	if (!fte_tmp->node.active) {
 		tree_put_node(&fte_tmp->node, false);
 		fte_tmp =3D NULL;
@@ -1646,14 +1679,21 @@ lookup_fte_locked(struct mlx5_flow_group *g,
 	}
=20
 	nested_down_write_ref_node(&fte_tmp->node, FS_LOCK_CHILD);
+
 out:
-	if (take_write)
-		up_write_ref_node(&g->node, false);
-	else
-		up_read_ref_node(&g->node);
+	tree_put_node(&g->node, false);
 	return fte_tmp;
 }
=20
+static struct fs_fte *
+lookup_fte_locked(struct mlx5_flow_group *g, const u32 *match_value, bool =
write)
+{
+	if (write)
+		return lookup_fte_for_write_locked(g, match_value);
+	else
+		return lookup_fte_for_read_locked(g, match_value);
+}
+
 static struct mlx5_flow_handle *
 try_add_to_existing_fg(struct mlx5_flow_table *ft,
 		       struct list_head *match_head,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/fs_core.h
index 00717eba2256..f278298b0f6e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.h
@@ -202,6 +202,7 @@ struct fs_fte {
 	enum fs_fte_status		status;
 	struct mlx5_fc			*counter;
 	struct rhash_head		hash;
+	struct rcu_head	rcu;
 	int				modify_mask;
 };
=20
--=20
2.21.0

