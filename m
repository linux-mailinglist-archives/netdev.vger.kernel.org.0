Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C49F4ADC1A
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 16:12:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240878AbiBHPL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 10:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbiBHPLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 10:11:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1552C061576
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 07:11:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=RkGA/gtuh4Sw+Wbu2l3BlwmUX5qxEfffyNTQyTbl6g0=; b=xu1200as+FlC3SjWcP852Sspk5
        PMrpGt7iqElmHWc+JNYwLotg0Tw80Vt4TqHiluyGFR7y1vS1e1ZHjh4i/KEfCTyzGZHIpNKLggtS5
        nB49tUOZGAwC+Z9K2gJc3vq0cnnWLxMgQOBfV8Out1jo+DCLrl7qlOCKS3dkdFSEXNwG72lLtWuif
        +siRAvX9sGkReHCP/XAW3gZ3a4hX3EiUYgKe6dmEmfK+bHHvMIPdzPtuLaF0/XppnPf5pWx2k5F5k
        F6TBcqp17Dpu6FUnxKT+c6T+BG6xUaseRuj0rYHlrGg7Td9YsAwf6W/wk7OsdLrAeBsqFYcLhEiu2
        M7Abz68Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:38402 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nHS9n-0003IG-Ch; Tue, 08 Feb 2022 15:11:51 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nHS9m-0070ZB-Pf; Tue, 08 Feb 2022 15:11:50 +0000
In-Reply-To: <YgKIIq2baq4yERS5@shell.armlinux.org.uk>
References: <YgKIIq2baq4yERS5@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH CFT net-next 1/6] net: dsa: add support for phylink
 mac_select_pcs()
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nHS9m-0070ZB-Pf@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 08 Feb 2022 15:11:50 +0000
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
index ca8c14b547b4..2766bf927b3f 100644
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

