Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F409A6C3663
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 16:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbjCUP64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 11:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbjCUP6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 11:58:50 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057A41632B
        for <netdev@vger.kernel.org>; Tue, 21 Mar 2023 08:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=7eQFPzmbZICHHPdtBsQLeQaXsm1dWuSlg/J1w5EQ7xc=; b=pS20j6KqsqmKG4r//jqsEj2XU+
        AEfLCyZZzN+b6Yn8Zu/KPfxZee/HmD6cEhnxaKOf41vgrrUbF42Rpq8OScqZfajhdpplXsQg8xZgW
        0b1wCX50kF+aQNo+xfC27UeuMg7JTueo97+kGMuEIKs85oL03XtnEwKv3gxFTIBFbC81M3zaB2mv2
        ucltFH5zktjdxVGz/q4gS5S6OBh0yIqArQsAUIdPa8qNYUKCPZcgMPYxS7M+8BvtEv1Kh4mIss1AF
        nrfzTvYyBGXjbRzOPDFyZOsb8lVyIblX5n2dm++mSeNHMltjibKwFT8q9trJy167WV8d6gi/wqOjn
        Dw0AmS3g==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:56526 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1peeNo-0001Tx-Oz; Tue, 21 Mar 2023 15:58:44 +0000
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1peeNo-00DmhJ-2x; Tue, 21 Mar 2023 15:58:44 +0000
In-Reply-To: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
References: <ZBnT6yW9UY1sAsiy@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jose Abreu <Jose.Abreu@synopsys.com>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH net-next 1/3] net: dpaa2-mac: use Autoneg bit rather than
 an_enabled
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1peeNo-00DmhJ-2x@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Tue, 21 Mar 2023 15:58:44 +0000
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Autoneg bit in the advertising bitmap and state->an_enabled are
always identical. Thus, we will be removing state->an_enabled.

Use the Autoneg bit in the advertising bitmap to indicate whether
autonegotiation should be used, rather than using the an_enabled
member which will be going away. This means we use the same condition
as phylink_mii_c22_pcs_config().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
index c886f33f8c6f..b1871e6c4006 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
@@ -159,7 +159,8 @@ static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
 	struct dpmac_link_state *dpmac_state = &mac->state;
 	int err;
 
-	if (state->an_enabled)
+	if (linkmode_test_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
+			      state->advertising))
 		dpmac_state->options |= DPMAC_LINK_OPT_AUTONEG;
 	else
 		dpmac_state->options &= ~DPMAC_LINK_OPT_AUTONEG;
-- 
2.30.2

