Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C18BE4B8C04
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 16:06:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235328AbiBPPGR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 10:06:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbiBPPGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 10:06:17 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6432280EE7
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 07:06:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=KWMKhsUdIWWEkP7E2z9OLypjsROexOR6busnO2ztP+M=; b=D+jTSpJv9l9Ui6jtRxaR3OAcJG
        ZKuuQa+7Ub4haFSuGz5cltEehTNKVOHUVhrsYR+2qZSNbSOqa6VDlGrKsQJOD9ayWXmwariEBixH0
        MUX58MStnLOcVmKc/dZNiAlbR4FqniVNTvCylZZSfdUwKYjsyqRJ9aFmL0q61lZAOLg0DCeMedoZC
        sA/HND5AniIn0OMPHEQNxIbrvh5qXsgep8mhlIlS2wNqYqxo6gZcq4MwcoQ0aBifyWGoEoa9Sz2IH
        Ak5zFHEUb6rePun5Imyedy83+41F5IJ4rJylsdzlo3jeQ7dJJNrjs0h3Kd/2tXpL5BaFVwtGZnsRe
        BFR4QLZg==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46578 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nKLsX-0003yi-Lz; Wed, 16 Feb 2022 15:06:01 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nKLsX-009NMX-2e; Wed, 16 Feb 2022 15:06:01 +0000
In-Reply-To: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
References: <Yg0SYHh1YNWsPB1D@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 1/6] net: dsa: add support for phylink
 mac_select_pcs()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nKLsX-009NMX-2e@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 16 Feb 2022 15:06:01 +0000
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DSA support for the phylink mac_select_pcs() method so DSA drivers
can return provide phylink with the appropriate PCS for the PHY
interface mode.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/net/dsa.h |  3 +++
 net/dsa/port.c    | 15 +++++++++++++++
 2 files changed, 18 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index fd1f62a6e0a8..52e2b815605d 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -778,6 +778,9 @@ struct dsa_switch_ops {
 	void	(*phylink_validate)(struct dsa_switch *ds, int port,
 				    unsigned long *supported,
 				    struct phylink_link_state *state);
+	struct phylink_pcs *(*phylink_mac_select_pcs)(struct dsa_switch *ds,
+						      int port,
+						      phy_interface_t iface);
 	int	(*phylink_mac_link_state)(struct dsa_switch *ds, int port,
 					  struct phylink_link_state *state);
 	void	(*phylink_mac_config)(struct dsa_switch *ds, int port,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index bd78192e0e47..1138d40f7897 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1011,6 +1011,20 @@ static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
 	}
 }
 
+static struct phylink_pcs *dsa_port_phylink_mac_select_pcs(
+					struct phylink_config *config,
+					phy_interface_t interface)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+	struct phylink_pcs *pcs = NULL;
+
+	if (ds->ops->phylink_mac_select_pcs)
+		pcs = ds->ops->phylink_mac_select_pcs(ds, dp->index, interface);
+
+	return pcs;
+}
+
 static void dsa_port_phylink_mac_config(struct phylink_config *config,
 					unsigned int mode,
 					const struct phylink_link_state *state)
@@ -1077,6 +1091,7 @@ static void dsa_port_phylink_mac_link_up(struct phylink_config *config,
 
 static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.validate = dsa_port_phylink_validate,
+	.mac_select_pcs = dsa_port_phylink_mac_select_pcs,
 	.mac_pcs_get_state = dsa_port_phylink_mac_pcs_get_state,
 	.mac_config = dsa_port_phylink_mac_config,
 	.mac_an_restart = dsa_port_phylink_mac_an_restart,
-- 
2.30.2

