Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF55164E66
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 20:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726820AbgBSTFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 14:05:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:41824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726613AbgBSTF3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Feb 2020 14:05:29 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFC4C2465D;
        Wed, 19 Feb 2020 19:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582139128;
        bh=XgMNeW1yq3fROJV+sUppZ3REGe913N4jb5c5im7xE24=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lrY+PeSCnZfco1ASgkcAC9lbSOtGu3X6jjwhisaODEALVjulrp2DjLl7Kex5WlD+J
         KzLG6P+9EGrVdVDzjFFV/xCbQVwbQ4V55fukBgBwmGQc/C4mozUdJf1fuHqF7gmAoC
         Ix76OAqZEwtCBsLxoDa/YrdG3U7jlwoaoEpog3Nw=
From:   Leon Romanovsky <leon@kernel.org>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yishai Hadas <yishaih@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH mlx5-next 1/2] net/mlx5: Expose raw packet pacing APIs
Date:   Wed, 19 Feb 2020 21:05:17 +0200
Message-Id: <20200219190518.200912-2-leon@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200219190518.200912-1-leon@kernel.org>
References: <20200219190518.200912-1-leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Expose raw packet pacing APIs to be used by DEVX based applications.
The existing code was refactored to have a single flow with the new raw
APIs.

The new raw APIs considered the input of 'pp_rate_limit_context', uid,
'dedicated', upon looking for an existing entry.

This raw mode enables future device specification data in the raw
context without changing the existing logic and code.

The ability to ask for a dedicated entry gives control for application
to allocate entries according to its needs.

A dedicated entry may not be used by some other process and it also
enables the process spreading its resources to some different entries
for use different hardware resources as part of enforcing the rate.

The counter per entry mas changed to be u64 to prevent any option to
overflow.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/rl.c | 130 ++++++++++++++-----
 include/linux/mlx5/driver.h                  |  11 +-
 include/linux/mlx5/mlx5_ifc.h                |  26 ++--
 3 files changed, 122 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rl.c b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
index 01c380425f9d..f3b29d9ade1f 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rl.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rl.c
@@ -101,22 +101,39 @@ int mlx5_destroy_scheduling_element_cmd(struct mlx5_core_dev *dev, u8 hierarchy,
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
+static bool mlx5_rl_are_equal_raw(struct mlx5_rl_entry *entry, void *rl_in,
+				  u16 uid)
+{
+	return (!memcmp(entry->rl_raw, rl_in, sizeof(entry->rl_raw)) &&
+		entry->uid == uid);
+}
+
 /* Finds an entry where we can register the given rate
  * If the rate already exists, return the entry where it is registered,
  * otherwise return the first available entry.
  * If the table is full, return NULL
  */
 static struct mlx5_rl_entry *find_rl_entry(struct mlx5_rl_table *table,
-					   struct mlx5_rate_limit *rl)
+					   void *rl_in, u16 uid, bool dedicated)
 {
 	struct mlx5_rl_entry *ret_entry = NULL;
 	bool empty_found = false;
 	int i;
 
 	for (i = 0; i < table->max_size; i++) {
-		if (mlx5_rl_are_equal(&table->rl_entry[i].rl, rl))
-			return &table->rl_entry[i];
-		if (!empty_found && !table->rl_entry[i].rl.rate) {
+		if (dedicated) {
+			if (!table->rl_entry[i].refcount)
+				return &table->rl_entry[i];
+			continue;
+		}
+
+		if (table->rl_entry[i].refcount) {
+			if (table->rl_entry[i].dedicated)
+				continue;
+			if (mlx5_rl_are_equal_raw(&table->rl_entry[i], rl_in,
+						  uid))
+				return &table->rl_entry[i];
+		} else if (!empty_found) {
 			empty_found = true;
 			ret_entry = &table->rl_entry[i];
 		}
@@ -126,18 +143,19 @@ static struct mlx5_rl_entry *find_rl_entry(struct mlx5_rl_table *table,
 }
 
 static int mlx5_set_pp_rate_limit_cmd(struct mlx5_core_dev *dev,
-				      u16 index,
-				      struct mlx5_rate_limit *rl)
+				      struct mlx5_rl_entry *entry, bool set)
 {
-	u32 in[MLX5_ST_SZ_DW(set_pp_rate_limit_in)]   = {0};
-	u32 out[MLX5_ST_SZ_DW(set_pp_rate_limit_out)] = {0};
+	u32 in[MLX5_ST_SZ_DW(set_pp_rate_limit_in)]   = {};
+	u32 out[MLX5_ST_SZ_DW(set_pp_rate_limit_out)] = {};
+	void *pp_context;
 
+	pp_context = MLX5_ADDR_OF(set_pp_rate_limit_in, in, ctx);
 	MLX5_SET(set_pp_rate_limit_in, in, opcode,
 		 MLX5_CMD_OP_SET_PP_RATE_LIMIT);
-	MLX5_SET(set_pp_rate_limit_in, in, rate_limit_index, index);
-	MLX5_SET(set_pp_rate_limit_in, in, rate_limit, rl->rate);
-	MLX5_SET(set_pp_rate_limit_in, in, burst_upper_bound, rl->max_burst_sz);
-	MLX5_SET(set_pp_rate_limit_in, in, typical_packet_size, rl->typical_pkt_sz);
+	MLX5_SET(set_pp_rate_limit_in, in, uid, entry->uid);
+	MLX5_SET(set_pp_rate_limit_in, in, rate_limit_index, entry->index);
+	if (set)
+		memcpy(pp_context, entry->rl_raw, sizeof(entry->rl_raw));
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
 
@@ -158,23 +176,25 @@ bool mlx5_rl_are_equal(struct mlx5_rate_limit *rl_0,
 }
 EXPORT_SYMBOL(mlx5_rl_are_equal);
 
-int mlx5_rl_add_rate(struct mlx5_core_dev *dev, u16 *index,
-		     struct mlx5_rate_limit *rl)
+int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16 uid,
+			 bool dedicated_entry, u16 *index)
 {
 	struct mlx5_rl_table *table = &dev->priv.rl_table;
 	struct mlx5_rl_entry *entry;
 	int err = 0;
+	u32 rate;
 
+	rate = MLX5_GET(set_pp_rate_limit_context, rl_in, rate_limit);
 	mutex_lock(&table->rl_lock);
 
-	if (!rl->rate || !mlx5_rl_is_in_range(dev, rl->rate)) {
+	if (!rate || !mlx5_rl_is_in_range(dev, rate)) {
 		mlx5_core_err(dev, "Invalid rate: %u, should be %u to %u\n",
-			      rl->rate, table->min_rate, table->max_rate);
+			      rate, table->min_rate, table->max_rate);
 		err = -EINVAL;
 		goto out;
 	}
 
-	entry = find_rl_entry(table, rl);
+	entry = find_rl_entry(table, rl_in, uid, dedicated_entry);
 	if (!entry) {
 		mlx5_core_err(dev, "Max number of %u rates reached\n",
 			      table->max_size);
@@ -185,16 +205,24 @@ int mlx5_rl_add_rate(struct mlx5_core_dev *dev, u16 *index,
 		/* rate already configured */
 		entry->refcount++;
 	} else {
+		memcpy(entry->rl_raw, rl_in, sizeof(entry->rl_raw));
+		entry->uid = uid;
 		/* new rate limit */
-		err = mlx5_set_pp_rate_limit_cmd(dev, entry->index, rl);
+		err = mlx5_set_pp_rate_limit_cmd(dev, entry, true);
 		if (err) {
-			mlx5_core_err(dev, "Failed configuring rate limit(err %d): rate %u, max_burst_sz %u, typical_pkt_sz %u\n",
-				      err, rl->rate, rl->max_burst_sz,
-				      rl->typical_pkt_sz);
+			mlx5_core_err(
+				dev,
+				"Failed configuring rate limit(err %d): rate %u, max_burst_sz %u, typical_pkt_sz %u\n",
+				err, rate,
+				MLX5_GET(set_pp_rate_limit_context, rl_in,
+					 burst_upper_bound),
+				MLX5_GET(set_pp_rate_limit_context, rl_in,
+					 typical_packet_size));
 			goto out;
 		}
-		entry->rl = *rl;
+
 		entry->refcount = 1;
+		entry->dedicated = dedicated_entry;
 	}
 	*index = entry->index;
 
@@ -202,20 +230,61 @@ int mlx5_rl_add_rate(struct mlx5_core_dev *dev, u16 *index,
 	mutex_unlock(&table->rl_lock);
 	return err;
 }
+EXPORT_SYMBOL(mlx5_rl_add_rate_raw);
+
+void mlx5_rl_remove_rate_raw(struct mlx5_core_dev *dev, u16 index)
+{
+	struct mlx5_rl_table *table = &dev->priv.rl_table;
+	struct mlx5_rl_entry *entry;
+
+	mutex_lock(&table->rl_lock);
+	entry = &table->rl_entry[index - 1];
+	entry->refcount--;
+	if (!entry->refcount)
+		/* need to remove rate */
+		mlx5_set_pp_rate_limit_cmd(dev, entry, false);
+	mutex_unlock(&table->rl_lock);
+}
+EXPORT_SYMBOL(mlx5_rl_remove_rate_raw);
+
+int mlx5_rl_add_rate(struct mlx5_core_dev *dev, u16 *index,
+		     struct mlx5_rate_limit *rl)
+{
+	u8 rl_raw[MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)] = {};
+
+	MLX5_SET(set_pp_rate_limit_context, rl_raw, rate_limit, rl->rate);
+	MLX5_SET(set_pp_rate_limit_context, rl_raw, burst_upper_bound,
+		 rl->max_burst_sz);
+	MLX5_SET(set_pp_rate_limit_context, rl_raw, typical_packet_size,
+		 rl->typical_pkt_sz);
+
+	return mlx5_rl_add_rate_raw(dev, rl_raw,
+				    MLX5_CAP_QOS(dev, packet_pacing_uid) ?
+					MLX5_SHARED_RESOURCE_UID : 0,
+				    false, index);
+}
 EXPORT_SYMBOL(mlx5_rl_add_rate);
 
 void mlx5_rl_remove_rate(struct mlx5_core_dev *dev, struct mlx5_rate_limit *rl)
 {
+	u8 rl_raw[MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)] = {};
 	struct mlx5_rl_table *table = &dev->priv.rl_table;
 	struct mlx5_rl_entry *entry = NULL;
-	struct mlx5_rate_limit reset_rl = {0};
 
 	/* 0 is a reserved value for unlimited rate */
 	if (rl->rate == 0)
 		return;
 
+	MLX5_SET(set_pp_rate_limit_context, rl_raw, rate_limit, rl->rate);
+	MLX5_SET(set_pp_rate_limit_context, rl_raw, burst_upper_bound,
+		 rl->max_burst_sz);
+	MLX5_SET(set_pp_rate_limit_context, rl_raw, typical_packet_size,
+		 rl->typical_pkt_sz);
+
 	mutex_lock(&table->rl_lock);
-	entry = find_rl_entry(table, rl);
+	entry = find_rl_entry(table, rl_raw,
+			      MLX5_CAP_QOS(dev, packet_pacing_uid) ?
+				MLX5_SHARED_RESOURCE_UID : 0, false);
 	if (!entry || !entry->refcount) {
 		mlx5_core_warn(dev, "Rate %u, max_burst_sz %u typical_pkt_sz %u are not configured\n",
 			       rl->rate, rl->max_burst_sz, rl->typical_pkt_sz);
@@ -223,11 +292,9 @@ void mlx5_rl_remove_rate(struct mlx5_core_dev *dev, struct mlx5_rate_limit *rl)
 	}
 
 	entry->refcount--;
-	if (!entry->refcount) {
+	if (!entry->refcount)
 		/* need to remove rate */
-		mlx5_set_pp_rate_limit_cmd(dev, entry->index, &reset_rl);
-		entry->rl = reset_rl;
-	}
+		mlx5_set_pp_rate_limit_cmd(dev, entry, false);
 
 out:
 	mutex_unlock(&table->rl_lock);
@@ -273,14 +340,13 @@ int mlx5_init_rl_table(struct mlx5_core_dev *dev)
 void mlx5_cleanup_rl_table(struct mlx5_core_dev *dev)
 {
 	struct mlx5_rl_table *table = &dev->priv.rl_table;
-	struct mlx5_rate_limit rl = {0};
 	int i;
 
 	/* Clear all configured rates */
 	for (i = 0; i < table->max_size; i++)
-		if (table->rl_entry[i].rl.rate)
-			mlx5_set_pp_rate_limit_cmd(dev, table->rl_entry[i].index,
-						   &rl);
+		if (table->rl_entry[i].refcount)
+			mlx5_set_pp_rate_limit_cmd(dev, &table->rl_entry[i],
+						   false);
 
 	kfree(dev->priv.rl_table.rl_entry);
 }
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 277a51d3ec40..f2b4225ed650 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -518,9 +518,11 @@ struct mlx5_rate_limit {
 };
 
 struct mlx5_rl_entry {
-	struct mlx5_rate_limit	rl;
-	u16                     index;
-	u16                     refcount;
+	u8 rl_raw[MLX5_ST_SZ_BYTES(set_pp_rate_limit_context)];
+	u16 index;
+	u64 refcount;
+	u16 uid;
+	u8 dedicated : 1;
 };
 
 struct mlx5_rl_table {
@@ -1007,6 +1009,9 @@ int mlx5_rl_add_rate(struct mlx5_core_dev *dev, u16 *index,
 		     struct mlx5_rate_limit *rl);
 void mlx5_rl_remove_rate(struct mlx5_core_dev *dev, struct mlx5_rate_limit *rl);
 bool mlx5_rl_is_in_range(struct mlx5_core_dev *dev, u32 rate);
+int mlx5_rl_add_rate_raw(struct mlx5_core_dev *dev, void *rl_in, u16 uid,
+			 bool dedicated_entry, u16 *index);
+void mlx5_rl_remove_rate_raw(struct mlx5_core_dev *dev, u16 index);
 bool mlx5_rl_are_equal(struct mlx5_rate_limit *rl_0,
 		       struct mlx5_rate_limit *rl_1);
 int mlx5_alloc_bfreg(struct mlx5_core_dev *mdev, struct mlx5_sq_bfreg *bfreg,
diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index ff8c9d527bb4..7d89ab64b372 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -810,7 +810,9 @@ struct mlx5_ifc_qos_cap_bits {
 	u8         reserved_at_4[0x1];
 	u8         packet_pacing_burst_bound[0x1];
 	u8         packet_pacing_typical_size[0x1];
-	u8         reserved_at_7[0x19];
+	u8         reserved_at_7[0x4];
+	u8         packet_pacing_uid[0x1];
+	u8         reserved_at_c[0x14];
 
 	u8         reserved_at_20[0x20];
 
@@ -8262,9 +8264,20 @@ struct mlx5_ifc_set_pp_rate_limit_out_bits {
 	u8         reserved_at_40[0x40];
 };
 
+struct mlx5_ifc_set_pp_rate_limit_context_bits {
+	u8         rate_limit[0x20];
+
+	u8	   burst_upper_bound[0x20];
+
+	u8         reserved_at_40[0x10];
+	u8	   typical_packet_size[0x10];
+
+	u8         reserved_at_60[0x120];
+};
+
 struct mlx5_ifc_set_pp_rate_limit_in_bits {
 	u8         opcode[0x10];
-	u8         reserved_at_10[0x10];
+	u8         uid[0x10];
 
 	u8         reserved_at_20[0x10];
 	u8         op_mod[0x10];
@@ -8274,14 +8287,7 @@ struct mlx5_ifc_set_pp_rate_limit_in_bits {
 
 	u8         reserved_at_60[0x20];
 
-	u8         rate_limit[0x20];
-
-	u8	   burst_upper_bound[0x20];
-
-	u8         reserved_at_c0[0x10];
-	u8	   typical_packet_size[0x10];
-
-	u8         reserved_at_e0[0x120];
+	struct mlx5_ifc_set_pp_rate_limit_context_bits ctx;
 };
 
 struct mlx5_ifc_access_register_out_bits {
-- 
2.24.1

