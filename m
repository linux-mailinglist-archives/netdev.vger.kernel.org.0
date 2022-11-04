Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6999C61A2AA
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 21:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229898AbiKDUtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 16:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKDUta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 16:49:30 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94EF0A1A1;
        Fri,  4 Nov 2022 13:49:28 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667594967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=mBvld+GgZuPiLK5vglNTcPwqj1bswkQ3GQEVIj7NMyw=;
        b=r8+I9EXLydrVa4Wevv5Oq7/afV1wabK2W07ZbKn9WCMjm/0ThRH/GOSlCvPazahHtaWpCN
        owxNQehsUYm/i5P4Wv1sHSc6kGlWmN9TP1Yit6cooPMxZ0wfC4nOfFMkUi/rJVe6/KMK73
        cu0rcoSKVcs888NJ0zEPKBOgm/3/WxQ=
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     netdev@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH net-next] net: macb: implement live mac addr change
Date:   Fri,  4 Nov 2022 13:48:37 -0700
Message-Id: <20221104204837.614459-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement live mac addr change for the macb ethernet driver.

Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
---
 drivers/net/ethernet/cadence/macb_main.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 4f63f1ba3161..991d5041c836 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -2947,6 +2947,18 @@ static int macb_change_mtu(struct net_device *dev, int new_mtu)
 	return 0;
 }
 
+static int macb_set_mac_addr(struct net_device *dev, void *addr)
+{
+	int err;
+
+	err = eth_mac_addr(dev, addr);
+	if (err < 0)
+		return err;
+
+	macb_set_hwaddr(netdev_priv(dev));
+	return 0;
+}
+
 static void gem_update_stats(struct macb *bp)
 {
 	struct macb_queue *queue;
@@ -3786,7 +3798,7 @@ static const struct net_device_ops macb_netdev_ops = {
 	.ndo_eth_ioctl		= macb_ioctl,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_change_mtu		= macb_change_mtu,
-	.ndo_set_mac_address	= eth_mac_addr,
+	.ndo_set_mac_address	= macb_set_mac_addr,
 #ifdef CONFIG_NET_POLL_CONTROLLER
 	.ndo_poll_controller	= macb_poll_controller,
 #endif
@@ -4049,6 +4061,8 @@ static int macb_init(struct platform_device *pdev)
 		dev->ethtool_ops = &macb_ethtool_ops;
 	}
 
+	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+
 	/* Set features */
 	dev->hw_features = NETIF_F_SG;
 
-- 
2.37.3

