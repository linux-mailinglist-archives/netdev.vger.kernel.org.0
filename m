Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFCE31709B6
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 21:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727277AbgBZUdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 15:33:17 -0500
Received: from mail26.static.mailgun.info ([104.130.122.26]:30622 "EHLO
        mail26.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727306AbgBZUdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 15:33:16 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1582749196; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=P/SSm6c2lM4hXptWOYl4b2omu2FYwZZnWYoPeIC1UlE=;
 b=Zi27k+mb0HOyLvXyXQEeQWsJHeZ8uOGpPhAzPzABDXeD0GVl0WLMb+XFaLkqX6zsV/2af89d
 /eFLz8hTsK8M/N+ZeFZ5aaS5eZhIgOcjDvXkaw65s2WRrvvK8wf/a2fib0fZmaiAtoWhpTox
 orkL8//H3RiH0raAhcwu+/+qZSU=
X-Mailgun-Sending-Ip: 104.130.122.26
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171])
 by mxa.mailgun.org with ESMTP id 5e56d607.7fb606602110-smtp-out-n01;
 Wed, 26 Feb 2020 20:33:11 -0000 (UTC)
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9462DC4479D; Wed, 26 Feb 2020 20:33:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=2.0 tests=ALL_TRUSTED
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BC22FC43383;
        Wed, 26 Feb 2020 20:33:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 26 Feb 2020 13:33:10 -0700
From:   subashab@codeaurora.org
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 04/10] net: rmnet: fix suspicious RCU usage
In-Reply-To: <20200226174706.5334-1-ap420073@gmail.com>
References: <20200226174706.5334-1-ap420073@gmail.com>
Message-ID: <473fc49bd479ecfeb92adbd9a26fba2e@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-02-26 10:47, Taehee Yoo wrote:
> rmnet_get_port() internally calls rcu_dereference_rtnl(),
> which checks RTNL.
> But rmnet_get_port() could be called by packet path.
> The packet path is not protected by RTNL.
> So, the suspicious RCU usage problem occurs.
> 
> Test commands:
>     ip netns add nst
>     ip link add veth0 type veth peer name veth1
>     ip link set veth1 netns nst
>     ip link add rmnet0 link veth0 type rmnet mux_id 1
>     ip netns exec nst ip link add rmnet1 link veth1 type rmnet mux_id 1
>     ip netns exec nst ip link set veth1 up
>     ip netns exec nst ip link set rmnet1 up
>     ip netns exec nst ip a a 192.168.100.2/24 dev rmnet1
>     ip link set veth0 up
>     ip link set rmnet0 up
>     ip a a 192.168.100.1/24 dev rmnet0
>     ping 192.168.100.2
> 
> Splat looks like:
> [  339.775811][  T969] =============================
> [  339.777204][  T969] WARNING: suspicious RCU usage
> [  339.778188][  T969] 5.5.0+ #407 Not tainted
> [  339.779123][  T969] -----------------------------
> [  339.780100][  T969]
> drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c:389 suspicious
> rcu_dereference_check() usage!
> [  339.781943][  T969]
> [  339.781943][  T969] other info that might help us debug this:
> [  339.781943][  T969]
> [  339.783475][  T969]
> [  339.783475][  T969] rcu_scheduler_active = 2, debug_locks = 1
> [  339.784656][  T969] 5 locks held by ping/969:
> [  339.785406][  T969]  #0: ffff88804cb897f0 (sk_lock-AF_INET){+.+.},
> at: raw_sendmsg+0xab8/0x2980
> [  339.786766][  T969]  #1: ffffffff92925460 (rcu_read_lock_bh){....},
> at: ip_finish_output2+0x243/0x2150
> [  339.788308][  T969]  #2: ffffffff92925460 (rcu_read_lock_bh){....},
> at: __dev_queue_xmit+0x213/0x2e10
> [  339.790662][  T969]  #3: ffff88805a924158
> (&dev->qdisc_running_key#3){+...}, at: ip_finish_output2+0x714/0x2150
> [  339.792072][  T969]  #4: ffff88805b4fdc98
> (&dev->qdisc_xmit_lock_key#3){+.-.}, at: sch_direct_xmit+0x1e2/0x1020
> [  339.793445][  T969]
> [  339.793445][  T969] stack backtrace:
> [  339.794691][  T969] CPU: 3 PID: 969 Comm: ping Not tainted 5.5.0+ 
> #407
> [  339.795946][  T969] Hardware name: innotek GmbH
> VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
> [  339.797621][  T969] Call Trace:
> [  339.798249][  T969]  dump_stack+0x96/0xdb
> [  339.798847][  T969]  rmnet_get_port.part.9+0x76/0x80 [rmnet]
> [  339.799583][  T969]  rmnet_egress_handler+0x107/0x420 [rmnet]
> [  339.800350][  T969]  ? sch_direct_xmit+0x1e2/0x1020
> [  339.801027][  T969]  rmnet_vnd_start_xmit+0x3d/0xa0 [rmnet]
> [  339.801784][  T969]  dev_hard_start_xmit+0x160/0x740
> [  339.802667][  T969]  sch_direct_xmit+0x265/0x1020
> [ ... ]
> 
> Fixes: ceed73a2cf4a ("drivers: net: ethernet: qualcomm: rmnet: Initial
> implementation")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c  | 13 ++++++-------
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h  |  2 +-
>  .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c    |  4 ++--
>  drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c     |  2 ++
>  4 files changed, 11 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> index 7a7d0f521352..93642cdd3305 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.c
> @@ -382,11 +382,10 @@ struct rtnl_link_ops rmnet_link_ops __read_mostly 
> = {
>  	.fill_info	= rmnet_fill_info,
>  };
> 
> -/* Needs either rcu_read_lock() or rtnl lock */
> -struct rmnet_port *rmnet_get_port(struct net_device *real_dev)
> +struct rmnet_port *rmnet_get_port_rcu(struct net_device *real_dev)
>  {
>  	if (rmnet_is_real_dev_registered(real_dev))
> -		return rcu_dereference_rtnl(real_dev->rx_handler_data);
> +		return rcu_dereference(real_dev->rx_handler_data);
>  	else
>  		return NULL;
>  }
> @@ -412,7 +411,7 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
>  	struct rmnet_port *port, *slave_port;
>  	int err;
> 
> -	port = rmnet_get_port(real_dev);
> +	port = rmnet_get_port_rtnl(real_dev);
> 
>  	/* If there is more than one rmnet dev attached, its probably being
>  	 * used for muxing. Skip the briding in that case
> @@ -427,7 +426,7 @@ int rmnet_add_bridge(struct net_device *rmnet_dev,
>  	if (err)
>  		return -EBUSY;
> 
> -	slave_port = rmnet_get_port(slave_dev);
> +	slave_port = rmnet_get_port_rtnl(slave_dev);
>  	slave_port->rmnet_mode = RMNET_EPMODE_BRIDGE;
>  	slave_port->bridge_ep = real_dev;
> 
> @@ -445,11 +444,11 @@ int rmnet_del_bridge(struct net_device 
> *rmnet_dev,
>  	struct net_device *real_dev = priv->real_dev;
>  	struct rmnet_port *port, *slave_port;
> 
> -	port = rmnet_get_port(real_dev);
> +	port = rmnet_get_port_rtnl(real_dev);
>  	port->rmnet_mode = RMNET_EPMODE_VND;
>  	port->bridge_ep = NULL;
> 
> -	slave_port = rmnet_get_port(slave_dev);
> +	slave_port = rmnet_get_port_rtnl(slave_dev);
>  	rmnet_unregister_real_device(slave_dev, slave_port);
> 
>  	netdev_dbg(slave_dev, "removed from rmnet as slave\n");
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> index cd0a6bcbe74a..0d568dcfd65a 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h
> @@ -65,7 +65,7 @@ struct rmnet_priv {
>  	struct rmnet_priv_stats stats;
>  };
> 
> -struct rmnet_port *rmnet_get_port(struct net_device *real_dev);
> +struct rmnet_port *rmnet_get_port_rcu(struct net_device *real_dev);
>  struct rmnet_endpoint *rmnet_get_endpoint(struct rmnet_port *port, u8 
> mux_id);
>  int rmnet_add_bridge(struct net_device *rmnet_dev,
>  		     struct net_device *slave_dev,
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> index 1b74bc160402..074a8b326c30 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_handlers.c
> @@ -184,7 +184,7 @@ rx_handler_result_t rmnet_rx_handler(struct sk_buff 
> **pskb)
>  		return RX_HANDLER_PASS;
> 
>  	dev = skb->dev;
> -	port = rmnet_get_port(dev);
> +	port = rmnet_get_port_rcu(dev);
> 
>  	switch (port->rmnet_mode) {
>  	case RMNET_EPMODE_VND:
> @@ -217,7 +217,7 @@ void rmnet_egress_handler(struct sk_buff *skb)
>  	skb->dev = priv->real_dev;
>  	mux_id = priv->mux_id;
> 
> -	port = rmnet_get_port(skb->dev);
> +	port = rmnet_get_port_rcu(skb->dev);
>  	if (!port)
>  		goto drop;
> 
> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> index 509dfc895a33..a26e76e9d382 100644
> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
> @@ -50,7 +50,9 @@ static netdev_tx_t rmnet_vnd_start_xmit(struct 
> sk_buff *skb,
> 
>  	priv = netdev_priv(dev);
>  	if (priv->real_dev) {

This rcu lock shouldn't be needed as it is acquired already in
__dev_queue_xmit().

> +		rcu_read_lock();
>  		rmnet_egress_handler(skb);
> +		rcu_read_unlock();
>  	} else {
>  		this_cpu_inc(priv->pcpu_stats->stats.tx_drops);
>  		kfree_skb(skb);
