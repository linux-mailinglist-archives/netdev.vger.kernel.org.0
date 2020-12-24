Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34AD62E2373
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 02:44:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgLXBm3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 20:42:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:56654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727940AbgLXBm3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 20:42:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2ED82256F;
        Thu, 24 Dec 2020 01:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608774108;
        bh=L+bUl3eAVqj4bc6uQeXDiH/vysCuwoFIdoFhzwBCKcA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dv6nFUYFOyXgTv6i7pWyENkkOFk7M3TbsIOo0uGHJqaaTFk53FN6/t+4jGmn7zSox
         T3JWgpnmc2Yuw0XDCqpq1/cgCRNhdTxH0Ge/3Mcd6kRPKg7oJQ/okAyFmP10sTnyxa
         huegTsQE6HEkAEL/mNMd5avyjINkZUhyDCL+1BmEnU8DS98Q0L5cURCm3imWCKcQTi
         fzD0zOLOU1nLs1u3n/xkmLUhJGN5lReGJ2Nz6bc9NRKtmgqcshh7Ir/m2l074sHxF/
         SwlzhOPhfPhOaZiCcScpnAVlJnviafIXodU9IP47DPpfr0ZwUEUmG+QxQX+3ackMNc
         blwmveygtjfag==
Date:   Wed, 23 Dec 2020 17:41:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Dinghao Liu <dinghao.liu@zju.edu.cn>, kjlu@umn.edu,
        "David S. Miller" <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ethernet: Fix memleak in ethoc_probe
Message-ID: <20201223174146.37e62326@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <680850a9-8ab0-4672-498e-6dc740720da3@gmail.com>
References: <20201223110615.31389-1-dinghao.liu@zju.edu.cn>
        <20201223153304.GD3198262@lunn.ch>
        <20201223123218.1cf7d9cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201223210044.GA3253993@lunn.ch>
        <20201223131149.15fff8d2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <680850a9-8ab0-4672-498e-6dc740720da3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Dec 2020 14:17:29 -0800 Florian Fainelli wrote:
> On 12/23/2020 1:11 PM, Jakub Kicinski wrote:
> > On Wed, 23 Dec 2020 22:00:44 +0100 Andrew Lunn wrote:  
> >> On Wed, Dec 23, 2020 at 12:32:18PM -0800, Jakub Kicinski wrote:  
> >>> On Wed, 23 Dec 2020 16:33:04 +0100 Andrew Lunn wrote:    
> >>>> On Wed, Dec 23, 2020 at 07:06:12PM +0800, Dinghao Liu wrote:    
> >>>>> When mdiobus_register() fails, priv->mdio allocated
> >>>>> by mdiobus_alloc() has not been freed, which leads
> >>>>> to memleak.
> >>>>>
> >>>>> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>      
> >>>>
> >>>> Fixes: bfa49cfc5262 ("net/ethoc: fix null dereference on error exit path")
> >>>>
> >>>> Reviewed-by: Andrew Lunn <andrew@lunn.ch>    
> >>>
> >>> Ooof, I applied without looking at your email and I added:
> >>>
> >>> Fixes: e7f4dc3536a4 ("mdio: Move allocation of interrupts into core")    
> >>
> >> [Goes and looks deeper]
> >>
> >> Yes, commit e7f4dc3536a4 looks like it introduced the original
> >> problem. bfa49cfc5262 just moved to code around a bit.
> >>
> >> Does patchwork not automagically add Fixes: lines from full up emails?
> >> That seems like a reasonable automation.  
> > 
> > Looks like it's been a TODO for 3 years now:
> > 
> > https://github.com/getpatchwork/patchwork/issues/151  
> 
> It was proposed before, but rejected. You can have your local patchwork
> admin take care of that for you though and add custom tags:
> 
> https://lists.ozlabs.org/pipermail/patchwork/2017-January/003910.html

Konstantin, would you be willing to mod the kernel.org instance of
patchwork to populate Fixes tags in the generated mboxes?
