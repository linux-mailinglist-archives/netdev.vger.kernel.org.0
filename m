Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A6CB63F9D9
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 22:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231129AbiLAVbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 16:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230127AbiLAVbW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 16:31:22 -0500
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D73BA6B6F
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 13:31:21 -0800 (PST)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id DD6A588;
        Thu,  1 Dec 2022 22:31:19 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1669930279;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qfEYUsGv5LHSnAXTXYv80m+wnEHVstGAKrLjI8Ln92g=;
        b=XNR/GkJZJitmXWuowOLatw1Z1a+1VyKeTLwNI5f0FYe8OuiBY4Rywe2ZHXgo2bvEuM6oQ3
        UFB47TdIOMngJNtnJaojfT9ZrtiPwsvXXI66819JrGX+Q+L4DcigZbrCb1/H7D/dAwz8WE
        vq/ffjYgzLZ5vQ4wb1AQ0sRdRSOLVvV9wCRH0cAF3btB6mD4ytPmClfgDTTPVmVyecka4j
        V6cpuq3itpgLIZfBHNh/CkcgHB2OJUBa4WALWLDotGStOM3pbwBfcPtFxFa+JiafW0+GBB
        ir9MyuCszoa0VLRUH0Yvdfooz9HL24WscMo+T5pQjpzClzh9WCDd5U8rDBhiiw==
MIME-Version: 1.0
Date:   Thu, 01 Dec 2022 22:31:19 +0100
From:   Michael Walle <michael@walle.cc>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org, Xu Liang <lxu@maxlinear.com>
Subject: Re: GPY215 PHY interrupt issue
In-Reply-To: <Y4jOMocoLneO8xoD@lunn.ch>
References: <fd1352e543c9d815a7a327653baacda7@walle.cc>
 <Y4DcoTmU3nWqMHIp@lunn.ch> <baa468f15c6e00c0f29a31253c54383c@walle.cc>
 <Y4S4EfChuo0wmX2k@lunn.ch> <c69e1d1d897dd7500b59c49f0873e7dd@walle.cc>
 <Y4jOMocoLneO8xoD@lunn.ch>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <158870dd20a5e30cda9f17009aa0c6c8@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-12-01 16:54, schrieb Andrew Lunn:
>> So, switching the line to GPIO input doesn't help here, which also
>> means the interrupt line will be stuck the whole time.
> 
> Sounds like they totally messed up the design somehow.
> 
> Since we are into horrible hack territory.....
> 
> I assume you are using the Link state change interrupt? LSTC?

Yes, but recently I've found it that it also happens with
the speed change interrupt (during link-up). By pure luck (or
bad luck really?) I discovered that when I reduce the MDIO
frequency I get a similar behavior for the interrupt line
at link-up with the LSPC interrupt. I don't think it has
something to do with the frequency but with changed timing.
Anyway, I need to do the workaround for LTSC and for LSPC...

At the moment I have the following, which works:

@@ -560,6 +610,8 @@ static int gpy_config_intr(struct phy_device 
*phydev)

  static irqreturn_t gpy_handle_interrupt(struct phy_device *phydev)
  {
+	bool needs_mdint_wa = phydev->drv->phy_id == PHY_ID_GPY215B ||
+			     phydev->drv->phy_id == PHY_ID_GPY215C;
  	int reg;

  	reg = phy_read(phydev, PHY_ISTAT);
@@ -571,6 +623,23 @@ static irqreturn_t gpy_handle_interrupt(struct 
phy_device *phydev)
  	if (!(reg & PHY_IMASK_MASK))
  		return IRQ_NONE;

+	/* The PHY might leave the interrupt line asserted even after 
PHY_ISTAT
+	* is read. To avoid interrupt storms, delay the interrupt handling as
+	* long as the PHY drives the interrupt line. An internal bus read will
+	* stall as long as the interrupt line is asserted, thus just read a
+	* random register here.
+	* Because we cannot access the internal bus at all while the interrupt
+	* is driven by the PHY, there is no way to make the interrupt line
+	* unstuck (e.g. by changing the pinmux to GPIO input) during that time
+	* frame. Therefore, polling is the best we can do and won't do any 
more
+	* harm.
+	* It was observed that this bug happens on link state and link speed
+	* changes on a GPY215B and GYP215C independent of the firmware version
+	* (which doesn't mean that this list is exhaustive).
+	*/
+	if (needs_mdint_wa && (reg & (PHY_IMASK_LSTC | PHY_IMASK_LSPC)))
+		gpy_mbox_read(phydev, REG_GPIO0_OUT);
+
  	phy_trigger_machine(phydev);

  	return IRQ_HANDLED;

> Maybe instead use Link speed change and Duplex mode change? And
> disallow 10/Half. Some PHYs change to 10/Half when they loose
> link. They might be enough to tell you the link has changed. You can
> then read the BMSR to find out what actually happened.
> 
> This is assuming that interrupts in general are not FUBAR.

It seems like at least these two are :/ So with the code above
we could avoid the interrupt storm but we can't do anything about
the blocked interrupt line. I'm unsure if that is acceptable or
if we'd have to disable interrupts on this PHY altogether and
fallback to polling.

-michael
