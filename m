Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B3F43E6BB
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 19:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbhJ1RCq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 13:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbhJ1RCp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 13:02:45 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC19C061570
        for <netdev@vger.kernel.org>; Thu, 28 Oct 2021 10:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=QXxlQcSExTh09ijxffhRtrw9dCyNtlRHr/V+uRKs0Zs=; b=LpD0A3mHmIUTTrZJmZ8KUKIrOG
        0GTP4ePUv6y17sKOH/LDARZSY+mxj9YfWrvnS3/n7jzhKVq1fueLuPOJwghK08YioDWwWjBrpOC1G
        6+fBoAzYmeJVcwKhOtLHuoqh/lFbmoFFsLdciZMVoQfPNpmeIAHNS6PyXZiH94Ese5hGUJP7/LGOw
        0JFmzP7DM1oG3flHWBz8EJw0o2MiTDZ6d52xkuGo215nrZ5gBTHFxO0iRLWnMaeJ4NaMn6EL4ZttK
        cVJH62wGeuScGKWuHmS2QmWGyMw0m/3Owv0XZyb0AVTZMYabUfU0xabAP4N1RvAMetyNiXjORwka/
        6HQygaKQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:46890 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mg8lC-0007oG-Qc; Thu, 28 Oct 2021 18:00:14 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mg8lC-0020Yn-DA; Thu, 28 Oct 2021 18:00:14 +0100
From:   Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next] net: dsa: populate supported_interfaces member
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mg8lC-0020Yn-DA@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Thu, 28 Oct 2021 18:00:14 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>

Add a new DSA switch operation, phylink_get_interfaces, which should
fill in which PHY_INTERFACE_MODE_* are supported by given port.

Use this before phylink_create() to fill phylinks supported_interfaces
member, allowing phylink to determine which PHY_INTERFACE_MODEs are
supported.

Signed-off-by: Marek Behún <kabel@kernel.org>
[tweaked patch and description to add more complete support -- rmk]
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 include/net/dsa.h | 2 ++
 net/dsa/port.c    | 4 ++++
 net/dsa/slave.c   | 4 ++++
 3 files changed, 10 insertions(+)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index badd214f7470..eff5c44ba377 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -645,6 +645,8 @@ struct dsa_switch_ops {
 	/*
 	 * PHYLINK integration
 	 */
+	void	(*phylink_get_interfaces)(struct dsa_switch *ds, int port,
+					  unsigned long *supported_interfaces);
 	void	(*phylink_validate)(struct dsa_switch *ds, int port,
 				    unsigned long *supported,
 				    struct phylink_link_state *state);
diff --git a/net/dsa/port.c b/net/dsa/port.c
index c0e630f7f0bd..f6f12ad2b525 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -1168,6 +1168,10 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 	dp->pl_config.type = PHYLINK_DEV;
 	dp->pl_config.pcs_poll = ds->pcs_poll;
 
+	if (ds->ops->phylink_get_interfaces)
+		ds->ops->phylink_get_interfaces(ds, dp->index,
+					dp->pl_config.supported_interfaces);
+
 	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn),
 				mode, &dsa_port_phylink_mac_ops);
 	if (IS_ERR(dp->pl)) {
diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index db066f0da4b5..ad61f6bc8886 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -1871,6 +1871,10 @@ static int dsa_slave_phy_setup(struct net_device *slave_dev)
 		dp->pl_config.poll_fixed_state = true;
 	}
 
+	if (ds->ops->phylink_get_interfaces)
+		ds->ops->phylink_get_interfaces(ds, dp->index,
+					dp->pl_config.supported_interfaces);
+
 	dp->pl = phylink_create(&dp->pl_config, of_fwnode_handle(port_dn), mode,
 				&dsa_port_phylink_mac_ops);
 	if (IS_ERR(dp->pl)) {
-- 
2.30.2

