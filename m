Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395AA53FD7C
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 13:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241918AbiFGL3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 07:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242891AbiFGL27 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 07:28:59 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8C1E98765
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 04:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OW2mn3f+4v7xS7Sye4Y2KnL5XwLQJHgPFv7EAEbLrOs=; b=BX6kXEf1Z2DwsVf0nldM6txW+l
        nhRToQG4GLaUlTzDhpCiM3pxOamUm8ybi00N9zQbPDF8FQuqMDwBv5pK3bn+A/b50mB72ShpxFF3u
        VdeGhuo1mF4Ect2ynY33H8FMNKgT+3oLJxCGo5o36S5Xx1bRfdHk7G+Cq3ADQX5UYgEsEepDXnBcT
        8Wa7GhhQz1ANuSxo7zMtHxdnuTyvrQTTWh2/++g9WMMm2A9yzuB1gQTi3rOJygD3R4pKYBQdeoQIV
        llL7eD+ZqdUZ6qQXITIwJfxG9PTndhWn0iJCKqBREa7zepPAyt1BHyLUQU4yIb1dQ1NLK8vm1lmlp
        57qcKUlw==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:54762 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1nyXOH-0003KN-Ht; Tue, 07 Jun 2022 12:28:53 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1nyXOG-00GPyX-Sy; Tue, 07 Jun 2022 12:28:52 +0100
In-Reply-To: <Yp82TyoLon9jz6k3@shell.armlinux.org.uk>
References: <Yp82TyoLon9jz6k3@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: [PATCH net 3/3] net: dsa: mv88e6xxx: correctly report serdes link
 failure
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1nyXOG-00GPyX-Sy@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 07 Jun 2022 12:28:52 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Phylink wants to know if the link has dropped since the last time state
was retrieved, and the BMSR gives us that. Read the BMSR and use it when
deciding the link state. Fill in the an_complete member as well for the
emulated PHY state.

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/dsa/mv88e6xxx/serdes.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/dsa/mv88e6xxx/serdes.c b/drivers/net/dsa/mv88e6xxx/serdes.c
index 47bf87d530b0..d94150d8f3f4 100644
--- a/drivers/net/dsa/mv88e6xxx/serdes.c
+++ b/drivers/net/dsa/mv88e6xxx/serdes.c
@@ -53,6 +53,14 @@ static int mv88e6xxx_serdes_pcs_get_state(struct mv88e6xxx_chip *chip,
 					  u16 bmsr, u16 lpa, u16 status,
 					  struct phylink_link_state *state)
 {
+	state->link = false;
+
+	/* If the BMSR reports that the link had failed, report this to
+	 * phylink.
+	 */
+	if (!(bmsr & BMSR_LSTATUS))
+		return 0;
+
 	state->link = !!(status & MV88E6390_SGMII_PHY_STATUS_LINK);
 	state->an_complete = !!(bmsr & BMSR_ANEGCOMPLETE);
 
-- 
2.30.2

