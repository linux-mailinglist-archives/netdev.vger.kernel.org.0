Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 312D4549A32
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbiFMRiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:38:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231731AbiFMRhR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:37:17 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 069C935DCE
        for <netdev@vger.kernel.org>; Mon, 13 Jun 2022 06:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JMyTY1oH4TKLroHA7VXkRRZt2Tvmaw3EOtzPL5HwmSU=; b=KmxYi2h44CDq92FcFcn1XnrrfD
        tXZmADJi4NaDvt13scaOyrPe8KrlFDlkUH58aXtQFsBZx3FZge0ZA0+Q4kU1i3n1EKNG9mNk1HRZi
        DQ5QDECoqyWn96GN75kd4WP+doIjuKSBh159f76F398hmGngD5pJ3BSaG/Q7IVw1Y+1JshhHHdvdU
        Oe1bmp0llA0Y0WzZ8H3gwbqzjyVFIBRq5pBVbrF7zpToZhZF6sLf42hs4DgPcgKJYg5o1mcvrlQ9Z
        XTAq3sEwgcBASjB2bOgZZakmVrpAvcS+mONYAWOx0zsOaF/WMXGZZt6lx5KauhJ2ZATZv3ThQY0d9
        CrMLD9WQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:52092 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1o0jgk-0001ru-Fd; Mon, 13 Jun 2022 14:01:02 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1o0jgj-000JYt-RI; Mon, 13 Jun 2022 14:01:01 +0100
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
Subject: [PATCH net-next 08/15] net: dsa: add support for mac_prepare() and
 mac_finish() calls
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1o0jgj-000JYt-RI@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Mon, 13 Jun 2022 14:01:01 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add DSA support for the phylink mac_prepare() and mac_finish() calls.
These were introduced as part of the PCS support to allow MACs to
perform preparatory steps prior to configuration, and finalisation
steps after the MAC and PCS has been configured.

Introducing phylink_pcs support to the mv88e6xxx DSA driver needs some
code moved out of its mac_config() stage into the mac_prepare() and
mac_finish() stages, and this commit facilitates such code in DSA
drivers.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 include/net/dsa.h |  6 ++++++
 net/dsa/port.c    | 32 ++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 14f07275852b..786e9aa0acce 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -857,9 +857,15 @@ struct dsa_switch_ops {
 						      phy_interface_t iface);
 	int	(*phylink_mac_link_state)(struct dsa_switch *ds, int port,
 					  struct phylink_link_state *state);
+	int	(*phylink_mac_prepare)(struct dsa_switch *ds, int port,
+				       unsigned int mode,
+				       phy_interface_t interface);
 	void	(*phylink_mac_config)(struct dsa_switch *ds, int port,
 				      unsigned int mode,
 				      const struct phylink_link_state *state);
+	int	(*phylink_mac_finish)(struct dsa_switch *ds, int port,
+				      unsigned int mode,
+				      phy_interface_t interface);
 	void	(*phylink_mac_an_restart)(struct dsa_switch *ds, int port);
 	void	(*phylink_mac_link_down)(struct dsa_switch *ds, int port,
 					 unsigned int mode,
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 3738f2d40a0b..8642470c7601 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1447,6 +1447,21 @@ dsa_port_phylink_mac_select_pcs(struct phylink_config *config,
 	return pcs;
 }
 
+static int dsa_port_phylink_mac_prepare(struct phylink_config *config,
+					unsigned int mode,
+					phy_interface_t interface)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+	int err = 0;
+
+	if (ds->ops->phylink_mac_prepare)
+		err = ds->ops->phylink_mac_prepare(ds, dp->index, mode,
+						   interface);
+
+	return err;
+}
+
 static void dsa_port_phylink_mac_config(struct phylink_config *config,
 					unsigned int mode,
 					const struct phylink_link_state *state)
@@ -1460,6 +1475,21 @@ static void dsa_port_phylink_mac_config(struct phylink_config *config,
 	ds->ops->phylink_mac_config(ds, dp->index, mode, state);
 }
 
+static int dsa_port_phylink_mac_finish(struct phylink_config *config,
+				       unsigned int mode,
+				       phy_interface_t interface)
+{
+	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
+	struct dsa_switch *ds = dp->ds;
+	int err = 0;
+
+	if (ds->ops->phylink_mac_finish)
+		err = ds->ops->phylink_mac_finish(ds, dp->index, mode,
+						  interface);
+
+	return err;
+}
+
 static void dsa_port_phylink_mac_an_restart(struct phylink_config *config)
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
@@ -1515,7 +1545,9 @@ static const struct phylink_mac_ops dsa_port_phylink_mac_ops = {
 	.validate = dsa_port_phylink_validate,
 	.mac_select_pcs = dsa_port_phylink_mac_select_pcs,
 	.mac_pcs_get_state = dsa_port_phylink_mac_pcs_get_state,
+	.mac_prepare = dsa_port_phylink_mac_prepare,
 	.mac_config = dsa_port_phylink_mac_config,
+	.mac_finish = dsa_port_phylink_mac_finish,
 	.mac_an_restart = dsa_port_phylink_mac_an_restart,
 	.mac_link_down = dsa_port_phylink_mac_link_down,
 	.mac_link_up = dsa_port_phylink_mac_link_up,
-- 
2.30.2

