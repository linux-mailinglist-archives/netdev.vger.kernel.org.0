Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF64D17A571
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 13:42:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgCEMm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 07:42:26 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:39952 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbgCEMmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 07:42:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=53VIeLv1S/gt1pH40u0yQ8eO1/ZqA+Idyrt6cgVGg7k=; b=l19GGV8JqsRYOCgvlj/kg5voCn
        ncYJjUCWuPmE/mDPFRM4gAZ4xoDlofOAyvF07UdfeJyNHF2zBoWnWvfXEacfivg75RPFz//bJ5QYc
        bPVIfWkemvHP4a9KmaxlkbBKd+ZTp4EBQxrJDpjRKAal/og34fMxQZiBfs/zKCKL+MtvaWowNisP5
        u6d6DK7k0HFcQ93z/uer0gcbhhgD3ciE5k8phYprrCy9e0qibkaEyECi/lREhJJNlJm372Dd7Hgpd
        /+/b598AQoNU7/Ap0r21FIS4Ny9HkJEo76MHHFv1XSjyHIIM92vo7BIfn7BfZlrgZA0SMO/me0Lnj
        aHZSSRxA==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([2001:4d48:ad52:3201:222:68ff:fe15:37dd]:42986 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ppR-0006R6-PF; Thu, 05 Mar 2020 12:42:17 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1j9ppQ-000721-9Q; Thu, 05 Mar 2020 12:42:16 +0000
In-Reply-To: <20200305124139.GB25745@shell.armlinux.org.uk>
References: <20200305124139.GB25745@shell.armlinux.org.uk>
From:   Russell King <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/10] net: dsa: warn if phylink_mac_link_state
 returns error
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1j9ppQ-000721-9Q@rmk-PC.armlinux.org.uk>
Date:   Thu, 05 Mar 2020 12:42:16 +0000
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
index d4450a454249..ef5ea18dc5bb 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -433,6 +433,7 @@ static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
 {
 	struct dsa_port *dp = container_of(config, struct dsa_port, pl_config);
 	struct dsa_switch *ds = dp->ds;
+	int err;
 
 	/* Only called for inband modes */
 	if (!ds->ops->phylink_mac_link_state) {
@@ -440,8 +441,12 @@ static void dsa_port_phylink_mac_pcs_get_state(struct phylink_config *config,
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

