Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61692D3726
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 00:50:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbgLHXtr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 18:49:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:34656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbgLHXtr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 18:49:47 -0500
Date:   Tue, 8 Dec 2020 15:49:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607471346;
        bh=6mtpRqIaFOCxc3Cj5hV3sRh2QPbDs79xb2ok8ZSQDtQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=ETB0/1pIjk0A2KbChIM6fp4ERBqTm4bKbtgfRxhpGNqrPBltVwniw7VTnURLHl43V
         w3I8f6H5XTUW1kKeapRtKPvySh8RTy3LxE2qX+ogOOWj6yVOVV+OXSUkHSQqh8qqgD
         JO0QBo418+WCUYUFKDPU19b/rfEekC2DhuDWMF5DBZGn7zLdqAbnQ8/KTpV6gUpEL3
         ADm4zUyjHY8Vp5ZqIqDDB3WL/XwVsKboHc1X4rqpOHXTlNVKSFNVT4qgOOIBp1zDiP
         w99yQOw+s2D8ZRqOoh+4zH12Yqo/KtsJaE2L2/6PedNaSUHXYu8m6vyYIx0CtlEIXG
         0ayq5Yz6ZMh2g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Nathan Lynch <nathanl@linux.ibm.com>
Subject: Re: [RFC PATCH net-next 1/3] net: core: introduce
 netdev_notify_peers_locked
Message-ID: <20201208154905.23151fe4@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201206052127.21450-2-ljp@linux.ibm.com>
References: <20201206052127.21450-1-ljp@linux.ibm.com>
        <20201206052127.21450-2-ljp@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Dec 2020 23:21:25 -0600 Lijun Pan wrote:
> There are some use cases for netdev_notify_peers in the context
> when rtnl lock is already held. Introduce lockless version
> of netdev_notify_peers call to save the extra code to call
> 	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, dev);
> 	call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev);
> 
> Suggested-by: Nathan Lynch <nathanl@linux.ibm.com>
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -1488,6 +1488,25 @@ void netdev_notify_peers(struct net_device *dev)
>  }
>  EXPORT_SYMBOL(netdev_notify_peers);

Why not convert netdev_notify_peers to call the new helper?
That way the chance they will get out of sync is way smaller.

> +/**
> + * netdev_notify_peers_locked - notify network peers about existence of @dev,
> + * to be called in the context when rtnl lock is already held.
> + * @dev: network device
> + *
> + * Generate traffic such that interested network peers are aware of
> + * @dev, such as by generating a gratuitous ARP. This may be used when
> + * a device wants to inform the rest of the network about some sort of
> + * reconfiguration such as a failover event or virtual machine
> + * migration.
> + */
> +void netdev_notify_peers_locked(struct net_device *dev)

I think __netdev_notify_peers() would be a more typical name for
a core kernel function like this.

> +{
> +	ASSERT_RTNL();
> +	call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, dev);
> +	call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev);
> +}
> +EXPORT_SYMBOL(netdev_notify_peers_locked);

Otherwise LGTM, seems like a good cleanup.
