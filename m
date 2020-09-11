Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F12D265B85
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 10:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgIKIZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 04:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgIKIZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 04:25:39 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA10C061573
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 01:25:37 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kGeNB-0002LJ-Fv; Fri, 11 Sep 2020 10:25:33 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1kGeN7-00074m-PO; Fri, 11 Sep 2020 10:25:29 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] net: ag71xx: add flow control support
Date:   Fri, 11 Sep 2020 10:25:28 +0200
Message-Id: <20200911082528.27121-3-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200911082528.27121-1-o.rempel@pengutronix.de>
References: <20200911082528.27121-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add flow control support. The functionality was tested on AR9331 SoC and
confirmed by iperf3 results and HW counters exported over ethtool.
Following test configurations was used:

iMX6S receiver <--- TL-SG1005D switch <---- AR9331 sender

The switch is supporting symmytric flow control:
Settings for eth0:
        Supported ports: [ MII ]
        Supported link modes:   10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
        Supported pause frame use: Symmetric Receive-only
        Supports auto-negotiation: Yes
        Supported FEC modes: Not reported
        Advertised link modes:  10baseT/Half 10baseT/Full
                                100baseT/Half 100baseT/Full
        Advertised pause frame use: Symmetric
        Advertised auto-negotiation: Yes
        Advertised FEC modes: Not reported
        Link partner advertised link modes:  10baseT/Half 10baseT/Full
                                             100baseT/Half 100baseT/Full
--->>   Link partner advertised pause frame use: Symmetric
        Link partner advertised auto-negotiation: Yes
        Link partner advertised FEC modes: Not reported
        Speed: 100Mb/s
        Duplex: Full
        Auto-negotiation: on
        Port: MII
        PHYAD: 4
        Transceiver: external
        Link detected: yes

The iMX6S system was configured to 10Mbit, to let the switch use flow
control:
  - ethtool -s eth0 speed 10

With flow control disabled on AR9331:
  - ethtool -A eth0  rx off tx off
  - iperf3 -u -c 172.17.0.1 -b100M -l1472 -t10

[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-10.00  sec  66.2 MBytes  55.5 Mbits/sec  0.000 ms  0/47155 (0%)  sender
[  5]   0.00-10.04  sec  11.5 MBytes  9.57 Mbits/sec  1.309 ms  38986/47146 (83%)  receiver

With flow control enabled on AR9331:
  - ethtool -A eth0  rx on tx on
  - iperf3 -u -c 172.17.0.1 -b100M -l1472 -t10

[ ID] Interval           Transfer     Bitrate         Jitter    Lost/Total Datagrams
[  5]   0.00-10.00  sec  15.1 MBytes  12.6 Mbits/sec  0.000 ms  0/10727 (0%)  sender
[  5]   0.00-10.05  sec  11.5 MBytes  9.57 Mbits/sec  1.371 ms  2525/10689 (24%)  receiver

Similar results are get in opposite direction by introducing extra CPU
load on AR9331:
  - chrt 40 dd if=/dev/zero of=/dev/null &

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 drivers/net/ethernet/atheros/ag71xx.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/atheros/ag71xx.c b/drivers/net/ethernet/atheros/ag71xx.c
index 8c80a87aee58..dd5c8a9038bb 100644
--- a/drivers/net/ethernet/atheros/ag71xx.c
+++ b/drivers/net/ethernet/atheros/ag71xx.c
@@ -1056,6 +1056,8 @@ static void ag71xx_mac_validate(struct phylink_config *config,
 
 	phylink_set(mask, MII);
 
+	phylink_set(mask, Pause);
+	phylink_set(mask, Asym_Pause);
 	phylink_set(mask, Autoneg);
 	phylink_set(mask, 10baseT_Half);
 	phylink_set(mask, 10baseT_Full);
@@ -1106,7 +1108,7 @@ static void ag71xx_mac_link_up(struct phylink_config *config,
 			       bool tx_pause, bool rx_pause)
 {
 	struct ag71xx *ag = netdev_priv(to_net_dev(config->dev));
-	u32 cfg2;
+	u32 cfg1, cfg2;
 	u32 ifctl;
 	u32 fifo5;
 
@@ -1140,6 +1142,15 @@ static void ag71xx_mac_link_up(struct phylink_config *config,
 	ag71xx_wr(ag, AG71XX_REG_FIFO_CFG5, fifo5);
 	ag71xx_wr(ag, AG71XX_REG_MAC_IFCTL, ifctl);
 
+	cfg1 = ag71xx_rr(ag, AG71XX_REG_MAC_CFG1);
+	cfg1 &= ~(MAC_CFG1_TFC | MAC_CFG1_RFC);
+	if (tx_pause)
+		cfg1 |= MAC_CFG1_TFC;
+
+	if (rx_pause)
+		cfg1 |= MAC_CFG1_RFC;
+	ag71xx_wr(ag, AG71XX_REG_MAC_CFG1, cfg1);
+
 	ag71xx_hw_start(ag);
 }
 
-- 
2.28.0

