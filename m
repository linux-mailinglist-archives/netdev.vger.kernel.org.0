Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E21F66D9ED5
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238947AbjDFRdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240049AbjDFRdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:33:41 -0400
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::222])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A8D8A7D
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 10:33:23 -0700 (PDT)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 633D640008;
        Thu,  6 Apr 2023 17:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1680802402;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Vhy97VSl2syCSI5pjgEciGFNAcpGRH/LFxJKqt4JIbw=;
        b=SjBJs0SkVlrJ5wVjrAqUebudjnCj5o4sFW0/lW+dC62qXo+ADj6rtGZoep+nS0i/4FHEOV
        qNSoNVaufo4YNRKjc7wF7xtdXykowUx3a+V0f/mjUGkmoO5nfkuDr1L+qK6ime/OdIWtYv
        hEh4xA94jvtug5kAlEdYGdrNYYEcw3deHzbvZZVubok1a3nwzN5ML11EMWGVwc7lUP+C/n
        6req04AKR2JU2ZzwwnK3R8hlOLzHBKhXTFebkeiJh0e+C7JRUDSgHmM5ZUxNwaUzynz574
        JCYLtAA4LPmL11eERZl8e7pxXb6UTN0UbIrCGeAUHeJbO9wTDluQJX4QPzsfgg==
From:   =?UTF-8?q?K=C3=B6ry=20Maincent?= <kory.maincent@bootlin.com>
To:     netdev@vger.kernel.org
Cc:     kuba@kernel.org, glipus@gmail.com, maxime.chevallier@bootlin.com,
        vladimir.oltean@nxp.com, vadim.fedorenko@linux.dev,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, linux@armlinux.org.uk,
        Kory Maincent <kory.maincent@bootlin.com>
Subject: [PATCH net-next RFC v4 5/5] net: fix up drivers WRT phy time stamping
Date:   Thu,  6 Apr 2023 19:33:08 +0200
Message-Id: <20230406173308.401924-6-kory.maincent@bootlin.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230406173308.401924-1-kory.maincent@bootlin.com>
References: <20230406173308.401924-1-kory.maincent@bootlin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Richard Cochran <richardcochran@gmail.com>

For "git bisect" correctness, this patch should be squashed in to the
previous one, but it is broken out here for the purpose of review.

I will also add the fix up of lan966x driver to validate the netdev
 notifier when the hwtstamp action will be converted to NDO.

Signed-off-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Kory Maincent <kory.maincent@bootlin.com>
---

Notes:
    I will add the lan966x driver update to verify the netdev notifer once
    the replacement to NDO by Max will be done. Also I don't have this hardware
    to test it, it will be useful if someone will be willing to test for me.

 drivers/net/ethernet/freescale/fec_main.c | 23 +++++++++-----------
 drivers/net/ethernet/mscc/ocelot_net.c    | 21 +++++++++---------
 drivers/net/ethernet/ti/cpsw_priv.c       | 12 +++++------
 drivers/net/ethernet/ti/netcp_ethss.c     | 26 +++++------------------
 4 files changed, 31 insertions(+), 51 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index f3b16a6673e2..bc4bfdad83ca 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3213,22 +3213,19 @@ static int fec_enet_ioctl(struct net_device *ndev, struct ifreq *rq, int cmd)
 	if (!netif_running(ndev))
 		return -EINVAL;
 
-	if (!phydev)
-		return -ENODEV;
+	switch (cmd) {
+	case SIOCSHWTSTAMP:
+		return fep->bufdesc_ex ? fec_ptp_set(ndev, rq) :
+		-EOPNOTSUPP;
 
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
+	case SIOCGHWTSTAMP:
+		return fep->bufdesc_ex ? fec_ptp_get(ndev, rq) :
+		-EOPNOTSUPP;
 	}
 
+	if (!phydev)
+		return -ENODEV;
+
 	return phy_mii_ioctl(phydev, rq, cmd);
 }
 
diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 21a87a3fc556..29f7a8a3a4d9 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -873,18 +873,19 @@ static int ocelot_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	struct ocelot *ocelot = priv->port.ocelot;
 	int port = priv->port.index;
 
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
index e966dd47e2db..cec4c65532c4 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.c
+++ b/drivers/net/ethernet/ti/cpsw_priv.c
@@ -715,13 +715,11 @@ int cpsw_ndo_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 
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
index 2adf82a32bf6..6074ce13e130 100644
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
-- 
2.25.1

