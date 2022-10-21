Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55571607A31
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 17:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbiJUPKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 11:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiJUPKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 11:10:16 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A79D57E4;
        Fri, 21 Oct 2022 08:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Date:Sender:Message-Id:Content-Type:
        Content-Transfer-Encoding:MIME-Version:Subject:Cc:To:From:References:
        In-Reply-To:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=FrqeS3VJw+FPcz82Z8ZW8s1SnKOZDXvq0uXtD4FCNRo=; b=dMqKwHMcH0f+rymxcxYZGyiBYQ
        9Rv61ktnInDexzmbXEOWXU9wDcpddIrs474JEz7HNuBzJRS5Zm+jWQssPPNocrhU+c6OCjvCDqaM7
        KDbogLfepujVWEvhv8CxypmCA55pgk3UsLpseCc3Igatuh64roHATZlDkkSDxvZ4PzsHrV1C0v3Dp
        D98IxkbNhcCHrrFBdTdul4JgFxo60Gl+PPEetCqr3V0Hq43BoRhOuFg5iZDoAmvj6moBaIolXVnOp
        zj3WBdivYTfHp/ipGThBmWHtV9nl7epfSwMFLH5GDTpO7WINl47TQr3Q4GlolmMG66abDAz70lSxj
        /3uJgC4Q==;
Received: from e0022681537dd.dyn.armlinux.org.uk ([fd8f:7570:feb6:1:222:68ff:fe15:37dd]:42526 helo=rmk-PC.armlinux.org.uk)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <rmk@armlinux.org.uk>)
        id 1oltf0-0000NO-CS; Fri, 21 Oct 2022 16:10:10 +0100
Received: from rmk by rmk-PC.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <rmk@rmk-PC.armlinux.org.uk>)
        id 1oltez-00FwxN-Nn; Fri, 21 Oct 2022 16:10:09 +0100
In-Reply-To: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
References: <Y1K17UtfFopACIi2@shell.armlinux.org.uk>
From:   "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net-next 7/7] net: sfp: get rid of DM7052 hack when enabling
 high power
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
Message-Id: <E1oltez-00FwxN-Nn@rmk-PC.armlinux.org.uk>
Sender: Russell King <rmk@armlinux.org.uk>
Date:   Fri, 21 Oct 2022 16:10:09 +0100
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we no longer mis-detect high-power mode with the DM7052 module,
we no longer need the hack in sfp_module_enable_high_power(), and can
now switch this to use sfp_modify_u8().

Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/sfp.c | 29 ++++++-----------------------
 1 file changed, 6 insertions(+), 23 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 921bbedd9b22..39fd1811375c 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -1837,31 +1837,14 @@ static int sfp_module_parse_power(struct sfp *sfp)
 
 static int sfp_sm_mod_hpower(struct sfp *sfp, bool enable)
 {
-	u8 val;
 	int err;
 
-	err = sfp_read(sfp, true, SFP_EXT_STATUS, &val, sizeof(val));
-	if (err != sizeof(val)) {
-		dev_err(sfp->dev, "Failed to read EEPROM: %pe\n", ERR_PTR(err));
-		return -EAGAIN;
-	}
-
-	/* DM7052 reports as a high power module, responds to reads (with
-	 * all bytes 0xff) at 0x51 but does not accept writes.  In any case,
-	 * if the bit is already set, we're already in high power mode.
-	 */
-	if (!!(val & SFP_EXT_STATUS_PWRLVL_SELECT) == enable)
-		return 0;
-
-	if (enable)
-		val |= SFP_EXT_STATUS_PWRLVL_SELECT;
-	else
-		val &= ~SFP_EXT_STATUS_PWRLVL_SELECT;
-
-	err = sfp_write(sfp, true, SFP_EXT_STATUS, &val, sizeof(val));
-	if (err != sizeof(val)) {
-		dev_err(sfp->dev, "Failed to write EEPROM: %pe\n",
-			ERR_PTR(err));
+	err = sfp_modify_u8(sfp, true, SFP_EXT_STATUS,
+			    SFP_EXT_STATUS_PWRLVL_SELECT,
+			    enable ? SFP_EXT_STATUS_PWRLVL_SELECT : 0);
+	if (err != sizeof(u8)) {
+		dev_err(sfp->dev, "failed to %sable high power: %pe\n",
+			enable ? "en" : "dis", ERR_PTR(err));
 		return -EAGAIN;
 	}
 
-- 
2.30.2

