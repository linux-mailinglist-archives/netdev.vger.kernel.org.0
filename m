Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B374A8E8
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 19:57:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729884AbfFRR5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 13:57:25 -0400
Received: from Galois.linutronix.de ([146.0.238.70]:48485 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729647AbfFRR5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 13:57:25 -0400
Received: from [5.158.153.53] (helo=nereus.lab.linutronix.de.)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hdIMF-0006l3-AV; Tue, 18 Jun 2019 19:57:23 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Benedikt Spranger <b.spranger@linutronix.de>
Subject: [RFC PATCH 1/2] net: dsa: b53: Turn on managed mode and set IMP port
Date:   Tue, 18 Jun 2019 19:57:11 +0200
Message-Id: <20190618175712.71148-2-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.19.0
In-Reply-To: <20190618175712.71148-1-b.spranger@linutronix.de>
References: <20190618175712.71148-1-b.spranger@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

When enabling Broadcom tags on earlier devices such as BCM53125, we need
to also enable Managed mode, as well as configure which port is going to
be the IMP port. If we did not do that, the switch would just pass
through the Broadcom tags on the wire and not act on them. We need to
have bcm_sf2 stop overwriting the SWMODE register and let b53 deal with
that now.

Fixes: 7edc58d614d4 ("net: dsa: b53: Turn on Broadcom tags")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Benedikt Spranger <b.spranger@linutronix.de>
---
 drivers/net/dsa/b53/b53_common.c | 19 +++++++++++++++----
 drivers/net/dsa/bcm_sf2.c        |  3 ---
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index c8040ecf4425..06b9a7a81ae0 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -331,9 +331,9 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 	b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_MODE, &mgmt);
 
 	if (enable)
-		mgmt |= SM_SW_FWD_EN;
+		mgmt |= SM_SW_FWD_EN | SM_SW_FWD_MODE;
 	else
-		mgmt &= ~SM_SW_FWD_EN;
+		mgmt &= ~(SM_SW_FWD_EN | SM_SW_FWD_MODE);
 
 	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_MODE, mgmt);
 
@@ -364,8 +364,6 @@ static void b53_enable_vlan(struct b53_device *dev, bool enable,
 		b53_read8(dev, B53_VLAN_PAGE, B53_VLAN_CTRL5, &vc5);
 	}
 
-	mgmt &= ~SM_SW_FWD_MODE;
-
 	if (enable) {
 		vc0 |= VC0_VLAN_EN | VC0_VID_CHK_EN | VC0_VID_HASH_VID;
 		vc1 |= VC1_RX_MCST_UNTAG_EN | VC1_RX_MCST_FWD_EN;
@@ -589,6 +587,19 @@ void b53_brcm_hdr_setup(struct dsa_switch *ds, int port)
 		hdr_ctl &= ~val;
 	b53_write8(dev, B53_MGMT_PAGE, B53_BRCM_HDR, hdr_ctl);
 
+	/* Set IMP port number, necessary for Broadcom tags to be used
+	 * while in managed mode
+	 */
+	if (tag_en) {
+		b53_read8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, &hdr_ctl);
+		hdr_ctl &= ~GC_FRM_MGMT_PORT_M;
+		val = 0;
+		if (port == 8)
+			val = GC_FRM_MGMT_PORT_MII;
+		hdr_ctl |= val;
+		b53_write8(dev, B53_MGMT_PAGE, B53_GLOBAL_CONFIG, hdr_ctl);
+	}
+
 	/* Registers below are only accessible on newer devices */
 	if (!is58xx(dev))
 		return;
diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index 3811fdbda13e..47f55dab14f6 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -53,9 +53,6 @@ static void bcm_sf2_imp_setup(struct dsa_switch *ds, int port)
 	reg &= ~(RX_DIS | TX_DIS);
 	core_writel(priv, reg, CORE_IMP_CTL);
 
-	/* Enable forwarding */
-	core_writel(priv, SW_FWDG_EN, CORE_SWMODE);
-
 	/* Enable IMP port in dumb mode */
 	reg = core_readl(priv, CORE_SWITCH_CTRL);
 	reg |= MII_DUMB_FWDG_EN;
-- 
2.19.0

