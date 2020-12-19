Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3C4F2DEC6D
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:32:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgLSAbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 19:31:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:35060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725868AbgLSAbX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Dec 2020 19:31:23 -0500
Date:   Fri, 18 Dec 2020 16:30:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608337842;
        bh=FTbVrDiRagPo4dtYQSBJkZhKSkBe59dUC4gVCqzoNdM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=VraZEgmXjpBvP+52tP6o5YgWuSJZZbiTaJwGv/j4y5ohnCc9/h+0pJ6NNRJjAJCiE
         QpXzP5pJfvdWJTuLE3rBLvAJFOPKV/uUOopd+MlUQTzvJGk5QoFgC6OhZOywz15Ac/
         0n4BU2eGwW56noGm4kmVnJlbJOIc4DnqPjACBkVQn96CizfD1+NjE3wzRR9NomrkD1
         7B1PqBuyYiRCifGwK40z0dMpdlMVjhTRBoXha9T/yrQYIobMA7OE+Dd4Mq4tD+2T+b
         YtaepJ9/kRkw8ha1Vrb708QEgAsgHOnQa+2OicPX/03RVQOuiRiAOUqt7bw1Q0Bp85
         R5k+ru6zM2whA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, pabeni@redhat.com,
        Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net 1/4] net-sysfs: take the rtnl lock when storing
 xps_cpus
Message-ID: <20201218163041.78f36cc2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201217162521.1134496-2-atenart@kernel.org>
References: <20201217162521.1134496-1-atenart@kernel.org>
        <20201217162521.1134496-2-atenart@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Dec 2020 17:25:18 +0100 Antoine Tenart wrote:
> Callers to netif_set_xps_queue should take the rtnl lock. Failing to do
> so can lead to race conditions between netdev_set_num_tc and
> netif_set_xps_queue, triggering various oops:
> 
> - netif_set_xps_queue uses dev->tc_num as one of the parameters to
>   compute the size of new_dev_maps when allocating it. dev->tc_num is
>   also used to access the map, and the compiler may generate code to
>   retrieve this field multiple times in the function.
> 
> - netdev_set_num_tc sets dev->tc_num.
> 
> If new_dev_maps is allocated using dev->tc_num and then dev->tc_num is
> set to a higher value through netdev_set_num_tc, later accesses to
> new_dev_maps in netif_set_xps_queue could lead to accessing memory
> outside of new_dev_maps; triggering an oops.
> 
> One way of triggering this is to set an iface up (for which the driver
> uses netdev_set_num_tc in the open path, such as bnx2x) and writing to
> xps_cpus in a concurrent thread. With the right timing an oops is
> triggered.
> 
> Fixes: 184c449f91fe ("net: Add support for XPS with QoS via traffic classes")

Let's CC Alex

> Signed-off-by: Antoine Tenart <atenart@kernel.org>

Two things: (a) is the datapath not exposed to a similar problem?
__get_xps_queue_idx() uses dev->tc_num in a very similar fashion.
Should we perhaps make the "num_tcs" part of the XPS maps which is
under RCU protection rather than accessing the netdev copy? 
(b) if we always take rtnl_lock, why have xps_map_mutex? Can we
rearrange things so that xps_map_mutex is sufficient?

> diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> index 999b70c59761..7cc15dec1717 100644
> --- a/net/core/net-sysfs.c
> +++ b/net/core/net-sysfs.c
> @@ -1396,7 +1396,13 @@ static ssize_t xps_cpus_store(struct netdev_queue *queue,
>  		return err;
>  	}
>  
> +	if (!rtnl_trylock()) {
> +		free_cpumask_var(mask);
> +		return restart_syscall();
> +	}
> +
>  	err = netif_set_xps_queue(dev, mask, index);
> +	rtnl_unlock();
>  
>  	free_cpumask_var(mask);
>  

