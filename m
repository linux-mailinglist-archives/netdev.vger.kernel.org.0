Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1004C2A87CF
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 21:13:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgKEUND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 15:13:03 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:18618 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732013AbgKEUNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 15:13:02 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa45cd00003>; Thu, 05 Nov 2020 12:13:04 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 5 Nov
 2020 20:13:00 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Yevgeny Kliteynik" <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Mark Bloch <mbloch@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next v2 05/12] net/mlx5: DR, Handle ICM memory via buddy allocation instead of buckets
Date:   Thu, 5 Nov 2020 12:12:35 -0800
Message-ID: <20201105201242.21716-6-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201105201242.21716-1-saeedm@nvidia.com>
References: <20201105201242.21716-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604607184; bh=1nXfr7loJ08qypPLeOWpyi/dKZKTBVRCw4/0f04Sru8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=k9I2mKw0Rzm+jjRbL0q6vs8QIeugmoGSzZFrYmgmpQn6+cTHxaVVrSHt4kaVq5525
         DXzVr/wlNxbl18p0a3iRjGqHIlNQF1IoFnD8W7gxRDm7MS098K8Tul9Esc4XEN59kH
         TRMQArUS8KqTPsEJ1RERB04pHcmtRgTV8XCzla800goxRoDD751EJgYbU5XYCpcF9h
         nSn2ITi4n2gwDdFA6iGDocesfO6nzAwTel1xD3tmYWVP+fzoCcRFxADOi0vxYx7d8P
         AN0AAwW7HCPw86xlB/FFrFB5Cfe/6hucyaFGxMwKflS/Bfov9nMh4F7Uea/goXzhku
         dbt1g2SjICKkA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Till now in order to manage the ICM memory we used bucket
mechanism, which kept a bucket per specified size (sizes were
between 1 block to 2^21 blocks).

Now changing that with buddy-system mechanism, which gives us much
more flexible way to manage the ICM memory.
Its biggest advantage over the bucket is by using the same ICM memory
area for all the sizes of blocks, which reduces the memory consumption.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_icm_pool.c | 501 +++++++-----------
 .../mellanox/mlx5/core/steering/dr_types.h    |  24 +-
 2 files changed, 211 insertions(+), 314 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c=
 b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
index cc33515b9aba..2c5886b469f7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c
@@ -6,48 +6,13 @@
 #define DR_ICM_MODIFY_HDR_ALIGN_BASE 64
 #define DR_ICM_SYNC_THRESHOLD (64 * 1024 * 1024)
=20
-struct mlx5dr_icm_pool;
-
-struct mlx5dr_icm_bucket {
-	struct mlx5dr_icm_pool *pool;
-
-	/* Chunks that aren't visible to HW not directly and not in cache */
-	struct list_head free_list;
-	unsigned int free_list_count;
-
-	/* Used chunks, HW may be accessing this memory */
-	struct list_head used_list;
-	unsigned int used_list_count;
-
-	/* HW may be accessing this memory but at some future,
-	 * undetermined time, it might cease to do so. Before deciding to call
-	 * sync_ste, this list is moved to sync_list
-	 */
-	struct list_head hot_list;
-	unsigned int hot_list_count;
-
-	/* Pending sync list, entries from the hot list are moved to this list.
-	 * sync_ste is executed and then sync_list is concatenated to the free li=
st
-	 */
-	struct list_head sync_list;
-	unsigned int sync_list_count;
-
-	u32 total_chunks;
-	u32 num_of_entries;
-	u32 entry_size;
-	/* protect the ICM bucket */
-	struct mutex mutex;
-};
-
 struct mlx5dr_icm_pool {
-	struct mlx5dr_icm_bucket *buckets;
 	enum mlx5dr_icm_type icm_type;
 	enum mlx5dr_icm_chunk_size max_log_chunk_sz;
-	enum mlx5dr_icm_chunk_size num_of_buckets;
-	struct list_head icm_mr_list;
-	/* protect the ICM MR list */
-	struct mutex mr_mutex;
 	struct mlx5dr_domain *dmn;
+	/* memory management */
+	struct mutex mutex; /* protect the ICM pool and ICM buddy */
+	struct list_head buddy_mem_list;
 };
=20
 struct mlx5dr_icm_dm {
@@ -58,13 +23,11 @@ struct mlx5dr_icm_dm {
 };
=20
 struct mlx5dr_icm_mr {
-	struct mlx5dr_icm_pool *pool;
 	struct mlx5_core_mkey mkey;
 	struct mlx5dr_icm_dm dm;
-	size_t used_length;
+	struct mlx5dr_domain *dmn;
 	size_t length;
 	u64 icm_start_addr;
-	struct list_head mr_list;
 };
=20
 static int dr_icm_create_dm_mkey(struct mlx5_core_dev *mdev,
@@ -107,8 +70,7 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 	if (!icm_mr)
 		return NULL;
=20
-	icm_mr->pool =3D pool;
-	INIT_LIST_HEAD(&icm_mr->mr_list);
+	icm_mr->dmn =3D pool->dmn;
=20
 	icm_mr->dm.length =3D mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_ch=
unk_sz,
 							       pool->icm_type);
@@ -150,8 +112,6 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
 		goto free_mkey;
 	}
=20
-	list_add_tail(&icm_mr->mr_list, &pool->icm_mr_list);
-
 	return icm_mr;
=20
 free_mkey:
@@ -166,10 +126,9 @@ dr_icm_pool_mr_create(struct mlx5dr_icm_pool *pool)
=20
 static void dr_icm_pool_mr_destroy(struct mlx5dr_icm_mr *icm_mr)
 {
-	struct mlx5_core_dev *mdev =3D icm_mr->pool->dmn->mdev;
+	struct mlx5_core_dev *mdev =3D icm_mr->dmn->mdev;
 	struct mlx5dr_icm_dm *dm =3D &icm_mr->dm;
=20
-	list_del(&icm_mr->mr_list);
 	mlx5_core_destroy_mkey(mdev, &icm_mr->mkey);
 	mlx5_dm_sw_icm_dealloc(mdev, dm->type, dm->length, 0,
 			       dm->addr, dm->obj_id);
@@ -178,19 +137,17 @@ static void dr_icm_pool_mr_destroy(struct mlx5dr_icm_=
mr *icm_mr)
=20
 static int dr_icm_chunk_ste_init(struct mlx5dr_icm_chunk *chunk)
 {
-	struct mlx5dr_icm_bucket *bucket =3D chunk->bucket;
-
-	chunk->ste_arr =3D kvzalloc(bucket->num_of_entries *
+	chunk->ste_arr =3D kvzalloc(chunk->num_of_entries *
 				  sizeof(chunk->ste_arr[0]), GFP_KERNEL);
 	if (!chunk->ste_arr)
 		return -ENOMEM;
=20
-	chunk->hw_ste_arr =3D kvzalloc(bucket->num_of_entries *
+	chunk->hw_ste_arr =3D kvzalloc(chunk->num_of_entries *
 				     DR_STE_SIZE_REDUCED, GFP_KERNEL);
 	if (!chunk->hw_ste_arr)
 		goto out_free_ste_arr;
=20
-	chunk->miss_list =3D kvmalloc(bucket->num_of_entries *
+	chunk->miss_list =3D kvmalloc(chunk->num_of_entries *
 				    sizeof(chunk->miss_list[0]), GFP_KERNEL);
 	if (!chunk->miss_list)
 		goto out_free_hw_ste_arr;
@@ -204,72 +161,6 @@ static int dr_icm_chunk_ste_init(struct mlx5dr_icm_chu=
nk *chunk)
 	return -ENOMEM;
 }
=20
-static int dr_icm_chunks_create(struct mlx5dr_icm_bucket *bucket)
-{
-	size_t mr_free_size, mr_req_size, mr_row_size;
-	struct mlx5dr_icm_pool *pool =3D bucket->pool;
-	struct mlx5dr_icm_mr *icm_mr =3D NULL;
-	struct mlx5dr_icm_chunk *chunk;
-	int i, err =3D 0;
-
-	mr_req_size =3D bucket->num_of_entries * bucket->entry_size;
-	mr_row_size =3D mlx5dr_icm_pool_chunk_size_to_byte(pool->max_log_chunk_sz=
,
-							 pool->icm_type);
-	mutex_lock(&pool->mr_mutex);
-	if (!list_empty(&pool->icm_mr_list)) {
-		icm_mr =3D list_last_entry(&pool->icm_mr_list,
-					 struct mlx5dr_icm_mr, mr_list);
-
-		if (icm_mr)
-			mr_free_size =3D icm_mr->dm.length - icm_mr->used_length;
-	}
-
-	if (!icm_mr || mr_free_size < mr_row_size) {
-		icm_mr =3D dr_icm_pool_mr_create(pool);
-		if (!icm_mr) {
-			err =3D -ENOMEM;
-			goto out_err;
-		}
-	}
-
-	/* Create memory aligned chunks */
-	for (i =3D 0; i < mr_row_size / mr_req_size; i++) {
-		chunk =3D kvzalloc(sizeof(*chunk), GFP_KERNEL);
-		if (!chunk) {
-			err =3D -ENOMEM;
-			goto out_err;
-		}
-
-		chunk->bucket =3D bucket;
-		chunk->rkey =3D icm_mr->mkey.key;
-		/* mr start addr is zero based */
-		chunk->mr_addr =3D icm_mr->used_length;
-		chunk->icm_addr =3D (uintptr_t)icm_mr->icm_start_addr + icm_mr->used_len=
gth;
-		icm_mr->used_length +=3D mr_req_size;
-		chunk->num_of_entries =3D bucket->num_of_entries;
-		chunk->byte_size =3D chunk->num_of_entries * bucket->entry_size;
-
-		if (pool->icm_type =3D=3D DR_ICM_TYPE_STE) {
-			err =3D dr_icm_chunk_ste_init(chunk);
-			if (err)
-				goto out_free_chunk;
-		}
-
-		INIT_LIST_HEAD(&chunk->chunk_list);
-		list_add(&chunk->chunk_list, &bucket->free_list);
-		bucket->free_list_count++;
-		bucket->total_chunks++;
-	}
-	mutex_unlock(&pool->mr_mutex);
-	return 0;
-
-out_free_chunk:
-	kvfree(chunk);
-out_err:
-	mutex_unlock(&pool->mr_mutex);
-	return err;
-}
-
 static void dr_icm_chunk_ste_cleanup(struct mlx5dr_icm_chunk *chunk)
 {
 	kvfree(chunk->miss_list);
@@ -277,166 +168,208 @@ static void dr_icm_chunk_ste_cleanup(struct mlx5dr_=
icm_chunk *chunk)
 	kvfree(chunk->ste_arr);
 }
=20
+static enum mlx5dr_icm_type
+get_chunk_icm_type(struct mlx5dr_icm_chunk *chunk)
+{
+	return chunk->buddy_mem->pool->icm_type;
+}
+
 static void dr_icm_chunk_destroy(struct mlx5dr_icm_chunk *chunk)
 {
-	struct mlx5dr_icm_bucket *bucket =3D chunk->bucket;
+	enum mlx5dr_icm_type icm_type =3D get_chunk_icm_type(chunk);
=20
 	list_del(&chunk->chunk_list);
-	bucket->total_chunks--;
=20
-	if (bucket->pool->icm_type =3D=3D DR_ICM_TYPE_STE)
+	if (icm_type =3D=3D DR_ICM_TYPE_STE)
 		dr_icm_chunk_ste_cleanup(chunk);
=20
 	kvfree(chunk);
 }
=20
-static void dr_icm_bucket_init(struct mlx5dr_icm_pool *pool,
-			       struct mlx5dr_icm_bucket *bucket,
-			       enum mlx5dr_icm_chunk_size chunk_size)
+static int dr_icm_buddy_create(struct mlx5dr_icm_pool *pool)
 {
-	if (pool->icm_type =3D=3D DR_ICM_TYPE_STE)
-		bucket->entry_size =3D DR_STE_SIZE;
-	else
-		bucket->entry_size =3D DR_MODIFY_ACTION_SIZE;
-
-	bucket->num_of_entries =3D mlx5dr_icm_pool_chunk_size_to_entries(chunk_si=
ze);
-	bucket->pool =3D pool;
-	mutex_init(&bucket->mutex);
-	INIT_LIST_HEAD(&bucket->free_list);
-	INIT_LIST_HEAD(&bucket->used_list);
-	INIT_LIST_HEAD(&bucket->hot_list);
-	INIT_LIST_HEAD(&bucket->sync_list);
+	struct mlx5dr_icm_buddy_mem *buddy;
+	struct mlx5dr_icm_mr *icm_mr;
+
+	icm_mr =3D dr_icm_pool_mr_create(pool);
+	if (!icm_mr)
+		return -ENOMEM;
+
+	buddy =3D kvzalloc(sizeof(*buddy), GFP_KERNEL);
+	if (!buddy)
+		goto free_mr;
+
+	if (mlx5dr_buddy_init(buddy, pool->max_log_chunk_sz))
+		goto err_free_buddy;
+
+	buddy->icm_mr =3D icm_mr;
+	buddy->pool =3D pool;
+
+	/* add it to the -start- of the list in order to search in it first */
+	list_add(&buddy->list_node, &pool->buddy_mem_list);
+
+	return 0;
+
+err_free_buddy:
+	kvfree(buddy);
+free_mr:
+	dr_icm_pool_mr_destroy(icm_mr);
+	return -ENOMEM;
 }
=20
-static void dr_icm_bucket_cleanup(struct mlx5dr_icm_bucket *bucket)
+static void dr_icm_buddy_destroy(struct mlx5dr_icm_buddy_mem *buddy)
 {
 	struct mlx5dr_icm_chunk *chunk, *next;
=20
-	mutex_destroy(&bucket->mutex);
-	list_splice_tail_init(&bucket->sync_list, &bucket->free_list);
-	list_splice_tail_init(&bucket->hot_list, &bucket->free_list);
+	list_for_each_entry_safe(chunk, next, &buddy->hot_list, chunk_list)
+		dr_icm_chunk_destroy(chunk);
=20
-	list_for_each_entry_safe(chunk, next, &bucket->free_list, chunk_list)
+	list_for_each_entry_safe(chunk, next, &buddy->used_list, chunk_list)
 		dr_icm_chunk_destroy(chunk);
=20
-	WARN_ON(bucket->total_chunks !=3D 0);
+	dr_icm_pool_mr_destroy(buddy->icm_mr);
=20
-	/* Cleanup of unreturned chunks */
-	list_for_each_entry_safe(chunk, next, &bucket->used_list, chunk_list)
-		dr_icm_chunk_destroy(chunk);
+	mlx5dr_buddy_cleanup(buddy);
+
+	kvfree(buddy);
 }
=20
-static u64 dr_icm_hot_mem_size(struct mlx5dr_icm_pool *pool)
+static struct mlx5dr_icm_chunk *
+dr_icm_chunk_create(struct mlx5dr_icm_pool *pool,
+		    enum mlx5dr_icm_chunk_size chunk_size,
+		    struct mlx5dr_icm_buddy_mem *buddy_mem_pool,
+		    unsigned int seg)
 {
-	u64 hot_size =3D 0;
-	int chunk_order;
+	struct mlx5dr_icm_chunk *chunk;
+	int offset;
=20
-	for (chunk_order =3D 0; chunk_order < pool->num_of_buckets; chunk_order++=
)
-		hot_size +=3D pool->buckets[chunk_order].hot_list_count *
-			    mlx5dr_icm_pool_chunk_size_to_byte(chunk_order, pool->icm_type);
+	chunk =3D kvzalloc(sizeof(*chunk), GFP_KERNEL);
+	if (!chunk)
+		return NULL;
=20
-	return hot_size;
-}
+	offset =3D mlx5dr_icm_pool_dm_type_to_entry_size(pool->icm_type) * seg;
+
+	chunk->rkey =3D buddy_mem_pool->icm_mr->mkey.key;
+	chunk->mr_addr =3D offset;
+	chunk->icm_addr =3D
+		(uintptr_t)buddy_mem_pool->icm_mr->icm_start_addr + offset;
+	chunk->num_of_entries =3D
+		mlx5dr_icm_pool_chunk_size_to_entries(chunk_size);
+	chunk->byte_size =3D
+		mlx5dr_icm_pool_chunk_size_to_byte(chunk_size, pool->icm_type);
+	chunk->seg =3D seg;
+
+	if (pool->icm_type =3D=3D DR_ICM_TYPE_STE && dr_icm_chunk_ste_init(chunk)=
) {
+		mlx5dr_err(pool->dmn,
+			   "Failed to init ste arrays (order: %d)\n",
+			   chunk_size);
+		goto out_free_chunk;
+	}
=20
-static bool dr_icm_reuse_hot_entries(struct mlx5dr_icm_pool *pool,
-				     struct mlx5dr_icm_bucket *bucket)
-{
-	u64 bytes_for_sync;
+	chunk->buddy_mem =3D buddy_mem_pool;
+	INIT_LIST_HEAD(&chunk->chunk_list);
=20
-	bytes_for_sync =3D dr_icm_hot_mem_size(pool);
-	if (bytes_for_sync < DR_ICM_SYNC_THRESHOLD || !bucket->hot_list_count)
-		return false;
+	/* chunk now is part of the used_list */
+	list_add_tail(&chunk->chunk_list, &buddy_mem_pool->used_list);
=20
-	return true;
-}
+	return chunk;
=20
-static void dr_icm_chill_bucket_start(struct mlx5dr_icm_bucket *bucket)
-{
-	list_splice_tail_init(&bucket->hot_list, &bucket->sync_list);
-	bucket->sync_list_count +=3D bucket->hot_list_count;
-	bucket->hot_list_count =3D 0;
+out_free_chunk:
+	kvfree(chunk);
+	return NULL;
 }
=20
-static void dr_icm_chill_bucket_end(struct mlx5dr_icm_bucket *bucket)
+static bool dr_icm_pool_is_sync_required(struct mlx5dr_icm_pool *pool)
 {
-	list_splice_tail_init(&bucket->sync_list, &bucket->free_list);
-	bucket->free_list_count +=3D bucket->sync_list_count;
-	bucket->sync_list_count =3D 0;
-}
+	u64 allow_hot_size, all_hot_mem =3D 0;
+	struct mlx5dr_icm_buddy_mem *buddy;
+
+	list_for_each_entry(buddy, &pool->buddy_mem_list, list_node) {
+		allow_hot_size =3D
+			mlx5dr_icm_pool_chunk_size_to_byte((buddy->max_order - 2),
+							   pool->icm_type);
+		all_hot_mem +=3D buddy->hot_memory_size;
+
+		if (buddy->hot_memory_size > allow_hot_size ||
+		    all_hot_mem > DR_ICM_SYNC_THRESHOLD)
+			return true;
+	}
=20
-static void dr_icm_chill_bucket_abort(struct mlx5dr_icm_bucket *bucket)
-{
-	list_splice_tail_init(&bucket->sync_list, &bucket->hot_list);
-	bucket->hot_list_count +=3D bucket->sync_list_count;
-	bucket->sync_list_count =3D 0;
+	return false;
 }
=20
-static void dr_icm_chill_buckets_start(struct mlx5dr_icm_pool *pool,
-				       struct mlx5dr_icm_bucket *cb,
-				       bool buckets[DR_CHUNK_SIZE_MAX])
+static int dr_icm_pool_sync_all_buddy_pools(struct mlx5dr_icm_pool *pool)
 {
-	struct mlx5dr_icm_bucket *bucket;
-	int i;
-
-	for (i =3D 0; i < pool->num_of_buckets; i++) {
-		bucket =3D &pool->buckets[i];
-		if (bucket =3D=3D cb) {
-			dr_icm_chill_bucket_start(bucket);
-			continue;
-		}
+	struct mlx5dr_icm_buddy_mem *buddy, *tmp_buddy;
+	int err;
=20
-		/* Freeing the mutex is done at the end of that process, after
-		 * sync_ste was executed at dr_icm_chill_buckets_end func.
-		 */
-		if (mutex_trylock(&bucket->mutex)) {
-			dr_icm_chill_bucket_start(bucket);
-			buckets[i] =3D true;
-		}
+	err =3D mlx5dr_cmd_sync_steering(pool->dmn->mdev);
+	if (err) {
+		mlx5dr_err(pool->dmn, "Failed to sync to HW (err: %d)\n", err);
+		return err;
 	}
-}
-
-static void dr_icm_chill_buckets_end(struct mlx5dr_icm_pool *pool,
-				     struct mlx5dr_icm_bucket *cb,
-				     bool buckets[DR_CHUNK_SIZE_MAX])
-{
-	struct mlx5dr_icm_bucket *bucket;
-	int i;
-
-	for (i =3D 0; i < pool->num_of_buckets; i++) {
-		bucket =3D &pool->buckets[i];
-		if (bucket =3D=3D cb) {
-			dr_icm_chill_bucket_end(bucket);
-			continue;
-		}
=20
-		if (!buckets[i])
-			continue;
+	list_for_each_entry_safe(buddy, tmp_buddy, &pool->buddy_mem_list, list_no=
de) {
+		struct mlx5dr_icm_chunk *chunk, *tmp_chunk;
=20
-		dr_icm_chill_bucket_end(bucket);
-		mutex_unlock(&bucket->mutex);
+		list_for_each_entry_safe(chunk, tmp_chunk, &buddy->hot_list, chunk_list)=
 {
+			mlx5dr_buddy_free_mem(buddy, chunk->seg,
+					      ilog2(chunk->num_of_entries));
+			buddy->hot_memory_size -=3D chunk->byte_size;
+			dr_icm_chunk_destroy(chunk);
+		}
 	}
+
+	return 0;
 }
=20
-static void dr_icm_chill_buckets_abort(struct mlx5dr_icm_pool *pool,
-				       struct mlx5dr_icm_bucket *cb,
-				       bool buckets[DR_CHUNK_SIZE_MAX])
+static int dr_icm_handle_buddies_get_mem(struct mlx5dr_icm_pool *pool,
+					 enum mlx5dr_icm_chunk_size chunk_size,
+					 struct mlx5dr_icm_buddy_mem **buddy,
+					 unsigned int *seg)
 {
-	struct mlx5dr_icm_bucket *bucket;
-	int i;
-
-	for (i =3D 0; i < pool->num_of_buckets; i++) {
-		bucket =3D &pool->buckets[i];
-		if (bucket =3D=3D cb) {
-			dr_icm_chill_bucket_abort(bucket);
-			continue;
-		}
+	struct mlx5dr_icm_buddy_mem *buddy_mem_pool;
+	bool new_mem =3D false;
+	int err;
=20
-		if (!buckets[i])
-			continue;
+	/* Check if we have chunks that are waiting for sync-ste */
+	if (dr_icm_pool_is_sync_required(pool))
+		dr_icm_pool_sync_all_buddy_pools(pool);
+
+alloc_buddy_mem:
+	/* find the next free place from the buddy list */
+	list_for_each_entry(buddy_mem_pool, &pool->buddy_mem_list, list_node) {
+		err =3D mlx5dr_buddy_alloc_mem(buddy_mem_pool,
+					     chunk_size, seg);
+		if (!err)
+			goto found;
+
+		if (WARN_ON(new_mem)) {
+			/* We have new memory pool, first in the list */
+			mlx5dr_err(pool->dmn,
+				   "No memory for order: %d\n",
+				   chunk_size);
+			goto out;
+		}
+	}
=20
-		dr_icm_chill_bucket_abort(bucket);
-		mutex_unlock(&bucket->mutex);
+	/* no more available allocators in that pool, create new */
+	err =3D dr_icm_buddy_create(pool);
+	if (err) {
+		mlx5dr_err(pool->dmn,
+			   "Failed creating buddy for order %d\n",
+			   chunk_size);
+		goto out;
 	}
+
+	/* mark we have new memory, first in list */
+	new_mem =3D true;
+	goto alloc_buddy_mem;
+
+found:
+	*buddy =3D buddy_mem_pool;
+out:
+	return err;
 }
=20
 /* Allocate an ICM chunk, each chunk holds a piece of ICM memory and
@@ -446,68 +379,42 @@ struct mlx5dr_icm_chunk *
 mlx5dr_icm_alloc_chunk(struct mlx5dr_icm_pool *pool,
 		       enum mlx5dr_icm_chunk_size chunk_size)
 {
-	struct mlx5dr_icm_chunk *chunk =3D NULL; /* Fix compilation warning */
-	bool buckets[DR_CHUNK_SIZE_MAX] =3D {};
-	struct mlx5dr_icm_bucket *bucket;
-	int err;
+	struct mlx5dr_icm_chunk *chunk =3D NULL;
+	struct mlx5dr_icm_buddy_mem *buddy;
+	unsigned int seg;
+	int ret;
=20
 	if (chunk_size > pool->max_log_chunk_sz)
 		return NULL;
=20
-	bucket =3D &pool->buckets[chunk_size];
-
-	mutex_lock(&bucket->mutex);
-
-	/* Take chunk from pool if available, otherwise allocate new chunks */
-	if (list_empty(&bucket->free_list)) {
-		if (dr_icm_reuse_hot_entries(pool, bucket)) {
-			dr_icm_chill_buckets_start(pool, bucket, buckets);
-			err =3D mlx5dr_cmd_sync_steering(pool->dmn->mdev);
-			if (err) {
-				dr_icm_chill_buckets_abort(pool, bucket, buckets);
-				mlx5dr_err(pool->dmn, "Sync_steering failed\n");
-				chunk =3D NULL;
-				goto out;
-			}
-			dr_icm_chill_buckets_end(pool, bucket, buckets);
-		} else {
-			dr_icm_chunks_create(bucket);
-		}
-	}
+	mutex_lock(&pool->mutex);
+	/* find mem, get back the relevant buddy pool and seg in that mem */
+	ret =3D dr_icm_handle_buddies_get_mem(pool, chunk_size, &buddy, &seg);
+	if (ret)
+		goto out;
=20
-	if (!list_empty(&bucket->free_list)) {
-		chunk =3D list_last_entry(&bucket->free_list,
-					struct mlx5dr_icm_chunk,
-					chunk_list);
-		if (chunk) {
-			list_del_init(&chunk->chunk_list);
-			list_add_tail(&chunk->chunk_list, &bucket->used_list);
-			bucket->free_list_count--;
-			bucket->used_list_count++;
-		}
-	}
+	chunk =3D dr_icm_chunk_create(pool, chunk_size, buddy, seg);
+	if (!chunk)
+		goto out_err;
+
+	goto out;
+
+out_err:
+	mlx5dr_buddy_free_mem(buddy, seg, chunk_size);
 out:
-	mutex_unlock(&bucket->mutex);
+	mutex_unlock(&pool->mutex);
 	return chunk;
 }
=20
 void mlx5dr_icm_free_chunk(struct mlx5dr_icm_chunk *chunk)
 {
-	struct mlx5dr_icm_bucket *bucket =3D chunk->bucket;
-
-	if (bucket->pool->icm_type =3D=3D DR_ICM_TYPE_STE) {
-		memset(chunk->ste_arr, 0,
-		       bucket->num_of_entries * sizeof(chunk->ste_arr[0]));
-		memset(chunk->hw_ste_arr, 0,
-		       bucket->num_of_entries * DR_STE_SIZE_REDUCED);
-	}
+	struct mlx5dr_icm_buddy_mem *buddy =3D chunk->buddy_mem;
=20
-	mutex_lock(&bucket->mutex);
-	list_del_init(&chunk->chunk_list);
-	list_add_tail(&chunk->chunk_list, &bucket->hot_list);
-	bucket->hot_list_count++;
-	bucket->used_list_count--;
-	mutex_unlock(&bucket->mutex);
+	/* move the memory to the waiting list AKA "hot" */
+	mutex_lock(&buddy->pool->mutex);
+	list_move_tail(&chunk->chunk_list, &buddy->hot_list);
+	buddy->hot_memory_size +=3D chunk->byte_size;
+	mutex_unlock(&buddy->pool->mutex);
 }
=20
 struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct mlx5dr_domain *dmn,
@@ -515,7 +422,6 @@ struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct m=
lx5dr_domain *dmn,
 {
 	enum mlx5dr_icm_chunk_size max_log_chunk_sz;
 	struct mlx5dr_icm_pool *pool;
-	int i;
=20
 	if (icm_type =3D=3D DR_ICM_TYPE_STE)
 		max_log_chunk_sz =3D dmn->info.max_log_sw_icm_sz;
@@ -526,43 +432,24 @@ struct mlx5dr_icm_pool *mlx5dr_icm_pool_create(struct=
 mlx5dr_domain *dmn,
 	if (!pool)
 		return NULL;
=20
-	pool->buckets =3D kcalloc(max_log_chunk_sz + 1,
-				sizeof(pool->buckets[0]),
-				GFP_KERNEL);
-	if (!pool->buckets)
-		goto free_pool;
-
 	pool->dmn =3D dmn;
 	pool->icm_type =3D icm_type;
 	pool->max_log_chunk_sz =3D max_log_chunk_sz;
-	pool->num_of_buckets =3D max_log_chunk_sz + 1;
-	INIT_LIST_HEAD(&pool->icm_mr_list);
=20
-	for (i =3D 0; i < pool->num_of_buckets; i++)
-		dr_icm_bucket_init(pool, &pool->buckets[i], i);
+	INIT_LIST_HEAD(&pool->buddy_mem_list);
=20
-	mutex_init(&pool->mr_mutex);
+	mutex_init(&pool->mutex);
=20
 	return pool;
-
-free_pool:
-	kvfree(pool);
-	return NULL;
 }
=20
 void mlx5dr_icm_pool_destroy(struct mlx5dr_icm_pool *pool)
 {
-	struct mlx5dr_icm_mr *icm_mr, *next;
-	int i;
-
-	mutex_destroy(&pool->mr_mutex);
-
-	list_for_each_entry_safe(icm_mr, next, &pool->icm_mr_list, mr_list)
-		dr_icm_pool_mr_destroy(icm_mr);
+	struct mlx5dr_icm_buddy_mem *buddy, *tmp_buddy;
=20
-	for (i =3D 0; i < pool->num_of_buckets; i++)
-		dr_icm_bucket_cleanup(&pool->buckets[i]);
+	list_for_each_entry_safe(buddy, tmp_buddy, &pool->buddy_mem_list, list_no=
de)
+		dr_icm_buddy_destroy(buddy);
=20
-	kfree(pool->buckets);
+	mutex_destroy(&pool->mutex);
 	kvfree(pool);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/=
drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 5642484b3a5b..3e423c8ed22f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -114,7 +114,7 @@ enum mlx5dr_ipv {
=20
 struct mlx5dr_icm_pool;
 struct mlx5dr_icm_chunk;
-struct mlx5dr_icm_bucket;
+struct mlx5dr_icm_buddy_mem;
 struct mlx5dr_ste_htbl;
 struct mlx5dr_match_param;
 struct mlx5dr_cmd_caps;
@@ -803,7 +803,7 @@ void mlx5dr_rule_update_rule_member(struct mlx5dr_ste *=
new_ste,
 				    struct mlx5dr_ste *ste);
=20
 struct mlx5dr_icm_chunk {
-	struct mlx5dr_icm_bucket *bucket;
+	struct mlx5dr_icm_buddy_mem *buddy_mem;
 	struct list_head chunk_list;
 	u32 rkey;
 	u32 num_of_entries;
@@ -811,6 +811,11 @@ struct mlx5dr_icm_chunk {
 	u64 icm_addr;
 	u64 mr_addr;
=20
+	/* indicates the index of this chunk in the whole memory,
+	 * used for deleting the chunk from the buddy
+	 */
+	unsigned int seg;
+
 	/* Memory optimisation */
 	struct mlx5dr_ste *ste_arr;
 	u8 *hw_ste_arr;
@@ -844,6 +849,15 @@ int mlx5dr_matcher_select_builders(struct mlx5dr_match=
er *matcher,
 				   enum mlx5dr_ipv outer_ipv,
 				   enum mlx5dr_ipv inner_ipv);
=20
+static inline int
+mlx5dr_icm_pool_dm_type_to_entry_size(enum mlx5dr_icm_type icm_type)
+{
+	if (icm_type =3D=3D DR_ICM_TYPE_STE)
+		return DR_STE_SIZE;
+
+	return DR_MODIFY_ACTION_SIZE;
+}
+
 static inline u32
 mlx5dr_icm_pool_chunk_size_to_entries(enum mlx5dr_icm_chunk_size chunk_siz=
e)
 {
@@ -857,11 +871,7 @@ mlx5dr_icm_pool_chunk_size_to_byte(enum mlx5dr_icm_chu=
nk_size chunk_size,
 	int num_of_entries;
 	int entry_size;
=20
-	if (icm_type =3D=3D DR_ICM_TYPE_STE)
-		entry_size =3D DR_STE_SIZE;
-	else
-		entry_size =3D DR_MODIFY_ACTION_SIZE;
-
+	entry_size =3D mlx5dr_icm_pool_dm_type_to_entry_size(icm_type);
 	num_of_entries =3D mlx5dr_icm_pool_chunk_size_to_entries(chunk_size);
=20
 	return entry_size * num_of_entries;
--=20
2.26.2

