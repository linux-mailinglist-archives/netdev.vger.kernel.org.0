Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E513E16D6
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 16:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbhHEOX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 10:23:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:44108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233428AbhHEOX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 10:23:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E43E6113B;
        Thu,  5 Aug 2021 14:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628173423;
        bh=v3/cT7xxb//9kO1JkcSdUbWGmzDOj4Jn2pXdKC8+8Ac=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JQatWmgC+uxpmNxCzbXavNFDW9Ct3qGgNfNHpfH6F6P0aPb9iDUUAT6rPLwxA3qfr
         R1Zm5Fhf++NOTdaEksVSokUip+WrrGmBpfSLuZjSBafyJCiy2bIgHqtaVry3SDUx/z
         C6M6Uxg9K8Etx4Ru8XLzlJOisokNRlyRMyhu8ft50oH9lTZ+VZCw6ZLolC8w5E9YRY
         R9I51y+2UIek4E2Gwmwpp8MSghPurYJneCzRLKc90EoaWuZ6iviiv0rIy9X5IYSxNw
         PEltJe17CUSc7gn5O95ZveWA9EEMZgnlYGeFpCHohs6uO+IprFxzG1ZhDgE9hTh4AM
         QV64GAg6A12mQ==
Date:   Thu, 5 Aug 2021 07:23:42 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1] netdevsim: Forbid devlink reload when
 adding or deleting ports
Message-ID: <20210805072342.17faf851@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YQvs4wRIIEDG6Dcu@unreal>
References: <53cd1a28dd34ced9fb4c39885c6e13523e97d62c.1628161323.git.leonro@nvidia.com>
        <20210805061547.3e0869ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YQvs4wRIIEDG6Dcu@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Aug 2021 16:51:31 +0300 Leon Romanovsky wrote:
> > > +	nsim_bus_dev = nsim_dev->nsim_bus_dev;
> > > +	if (!mutex_trylock(&nsim_bus_dev->nsim_bus_reload_lock))
> > > +		return -EOPNOTSUPP;  
> > 
> > Why not -EBUSY?  
> 
> This is what devlink_reload_disable() returns, so I kept same error.
> It is not important at all.
> 
> What about the following change on top of this patch?

LGTM, the only question is whether we should leave in_reload true 
if nsim_dev->fail_reload is set.

> @@ -889,17 +890,26 @@ static int nsim_dev_reload_up(struct devlink *devlink, enum devlink_reload_actio
>  			      struct netlink_ext_ack *extack)
>  {
>  	struct nsim_dev *nsim_dev = devlink_priv(devlink);
> +	struct nsim_bus_dev *nsim_bus_dev;
> +	int ret;
> +
> +	nsim_bus_dev = nsim_dev->nsim_bus_dev;
> +	mutex_lock(&nsim_bus_dev->nsim_bus_reload_lock);
> +	nsim_bus_dev->in_reload = false;
>  
>  	if (nsim_dev->fail_reload) {
>  		/* For testing purposes, user set debugfs fail_reload
>  		 * value to true. Fail right away.
>  		 */
>  		NL_SET_ERR_MSG_MOD(extack, "User setup the reload to fail for testing purposes");
> +		mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
>  		return -EINVAL;
>  	}
>  
>  	*actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);
> -	return nsim_dev_reload_create(nsim_dev, extack);
> +	ret = nsim_dev_reload_create(nsim_dev, extack);
> +	mutex_unlock(&nsim_bus_dev->nsim_bus_reload_lock);
> +	return ret;
>  }


