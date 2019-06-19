Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7B674B242
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 08:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730418AbfFSGlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 02:41:37 -0400
Received: from mga14.intel.com ([192.55.52.115]:57632 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725892AbfFSGlh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 02:41:37 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Jun 2019 23:41:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="150518994"
Received: from wvoon-ilbpg2.png.intel.com ([10.88.227.88])
  by orsmga007.jf.intel.com with ESMTP; 18 Jun 2019 23:41:33 -0700
From:   Voon Weifeng <weifeng.voon@intel.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jose Abreu <joabreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>
Subject: [net v1] net: stmmac: set IC bit when transmitting frames with HW timestamp
Date:   Wed, 19 Jun 2019 22:41:48 +0800
Message-Id: <1560955308-15190-1-git-send-email-weifeng.voon@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roland Hii <roland.king.guan.hii@intel.com>

When transmitting certain PTP frames, e.g. SYNC and DELAY_REQ, the
PTP daemon, e.g. ptp4l, is polling the driver for the frame transmit
hardware timestamp. The polling will most likely timeout if the tx
coalesce is enabled due to the Interrupt-on-Completion (IC) bit is
not set in tx descriptor for those frames.

This patch will ignore the tx coalesce parameter and set the IC bit
when transmitting PTP frames which need to report out the frame
transmit hardware timestamp to user space.

Fixes: f748be531d70 ("net: stmmac: Rework coalesce timer and fix multi-queue races")
Signed-off-by: Roland Hii <roland.king.guan.hii@intel.com>
Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Voon Weifeng <weifeng.voon@intel.com>

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 06dd51f47cfd..06358fe5b245 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2947,12 +2947,15 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* Manage tx mitigation */
 	tx_q->tx_count_frames += nfrags + 1;
-	if (priv->tx_coal_frames <= tx_q->tx_count_frames) {
+	if (likely(priv->tx_coal_frames > tx_q->tx_count_frames) &&
+	    !(priv->synopsys_id >= DWMAC_CORE_4_00 &&
+	    (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    priv->hwts_tx_en)) {
+		stmmac_tx_timer_arm(priv, queue);
+	} else {
+		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, desc);
 		priv->xstats.tx_set_ic_bit++;
-		tx_q->tx_count_frames = 0;
-	} else {
-		stmmac_tx_timer_arm(priv, queue);
 	}
 
 	skb_tx_timestamp(skb);
@@ -3166,12 +3169,15 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * element in case of no SG.
 	 */
 	tx_q->tx_count_frames += nfrags + 1;
-	if (priv->tx_coal_frames <= tx_q->tx_count_frames) {
+	if (likely(priv->tx_coal_frames > tx_q->tx_count_frames) &&
+	    !(priv->synopsys_id >= DWMAC_CORE_4_00 &&
+	    (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
+	    priv->hwts_tx_en)) {
+		stmmac_tx_timer_arm(priv, queue);
+	} else {
+		tx_q->tx_count_frames = 0;
 		stmmac_set_tx_ic(priv, desc);
 		priv->xstats.tx_set_ic_bit++;
-		tx_q->tx_count_frames = 0;
-	} else {
-		stmmac_tx_timer_arm(priv, queue);
 	}
 
 	skb_tx_timestamp(skb);
-- 
1.9.1

