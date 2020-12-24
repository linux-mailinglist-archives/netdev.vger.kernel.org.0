Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F00F92E271E
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 14:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgLXNMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 08:12:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726544AbgLXNMi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 08:12:38 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7667EC061794;
        Thu, 24 Dec 2020 05:11:58 -0800 (PST)
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1608815515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k23O2xyiw8gGd/X+qORUBIx3eM546L8uEpAKnZ3UL7s=;
        b=1RBjqIJ7osehDAyPJ88oI9YIN34wB49UR8tfVzfmmvuvk2i9uAmmEN1pZBzIZqewpPhjLL
        7RUzsErTdvajQ0PLbvQ1/vc37/LNK1MgDCzJTZ8fwxC7WjKceq4kFkou5k7ZLx8rksbW4T
        S2OQ4agyL03NNk5Hyl3DlCZrfOgEbNwTehpRQlae0T3r9jx7O8aGQaEvUsIfZH9PHp4oDE
        s9+6tXzGEVSukvpXLixCZIvxlI5Gl5fgD5cnhbKWG0YKAAzJRXOfmMAykqGmYxejp0CO1i
        y7YP5RUZDnbgkWPt5nF+QGN+3txqvBk8ogadZfig9sk5hOWABDRSRQJ97wYgeQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1608815515;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=k23O2xyiw8gGd/X+qORUBIx3eM546L8uEpAKnZ3UL7s=;
        b=xz9jTuyvkmSVelH5/sfjwfLTssNgh5ejOynV/LI+iG15kPxnDtVC7yw1YwceJKhZZBOwKl
        aYnw48qeaEiFcyDw==
To:     Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Vishal Kulkarni <vishal@chelsio.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Sebastian A. Siewior" <bigeasy@linutronix.de>,
        "Ahmed S. Darwish" <a.darwish@linutronix.de>
Subject: [RFC PATCH 1/3] chelsio: cxgb: Remove ndo_poll_controller()
Date:   Thu, 24 Dec 2020 14:11:46 +0100
Message-Id: <20201224131148.300691-2-a.darwish@linutronix.de>
In-Reply-To: <20201224131148.300691-1-a.darwish@linutronix.de>
References: <20201224131148.300691-1-a.darwish@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since commit ac3d9dd034e5 ("netpoll: make ndo_poll_controller()
optional"), networking drivers which use NAPI for clearing their TX
completions should not provide an ndo_poll_controller(). Netpoll simply
triggers the necessary TX queues cleanup by synchronously calling the
driver's NAPI poll handler -- with irqs off and a zero budget.

Modify the cxgb's poll method to clear the TX queues upon zero budget.
Per API requirements, make sure to never consume any RX packet in that
case (budget=0), and thus also not to increment the budget upon return.

Afterwards, remove ndo_poll_controller().

Link: https://lkml.kernel.org/r/20180921222752.101307-1-edumazet@google.com
Link: https://lkml.kernel.org/r/A782704A-DF97-4E85-B10A-D2268A67DFD7@fb.com
References: 822d54b9c2c1 ("netpoll: Drop budget parameter from NAPI polling call hierarchy")
Signed-off-by: Ahmed S. Darwish <a.darwish@linutronix.de>
Cc: Eric Dumazet <edumazet@google.com>
---
 drivers/net/ethernet/chelsio/cxgb/cxgb2.c | 14 --------------
 drivers/net/ethernet/chelsio/cxgb/sge.c   |  9 ++++++++-
 2 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
index 0e4a0f413960..7b5a98330ef7 100644
--- a/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
+++ b/drivers/net/ethernet/chelsio/cxgb/cxgb2.c
@@ -878,17 +878,6 @@ static int t1_set_features(struct net_device *dev, netdev_features_t features)
 
 	return 0;
 }
-#ifdef CONFIG_NET_POLL_CONTROLLER
-static void t1_netpoll(struct net_device *dev)
-{
-	unsigned long flags;
-	struct adapter *adapter = dev->ml_priv;
-
-	local_irq_save(flags);
-	t1_interrupt(adapter->pdev->irq, adapter);
-	local_irq_restore(flags);
-}
-#endif
 
 /*
  * Periodic accumulation of MAC statistics.  This is used only if the MAC
@@ -973,9 +962,6 @@ static const struct net_device_ops cxgb_netdev_ops = {
 	.ndo_set_mac_address	= t1_set_mac_addr,
 	.ndo_fix_features	= t1_fix_features,
 	.ndo_set_features	= t1_set_features,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= t1_netpoll,
-#endif
 };
 
 static int init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
diff --git a/drivers/net/ethernet/chelsio/cxgb/sge.c b/drivers/net/ethernet/chelsio/cxgb/sge.c
index 2d9c2b5a690a..d6df1a87db0b 100644
--- a/drivers/net/ethernet/chelsio/cxgb/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb/sge.c
@@ -1609,7 +1609,14 @@ static int process_pure_responses(struct adapter *adapter)
 int t1_poll(struct napi_struct *napi, int budget)
 {
 	struct adapter *adapter = container_of(napi, struct adapter, napi);
-	int work_done = process_responses(adapter, budget);
+	int work_done = 0;
+
+	if (budget)
+		work_done = process_responses(adapter, budget);
+	else {
+		/* budget=0 means: don't poll rx data */
+		process_pure_responses(adapter);
+	}
 
 	if (likely(work_done < budget)) {
 		napi_complete_done(napi, work_done);
-- 
2.29.2

