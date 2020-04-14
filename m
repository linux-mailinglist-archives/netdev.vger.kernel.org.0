Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57EE41A702E
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 02:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390513AbgDNAfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 20:35:13 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:35208 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390458AbgDNAfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Apr 2020 20:35:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=erzT/O8D5jTHF6VlSCjyErjwNoqXQMiel9UmZFHAOT0=; b=do/tsidFu7+xYE7FLqDV44ucGo
        y5qI6GAkKDirmfjvOrp/r3MGGpsTEOOObTjoa1HxWw/j9JXH2letKtp0rEOlccOuReBkNU37Ykut/
        x+0g9LDkjCwVAEkcmVEhL5eTP73/EBuEtTxvtWfv9BkUX2kiLsYUDDGStgHVUo/2rbyE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jO9XW-002Xr0-Hk; Tue, 14 Apr 2020 02:34:58 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net v2 2/2] net: dsa: Down cpu/dsa ports phylink will control
Date:   Tue, 14 Apr 2020 02:34:39 +0200
Message-Id: <20200414003439.606724-3-andrew@lunn.ch>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200414003439.606724-1-andrew@lunn.ch>
References: <20200414003439.606724-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DSA and CPU ports can be configured in two ways. By default, the
driver should configure such ports to there maximum bandwidth. For
most use cases, this is suficient. When this default is insufficient,
a phylink instance can be bound to such ports, and phylink will
configure the port, e.g. based on fixed-link properties. phylink
assumes the port is initially down. Given that the driver should of
already configured it to its maximum speed, ask the driver to down
the port before instantiating the phylink instance.

Fixes: 30c4a5b0aad8 ("net: mv88e6xxx: use resolved link config in mac_link_up()")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/port.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index 231b2d494f1c..a58fdd362574 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -670,11 +670,16 @@ int dsa_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 	struct device_node *phy_np;
+	int port = dp->index;
 
 	if (!ds->ops->adjust_link) {
 		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
-		if (of_phy_is_fixed_link(dp->dn) || phy_np)
+		if (of_phy_is_fixed_link(dp->dn) || phy_np) {
+			if (ds->ops->phylink_mac_link_down)
+				ds->ops->phylink_mac_link_down(ds, port,
+					MLO_AN_FIXED, PHY_INTERFACE_MODE_NA);
 			return dsa_port_phylink_register(dp);
+		}
 		return 0;
 	}
 
-- 
2.26.0

