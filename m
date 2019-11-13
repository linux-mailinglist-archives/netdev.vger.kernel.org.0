Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 324CAFB35E
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 16:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfKMPNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 10:13:04 -0500
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:51248 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727550AbfKMPMV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 10:12:21 -0500
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 38E03C0E98;
        Wed, 13 Nov 2019 15:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1573657941; bh=jjICtN6nRPvjHGBNW8f6sLnIxarejkUWdfnGT+fEkhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=RffYW4TN54gSvtHNErDOxuzEPR6/DnIaT4qIvG4Z1jzdg0kzB8kOXEroRoYNEPPNh
         DHY/OLqKtEUbb4/tMUuu822UcQv+BfDeLk66Q1glFxlSsx6gT5RWk27Il8pZDflgEM
         4f7HNGWeatmrf92VybDNnesbjHnyIRDd1pqJzlMF46p41EJj5NUfxU8jQnjC26IMWC
         Vah+bJtb/vG53vdZRXa2LF30igCDU+J8hK8S2uVrbteRWiTvTX7RoUs/hJAiZghYpw
         Wgwe+bLTF19xPBxDWALymorx+WFTld0ncIhQI+vjD0Yytzq9smLT2m9RH6LxeODkIz
         UrkfjS4o6Xgsw==
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by mailhost.synopsys.com (Postfix) with ESMTP id E3509A0097;
        Wed, 13 Nov 2019 15:12:19 +0000 (UTC)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 7/7] net: stmmac: TX Coalesce should be per-packet
Date:   Wed, 13 Nov 2019 16:12:08 +0100
Message-Id: <904a2b53a0957f6f82562a73dffb4d69218c99b5.1573657593.git.Jose.Abreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1573657592.git.Jose.Abreu@synopsys.com>
References: <cover.1573657592.git.Jose.Abreu@synopsys.com>
In-Reply-To: <cover.1573657592.git.Jose.Abreu@synopsys.com>
References: <cover.1573657592.git.Jose.Abreu@synopsys.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TX Coalesce settings are per packet and not per fragment because
otherwise the coalesce would be different between TSO and non-TSO
packets.

Signed-off-by: Jose Abreu <Jose.Abreu@synopsys.com>

---
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: Alexandre Torgue <alexandre.torgue@st.com>
Cc: Jose Abreu <joabreu@synopsys.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: netdev@vger.kernel.org
Cc: linux-stm32@st-md-mailman.stormreply.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 6136ada20c8e..140abfcb54c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3033,7 +3033,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	tx_q->tx_skbuff[tx_q->cur_tx] = skb;
 
 	/* Manage tx mitigation */
-	tx_q->tx_count_frames += nfrags + 1;
+	tx_q->tx_count_frames++;
 	if (likely(priv->tx_coal_frames > tx_q->tx_count_frames) &&
 	    !((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
 	      priv->hwts_tx_en)) {
@@ -3241,7 +3241,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * This approach takes care about the fragments: desc is the first
 	 * element in case of no SG.
 	 */
-	tx_q->tx_count_frames += nfrags + 1;
+	tx_q->tx_count_frames++;
 	if (likely(priv->tx_coal_frames > tx_q->tx_count_frames) &&
 	    !((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
 	      priv->hwts_tx_en)) {
-- 
2.7.4

