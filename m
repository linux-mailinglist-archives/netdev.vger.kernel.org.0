Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 156C357A90B
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 23:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239940AbiGSVfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 17:35:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbiGSVfo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 17:35:44 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD82A357E0
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 14:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=irout7iuWMMTofRPcNIOmUItYW/K97g/eYt9e3bX+0A=; b=5O
        MhUn6qHlUlwko/fudlMJuG7Q3p81SFbCAjbZuwfH1qjctkx1K/lOt8iMTdFey9WSUoyaa0QcequGB
        m7duZh7zRZuveF8jNVSC1gJjV7aJ9gSYY9GN5zer7HyapBYYQx602W7Un1gIeABbOnUxUxuFSDdfT
        6BIJnk64c1hG6xM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oDusQ-00Areg-61; Tue, 19 Jul 2022 23:35:34 +0200
Date:   Tue, 19 Jul 2022 23:35:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Gilles BULOZ <gilles.buloz@kontron.com>
Cc:     netdev@vger.kernel.org
Subject: Re: Marvell 88E1512 PHY LED2 mode mismatch with Elkhartlake pin mode
Message-ID: <YtcjpofgVhSRyo+t@lunn.ch>
References: <3f6a37ab-c346-b53c-426c-133aa1ce76d7@kontron.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3f6a37ab-c346-b53c-426c-133aa1ce76d7@kontron.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 06:36:20PM +0200, Gilles BULOZ wrote:
> Dear developers,
> 
> On a custom Elkhartlake board based on the Intel CRB, it turns out I have
> the 88E1512 PHY configured in polled mode ("intel-eth-pci 0000:00:1e.4 eno1:
> PHY [stmmac-1:01] driver [Marvell 88E1510] (irq=POLL)" in dmesg) and the
> LED2/INT# pin is configured in LED2 mode by marvell_config_led() in
> drivers/net/phy/marvell.c (MII_88E1510_PHY_LED_DEF written to
> MII_PHY_LED_CTRL). This pin is connected as on the CRB to an Elkhartlake pin
> for a PHY interrupt but for some reason the interrupt is enabled on the
> Elkhartlake.
> So when I shutdown the system (S5), any activity on link makes LED2/INT# toggle and power the system back on.
> 
> I tried to force  phydev->dev_flag to use
> MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE instead of MII_88E1510_PHY_LED_DEF but
> I've been unable to find how to force this flag. And I discovered that the
> value of MII_88E1510_PHY_LED0_LINK_LED1_ACTIVE = 0x1040 is not OK for me
> because LED2 is set to "link status" so if I use this value the system is
> back "on" on link change (better than on activity but still not OK).
> 
> As a final workaround I've patched drivers/net/phy/marvell.c at
> marvell_config_led() to have "LED0=link LED1=activity LED2=off" by writing
> 0x1840 to MII_PHY_LED_CTRL, but I know this is a ugly workaround.
> 
> So I'm wondering if PHY "irq=POLL" is the expected operating mode ?
> In this case what should disable the interrupt on the Elkhartlake pin ?
> Is wake on Lan supported if PHY is set to "irq=POLL" ?

This sounds a bit like:

https://lore.kernel.org/lkml/YelxMFOiqnfIVmyy@lunn.ch/T/

If you comment out marvell_config_led(), and read back the registers,
does it look like the firmware has setup the LEDs to something
sensible?

Is the IRQ described in ACPI? Maybe you could wire it up. Set
phydev->irq before connecting the PHY, and then phylib will use the
IRQ, not polling. That might also solve your wakeup problem, in that
when the interrupt is disabled at shutdown, it should disable it in
the PHY.

    Andrew
