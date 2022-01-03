Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEAEE48390A
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 00:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiACX0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 18:26:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbiACX0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 18:26:03 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C52C061761;
        Mon,  3 Jan 2022 15:26:03 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id t187so17104012pfb.11;
        Mon, 03 Jan 2022 15:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nunRUnjuTlZ2TkjRJzWs2h82t5bGSvU4/zGNqg54R6s=;
        b=cUUBnoXtq1vx7LD8nnJg56cLY42F8nERJOLNmLfhPcDB4ZFAi+MrSkHblqc5Jt73eb
         8WAJ2tpYfcx+QezaXXTysW0+u+VfN7eukl0rnpEC0+2AL7FMsg64GXSZEJozgQhAFUkI
         QJlEkow7zpac+ufwnNECt+5LgDMZY0pGUr8vId/kj3Er7VROCVmomfxfskDG6BJ4KcnJ
         eov8rkeIFGUHRnc7tS6++G0oUNVGJ5Pud0tRA4auQEV3MV12Fqvl701bwoQVTRfsmvFJ
         RRQpwsp8vJTQNnBzoNovxd03PxLaaGg8TEBBrTkOZZpo4BXCp2x0EcZkKhMaYXMhl0m5
         PSlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nunRUnjuTlZ2TkjRJzWs2h82t5bGSvU4/zGNqg54R6s=;
        b=K55KvcvHNHxhPges8DqACqa10LXZgBCdASfEdtggqB0Ns83lmAhIHiNwjc5q2L2l3N
         3VfQUzX9ppeNyDZUzQ0oLNoXFTuRPmoGty2mVlORv+Nn7CgvpJiBE5oaTLUBH2Y7Y6uT
         3HDHk5s8gbZ/pGcovJe/RKbeKIpRYcL20rInG2kzjyB9OHRtQNh5/+Ulj5zaUQGlQ+iV
         ocgLT1XkeNywaoNN2YBRbj9IVK+EVsiCM5KJsWLyulNbQzBi+/0pBQ4gLrc9XYAxXFLO
         1oGKjOj4Hd1YN0osqXU00Om7I/XyO3OP/jhJ+ADCYusj8X2SDiSPUBHGNV2aC1feboUT
         NlBA==
X-Gm-Message-State: AOAM530S7aonyxxkFWqAluMKqgY61SvK8i8sPMahFfS6uAbe+b7kGSQb
        xEV98OT0BNP3ceZLBcy5LXIad2YWRKs=
X-Google-Smtp-Source: ABdhPJzpzuFJv3nBIb7tK8IXIzoyfa98OakrwcFZCAI4dRsFtuolDGYYNvE/uyeEWjFtL3daFee9ng==
X-Received: by 2002:a63:154f:: with SMTP id 15mr41804582pgv.521.1641252362841;
        Mon, 03 Jan 2022 15:26:02 -0800 (PST)
Received: from localhost.localdomain ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id k6sm41340191pff.106.2022.01.03.15.26.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 15:26:02 -0800 (PST)
From:   Richard Cochran <richardcochran@gmail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Russell King <linux@arm.linux.org.uk>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH RFC V1 net-next 4/4] net: fix up drivers WRT phy time stamping
Date:   Mon,  3 Jan 2022 15:25:55 -0800
Message-Id: <20220103232555.19791-5-richardcochran@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For "git bisect" correctness, this patch should be squashed in to the
previous one, but it is broken out here for the purpose of review.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 23 +++++++++-----------
 drivers/net/ethernet/mscc/ocelot_net.c    | 21 +++++++++---------
 drivers/net/ethernet/ti/cpsw_priv.c       | 12 +++++------
 drivers/net/ethernet/ti/netcp_ethss.c     | 26 +++++------------------
 drivers/net/macvlan.c                     |  4 +---
 5 files changed, 32 insertions(+), 54 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index 796133de527e..2f62990f9ced 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -2935,22 +2935,19 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 	if (!netif_running(ndev))
 		return -EINVAL;
 
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return fep->bufdesc_ex ? fec_ptp_set(ndev, rq) :
+		-EOPNOTSUPP;
+
+	case SIOCGHWTSTAMP:
+		return fep->bufdesc_ex ? fec_ptp_get(ndev, rq) :
+		-EOPNOTSUPP;
+	}
+
 	if (!phydev)
 		return -ENODEV;
 
-	if (fep->bufdesc_ex) {
-		bool use_fec_hwts = !phy_has_hwtstamp(phydev);
-
-		if (cmd == SIOCSHWTSTAMP) {
-			if (use_fec_hwts)
-				return fec_ptp_set(ndev, rq);
-			fec_ptp_disable_hwts(ndev);
-		} else if (cmd == SIOCGHWTSTAMP) {
-			if (use_fec_hwts)
-				return fec_ptp_get(ndev, rq);
-		}
-	}
-
 	return phy_mii_ioctl(phydev, rq, cmd);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 8115c3db252e..d9a0988404d0 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -755,18 +755,19 @@ static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->chip_port;
 
-	/* If the attached PHY device isn't capable of timestamping operations,
-	 * use our own (when possible).
-	 */
-	if (!phy_has_hwtstamp(dev->phydev) && ocelot->ptp) {
-		switch (cmd) {
-		case SIOCSHWTSTAMP:
-			return ocelot_hwstamp_set(ocelot, port, ifr);
-		case SIOCGHWTSTAMP:
-			return ocelot_hwstamp_get(ocelot, port, ifr);
-		}
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return ocelot->ptp ? ocelot_hwstamp_set(ocelot, port, ifr) :
+		-EOPNOTSUPP;
+
+	case SIOCGHWTSTAMP:
+		return ocelot->ptp ? ocelot_hwstamp_get(ocelot, port, ifr) :
+		-EOPNOTSUPP;
 	}
 
+	if (!dev->phydev)
+		return -ENODEV;
+
 	return phy_mii_ioctl(dev->phydev, ifr, cmd);
 }
 
diff --git a/drivers/net/ethernet/ti/cpsw_priv.c b/drivers/net/ethernet/ti/cpsw_priv.c
index 8624a044776f..5825efc6426e 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -713,13 +713,11 @@ int cpsw_ndo_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 
 	phy = cpsw->slaves[slave_no].phy;
 
-	if (!phy_has_hwtstamp(phy)) {
-		switch (cmd) {
-		case SIOCSHWTSTAMP:
-			return cpsw_hwtstamp_set(dev, req);
-		case SIOCGHWTSTAMP:
-			return cpsw_hwtstamp_get(dev, req);
-		}
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return cpsw_hwtstamp_set(dev, req);
+	case SIOCGHWTSTAMP:
+		return cpsw_hwtstamp_get(dev, req);
 	}
 
 	if (phy)
diff --git a/drivers/net/ethernet/ti/netcp_ethss.c b/drivers/net/ethernet/ti/netcp_ethss.c
index 751fb0bc65c5..36ce80f8bd6b 100644
--- a/drivers/net/ethernet/ti/netcp_ethss.c
+++ b/drivers/net/ethernet/ti/netcp_ethss.c
@@ -2557,15 +2557,6 @@ static int gbe_txtstamp_mark_pkt(struct gbe_intf *gbe_intf,
 	    !gbe_dev->tx_ts_enabled)
 		return 0;
 
-	/* If phy has the txtstamp api, assume it will do it.
-	 * We mark it here because skb_tx_timestamp() is called
-	 * after all the txhooks are called.
-	 */
-	if (phy_has_txtstamp(phydev)) {
-		skb_shinfo(p_info->skb)->tx_flags |= SKBTX_IN_PROGRESS;
-		return 0;
-	}
-
 	if (gbe_need_txtstamp(gbe_intf, p_info)) {
 		p_info->txtstamp = gbe_txtstamp;
 		p_info->ts_context = (void *)gbe_intf;
@@ -2583,11 +2574,6 @@ static int gbe_rxtstamp(struct gbe_intf *gbe_intf, struct netcp_packet *p_info)
 	if (p_info->rxtstamp_complete)
 		return 0;
 
-	if (phy_has_rxtstamp(phydev)) {
-		p_info->rxtstamp_complete = true;
-		return 0;
-	}
-
 	if (gbe_dev->rx_ts_enabled)
 		cpts_rx_timestamp(gbe_dev->cpts, p_info->skb);
 
@@ -2821,13 +2807,11 @@ static int gbe_ioctl(void *intf_priv, struct ifreq *req, int cmd)
 	struct gbe_intf *gbe_intf = intf_priv;
 	struct phy_device *phy = gbe_intf->slave->phy;
 
-	if (!phy_has_hwtstamp(phy)) {
-		switch (cmd) {
-		case SIOCGHWTSTAMP:
-			return gbe_hwtstamp_get(gbe_intf, req);
-		case SIOCSHWTSTAMP:
-			return gbe_hwtstamp_set(gbe_intf, req);
-		}
+	switch (cmd) {
+	case SIOCGHWTSTAMP:
+		return gbe_hwtstamp_get(gbe_intf, req);
+	case SIOCSHWTSTAMP:
+		return gbe_hwtstamp_set(gbe_intf, req);
 	}
 
 	if (phy)
diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 6ef5f77be4d0..13264c3e4192 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -1055,9 +1055,7 @@ static int macvlan_ethtool_get_ts_info(struct net_device *dev,
 	const struct ethtool_ops *ops = real_dev->ethtool_ops;
 	struct phy_device *phydev = real_dev->phydev;
 
-	if (phy_has_tsinfo(phydev)) {
-		return phy_ts_info(phydev, info);
-	} else if (ops->get_ts_info) {
+	if (ops->get_ts_info) {
 		return ops->get_ts_info(real_dev, info);
 	} else {
 		info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
-- 
2.20.1

