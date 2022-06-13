Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35773549A1C
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232991AbiFMRfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245179AbiFMRb1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:31:27 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5599113C0BC
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=DHuD+XPPhEhfdGEaBvm4R0GK7WC3L18MMvoWlE8pioQ=; b=jpySJ3eiri4GZSYyh8fqdi4DBr
        /zXPrIeIReOLvjqLC0/JdMdh5MeJv4JNKqZV/ffhL35cy7ViysefyDvn5iz6YBmpgsRYOjVUULgsA
        yVnFZU+T3s0Z+XMWak2hbZn9mVbrlPfdqyTVUqTnxRsDmTEWIpvUYWnsSGKy0PyOEkExGuKXVWB74
        YMMV16f202CqxL3nGs1r6N5ylRa89xQ4yXZ3LkP42X6+igll0H3RTSCZSp9GFUeCuY2XAZYTtTClv
        iQ1d4Cti9dK2UQbFNUcdyWBSHH4mSjUwnUDgRoeXto3/1+mGyNU8InqZtD3seW/VGJOzsRLvS8VEq
        ZiOPIZ1Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52086 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jga-0001rU-61; Mon, 13 Jun 2022 14:00:52 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jgZ-000JYh-Ik; Mon, 13 Jun 2022 14:00:51 +0100
In-Reply-To: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
References: <Yqc0lxn3ngWSuvdS@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Robert Hancock <robert.hancock@calian.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 06/15] net: phylink: add
 pcs_pre_config()/pcs_post_config() methods
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jgZ-000JYh-Ik@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:00:51 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add hooks that are called before and after the mac_config() call,
which will be needed to deal with errata workarounds for the
Marvell 88e639x DSA switches.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 24 ++++++++++++++++++++++++
 include/linux/phylink.h   |  6 ++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index 7721aea73c86..a09a05a0d338 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -763,6 +763,24 @@ static void phylink_resolve_flow(struct phylink_link_state *state)
 	}
 }
 
+static void phylink_pcs_pre_config(struct phylink_pcs *pcs,
+				   phy_interface_t interface)
+{
+	if (pcs && pcs->ops->pcs_pre_config)
+		pcs->ops->pcs_pre_config(pcs, interface);
+}
+
+static int phylink_pcs_post_config(struct phylink_pcs *pcs,
+				   phy_interface_t interface)
+{
+	int err = 0;
+
+	if (pcs && pcs->ops->pcs_post_config)
+		err = pcs->ops->pcs_post_config(pcs, interface);
+
+	return err;
+}
+
 static void phylink_pcs_disable(struct phylink_pcs *pcs)
 {
 	if (pcs && pcs->ops->pcs_disable)
@@ -861,8 +879,14 @@ static void phylink_major_config(struct phylink *pl, bool restart,
 		pl->pcs = pcs;
 	}
 
+	if (pl->pcs)
+		phylink_pcs_pre_config(pl->pcs, state->interface);
+
 	phylink_mac_config(pl, state);
 
+	if (pl->pcs)
+		phylink_pcs_post_config(pl->pcs, state->interface);
+
 	if (pl->pcs_state == PCS_STATE_STARTING || pcs_changed)
 		phylink_pcs_enable(pl->pcs);
 
diff --git a/include/linux/phylink.h b/include/linux/phylink.h
index eece482bce17..e65a4bab0e84 100644
--- a/include/linux/phylink.h
+++ b/include/linux/phylink.h
@@ -434,6 +434,8 @@ struct phylink_pcs {
  * @pcs_validate: validate the link configuration.
  * @pcs_enable: enable the PCS.
  * @pcs_disable: disable the PCS.
+ * @pcs_pre_config: pre-mac_config method (for errata)
+ * @pcs_post_config: post-mac_config method (for arrata)
  * @pcs_get_state: read the current MAC PCS link state from the hardware.
  * @pcs_config: configure the MAC PCS for the selected mode and state.
  * @pcs_an_restart: restart 802.3z BaseX autonegotiation.
@@ -445,6 +447,10 @@ struct phylink_pcs_ops {
 			    const struct phylink_link_state *state);
 	int (*pcs_enable)(struct phylink_pcs *pcs);
 	void (*pcs_disable)(struct phylink_pcs *pcs);
+	void (*pcs_pre_config)(struct phylink_pcs *pcs,
+			       phy_interface_t interface);
+	int (*pcs_post_config)(struct phylink_pcs *pcs,
+			       phy_interface_t interface);
 	void (*pcs_get_state)(struct phylink_pcs *pcs,
 			      struct phylink_link_state *state);
 	int (*pcs_config)(struct phylink_pcs *pcs, unsigned int mode,
-- 
2.30.2

