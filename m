Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B265816D4
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 17:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiGZPzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 11:55:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239348AbiGZPz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 11:55:27 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E2821B
        for <netdev@vger.kernel.org>; Tue, 26 Jul 2022 08:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XHt64zgcnACsdDepfHwPLc9n0RXBCUPTpdOr5cl5MWw=; b=qE8bl4fFXqkNojSIm6GuQfDCw2
        zsWYRsgZ8P2zpCJvPHwok3SjTPGMYduNHhVoN3HxZDyCS0kZhklS6ZYofx391wxNdQmJFWjxTNs8X
        jTYzXQEsTRXBq8Z96u50Zrs7zKRYQ7lkKXghlFgBbyMVJmPwBDOF+LYfNS2lrvulyZVI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oGMu2-00BZme-BR; Tue, 26 Jul 2022 17:55:22 +0200
Date:   Tue, 26 Jul 2022 17:55:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gilles BULOZ <gilles.buloz@kontron.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell 88E1512 PHY LED2 mode mismatch with Elkhartlake pin mode
Message-ID: <YuAOao5X5kj87dt2@lunn.ch>
References: <3f6a37ab-c346-b53c-426c-133aa1ce76d7@kontron.com>
 <YtcjpofgVhSRyo+t@lunn.ch>
 <e6a883e4-0635-7683-cbfe-b4504c9da893@kontron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6a883e4-0635-7683-cbfe-b4504c9da893@kontron.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The value programmed by the BIOS to MII_PHY_LED_CTRL is 0x0030 meaning
> LED2=link, LED1=activity, and LED0=link (and reserved bit 12 is set to 0
> instead of keeping it to its default 1). So this is also not something OK if
> the interrupt is enabled on the Elkartlake side for LED2/INT#

O.K, so it is a different situation to the link i gave.

> > Is the IRQ described in ACPI?
> OK, I'm going to check for it
> > Maybe you could wire it up. Set
> > phydev->irq before connecting the PHY,
> OK do you do that (set phydev->irq) ?
> > and then phylib will use the
> > IRQ, not polling. That might also solve your wakeup problem, in that
> > when the interrupt is disabled at shutdown, it should disable it in
> > the PHY.
> Is the PHY interrupt needed to support WakeOnLan ?
> And is the PHY POLL mode what we have on the EHL CRB (I don't have the CRB here so I can't check that) ?

Needing the interrupt will depend on how power management works on
your device.

There are two basic architectures which can be used.

1) The interrupt controller is kept running on suspend, and it can
wake the system up when an interrupt happens. You need to call
enable_irq_wake() to let the interrupt core code know this. Picking a random example:

https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/broadcom/bcmsysport.c#L546

2) The output from the PHY is connected to PMIC. The pin changing
state causes the PMIC to turn the power back on. The SoC itself is not
involved. And the driver does not need to use interrupts, in fact it
cannot use interrupts, if the pin is connected to the PMIC and not the
SoC.

It sounds like you have 1), so yes, you should be using the interrupt
for WOL to work.

    Andrew

