Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EE996DCF60
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 03:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjDKBdf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 21:33:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjDKBdb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 21:33:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DC2C1998;
        Mon, 10 Apr 2023 18:33:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE2B061B9D;
        Tue, 11 Apr 2023 01:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05C2BC433A0;
        Tue, 11 Apr 2023 01:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681176810;
        bh=qyYYe0U+XDabKpjRQczTgchSHPkbw8rhPG+FrdjLUUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZBPTaqyf3QZz6Q5kiD4mSaBAA1QfcSFWtdyglc6R7IWrTSq4mn7tPFEp+ZNhIkm1e
         /hDryR08v5fZRUKVxYNMpP9ZkzPoK1QtwsTu28secX7grFtraRL7rgc5ffsVHEv9iu
         lm4K9g1sX6RWOlhb6XpGmeLum+PQutzYT/CmJ8vlT6sbKlS8htluEX/qy1F5eBzIz6
         ZQZeWPqUoHQy7JzFwXbFpJs7M3EHV+Ys1I1ZCPtL/m2RPkiMSuBzy7R8cf+D/pk7zK
         yuGAZdl5jNteU/bZ8H8edAR3QcWaDYf4DlcXKkc4YN0UgX97/k1AE0WLDurWr6EomF
         KudRXd8aAOQrA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, tariqt@nvidia.com,
        linux-rdma@vger.kernel.org
Subject: [PATCH net-next 3/3] mlx4: use READ_ONCE/WRITE_ONCE for ring indexes
Date:   Mon, 10 Apr 2023 18:33:23 -0700
Message-Id: <20230411013323.513688-4-kuba@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411013323.513688-1-kuba@kernel.org>
References: <20230411013323.513688-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric points out that we should make sure that ring index updates
are wrapped in the appropriate READ_ONCE/WRITE_ONCE macros.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: tariqt@nvidia.com
CC: linux-rdma@vger.kernel.org
---
 drivers/net/ethernet/mellanox/mlx4/en_tx.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index 2f79378fbf6e..65cb63f6c465 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -228,7 +228,9 @@ void mlx4_en_deactivate_tx_ring(struct mlx4_en_priv *priv,
 
 static inline bool mlx4_en_is_tx_ring_full(struct mlx4_en_tx_ring *ring)
 {
-	return ring->prod - ring->cons > ring->full_size;
+	u32 used = READ_ONCE(ring->prod) - READ_ONCE(ring->cons);
+
+	return used > ring->full_size;
 }
 
 static void mlx4_en_stamp_wqe(struct mlx4_en_priv *priv,
@@ -1083,7 +1085,7 @@ netdev_tx_t mlx4_en_xmit(struct sk_buff *skb, struct net_device *dev)
 			op_own |= cpu_to_be32(MLX4_WQE_CTRL_IIP);
 	}
 
-	ring->prod += nr_txbb;
+	WRITE_ONCE(ring->prod, ring->prod + nr_txbb);
 
 	/* If we used a bounce buffer then copy descriptor back into place */
 	if (unlikely(bounce))
@@ -1214,7 +1216,7 @@ netdev_tx_t mlx4_en_xmit_frame(struct mlx4_en_rx_ring *rx_ring,
 
 	rx_ring->xdp_tx++;
 
-	ring->prod += MLX4_EN_XDP_TX_NRTXBB;
+	WRITE_ONCE(ring->prod, ring->prod + MLX4_EN_XDP_TX_NRTXBB);
 
 	/* Ensure new descriptor hits memory
 	 * before setting ownership of this descriptor to HW
-- 
2.39.2

