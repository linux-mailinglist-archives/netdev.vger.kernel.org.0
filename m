Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C8E4A57C1
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 08:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiBAHbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 02:31:52 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46616 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233720AbiBAHbv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 02:31:51 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 038C1CE172D
        for <netdev@vger.kernel.org>; Tue,  1 Feb 2022 07:31:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE684C340EB;
        Tue,  1 Feb 2022 07:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643700708;
        bh=Gfz/IyQeHhfIN3yvGC3lAVrGkBwjXoAf3UsomFaNtio=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=On3CcmYaeWcWRpHFeZkymIwfQs4pwKGJHcl8ylbeUr27U76qv4DaZhCf+QRUxIo6T
         49Vb3qA9DeO9PmW9YqKYVTtgf9kqHHVUVuv+m5xyXXTqcOJdv6dvzrVDeJFcN20u2p
         sUNZdPo2HVKkijPrfEsHK5/rE+vtaOWldJ+MaVt531CvkzD3oDCZ8fjgyRiMw7d/I8
         Kg88zm+gq1LnfwSwJN50rAevbYFeRczpZLkLZPiIzhGEkVBB2Ybe17swceVdv8INfO
         bG6UGGUKmAxXmR3Id6Hk27d1OxY4Pdq/VwMl0DsnijZ9cIJOtcVHOb62d8fLo3jy8n
         eBrwT3+km1qpQ==
Date:   Tue, 1 Feb 2022 09:31:44 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Shannon Nelson <shannon.nelson@oracle.com>
Subject: Re: [PATCH ipsec-next] xfrm: delete duplicated functions that calls
 same xfrm_api_check()
Message-ID: <Yfjh4FqmN3Xe1umR@unreal>
References: <5f9d6820e0548cb3304cbb49bcb84bedb15d7403.1643274380.git.leonro@nvidia.com>
 <20220201070701.GU1223722@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220201070701.GU1223722@gauss3.secunet.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 08:07:01AM +0100, Steffen Klassert wrote:
> On Thu, Jan 27, 2022 at 11:08:40AM +0200, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > The xfrm_dev_register() and xfrm_dev_feat_change() have same
> > implementation of one call to xfrm_api_check(). Instead of doing such
> > indirection, call to xfrm_api_check() directly and delete duplicated
> > functions.
> > 
> > Fixes: 92a2320697f7 ("xfrm: check for xdo_dev_ops add and delete")
> 
> There was nothing broken here, just a suboptimal implementation.
> So please remove the Fixes tag, otherwise it gets backported
> without a need.

No problem, I will remove.

> 
> Thanks!
> 
> > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > ---
> >  net/xfrm/xfrm_device.c | 14 ++------------
> >  1 file changed, 2 insertions(+), 12 deletions(-)
> > 
> > diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
> > index 3fa066419d37..36d6c1835844 100644
> > --- a/net/xfrm/xfrm_device.c
> > +++ b/net/xfrm/xfrm_device.c
> > @@ -380,16 +380,6 @@ static int xfrm_api_check(struct net_device *dev)
> >  	return NOTIFY_DONE;
> >  }
> >  
> > -static int xfrm_dev_register(struct net_device *dev)
> > -{
> > -	return xfrm_api_check(dev);
> > -}
> > -
> > -static int xfrm_dev_feat_change(struct net_device *dev)
> > -{
> > -	return xfrm_api_check(dev);
> > -}
> > -
> >  static int xfrm_dev_down(struct net_device *dev)
> >  {
> >  	if (dev->features & NETIF_F_HW_ESP)
> > @@ -404,10 +394,10 @@ static int xfrm_dev_event(struct notifier_block *this, unsigned long event, void
> >  
> >  	switch (event) {
> >  	case NETDEV_REGISTER:
> > -		return xfrm_dev_register(dev);
> > +		return xfrm_api_check(dev);
> >  
> >  	case NETDEV_FEAT_CHANGE:
> > -		return xfrm_dev_feat_change(dev);
> > +		return xfrm_api_check(dev);
> >  
> >  	case NETDEV_DOWN:
> >  	case NETDEV_UNREGISTER:
> > -- 
> > 2.34.1
