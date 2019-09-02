Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D75DEA4FAB
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 09:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729677AbfIBHXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 03:23:12 -0400
Received: from mail-eopbgr70087.outbound.protection.outlook.com ([40.107.7.87]:57541
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726377AbfIBHXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Sep 2019 03:23:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYOqvkQbMZgDJI/2LtvGPBy7UetTgET/h5o2Jp/kbLZRBPc8E8f/yOR/VUQdawxx09XN4csnSi0HXbXu+ayNctHu2QvaTMS9GQVoMZeDIMSzAZ0mFwuOdHjDRfOwXG4/Vrb+BzytSEdMmA7jU9OasMmTCCtApSJv9y+UzFMJU+oDX+5y4WcR6N8ozUNxtpg3Byt/wP+Pm3lNKmvmU006rWvgTIGO9+gkldxH4NyQm1AxpI65vIQw9NbFzfb5bXfmYpgJam79QqJVTk5lq6I+1Wpj7MjhuZ8b8RsMdEKauWBCpSMrw9vBXHwR73ZONY64EyEFSwTks97iL/E0setxYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+11dUHE8v6dabI5erHu8ln0gkVyOdcjOUY+4l+FA+I=;
 b=h1497cf+dUrYEZ4MNL4XjwLLXbJWSVv+rq64Wbs8MWzXLCFDT1T+YpBLgOFX18FvBIVv3t2UYBiEdGgGsUFpz46wS2x5fnMQtxGhcnIudntVP92llJbLp1XPNxYn9/0qS3ov6JeAJZrkkt0d8gmkUYCLNMt1XFUHO0rxCZYHA2lQUGz+janCGOkPlkl1i71rbDlDqgD0eQqZ+7MsvjVzPgJ2Qd92orYVLWPTJND/D/Gg1M8pCip1ax9sInD7di5aMwsAsFGS92TXsO5Pnm0SzxYmRR621uVoApBcHlkjPbPs9XYtr/CHF4yU7WOXs3xkBJWeFJuEieO6CQr3VmdOIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n+11dUHE8v6dabI5erHu8ln0gkVyOdcjOUY+4l+FA+I=;
 b=RHWLhXewIromLAAwvJofnF2iO3nIrsmqtUQrBW7fIP/aEAGeK6Qslbh9SC561Fuy92DvpnJsvobWtHPycBPWR9O0X6BqhGzS+6LD7/eDH1imrc9hXkrQMw73FPQ6OnjOYHRXfoz+zYf5DxMoS+HBU6oeATGE7ZQmtuNrPxrZQwE=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2259.eurprd05.prod.outlook.com (10.165.38.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Mon, 2 Sep 2019 07:22:59 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::58d1:d1d6:dbda:3576%4]) with mapi id 15.20.2220.021; Mon, 2 Sep 2019
 07:22:59 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Vesker <valex@mellanox.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 04/18] net/mlx5: DR, ICM pool memory allocator
Thread-Topic: [net-next 04/18] net/mlx5: DR, ICM pool memory allocator
Thread-Index: AQHVYV8/WA6RDAlmIEmvSVAJ05OpOQ==
Date:   Mon, 2 Sep 2019 07:22:59 +0000
Message-ID: <20190902072213.7683-5-saeedm@mellanox.com>
References: <20190902072213.7683-1-saeedm@mellanox.com>
In-Reply-To: <20190902072213.7683-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4d1c7b2-b47c-4ab9-be0f-08d72f7661f2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2259;
x-ms-traffictypediagnostic: AM4PR0501MB2259:|AM4PR0501MB2259:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB2259D752ED88C1FD232182D0BEBE0@AM4PR0501MB2259.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 01480965DA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(199004)(189003)(64756008)(478600001)(66946007)(66556008)(71190400001)(71200400001)(6916009)(5660300002)(54906003)(6486002)(8676002)(14454004)(81156014)(36756003)(81166006)(76176011)(1076003)(186003)(50226002)(99286004)(25786009)(4326008)(8936002)(316002)(30864003)(102836004)(386003)(6506007)(2906002)(26005)(14444005)(3846002)(256004)(6116002)(2616005)(66066001)(86362001)(53936002)(52116002)(53946003)(107886003)(486006)(6436002)(305945005)(7736002)(6512007)(446003)(476003)(66446008)(11346002)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2259;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Sj+Pv0+gBlyPl86LCq5SlY07vS2TXzE9POv91OmwApVFymmqSoqTuiV01XDZd948RuIRRSLITPnSiR3RjrKdsx+RAKWPYPESEtKMQ+8DZbog0fRxpElsHtNvepECZmLkVW6pFdTuVTaMv3y/5m1dwx6rjrcLUGI4IjMR6TorKbqBhEl+ifBSUTD3zQFeKU6x+Xe/1u/yZNoZsgUV7bEg0eU5h8GoUwO8dp784VP/ATOGZnM+CnRmNoVlql+J2hxIzkRUCFU+/WKt+quSG6mNqegz13cS2Aa2+wl6Prpxqh5YVmRUlW7UicbxakY+DANFhr5r1Yq8g5qBEUKrrMsB4fvQckIYwhYBMcT8d/vO3g7QB9sz+3SGQeeAfU9672R7lJI/b/Y0vVJPh9BDeWWx7TPCpToVrI0/g/AB7aQ1SJE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4d1c7b2-b47c-4ab9-be0f-08d72f7661f2
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2019 07:22:59.6397
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wlh8HMWdzdl5w00AwbqY//2uJOOb8Qf8aV9Ghdgpym8mg8Y86M7oO8KNW+0pnGKD0Hoc8dliLhp750FQw4kppQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2259
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Vesker <valex@mellanox.com>

ICM device memory is used for writing steering rules (STEs) to the NIC.
An ICM memory pool allocator was implemented to manage the required
memory. The pool consists of buckets, a bucket per chunk size.
Once a bucket is empty we will cut a row of memory from the latest
allocated MR, if the MR size is not sufficient we will allocate a new MR.
HW design requires that chunks memory address should be aligned to the
chunk size, this is the reason for managing the MR with row size that
insures memory alignment.
Current design is greedy in memory but provides quick allocation times
in steady state.

Signed-off-by: Alex Vesker <valex@mellanox.com>
Reviewed-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 570 ++++++++++++++++++
 1 file changed, 570 insertions(+)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm=
_pool.c

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c=
 b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
new file mode 100644
index 000000000000..e76f61e7555e
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -0,0 +1,570 @@
+// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
+/* Copyright (c) 2019 Mellanox Technologies. */
+
+#include "dr_types.h"
+
+#define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
+#define DR_ICM_SYNC_THRESHOLD (64 * 1024 * 1024)
+
+struct mlx5dr_icm_pool;
+
+struct mlx5dr_icm_bucket {
+	struct mlx5dr_icm_pool *pool;
+
+	/* Chunks that aren't visible to HW not directly and not in cache */
+	struct list_head free_list;
+	unsigned int free_list_count;
+
+	/* Used chunks, HW may be accessing this memory */
+	struct list_head used_list;
+	unsigned int used_list_count;
+
+	/* HW may be accessing this memory but at some future,
+	 * undetermined time, it might cease to do so. Before deciding to call
+	 * sync_ste, this list is moved to sync_list
+	 */
+	struct list_head hot_list;
+	unsigned int hot_list_count;
+
+	/* Pending sync list, entries from the hot list are moved to this list.
+	 * sync_ste is executed and then sync_list is concatenated to the free li=
st
+	 */
+	struct list_head sync_list;
+	unsigned int sync_list_count;
+
+	u32 total_chunks;
+	u32 num_of_entries;
+	u32 entry_size;
+	/* protect the ICM bucket */
+	struct mutex mutex;
+};
+
+struct mlx5dr_icm_pool {
+	struct mlx5dr_icm_bucket *buckets;
+	enum mlx5dr_icm_type icm_type;
+	enum mlx5dr_icm_chunk_size max_log_chunk_sz;
+	enum mlx5dr_icm_chunk_size num_of_buckets;
+	struct list_head icm_mr_list;
+	/* protect the ICM MR list */
+	struct mutex mr_mutex;
+	struct mlx5dr_domain *dmn;
+};
+
+struct mlx5dr_icm_dm {
+	u32 obj_id;
+	enum mlx5_sw_icm_type type;
+	u64 addr;
+	size_t length;
+};
+
+struct mlx5dr_icm_mr {
+	struct mlx5dr_icm_pool *pool;
+	struct mlx5_core_mkey mkey;
+	struct mlx5dr_icm_dm dm;
+	size_t used_length;
+	size_t length;
+	u64 icm_start_addr;
+	struct list_head mr_list;
+};
+
+static int dr_icm_create_dm_mkey(struct mlx5_core_dev *mdev,
+				 u32 pd, u64 length, u64 start_addr, int mode,
+				 struct mlx5_core_mkey *mkey)
+{
+	u32 inlen =3D MLX5_ST_SZ_BYTES(create_mkey_in);
+	u32 in[MLX5_ST_SZ_DW(create_mkey_in)] =3D {};
+	void *mkc;
+
+	mkc =3D MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+
+	MLX5_SET(mkc, mkc, access_mode_1_0, mode);
+	MLX5_SET(mkc, mkc, access_mode_4_2, (mode >> 2) & 0x7);
+	MLX5_SET(mkc, mkc, lw, 1);
+	MLX5_SET(mkc, mkc, lr, 1);
+	if (mode =3D=3D MLX5_MKC_ACCESS_MODE_SW_ICM) {
+		MLX5_SET(mkc, mkc, rw, 1);
+		MLX5_SET(mkc, mkc, rr, 1);
+	}
+
+	MLX5_SET64(mkc, mkc, len, length);
+	MLX5_SET(mkc, mkc, pd, pd);
+	MLX5_SET(mkc, mkc, qpn, 0xffffff);
+	MLX5_SET64(mkc, mkc, start_addr, start_addr);
+
+	return mlx5_core_create_mkey(mdev, mkey, in, inlen);
+}
+
+static struct mlx5dr_icm_mr *
+dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool,
+		      enum mlx5_sw_icm_type type,
+		      size_t align_base)
+{
+	struct mlx5_core_dev *mdev =3D pool->dmn->mdev;
+	struct mlx5dr_icm_mr *icm_mr;
+	size_t align_diff;
+	int err;
+
+	icm_mr =3D kvzalloc(sizeof(*icm_mr), GFP_KERNEL);
+	if (!icm_mr)
+		return NULL;
+
+	icm_mr->pool =3D pool;
+	INIT_LIST_HEAD(&icm_mr->mr_list);
+
+	icm_mr->dm.type =3D type;
+
+	/* 2^log_biggest_table * entry-size * double-for-alignment */
+	icm_mr->dm.length =3D mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_ch=
unk_sz,
+							       pool->icm_type) * 2;
+
+	err =3D mlx5_dm_sw_icm_alloc(mdev, icm_mr->dm.type, icm_mr->dm.length, 0,
+				   &icm_mr->dm.addr, &icm_mr->dm.obj_id);
+	if (err) {
+		mlx5dr_err(pool->dmn, "Failed to allocate SW ICM memory, err (%d)\n", er=
r);
+		goto free_icm_mr;
+	}
+
+	/* Register device memory */
+	err =3D dr_icm_create_dm_mkey(mdev, pool->dmn->pdn,
+				    icm_mr->dm.length,
+				    icm_mr->dm.addr,
+				    MLX5_MKC_ACCESS_MODE_SW_ICM,
+				    &icm_mr->mkey);
+	if (err) {
+		mlx5dr_err(pool->dmn, "Failed to create SW ICM MKEY, err (%d)\n", err);
+		goto free_dm;
+	}
+
+	icm_mr->icm_start_addr =3D icm_mr->dm.addr;
+
+	align_diff =3D icm_mr->icm_start_addr % align_base;
+	if (align_diff)
+		icm_mr->used_length =3D align_base - align_diff;
+
+	list_add_tail(&icm_mr->mr_list, &pool->icm_mr_list);
+
+	return icm_mr;
+
+free_dm:
+	mlx5_dm_sw_icm_dealloc(mdev, icm_mr->dm.type, icm_mr->dm.length, 0,
+			       icm_mr->dm.addr, icm_mr->dm.obj_id);
+free_icm_mr:
+	kvfree(icm_mr);
+	return NULL;
+}
+
+static void dr_icm_pool_mr_destroy(struct mlx5dr_icm_mr *icm_mr)
+{
+	struct mlx5_core_dev *mdev =3D icm_mr->pool->dmn->mdev;
+	struct mlx5dr_icm_dm *dm =3D &icm_mr->dm;
+
+	list_del(&icm_mr->mr_list);
+	mlx5_core_destroy_mkey(mdev, &icm_mr->mkey);
+	mlx5_dm_sw_icm_dealloc(mdev, dm->type, dm->length, 0,
+			       dm->addr, dm->obj_id);
+	kvfree(icm_mr);
+}
+
+static int dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk)
+{
+	struct mlx5dr_icm_bucket *bucket =3D chunk->bucket;
+
+	chunk->ste_arr =3D kvzalloc(bucket->num_of_entries *
+				  sizeof(chunk->ste_arr[0]), GFP_KERNEL);
+	if (!chunk->ste_arr)
+		return -ENOMEM;
+
+	chunk->hw_ste_arr =3D kvzalloc(bucket->num_of_entries *
+				     DR_STE_SIZE_REDUCED, GFP_KERNEL);
+	if (!chunk->hw_ste_arr)
+		goto out_free_ste_arr;
+
+	chunk->miss_list =3D kvmalloc(bucket->num_of_entries *
+				    sizeof(chunk->miss_list[0]), GFP_KERNEL);
+	if (!chunk->miss_list)
+		goto out_free_hw_ste_arr;
+
+	return 0;
+
+out_free_hw_ste_arr:
+	kvfree(chunk->hw_ste_arr);
+out_free_ste_arr:
+	kvfree(chunk->ste_arr);
+	return -ENOMEM;
+}
+
+static int dr_icm_chunks_create(struct mlx5dr_icm_bucket *bucket)
+{
+	size_t mr_free_size, mr_req_size, mr_row_size;
+	struct mlx5dr_icm_pool *pool =3D bucket->pool;
+	struct mlx5dr_icm_mr *icm_mr =3D NULL;
+	struct mlx5dr_icm_chunk *chunk;
+	enum mlx5_sw_icm_type dm_type;
+	size_t align_base;
+	int i, err =3D 0;
+
+	mr_req_size =3D bucket->num_of_entries * bucket->entry_size;
+	mr_row_size =3D mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz=
,
+							 pool->icm_type);
+
+	if (pool->icm_type =3D=3D DR_ICM_TYPE_STE) {
+		dm_type =3D MLX5_SW_ICM_TYPE_STEERING;
+		/* Align base is the biggest chunk size / row size */
+		align_base =3D mr_row_size;
+	} else {
+		dm_type =3D MLX5_SW_ICM_TYPE_HEADER_MODIFY;
+		/* Align base is 64B */
+		align_base =3D DR_ICM_MODIFY_HDR_ALIGN_BASE;
+	}
+
+	mutex_lock(&pool->mr_mutex);
+	if (!list_empty(&pool->icm_mr_list)) {
+		icm_mr =3D list_last_entry(&pool->icm_mr_list,
+					 struct mlx5dr_icm_mr, mr_list);
+
+		if (icm_mr)
+			mr_free_size =3D icm_mr->dm.length - icm_mr->used_length;
+	}
+
+	if (!icm_mr || mr_free_size < mr_row_size) {
+		icm_mr =3D dr_icm_pool_mr_create(pool, dm_type, align_base);
+		if (!icm_mr) {
+			err =3D -ENOMEM;
+			goto out_err;
+		}
+	}
+
+	/* Create memory aligned chunks */
+	for (i =3D 0; i < mr_row_size / mr_req_size; i++) {
+		chunk =3D kvzalloc(sizeof(*chunk), GFP_KERNEL);
+		if (!chunk) {
+			err =3D -ENOMEM;
+			goto out_err;
+		}
+
+		chunk->bucket =3D bucket;
+		chunk->rkey =3D icm_mr->mkey.key;
+		/* mr start addr is zero based */
+		chunk->mr_addr =3D icm_mr->used_length;
+		chunk->icm_addr =3D (uintptr_t)icm_mr->icm_start_addr + icm_mr->used_len=
gth;
+		icm_mr->used_length +=3D mr_req_size;
+		chunk->num_of_entries =3D bucket->num_of_entries;
+		chunk->byte_size =3D chunk->num_of_entries * bucket->entry_size;
+
+		if (pool->icm_type =3D=3D DR_ICM_TYPE_STE) {
+			err =3D dr_icm_chunk_ste_init(chunk);
+			if (err)
+				goto out_free_chunk;
+		}
+
+		INIT_LIST_HEAD(&chunk->chunk_list);
+		list_add(&chunk->chunk_list, &bucket->free_list);
+		bucket->free_list_count++;
+		bucket->total_chunks++;
+	}
+	mutex_unlock(&pool->mr_mutex);
+	return 0;
+
+out_free_chunk:
+	kvfree(chunk);
+out_err:
+	mutex_unlock(&pool->mr_mutex);
+	return err;
+}
+
+static void dr_icm_chunk_ste_cleanup(struct mlx5dr_icm_chunk *chunk)
+{
+	kvfree(chunk->miss_list);
+	kvfree(chunk->hw_ste_arr);
+	kvfree(chunk->ste_arr);
+}
+
+static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk)
+{
+	struct mlx5dr_icm_bucket *bucket =3D chunk->bucket;
+
+	list_del(&chunk->chunk_list);
+	bucket->total_chunks--;
+
+	if (bucket->pool->icm_type =3D=3D DR_ICM_TYPE_STE)
+		dr_icm_chunk_ste_cleanup(chunk);
+
+	kvfree(chunk);
+}
+
+static void dr_icm_bucket_init(struct mlx5dr_icm_pool *pool,
+			       struct mlx5dr_icm_bucket *bucket,
+			       enum mlx5dr_icm_chunk_size chunk_size)
+{
+	if (pool->icm_type =3D=3D DR_ICM_TYPE_STE)
+		bucket->entry_size =3D DR_STE_SIZE;
+	else
+		bucket->entry_size =3D DR_MODIFY_ACTION_SIZE;
+
+	bucket->num_of_entries =3D mlx5dr_icm_pool_chunk_size_to_entries(chunk_si=
ze);
+	bucket->pool =3D pool;
+	mutex_init(&bucket->mutex);
+	INIT_LIST_HEAD(&bucket->free_list);
+	INIT_LIST_HEAD(&bucket->used_list);
+	INIT_LIST_HEAD(&bucket->hot_list);
+	INIT_LIST_HEAD(&bucket->sync_list);
+}
+
+static void dr_icm_bucket_cleanup(struct mlx5dr_icm_bucket *bucket)
+{
+	struct mlx5dr_icm_chunk *chunk, *next;
+
+	mutex_destroy(&bucket->mutex);
+	list_splice_tail_init(&bucket->sync_list, &bucket->free_list);
+	list_splice_tail_init(&bucket->hot_list, &bucket->free_list);
+
+	list_for_each_entry_safe(chunk, next, &bucket->free_list, chunk_list)
+		dr_icm_chunk_destroy(chunk);
+
+	WARN_ON(bucket->total_chunks !=3D 0);
+
+	/* Cleanup of unreturned chunks */
+	list_for_each_entry_safe(chunk, next, &bucket->used_list, chunk_list)
+		dr_icm_chunk_destroy(chunk);
+}
+
+static u64 dr_icm_hot_mem_size(struct mlx5dr_icm_pool *pool)
+{
+	u64 hot_size =3D 0;
+	int chunk_order;
+
+	for (chunk_order =3D 0; chunk_order < pool->num_of_buckets; chunk_order++=
)
+		hot_size +=3D pool->buckets[chunk_order].hot_list_count *
+			    mlx5dr_icm_pool_chunk_size_to_byte(chunk_order, pool->icm_type);
+
+	return hot_size;
+}
+
+static bool dr_icm_reuse_hot_entries(struct mlx5dr_icm_pool *pool,
+				     struct mlx5dr_icm_bucket *bucket)
+{
+	u64 bytes_for_sync;
+
+	bytes_for_sync =3D dr_icm_hot_mem_size(pool);
+	if (bytes_for_sync < DR_ICM_SYNC_THRESHOLD || !bucket->hot_list_count)
+		return false;
+
+	return true;
+}
+
+static void dr_icm_chill_bucket_start(struct mlx5dr_icm_bucket *bucket)
+{
+	list_splice_tail_init(&bucket->hot_list, &bucket->sync_list);
+	bucket->sync_list_count +=3D bucket->hot_list_count;
+	bucket->hot_list_count =3D 0;
+}
+
+static void dr_icm_chill_bucket_end(struct mlx5dr_icm_bucket *bucket)
+{
+	list_splice_tail_init(&bucket->sync_list, &bucket->free_list);
+	bucket->free_list_count +=3D bucket->sync_list_count;
+	bucket->sync_list_count =3D 0;
+}
+
+static void dr_icm_chill_bucket_abort(struct mlx5dr_icm_bucket *bucket)
+{
+	list_splice_tail_init(&bucket->sync_list, &bucket->hot_list);
+	bucket->hot_list_count +=3D bucket->sync_list_count;
+	bucket->sync_list_count =3D 0;
+}
+
+static void dr_icm_chill_buckets_start(struct mlx5dr_icm_pool *pool,
+				       struct mlx5dr_icm_bucket *cb,
+				       bool buckets[DR_CHUNK_SIZE_MAX])
+{
+	struct mlx5dr_icm_bucket *bucket;
+	int i;
+
+	for (i =3D 0; i < pool->num_of_buckets; i++) {
+		bucket =3D &pool->buckets[i];
+		if (bucket =3D=3D cb) {
+			dr_icm_chill_bucket_start(bucket);
+			continue;
+		}
+
+		/* Freeing the mutex is done at the end of that process, after
+		 * sync_ste was executed at dr_icm_chill_buckets_end func.
+		 */
+		if (mutex_trylock(&bucket->mutex)) {
+			dr_icm_chill_bucket_start(bucket);
+			buckets[i] =3D true;
+		}
+	}
+}
+
+static void dr_icm_chill_buckets_end(struct mlx5dr_icm_pool *pool,
+				     struct mlx5dr_icm_bucket *cb,
+				     bool buckets[DR_CHUNK_SIZE_MAX])
+{
+	struct mlx5dr_icm_bucket *bucket;
+	int i;
+
+	for (i =3D 0; i < pool->num_of_buckets; i++) {
+		bucket =3D &pool->buckets[i];
+		if (bucket =3D=3D cb) {
+			dr_icm_chill_bucket_end(bucket);
+			continue;
+		}
+
+		if (!buckets[i])
+			continue;
+
+		dr_icm_chill_bucket_end(bucket);
+		mutex_unlock(&bucket->mutex);
+	}
+}
+
+static void dr_icm_chill_buckets_abort(struct mlx5dr_icm_pool *pool,
+				       struct mlx5dr_icm_bucket *cb,
+				       bool buckets[DR_CHUNK_SIZE_MAX])
+{
+	struct mlx5dr_icm_bucket *bucket;
+	int i;
+
+	for (i =3D 0; i < pool->num_of_buckets; i++) {
+		bucket =3D &pool->buckets[i];
+		if (bucket =3D=3D cb) {
+			dr_icm_chill_bucket_abort(bucket);
+			continue;
+		}
+
+		if (!buckets[i])
+			continue;
+
+		dr_icm_chill_bucket_abort(bucket);
+		mutex_unlock(&bucket->mutex);
+	}
+}
+
+/* Allocate an ICM chunk, each chunk holds a piece of ICM memory and
+ * also memory used for HW STE management for optimizations.
+ */
+struct mlx5dr_icm_chunk *
+mlx5dr_icm_alloc_chunk(struct mlx5dr_icm_pool *pool,
+		       enum mlx5dr_icm_chunk_size chunk_size)
+{
+	struct mlx5dr_icm_chunk *chunk =3D NULL; /* Fix compilation warning */
+	bool buckets[DR_CHUNK_SIZE_MAX] =3D {};
+	struct mlx5dr_icm_bucket *bucket;
+	int err;
+
+	if (chunk_size > pool->max_log_chunk_sz)
+		return NULL;
+
+	bucket =3D &pool->buckets[chunk_size];
+
+	mutex_lock(&bucket->mutex);
+
+	/* Take chunk from pool if available, otherwise allocate new chunks */
+	if (list_empty(&bucket->free_list)) {
+		if (dr_icm_reuse_hot_entries(pool, bucket)) {
+			dr_icm_chill_buckets_start(pool, bucket, buckets);
+			err =3D mlx5dr_cmd_sync_steering(pool->dmn->mdev);
+			if (err) {
+				dr_icm_chill_buckets_abort(pool, bucket, buckets);
+				mlx5dr_dbg(pool->dmn, "Sync_steering failed\n");
+				chunk =3D NULL;
+				goto out;
+			}
+			dr_icm_chill_buckets_end(pool, bucket, buckets);
+		} else {
+			dr_icm_chunks_create(bucket);
+		}
+	}
+
+	if (!list_empty(&bucket->free_list)) {
+		chunk =3D list_last_entry(&bucket->free_list,
+					struct mlx5dr_icm_chunk,
+					chunk_list);
+		if (chunk) {
+			list_del_init(&chunk->chunk_list);
+			list_add_tail(&chunk->chunk_list, &bucket->used_list);
+			bucket->free_list_count--;
+			bucket->used_list_count++;
+		}
+	}
+out:
+	mutex_unlock(&bucket->mutex);
+	return chunk;
+}
+
+void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
+{
+	struct mlx5dr_icm_bucket *bucket =3D chunk->bucket;
+
+	if (bucket->pool->icm_type =3D=3D DR_ICM_TYPE_STE) {
+		memset(chunk->ste_arr, 0,
+		       bucket->num_of_entries * sizeof(chunk->ste_arr[0]));
+		memset(chunk->hw_ste_arr, 0,
+		       bucket->num_of_entries * DR_STE_SIZE_REDUCED);
+	}
+
+	mutex_lock(&bucket->mutex);
+	list_del_init(&chunk->chunk_list);
+	list_add_tail(&chunk->chunk_list, &bucket->hot_list);
+	bucket->hot_list_count++;
+	bucket->used_list_count--;
+	mutex_unlock(&bucket->mutex);
+}
+
+struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
+					       enum mlx5dr_icm_type icm_type)
+{
+	enum mlx5dr_icm_chunk_size max_log_chunk_sz;
+	struct mlx5dr_icm_pool *pool;
+	int i;
+
+	if (icm_type =3D=3D DR_ICM_TYPE_STE)
+		max_log_chunk_sz =3D dmn->info.max_log_sw_icm_sz;
+	else
+		max_log_chunk_sz =3D dmn->info.max_log_action_icm_sz;
+
+	pool =3D kvzalloc(sizeof(*pool), GFP_KERNEL);
+	if (!pool)
+		return NULL;
+
+	pool->buckets =3D kcalloc(max_log_chunk_sz + 1,
+				sizeof(pool->buckets[0]),
+				GFP_KERNEL);
+	if (!pool->buckets)
+		goto free_pool;
+
+	pool->dmn =3D dmn;
+	pool->icm_type =3D icm_type;
+	pool->max_log_chunk_sz =3D max_log_chunk_sz;
+	pool->num_of_buckets =3D max_log_chunk_sz + 1;
+	INIT_LIST_HEAD(&pool->icm_mr_list);
+
+	for (i =3D 0; i < pool->num_of_buckets; i++)
+		dr_icm_bucket_init(pool, &pool->buckets[i], i);
+
+	mutex_init(&pool->mr_mutex);
+
+	return pool;
+
+free_pool:
+	kvfree(pool);
+	return NULL;
+}
+
+void mlx5dr_icm_pool_destroy(struct mlx5dr_icm_pool *pool)
+{
+	struct mlx5dr_icm_mr *icm_mr, *next;
+	int i;
+
+	mutex_destroy(&pool->mr_mutex);
+
+	list_for_each_entry_safe(icm_mr, next, &pool->icm_mr_list, mr_list)
+		dr_icm_pool_mr_destroy(icm_mr);
+
+	for (i =3D 0; i < pool->num_of_buckets; i++)
+		dr_icm_bucket_cleanup(&pool->buckets[i]);
+
+	kfree(pool->buckets);
+	kvfree(pool);
+}
--=20
2.21.0

