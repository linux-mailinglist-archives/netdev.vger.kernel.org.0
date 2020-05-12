Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A70F71CE99D
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 02:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728311AbgELAYq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 20:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728271AbgELAYp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 20:24:45 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A24C061A0E;
        Mon, 11 May 2020 17:24:45 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id s11so1836767pgv.13;
        Mon, 11 May 2020 17:24:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=dEYbJ/apkKt1RV4E2Wk6RjwXb6IDTSOlZnsnmChsm9c=;
        b=jinuh9JhoQT9jLoI6YUJD5olNwY9c+fJ4r1sK9PBqyC9abbIs5wfKhKdKeMSNGOwlB
         K6pQisGu34ViStSDQwf1VmEErqnlXHQY5cHjk1ykfAP/sj44JRkF/eI4Fec1AOVQTGsO
         kch+LeRFVDGiiTdTjKOKCSE8j/XY9GNtSOinICic+qfUSqMYd51Z7y4XDqUJXhyzKKcF
         hahm9nySIHcuk2bF5F1AGrBbDCidUyeH3/uuCSTXW2Ge62YrHWpHRS8jPCQRBzCNqS6l
         xIt4Tel8gJloDt2HqYglvXqoL7+PFLEWXwaksNxMuWJBRw2uLvkWOWznWTD/mDsomOMn
         VFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=dEYbJ/apkKt1RV4E2Wk6RjwXb6IDTSOlZnsnmChsm9c=;
        b=NMWMkDohJNianpR7Alxn4/MZGojP72TPKZEnQbQs/dybEkRytJS6ptb8x+gcmjiZmd
         8YErpMw/rO3cFNOuGE19pFDsfOgVD49q1Bt8RNPCSpYgyXYvuU4a5fJff8s7sj6DeNPv
         yrAA/TAXgieY+YBz71fvCQTQqzA1tjqXsB18Yr1qy3AmZImrHH0SkmF+Nkp6cJ5k0uk+
         iX18wr+IIUgjuWMog2u7/Gsvdr2BB3SEqADjMYw9mkbiBa00Etu7ZfBO/u/NyJXvx8c9
         KNGlbGeU89eD2CIKCrFmsUInzJyXqtL8VwVv1BC3+A4dLFxf+wbzOcF8J0pS7AQkAwVZ
         akYA==
X-Gm-Message-State: AGi0PuYy8h+Y3AnsZRfsr3Ul5kttybFUrglCSCQhoSHbGGozoHj7udSw
        KEWPsf8+dQoApa1JuEwSZBs=
X-Google-Smtp-Source: APiQypLWZ17uTUB87hFoZOPgZEhX8RksU7w3dh+8cvcFxWLldk7ITOGkfWr5kmMNI0/t51F2SZkr/Q==
X-Received: by 2002:a62:ae13:: with SMTP id q19mr19096949pff.310.1589243084538;
        Mon, 11 May 2020 17:24:44 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 23sm9062112pgm.18.2020.05.11.17.24.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 May 2020 17:24:43 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next 2/4] net: add autoneg parameter to linkmode_set_pause
Date:   Mon, 11 May 2020 17:24:08 -0700
Message-Id: <1589243050-18217-3-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This commit introduces a new parameter to linkmode_set_pause to
provide a mechanism to specify two alternative mappings of the
pause parameters for advertisement by the PHY.

An argument is made that the advertisement through Pause and
AsymPause of the desired Rx and Tx pause frame use should be
different depending on whether pause autonegotiation is enabled.

The existing behavior is kept unchanged by setting autoneg=0 in
this new parameter and existing users of the function are made
to do just that.

Fixes: 45c767faef15 ("net: add linkmode helper for setting flow control advertisement")
Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/phy/linkmode.c   | 104 +++++++++++++++++++++++++++++++++----------
 drivers/net/phy/phy_device.c |   3 +-
 drivers/net/phy/phylink.c    |   6 +--
 include/linux/linkmode.h     |   3 +-
 4 files changed, 88 insertions(+), 28 deletions(-)

diff --git a/drivers/net/phy/linkmode.c b/drivers/net/phy/linkmode.c
index f60560fe3499..5658ba9ba94d 100644
--- a/drivers/net/phy/linkmode.c
+++ b/drivers/net/phy/linkmode.c
@@ -48,48 +48,106 @@ EXPORT_SYMBOL_GPL(linkmode_resolve_pause);
  * @advertisement: advertisement in ethtool format
  * @tx: boolean from ethtool struct ethtool_pauseparam tx_pause member
  * @rx: boolean from ethtool struct ethtool_pauseparam rx_pause member
+ * @autoneg: boolean from ethtool struct ethtool_pauseparam autoneg member
  *
  * Configure the advertised Pause and Asym_Pause bits according to the
- * capabilities of provided in @tx and @rx.
+ * capabilities specified by @tx, @rx, and @autoneg.
  *
- * We convert as follows:
+ * If autoneg is true, we convert as follows:
+ *  tx rx  Pause AsymDir
+ *  0  0   0     0
+ *  0  1   1     1
+ *  1  0   0     1
+ *  1  1   1     1
+ *
+ * Otherwise, we convert as follows:
  *  tx rx  Pause AsymDir
  *  0  0   0     0
  *  0  1   1     1
  *  1  0   0     1
  *  1  1   1     0
  *
- * Note: this translation from ethtool tx/rx notation to the advertisement
- * is actually very problematical. Here are some examples:
+ * To the extent that pause frame generation and consumption are defined as
+ * MAC layer functionalities and that the PHY layer should only concern
+ * itself with the advertising of these capabilities, this implementation
+ * is intended to address the problematic behaviors of the previous version
+ * while allowing equivalent behavior when an implementation is unwilling
+ * to negotiate with its peer.
+ *
+ * When autoneg is enabled for pause parameters it indicates a willingness
+ * to negotiate the parameters with a peer. Negotiation implies that a node
+ * is willing to accept a subset of its requested parameters as long as it
+ * is compatible with those requested parameters. This mapping agrees with
+ * the encoding specified in IEEE Std 802.3-2018 by Table 37-2.
+ *
+ * The negotiation is specified in IEEE Std 802.3-2018 by Table 37-4 and
+ * is implemented here by linkmode_resolve_pause.
+ *
+ * Allowing <autoneg=1 tx=1 rx=1> to set both Pause and AsymDir prevents
+ * the previous problematic behaviors as follows:
  *
  * For tx=0 rx=1, meaning transmit is unsupported, receive is supported:
  *
  *  Local device  Link partner
- *  Pause AsymDir Pause AsymDir Result
- *    1     1       1     0     TX + RX - but we have no TX support.
- *    1     1       0     1	Only this gives RX only
+ *  Pause AsymDir Pause AsymDir Result of negotiation at local device
+ *    1     1       0     0	No pause frames allowed
+ *    1     1       0     1	Only RX pause frames allowed
+ *    1     1       1     0	TX + RX pause frames are allowed
+ *    1     1       1     1	TX + RX pause frames are allowed
+ *
+ * While the TX + RX results may seem problematic they are only an
+ * indication that a MAC that receives a pause MAC control frame in the
+ * specified direction will comply with the specified behavior. The tx=0
+ * parameter is made visible to the local MAC layer by the set_pauseparam
+ * ethtool method so it should disable the generation of pause frames at
+ * the MAC layer regardless of what the PHY negotiates.
  *
  * For tx=1 rx=1, meaning we have the capability to transmit and receive
- * pause frames:
+ * pause frames, the results are the same as above. However, now the PHY
+ * negotiation result that reports "Only Rx pause frames allowed" must be
+ * used by the MAC to override the fact that tx=1 so that pause frame
+ * generation is disabled for this combination.
+ *
+ * When autoneg is disabled for pause parameters, it indicates an
+ * unwillingness to negotiate the parameters with a peer. In this case,
+ * the advertisement is more informational and mapping tx=1 rx=1 to only
+ * Symmetric Pause may be a better communication of intent.
  *
  *  Local device  Link partner
- *  Pause AsymDir Pause AsymDir Result
- *    1     0       0     1     Disabled - but since we do support tx and rx,
- *				this should resolve to RX only.
- *
- * Hence, asking for:
- *  rx=1 tx=0 gives Pause+AsymDir advertisement, but we may end up
- *            resolving to tx+rx pause or only rx pause depending on
- *            the partners advertisement.
- *  rx=0 tx=1 gives AsymDir only, which will only give tx pause if
- *            the partners advertisement allows it.
- *  rx=1 tx=1 gives Pause only, which will only allow tx+rx pause
- *            if the other end also advertises Pause.
+ *  Pause AsymDir Pause AsymDir Result of negotiation
+ *    1     0       0     1     Disabled
+ *
+ * This may be considered problematic, since with negotiation it should
+ * be possible for the peer device to send pause frames. However, since
+ * the local device is not willing to negotiate, the result agrees with
+ * a philosophy that the local device wants Symmetric Pause or nothing.
+ * A peer device that is willing to negotiate in this circumstance will
+ * have to fall back to not sending pause frames which may be appropriate
+ * if the local device is not able to support Asymmetric Pause.
+ *
+ * A MAC that has autoneg disabled for pause parameters may choose not
+ * to comply with the mapping returned by linkmode_resolve_pause and rely
+ * purely on the tx and rx values set by the set_pauseparam ethtool
+ * method. However, there is no guarantee of proper functionality and the
+ * burden is placed on the user to "know what they are doing" as is always
+ * the case with manual configuration of network parameters.
+ *
+ * Note: A MAC that is only able to support Symmetric Pause should use the
+ * phy_support_sym_pause function to reflect that in the supported bits.
+ * It should use phy_validate_pause to validate the set_pauseparam values.
+ * If the parameters are valid, this function should be called with
+ * autoneg=0 to advertise its inability to properly negotiate regardless
+ * of the autoneg parameter in the ethtool_pauseparam structure.
  */
-void linkmode_set_pause(unsigned long *advertisement, bool tx, bool rx)
+void linkmode_set_pause(unsigned long *advertisement, bool tx, bool rx,
+			bool autoneg)
 {
 	linkmode_mod_bit(ETHTOOL_LINK_MODE_Pause_BIT, advertisement, rx);
-	linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT, advertisement,
-			 rx ^ tx);
+	if (autoneg)
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				 advertisement, rx | tx);
+	else
+		linkmode_mod_bit(ETHTOOL_LINK_MODE_Asym_Pause_BIT,
+				 advertisement, rx ^ tx);
 }
 EXPORT_SYMBOL_GPL(linkmode_set_pause);
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5a9618ba232e..48ab9efa0166 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2604,7 +2604,8 @@ void phy_set_asym_pause(struct phy_device *phydev, bool rx, bool tx)
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(oldadv);
 
 	linkmode_copy(oldadv, phydev->advertising);
-	linkmode_set_pause(phydev->advertising, tx, rx);
+	/* autoneg=0 to preserve functionality for exisiting users */
+	linkmode_set_pause(phydev->advertising, tx, rx, 0);
 
 	if (!linkmode_equal(oldadv, phydev->advertising) &&
 	    phydev->autoneg)
diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 0f23bec431c1..c544d25ad654 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1489,8 +1489,8 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 
 	/*
 	 * See the comments for linkmode_set_pause(), wrt the deficiencies
-	 * with the current implementation.  A solution to this issue would
-	 * be:
+	 * with the autoneg=0 implementation.  A solution to this issue would
+	 * be to set autoneg=1 to get:
 	 * ethtool  Local device
 	 *  rx  tx  Pause AsymDir
 	 *  0   0   0     0
@@ -1501,7 +1501,7 @@ int phylink_ethtool_set_pauseparam(struct phylink *pl,
 	 * rx/tx pause resolution.
 	 */
 	linkmode_set_pause(config->advertising, pause->tx_pause,
-			   pause->rx_pause);
+			   pause->rx_pause, 0);
 
 	/* If we have a PHY, phylib will call our link state function if the
 	 * mode has changed, which will trigger a resolve and update the MAC
diff --git a/include/linux/linkmode.h b/include/linux/linkmode.h
index c664c27a29a0..7b55a97de162 100644
--- a/include/linux/linkmode.h
+++ b/include/linux/linkmode.h
@@ -92,6 +92,7 @@ void linkmode_resolve_pause(const unsigned long *local_adv,
 			    const unsigned long *partner_adv,
 			    bool *tx_pause, bool *rx_pause);
 
-void linkmode_set_pause(unsigned long *advertisement, bool tx, bool rx);
+void linkmode_set_pause(unsigned long *advertisement, bool tx, bool rx,
+			bool autoneg);
 
 #endif /* __LINKMODE_H */
-- 
2.7.4

