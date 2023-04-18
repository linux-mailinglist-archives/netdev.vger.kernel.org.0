Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A30C6E6066
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbjDRLuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbjDRLuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:50:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E32FAF02;
        Tue, 18 Apr 2023 04:49:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E20DD630C2;
        Tue, 18 Apr 2023 11:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEFF5C433D2;
        Tue, 18 Apr 2023 11:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681818477;
        bh=sX2PTY2QQR91FYj3Fp+THVg06q2dBOjIrndLtKeG1dc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pYx+tjHwWXX/SbXLPifTRDMy7wfU1VOul+jnE4V1lTDxXvwtQCsjilBVKWruaRc4W
         lhc4rASBFjWQV4lobZNQP9Zj3AlVuIWmPMoS5Hwblym3TNDPMxrprC+NQxca5lzp13
         CmpKFYJQe1dNJgEUQm9oDNAPF4vnOpWzxSex3FrJzdoeUnIpDENQTWbBmbwAjt0qq7
         gZpTFkV0qt9t6ooD8bohkBiIZ73x5QCAWa4sK1koAFDZba2UPt9MwxzMkFy5hlfEu3
         RGdYq69nwHD0GvJDmxwumQCeNB9ymQRjGObW9z15L23ibhCpe36EL/NpfFD46qK1R9
         gQe038vEx8Okw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     Yishai Hadas <yishaih@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 2/2] net/mlx4: avoid overloading user/kernel pointers
Date:   Tue, 18 Apr 2023 13:47:12 +0200
Message-Id: <20230418114730.3674657-2-arnd@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230418114730.3674657-1-arnd@kernel.org>
References: <20230418114730.3674657-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The mlx4_ib_create_cq() and mlx4_init_user_cqes() functions cast
between kernel pointers and user pointers, which is confusing
and can easily hide bugs.

Change the code to use use the correct address spaces consistently
and use separate pointer variables in mlx4_cq_alloc() to avoid
mixing them.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
I ran into this while fixing the link error in the first
patch, and decided it would be useful to clean up.
---
 drivers/infiniband/hw/mlx4/cq.c         | 11 +++++++----
 drivers/net/ethernet/mellanox/mlx4/cq.c | 17 ++++++++---------
 include/linux/mlx4/device.h             |  2 +-
 3 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 4cd738aae53c..b12713fdde99 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -180,7 +180,8 @@ int mlx4_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 	struct mlx4_ib_dev *dev = to_mdev(ibdev);
 	struct mlx4_ib_cq *cq = to_mcq(ibcq);
 	struct mlx4_uar *uar;
-	void *buf_addr;
+	void __user *ubuf_addr;
+	void *kbuf_addr;
 	int err;
 	struct mlx4_ib_ucontext *context = rdma_udata_to_drv_context(
 		udata, struct mlx4_ib_ucontext, ibucontext);
@@ -209,7 +210,8 @@ int mlx4_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 			goto err_cq;
 		}
 
-		buf_addr = (void *)(unsigned long)ucmd.buf_addr;
+		ubuf_addr = u64_to_user_ptr(ucmd.buf_addr);
+		kbuf_addr = NULL;
 		err = mlx4_ib_get_cq_umem(dev, &cq->buf, &cq->umem,
 					  ucmd.buf_addr, entries);
 		if (err)
@@ -235,7 +237,8 @@ int mlx4_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 		if (err)
 			goto err_db;
 
-		buf_addr = &cq->buf.buf;
+		ubuf_addr = NULL;
+		kbuf_addr = &cq->buf.buf;
 
 		uar = &dev->priv_uar;
 		cq->mcq.usage = MLX4_RES_USAGE_DRIVER;
@@ -248,7 +251,7 @@ int mlx4_ib_create_cq(struct ib_cq *ibcq, const struct ib_cq_init_attr *attr,
 			    &cq->mcq, vector, 0,
 			    !!(cq->create_flags &
 			       IB_UVERBS_CQ_FLAGS_TIMESTAMP_COMPLETION),
-			    buf_addr, !!udata);
+			    ubuf_addr, kbuf_addr);
 	if (err)
 		goto err_dbmap;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index 020cb8e2883f..22216f4e409b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -287,7 +287,7 @@ static void mlx4_cq_free_icm(struct mlx4_dev *dev, int cqn)
 		__mlx4_cq_free_icm(dev, cqn);
 }
 
-static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
+static int mlx4_init_user_cqes(void __user *buf, int entries, int cqe_size)
 {
 	int entries_per_copy = PAGE_SIZE / cqe_size;
 	size_t copy_size = array_size(entries, cqe_size);
@@ -307,7 +307,7 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
 
 	if (copy_size > PAGE_SIZE) {
 		for (i = 0; i < entries / entries_per_copy; i++) {
-			err = copy_to_user((void __user *)buf, init_ents, PAGE_SIZE) ?
+			err = copy_to_user(buf, init_ents, PAGE_SIZE) ?
 				-EFAULT : 0;
 			if (err)
 				goto out;
@@ -315,8 +315,7 @@ static int mlx4_init_user_cqes(void *buf, int entries, int cqe_size)
 			buf += PAGE_SIZE;
 		}
 	} else {
-		err = copy_to_user((void __user *)buf, init_ents,
-				   copy_size) ?
+		err = copy_to_user(buf, init_ents, copy_size) ?
 			-EFAULT : 0;
 	}
 
@@ -343,7 +342,7 @@ static void mlx4_init_kernel_cqes(struct mlx4_buf *buf,
 int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,
 		  struct mlx4_mtt *mtt, struct mlx4_uar *uar, u64 db_rec,
 		  struct mlx4_cq *cq, unsigned vector, int collapsed,
-		  int timestamp_en, void *buf_addr, bool user_cq)
+		  int timestamp_en, void __user *ubuf_addr, void *kbuf_addr)
 {
 	bool sw_cq_init = dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_SW_CQ_INIT;
 	struct mlx4_priv *priv = mlx4_priv(dev);
@@ -391,13 +390,13 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent,
 	cq_context->db_rec_addr     = cpu_to_be64(db_rec);
 
 	if (sw_cq_init) {
-		if (user_cq) {
-			err = mlx4_init_user_cqes(buf_addr, nent,
+		if (ubuf_addr) {
+			err = mlx4_init_user_cqes(ubuf_addr, nent,
 						  dev->caps.cqe_size);
 			if (err)
 				sw_cq_init = false;
-		} else {
-			mlx4_init_kernel_cqes(buf_addr, nent,
+		} else if (kbuf_addr) {
+			mlx4_init_kernel_cqes(kbuf_addr, nent,
 					      dev->caps.cqe_size);
 		}
 	}
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 6646634a0b9d..dd8f3396dcba 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1126,7 +1126,7 @@ void mlx4_free_hwq_res(struct mlx4_dev *mdev, struct mlx4_hwq_resources *wqres,
 int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
 		  struct mlx4_uar *uar, u64 db_rec, struct mlx4_cq *cq,
 		  unsigned int vector, int collapsed, int timestamp_en,
-		  void *buf_addr, bool user_cq);
+		  void __user *ubuf_addr, void *kbuf_addr);
 void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq);
 int mlx4_qp_reserve_range(struct mlx4_dev *dev, int cnt, int align,
 			  int *base, u8 flags, u8 usage);
-- 
2.39.2

