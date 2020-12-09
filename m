Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FEEB2D4AF1
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 20:51:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387999AbgLITtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 14:49:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732246AbgLITt1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 14:49:27 -0500
Date:   Wed, 9 Dec 2020 11:48:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607543327;
        bh=s6dPnE7S0yfkrHXxthmBtF0PbUYsXpjhSYfYbPAvBn8=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=CSRlYJtPboMHtEadKY3CRQHpZWmmzxX1d/r8ewfUwWvSkZZIkzpQ9dT2JGltDLk2g
         HjnSo4GpMQEdzsT6N6ZFiP5jPihW4N6gKf85GkKxsfyPQDCJhpPAlnhq3lMJzCQHS8
         2mgJLugQWlayYFZ5bbcrztFjWtBb3/vT9dueI+MqjFLqUrOIH+s0OUw7hjMezJD2lc
         GfpgQjRLHXSpGX3REnzO5j30nWsx6Sh1dLXv3WHpAeEYLkHeWU/Si8LvXGGhXVp00L
         6YxU0Gc3Yig9vDeLkrSD9BMGHuc2dZQhi2ZV2xk19CxUhtHGfEqTyPs8Rn3RwvZR6J
         NUjUN8FQSwBjw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Geetha sowjanya <gakula@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sgoutham@marvell.com,
        davem@davemloft.net, sbhatta@marvell.com
Subject: Re: [PATCHv3 net-next] octeontx2-pf: Add RSS multi group support
Message-ID: <20201209114845.61839f46@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <f47444311bc7661c6482de11d570fb815f8e7941.camel@kernel.org>
References: <20201209170937.19548-1-gakula@marvell.com>
        <f47444311bc7661c6482de11d570fb815f8e7941.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 09 Dec 2020 11:08:24 -0800 Saeed Mahameed wrote:
> > -/* Configure RSS table and hash key */
> > -static int otx2_set_rxfh(struct net_device *dev, const u32 *indir,
> > -			 const u8 *hkey, const u8 hfunc)
> > +static int otx2_get_rxfh_context(struct net_device *dev, u32 *indir,
> > +				 u8 *hkey, u8 *hfunc, u32 rss_context)
> >  {
> >  	struct otx2_nic *pfvf = netdev_priv(dev);
> > +	struct otx2_rss_ctx *rss_ctx;
> >  	struct otx2_rss_info *rss;
> >  	int idx;
> >  
> > -	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc !=
> > ETH_RSS_HASH_TOP)
> > -		return -EOPNOTSUPP;
> > -
> >  	rss = &pfvf->hw.rss_info;
> >  
> >  	if (!rss->enable) {
> > -		netdev_err(dev, "RSS is disabled, cannot change
> > settings\n");
> > +		netdev_err(dev, "RSS is disabled\n");
> >  		return -EIO;
> >  	}  
> 
> I see that you init/enable rss on open, is this is your way to block
> getting rss info if device is not open ? why do you need to report an
> error anyway, why not just report whatever default config you will be
> setting up on next open ? 
> 
> to me reporting errors to ethtool queries when device is down is a bad
> user experience.
> 
> > +	if (rss_context >= MAX_RSS_GROUPS)
> > +		return -EINVAL;
> > +  
> 
> -ENOENT
> > +	rss_ctx = rss->rss_ctx[rss_context];
> > +	if (!rss_ctx)
> > +		return -EINVAL;
> >   
> 
> -ENOENT

Plus looks like this version introduces a W=1 C=1 warning:

drivers/net/ethernet/marvell/octeontx2/nic/otx2_ethtool.c:768:28: warning: Using plain integer as NULL pointer
