Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5455C5DBBC
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 04:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbfGCCRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 22:17:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:55078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727309AbfGCCQm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 22:16:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 232D52189F;
        Wed,  3 Jul 2019 02:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562120202;
        bh=giDXluMr/f+PyEt9s7AQYNZMVzDufPbq38SXiAfoHCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ogzHmPBETNOfxAQb+Y1WfkJoRzVy3YXH90MtviArLcYadyhsgbrbj2YMXXOJHtw8q
         jNq39grrc4emuF8YaRffZdvVA+vGI8UN2jkZWPWfd9slbYoSWp8UW5ilA4/wXfHbAr
         oIbXp16sn8B+lpAMqFvcLKijfhtIU88/ijwjrNPo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Roland Hii <roland.king.guan.hii@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 12/26] net: stmmac: set IC bit when transmitting frames with HW timestamp
Date:   Tue,  2 Jul 2019 22:16:11 -0400
Message-Id: <20190703021625.18116-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190703021625.18116-1-sashal@kernel.org>
References: <20190703021625.18116-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roland Hii <roland.king.guan.hii@intel.com>

[ Upstream commit d0bb82fd60183868f46c8ccc595a3d61c3334a18 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22 ++++++++++++-------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 45e64d71a93f..5c18874614ba 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2938,12 +2938,15 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 
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
@@ -3157,12 +3160,15 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
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
2.20.1

