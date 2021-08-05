Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26F7D3E1707
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:33:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241976AbhHEOd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:33:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241678AbhHEOdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 10:33:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4F6260F70;
        Thu,  5 Aug 2021 14:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628174020;
        bh=uS5k7NT/OtSSpIhp7kkMdv3wNhYKJVGqUHgVMB90X+k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pQsSYEtjIUMsWaCO9Q0Gj0qiHIPDbbs4GmN4Dq0d3dh7CgX8aof2xXi/vu4KHgkdm
         ro1miJjlCGWMTgEnpnjIdd+c39+/8kVesjyMjf4uV36w6PMjyEh5i2S/4a1ccgbrv3
         yO1HRKw54EdqJqCuxVSFt3QK+AUJULqhnw5JnLB6Oq29VmMEqNqIi31L4p5CfqO7ka
         Yh4L9pLxPWWrfPeueVtWyZH3Wv0HtTjJTHSED1B64vcPH0ffmdXWMD6Nv/re6bon8i
         Rv2vJ3Nj20PmNF9ZGUUufxws20DYpGH6dUFu11O/LmNGImt9diCVfcZEverM3SHbeH
         ZFY1yZ+ovBA3w==
Date:   Thu, 5 Aug 2021 17:33:35 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] netdevsim: Forbid devlink reload when adding
 or deleting ports
Message-ID: <YQv2v5cTqLvoPc4n@unreal>
References: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
 <20210805061547.3e0869ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YQvs4wRIIEDG6Dcu@unreal>
 <20210805072342.17faf851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210805072342.17faf851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 05, 2021 at 07:23:42AM -0700, Jakub Kicinski wrote:
> On Thu, 5 Aug 2021 16:51:31 +0300 Leon Romanovsky wrote:
> > > > +	nsim_bus_dev = nsim_dev->nsim_bus_dev;
> > > > +	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
> > > > +		return -EOPNOTSUPP;  
> > > 
> > > Why not -EBUSY?  
> > 
> > This is what devlink_reload_disable() returns, so I kept same error.
> > It is not important at all.
> > 
> > What about the following change on top of this patch?
> 
> LGTM, the only question is whether we should leave in_reload true 
> if nsim_dev->fail_reload is set.

I don't think so, it will block add/delete ports.

> 
> > @@ -889,17 +890,26 @@ static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_actio
> >  			      struct netlink_ext_ack *extack)
> >  {
> >  	struct nsim_dev *nsim_dev = devlink_priv(devlink);
> > +	struct nsim_bus_dev *nsim_bus_dev;
> > +	int ret;
> > +
> > +	nsim_bus_dev = nsim_dev->nsim_bus_dev;
> > +	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
> > +	nsim_bus_dev->in_reload = false;
> >  
> >  	if (nsim_dev->fail_reload) {
> >  		/* For testing purposes, user set debugfs fail_reload
> >  		 * value to true. Fail right away.
> >  		 */
> >  		NL_SET_ERR_MSG_MOD(extack, "User setup the reload to fail for testing purposes");
> > +		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
> >  		return -EINVAL;
> >  	}
> >  
> >  	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
> > -	return nsim_dev_reload_create(nsim_dev, extack);
> > +	ret = nsim_dev_reload_create(nsim_dev, extack);
> > +	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
> > +	return ret;
> >  }
> 
> 
