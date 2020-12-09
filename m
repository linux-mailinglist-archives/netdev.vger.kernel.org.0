Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17DCC2D49D5
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 20:09:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387596AbgLITJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 14:09:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:54774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733001AbgLITJH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 14:09:07 -0500
Message-ID: <f47444311bc7661c6482de11d570fb815f8e7941.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607540907;
        bh=MZoHqy8IDSGzdgkpc0oauuGyvv+fzNC267tZh0farKc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=vPVoR+yr9Irrh4vZvZhRF7yzxMdjKL8IJL6xAJj+2hpkMQuUvOlNGsB/zdXAdJrnf
         G1d95aKPLd8DjKSMXVM7U4aIqTPmYZUhKrBM4BX5IQhzUPYoy68UPSZyPhqmBsYD9I
         LwQ+Ir0SNSfYN8cNw0u9nPfel734j7BdCWjz2BwVV/UQifaiRbHbVWFhGcmXYINhJ4
         Jr+sMzueG7eNx7LH/i8qtt0HmzFFRK80XB+KToWv+1eJf4U9m2XbgNW0NhM9ex6Pgs
         NmQirD8+GSWg+ugJkqDQlTUIcyV79SOZqt5j583avk5K98QabQLRpNwsE5zSjmMEX/
         IH3WjRqTnPvfg==
Subject: Re: [PATCHv3 net-next] octeontx2-pf: Add RSS multi group support
From:   Saeed Mahameed <saeed@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     sgoutham@marvell.com, davem@davemloft.net, kuba@kernel.org,
        sbhatta@marvell.com
Date:   Wed, 09 Dec 2020 11:08:24 -0800
In-Reply-To: <20201209170937.19548-1-gakula@marvell.com>
References: <20201209170937.19548-1-gakula@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-09 at 22:39 +0530, Geetha sowjanya wrote:
> Hardware supports 8 RSS groups per interface. Currently we are using
> only group '0'. This patch allows user to create new RSS
> groups/contexts
> and use the same as destination for flow steering rules.
> 
> usage:
> To steer the traffic to RQ 2,3
> 
> ethtool -X eth0 weight 0 0 1 1 context new
> (It will print the allocated context id number)
> New RSS context is 1
> 
> ethtool -N eth0 flow-type tcp4 dst-port 80 context 1 loc 1
> 
> To delete the context
> ethtool -X eth0 context 1 delete
> 
> When an RSS context is removed, the active classification
> rules using this context are also removed.
> 
> Change-log:
> v2
> - Removed unrelated whitespace
> - Coverted otx2_get_rxfh() to use new function.
> 
> v3
> - Coverted otx2_set_rxfh() to use new function.
> 
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Signed-off-by: Geetha sowjanya <gakula@marvell.com>
> ---

...

> -/* Configure RSS table and hash key */
> -static int otx2_set_rxfh(struct net_device *dev, const u32 *indir,
> -			 const u8 *hkey, const u8 hfunc)
> +static int otx2_get_rxfh_context(struct net_device *dev, u32 *indir,
> +				 u8 *hkey, u8 *hfunc, u32 rss_context)
>  {
>  	struct otx2_nic *pfvf = netdev_priv(dev);
> +	struct otx2_rss_ctx *rss_ctx;
>  	struct otx2_rss_info *rss;
>  	int idx;
>  
> -	if (hfunc != ETH_RSS_HASH_NO_CHANGE && hfunc !=
> ETH_RSS_HASH_TOP)
> -		return -EOPNOTSUPP;
> -
>  	rss = &pfvf->hw.rss_info;
>  
>  	if (!rss->enable) {
> -		netdev_err(dev, "RSS is disabled, cannot change
> settings\n");
> +		netdev_err(dev, "RSS is disabled\n");
>  		return -EIO;
>  	}

I see that you init/enable rss on open, is this is your way to block
getting rss info if device is not open ? why do you need to report an
error anyway, why not just report whatever default config you will be
setting up on next open ? 

to me reporting errors to ethtool queries when device is down is a bad
user experience.

> +	if (rss_context >= MAX_RSS_GROUPS)
> +		return -EINVAL;
> +

-ENOENT
> +	rss_ctx = rss->rss_ctx[rss_context];
> +	if (!rss_ctx)
> +		return -EINVAL;
> 

-ENOENT


