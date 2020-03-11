Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5A721181C3F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 16:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729716AbgCKPYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 11:24:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57510 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729473AbgCKPYf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 11:24:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Yu0aXcnXKd1/eSZvsEtqez/Tx/+0ZZbHQYLe/0GvBmw=; b=zrdy1jk03S78lp3aH/44+a5KZn
        KRfSE0nbbHV0A2CuxEgSnVR46IdEeaFk0C+SfZJ/QLD4iJrm04hAlbVuSHpelNrkKJJYzzRNkBxOu
        pZ6jiYvN3DD6sO9lv/UbcWECv4hg3UNUYOZq3LksDj9q6S5n3CD5kV19f2LsXOBeLL8k=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jC3Dk-0004i9-SJ; Wed, 11 Mar 2020 16:24:32 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        ioana.ciornei@nxp.com, olteanv@gmail.com,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH net] net: dsa: Don't instantiate phylink for CPU/DSA ports unless needed
Date:   Wed, 11 Mar 2020 16:24:24 +0100
Message-Id: <20200311152424.18067-1-andrew@lunn.ch>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

By default, DSA drivers should configure CPU and DSA ports to their
maximum speed. In many configurations this is sufficient to make the
link work.

In some cases it is necessary to configure the link to run slower,
e.g. because of limitations of the SoC it is connected to. Or back to
back PHYs are used and the PHY needs to be driven in order to
establish link. In this case, phylink is used.

Only instantiate phylink if it is required. If there is no PHY, or no
fixed link properties, phylink can upset a link which works in the
default configuration.

Fixes: 0e27921816ad ("net: dsa: Use PHYLINK for the CPU/DSA ports")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
---
 net/dsa/port.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index ed7dabb57985..ec13dc666788 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -648,9 +648,14 @@ static int dsa_port_phylink_register(struct dsa_port *dp)
 int dsa_port_link_register_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
+	struct device_node *phy_np;
 
-	if (!ds->ops->adjust_link)
-		return dsa_port_phylink_register(dp);
+	if (!ds->ops->adjust_link) {
+		phy_np = of_parse_phandle(dp->dn, "phy-handle", 0);
+		if (of_phy_is_fixed_link(dp->dn) || phy_np)
+			return dsa_port_phylink_register(dp);
+		return 0;
+	}
 
 	dev_warn(ds->dev,
 		 "Using legacy PHYLIB callbacks. Please migrate to PHYLINK!\n");
@@ -665,11 +670,12 @@ void dsa_port_link_unregister_of(struct dsa_port *dp)
 {
 	struct dsa_switch *ds = dp->ds;
 
-	if (!ds->ops->adjust_link) {
+	if (!ds->ops->adjust_link && dp->pl) {
 		rtnl_lock();
 		phylink_disconnect_phy(dp->pl);
 		rtnl_unlock();
 		phylink_destroy(dp->pl);
+		dp->pl = NULL;
 		return;
 	}
 
-- 
2.25.1

