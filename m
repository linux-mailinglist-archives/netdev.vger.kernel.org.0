Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9A6F11FBC9
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 00:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726478AbfLOXOq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 18:14:46 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:57766 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726260AbfLOXOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 18:14:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LH0DTjOMJiqxTyHi8KkJ1ASr5Yku7ppw49xdOvnkdOs=; b=OnE8aTfpCDgjXWKKQIV0ZT03T
        c1P6pc+UFAfR8g/REf2cOPQeYgkgjtwq8w/2qOLABtTrX4gfI8VJMAsiNryxkqAIMjZPqFm05e4fb
        Rp/HO225wOTIjK/EZsLZxAtDK7VhOLKN3YS82LF6yB6ar19hOhCUBQNlSPhxaMpaXPrZMbOOvhfzW
        OwUdK5A645n2BBvDc+t6OkGqbGQZMmGU5DGsphGIHvD/58IZYqTx6DHrSjHwxDckqEY0ZGKI5hv7U
        jRvXupGLuWZTPD1+SNpE2U/0r8gzO6x9M17Hn/krvOZbEl/gUivzZgCGVvP4enNhSU/YkuluYM2ZJ
        Tg5LHgd7Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:53500)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1igd60-0003bb-IL; Sun, 15 Dec 2019 23:14:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1igd5y-0001nM-La; Sun, 15 Dec 2019 23:14:38 +0000
Date:   Sun, 15 Dec 2019 23:14:38 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
Message-ID: <20191215231438.GC25745@shell.armlinux.org.uk>
References: <20191216101250.227b4bd6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191216101250.227b4bd6@canb.auug.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 10:12:50AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   drivers/net/phy/phylink.c
> 
> between commit:
> 
>   9b2079c046a9 ("net: phylink: fix interface passed to mac_link_up")
> 
> from the net tree and commit:
> 
>   24cf0e693bb5 ("net: phylink: split link_an_mode configured and current settings")
> 
> from the net-next tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 
> -- 
> Cheers,
> Stephen Rothwell
> 
> diff --cc drivers/net/phy/phylink.c
> index 1585eebb73fe,1e0e32c466ee..000000000000
> --- a/drivers/net/phy/phylink.c
> +++ b/drivers/net/phy/phylink.c
> @@@ -441,8 -445,9 +445,8 @@@ static void phylink_mac_link_up(struct 
>   	struct net_device *ndev = pl->netdev;
>   
>   	pl->cur_interface = link_state.interface;
> - 	pl->ops->mac_link_up(pl->config, pl->link_an_mode,
> + 	pl->ops->mac_link_up(pl->config, pl->cur_link_an_mode,
>  -			     pl->phy_state.interface,
>  -			     pl->phydev);
>  +			     pl->cur_interface, pl->phydev);
>   
>   	if (ndev)
>   		netif_carrier_on(ndev);

Yep, that's correct.  Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
