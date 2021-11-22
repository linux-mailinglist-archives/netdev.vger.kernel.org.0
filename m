Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E155F4595EF
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 21:08:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240132AbhKVULr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 15:11:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239844AbhKVULq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Nov 2021 15:11:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51D0160FD7;
        Mon, 22 Nov 2021 20:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637611718;
        bh=X9+1OE+aBg+G++q7U65uPko1RNMJsOQH9NxsPxCg1Q4=;
        h=From:To:Cc:Subject:Date:From;
        b=htRJ1t+OFq82yqDwfyuRyVqStV80HHDZ7cBqwH0B/P7iiz1uMikJZ0EBbCrjS5/+M
         bng84rJgNGfOQ9cris0+YGpXs6kDB69SeEq/zoZIOb6SddTI3WgG4V5pcdidenSOVO
         uX2jTL9ph2b4Avs5GVGnZzL1HlF0zQGEjUuWH8bGHqoheXQgk7AqlQsjUqADz4+l8T
         b2Iw+OUKpd9ysxmyGQnlF5KeN7IpskGrEZbnzh5WcZB1Up6XbPOe9cE9/82/mlwM/E
         V4y3zZEqXoHQ1oZDbm7tTg6qkLdKAPmcx0QN5ioBbLVrm0eeA9lfhIYKxHZD4R5KRV
         Z2tMLn0hb+3HA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Sven Auhagen <sven.auhagen@voleatech.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        davem@davemloft.net,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH net] net: marvell: mvpp2: increase MTU limit when XDP enabled
Date:   Mon, 22 Nov 2021 21:08:34 +0100
Message-Id: <20211122200834.29219-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently mvpp2_xdp_setup won't allow attaching XDP program if
  mtu > ETH_DATA_LEN (1500).

The mvpp2_change_mtu on the other hand checks whether
  MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE.

These two checks are semantically different.

Moreover this limit can be increased to MVPP2_MAX_RX_BUF_SIZE, since in
mvpp2_rx we have
  xdp.data = data + MVPP2_MH_SIZE + MVPP2_SKB_HEADROOM;
  xdp.frame_sz = PAGE_SIZE;

Change the checks to check whether
  mtu > MVPP2_MAX_RX_BUF_SIZE

Fixes: 07dd0a7aae7f ("mvpp2: add basic XDP support")
Signed-off-by: Marek Behún <kabel@kernel.org>
---
The NL_SET_ERR_MSG_MOD() is not a printf-like function, the message
must be a string literal. The last time Andrew Lunn asked if I could
use some CPP magic to make it print the MVPP2_MAX_RX_BUF_SIZE, since
it is a constant.

I don't think this is possible, so we won't be printing the maximum
possible value when failing to enable XDP due to MTU is too large.

But I changed the patch so that it now prints the maximum possible value
in the MTU change function when XDP is already enabled.

I also added Fixes tag.
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 49fc31fe0db8..a3aefdf0784e 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5017,11 +5017,13 @@ static int mvpp2_change_mtu(struct net_device *dev, int mtu)
 		mtu = ALIGN(MVPP2_RX_PKT_SIZE(mtu), 8);
 	}
 
+	if (port->xdp_prog && mtu > MVPP2_MAX_RX_BUF_SIZE) {
+		netdev_err(dev, "Illegal MTU value %d (> %d) for XDP mode\n",
+			   mtu, (int)MVPP2_MAX_RX_BUF_SIZE);
+		return -EINVAL;
+	}
+
 	if (MVPP2_RX_PKT_SIZE(mtu) > MVPP2_BM_LONG_PKT_SIZE) {
-		if (port->xdp_prog) {
-			netdev_err(dev, "Jumbo frames are not supported with XDP\n");
-			return -EINVAL;
-		}
 		if (priv->percpu_pools) {
 			netdev_warn(dev, "mtu %d too high, switching to shared buffers", mtu);
 			mvpp2_bm_switch_buffers(priv, false);
@@ -5307,8 +5309,8 @@ static int mvpp2_xdp_setup(struct mvpp2_port *port, struct netdev_bpf *bpf)
 	bool running = netif_running(port->dev);
 	bool reset = !prog != !port->xdp_prog;
 
-	if (port->dev->mtu > ETH_DATA_LEN) {
-		NL_SET_ERR_MSG_MOD(bpf->extack, "XDP is not supported with jumbo frames enabled");
+	if (port->dev->mtu > MVPP2_MAX_RX_BUF_SIZE) {
+		NL_SET_ERR_MSG_MOD(bpf->extack, "MTU too large for XDP");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.32.0

