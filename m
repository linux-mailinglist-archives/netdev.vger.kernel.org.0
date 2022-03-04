Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2974CD2F4
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 12:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238436AbiCDLHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 06:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231405AbiCDLHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 06:07:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8FE81AC284;
        Fri,  4 Mar 2022 03:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1646391995; x=1677927995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Pg2JkvRfQ/LGDFIxcuQ5T5bU6mZGtJBQROCeBLNeNBE=;
  b=GVxM1ggkxhIMlW6DVEnbu+jaRDiXj6iSq64WAS5z5PfY1Q+7gi17Sxaz
   pK1B1VA5KbKEopes7ADAezVvUtAsuuM6cSAZPR7zl4RmqUsbIf1I9YxoW
   PBk7J5CNFtLo045ZxJK27Dc62y/+aT2eMrPLtARQjgHUOedIoYvZJwWEI
   D/OCJ5x6KO3yhD/KmbspJfRYSFI6AiLEJVdy6QXh+/O0hJTXTl91Ajg/m
   Gg72bfhtud4ue4xOQiKpC0iFhxeNLJDo22JYydwWcO/Iio0nXORBFPEV8
   G1L7LZBYkGMmHJn9ex7wCBIS3MCtXwTRvr4qUdiL4W/r713Hcme8QN6u+
   g==;
X-IronPort-AV: E=Sophos;i="5.90,155,1643698800"; 
   d="scan'208";a="148088241"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Mar 2022 04:06:34 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 4 Mar 2022 04:06:33 -0700
Received: from soft-dev3-1.microsemi.net (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 4 Mar 2022 04:06:31 -0700
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <casper.casan@gmail.com>,
        <richardcochran@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>
Subject: [PATCH net-next 1/9] net: sparx5: Move ifh from port to local variable
Date:   Fri, 4 Mar 2022 12:08:52 +0100
Message-ID: <20220304110900.3199904-2-horatiu.vultur@microchip.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
References: <20220304110900.3199904-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently the ifh is not changed, it is fixed for each frame for each
port that is sent out. Move this on the stack because this ifh needs to
be change based on the frames that are send out. This is needed for PTP
frames.

Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
---
 drivers/net/ethernet/microchip/sparx5/sparx5_main.h   | 2 +-
 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c | 3 +--
 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c | 8 ++++++--
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
index d40e18ce3293..6f0b6e60ceb8 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.h
@@ -167,7 +167,6 @@ struct sparx5_port {
 	enum sparx5_port_max_tags max_vlan_tags;
 	enum sparx5_vlan_port_type vlan_type;
 	u32 custom_etype;
-	u32 ifh[IFH_LEN];
 	bool vlan_aware;
 	struct hrtimer inj_timer;
 };
@@ -288,6 +287,7 @@ void sparx5_get_stats64(struct net_device *ndev, struct rtnl_link_stats64 *stats
 int sparx_stats_init(struct sparx5 *sparx5);
 
 /* sparx5_netdev.c */
+void sparx5_set_port_ifh(void *ifh_hdr, u16 portno);
 bool sparx5_netdevice_check(const struct net_device *dev);
 struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno);
 int sparx5_register_netdevs(struct sparx5 *sparx5);
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
index e042f117dc7a..86cae8bf42da 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
@@ -54,7 +54,7 @@ static void __ifh_encode_bitfield(void *ifh, u64 value, u32 pos, u32 width)
 		ifh_hdr[byte - 5] |= (u8)((encode & 0xFF0000000000) >> 40);
 }
 
-static void sparx5_set_port_ifh(void *ifh_hdr, u16 portno)
+void sparx5_set_port_ifh(void *ifh_hdr, u16 portno)
 {
 	/* VSTAX.RSV = 1. MSBit must be 1 */
 	ifh_encode_bitfield(ifh_hdr, 1, VSTAX + 79,  1);
@@ -210,7 +210,6 @@ struct net_device *sparx5_create_netdev(struct sparx5 *sparx5, u32 portno)
 	spx5_port->ndev = ndev;
 	spx5_port->sparx5 = sparx5;
 	spx5_port->portno = portno;
-	sparx5_set_port_ifh(spx5_port->ifh, portno);
 
 	ndev->netdev_ops = &sparx5_port_netdev_ops;
 	ndev->ethtool_ops = &sparx5_ethtool_ops;
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
index 148d431fcde4..d9c812f7d248 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
@@ -218,12 +218,16 @@ int sparx5_port_xmit_impl(struct sk_buff *skb, struct net_device *dev)
 	struct net_device_stats *stats = &dev->stats;
 	struct sparx5_port *port = netdev_priv(dev);
 	struct sparx5 *sparx5 = port->sparx5;
+	u32 ifh[IFH_LEN];
 	int ret;
 
+	memset(ifh, 0, IFH_LEN * 4);
+	sparx5_set_port_ifh(ifh, port->portno);
+
 	if (sparx5->fdma_irq > 0)
-		ret = sparx5_fdma_xmit(sparx5, port->ifh, skb);
+		ret = sparx5_fdma_xmit(sparx5, ifh, skb);
 	else
-		ret = sparx5_inject(sparx5, port->ifh, skb, dev);
+		ret = sparx5_inject(sparx5, ifh, skb, dev);
 
 	if (ret == NETDEV_TX_OK) {
 		stats->tx_bytes += skb->len;
-- 
2.33.0

