Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8F4F6E2C4C
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbjDNWJ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbjDNWJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:09:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F713C3B
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:09:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5D7764A8A
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:09:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5F0C433D2;
        Fri, 14 Apr 2023 22:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681510187;
        bh=nSwoMDzRQ4cEup6S/IpnwxvNeUxe4ix6wYll6WKcT3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KNa+z2llmDcL5mAIfhMeH4aU4uKrGFnDB0mFrmRi2jxbJcqNQzzqwJRbQqNpqAzCQ
         hH5VQEp19B7B72I3pc3mUop60PtGrDGciPhcK9JmaHeoCAQI5i2F1InI2c+xqpiB7K
         sTir/6ijc80jIKtuflk3gtNzC6e35Vv83RYpNXO8A8D5tyIz6o5fVWEV5xl9CK7kH6
         bMh5EdEZlCscsxYfdAFewhimfROTjaaAaOHDozery6Mn1IHBp4vGUJZSeeN0EoMuG8
         FAmfmlNHWBIVNCA1eV77n3cCBoOwFy/W8rIs0aZF5eCLWB3Pw8H0t0l+L8foEicVrL
         mZMjQ5HL1B/BQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>,
        Erez Shitrit <erezsh@nvidia.com>,
        Alex Vesker <valex@nvidia.com>
Subject: [net-next 07/15] net/mlx5: DR, Read ICM memory into dedicated buffer
Date:   Fri, 14 Apr 2023 15:09:31 -0700
Message-Id: <20230414220939.136865-8-saeed@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230414220939.136865-1-saeed@kernel.org>
References: <20230414220939.136865-1-saeed@kernel.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

Instead of using the write buffer for reading we will use a dedicated
buffer only for reading ICM memory.
Due to the new support for args, we can have a case with pending_wc
being odd number, and with reading into the same write buffer, it is
possible to overwrite next write on the same slot.
For example:
pending_wc is 17 so the buffer for write is:
   | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 |
and we have requests as follows:
   r wr wr wr wr wr wr wr wr
Now, the first read will be written into the last write because we use
the same buffer for read and write, before it was written to the HW and
we will have a wrong data in the ICM area.

Signed-off-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../mellanox/mlx5/core/steering/dr_send.c     | 21 ++++++++++++++-----
 .../mellanox/mlx5/core/steering/dr_types.h    |  5 +----
 2 files changed, 17 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
index d7c7363f9096..d052d469d4df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c
@@ -602,9 +602,10 @@ static void dr_fill_write_icm_segs(struct mlx5dr_domain *dmn,
 
 	send_ring->pending_wqe++;
 	send_info->read.length = send_info->write.length;
-	/* Read into the same write area */
-	send_info->read.addr = (uintptr_t)send_info->write.addr;
-	send_info->read.lkey = send_ring->mr->mkey;
+
+	/* Read into dedicated sync buffer */
+	send_info->read.addr = (uintptr_t)send_ring->sync_mr->dma_addr;
+	send_info->read.lkey = send_ring->sync_mr->mkey;
 
 	if (send_ring->pending_wqe % send_ring->signal_th == 0)
 		send_info->read.send_flags = IB_SEND_SIGNALED;
@@ -1288,16 +1289,25 @@ int mlx5dr_send_ring_alloc(struct mlx5dr_domain *dmn)
 		goto free_mem;
 	}
 
+	dmn->send_ring->sync_buff = kzalloc(dmn->send_ring->max_post_send_size,
+					    GFP_KERNEL);
+	if (!dmn->send_ring->sync_buff) {
+		ret = -ENOMEM;
+		goto clean_mr;
+	}
+
 	dmn->send_ring->sync_mr = dr_reg_mr(dmn->mdev,
 					    dmn->pdn, dmn->send_ring->sync_buff,
-					    MIN_READ_SYNC);
+					    dmn->send_ring->max_post_send_size);
 	if (!dmn->send_ring->sync_mr) {
 		ret = -ENOMEM;
-		goto clean_mr;
+		goto free_sync_mem;
 	}
 
 	return 0;
 
+free_sync_mem:
+	kfree(dmn->send_ring->sync_buff);
 clean_mr:
 	dr_dereg_mr(dmn->mdev, dmn->send_ring->mr);
 free_mem:
@@ -1320,6 +1330,7 @@ void mlx5dr_send_ring_free(struct mlx5dr_domain *dmn,
 	dr_dereg_mr(dmn->mdev, send_ring->sync_mr);
 	dr_dereg_mr(dmn->mdev, send_ring->mr);
 	kfree(send_ring->buf);
+	kfree(send_ring->sync_buff);
 	kfree(send_ring);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
index 7b35f78a84a2..81d7ac6d6258 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_types.h
@@ -1429,9 +1429,6 @@ struct mlx5dr_mr {
 	size_t size;
 };
 
-#define MAX_SEND_CQE		64
-#define MIN_READ_SYNC		64
-
 struct mlx5dr_send_ring {
 	struct mlx5dr_cq *cq;
 	struct mlx5dr_qp *qp;
@@ -1446,7 +1443,7 @@ struct mlx5dr_send_ring {
 	u32 tx_head;
 	void *buf;
 	u32 buf_size;
-	u8 sync_buff[MIN_READ_SYNC];
+	u8 *sync_buff;
 	struct mlx5dr_mr *sync_mr;
 	spinlock_t lock; /* Protect the data path of the send ring */
 	bool err_state; /* send_ring is not usable in err state */
-- 
2.39.2

