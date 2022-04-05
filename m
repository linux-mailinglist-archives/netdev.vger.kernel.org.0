Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9EF4F44E1
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 00:32:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355101AbiDEUDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 16:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573176AbiDESIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 14:08:55 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AF31F623
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 11:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=DnpgwdQdGEsvMQlOn3L1tEyieFyj3RpD31tAg6KOeLU=; b=pTOZ8SYUS6sF8Sr+zKur9U1pK+
        caGh97J10J2tnyEj+eclzd6Z+TX8SnP9zuhm9vQ5B1hanySq/ICwncyvfPc+9vQoeIhUdm9a+wudL
        J9FfBP1dGGIm8Xfm/ldSEqh/7YQBMAcsnwy5ZtyLC9r0vEJwoIzEHvmxc5qmVBB1DCxk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nbnZq-00EHVs-IY; Tue, 05 Apr 2022 20:06:50 +0200
Date:   Tue, 5 Apr 2022 20:06:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Conor Dooley <mail@conchuod.ie>
Cc:     Palmer Dabbelt <palmer@rivosinc.com>, linux@armlinux.org.uk,
        Conor.Dooley@microchip.com, apatel@ventanamicro.com,
        netdev@vger.kernel.org, Nicolas.Ferre@microchip.com,
        Claudiu.Beznea@microchip.com, hkallweit1@gmail.com,
        linux-riscv@lists.infradead.org
Subject: Re: riscv defconfig CONFIG_PM/macb/generic PHY regression in
 v5.18-rc1
Message-ID: <YkyFOqAqA2IyTCOp@lunn.ch>
References: <mhng-524fe1b1-ca51-43a6-ac0f-7ea325da8b6a@palmer-ri-x1c9>
 <25acda81-4c5c-f8ba-0220-5ffe90bb197e@conchuod.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25acda81-4c5c-f8ba-0220-5ffe90bb197e@conchuod.ie>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I tried using the one for the VSC8662 (0007.0660) since that's whats on,
> the board but that didn't help.
> Without the revert:
> 
> [    1.521768] macb 20112000.ethernet eth0: Cadence GEM rev 0x0107010c at
> 0x20112000 irq 17 (00:04:a3:4d:4c:dc)
> [    3.206274] macb 20112000.ethernet eth0: PHY
> [20112000.ethernet-ffffffff:09] driver [Vitesse VSC8662] (irq=POLL)
> [    3.216641] macb 20112000.ethernet eth0: configuring for phy/sgmii link
> mode
> (and then nothing)
> 
> If I revert the CONFIG_PM addition:
> 
> [    1.508882] macb 20112000.ethernet eth0: Cadence GEM rev 0x0107010c at
> 0x20112000 irq 17 (00:04:a3:4d:4c:dc)
> [    2.879617] macb 20112000.ethernet eth0: PHY
> [20112000.ethernet-ffffffff:09] driver [Vitesse VSC8662] (irq=POLL)
> [    2.890010] macb 20112000.ethernet eth0: configuring for phy/sgmii link
> mode
> [    6.981823] macb 20112000.ethernet eth0: Link is Up - 1Gbps/Full - flow
> control off
> [    6.989657] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> 
> I will try again tomorrow with "ethernet-phy-id0007.0771" to see if
> anything changes, since that would use the Microsemi driver rather
> than the Vitesse driver that VSC8662/0007.0660 uses.

The numbers here should be the same as what you find in registers 2
and 3 of the PHY. They identify the manufacture, version and revision
of the PHY. With a normal probe, these two registers are read, and the
PHY driver found which says it supports the particular ID. The only
time you need to actually list the IDs in DT is when you cannot find
the PHY using the normal probe, generally because its regulator/reset
is turned off, and only the PHY driver knows how to fix that.
Chicken/Egg.

You don't have this issue, you always seem to be able to find the PHY,
so you don't need these properties.

Also, using the Microsemi driver for a Vitesse hardware is like using
the intel i210 Ethernet driver for an amd xgbe Ethernet hardware....

    Andrew
