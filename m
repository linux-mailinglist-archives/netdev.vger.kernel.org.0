Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE0D3956F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 21:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbfFGTVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 15:21:06 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:51135 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729959AbfFGTVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 15:21:03 -0400
Received: from localhost ([127.0.0.1] helo=flow.W.breakpoint.cc)
        by Galois.linutronix.de with esmtp (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1hZKQ7-0004YF-9C; Fri, 07 Jun 2019 21:20:59 +0200
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     tglx@linutronix.de, "David S. Miller" <davem@davemloft.net>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Ioana Radulescu <ruxandra.radulescu@nxp.com>
Subject: [PATCH v2 net-next 3/7] dpaa2-eth: Remove preempt_disable() from seed_pool()
Date:   Fri,  7 Jun 2019 21:20:36 +0200
Message-Id: <20190607192040.19367-4-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190607192040.19367-1-bigeasy@linutronix.de>
References: <20190607192040.19367-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

According to the comment, the preempt_disable() statement is required
due to synchronisation in napi_alloc_frag(). The awful truth is that
local_bh_disable() is required because otherwise the NAPI poll callback
can be invoked while the open function setup buffers. This isn't
unlikely since the dpaa2 provides multiple devices.

The usage of napi_alloc_frag() has been removed in commit

 27c874867c4e9 ("dpaa2-eth: Use a single page per Rx buffer")

which means that the comment is not accurate and the preempt_disable()
statement is not required.

Remove the outdated comment and the no longer required
preempt_disable().

Cc: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Acked-by: Ioana Radulescu <ruxandra.radulescu@nxp.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 7d2390e3df772..bcd3ceb5f9dc4 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -997,13 +997,6 @@ static int seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
 	int i, j;
 	int new_count;
 
-	/* This is the lazy seeding of Rx buffer pools.
-	 * dpaa2_add_bufs() is also used on the Rx hotpath and calls
-	 * napi_alloc_frag(). The trouble with that is that it in turn ends up
-	 * calling this_cpu_ptr(), which mandates execution in atomic context.
-	 * Rather than splitting up the code, do a one-off preempt disable.
-	 */
-	preempt_disable();
 	for (j = 0; j < priv->num_channels; j++) {
 		for (i = 0; i < DPAA2_ETH_NUM_BUFS;
 		     i += DPAA2_ETH_BUFS_PER_CMD) {
@@ -1011,12 +1004,10 @@ static int seed_pool(struct dpaa2_eth_priv *priv, u16 bpid)
 			priv->channel[j]->buf_count += new_count;
 
 			if (new_count < DPAA2_ETH_BUFS_PER_CMD) {
-				preempt_enable();
 				return -ENOMEM;
 			}
 		}
 	}
-	preempt_enable();
 
 	return 0;
 }
-- 
2.20.1

