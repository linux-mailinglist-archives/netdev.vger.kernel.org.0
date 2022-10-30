Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 809EA612D0D
	for <lists+netdev@lfdr.de>; Sun, 30 Oct 2022 22:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbiJ3Vcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Oct 2022 17:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiJ3VcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Oct 2022 17:32:06 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2A6AE47;
        Sun, 30 Oct 2022 14:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667165525; x=1698701525;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=OdInNG+WtCVFIQyztfsKU1qUG+kc8CesAPbpqzEN/q4=;
  b=VP1UqK3/E3aV4VHTupjumONAK6a/JbjO7uMI4Ztd7HeFNPv3yFG9k1WF
   ZutPN3vcwmsN0WUPsbg7jYbRv7rwPIMB7WQfxdPdf0C9Q4iZ4ezIkZYli
   usntzVljzr2ocC4QKER9afYxjQlfUexET/EXCh2Q67VR5hHZXDrW4DTp1
   wo1PX4o/2IZR3WZBHfpfMKkm4NfaPHsAB136WRXAI+MBSlnSLkKNWUR8e
   8C5pSluTWEoJN7rO5Gn4H8oLe4uSSdNxKlBuOeaEXLPBaYMquOjpypHOh
   xGl25BAJ7JQGLSZp4qfWBw1ncQnd9KDtdeArIfq7NsCMZMOtp25rGcMaP
   w==;
X-IronPort-AV: E=Sophos;i="5.95,226,1661842800"; 
   d="scan'208";a="184552394"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Oct 2022 14:32:04 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Sun, 30 Oct 2022 14:32:03 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Sun, 30 Oct 2022 14:32:01 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <UNGLinuxDriver@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net v2 3/3] net: lan966x: Fix FDMA when MTU is changed
Date:   Sun, 30 Oct 2022 22:36:36 +0100
Message-ID: <20221030213636.1031408-4-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
References: <20221030213636.1031408-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c | 8 ++++++--
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 2 +-
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index a42035cec611c..c235edd2b182a 100644
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
@@ -733,6 +735,8 @@ int lan966x_fdma_change_mtu(struct lan966x *lan966x)
 
 	max_mtu = lan966x_fdma_get_max_mtu(lan966x);
 	max_mtu += IFH_LEN * sizeof(u32);
+	max_mtu += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	max_mtu += VLAN_HLEN * 2;
 
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

