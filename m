Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEFCE459FB1
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 11:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbhKWKEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 05:04:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231838AbhKWKEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 05:04:02 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A90EC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 02:00:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=4XNr7BR/5TNI3l9M9GhQTw+9AcyHIzcldXrTiciICEw=; b=jtOBoFyYnUmDSM0C8Gihatnao6
        TgqKkjPtCU/0kY0uDkGtR2xUUpuZw6hVB8DqU5UEwVddwdE9HXIkjXDjEszFHCTaON4CA4M1Qgde5
        8KVaRHKIPeh+I44LXgCFtpCa/cWvz7I0l91zc51+svkQ8GxyhK+nzalacD6KftHgmIrSTT6ozgyJF
        cbu/pKRjcF8XSRRs0XPZE3+h8iC8oDOuEvAI4VN18qsx2qmyNd6pbZpl/dfd7gVi6k+g/H7RcfCa3
        TeC5Co3htPtyuk/pd5QFiJeSlEarIotL2OPlf2uE9Aly6X5NlbG23dPFt6QqDeiQp7t9/HsofV5TB
        LICt3ikQ==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:36056 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpSba-0007jX-Oe; Tue, 23 Nov 2021 10:00:50 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1mpSba-00BXp6-9e; Tue, 23 Nov 2021 10:00:50 +0000
In-Reply-To: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
References: <YZy59OTNCpKoPZT/@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Chris Snook <chris.snook@gmail.com>, Felix Fietkau <nbd@nbd.name>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Subject: [PATCH RFC net-next 8/8] net: phylink: allow PCS to be removed
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1mpSba-00BXp6-9e@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 23 Nov 2021 10:00:50 +0000
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Allow phylink_set_pcs() to be called with a NULL pcs argument to remove
the PCS from phylink. This is only supported on non-legacy drivers
where doing so will have no effect on the mac_config() calling
behaviour.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
index a935655c39c0..9f0f0e0aad55 100644
--- a/drivers/net/phy/phylink.c
+++ b/drivers/net/phy/phylink.c
@@ -1196,15 +1196,25 @@ EXPORT_SYMBOL_GPL(phylink_create);
  * in mac_prepare() or mac_config() methods if it is desired to dynamically
  * change the PCS.
  *
- * Please note that there are behavioural changes with the mac_config()
- * callback if a PCS is present (denoting a newer setup) so removing a PCS
- * is not supported, and if a PCS is going to be used, it must be registered
- * by calling phylink_set_pcs() at the latest in the first mac_config() call.
+ * Please note that for legacy phylink users, there are behavioural changes
+ * with the mac_config() callback if a PCS is present (denoting a newer setup)
+ * so removing a PCS is not supported. If a PCS is going to be used, it must
+ * be registered by calling phylink_set_pcs() at the latest in the first
+ * mac_config() call.
+ *
+ * For modern drivers, this may be called with a NULL pcs argument to
+ * disconnect the PCS from phylink.
  */
 void phylink_set_pcs(struct phylink *pl, struct phylink_pcs *pcs)
 {
+	if (pl->config->legacy_pre_march2020 && pl->pcs && !pcs) {
+		phylink_warn(pl,
+			     "Removing PCS is not supported in a legacy driver");
+		return;
+	}
+
 	pl->pcs = pcs;
-	pl->pcs_ops = pcs->ops;
+	pl->pcs_ops = pcs ? pcs->ops : NULL;
 }
 EXPORT_SYMBOL_GPL(phylink_set_pcs);
 
-- 
2.30.2

