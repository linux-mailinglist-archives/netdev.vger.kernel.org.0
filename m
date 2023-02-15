Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF207697982
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 11:08:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232124AbjBOKIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 05:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbjBOKID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 05:08:03 -0500
Received: from relay2-d.mail.gandi.net (relay2-d.mail.gandi.net [217.70.183.194])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3756A5D6
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 02:07:58 -0800 (PST)
Received: (Authenticated sender: kory.maincent@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 982E440007;
        Wed, 15 Feb 2023 10:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1676455677;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=ThZ6uwwAvj2c1RRmiNKUeHoFvmdMycKpcnjr5IbScBc=;
        b=j80AD7aOyuEUW4jjjDUQ0kn5yJavlH2qVo4sjrUhMj43+2T188L2stwY93aRX6VK/UrMsB
        sxO8CFZ+HjTyHGwIpNLDeqF1UKCJetB8Ma3r/XNDj0tJhEkHJPlFv35+ZYCy2D8WQfbCpA
        42JoCqXBkV4NFMlp6UA4XqqIRPfnPWTxElMLzzxTVEGn/E2qwO/jGSkfAXzodToNBacZWq
        2syuFDvkFdR//q5vVkW8kg6BN9NRac31Hk4msvxSrPsfF0G8Klna1yyDsnsW3WbBOs3dLT
        P32+iRkRuri8LdVyujkJVqESPoMd2sgLaangQggKJOOwnLl9vezXYeyzrSx2Uw==
Date:   Wed, 15 Feb 2023 11:07:55 +0100
From:   =?UTF-8?B?S8O2cnk=?= Maincent <kory.maincent@bootlin.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: net: phy: broadcom: error in rxtstamp callback?
Message-ID: <20230215110755.33bb9436@kmaincent-XPS-13-7390>
Organization: bootlin
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I am new to PTP API. I am currently adding the support of PTP to a PHY driver.
I looked at the other PTP supports to do it and I figured out there might be an
issue with the broadcom driver. As I am only beginner in PTP I may have wrong
and if it is the case could you explain me why.
I also don't have such broadcom PHY to test it, but I want to report it if the
issue is real.
The issue is on the rxtstamp callback, it never return true nor deliver the
skb.

Here is the patch that may fix it:

diff --git a/drivers/net/phy/bcm-phy-ptp.c b/drivers/net/phy/bcm-phy-ptp.c
index ef00d6163061..57bb63bd98c7 100644
--- a/drivers/net/phy/bcm-phy-ptp.c
+++ b/drivers/net/phy/bcm-phy-ptp.c
@@ -412,7 +412,9 @@ static bool bcm_ptp_rxtstamp(struct mii_timestamper *mii_ts,
 		__pskb_trim(skb, skb->len - 8);
 	}
 
-	return false;
+	netif_rx(skb);
+
+	return true;
 }
 
 static bool bcm_ptp_get_tstamp(struct bcm_ptp_private *priv,
-- 
2.25.1


Regards,
