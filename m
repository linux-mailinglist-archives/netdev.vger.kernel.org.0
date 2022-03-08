Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54E64D14BE
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 11:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345860AbiCHK3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 05:29:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345848AbiCHK3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 05:29:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5164942A06;
        Tue,  8 Mar 2022 02:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646735319; x=1678271319;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ArbjmZUZ0l6WdorlwWCLAqiEYpli5Fr0XItnFGrqD60=;
  b=Fn2/+MLWew5DZi2vOtQ6xWqm94QRsmWLK8PJENWu3SuGSNk+Lm7Nlk/E
   Th2T+HJH+s8O0JkGKfdsris/m5QlIIEgQ+JgMme88x0Bnp7Qcg2MGj4P3
   lzXvoXSLnlT5+lyRa6YdTo/dvL35Q/jRO3J2JKdeU7u65kJfCtGKPS0af
   prdL+PkinHd/IEhzxdyRSdajZt4oh+gL4blr6QcMDN085AFuZJclCiKQ/
   /uPPZlySaAuszFkgYfMABw0RjA7apfPOOLDEpmWtJJlJZ9thRvygeQE7j
   gnKmXXjj+0zJNhFzDclRB2vmBHTO9HrUxKP9dexjvS/sGJ7mYpIYe1NYr
   A==;
X-IronPort-AV: E=Sophos;i="5.90,164,1643698800"; 
   d="scan'208";a="155629249"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Mar 2022 03:28:38 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 8 Mar 2022 03:28:09 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Tue, 8 Mar 2022 03:28:07 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next] net: lan966x: Add spinlock for frame transmission from CPU.
Date:   Tue, 8 Mar 2022 11:29:04 +0100
Message-ID: <20220308102904.3978779-1-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The registers used to inject a frame to one of the ports is shared
between all the net devices. Therefore, there can be race conditions for
accessing the registers when two processes send frames at the same time
on different ports.

To fix this, add a spinlock around the function
'lan966x_port_ifh_xmit()'.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 9 ++++++++-
 drivers/net/ethernet/microchip/lan966x/lan966x_main.h | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 750f2cc2f695..81c01665d01e 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -318,6 +318,7 @@ static void lan966x_ifh_set_timestamp(void *ifh, u64 timestamp)
 static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct lan966x_port *port = netdev_priv(dev);
+	struct lan966x *lan966x = port->lan966x;
 	__be32 ifh[IFH_LEN];
 	int err;
 
@@ -338,7 +339,11 @@ static int lan966x_port_xmit(struct sk_buff *skb, struct net_device *dev)
 		lan966x_ifh_set_timestamp(ifh, LAN966X_SKB_CB(skb)->ts_id);
 	}
 
-	return lan966x_port_ifh_xmit(skb, ifh, dev);
+	spin_lock(&lan966x->tx_lock);
+	err = lan966x_port_ifh_xmit(skb, ifh, dev);
+	spin_unlock(&lan966x->tx_lock);
+
+	return err;
 }
 
 static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
@@ -885,6 +890,8 @@ static void lan966x_init(struct lan966x *lan966x)
 	lan_rmw(ANA_ANAINTR_INTR_ENA_SET(1),
 		ANA_ANAINTR_INTR_ENA,
 		lan966x, ANA_ANAINTR);
+
+	spin_lock_init(&lan966x->tx_lock);
 }
 
 static int lan966x_ram_init(struct lan966x *lan966x)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 058e43531818..ae282da1da74 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -108,6 +108,8 @@ struct lan966x {
 
 	u8 base_mac[ETH_ALEN];
 
+	spinlock_t tx_lock; /* lock for frame transmition */
+
 	struct net_device *bridge;
 	u16 bridge_mask;
 	u16 bridge_fwd_mask;
-- 
2.33.0

