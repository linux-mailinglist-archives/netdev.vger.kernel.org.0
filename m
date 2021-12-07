Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 674E946BFFD
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 16:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239205AbhLGP52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 10:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239246AbhLGP50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 10:57:26 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA77DC061748
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 07:53:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=rpy6FaOe9RGrPhtpfYnS/RbUFcY4mdSxqY7pjxyjyvI=; b=EmJai02w1cU0gexxr+1yhQw3EL
        vnZXp/8VJvS1zXurhHjcUbN8rEmm8CgdTxZlET7ghMyLGOe1cK2dXQcLNBB0sdOpnGaCJfoFRFS/j
        hiqtbQ1dnTzPaGfmqJrdFBzoAVsSobOnw3eYFEKNRk5M3digmexrqzPKQcV4BNCfp2f61Cjfl5ya3
        58smfGncwwbaz1HcMyMv6Tm5siyBg3pqimgaePP5L9dH1AkiRlF8tyeib4DexM/DTmobIQQXdfL0l
        fcBULI1JaoCimaKH3U0sG0lHCc/K0Rw34iq2kIMtZLWV8jKo5f4K1pYlv4cvkrKkpwM1EGx0dwQ7R
        qkDN+/lA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56788 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mucmv-0006Pd-EA; Tue, 07 Dec 2021 15:53:53 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mucmu-00EyD4-Vy; Tue, 07 Dec 2021 15:53:53 +0000
In-Reply-To: <DGaGmGgWrlVkW@shell.armlinux.org.uk>
References: <DGaGmGgWrlVkW@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 4/5] net: phylink: use legacy_pre_march2020
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mucmu-00EyD4-Vy@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 07 Dec 2021 15:53:52 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the legacy flag to indicate whether we should operate in legacy
mode. This allows us to stop using the presence of a PCS as an
indicator to the age of the phylink user, and make PCS presence
optional.

Legacy mode involves:
1) calling mac_config() whenever the link comes up
2) calling mac_config() whenever the inband advertisement changes,
   possibly followed by a call to mac_an_restart()
3) making use of mac_an_restart()
4) making use of mac_pcs_get_state()

All the above functionality was moved to a seperate "PCS" block of
operations in March 2020.

Update the documents to indicate that the differences that this flag
makes.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 12 ++++++------
 include/linux/phylink.h   | 17 +++++++++++++++++
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 8e3861f09b4f..e47f2baf4b07 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -742,7 +742,7 @@ static void phylink_mac_pcs_an_restart(struct phylink *pl)
 	    phylink_autoneg_inband(pl->cur_link_an_mode)) {
 		if (pl->pcs_ops)
 			pl->pcs_ops->pcs_an_restart(pl->pcs);
-		else
+		else if (pl->config->legacy_pre_march2020)
 			pl->mac_ops->mac_an_restart(pl->config);
 	}
 }
@@ -803,7 +803,7 @@ static int phylink_change_inband_advert(struct phylink *pl)
 	if (test_bit(PHYLINK_DISABLE_STOPPED, &pl->phylink_disable_state))
 		return 0;
 
-	if (!pl->pcs_ops) {
+	if (!pl->pcs_ops && pl->config->legacy_pre_march2020) {
 		/* Legacy method */
 		phylink_mac_config(pl, &pl->link_config);
 		phylink_mac_pcs_an_restart(pl);
@@ -854,7 +854,8 @@ static void phylink_mac_pcs_get_state(struct phylink *pl,
 
 	if (pl->pcs_ops)
 		pl->pcs_ops->pcs_get_state(pl->pcs, state);
-	else if (pl->mac_ops->mac_pcs_get_state)
+	else if (pl->mac_ops->mac_pcs_get_state &&
+		 pl->config->legacy_pre_march2020)
 		pl->mac_ops->mac_pcs_get_state(pl->config, state);
 	else
 		state->link = 0;
@@ -1048,12 +1049,11 @@ static void phylink_resolve(struct work_struct *w)
 			}
 			phylink_major_config(pl, false, &link_state);
 			pl->link_config.interface = link_state.interface;
-		} else if (!pl->pcs_ops) {
+		} else if (!pl->pcs_ops && pl->config->legacy_pre_march2020) {
 			/* The interface remains unchanged, only the speed,
 			 * duplex or pause settings have changed. Call the
 			 * old mac_config() method to configure the MAC/PCS
-			 * only if we do not have a PCS installed (an
-			 * unconverted user.)
+			 * only if we do not have a legacy MAC driver.
 			 */
 			phylink_mac_config(pl, &link_state);
 		}
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index d005b8e36048..a2f266cc3442 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -190,6 +190,10 @@ void validate(struct phylink_config *config, unsigned long *supported,
  * negotiation completion state in @state->an_complete, and link up state
  * in @state->link. If possible, @state->lp_advertising should also be
  * populated.
+ *
+ * Note: This is a legacy method. This function will not be called unless
+ * legacy_pre_march2020 is set in &struct phylink_config and there is no
+ * PCS attached.
  */
 void mac_pcs_get_state(struct phylink_config *config,
 		       struct phylink_link_state *state);
@@ -230,6 +234,15 @@ int mac_prepare(struct phylink_config *config, unsigned int mode,
  * guaranteed to be correct, and so any mac_config() implementation must
  * never reference these fields.
  *
+ * Note: For legacy March 2020 drivers (drivers with legacy_pre_march2020 set
+ * in their &phylnk_config and which don't have a PCS), this function will be
+ * called on each link up event, and to also change the in-band advert. For
+ * non-legacy drivers, it will only be called to reconfigure the MAC for a
+ * "major" change in e.g. interface mode. It will not be called for changes
+ * in speed, duplex or pause modes or to change the in-band advertisement.
+ * In any case, it is strongly preferred that speed, duplex and pause settings
+ * are handled in the mac_link_up() method and not in this method.
+ *
  * (this requires a rewrite - please refer to mac_link_up() for situations
  *  where the PCS and MAC are not tightly integrated.)
  *
@@ -314,6 +327,10 @@ int mac_finish(struct phylink_config *config, unsigned int mode,
 /**
  * mac_an_restart() - restart 802.3z BaseX autonegotiation
  * @config: a pointer to a &struct phylink_config.
+ *
+ * Note: This is a legacy method. This function will not be called unless
+ * legacy_pre_march2020 is set in &struct phylink_config and there is no
+ * PCS attached.
  */
 void mac_an_restart(struct phylink_config *config);
 
-- 
2.30.2

