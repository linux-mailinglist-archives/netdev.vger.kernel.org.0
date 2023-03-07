Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F41C6AF5F7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 20:43:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234045AbjCGTm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 14:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230459AbjCGTme (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 14:42:34 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B22FAFF2F
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 11:29:30 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E64F1E0004;
        Tue,  7 Mar 2023 19:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1678217369;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=zx7DU39qp2jZEJsjUp0zjKAypF1hRExKDi/KWBIplNM=;
        b=WPfUZiCGUTjuImfxaNt7Ne6y6IK5LBw6cBhCg6kyg3nf5KwW4KnQ4XHwCkTZ7y3aqiBO3J
        VuMbh52ky0ZxOrAcDCvslQinV/jW6N/9oYYB1nOpY87wSwEFVPd0ZcgtFkzfn10bo8Wh6w
        m5oRzmmX7bac+XopbImAQRaQHqEfDr5Xa6+VYuXciARv6H0QaRtHdG0vbeq9PcxZJCgwq9
        wJCrRP8at3/lfdiWLtlmDxvg7u5F3VSKwMBRfuSsoIo1DsfP9OPJHu3FgXyRwnbuzb7+EV
        vUsJHEkgKkSjri8qNqO8YlXBsG6fYo6AE7PdIOxCySGAkShHjGLUOUCX5L+5Pg==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH net-next] net: mvpp2: Defer probe if MAC address source is not yet ready
Date:   Tue,  7 Mar 2023 20:29:27 +0100
Message-Id: <20230307192927.512757-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

NVMEM layouts are no longer registered early, and thus may not yet be
available when Ethernet drivers (or any other consumer) probe, leading
to possible probe deferrals errors. Forward the error code if this
happens. All other errors being discarded, the driver will eventually
use a random MAC address if no other source was considered valid (no
functional change on this regard).

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 24 ++++++++++++-------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 9b4ecbe4f36d..e7c7652ffac5 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -6081,18 +6081,19 @@ static bool mvpp2_port_has_irqs(struct mvpp2 *priv,
 	return true;
 }
 
-static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
-				     struct fwnode_handle *fwnode,
-				     char **mac_from)
+static int mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
+				    struct fwnode_handle *fwnode,
+				    char **mac_from)
 {
 	struct mvpp2_port *port = netdev_priv(dev);
 	char hw_mac_addr[ETH_ALEN] = {0};
 	char fw_mac_addr[ETH_ALEN];
+	int ret;
 
 	if (!fwnode_get_mac_address(fwnode, fw_mac_addr)) {
 		*mac_from = "firmware node";
 		eth_hw_addr_set(dev, fw_mac_addr);
-		return;
+		return 0;
 	}
 
 	if (priv->hw_version == MVPP21) {
@@ -6100,19 +6101,24 @@ static void mvpp2_port_copy_mac_addr(struct net_device *dev, struct mvpp2 *priv,
 		if (is_valid_ether_addr(hw_mac_addr)) {
 			*mac_from = "hardware";
 			eth_hw_addr_set(dev, hw_mac_addr);
-			return;
+			return 0;
 		}
 	}
 
 	/* Only valid on OF enabled platforms */
-	if (!of_get_mac_address_nvmem(to_of_node(fwnode), fw_mac_addr)) {
+	ret = of_get_mac_address_nvmem(to_of_node(fwnode), fw_mac_addr);
+	if (ret == -EPROBE_DEFER)
+		return ret;
+	if (!ret) {
 		*mac_from = "nvmem cell";
 		eth_hw_addr_set(dev, fw_mac_addr);
-		return;
+		return 0;
 	}
 
 	*mac_from = "random";
 	eth_hw_addr_random(dev);
+
+	return 0;
 }
 
 static struct mvpp2_port *mvpp2_phylink_to_port(struct phylink_config *config)
@@ -6815,7 +6821,9 @@ static int mvpp2_port_probe(struct platform_device *pdev,
 	mutex_init(&port->gather_stats_lock);
 	INIT_DELAYED_WORK(&port->stats_work, mvpp2_gather_hw_statistics);
 
-	mvpp2_port_copy_mac_addr(dev, priv, port_fwnode, &mac_from);
+	err = mvpp2_port_copy_mac_addr(dev, priv, port_fwnode, &mac_from);
+	if (err < 0)
+		goto err_free_stats;
 
 	port->tx_ring_size = MVPP2_MAX_TXD_DFLT;
 	port->rx_ring_size = MVPP2_MAX_RXD_DFLT;
-- 
2.34.1

