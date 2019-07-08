Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0A061E61
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 14:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730493AbfGHM0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 08:26:50 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:41274 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727189AbfGHM0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 08:26:49 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id BCBBAC2A26;
        Mon,  8 Jul 2019 12:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1562588809; bh=fLTBqcsohGmf5D926y4k3Ho/rhwsBNGOM4Be4eDgqSY=;
        h=From:To:Cc:Subject:Date:From;
        b=Kj3vmYt5roxkJWh4kP6YOgxjZo1VxdExS15uQaIqjfQYpJXi9hAXvG3OZ/h5BcdnZ
         jP0uR7F5Zz3LwNRW8vaxFt1nuKjVVQVoE90xuZQhxK8AmrY/CeGvYFKemo5dbaKsfX
         1Pi3fY+EkRfOQGSM1qAJ/c3OLlsDAmbOuM8+zANx8FlrX9JkRCPL+IVjJ1VIvb97NY
         VzrdQOsQ9yWm123SixWprUW/PRrq075VMMPhgVaE5gdlhAjE1dJl9pITfLDycZxw9r
         f6ZgGeuvhnJXyBilUu6QHRBRRtQXhQzBDo0dK2767y/b6yqUvaS7BkpqaxG8dUvDD9
         tTar5NLiXNtTw==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 14A83A005D;
        Mon,  8 Jul 2019 12:26:39 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id AFC2D7131;
        Mon,  8 Jul 2019 14:26:39 +0200 (CEST)
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     netdev@vger.kernel.org
Cc:     Joao Pinto <Joao.Pinto@synopsys.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH net] net: stmmac: Re-work the queue selection for TSO packets
Date:   Mon,  8 Jul 2019 14:26:28 +0200
Message-Id: <36018491f47206728e04d67a9e6263635e64f721.1562588640.git.joabreu@synopsys.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ben Hutchings says:
	"This is the wrong place to change the queue mapping.
	stmmac_xmit() is called with a specific TX queue locked,
	and accessing a different TX queue results in a data race
	for all of that queue's state.

	I think this commit should be reverted upstream and in all
	stable branches.  Instead, the driver should implement the
	ndo_select_queue operation and override the queue mapping there."

Fixes: c5acdbee22a1 ("net: stmmac: Send TSO packets always from Queue 0")
Suggested-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jose Abreu <joabreu@synopsys.com>

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
Cc: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 28 +++++++++++++++--------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 06358fe5b245..11b6feb33b54 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3045,17 +3045,8 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	/* Manage oversized TCP frames for GMAC4 device */
 	if (skb_is_gso(skb) && priv->tso) {
-		if (skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)) {
-			/*
-			 * There is no way to determine the number of TSO
-			 * capable Queues. Let's use always the Queue 0
-			 * because if TSO is supported then at least this
-			 * one will be capable.
-			 */
-			skb_set_queue_mapping(skb, 0);
-
+		if (skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6))
 			return stmmac_tso_xmit(skb, dev);
-		}
 	}
 
 	if (unlikely(stmmac_tx_avail(priv, queue) < nfrags + 1)) {
@@ -3872,6 +3863,22 @@ static int stmmac_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 	}
 }
 
+static u16 stmmac_select_queue(struct net_device *dev, struct sk_buff *skb,
+			       struct net_device *sb_dev)
+{
+	if (skb_shinfo(skb)->gso_type & (SKB_GSO_TCPV4 | SKB_GSO_TCPV6)) {
+		/*
+		 * There is no way to determine the number of TSO
+		 * capable Queues. Let's use always the Queue 0
+		 * because if TSO is supported then at least this
+		 * one will be capable.
+		 */
+		return 0;
+	}
+
+	return netdev_pick_tx(dev, skb, NULL) % dev->real_num_tx_queues;
+}
+
 static int stmmac_set_mac_address(struct net_device *ndev, void *addr)
 {
 	struct stmmac_priv *priv = netdev_priv(ndev);
@@ -4088,6 +4095,7 @@ static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_tx_timeout = stmmac_tx_timeout,
 	.ndo_do_ioctl = stmmac_ioctl,
 	.ndo_setup_tc = stmmac_setup_tc,
+	.ndo_select_queue = stmmac_select_queue,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller = stmmac_poll_controller,
 #endif
-- 
2.7.4

