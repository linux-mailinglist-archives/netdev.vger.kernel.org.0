Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0511A702D
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 02:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390507AbgDNAfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 20:35:02 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35194 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390458AbgDNAfC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 20:35:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IVln73sPCPdehqAH74o1fFxPPisB6IcrxXy8DHdY2LI=; b=fSw9VmEo32liLaQTPxE0IbjQS/
        i+6DI7bHC/VD5+HCDSrIR4cplpB2BYFI87rGsHbKo26g/Qa829hMli2JCk7Tk5W+P7obltDEgfO0z
        kl9v/9GXOSwGr3aadTvbsVdzWVZLaplNujbQiEH6ZVNhNvLLxEq+wY7WhcAByotTEYD8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jO9XW-002Xqv-Gz; Tue, 14 Apr 2020 02:34:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net v2 1/2] net: dsa: mv88e6xxx: Configure MAC when using fixed link
Date:   Tue, 14 Apr 2020 02:34:38 +0200
Message-Id: <20200414003439.606724-2-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200414003439.606724-1-andrew@lunn.ch>
References: <20200414003439.606724-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 88e6185 is reporting it has detected a PHY, when a port is
connected to an SFP. As a result, the fixed-phy configuration is not
being applied. That then breaks packet transfer, since the port is
reported as being down.

Add additional conditions to check the interface mode, and if it is
fixed always configure the port on link up/down, independent of the
PPU status.

Fixes: 30c4a5b0aad8 ("net: mv88e6xxx: use resolved link config in mac_link_up()")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 221593261e8f..dd8a5666a584 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -709,7 +709,8 @@ static void mv88e6xxx_mac_link_down(struct dsa_switch *ds, int port,
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	if (!mv88e6xxx_port_ppu_updates(chip, port) && ops->port_set_link)
+	if ((!mv88e6xxx_port_ppu_updates(chip, port) ||
+	     mode == MLO_AN_FIXED) && ops->port_set_link)
 		err = ops->port_set_link(chip, port, LINK_FORCED_DOWN);
 	mv88e6xxx_reg_unlock(chip);
 
@@ -731,7 +732,7 @@ static void mv88e6xxx_mac_link_up(struct dsa_switch *ds, int port,
 	ops = chip->info->ops;
 
 	mv88e6xxx_reg_lock(chip);
-	if (!mv88e6xxx_port_ppu_updates(chip, port)) {
+	if (!mv88e6xxx_port_ppu_updates(chip, port) || mode == MLO_AN_FIXED) {
 		/* FIXME: for an automedia port, should we force the link
 		 * down here - what if the link comes up due to "other" media
 		 * while we're bringing the port up, how is the exclusivity
-- 
2.26.0

