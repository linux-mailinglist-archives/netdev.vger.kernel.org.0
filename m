Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B82822B2F8A
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 19:18:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726158AbgKNSRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:17:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:42552 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgKNSRK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 13:17:10 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC7822224B;
        Sat, 14 Nov 2020 18:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605377829;
        bh=kIyBXYCsmZBAtoxE8HOK3iYWZzikcqnb4nKMaWDWUkI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vr9SQhCcvCHp0kcDgCKzdg3EMaLZYpyRAxLITm/rB5ZN0ZwYdSy5GNE919hwsMg+3
         2WQi9noxsEiMRsKJdAK0tpYSYaDqjsYDoBSb78V8NZ9QuC+8gjuUMxAttWJpfnCazm
         JJ89MFMyJMNCi8J3DdlI+NastOEWWayGJDkfybPI=
Date:   Sat, 14 Nov 2020 10:17:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jian Yang <jianyang.kernel@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Mahesh Bandewar <maheshb@google.com>,
        Jian Yang <jianyang@google.com>
Subject: Re: [PATCH net-next] net-loopback: allow lo dev initial state to be
 controlled
Message-ID: <20201114101709.42ee19e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
References: <20201111204308.3352959-1-jianyang.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Nov 2020 12:43:08 -0800 Jian Yang wrote:
> From: Mahesh Bandewar <maheshb@google.com>
> 
> Traditionally loopback devices comes up with initial state as DOWN for
> any new network-namespace. This would mean that anyone needing this
> device (which is mostly true except sandboxes where networking in not
> needed at all), would have to bring this UP by issuing something like
> 'ip link set lo up' which can be avoided if the initial state can be set
> as UP. Also ICMP error propagation needs loopback to be UP.
> 
> The default value for this sysctl is set to ZERO which will preserve the
> backward compatible behavior for the root-netns while changing the
> sysctl will only alter the behavior of the newer network namespaces.

Any reason why the new sysctl itself is not per netns?

> +netdev_loopback_state
> +---------------------

loopback_init_state ?

> +Controls the loopback device initial state for any new network namespaces. By
> +default, we keep the initial state as DOWN.
> +
> +If set to 1, the loopback device will be brought UP during namespace creation.
> +This will only apply to all new network namespaces.
> +
> +Default : 0  (for compatibility reasons)
> +
>  netdev_max_backlog
>  ------------------
>  
> diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> index a1c77cc00416..76dc92ac65a2 100644
> --- a/drivers/net/loopback.c
> +++ b/drivers/net/loopback.c
> @@ -219,6 +219,13 @@ static __net_init int loopback_net_init(struct net *net)
>  
>  	BUG_ON(dev->ifindex != LOOPBACK_IFINDEX);
>  	net->loopback_dev = dev;
> +
> +	if (sysctl_netdev_loopback_state) {
> +		/* Bring loopback device UP */
> +		rtnl_lock();
> +		dev_open(dev, NULL);
> +		rtnl_unlock();
> +	}

The only concern I have here is that it breaks notification ordering.
Is there precedent for NETDEV_UP to be generated before all pernet ops
->init was called?
