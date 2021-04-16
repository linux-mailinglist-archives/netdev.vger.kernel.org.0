Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D2E362BFE
	for <lists+netdev@lfdr.de>; Sat, 17 Apr 2021 01:43:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235073AbhDPXoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 19:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235111AbhDPXoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 19:44:12 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9493FC061574;
        Fri, 16 Apr 2021 16:43:47 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id c3so536262pfo.3;
        Fri, 16 Apr 2021 16:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=brzMZZzoip4/bMvEqdJjD4C2HN3Ucvxi1tHmkqgDBtE=;
        b=ccAjGC2R6HUdgHBzrom/EeJihy1BNRqdz9SA9KxuZ5anDN/SlJYBQvinmz09gGXdef
         zh+h4Ow0G5EHavLy0/u/DtajwBaQ4NVMQfwKg3U9O66g5YWykh2D7nP6/iD8ueZejvdY
         y9gvrsiwPc8UwcGibC5c0lYUXsjk6SKY/U61MHnKsc2QubEUnhF9BHxzx5hSiSH3iU90
         ysYBSbCQu1Wsjob5SUgt6Q4GWAU+1ABgtexWpj9VC6YQdZBwJYc4pD6yZV4OCFPaAuMk
         6OMAANBfFeVgNqrcuDs5MnVCI/RPaXQ+p4woZ2kTB7sdkPUlu7W5H2mY8XkMoYNajE+N
         jfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=brzMZZzoip4/bMvEqdJjD4C2HN3Ucvxi1tHmkqgDBtE=;
        b=qCuj04chyKlf45qlevbESBEzTBX1TbIqNa6vIO0kHKhB+wOyeffVAfRoBSpY9EwLS0
         dh68h6GoUTObBSu641penEzWv9c1pbPa8NclJjQ4bo+84iBrGKYpbzFcx8fUMsZGwnAe
         3wr84cmhmJR6i/llIeQ08LLaL2KvZJEgC1kunU0oMRg5dS0y4zkpP88FA7Ax/NnMwQYm
         a+Pax18IMe21R2noAHg0qX8h581lJAAOY+BZJF4Axy7Pf2ijkIo2LEYfmDHINgIloxRh
         33msutUPd2wtVBqGddUlFJy+V9Himd0MYa+JsQH7ZItV33QC1sO6kUwIVFpHiP3g60oj
         ryQg==
X-Gm-Message-State: AOAM533qvUPRsg/fCgMqEBTu994NgvRItK0MG3AIgF1cjUuqXnITinko
        YW2lUP+PLs1dTOmVuv+G5S0=
X-Google-Smtp-Source: ABdhPJwgTbe31odmYDdi1im3pBLV+1h9zpU/idH+cPrmho42I3xlzWB5f0AX/GYbxhxtMxqwR0YghQ==
X-Received: by 2002:a63:220d:: with SMTP id i13mr1293107pgi.446.1618616627166;
        Fri, 16 Apr 2021 16:43:47 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a185sm5623947pfd.70.2021.04.16.16.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 16:43:46 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>
Cc:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 5/5] net: enetc: add support for flow control
Date:   Sat, 17 Apr 2021 02:42:25 +0300
Message-Id: <20210416234225.3715819-6-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210416234225.3715819-1-olteanv@gmail.com>
References: <20210416234225.3715819-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

In the ENETC receive path, a frame received by the MAC is first stored
in a 256KB 'FIFO' memory, then transferred to DRAM when enqueuing it to
the RX ring. The FIFO is a shared resource for all ENETC ports, but
every port keeps track of its own memory utilization, on RX and on TX.

There is a setting for RX rings through which they can either operate in
'lossy' mode (where the lack of a free buffer causes an immediate
discard of the frame) or in 'lossless' mode (where the lack of a free
buffer in the ring makes the frame stay longer in the FIFO).

In turn, when the memory utilization of the FIFO exceeds a certain
margin, the MAC can be configured to emit PAUSE frames.

There is enough FIFO memory to buffer up to 3 MTU-sized frames per RX
port while not jeopardizing the other use cases (jumbo frames), and
also not consume bytes from the port TX allocations. Also, 3 MTU-sized
frames worth of memory is enough to ensure zero loss for 64 byte packets
at 1G line rate.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../ethernet/freescale/enetc/enetc_ethtool.c  | 18 ++++++
 .../net/ethernet/freescale/enetc/enetc_hw.h   |  9 +++
 .../net/ethernet/freescale/enetc/enetc_pf.c   | 60 ++++++++++++++++++-
 3 files changed, 85 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
index 49835e878bbb..ebccaf02411c 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_ethtool.c
@@ -708,6 +708,22 @@ static int enetc_set_wol(struct net_device *dev,
 	return ret;
 }
 
+static void enetc_get_pauseparam(struct net_device *dev,
+				 struct ethtool_pauseparam *pause)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(dev);
+
+	phylink_ethtool_get_pauseparam(priv->phylink, pause);
+}
+
+static int enetc_set_pauseparam(struct net_device *dev,
+				struct ethtool_pauseparam *pause)
+{
+	struct enetc_ndev_priv *priv = netdev_priv(dev);
+
+	return phylink_ethtool_set_pauseparam(priv->phylink, pause);
+}
+
 static int enetc_get_link_ksettings(struct net_device *dev,
 				    struct ethtool_link_ksettings *cmd)
 {
@@ -754,6 +770,8 @@ static const struct ethtool_ops enetc_pf_ethtool_ops = {
 	.get_ts_info = enetc_get_ts_info,
 	.get_wol = enetc_get_wol,
 	.set_wol = enetc_set_wol,
+	.get_pauseparam = enetc_get_pauseparam,
+	.set_pauseparam = enetc_set_pauseparam,
 };
 
 static const struct ethtool_ops enetc_vf_ethtool_ops = {
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_hw.h b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
index 04ac7fc23ead..0f5f081a5baf 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_hw.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc_hw.h
@@ -109,6 +109,7 @@ enum enetc_bdr_type {TX, RX};
 /* RX BDR reg offsets */
 #define ENETC_RBMR	0
 #define ENETC_RBMR_BDS	BIT(2)
+#define ENETC_RBMR_CM	BIT(4)
 #define ENETC_RBMR_VTE	BIT(5)
 #define ENETC_RBMR_EN	BIT(31)
 #define ENETC_RBSR	0x4
@@ -180,6 +181,8 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PSIVLANR(n)	(0x0240 + (n) * 4) /* n = SI index */
 #define ENETC_PSIVLAN_EN	BIT(31)
 #define ENETC_PSIVLAN_SET_QOS(val)	((u32)(val) << 12)
+#define ENETC_PPAUONTR		0x0410
+#define ENETC_PPAUOFFTR		0x0414
 #define ENETC_PTXMBAR		0x0608
 #define ENETC_PCAPR0		0x0900
 #define ENETC_PCAPR0_RXBDR(val)	((val) >> 24)
@@ -227,6 +230,7 @@ enum enetc_bdr_type {TX, RX};
 #define ENETC_PM0_TX_EN		BIT(0)
 #define ENETC_PM0_RX_EN		BIT(1)
 #define ENETC_PM0_PROMISC	BIT(4)
+#define ENETC_PM0_PAUSE_IGN	BIT(8)
 #define ENETC_PM0_CMD_XGLP	BIT(10)
 #define ENETC_PM0_CMD_TXP	BIT(11)
 #define ENETC_PM0_CMD_PHY_TX_EN	BIT(15)
@@ -239,6 +243,11 @@ enum enetc_bdr_type {TX, RX};
 
 #define ENETC_PM_IMDIO_BASE	0x8030
 
+#define ENETC_PM0_PAUSE_QUANTA	0x8054
+#define ENETC_PM0_PAUSE_THRESH	0x8064
+#define ENETC_PM1_PAUSE_QUANTA	0x9054
+#define ENETC_PM1_PAUSE_THRESH	0x9064
+
 #define ENETC_PM0_SINGLE_STEP		0x80c0
 #define ENETC_PM1_SINGLE_STEP		0x90c0
 #define ENETC_PM0_SINGLE_STEP_CH	BIT(7)
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index 1ae2473cbc16..aff1339442cc 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1015,7 +1015,12 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 				 int duplex, bool tx_pause, bool rx_pause)
 {
 	struct enetc_pf *pf = phylink_to_enetc_pf(config);
+	u32 pause_off_thresh = 0, pause_on_thresh = 0;
+	u32 init_quanta = 0, refresh_quanta = 0;
+	struct enetc_hw *hw = &pf->si->hw;
 	struct enetc_ndev_priv *priv;
+	u32 rbmr, cmd_cfg;
+	int idx;
 
 	priv = netdev_priv(pf->si->ndev);
 	if (priv->active_offloads & ENETC_F_QBV)
@@ -1023,9 +1028,60 @@ static void enetc_pl_mac_link_up(struct phylink_config *config,
 
 	if (!phylink_autoneg_inband(mode) &&
 	    phy_interface_mode_is_rgmii(interface))
-		enetc_force_rgmii_mac(&pf->si->hw, speed, duplex);
+		enetc_force_rgmii_mac(hw, speed, duplex);
+
+	/* Flow control */
+	for (idx = 0; idx < priv->num_rx_rings; idx++) {
+		rbmr = enetc_rxbdr_rd(hw, idx, ENETC_RBMR);
+
+		if (tx_pause)
+			rbmr |= ENETC_RBMR_CM;
+		else
+			rbmr &= ~ENETC_RBMR_CM;
+
+		enetc_rxbdr_wr(hw, idx, ENETC_RBMR, rbmr);
+	}
+
+	if (tx_pause) {
+		/* When the port first enters congestion, send a PAUSE request
+		 * with the maximum number of quanta. When the port exits
+		 * congestion, it will automatically send a PAUSE frame with
+		 * zero quanta.
+		 */
+		init_quanta = 0xffff;
+
+		/* Also, set up the refresh timer to send follow-up PAUSE
+		 * frames at half the quanta value, in case the congestion
+		 * condition persists.
+		 */
+		refresh_quanta = 0xffff / 2;
+
+		/* Start emitting PAUSE frames when 3 large frames (or more
+		 * smaller frames) have accumulated in the FIFO waiting to be
+		 * DMAed to the RX ring.
+		 */
+		pause_on_thresh = 3 * ENETC_MAC_MAXFRM_SIZE;
+		pause_off_thresh = 1 * ENETC_MAC_MAXFRM_SIZE;
+	}
+
+	enetc_port_wr(hw, ENETC_PM0_PAUSE_QUANTA, init_quanta);
+	enetc_port_wr(hw, ENETC_PM1_PAUSE_QUANTA, init_quanta);
+	enetc_port_wr(hw, ENETC_PM0_PAUSE_THRESH, refresh_quanta);
+	enetc_port_wr(hw, ENETC_PM1_PAUSE_THRESH, refresh_quanta);
+	enetc_port_wr(hw, ENETC_PPAUONTR, pause_on_thresh);
+	enetc_port_wr(hw, ENETC_PPAUOFFTR, pause_off_thresh);
+
+	cmd_cfg = enetc_port_rd(hw, ENETC_PM0_CMD_CFG);
+
+	if (rx_pause)
+		cmd_cfg &= ~ENETC_PM0_PAUSE_IGN;
+	else
+		cmd_cfg |= ENETC_PM0_PAUSE_IGN;
+
+	enetc_port_wr(hw, ENETC_PM0_CMD_CFG, cmd_cfg);
+	enetc_port_wr(hw, ENETC_PM1_CMD_CFG, cmd_cfg);
 
-	enetc_mac_enable(&pf->si->hw, true);
+	enetc_mac_enable(hw, true);
 }
 
 static void enetc_pl_mac_link_down(struct phylink_config *config,
-- 
2.25.1

