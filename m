Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B7F43C609
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 11:04:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241175AbhJ0JGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 05:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241167AbhJ0JGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 05:06:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7751DC061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 02:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=3TgcIBweO7xVl6HKHrs1OzMT/Y39bKCY8oBWIWj+7Kg=; b=SetM8woIpXakNoRShSWf25IdUR
        s9aY6oIx3n92FtJ5rOjb8GXp5W2mOyi+H8PikvT0vdUuxnMyuNYWbU07NUPm5EkV5GScC2Y8ekqY1
        rIqeAZNS/qKXo5bL0LC4CrCrvnu8MdyNMtZq527Ah6/uAdDGnmtKsu33duzXPK4JSo7ycwcwboPcL
        ql+0Q+dRCO63CFKgI+kuEV+VSWsN+v9pPrBxZnjKcsu0hZ/Ag1Gj044tAz/AfRPaIdpXaPIP8bojp
        snOFnYoB+cyYF/EYudeV+S7SBSqiMQ0hsKHOIpaxvsR8w9J+tc7AOW5rH7A0RNmWPYqoB1rjt8OPM
        JVc/Ylyw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34116 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfeqf-0006DB-SZ; Wed, 27 Oct 2021 10:03:53 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mfeqf-001Ts3-FQ; Wed, 27 Oct 2021 10:03:53 +0100
In-Reply-To: <YXkVzx3AM5neUQQH@shell.armlinux.org.uk>
References: <YXkVzx3AM5neUQQH@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        netdev@vger.kernel.org
Subject: [PATCH net-next 3/3] net: mvneta: drop use of
 phylink_helper_basex_speed()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mfeqf-001Ts3-FQ@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 27 Oct 2021 10:03:53 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have a better method to select SFP interface modes, we
no longer need to use phylink_helper_basex_speed() in a driver's
validation function, and we can also get rid of our hack to indicate
both 1000base-X and 2500base-X if the comphy is present to make that
work. Remove this hack and use of phylink_helper_basex_speed().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/marvell/mvneta.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 446cdd496f1b..5a7bdca22a63 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3823,8 +3823,6 @@ static void mvneta_validate(struct phylink_config *config,
 			    unsigned long *supported,
 			    struct phylink_link_state *state)
 {
-	struct net_device *ndev = to_net_dev(config->dev);
-	struct mvneta_port *pp = netdev_priv(ndev);
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
 
 	/* We only support QSGMII, SGMII, 802.3z and RGMII modes.
@@ -3846,11 +3844,12 @@ static void mvneta_validate(struct phylink_config *config,
 	phylink_set(mask, Pause);
 
 	/* Half-duplex at speeds higher than 100Mbit is unsupported */
-	if (pp->comphy || state->interface != PHY_INTERFACE_MODE_2500BASEX) {
+	if (state->interface != PHY_INTERFACE_MODE_2500BASEX) {
 		phylink_set(mask, 1000baseT_Full);
 		phylink_set(mask, 1000baseX_Full);
 	}
-	if (pp->comphy || state->interface == PHY_INTERFACE_MODE_2500BASEX) {
+
+	if (state->interface == PHY_INTERFACE_MODE_2500BASEX) {
 		phylink_set(mask, 2500baseT_Full);
 		phylink_set(mask, 2500baseX_Full);
 	}
@@ -3865,11 +3864,6 @@ static void mvneta_validate(struct phylink_config *config,
 
 	linkmode_and(supported, supported, mask);
 	linkmode_and(state->advertising, state->advertising, mask);
-
-	/* We can only operate at 2500BaseX or 1000BaseX.  If requested
-	 * to advertise both, only report advertising at 2500BaseX.
-	 */
-	phylink_helper_basex_speed(state);
 }
 
 static void mvneta_mac_pcs_get_state(struct phylink_config *config,
-- 
2.30.2

