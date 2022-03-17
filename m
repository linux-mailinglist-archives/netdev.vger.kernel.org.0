Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F6E4DCA32
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 16:41:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235285AbiCQPk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 11:40:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236015AbiCQPk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 11:40:57 -0400
Received: from unicorn.mansr.com (unicorn.mansr.com [IPv6:2001:8b0:ca0d:8d8e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D508220C2E0;
        Thu, 17 Mar 2022 08:39:38 -0700 (PDT)
Received: from raven.mansr.com (raven.mansr.com [81.2.72.235])
        by unicorn.mansr.com (Postfix) with ESMTPS id EF05B15360;
        Thu, 17 Mar 2022 15:39:35 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 86495210BC8; Thu, 17 Mar 2022 15:39:35 +0000 (GMT)
From:   Mans Rullgard <mans@mansr.com>
To:     Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vitaly Bordug <vbordug@ru.mvista.com>,
        Dan Malek <dan@embeddededge.com>,
        Joakim Tjernlund <joakim.tjernlund@lumentis.se>,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC][PATCH] net: fs_enet: fix tx error handling
Date:   Thu, 17 Mar 2022 15:38:58 +0000
Message-Id: <20220317153858.20719-1-mans@mansr.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In some cases, the TXE flag is apparently set without any error
indication in the buffer descriptor status. When this happens, tx
stalls until the tx_restart() function is called via the device
watchdog which can take a long time.

To fix this, check for TXE in the napi poll function and trigger a
tx_restart() call as for errors reported in the buffer descriptor.

This change makes the FCC based Ethernet controller on MPC82xx devices
usable. It probably breaks the other modes (FEC, SCC) which I have no
way of testing.

Signed-off-by: Mans Rullgard <mans@mansr.com>
---
 .../ethernet/freescale/fs_enet/fs_enet-main.c | 47 +++++++------------
 .../net/ethernet/freescale/fs_enet/mac-fcc.c  |  2 +-
 2 files changed, 19 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
index 78e008b81374..4276becd07cf 100644
--- a/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
+++ b/drivers/net/ethernet/freescale/fs_enet/fs_enet-main.c
@@ -94,14 +94,22 @@ static int fs_enet_napi(struct napi_struct *napi, int budget)
 	int curidx;
 	int dirtyidx, do_wake, do_restart;
 	int tx_left = TX_RING_SIZE;
+	u32 int_events;
 
 	spin_lock(&fep->tx_lock);
 	bdp = fep->dirty_tx;
+	do_wake = do_restart = 0;
+
+	int_events = (*fep->ops->get_int_events)(dev);
+
+	if (int_events & fep->ev_err) {
+		(*fep->ops->ev_error)(dev, int_events);
+		do_restart = 1;
+	}
 
 	/* clear status bits for napi*/
 	(*fep->ops->napi_clear_event)(dev);
 
-	do_wake = do_restart = 0;
 	while (((sc = CBDR_SC(bdp)) & BD_ENET_TX_READY) == 0 && tx_left) {
 		dirtyidx = bdp - fep->tx_bd_base;
 
@@ -318,43 +326,24 @@ fs_enet_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = dev_id;
 	struct fs_enet_private *fep;
-	const struct fs_platform_info *fpi;
 	u32 int_events;
-	u32 int_clr_events;
-	int nr, napi_ok;
-	int handled;
 
 	fep = netdev_priv(dev);
-	fpi = fep->fpi;
 
-	nr = 0;
-	while ((int_events = (*fep->ops->get_int_events)(dev)) != 0) {
-		nr++;
+	int_events = (*fep->ops->get_int_events)(dev);
+	if (!int_events)
+		return IRQ_NONE;
 
-		int_clr_events = int_events;
-		int_clr_events &= ~fep->ev_napi;
+	int_events &= ~fep->ev_napi;
 
-		(*fep->ops->clear_int_events)(dev, int_clr_events);
-
-		if (int_events & fep->ev_err)
-			(*fep->ops->ev_error)(dev, int_events);
-
-		if (int_events & fep->ev) {
-			napi_ok = napi_schedule_prep(&fep->napi);
-
-			(*fep->ops->napi_disable)(dev);
-			(*fep->ops->clear_int_events)(dev, fep->ev_napi);
-
-			/* NOTE: it is possible for FCCs in NAPI mode    */
-			/* to submit a spurious interrupt while in poll  */
-			if (napi_ok)
-				__napi_schedule(&fep->napi);
-		}
+	(*fep->ops->clear_int_events)(dev, int_events);
 
+	if (napi_schedule_prep(&fep->napi)) {
+		(*fep->ops->napi_disable)(dev);
+		__napi_schedule(&fep->napi);
 	}
 
-	handled = nr > 0;
-	return IRQ_RETVAL(handled);
+	return IRQ_HANDLED;
 }
 
 void fs_init_bds(struct net_device *dev)
diff --git a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
index b47490be872c..66c8f82a8333 100644
--- a/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
+++ b/drivers/net/ethernet/freescale/fs_enet/mac-fcc.c
@@ -124,7 +124,7 @@ static int do_pd_setup(struct fs_enet_private *fep)
 	return ret;
 }
 
-#define FCC_NAPI_EVENT_MSK	(FCC_ENET_RXF | FCC_ENET_RXB | FCC_ENET_TXB)
+#define FCC_NAPI_EVENT_MSK	(FCC_ENET_RXF | FCC_ENET_RXB | FCC_ENET_TXB | FCC_ENET_TXE)
 #define FCC_EVENT		(FCC_ENET_RXF | FCC_ENET_TXB)
 #define FCC_ERR_EVENT_MSK	(FCC_ENET_TXE)
 
-- 
2.35.1

