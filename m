Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE65E740E0
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727699AbfGXVf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:35:26 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35991 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbfGXVfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:35:25 -0400
Received: by mail-wr1-f67.google.com with SMTP id n4so48555777wrs.3
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 14:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=Ld0Hnm2NAvekwmTOF8ZxKWaLjgij1TrYNJM2HC1LsQ4=;
        b=NIfqRTv47oDB+3n/UyUfTzKvnigtHgO9KMohVvnRUitIYWFRfjiyMOgRod+QJPJhiO
         ukd0TCen9mReqTM64FHUPfTQmNb/RaIRSswu8P2USrr1ld3AFiw8WNDkh7PytPSFAsqC
         jxbbN9RaIVGEsvQourJ3vpyTWjKWnQlD29UMJ7KWcWbahcTO0+4HEhYHNfRBhe/9XUTN
         I8emJOl6dCEh8PMv71E/AmgisY5nRpVn+CPlXTDdrdCYRisvbIhv66HUHPk2zNU+4gIy
         raTE4m+od0U9YIyDyL82mb9isIaS/DYFAEsZsq4VYxtyrEvNch1RqlVpQww8rE4ZiZKa
         R3VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=Ld0Hnm2NAvekwmTOF8ZxKWaLjgij1TrYNJM2HC1LsQ4=;
        b=OZFSmowBLSh5LnkMYNisP5BiXyXhYi8Hov4m110DZIg/pDBbh5JuHcmu3iOxzxgs20
         XruIMJ4B+nv39+UyJUM8elCBuxyBmE06YSCnrY5yfIT/974E2+KsmtV842OjJHg0E7yg
         ro1pr2Ot3a/HHJK+og2L9lipn8E8PTpJw9jGPnUEHn+tDQFDzorEmwWej1Z/0vx1UgnS
         ZfEnuvBLsLevQdTyC1tOAWMijunS6rCBWddCRN5nLfGE7vTvMX6wnVB9n9rIJJbiUWSM
         XUE8VxsGmPwziR2hSSgLtdqp8MOxupFkFjjt9B/TXo3MJOtX+DmXa3ro4CrX0wbk66Nj
         cq2g==
X-Gm-Message-State: APjAAAWm8X8k95WEkAVpSw5Qq6r4QVL2tHrfhov1VsQDx4AihJfPMlNq
        O2fqBBfvWkkntlnIBO78hEe1Jhj1
X-Google-Smtp-Source: APXvYqxwK5EJAG1Kz4dcf+PbFNJuxbgwviM0ag3vsMi7rIw+7WYKBjWUmlw+69cS482KHo+FolsKpw==
X-Received: by 2002:adf:e442:: with SMTP id t2mr33297360wrm.286.1564004123263;
        Wed, 24 Jul 2019 14:35:23 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:60e4:dd99:f7ec:c519? (p200300EA8F43420060E4DD99F7ECC519.dip0.t-ipconnect.de. [2003:ea:8f43:4200:60e4:dd99:f7ec:c519])
        by smtp.googlemail.com with ESMTPSA id 4sm111008403wro.78.2019.07.24.14.35.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 14:35:22 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: [PATCH v2 net-next] r8169: improve rtl_set_rx_mode
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Message-ID: <2f0e6d3c-aa44-3334-aab0-f158f46e4aa9@gmail.com>
Date:   Wed, 24 Jul 2019 23:34:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch improves and simplifies rtl_set_rx_mode a little.
No functional change intended.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
v2:
- change variable declarations to reverse xmas tree
---
 drivers/net/ethernet/realtek/r8169_main.c | 52 ++++++++++-------------
 1 file changed, 22 insertions(+), 30 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9c743d2fc..9bd310938 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -61,7 +61,7 @@
 
 /* Maximum number of multicast addresses to filter (vs. Rx-all-multicast).
    The RTL chips use a 64 element hash table based on the Ethernet CRC. */
-static const int multicast_filter_limit = 32;
+#define	MC_FILTER_LIMIT	32
 
 #define TX_DMA_BURST	7	/* Maximum PCI burst, '7' is unlimited */
 #define InterFrameGap	0x03	/* 3 means InterFrameGap = the shortest one */
@@ -4146,54 +4146,46 @@ static void rtl8169_set_magic_reg(struct rtl8169_private *tp, unsigned mac_versi
 
 static void rtl_set_rx_mode(struct net_device *dev)
 {
+	u32 rx_mode = AcceptBroadcast | AcceptMyPhys | AcceptMulticast;
+	/* Multicast hash filter */
+	u32 mc_filter[2] = { 0xffffffff, 0xffffffff };
 	struct rtl8169_private *tp = netdev_priv(dev);
-	u32 mc_filter[2];	/* Multicast hash filter */
-	int rx_mode;
-	u32 tmp = 0;
+	u32 tmp;
 
 	if (dev->flags & IFF_PROMISC) {
 		/* Unconditionally log net taps. */
 		netif_notice(tp, link, dev, "Promiscuous mode enabled\n");
-		rx_mode =
-		    AcceptBroadcast | AcceptMulticast | AcceptMyPhys |
-		    AcceptAllPhys;
-		mc_filter[1] = mc_filter[0] = 0xffffffff;
-	} else if ((netdev_mc_count(dev) > multicast_filter_limit) ||
-		   (dev->flags & IFF_ALLMULTI)) {
-		/* Too many to filter perfectly -- accept all multicasts. */
-		rx_mode = AcceptBroadcast | AcceptMulticast | AcceptMyPhys;
-		mc_filter[1] = mc_filter[0] = 0xffffffff;
+		rx_mode |= AcceptAllPhys;
+	} else if (netdev_mc_count(dev) > MC_FILTER_LIMIT ||
+		   dev->flags & IFF_ALLMULTI ||
+		   tp->mac_version == RTL_GIGA_MAC_VER_35) {
+		/* accept all multicasts */
+	} else if (netdev_mc_empty(dev)) {
+		rx_mode &= ~AcceptMulticast;
 	} else {
 		struct netdev_hw_addr *ha;
 
-		rx_mode = AcceptBroadcast | AcceptMyPhys;
 		mc_filter[1] = mc_filter[0] = 0;
 		netdev_for_each_mc_addr(ha, dev) {
-			int bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
-			mc_filter[bit_nr >> 5] |= 1 << (bit_nr & 31);
-			rx_mode |= AcceptMulticast;
+			u32 bit_nr = ether_crc(ETH_ALEN, ha->addr) >> 26;
+			mc_filter[bit_nr >> 5] |= BIT(bit_nr & 31);
+		}
+
+		if (tp->mac_version > RTL_GIGA_MAC_VER_06) {
+			tmp = mc_filter[0];
+			mc_filter[0] = swab32(mc_filter[1]);
+			mc_filter[1] = swab32(tmp);
 		}
 	}
 
 	if (dev->features & NETIF_F_RXALL)
 		rx_mode |= (AcceptErr | AcceptRunt);
 
-	tmp = (RTL_R32(tp, RxConfig) & ~RX_CONFIG_ACCEPT_MASK) | rx_mode;
-
-	if (tp->mac_version > RTL_GIGA_MAC_VER_06) {
-		u32 data = mc_filter[0];
-
-		mc_filter[0] = swab32(mc_filter[1]);
-		mc_filter[1] = swab32(data);
-	}
-
-	if (tp->mac_version == RTL_GIGA_MAC_VER_35)
-		mc_filter[1] = mc_filter[0] = 0xffffffff;
-
 	RTL_W32(tp, MAR0 + 4, mc_filter[1]);
 	RTL_W32(tp, MAR0 + 0, mc_filter[0]);
 
-	RTL_W32(tp, RxConfig, tmp);
+	tmp = RTL_R32(tp, RxConfig);
+	RTL_W32(tp, RxConfig, (tmp & ~RX_CONFIG_ACCEPT_MASK) | rx_mode);
 }
 
 DECLARE_RTL_COND(rtl_csiar_cond)
-- 
2.22.0

