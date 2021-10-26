Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D9343B5C6
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 17:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhJZPmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 11:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235012AbhJZPmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 11:42:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 374FF60EFF;
        Tue, 26 Oct 2021 15:39:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635262780;
        bh=l0rrGoOahD4GXFa9Djor7L+zFep9kBC4SBx3qfcPOAE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bo165SXyiA+glA9+d7IsYVsAZfSolBTpIE6zhMyOTAuk26F7zXyU62jJEpRqRpOw1
         oqvKISPsZuFOH6ROxg9K2W5PKt+7HC1GFdTTCNpqzf0tso2WEHVKJ+NNeQKIX+4IOs
         qh2t+s5Jfgu/yHtV+OQACQIPpoEttNJUsU6uXDpeV9pPOfOejUVgssjHTO3KJDQ280
         uIyUQhpFG2nDmbpXSe2sqApofwc9bL1TjmgS2gszxBXDiB0jAnBlkHdua68e6yiAnY
         1CNuVRFx5SBr739FQPZA4E7R983atmEFGRt8PpYpYMLbMdr2EFzEr/ZSywb+vmyvXa
         o2s0qstsLM7bA==
Date:   Tue, 26 Oct 2021 08:39:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH v4] net: macb: Fix several edge cases in validate
Message-ID: <20211026083939.11dc6b16@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <4e430fbb-0908-fd3b-bb6e-ec316ea8d66a@seco.com>
References: <20211025172405.211164-1-sean.anderson@seco.com>
        <20211025174401.1de5e95d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <4e430fbb-0908-fd3b-bb6e-ec316ea8d66a@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 11:30:08 -0400 Sean Anderson wrote:
> Hi Jakub,
> 
> On 10/25/21 8:44 PM, Jakub Kicinski wrote:
> > On Mon, 25 Oct 2021 13:24:05 -0400 Sean Anderson wrote:  
> >> There were several cases where validate() would return bogus supported
> >> modes with unusual combinations of interfaces and capabilities. For
> >> example, if state->interface was 10GBASER and the macb had HIGH_SPEED
> >> and PCS but not GIGABIT MODE, then 10/100 modes would be set anyway. In
> >> another case, SGMII could be enabled even if the mac was not a GEM
> >> (despite this being checked for later on in mac_config()). These
> >> inconsistencies make it difficult to refactor this function cleanly.  
> >
> > Since you're respinning anyway (AFAIU) would you mind clarifying
> > the fix vs refactoring question? Sounds like it could be a fix for
> > the right (wrong?) PHY/MAC combination, but I don't think you're
> > intending it to be treated as a fix.
> >
> > If it's a fix it needs [PATCH net] in the subject and a Fixes tag,
> > if it's not a fix it needs [PATCH net-next] in the subject.
> >
> > This will make the lifes of maintainers and backporters easier,
> > thanks :)  
> 
> I don't know if it's a "fix" per se. The current logic isn't wrong,
> since I believe that the configurations where the above patch would make
> a difference do not exist. However, as noted in the commit message, this
> makes refactoring difficult.

Ok, unless one of the PHY experts can help us make a call let's go 
for net-next and no Fixes tag. 

> For example, one might want to implement supported_interfaces like
> 
>         if (bp->caps & MACB_CAPS_HIGH_SPEED &&
>             bp->caps & MACB_CAPS_PCS)
>                 __set_bit(PHY_INTERFACE_MODE_10GBASER, supported);
>         if (macb_is_gem(bp) && bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE) {
>                 __set_bit(PHY_INTERFACE_MODE_GMII, supported);
> 		phy_interface_set_rgmii(supported);
>                 if (bp->caps & MACB_CAPS_PCS)
>                         __set_bit(PHY_INTERFACE_MODE_SGMII, supported);
>         }
>         __set_bit(PHY_INTERFACE_MODE_MII, supported);
>         __set_bit(PHY_INTERFACE_MODE_RMII, supported);
> 
> but then you still need to check for GIGABIT_MODE in validate to
> determine whether 10GBASER should "support" 10/100. See [1] for more
> discussion.
> 
> If you think this fixes a bug, then the appropriate tag is
> 
> Fixes: 7897b071ac3b ("net: macb: convert to phylink")
> 
> --Sean
> 
> [1] https://lore.kernel.org/netdev/YXaIWFB8Kx9rm%2Fj9@shell.armlinux.org.uk/

