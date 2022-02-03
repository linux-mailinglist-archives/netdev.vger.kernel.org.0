Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B164A889E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:34:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352237AbiBCQeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:34:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:58740 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234742AbiBCQeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 11:34:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A2B00B83500
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 16:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301CEC340E8;
        Thu,  3 Feb 2022 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643906049;
        bh=/L8vXr/3hxe+GTNM9QgICLJg0JCJ6X0itzVAMqsDhno=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rKVaawt5wGFkj2jDABa1kqqpVCuppQmW4p/lA0R3BO762MLYfrmvJqlhRQSKUgdt4
         kkh+yWIRNv5h6FykqGg9G4KbjDZD/e3ZXAlswdBuSqUZ7QBVlC4Z0YgYKpszO1pht1
         bEN5fBN3EeKFzryjShtqjr8uIbhztXbB1SIxIRVVdNNW7UNpBcFmNLtv5DKCszrGAy
         E2+7Yg5q4aHOBihrYAz95hz9fqdDAJk608vkiAG5EJFEPw2OouQc9uvYau9GBQAk9B
         NxdVVRmnNS9X59GVmA6sqKvRRbpsG10mkyHwsP42sDSYx/uf5f9TngZFFW22VcdEY7
         6ffXGK8bOWvqw==
Date:   Thu, 3 Feb 2022 08:34:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH net-next 01/15] net: add netdev->tso_ipv6_max_size
 attribute
Message-ID: <20220203083407.523721a9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220203015140.3022854-2-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
        <20220203015140.3022854-2-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Feb 2022 17:51:26 -0800 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Some NIC (or virtual devices) are LSOv2 compatible.
> 
> BIG TCP plans using the large LSOv2 feature for IPv6.
> 
> New netlink attribute IFLA_TSO_IPV6_MAX_SIZE is defined.
> 
> Drivers should use netif_set_tso_ipv6_max_size() to advertize their limit.
> 
> Unchanged drivers are not allowing big TSO packets to be sent.

Many drivers will have a limit on how many buffer descriptors they
can chain, not the size of the super frame, I'd think. Is that not
the case? We can't assume all pages but the first and last are full,
right?

> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index e490b84732d1654bf067b30f2bb0b0825f88dea9..b1f68df2b37bc4b623f61cc2c6f0c02ba2afbe02 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -1948,6 +1948,7 @@ enum netdev_ml_priv_type {
>   *	@dev_addr_shadow:	Copy of @dev_addr to catch direct writes.
>   *	@linkwatch_dev_tracker:	refcount tracker used by linkwatch.
>   *	@watchdog_dev_tracker:	refcount tracker used by watchdog.
> + *	@tso_ipv6_max_size:	Maximum size of IPv6 TSO packets (driver/NIC limit)
>   *
>   *	FIXME: cleanup struct net_device such that network protocol info
>   *	moves out.
> @@ -2282,6 +2283,7 @@ struct net_device {
>  	u8 dev_addr_shadow[MAX_ADDR_LEN];
>  	netdevice_tracker	linkwatch_dev_tracker;
>  	netdevice_tracker	watchdog_dev_tracker;
> +	unsigned int		tso_ipv6_max_size;
>  };
>  #define to_net_dev(d) container_of(d, struct net_device, dev)
>  
> @@ -4818,6 +4820,14 @@ static inline void netif_set_gro_max_size(struct net_device *dev,
>  	WRITE_ONCE(dev->gro_max_size, size);
>  }
>  
> +/* Used by drivers to give their hardware/firmware limit for LSOv2 packets */
> +static inline void netif_set_tso_ipv6_max_size(struct net_device *dev,
> +					       unsigned int size)
> +{
> +	dev->tso_ipv6_max_size = size;
> +}
> +
> +

nit: double new line
