Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F314B1CC509
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 00:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728500AbgEIWwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 18:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:54938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgEIWwY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 18:52:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B532208DB;
        Sat,  9 May 2020 22:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589064743;
        bh=qhVNbu7XIwB3nTsRGd4QgqusWcMwu670xwRnnr6GNgI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ibX0rDDuYQ5S6J85ow0R6cRXRXJwHuvhZ8aZnTk9Kb0tHaROhwdSqu2UOfubfhrYm
         Yif9OiNvxrbQl1Zjx/UBjVk7U/SpWoIXC/Hdw/NxImVkZsBoAnLbwe5GY8ptIY/ktk
         QUQf6oSi9CDf0CKUjFImSLBQpR3iuwmmNCImFA2Y=
Date:   Sat, 9 May 2020 15:52:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Timur Tabi <timur@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] net: freescale: select CONFIG_FIXED_PHY where needed
Message-ID: <20200509155221.40e0e3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <bce24dff-5287-76e2-ba85-8d31d7e673f8@gmail.com>
References: <20200509120505.109218-1-arnd@arndb.de>
        <20200509132427.3d2979d8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAK8P3a0figw8FHGp2KqW6XdfbWLu_ZXp3hyuPVoPwpum6XeJ_Q@mail.gmail.com>
        <bce24dff-5287-76e2-ba85-8d31d7e673f8@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 9 May 2020 15:04:04 -0700 Florian Fainelli wrote:
> On 5/9/2020 2:48 PM, Arnd Bergmann wrote:
> > On Sat, May 9, 2020 at 10:24 PM Jakub Kicinski <kuba@kernel.org> wrote:  
> >>
> >> On Sat,  9 May 2020 14:04:52 +0200 Arnd Bergmann wrote:  
> >>> I ran into a randconfig build failure with CONFIG_FIXED_PHY=m
> >>> and CONFIG_GIANFAR=y:
> >>>
> >>> x86_64-linux-ld: drivers/net/ethernet/freescale/gianfar.o:(.rodata+0x418): undefined reference to `fixed_phy_change_carrier'
> >>>
> >>> It seems the same thing can happen with dpaa and ucc_geth, so change
> >>> all three to do an explicit 'select FIXED_PHY'.
> >>>
> >>> The fixed-phy driver actually has an alternative stub function that
> >>> theoretically allows building network drivers when fixed-phy is
> >>> disabled, but I don't see how that would help here, as the drivers
> >>> presumably would not work then.
> >>>
> >>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>  
> >>  
> >>> +     select FIXED_PHY  
> >>
> >> I think FIXED_PHY needs to be optional, depends on what the board has
> >> connected to the MAC it may not be needed, right PHY folks? We probably
> >> need the
> >>
> >>     depends on FIXED_PHY || !FIXED_PHY  
> > 
> > Unfortunately that does not work because it causes a circular dependency:
> > 
> > drivers/net/phy/Kconfig:415:error: recursive dependency detected!
> > drivers/net/phy/Kconfig:415: symbol FIXED_PHY depends on PHYLIB
> > drivers/net/phy/Kconfig:250: symbol PHYLIB is selected by FSL_PQ_MDIO
> > drivers/net/ethernet/freescale/Kconfig:60: symbol FSL_PQ_MDIO is
> > selected by UCC_GETH
> > drivers/net/ethernet/freescale/Kconfig:75: symbol UCC_GETH depends on FIXED_PHY

:(

> > I now checked what other drivers use the fixed-phy interface, and found
> > that all others do select FIXED_PHY except for these three, and they
> > are also the only ones using fixed_phy_change_carrier().
> > 
> > The fixed-phy driver is fairly small, so it probably won't harm too much
> > to use the select, but maybe I missed another option.  
> 
> select FIXED_PHY appears the correct choice here we could think about
> providing stubs if that is deemed useful, but in general these drivers
> do tend to have a functional dependency on the fixed PHY and MDIO bus
> subsystems.

The sad thing is - the stubs already exist, it seems we just can't
express the dependencies in Kconfig well enough to prevent driver 
to be built in when fixed_phy is a module. Anyway..

> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Applied to net, thank y'all!
