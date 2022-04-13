Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4CE4FFBD8
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 18:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237099AbiDMQ4d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 12:56:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237098AbiDMQ43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 12:56:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E794C6A009
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 09:54:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=OW2mn3f+4v7xS7Sye4Y2KnL5XwLQJHgPFv7EAEbLrOs=; b=n9lNO09F7ok5Stb2FC2wlmtZFW
        jLN6DMsdTpn+bbEclx5drNQaKeT5bkCzbsO2MfE8efEeROakCTAxK0W6+QYQx9lpNu2KTdqqjyPqJ
        0MFpPaR1ry5XVTfSJeKEhGdRjDHotl1v+SkmOa/rJbuPgk7FCHMyu5snoqaVkOpLDhO24iIHWbDZO
        0syTSiGGaJFEKQeBqJaFS/WcAcX49VhDTxr2crGSE3Dg2sokIJ5ioqfruUmKhIyKxiiriCWEqhpNn
        Oe0XRrqhPgkIiykIISQsWnGb2pqgk8T1Nuvk+naHByqFizyPTkQKgOVzBGAh+bNqMHLOiMQ2CME+H
        sPMrHh/A==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:34514 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1negFn-0003Qm-OJ; Wed, 13 Apr 2022 17:54:03 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1negFm-005tT2-RU; Wed, 13 Apr 2022 17:54:02 +0100
In-Reply-To: <Ylb/vEWXHOmQ7sFd@shell.armlinux.org.uk>
References: <Ylb/vEWXHOmQ7sFd@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH net 3/3] net: dsa: mv88e6xxx: correctly report serdes link
 failure
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1negFm-005tT2-RU@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Wed, 13 Apr 2022 17:54:02 +0100
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

