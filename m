Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDFF44CF78
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 03:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233583AbhKKCJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 21:09:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:55166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233552AbhKKCJC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 21:09:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 79BAC61073;
        Thu, 11 Nov 2021 02:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636596373;
        bh=X4sMI2ia4/BU1tBCkK05ajEI9bCkBdO8vwHAaLPmAOo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UECVeurkhuIaUY9WDjQcoxVYKmTe8BbPpwdDY3ua0UiE7VWODA2irmCyTPYlJCM3h
         Mb5lxqogNGyfqvLwqtskHaPOz+obVepTNfkdM+F2K7Mqs3vGkQ7+zeXExsrsfjCDIu
         wxs5+6MoomPz7/0+pyWok21hce2RCmWaU1jeHEnDmydscocUhRa3sOLAOzX/uFKp5a
         MgmUMSINZxUvy4yvRxeumhnplzl1eVX+0J4o3b9TIIWhWhKwt/7IvqIlqcli0UU3jY
         SihZnkGqbXBSybKDpe28UpNYvwhY0fh8RvFKa7dgKyGSFgUVGubymY1EILkGMOFfPy
         kD3md4ethu6Tg==
Date:   Wed, 10 Nov 2021 18:06:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jirislaby@kernel.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 2/2] hamradio: defer 6pack kfree after
 unregister_netdev
Message-ID: <20211110180612.2f2eb760@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211110180525.20422f66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211108103721.30522-1-linma@zju.edu.cn>
        <20211108103759.30541-1-linma@zju.edu.cn>
        <20211110180525.20422f66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 10 Nov 2021 18:05:25 -0800 Jakub Kicinski wrote:
> > diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
> > index 49f10053a794..bfdf89e54752 100644
> > --- a/drivers/net/hamradio/6pack.c
> > +++ b/drivers/net/hamradio/6pack.c
> > @@ -672,11 +672,13 @@ static void sixpack_close(struct tty_struct *tty)
> >  	del_timer_sync(&sp->tx_t);
> >  	del_timer_sync(&sp->resync_t);
> >  
> > -	/* Free all 6pack frame buffers. */
> > +	unregister_netdev(sp->dev);
> > +
> > +	/* Free all 6pack frame buffers after unreg. */
> >  	kfree(sp->rbuff);
> >  	kfree(sp->xbuff);
> >  
> > -	unregister_netdev(sp->dev);
> > +	free_netdev(sp->dev);  
> 
> You should mention in the commit message why you think it's safe to add
> free_netdev() which wasn't here before...
> 
> This driver seems to be setting:
> 
> 	dev->needs_free_netdev	= true;
> 
> so unregister_netdev() will free the netdev automatically.
> 
> That said I don't see a reason why this driver needs the automatic
> cleanup.
> 
> You can either remove that setting and then you can call free_netdev()
> like you do, or you need to move the cleanup to dev->priv_destructor.

Looks like this go applied already, please send a follow up fix.
