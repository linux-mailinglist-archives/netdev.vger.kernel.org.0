Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29E91450827
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 16:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbhKOPYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 10:24:38 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45346 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhKOPY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 10:24:28 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1636989683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=W7KifqYbgb8KexlQGzikqzjTBc2YySQxnBFseAKaY/s=;
        b=OjEOBRuTr77QGW3+oBpoPEsI7hOIB81bFUTXRTOpSkTFovWqTw+68rTFzmhXFgLpBt7dkQ
        l1J3Qv+AhgcDmjynUEW7TxnK/Lg3fS7m1iJ5iNj1LijlKoP+KMazSGGErP/JaxcGcgicQ+
        bLjpI0wYpuwAvF/giUdbZKeSfPoGn1GV1RMdHXwR+7TMjDiHS4tahL2lqsaLGVul9Biv1D
        NAz2xdo+/O6G8zE3N7Wva9qoAqBWvXDwyorl+yDs+dacb6zPZFTbgdZ2CwYYkpEhkbJ+bN
        8HnWghF4LmpUoq9R3qPqlPDVezLGAq3z0sUWT+EOvzUjEQp2eWO6oEgryi8PDg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1636989683;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=W7KifqYbgb8KexlQGzikqzjTBc2YySQxnBFseAKaY/s=;
        b=1fcd75s7XqKdqDd+9lAQwuUg5yRjXbd7qz27Ws/b7NilNBumpKCFkrSxM1jihXcvf+rUD9
        nrq6mGicF+/x6fBA==
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: [PATCH] net: stmmac: Fix signed/unsigned wreckage
Date:   Mon, 15 Nov 2021 16:21:23 +0100
Message-ID: <87mtm578cs.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The recent addition of timestamp correction to compensate the CDC error
introduced a subtle signed/unsigned bug in stmmac_get_tx_hwtstamp() while
it managed for some obscure reason to avoid that in stmmac_get_rx_hwtstamp().

The issue is:

    s64 adjust = 0;
    u64 ns;

    adjust += -(2 * (NSEC_PER_SEC / priv->plat->clk_ptp_rate));
    ns += adjust;

works by chance on 64bit, but falls apart on 32bit because the compiler
knows that adjust fits into 32bit and then treats the addition as a u64 +
u32 resulting in an off by ~2 seconds failure.

The RX variant uses an u64 for adjust and does the adjustment via

    ns -= adjust;

because consistency is obviously overrated.

Get rid of the pointless zero initialized adjust variable and do:

	ns -= (2 * NSEC_PER_SEC) / priv->plat->clk_ptp_rate;

which is obviously correct and spares the adjust obfuscation. Aside of that
it yields a more accurate result because the multiplication takes place
before the integer divide truncation and not afterwards.

Stick the calculation into an inline so it can't be accidentaly
disimproved. Return an u32 from that inline as the result is guaranteed
to fit which lets the compiler optimize the substraction.

Fixes: 3600be5f58c1 ("net: stmmac: add timestamp correction to rid CDC sync error")
Reported-by: Benedikt Spranger <b.spranger@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Benedikt Spranger <b.spranger@linutronix.de>
Cc: stable@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |   23 +++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -511,6 +511,14 @@ bool stmmac_eee_init(struct stmmac_priv
 	return true;
 }
 
+static inline u32 stmmac_cdc_adjust(struct stmmac_priv *priv)
+{
+	/* Correct the clk domain crossing(CDC) error */
+	if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate)
+		return (2 * NSEC_PER_SEC) / priv->plat->clk_ptp_rate;
+	return 0;
+}
+
 /* stmmac_get_tx_hwtstamp - get HW TX timestamps
  * @priv: driver private structure
  * @p : descriptor pointer
@@ -524,7 +532,6 @@ static void stmmac_get_tx_hwtstamp(struc
 {
 	struct skb_shared_hwtstamps shhwtstamp;
 	bool found = false;
-	s64 adjust = 0;
 	u64 ns = 0;
 
 	if (!priv->hwts_tx_en)
@@ -543,12 +550,7 @@ static void stmmac_get_tx_hwtstamp(struc
 	}
 
 	if (found) {
-		/* Correct the clk domain crossing(CDC) error */
-		if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate) {
-			adjust += -(2 * (NSEC_PER_SEC /
-					 priv->plat->clk_ptp_rate));
-			ns += adjust;
-		}
+		ns -= stmmac_cdc_adjust(priv);
 
 		memset(&shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
 		shhwtstamp.hwtstamp = ns_to_ktime(ns);
@@ -573,7 +575,6 @@ static void stmmac_get_rx_hwtstamp(struc
 {
 	struct skb_shared_hwtstamps *shhwtstamp = NULL;
 	struct dma_desc *desc = p;
-	u64 adjust = 0;
 	u64 ns = 0;
 
 	if (!priv->hwts_rx_en)
@@ -586,11 +587,7 @@ static void stmmac_get_rx_hwtstamp(struc
 	if (stmmac_get_rx_timestamp_status(priv, p, np, priv->adv_ts)) {
 		stmmac_get_timestamp(priv, desc, priv->adv_ts, &ns);
 
-		/* Correct the clk domain crossing(CDC) error */
-		if (priv->plat->has_gmac4 && priv->plat->clk_ptp_rate) {
-			adjust += 2 * (NSEC_PER_SEC / priv->plat->clk_ptp_rate);
-			ns -= adjust;
-		}
+		ns -= stmmac_cdc_adjust(priv);
 
 		netdev_dbg(priv->dev, "get valid RX hw timestamp %llu\n", ns);
 		shhwtstamp = skb_hwtstamps(skb);
