Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9EF2AA85E
	for <lists+netdev@lfdr.de>; Sun,  8 Nov 2020 00:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726470AbgKGXXO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 18:23:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59356 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgKGXXO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 18:23:14 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 484DB2087E;
        Sat,  7 Nov 2020 23:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604791393;
        bh=e3OLEr/83DVpjBpXHhs04dOi3JUgCsyFLMKa47cxGMo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AUMxBxh/0pXz9OrnoNkiE/15RIAW7cCo0KvLIb4DlCAtp9V0if+i4EIv44UG2Bc3M
         inWnBtCFvFoaAmF3ViLMh9tczD7Q6a92eCTPkDKiRToOcgnuFHirsj72vJYvmzTNZy
         t7LSnkFGmOhwASnE9OtzQFSOdBcReEf8h+RSuZ4g=
Date:   Sat, 7 Nov 2020 15:23:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        Maxim Mikityanskiy <maximmi@mellanox.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ethtool: netlink: add missing
 netdev_features_change() call
Message-ID: <20201107152312.727b2e68@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AlZXQ2o5uuTVHCfNGOiGgJ8vJ3KgO5YIWAnQjH0cDE@cp3-web-009.plabs.ch>
References: <AlZXQ2o5uuTVHCfNGOiGgJ8vJ3KgO5YIWAnQjH0cDE@cp3-web-009.plabs.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 05 Nov 2020 16:26:58 +0000 Alexander Lobakin wrote:
> After updating userspace Ethtool from 5.7 to 5.9, I noticed that
> NETDEV_FEAT_CHANGE is no more raised when changing netdev features
> through Ethtool.
> That's because the old Ethtool ioctl interface always calls
> netdev_features_change() at the end of user request processing to
> inform the kernel that our netdevice has some features changed, but
> the new Netlink interface does not. Instead, it just notifies itself
> with ETHTOOL_MSG_FEATURES_NTF.
> Replace this ethtool_notify() call with netdev_features_change(), so
> the kernel will be aware of any features changes, just like in case
> with the ioctl interface. This does not omit Ethtool notifications,
> as Ethtool itself listens to NETDEV_FEAT_CHANGE and drops
> ETHTOOL_MSG_FEATURES_NTF on it
> (net/ethtool/netlink.c:ethnl_netdev_event()).
> 
> Fixes: 0980bfcd6954 ("ethtool: set netdev features with FEATURES_SET request")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

LGTM, one nit below

> diff --git a/net/ethtool/features.c b/net/ethtool/features.c
> index 8ee4cdbd6b82..38f526f2125d 100644
> --- a/net/ethtool/features.c
> +++ b/net/ethtool/features.c
> @@ -279,8 +279,9 @@ int ethnl_set_features(struct sk_buff *skb, struct genl_info *info)
>  					  wanted_diff_mask, new_active,
>  					  active_diff_mask, compact);
>  	}
> +

I think the reply and notification are purposefully grouped, please
drop this extra new line.

>  	if (mod)
> -		ethtool_notify(dev, ETHTOOL_MSG_FEATURES_NTF, NULL);
> +		netdev_features_change(dev);
>  
>  out_rtnl:
>  	rtnl_unlock();

