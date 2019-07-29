Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BECFB79AB9
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 23:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388422AbfG2VM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 17:12:59 -0400
Received: from mail-eopbgr10054.outbound.protection.outlook.com ([40.107.1.54]:2445
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388394AbfG2VM6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 17:12:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TXtr4Lo+g/rtvL/dp9ArL1Vw5WsjPLCH8gYpdmYGp5GAEh7gfton3sVq75Qq0kwY9WVb0tKJbuQOlF/WK9ij7NH2WpL7xa2YqZ+SZpS2zMsX0owHiv8fu4Amgi6nLH8eql8VaA43PhVBUkF3yelKpmWuHZLQ5vyJEIZRK2u4uk0bCuCr63Pq7SJ5hSn+O6J4Rqhz/FSPb5wKzkx5qHA+mAGLSbRN9rvZTmuMGqu58utG5bVFXwNRNPCbFcAKWyPZw/bmowg6LGFevPOVfQVrjYu6E5WiNu15iblolo4hOH8mNfkpFMWopPycwqDLV1UuwlaG4b3ELOwJ6YLggMM3hA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTe5Bncinkzetcge/gKTMlm7NypFzMfsd4lJlCVJJpg=;
 b=edkRcR/ln4DeCMM7GP3woeSHAw3wK/DDpqjTFVGbZpYO8c0NTQEfvdCgq/F13wwYQIAz5tNHFUi3VEkJEOFIE06oMQq5pLl6/77Xa6V1XI+29oOucDhccgjdQgJ4EBbA++A1ayFf02UEmW1WueYOD1z9ab4kTrm1TWgBvaxgK71UdrpY8uRw1hqwu1YrheLqkRUeLe9MOTPWAXGsDi4b3X09H/kGglu5XZAxiT7RS9L01v9PtdxhBHPwtGS84Xab0vmUX1TroFa2ay354m+x3MEZFcKnnmVq6t33mMEPwy5OWeTqzrWihy0YmcGoheq+WvAFxDO/KFXpa94DGR8GvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTe5Bncinkzetcge/gKTMlm7NypFzMfsd4lJlCVJJpg=;
 b=KwBDgTGutmMaiy61Pdy/Y4MvwjeE8tCS6x3dTJyvQR1m2tXyW3k2qKSdBB4RS+MCWE2t2L9OTOLvUtSdy8t/+sRt41n//h1N41h5DSL6/IrVHSeWLcJGx6RfV65d1YbufcSz54hHn1lSFgkTZjOYeZDaEpRSAlrM6h1os/ZPCvk=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2375.eurprd05.prod.outlook.com (10.168.72.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.10; Mon, 29 Jul 2019 21:12:52 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 21:12:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     Gavi Teitz <gavi@mellanox.com>, Vlad Buslov <vladbu@mellanox.com>
Subject: [PATCH mlx5-next 01/11] net/mlx5: Refactor and optimize flow counter
 bulk query
Thread-Topic: [PATCH mlx5-next 01/11] net/mlx5: Refactor and optimize flow
 counter bulk query
Thread-Index: AQHVRlJiyiCMNupJjUmwDc2HU7YCxg==
Date:   Mon, 29 Jul 2019 21:12:52 +0000
Message-ID: <20190729211209.14772-2-saeedm@mellanox.com>
References: <20190729211209.14772-1-saeedm@mellanox.com>
In-Reply-To: <20190729211209.14772-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR05CA0081.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::22) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbf5aac4-3246-44ef-24d7-08d71469847f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2375;
x-ms-traffictypediagnostic: DB6PR0501MB2375:
x-microsoft-antispam-prvs: <DB6PR0501MB2375FB7DA372CFC48188FA00BEDD0@DB6PR0501MB2375.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(199004)(189003)(50226002)(14444005)(5660300002)(6116002)(3846002)(486006)(446003)(86362001)(81156014)(186003)(36756003)(81166006)(8936002)(26005)(25786009)(316002)(71190400001)(71200400001)(110136005)(54906003)(64756008)(76176011)(66556008)(2906002)(66946007)(66446008)(99286004)(66476007)(1076003)(386003)(6506007)(102836004)(256004)(7736002)(6486002)(14454004)(66066001)(2501003)(8676002)(305945005)(6436002)(4326008)(11346002)(68736007)(52116002)(2616005)(30864003)(476003)(478600001)(6512007)(450100002)(2201001)(107886003)(53936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2375;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: I3WGPh2Ua4HuDN3dDtd1twXboT4WhavgJEoq8Z9ZVa6F3x4mlc72tUsiyahhAvP3Oz4bobUy0EsHRUJAm5iG7IPlcAYktSw5ECZ9/KAFWmdFagLZ77BISkfW8djXANsZfivUESBfz8yZbFOEOR07AmZD1laBADmjBcdKdWJjXsiXAEFkb6V1i4Yv6+1POzjmGjRQVaOuO/MuJhxF0wUrQNgh2nekuVB1xoW2qPFOcuFwVNUpGznacEd0B05F/9f8yD0ot7LxlQZnyxLm0DNrH+TxGn3Usw8RxCs4cGIkUhKJo2Ky1RbC64W87OziJ42cG0oamGs2suDoDLFgac7GP0LBlt6U9FmLcXXNcLknvqCxnw6xc32NsHWQTJaJkRx5CsY+9f+KRdhmpIJFzHZbDEwjhA9baG/wOZHBQn1t6VE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf5aac4-3246-44ef-24d7-08d71469847f
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 21:12:52.6619
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2375
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gavi Teitz <gavi@mellanox.com>

Towards introducing the ability to allocate bulks of flow counters,
refactor the flow counter bulk query process, removing functions and
structs whose names indicated being used for flow counter bulk
allocation FW commands, despite them actually only being used to
support bulk querying, and migrate their functionality to correctly
named functions in their natural location, fs_counters.c.

Additionally, optimize the bulk query process by:
 * Extracting the memory used for the query to mlx5_fc_stats so
   that it is only allocated once, and not for each bulk query.
 * Querying all the counters in one function call.

Signed-off-by: Gavi Teitz <gavi@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |  61 ++-------
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.h  |  13 +-
 .../ethernet/mellanox/mlx5/core/fs_counters.c | 125 ++++++++++--------
 include/linux/mlx5/driver.h                   |   1 +
 4 files changed, 81 insertions(+), 119 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.c
index 7ac1249eadc3..51f6972f4c70 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c
@@ -615,67 +615,24 @@ int mlx5_cmd_fc_query(struct mlx5_core_dev *dev, u32 =
id,
 	return 0;
 }
=20
-struct mlx5_cmd_fc_bulk {
-	u32 id;
-	int num;
-	int outlen;
-	u32 out[0];
-};
-
-struct mlx5_cmd_fc_bulk *
-mlx5_cmd_fc_bulk_alloc(struct mlx5_core_dev *dev, u32 id, int num)
+int mlx5_cmd_fc_get_bulk_query_out_len(int bulk_len)
 {
-	struct mlx5_cmd_fc_bulk *b;
-	int outlen =3D
-		MLX5_ST_SZ_BYTES(query_flow_counter_out) +
-		MLX5_ST_SZ_BYTES(traffic_counter) * num;
-
-	b =3D kzalloc(sizeof(*b) + outlen, GFP_KERNEL);
-	if (!b)
-		return NULL;
-
-	b->id =3D id;
-	b->num =3D num;
-	b->outlen =3D outlen;
-
-	return b;
+	return MLX5_ST_SZ_BYTES(query_flow_counter_out) +
+		MLX5_ST_SZ_BYTES(traffic_counter) * bulk_len;
 }
=20
-void mlx5_cmd_fc_bulk_free(struct mlx5_cmd_fc_bulk *b)
-{
-	kfree(b);
-}
-
-int
-mlx5_cmd_fc_bulk_query(struct mlx5_core_dev *dev, struct mlx5_cmd_fc_bulk =
*b)
+int mlx5_cmd_fc_bulk_query(struct mlx5_core_dev *dev, u32 base_id, int bul=
k_len,
+			   u32 *out)
 {
+	int outlen =3D mlx5_cmd_fc_get_bulk_query_out_len(bulk_len);
 	u32 in[MLX5_ST_SZ_DW(query_flow_counter_in)] =3D {0};
=20
 	MLX5_SET(query_flow_counter_in, in, opcode,
 		 MLX5_CMD_OP_QUERY_FLOW_COUNTER);
 	MLX5_SET(query_flow_counter_in, in, op_mod, 0);
-	MLX5_SET(query_flow_counter_in, in, flow_counter_id, b->id);
-	MLX5_SET(query_flow_counter_in, in, num_of_counters, b->num);
-	return mlx5_cmd_exec(dev, in, sizeof(in), b->out, b->outlen);
-}
-
-void mlx5_cmd_fc_bulk_get(struct mlx5_core_dev *dev,
-			  struct mlx5_cmd_fc_bulk *b, u32 id,
-			  u64 *packets, u64 *bytes)
-{
-	int index =3D id - b->id;
-	void *stats;
-
-	if (index < 0 || index >=3D b->num) {
-		mlx5_core_warn(dev, "Flow counter id (0x%x) out of range (0x%x..0x%x). C=
ounter ignored.\n",
-			       id, b->id, b->id + b->num - 1);
-		return;
-	}
-
-	stats =3D MLX5_ADDR_OF(query_flow_counter_out, b->out,
-			     flow_statistics[index]);
-	*packets =3D MLX5_GET64(traffic_counter, stats, packets);
-	*bytes =3D MLX5_GET64(traffic_counter, stats, octets);
+	MLX5_SET(query_flow_counter_in, in, flow_counter_id, base_id);
+	MLX5_SET(query_flow_counter_in, in, num_of_counters, bulk_len);
+	return mlx5_cmd_exec(dev, in, sizeof(in), out, outlen);
 }
=20
 int mlx5_packet_reformat_alloc(struct mlx5_core_dev *dev,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h b/drivers/net=
/ethernet/mellanox/mlx5/core/fs_cmd.h
index e340f9af2f5a..db49eabba98d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.h
@@ -82,16 +82,9 @@ int mlx5_cmd_fc_free(struct mlx5_core_dev *dev, u32 id);
 int mlx5_cmd_fc_query(struct mlx5_core_dev *dev, u32 id,
 		      u64 *packets, u64 *bytes);
=20
-struct mlx5_cmd_fc_bulk;
-
-struct mlx5_cmd_fc_bulk *
-mlx5_cmd_fc_bulk_alloc(struct mlx5_core_dev *dev, u32 id, int num);
-void mlx5_cmd_fc_bulk_free(struct mlx5_cmd_fc_bulk *b);
-int
-mlx5_cmd_fc_bulk_query(struct mlx5_core_dev *dev, struct mlx5_cmd_fc_bulk =
*b);
-void mlx5_cmd_fc_bulk_get(struct mlx5_core_dev *dev,
-			  struct mlx5_cmd_fc_bulk *b, u32 id,
-			  u64 *packets, u64 *bytes);
+int mlx5_cmd_fc_get_bulk_query_out_len(int bulk_len);
+int mlx5_cmd_fc_bulk_query(struct mlx5_core_dev *dev, u32 base_id, int bul=
k_len,
+			   u32 *out);
=20
 const struct mlx5_flow_cmds *mlx5_fs_cmd_get_default(enum fs_flow_table_ty=
pe type);
=20
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c b/driver=
s/net/ethernet/mellanox/mlx5/core/fs_counters.c
index b3762123a69c..067a4b56498b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_counters.c
@@ -75,7 +75,7 @@ struct mlx5_fc {
  * access to counter list:
  * - create (user context)
  *   - mlx5_fc_create() only adds to an addlist to be used by
- *     mlx5_fc_stats_query_work(). addlist is a lockless single linked lis=
t
+ *     mlx5_fc_stats_work(). addlist is a lockless single linked list
  *     that doesn't require any additional synchronization when adding sin=
gle
  *     node.
  *   - spawn thread to do the actual destroy
@@ -136,72 +136,69 @@ static void mlx5_fc_stats_remove(struct mlx5_core_dev=
 *dev,
 	spin_unlock(&fc_stats->counters_idr_lock);
 }
=20
-/* The function returns the last counter that was queried so the caller
- * function can continue calling it till all counters are queried.
- */
-static struct mlx5_fc *mlx5_fc_stats_query(struct mlx5_core_dev *dev,
-					   struct mlx5_fc *first,
-					   u32 last_id)
+static int get_max_bulk_query_len(struct mlx5_core_dev *dev)
 {
-	struct mlx5_fc_stats *fc_stats =3D &dev->priv.fc_stats;
-	struct mlx5_fc *counter =3D NULL;
-	struct mlx5_cmd_fc_bulk *b;
-	bool more =3D false;
-	u32 afirst_id;
-	int num;
-	int err;
+	return min_t(int, MLX5_SW_MAX_COUNTERS_BULK,
+			  (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));
+}
=20
-	int max_bulk =3D min_t(int, MLX5_SW_MAX_COUNTERS_BULK,
-			     (1 << MLX5_CAP_GEN(dev, log_max_flow_counter_bulk)));
+static void update_counter_cache(int index, u32 *bulk_raw_data,
+				 struct mlx5_fc_cache *cache)
+{
+	void *stats =3D MLX5_ADDR_OF(query_flow_counter_out, bulk_raw_data,
+			     flow_statistics[index]);
+	u64 packets =3D MLX5_GET64(traffic_counter, stats, packets);
+	u64 bytes =3D MLX5_GET64(traffic_counter, stats, octets);
=20
-	/* first id must be aligned to 4 when using bulk query */
-	afirst_id =3D first->id & ~0x3;
+	if (cache->packets =3D=3D packets)
+		return;
=20
-	/* number of counters to query inc. the last counter */
-	num =3D ALIGN(last_id - afirst_id + 1, 4);
-	if (num > max_bulk) {
-		num =3D max_bulk;
-		last_id =3D afirst_id + num - 1;
-	}
+	cache->packets =3D packets;
+	cache->bytes =3D bytes;
+	cache->lastuse =3D jiffies;
+}
=20
-	b =3D mlx5_cmd_fc_bulk_alloc(dev, afirst_id, num);
-	if (!b) {
-		mlx5_core_err(dev, "Error allocating resources for bulk query\n");
-		return NULL;
-	}
+static void mlx5_fc_stats_query_counter_range(struct mlx5_core_dev *dev,
+					      struct mlx5_fc *first,
+					      u32 last_id)
+{
+	struct mlx5_fc_stats *fc_stats =3D &dev->priv.fc_stats;
+	bool query_more_counters =3D (first->id <=3D last_id);
+	int max_bulk_len =3D get_max_bulk_query_len(dev);
+	u32 *data =3D fc_stats->bulk_query_out;
+	struct mlx5_fc *counter =3D first;
+	u32 bulk_base_id;
+	int bulk_len;
+	int err;
=20
-	err =3D mlx5_cmd_fc_bulk_query(dev, b);
-	if (err) {
-		mlx5_core_err(dev, "Error doing bulk query: %d\n", err);
-		goto out;
-	}
+	while (query_more_counters) {
+		/* first id must be aligned to 4 when using bulk query */
+		bulk_base_id =3D counter->id & ~0x3;
=20
-	counter =3D first;
-	list_for_each_entry_from(counter, &fc_stats->counters, list) {
-		struct mlx5_fc_cache *c =3D &counter->cache;
-		u64 packets;
-		u64 bytes;
+		/* number of counters to query inc. the last counter */
+		bulk_len =3D min_t(int, max_bulk_len,
+				 ALIGN(last_id - bulk_base_id + 1, 4));
=20
-		if (counter->id > last_id) {
-			more =3D true;
-			break;
+		err =3D mlx5_cmd_fc_bulk_query(dev, bulk_base_id, bulk_len,
+					     data);
+		if (err) {
+			mlx5_core_err(dev, "Error doing bulk query: %d\n", err);
+			return;
 		}
+		query_more_counters =3D false;
=20
-		mlx5_cmd_fc_bulk_get(dev, b,
-				     counter->id, &packets, &bytes);
+		list_for_each_entry_from(counter, &fc_stats->counters, list) {
+			int counter_index =3D counter->id - bulk_base_id;
+			struct mlx5_fc_cache *cache =3D &counter->cache;
=20
-		if (c->packets =3D=3D packets)
-			continue;
+			if (counter->id >=3D bulk_base_id + bulk_len) {
+				query_more_counters =3D true;
+				break;
+			}
=20
-		c->packets =3D packets;
-		c->bytes =3D bytes;
-		c->lastuse =3D jiffies;
+			update_counter_cache(counter_index, data, cache);
+		}
 	}
-
-out:
-	mlx5_cmd_fc_bulk_free(b);
-
-	return more ? counter : NULL;
 }
=20
 static void mlx5_free_fc(struct mlx5_core_dev *dev,
@@ -244,8 +241,8 @@ static void mlx5_fc_stats_work(struct work_struct *work=
)
=20
 	counter =3D list_first_entry(&fc_stats->counters, struct mlx5_fc,
 				   list);
-	while (counter)
-		counter =3D mlx5_fc_stats_query(dev, counter, last->id);
+	if (counter)
+		mlx5_fc_stats_query_counter_range(dev, counter, last->id);
=20
 	fc_stats->next_query =3D now + fc_stats->sampling_interval;
 }
@@ -324,6 +321,8 @@ EXPORT_SYMBOL(mlx5_fc_destroy);
 int mlx5_init_fc_stats(struct mlx5_core_dev *dev)
 {
 	struct mlx5_fc_stats *fc_stats =3D &dev->priv.fc_stats;
+	int max_bulk_len;
+	int max_out_len;
=20
 	spin_lock_init(&fc_stats->counters_idr_lock);
 	idr_init(&fc_stats->counters_idr);
@@ -331,14 +330,24 @@ int mlx5_init_fc_stats(struct mlx5_core_dev *dev)
 	init_llist_head(&fc_stats->addlist);
 	init_llist_head(&fc_stats->dellist);
=20
+	max_bulk_len =3D get_max_bulk_query_len(dev);
+	max_out_len =3D mlx5_cmd_fc_get_bulk_query_out_len(max_bulk_len);
+	fc_stats->bulk_query_out =3D kzalloc(max_out_len, GFP_KERNEL);
+	if (!fc_stats->bulk_query_out)
+		return -ENOMEM;
+
 	fc_stats->wq =3D create_singlethread_workqueue("mlx5_fc");
 	if (!fc_stats->wq)
-		return -ENOMEM;
+		goto err_wq_create;
=20
 	fc_stats->sampling_interval =3D MLX5_FC_STATS_PERIOD;
 	INIT_DELAYED_WORK(&fc_stats->work, mlx5_fc_stats_work);
=20
 	return 0;
+
+err_wq_create:
+	kfree(fc_stats->bulk_query_out);
+	return -ENOMEM;
 }
=20
 void mlx5_cleanup_fc_stats(struct mlx5_core_dev *dev)
@@ -352,6 +361,8 @@ void mlx5_cleanup_fc_stats(struct mlx5_core_dev *dev)
 	destroy_workqueue(dev->priv.fc_stats.wq);
 	dev->priv.fc_stats.wq =3D NULL;
=20
+	kfree(fc_stats->bulk_query_out);
+
 	idr_destroy(&fc_stats->counters_idr);
=20
 	tmplist =3D llist_del_all(&fc_stats->addlist);
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 0e6da1840c7d..267b2bc0ca4a 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -488,6 +488,7 @@ struct mlx5_fc_stats {
 	struct delayed_work work;
 	unsigned long next_query;
 	unsigned long sampling_interval; /* jiffies */
+	u32 *bulk_query_out;
 };
=20
 struct mlx5_events;
--=20
2.21.0

