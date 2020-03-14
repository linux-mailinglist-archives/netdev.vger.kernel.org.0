Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB4251856D2
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 02:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgCOBaI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Mar 2020 21:30:08 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:55780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727050AbgCOBaH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Mar 2020 21:30:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Wm5U3gbfur1MD53XUuCmbhwI10XWeSPv9zyJJwQg4uc=; b=imzP89mHtMp0aSEMy+Sxe8J6Uf
        4LjSEsf1WHc9Kg6tGTPHxjvhvEp1EFyFFi5nJUqkJHh981nhhs335WzzkOkBeaQrSMPOh6O8TOLYj
        S94ttEw1CKr/3ZBafLuZV8UXnP+hHao+xQTL5SgPGUKR3s4ESMUXxcEcyUHTJYLnfW5XImtsMOrCJ
        g8BTLw48V2J9TPgiqbCLbc7kkHcDRs2nXsB8R9UK0RAoFA5P10OBne2f5aK+0BxQZltbyCBckvHJf
        QUFNZ0OtG8FJCTke+jXAX4x0yk3vUhREn8Of9mHsMNpxjQONg/i25ZnWhFxSmJ3ZDXoYdKrcwPhuz
        mEh0ptfA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2002:4e20:1eda:1:222:68ff:fe15:37dd]:49338 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3pI-0006BM-Nw; Sat, 14 Mar 2020 10:15:28 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1jD3pI-0006DE-6T; Sat, 14 Mar 2020 10:15:28 +0000
In-Reply-To: <20200314101431.GF25745@shell.armlinux.org.uk>
References: <20200314101431.GF25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 1/8] net: dsa: warn if phylink_mac_link_state returns
 error
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1jD3pI-0006DE-6T@rmk-PC.armlinux.org.uk>
Date:   Sat, 14 Mar 2020 10:15:28 +0000
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Issue a warning to the kernel log if phylink_mac_link_state() returns
an error. This should not occur, but let's make it visible.

Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
---
 net/dsa/port.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/dsa/port.c b/net/dsa/port.c
index e6875d8f944d..a18e65a474a5 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -457,6 +457,7 @@ static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
+	int err;
 
 	/* Only called for inband modes */
 	if (!ds->ops->phylink_mac_link_state) {
@@ -464,8 +465,12 @@ static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
 		return;
 	}
 
-	if (ds->ops->phylink_mac_link_state(ds, dp->index, state) < 0)
+	err = ds->ops->phylink_mac_link_state(ds, dp->index, state);
+	if (err < 0) {
+		dev_err(ds->dev, "p%d: phylink_mac_link_state() failed: %d\n",
+			dp->index, err);
 		state->link = 0;
+	}
 }
 
 static void dsa_port_phylink_mac_config(struct phylink_config *config,
-- 
2.20.1

