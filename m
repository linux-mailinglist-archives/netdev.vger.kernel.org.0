Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12CA5580C53
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231512AbiGZHVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238003AbiGZHUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:20:19 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2054.outbound.protection.outlook.com [40.107.244.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82662C15;
        Tue, 26 Jul 2022 00:20:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZOD1UndmeTGTk9hgFyivuVF5S7Oe4keZXZQZZMkR0V2ccNKRL9C2VT+gmSh6RqZ3WgAayKwXAsjTweLSBmuyHpr/MPeAhcK9e7IhoA7BqdZD+TafEeC82PX8u504ILUG08wJSuQU7BLz/nVr3aW8qV/gi/E2QAHIV0OWoWcVAO5D11Fjc1QKxQXTmoTKchT1ndDAY1/Wd40DNMJZWX5ss/oxqjiUwcqP/+2ogSgyje4jK6snZ/xUXaddFQMCnzH3b9oddnNGSbNafxxzDmc5RJlRKmKgZYVC8r655PCFmzvsA5fpm8JlifljZQmnoAgyEzbHPFAXLdXsLdTKhLH2eQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mKP0PGsxWiAbe3Z++CSnEe39J+N4eERze7OVZ3qeGF0=;
 b=eqmFksHeUmBK29JppN/b7JOIxfrQjs79QPzZYBGUJNSauL/Udlu+O0obgsCkD7m3iY2HUsvxRltVgakcfa1qngLn7CdYCtC/TmpDpsWSTy+TCOFk/D2xEOC56eXBZZ1txLzlD/MGXbYNNURLmpVrsDQ2yQhmKfk5EIQ5NHQkEqvKWwflmbOAxRfbQTYQspjvPvwXYS62T2Y5zkSkZY/CdsagNPhOUBDD9QROyOX0enejhCQbhoMVedqjDRBumLw4x9MsUot89HkJtp+b48q3dRYal23qpaxL18f6M4wJAwIo4xdsLekM/uyrs+YcLddb1RaMth2q4ZvTa+fMHMyVGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mKP0PGsxWiAbe3Z++CSnEe39J+N4eERze7OVZ3qeGF0=;
 b=tZXPGRrrXpENeferl6o9Rtb9x2605tGcFEXvpPKe3ob2V95efy/natQmWnKP5GNrA3yLL91jVX/Qpgbt6aAlmVE/sH322G1JOs7MRHiUFlKYF2DVFUQ3N2h0xttgDYK4Wc1nTiL5joa1qYeggIVc1RizBkDOnuHGGd2Ga9C3H6rSntekcvOo5K9X4p8iHgbedQpO6fxZ0wy/xC2jCmsxmg9T464piXFWp9L0MYIqBBxfxK7AMMUQ0XjuaucSVsUi6Kfz6jaktRzNI3oC0yjCCbntoZX4IB4ymO4y7qr+bAAiMLc0+GBwGogsmbujuH/wFvmnoyWKPibweBCF/C+XtA==
Received: from BN0PR07CA0007.namprd07.prod.outlook.com (2603:10b6:408:141::24)
 by MN2PR12MB3821.namprd12.prod.outlook.com (2603:10b6:208:16f::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Tue, 26 Jul
 2022 07:20:09 +0000
Received: from BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:141:cafe::11) by BN0PR07CA0007.outlook.office365.com
 (2603:10b6:408:141::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Tue, 26 Jul 2022 07:20:09 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT035.mail.protection.outlook.com (10.13.177.116) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5458.17 via Frontend Transport; Tue, 26 Jul 2022 07:20:09 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Tue, 26 Jul
 2022 07:19:56 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Tue, 26 Jul
 2022 00:19:55 -0700
Received: from vdi.nvidia.com (10.127.8.14) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.26 via Frontend Transport; Tue, 26 Jul
 2022 00:19:53 -0700
From:   Michael Guralnik <michaelgur@nvidia.com>
To:     <jgg@nvidia.com>
CC:     <leonro@nvidia.com>, <maorg@nvidia.com>,
        <linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, <saeedm@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>
Subject: [PATCH rdma-next v1 4/5] RDMA/mlx5: Store in the cache mkeys instead of mrs
Date:   Tue, 26 Jul 2022 10:19:10 +0300
Message-ID: <20220726071911.122765-5-michaelgur@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220726071911.122765-1-michaelgur@nvidia.com>
References: <20220726071911.122765-1-michaelgur@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ad09110-44dd-47e6-bb14-08da6ed745c1
X-MS-TrafficTypeDiagnostic: MN2PR12MB3821:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gThhRpol5UUUV7EP0o1t1ORoI6jihP6UPYq4GMYVKtq9KbjrDTDwrY0TBzcn+P00rKKV7Ok6X6VNBPFkdkAc7jeR33JglqlV+bIpwhBG/3JP5bkW7ed63J4e7xt/pl1vhNAK5UplDgFsJhhu1RB5mqpMH/Z9m72jCR/FxuuQvlqnw/Qo2TCPAXxU6NqBHyX/cNeihk3r0fIlQ+CjQ5Ge+Jp1JGiWLyRMBppGPiIELo81HH2h+8aZEKG+Qcv9eVHdi7tdUYnTW2iDBfcMs4aQYyNSQI/mEe3ANqgC3Gxixc8N+aNelsP3TBwfXFG2lQw/5sL1KILNQsH+mVscsFnbruSM5tOKOyEXuOzas0T9nD7Om93qKdhJ8MF+/UBhKoCio2n9IInM3N7MIgLQIGvOCKkfZN4nE2s5NDVRVx4zs74g+L4YY8SP9xYlYTqwy6HLR74lHqVRa4MaphrSs83JwJjFCAVDAAipiXvtcE0Oz+cLsdVL2zAdPMgABRrBTs+yu4KnxkeKTkqsyUY59A7uNrHaBaAFZ5jhZy6hvv61Ns3tVb4n/rYlmIMUwBAX2PT2qZP+o/egzjYJJGStsZUaIRcot5nAZs+ahnu7dcUkdzyASlzUgtQWS/3zkHWlzrX+sTykQudoJLqlpYviltUmCTwOp+3WgS1xuirt5oFhQjQyMOR7B6pm+hBGwouTJgThSvGAZFtS+/VHeiRkdcZ4cGoRLyfnL6PYC03gl7LBBUUyrKu3kwRIh8qdBEb3Y/ORGdAtRoC84+A+iMmjRkCKchTSMsYfPgB2BJTBrwCDAafxvd19bTMfpaWjqnmjT8dyyKYM2DF1xs805BMTyjTiyg==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(346002)(396003)(136003)(376002)(36840700001)(40470700004)(46966006)(70586007)(186003)(2906002)(70206006)(41300700001)(356005)(82740400003)(4326008)(8676002)(30864003)(336012)(5660300002)(47076005)(40480700001)(83380400001)(426003)(6862004)(8936002)(478600001)(107886003)(86362001)(36756003)(2616005)(6636002)(54906003)(40460700003)(316002)(6666004)(81166007)(82310400005)(450100002)(26005)(1076003)(7696005)(36860700001)(37006003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Jul 2022 07:20:09.1351
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ad09110-44dd-47e6-bb14-08da6ed745c1
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT035.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3821
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aharon Landau <aharonl@nvidia.com>

Currently, the driver stores mlx5_ib_mr struct in the cache entries,
although the only use of the cached MR is the mkey. Store only the mkey
in the cache.

Signed-off-by: Aharon Landau <aharonl@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  26 ++--
 drivers/infiniband/hw/mlx5/mr.c      | 200 ++++++++++++---------------
 2 files changed, 97 insertions(+), 129 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index da9202f4b5f3..91f985cd7d90 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -619,6 +619,7 @@ struct mlx5_ib_mkey {
 	unsigned int ndescs;
 	struct wait_queue_head wait;
 	refcount_t usecount;
+	struct mlx5_cache_ent *cache_ent;
 };
 
 #define MLX5_IB_MTT_PRESENT (MLX5_IB_MTT_READ | MLX5_IB_MTT_WRITE)
@@ -641,18 +642,9 @@ struct mlx5_ib_mr {
 	struct ib_mr ibmr;
 	struct mlx5_ib_mkey mmkey;
 
-	/* User MR data */
-	struct mlx5_cache_ent *cache_ent;
-	/* Everything after cache_ent is zero'd when MR allocated */
 	struct ib_umem *umem;
 
 	union {
-		/* Used only while the MR is in the cache */
-		struct {
-			u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
-			struct mlx5_async_work cb_work;
-		};
-
 		/* Used only by kernel MRs (umem == NULL) */
 		struct {
 			void *descs;
@@ -692,12 +684,6 @@ struct mlx5_ib_mr {
 	};
 };
 
-/* Zero the fields in the mr that are variant depending on usage */
-static inline void mlx5_clear_mr(struct mlx5_ib_mr *mr)
-{
-	memset_after(mr, 0, cache_ent);
-}
-
 static inline bool is_odp_mr(struct mlx5_ib_mr *mr)
 {
 	return IS_ENABLED(CONFIG_INFINIBAND_ON_DEMAND_PAGING) && mr->umem &&
@@ -768,6 +754,16 @@ struct mlx5_cache_ent {
 	struct delayed_work	dwork;
 };
 
+struct mlx5r_async_create_mkey {
+	union {
+		u32 in[MLX5_ST_SZ_BYTES(create_mkey_in)];
+		u32 out[MLX5_ST_SZ_DW(create_mkey_out)];
+	};
+	struct mlx5_async_work cb_work;
+	struct mlx5_cache_ent *ent;
+	u32 mkey;
+};
+
 struct mlx5_mr_cache {
 	struct workqueue_struct *wq;
 	struct mlx5_cache_ent	ent[MAX_MR_CACHE_ENTRIES];
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 26bfdbba24b4..edbc2990d151 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -82,15 +82,14 @@ static void set_mkc_access_pd_addr_fields(void *mkc, int acc, u64 start_addr,
 	MLX5_SET64(mkc, mkc, start_addr, start_addr);
 }
 
-static void assign_mkey_variant(struct mlx5_ib_dev *dev,
-				struct mlx5_ib_mkey *mkey, u32 *in)
+static void assign_mkey_variant(struct mlx5_ib_dev *dev, u32 *mkey, u32 *in)
 {
 	u8 key = atomic_inc_return(&dev->mkey_var);
 	void *mkc;
 
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	MLX5_SET(mkc, mkc, mkey_7_0, key);
-	mkey->key = key;
+	*mkey = key;
 }
 
 static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev,
@@ -98,7 +97,7 @@ static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev,
 {
 	int ret;
 
-	assign_mkey_variant(dev, mkey, in);
+	assign_mkey_variant(dev, &mkey->key, in);
 	ret = mlx5_core_create_mkey(dev->mdev, &mkey->key, in, inlen);
 	if (!ret)
 		init_waitqueue_head(&mkey->wait);
@@ -106,17 +105,18 @@ static int mlx5_ib_create_mkey(struct mlx5_ib_dev *dev,
 	return ret;
 }
 
-static int
-mlx5_ib_create_mkey_cb(struct mlx5_ib_dev *dev,
-		       struct mlx5_ib_mkey *mkey,
-		       struct mlx5_async_ctx *async_ctx,
-		       u32 *in, int inlen, u32 *out, int outlen,
-		       struct mlx5_async_work *context)
+static int mlx5_ib_create_mkey_cb(struct mlx5r_async_create_mkey *async_create)
 {
-	MLX5_SET(create_mkey_in, in, opcode, MLX5_CMD_OP_CREATE_MKEY);
-	assign_mkey_variant(dev, mkey, in);
-	return mlx5_cmd_exec_cb(async_ctx, in, inlen, out, outlen,
-				create_mkey_callback, context);
+	struct mlx5_ib_dev *dev = async_create->ent->dev;
+	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
+	size_t outlen = MLX5_ST_SZ_BYTES(create_mkey_out);
+
+	MLX5_SET(create_mkey_in, async_create->in, opcode,
+		 MLX5_CMD_OP_CREATE_MKEY);
+	assign_mkey_variant(dev, &async_create->mkey, async_create->in);
+	return mlx5_cmd_exec_cb(&dev->async_ctx, async_create->in, inlen,
+				async_create->out, outlen, create_mkey_callback,
+				&async_create->cb_work);
 }
 
 static int mr_cache_max_order(struct mlx5_ib_dev *dev);
@@ -209,48 +209,47 @@ static void undo_push_reserve_mkey(struct mlx5_cache_ent *ent)
 	WARN_ON(old);
 }
 
-static void push_to_reserved(struct mlx5_cache_ent *ent, struct mlx5_ib_mr *mr)
+static void push_to_reserved(struct mlx5_cache_ent *ent, u32 mkey)
 {
 	void *old;
 
-	old = __xa_store(&ent->mkeys, ent->stored, mr, 0);
+	old = __xa_store(&ent->mkeys, ent->stored, xa_mk_value(mkey), 0);
 	WARN_ON(old);
 	ent->stored++;
 }
 
-static struct mlx5_ib_mr *pop_stored_mkey(struct mlx5_cache_ent *ent)
+static u32 pop_stored_mkey(struct mlx5_cache_ent *ent)
 {
-	struct mlx5_ib_mr *mr;
-	void *old;
+	void *old, *xa_mkey;
 
 	ent->stored--;
 	ent->reserved--;
 
 	if (ent->stored == ent->reserved) {
-		mr = __xa_erase(&ent->mkeys, ent->stored);
-		WARN_ON(!mr);
-		return mr;
+		xa_mkey = __xa_erase(&ent->mkeys, ent->stored);
+		WARN_ON(!xa_mkey);
+		return (u32)xa_to_value(xa_mkey);
 	}
 
-	mr = __xa_store(&ent->mkeys, ent->stored, XA_ZERO_ENTRY,
-				GFP_KERNEL);
-	WARN_ON(!mr || xa_is_err(mr));
+	xa_mkey = __xa_store(&ent->mkeys, ent->stored, XA_ZERO_ENTRY,
+			     GFP_KERNEL);
+	WARN_ON(!xa_mkey || xa_is_err(xa_mkey));
 	old = __xa_erase(&ent->mkeys, ent->reserved);
 	WARN_ON(old);
-	return mr;
+	return (u32)xa_to_value(xa_mkey);
 }
 
 static void create_mkey_callback(int status, struct mlx5_async_work *context)
 {
-	struct mlx5_ib_mr *mr =
-		container_of(context, struct mlx5_ib_mr, cb_work);
-	struct mlx5_cache_ent *ent = mr->cache_ent;
+	struct mlx5r_async_create_mkey *mkey_out =
+		container_of(context, struct mlx5r_async_create_mkey, cb_work);
+	struct mlx5_cache_ent *ent = mkey_out->ent;
 	struct mlx5_ib_dev *dev = ent->dev;
 	unsigned long flags;
 
 	if (status) {
-		create_mkey_warn(dev, status, mr->out);
-		kfree(mr);
+		create_mkey_warn(dev, status, mkey_out->out);
+		kfree(mkey_out);
 		xa_lock_irqsave(&ent->mkeys, flags);
 		undo_push_reserve_mkey(ent);
 		WRITE_ONCE(dev->fill_delay, 1);
@@ -259,18 +258,16 @@ static void create_mkey_callback(int status, struct mlx5_async_work *context)
 		return;
 	}
 
-	mr->mmkey.type = MLX5_MKEY_MR;
-	mr->mmkey.key |= mlx5_idx_to_mkey(
-		MLX5_GET(create_mkey_out, mr->out, mkey_index));
-	init_waitqueue_head(&mr->mmkey.wait);
-
+	mkey_out->mkey |= mlx5_idx_to_mkey(
+		MLX5_GET(create_mkey_out, mkey_out->out, mkey_index));
 	WRITE_ONCE(dev->cache.last_add, jiffies);
 
 	xa_lock_irqsave(&ent->mkeys, flags);
-	push_to_reserved(ent, mr);
+	push_to_reserved(ent, mkey_out->mkey);
 	/* If we are doing fill_to_high_water then keep going. */
 	queue_adjust_cache_locked(ent);
 	xa_unlock_irqrestore(&ent->mkeys, flags);
+	kfree(mkey_out);
 }
 
 static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
@@ -292,15 +289,8 @@ static int get_mkc_octo_size(unsigned int access_mode, unsigned int ndescs)
 	return ret;
 }
 
-static struct mlx5_ib_mr *alloc_cache_mr(struct mlx5_cache_ent *ent, void *mkc)
+static void set_cache_mkc(struct mlx5_cache_ent *ent, void *mkc)
 {
-	struct mlx5_ib_mr *mr;
-
-	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
-	if (!mr)
-		return NULL;
-	mr->cache_ent = ent;
-
 	set_mkc_access_pd_addr_fields(mkc, 0, 0, ent->dev->umrc.pd);
 	MLX5_SET(mkc, mkc, free, 1);
 	MLX5_SET(mkc, mkc, umr_en, 1);
@@ -310,106 +300,82 @@ static struct mlx5_ib_mr *alloc_cache_mr(struct mlx5_cache_ent *ent, void *mkc)
 	MLX5_SET(mkc, mkc, translations_octword_size,
 		 get_mkc_octo_size(ent->access_mode, ent->ndescs));
 	MLX5_SET(mkc, mkc, log_page_size, ent->page);
-	return mr;
 }
 
 /* Asynchronously schedule new MRs to be populated in the cache. */
 static int add_keys(struct mlx5_cache_ent *ent, unsigned int num)
 {
-	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	struct mlx5_ib_mr *mr;
+	struct mlx5r_async_create_mkey *async_create;
 	void *mkc;
-	u32 *in;
 	int err = 0;
 	int i;
 
-	in = kzalloc(inlen, GFP_KERNEL);
-	if (!in)
-		return -ENOMEM;
-
-	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
 	for (i = 0; i < num; i++) {
-		mr = alloc_cache_mr(ent, mkc);
-		if (!mr) {
-			err = -ENOMEM;
-			goto free_in;
-		}
+		async_create = kzalloc(sizeof(struct mlx5r_async_create_mkey),
+				       GFP_KERNEL);
+		if (!async_create)
+			return -ENOMEM;
+		mkc = MLX5_ADDR_OF(create_mkey_in, async_create->in,
+				   memory_key_mkey_entry);
+		set_cache_mkc(ent, mkc);
+		async_create->ent = ent;
 
 		err = push_mkey(ent, true, NULL);
 		if (err)
-			goto free_mr;
+			goto free_async_create;
 
-		err = mlx5_ib_create_mkey_cb(ent->dev, &mr->mmkey,
-					     &ent->dev->async_ctx, in, inlen,
-					     mr->out, sizeof(mr->out),
-					     &mr->cb_work);
+		err = mlx5_ib_create_mkey_cb(async_create);
 		if (err) {
 			mlx5_ib_warn(ent->dev, "create mkey failed %d\n", err);
 			goto err_undo_reserve;
 		}
 	}
 
-	kfree(in);
 	return 0;
 
 err_undo_reserve:
 	xa_lock_irq(&ent->mkeys);
 	undo_push_reserve_mkey(ent);
 	xa_unlock_irq(&ent->mkeys);
-free_mr:
-	kfree(mr);
-free_in:
-	kfree(in);
+free_async_create:
+	kfree(async_create);
 	return err;
 }
 
 /* Synchronously create a MR in the cache */
-static struct mlx5_ib_mr *create_cache_mr(struct mlx5_cache_ent *ent)
+static int create_cache_mkey(struct mlx5_cache_ent *ent, u32 *mkey)
 {
 	size_t inlen = MLX5_ST_SZ_BYTES(create_mkey_in);
-	struct mlx5_ib_mr *mr;
 	void *mkc;
 	u32 *in;
 	int err;
 
 	in = kzalloc(inlen, GFP_KERNEL);
 	if (!in)
-		return ERR_PTR(-ENOMEM);
+		return -ENOMEM;
 	mkc = MLX5_ADDR_OF(create_mkey_in, in, memory_key_mkey_entry);
+	set_cache_mkc(ent, mkc);
 
-	mr = alloc_cache_mr(ent, mkc);
-	if (!mr) {
-		err = -ENOMEM;
-		goto free_in;
-	}
-
-	err = mlx5_core_create_mkey(ent->dev->mdev, &mr->mmkey.key, in, inlen);
+	err = mlx5_core_create_mkey(ent->dev->mdev, mkey, in, inlen);
 	if (err)
-		goto free_mr;
+		goto free_in;
 
-	init_waitqueue_head(&mr->mmkey.wait);
-	mr->mmkey.type = MLX5_MKEY_MR;
 	WRITE_ONCE(ent->dev->cache.last_add, jiffies);
-	kfree(in);
-	return mr;
-free_mr:
-	kfree(mr);
 free_in:
 	kfree(in);
-	return ERR_PTR(err);
+	return err;
 }
 
 static void remove_cache_mr_locked(struct mlx5_cache_ent *ent)
 {
-	struct mlx5_ib_mr *mr;
+	u32 mkey;
 
 	lockdep_assert_held(&ent->mkeys.xa_lock);
 	if (!ent->stored)
 		return;
-	mr = pop_stored_mkey(ent);
+	mkey = pop_stored_mkey(ent);
 	xa_unlock_irq(&ent->mkeys);
-	mlx5_core_destroy_mkey(ent->dev->mdev, mr->mmkey.key);
-	kfree(mr);
+	mlx5_core_destroy_mkey(ent->dev->mdev, mkey);
 	xa_lock_irq(&ent->mkeys);
 }
 
@@ -678,11 +644,15 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 				       int access_flags)
 {
 	struct mlx5_ib_mr *mr;
+	int err;
 
-	/* Matches access in alloc_cache_mr() */
 	if (!mlx5r_umr_can_reconfig(dev, 0, access_flags))
 		return ERR_PTR(-EOPNOTSUPP);
 
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr)
+		return ERR_PTR(-ENOMEM);
+
 	xa_lock_irq(&ent->mkeys);
 	ent->in_use++;
 
@@ -690,20 +660,22 @@ struct mlx5_ib_mr *mlx5_mr_cache_alloc(struct mlx5_ib_dev *dev,
 		queue_adjust_cache_locked(ent);
 		ent->miss++;
 		xa_unlock_irq(&ent->mkeys);
-		mr = create_cache_mr(ent);
-		if (IS_ERR(mr)) {
+		err = create_cache_mkey(ent, &mr->mmkey.key);
+		if (err) {
 			xa_lock_irq(&ent->mkeys);
 			ent->in_use--;
 			xa_unlock_irq(&ent->mkeys);
-			return mr;
+			kfree(mr);
+			return ERR_PTR(err);
 		}
 	} else {
-		mr = pop_stored_mkey(ent);
+		mr->mmkey.key = pop_stored_mkey(ent);
 		queue_adjust_cache_locked(ent);
 		xa_unlock_irq(&ent->mkeys);
-
-		mlx5_clear_mr(mr);
 	}
+	mr->mmkey.cache_ent = ent;
+	mr->mmkey.type = MLX5_MKEY_MR;
+	init_waitqueue_head(&mr->mmkey.wait);
 	return mr;
 }
 
@@ -711,15 +683,14 @@ static void clean_keys(struct mlx5_ib_dev *dev, int c)
 {
 	struct mlx5_mr_cache *cache = &dev->cache;
 	struct mlx5_cache_ent *ent = &cache->ent[c];
-	struct mlx5_ib_mr *mr;
+	u32 mkey;
 
 	cancel_delayed_work(&ent->dwork);
 	xa_lock_irq(&ent->mkeys);
 	while (ent->stored) {
-		mr = pop_stored_mkey(ent);
+		mkey = pop_stored_mkey(ent);
 		xa_unlock_irq(&ent->mkeys);
-		mlx5_core_destroy_mkey(dev->mdev, mr->mmkey.key);
-		kfree(mr);
+		mlx5_core_destroy_mkey(dev->mdev, mkey);
 		xa_lock_irq(&ent->mkeys);
 	}
 	xa_unlock_irq(&ent->mkeys);
@@ -1391,7 +1362,7 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 	struct mlx5_ib_dev *dev = to_mdev(mr->ibmr.device);
 
 	/* We only track the allocated sizes of MRs from the cache */
-	if (!mr->cache_ent)
+	if (!mr->mmkey.cache_ent)
 		return false;
 	if (!mlx5r_umr_can_load_pas(dev, new_umem->length))
 		return false;
@@ -1400,7 +1371,7 @@ static bool can_use_umr_rereg_pas(struct mlx5_ib_mr *mr,
 		mlx5_umem_find_best_pgsz(new_umem, mkc, log_page_size, 0, iova);
 	if (WARN_ON(!*page_size))
 		return false;
-	return (1ULL << mr->cache_ent->order) >=
+	return (1ULL << mr->mmkey.cache_ent->order) >=
 	       ib_umem_num_dma_blocks(new_umem, *page_size);
 }
 
@@ -1641,16 +1612,17 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 	}
 
 	/* Stop DMA */
-	if (mr->cache_ent) {
-		xa_lock_irq(&mr->cache_ent->mkeys);
-		mr->cache_ent->in_use--;
-		xa_unlock_irq(&mr->cache_ent->mkeys);
+	if (mr->mmkey.cache_ent) {
+		xa_lock_irq(&mr->mmkey.cache_ent->mkeys);
+		mr->mmkey.cache_ent->in_use--;
+		xa_unlock_irq(&mr->mmkey.cache_ent->mkeys);
 
 		if (mlx5r_umr_revoke_mr(mr) ||
-		    push_mkey(mr->cache_ent, false, mr))
-			mr->cache_ent = NULL;
+		    push_mkey(mr->mmkey.cache_ent, false,
+			      xa_mk_value(mr->mmkey.key)))
+			mr->mmkey.cache_ent = NULL;
 	}
-	if (!mr->cache_ent) {
+	if (!mr->mmkey.cache_ent) {
 		rc = destroy_mkey(to_mdev(mr->ibmr.device), mr);
 		if (rc)
 			return rc;
@@ -1667,10 +1639,10 @@ int mlx5_ib_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 			mlx5_ib_free_odp_mr(mr);
 	}
 
-	if (!mr->cache_ent) {
+	if (!mr->mmkey.cache_ent)
 		mlx5_free_priv_descs(mr);
-		kfree(mr);
-	}
+
+	kfree(mr);
 	return 0;
 }
 
-- 
2.17.2

