Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAD429F0C8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 17:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726028AbgJ2QJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 12:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgJ2QJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 12:09:10 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B013C0613CF
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 09:09:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:Reply-To:Content-ID
        :Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:
        Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Gj30upH9/kEo26IaLq0uisTLNryuTCzVHKmwJEDBErA=; b=XCXVFW4jrNOdVHccWw7xQKuXXV
        0MGWU8CyAZjbinAiCQA0waEunzYnX2s/l+N3Pakg8H6PuvPjAW3JMrmJgjOv+cJefjpZnBC8lI42L
        wAPrH5wUYmYtENJ0IEzGCrjFqLY/7BQf8koL5ICVchllGUI2FWoAp3zEYG1/cv4m+N3Xi/R5wqC36
        +mJMcZR+4ZUA+rwNwGXc2QB54CY8xsTPQUh4SUYYd6k6m9WP5jzohCLFjv9G9nLp9QhFzsFPExjTw
        Tf7c98FZbpYXpbd/o8I3gEd4CTGSVe/LHjaOTcqJTSPQ+fM9aSyzlo5edvIO4li0PoCfCa7A9KCbl
        N0QBSS1g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:44448 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kYAU3-0004cG-BN; Thu, 29 Oct 2020 16:09:03 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1kYAU3-00071C-1G; Thu, 29 Oct 2020 16:09:03 +0000
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] net: dsa: mv88e6xxx: fix vlan setup
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1kYAU3-00071C-1G@rmk-PC.armlinux.org.uk>
Sender: "Russell King,,," <rmk@armlinux.org.uk>
Date:   Thu, 29 Oct 2020 16:09:03 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA assumes that a bridge which has vlan filtering disabled is not
vlan aware, and ignores all vlan configuration. However, the kernel
software bridge code allows configuration in this state.

This causes the kernel's idea of the bridge vlan state and the
hardware state to disagree, so "bridge vlan show" indicates a correct
configuration but the hardware lacks all configuration. Even worse,
enabling vlan filtering on a DSA bridge immediately blocks all traffic
which, given the output of "bridge vlan show", is very confusing.

Allow the VLAN configuration to be updated on Marvell DSA bridges,
otherwise we end up cutting all traffic when enabling vlan filtering.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
This is the revised version of the patch that has been waiting a long
time to fix this issue on the Marvell DSA switches.

 drivers/net/dsa/mv88e6xxx/chip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index bd297ae7cf9e..72340c17f099 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -2851,6 +2851,7 @@ static int mv88e6xxx_setup(struct dsa_switch *ds)
 
 	chip->ds = ds;
 	ds->slave_mii_bus = mv88e6xxx_default_mdio_bus(chip);
+	ds->configure_vlan_while_not_filtering = true;
 
 	mv88e6xxx_reg_lock(chip);
 
-- 
2.20.1

