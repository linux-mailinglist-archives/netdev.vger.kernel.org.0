Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13741F64D6
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729654AbfKJDCl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 22:02:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:57790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727316AbfKJCtJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:49:09 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D794122593;
        Sun, 10 Nov 2019 02:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573354148;
        bh=uNuL2SlXQPCd2xQq6qydXDinsZiQ5RcmM24s08p/bDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZPh4riEbq5mBMDe2+Ff0hyub5hQCxUNmXjU9nI7uRh8BpQXpOUI+9DCZF9lxRG/a9
         S8ubYSh76zU3eQt/aHDru69DMo/+kdqn0o4lDdRVzPcCaBugSzeaSZ7YaVqjj/Wwz1
         QHIJy7MnILlgGkCOw4W4+UD+h7XWkNyUL4YLXSpk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 12/66] net: xilinx: fix return type of ndo_start_xmit function
Date:   Sat,  9 Nov 2019 21:47:51 -0500
Message-Id: <20191110024846.32598-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024846.32598-1-sashal@kernel.org>
References: <20191110024846.32598-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 81255af8d9d5565004792c295dde49344df450ca ]

The method ndo_start_xmit() is defined as returning an 'netdev_tx_t',
which is a typedef for an enum type, so make sure the implementation in
this driver has returns 'netdev_tx_t' value, and change the function
return type to netdev_tx_t.

Found by coccinelle.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c       | 3 ++-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 3 ++-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c     | 9 +++++----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index a9bd665fd1225..545f60877bb7d 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -673,7 +673,8 @@ static inline int temac_check_tx_bd_space(struct temac_local *lp, int num_frag)
 	return 0;
 }
 
-static int temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t
+temac_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	struct temac_local *lp = netdev_priv(ndev);
 	struct cdmac_bd *cur_p;
diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 5f21ddff9e0f9..46fcf3ec2caf7 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -655,7 +655,8 @@ static inline int axienet_check_tx_bd_space(struct axienet_local *lp,
  * start the transmission. Additionally if checksum offloading is supported,
  * it populates AXI Stream Control fields with appropriate values.
  */
-static int axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
+static netdev_tx_t
+axienet_start_xmit(struct sk_buff *skb, struct net_device *ndev)
 {
 	u32 ii;
 	u32 num_frag;
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index aa02a03a6d8db..034b36442ee75 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1005,9 +1005,10 @@ static int xemaclite_close(struct net_device *dev)
  * deferred and the Tx queue is stopped so that the deferred socket buffer can
  * be transmitted when the Emaclite device is free to transmit data.
  *
- * Return:	0, always.
+ * Return:	NETDEV_TX_OK, always.
  */
-static int xemaclite_send(struct sk_buff *orig_skb, struct net_device *dev)
+static netdev_tx_t
+xemaclite_send(struct sk_buff *orig_skb, struct net_device *dev)
 {
 	struct net_local *lp = netdev_priv(dev);
 	struct sk_buff *new_skb;
@@ -1028,7 +1029,7 @@ static int xemaclite_send(struct sk_buff *orig_skb, struct net_device *dev)
 		/* Take the time stamp now, since we can't do this in an ISR. */
 		skb_tx_timestamp(new_skb);
 		spin_unlock_irqrestore(&lp->reset_lock, flags);
-		return 0;
+		return NETDEV_TX_OK;
 	}
 	spin_unlock_irqrestore(&lp->reset_lock, flags);
 
@@ -1037,7 +1038,7 @@ static int xemaclite_send(struct sk_buff *orig_skb, struct net_device *dev)
 	dev->stats.tx_bytes += len;
 	dev_consume_skb_any(new_skb);
 
-	return 0;
+	return NETDEV_TX_OK;
 }
 
 /**
-- 
2.20.1

