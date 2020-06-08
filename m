Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B08271F2892
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 01:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732707AbgFHXyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 19:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387503AbgFHXYS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:24:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FE9620C56;
        Mon,  8 Jun 2020 23:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658658;
        bh=nXchnZb0VQVMifgHuWErdeP223POR9zgseAnk9BTKs8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D2U7mW06FVe6UmYNcnx9rEndibkhVc+CC+c8l07TvjEBMtFyUpCURunBYYVT5f8Ox
         AXYuWf6BZAj7+LlDqbd1ekBYW1AKh4VYcEL70Vk/xyoxfdHEl0F0fn9ii5nOPLiRjl
         IL8ePWBQVgkmqiyX2vjlBuzMevMImtagYQSvPzhc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Erez Shitrit <erezsh@mellanox.com>,
        Alex Vesker <valex@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 075/106] net/mlx5e: IPoIB, Drop multicast packets that this interface sent
Date:   Mon,  8 Jun 2020 19:22:07 -0400
Message-Id: <20200608232238.3368589-75-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608232238.3368589-1-sashal@kernel.org>
References: <20200608232238.3368589-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Erez Shitrit <erezsh@mellanox.com>

[ Upstream commit 8b46d424a743ddfef8056d5167f13ee7ebd1dcad ]

After enabled loopback packets for IPoIB, we need to drop these packets
that this HCA has replicated and came back to the same interface that
sent them.

Fixes: 4c6c615e3f30 ("net/mlx5e: IPoIB, Add PKEY child interface nic profile")
Signed-off-by: Erez Shitrit <erezsh@mellanox.com>
Reviewed-by: Alex Vesker <valex@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 044687a1f27c..9d86e49a7f44 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -1314,6 +1314,7 @@ int mlx5e_poll_rx_cq(struct mlx5e_cq *cq, int budget)
 
 #ifdef CONFIG_MLX5_CORE_IPOIB
 
+#define MLX5_IB_GRH_SGID_OFFSET 8
 #define MLX5_IB_GRH_DGID_OFFSET 24
 #define MLX5_GID_SIZE           16
 
@@ -1327,6 +1328,7 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	struct net_device *netdev;
 	struct mlx5e_priv *priv;
 	char *pseudo_header;
+	u32 flags_rqpn;
 	u32 qpn;
 	u8 *dgid;
 	u8 g;
@@ -1347,7 +1349,8 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	priv = mlx5i_epriv(netdev);
 	tstamp = &priv->tstamp;
 
-	g = (be32_to_cpu(cqe->flags_rqpn) >> 28) & 3;
+	flags_rqpn = be32_to_cpu(cqe->flags_rqpn);
+	g = (flags_rqpn >> 28) & 3;
 	dgid = skb->data + MLX5_IB_GRH_DGID_OFFSET;
 	if ((!g) || dgid[0] != 0xff)
 		skb->pkt_type = PACKET_HOST;
@@ -1356,9 +1359,15 @@ static inline void mlx5i_complete_rx_cqe(struct mlx5e_rq *rq,
 	else
 		skb->pkt_type = PACKET_MULTICAST;
 
-	/* TODO: IB/ipoib: Allow mcast packets from other VFs
-	 * 68996a6e760e5c74654723eeb57bf65628ae87f4
+	/* Drop packets that this interface sent, ie multicast packets
+	 * that the HCA has replicated.
 	 */
+	if (g && (qpn == (flags_rqpn & 0xffffff)) &&
+	    (memcmp(netdev->dev_addr + 4, skb->data + MLX5_IB_GRH_SGID_OFFSET,
+		    MLX5_GID_SIZE) == 0)) {
+		skb->dev = NULL;
+		return;
+	}
 
 	skb_pull(skb, MLX5_IB_GRH_BYTES);
 
-- 
2.25.1

