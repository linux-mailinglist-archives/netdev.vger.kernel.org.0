Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3548E60F8A6
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 15:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235618AbiJ0NLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 09:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236081AbiJ0NKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 09:10:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5D5E45206
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 06:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=25SQ/5GtegjhrUEZs5O1w7glDSENYSyiHq9/TL2mEBs=; b=plqRWHU/sY1lYckeL9pCZcNhG1
        MWstgzoJwzcc84fBi//ucDJCGs8MFEMeUi1Rlf72BTF7rcu3v8FA6Dw5pCHUzbqHj9gzM6UE/EJNf
        9khIzY//jaOn5DJ0Bpw32OyEDqV6NR6jfVL635i/dnXUEGVXe3fCXTsXLuvzNSnV5Fzx3t1PlZY0n
        F03UxEW/EL8iNmKO0WQm9SwZtw+aNF/PqtTkwHrGba9+RrXjhSDV8WQncqUutw7g/wM7fvkYPPWzk
        s5LFTsNutpmHPCKJRbyVB6JcplK20T5b4gkX0rTp5gdhEBzTBdjQMK9rUxuuBnyPdHs/CvsFp93VF
        Vnv+h/8g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34978 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oo2ec-0006xT-3Z; Thu, 27 Oct 2022 14:10:38 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oo2eb-00HF7b-Gf; Thu, 27 Oct 2022 14:10:37 +0100
In-Reply-To: <Y1qDMw+DJLAJHT40@shell.armlinux.org.uk>
References: <Y1qDMw+DJLAJHT40@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Frank Wunderlich <frank-w@public-files.de>
Cc:     Eric Dumazet <edumazet@google.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH net-next 01/11] net: phylink: add phylink_get_link_timer_ns()
 helper
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oo2eb-00HF7b-Gf@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 27 Oct 2022 14:10:37 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a helper to convert the PHY interface mode to the required link
timer setting as stated by the appropriate standard. Inappropriate
interface modes return an error.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/linux/phylink.h | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index 63800bf4a7ac..1df3e5e316e8 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -616,6 +616,30 @@ int phylink_speed_up(struct phylink *pl);
 
 void phylink_set_port_modes(unsigned long *bits);
 
+/**
+ * phylink_get_link_timer_ns - return the PCS link timer value
+ * @interface: link &typedef phy_interface_t mode
+ *
+ * Return the PCS link timer setting in nanoseconds for the PHY @interface
+ * mode, or -EINVAL if not appropriate.
+ */
+static inline int phylink_get_link_timer_ns(phy_interface_t interface)
+{
+	switch (interface) {
+	case PHY_INTERFACE_MODE_SGMII:
+	case PHY_INTERFACE_MODE_QSGMII:
+	case PHY_INTERFACE_MODE_USXGMII:
+		return 1600000;
+
+	case PHY_INTERFACE_MODE_1000BASEX:
+	case PHY_INTERFACE_MODE_2500BASEX:
+		return 10000000;
+
+	default:
+		return -EINVAL;
+	}
+}
+
 void phylink_mii_c22_pcs_decode_state(struct phylink_link_state *state,
 				      u16 bmsr, u16 lpa);
 void phylink_mii_c22_pcs_get_state(struct mdio_device *pcs,
-- 
2.30.2

