Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DEA56095AC
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 20:45:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbiJWSpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 14:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230395AbiJWSpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 14:45:19 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5618E3FEEC;
        Sun, 23 Oct 2022 11:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666550719; x=1698086719;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eVE2lQ5w+2D1pFZYr6+909z4xn/w37Zq+2kgclL7XFo=;
  b=WUrNW6X8J04JeyR55yOjf+DQNgeEAkGx9wjCCcHtw60YaeIiPyyGWOtQ
   dQdMwhXgFK5G8PsmjoK/dkI/HcJpaZI7iyfcwSq4NRAPZRTx7/ZrJxFKU
   vKGpBR8JMElASA1gQG/EywrruvyCzowwBfXtWiZcA2/pMi2pwHuq1KHaZ
   23ZLI9PL1x4nAUcrSV6CLKAdQ0Sijbx0oa6OmEYeVdQfYJ30JgbSAP7bA
   6wk7wNwmb2/oTAkme5tnciEn6gZ+Xn97jXADiLnSKDQPq3X8c0/9E7hCW
   2KqBkAMOyP+xDl6VV/jAN06bhqsbF7ys/rJssCiG2IEWCBp4meoiKnYRl
   A==;
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="180146172"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Oct 2022 11:45:18 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 23 Oct 2022 11:45:17 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 23 Oct 2022 11:45:16 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net 3/3] net: lan966x: Fix FDMA when MTU is changed
Date:   Sun, 23 Oct 2022 20:48:38 +0200
Message-ID: <20221023184838.4128061-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221023184838.4128061-1-horatiu.vultur@microchip.com>
References: <20221023184838.4128061-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When MTU is changed, FDMA is required to calculate what is the maximum
size of the frame that it can received. So it can calculate what is the
page order needed to allocate for the received frames.
The first problem was that, when the max MTU was calculated it was
reading the value from dev and not from HW, so in this way it was
missing L2 header + the FCS.
The other problem was that once the skb is created using
__build_skb_around, it would reserve some space for skb_shared_info.
So if we received a frame which size is at the limit of the page order
then the creating will failed because it would not have space to put all
the data.

Fixes: 2ea1cbac267e ("net: lan966x: Update FDMA to change MTU.")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 7 +++++--
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index a42035cec611c..5a5603f9e9fd3 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -668,12 +668,14 @@ static int lan966x_fdma_get_max_mtu(struct lan966x *lan966x)
 	int i;
 
 	for (i = 0; i < lan966x->num_phys_ports; ++i) {
+		struct lan966x_port *port;
 		int mtu;
 
-		if (!lan966x->ports[i])
+		port = lan966x->ports[i];
+		if (!port)
 			continue;
 
-		mtu = lan966x->ports[i]->dev->mtu;
+		mtu = lan_rd(lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
 		if (mtu > max_mtu)
 			max_mtu = mtu;
 	}
@@ -733,6 +735,7 @@ int lan966x_fdma_change_mtu(struct lan966x *lan966x)
 
 	max_mtu = lan966x_fdma_get_max_mtu(lan966x);
 	max_mtu += IFH_LEN * sizeof(u32);
+	max_mtu += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 
 	if (round_up(max_mtu, PAGE_SIZE) / PAGE_SIZE - 1 ==
 	    lan966x->rx.page_order)
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index b3070c3fcad0a..20ee5b28f70a5 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -395,7 +395,7 @@ static int lan966x_port_change_mtu(struct net_device *dev, int new_mtu)
 
 	err = lan966x_fdma_change_mtu(lan966x);
 	if (err) {
-		lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(old_mtu),
+		lan_wr(DEV_MAC_MAXLEN_CFG_MAX_LEN_SET(LAN966X_HW_MTU(old_mtu)),
 		       lan966x, DEV_MAC_MAXLEN_CFG(port->chip_port));
 		dev->mtu = old_mtu;
 	}
-- 
2.38.0

