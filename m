Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 212DE3E55A3
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 10:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbhHJIj5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 04:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229480AbhHJIj5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 04:39:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE5726056C;
        Tue, 10 Aug 2021 08:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628584775;
        bh=2bt2C+W2KdWRP1/JdlrOPS/C7CuHdjweWjr0Up5QFpE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iJ1F+ghywFyvh2MnErnsKDlH7HPD8XsktKXnZLvf7L8PaqMkgwfYdTVsraq3BbEe5
         rTHrAhSgPyXLRwqbGDNw5v0/jruk38SgNQfiG7anYd2hVU2Ut7P0m5k4vtrQFwTIth
         oQaNecJ4K+6jgduXmFUedsf+j3V8ehc5PjTDdLYB70SDzSQDBTaCcgDnwOeQvVIG39
         GSD5qXWh3VbY4lB7zZagpuj60Pov6+NryjAYvOG4DRZEN5FzUQTX4P7PLfQMCGiS+c
         O9CEiDu/dZJlSxyZtpW01McxCrH0Njd/evuero88fFATDpjxvVdVEGeoTo0ONpXKti
         5O5U9qN8xhd/A==
Date:   Tue, 10 Aug 2021 11:39:31 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Lahav Schlesinger <lschlesinger@drivenets.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org, davem@davemloft.net,
        kuba@kernel.org
Subject: Re: [PATCH net-next v3] net: Support filtering interfaces on no
 master
Message-ID: <YRI7Q19LDFlTecob@unreal>
References: <20210810072743.2778562-1-lschlesinger@drivenets.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810072743.2778562-1-lschlesinger@drivenets.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 07:27:43AM +0000, Lahav Schlesinger wrote:
> Currently there's support for filtering neighbours/links for interfaces
> which have a specific master device (using the IFLA_MASTER/NDA_MASTER
> attributes).
> 
> This patch adds support for filtering interfaces/neighbours dump for
> interfaces that *don't* have a master.
> 
> I have a patch for iproute2 ready for adding this support in userspace.

This line should be removed too.

Thanks

> 
> Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
> Cc: David Ahern <dsahern@kernel.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> ---
> v2 -> v3
>  - Change the way 'master' is checked for being non NULL
> v1 -> v2
>  - Change from filtering just for non VRF slaves to non slaves at all
> 
>  net/core/neighbour.c | 7 +++++++
>  net/core/rtnetlink.c | 7 +++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index b963d6b02c4f..2d5bc3a75fae 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -2528,6 +2528,13 @@ static bool neigh_master_filtered(struct net_device *dev, int master_idx)
>  		return false;
>  
>  	master = dev ? netdev_master_upper_dev_get(dev) : NULL;
> +
> +	/* 0 is already used to denote NDA_MASTER wasn't passed, therefore need another
> +	 * invalid value for ifindex to denote "no master".
> +	 */
> +	if (master_idx == -1)
> +		return !!master;
> +
>  	if (!master || master->ifindex != master_idx)
>  		return true;
>  
> diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
> index 7c9d32cfe607..2dcf1c084b20 100644
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -1959,6 +1959,13 @@ static bool link_master_filtered(struct net_device *dev, int master_idx)
>  		return false;
>  
>  	master = netdev_master_upper_dev_get(dev);
> +
> +	/* 0 is already used to denote IFLA_MASTER wasn't passed, therefore need
> +	 * another invalid value for ifindex to denote "no master".
> +	 */
> +	if (master_idx == -1)
> +		return !!master;
> +
>  	if (!master || master->ifindex != master_idx)
>  		return true;
>  
> -- 
> 2.25.1
> 
