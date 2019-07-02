Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B83875CFD4
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 14:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726980AbfGBMy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 08:54:58 -0400
Received: from albert.telenet-ops.be ([195.130.137.90]:58288 "EHLO
        albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfGBMy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 08:54:57 -0400
Received: from ramsan ([84.194.98.4])
        by albert.telenet-ops.be with bizsmtp
        id Xoup2000305gfCL06oup4h; Tue, 02 Jul 2019 14:54:54 +0200
Received: from geert (helo=localhost)
        by ramsan with local-esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hiIJ7-0001Wd-2N; Tue, 02 Jul 2019 14:54:49 +0200
Date:   Tue, 2 Jul 2019 14:54:49 +0200 (CEST)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Mahesh Bandewar <maheshb@google.com>
cc:     Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Michael Chan <michael.chan@broadcom.com>,
        Daniel Axtens <dja@axtens.net>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        "Paul E. McKenney" <paulmck@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: suspicious RCU usage (was: Re: [PATCHv3 next 1/3] loopback: create
 blackhole net device similar to loopack.)
In-Reply-To: <20190701213849.102759-1-maheshb@google.com>
Message-ID: <alpine.DEB.2.21.1907021450320.5764@ramsan.of.borg>
References: <20190701213849.102759-1-maheshb@google.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 	Hi Mahesh,

On Mon, 1 Jul 2019, Mahesh Bandewar wrote:
> Create a blackhole net device that can be used for "dead"
> dst entries instead of loopback device. This blackhole device differs
> from loopback in few aspects: (a) It's not per-ns. (b)  MTU on this
> device is ETH_MIN_MTU (c) The xmit function is essentially kfree_skb().
> and (d) since it's not registered it won't have ifindex.
>
> Lower MTU effectively make the device not pass the MTU check during
> the route check when a dst associated with the skb is dead.
>
> Signed-off-by: Mahesh Bandewar <maheshb@google.com>

This is now commit 4de83b88c66a1e4d ("loopback: create blackhole net
device similar to loopack.") in net-next, and causes the following
warning on arm64:

     WARNING: suspicious RCU usage
     5.2.0-rc6-arm64-renesas-01699-g4de83b88c66a1e4d #263 Not tainted
     -----------------------------
     include/linux/rtnetlink.h:85 suspicious rcu_dereference_protected() usage!

     other info that might help us debug this:


     rcu_scheduler_active = 2, debug_locks = 1
     no locks held by swapper/0/1.

     stack backtrace:
     CPU: 2 PID: 1 Comm: swapper/0 Not tainted 5.2.0-rc6-arm64-renesas-01699-g4de83b88c66a1e4d #263
     Hardware name: Renesas Salvator-X 2nd version board based on r8a7795 ES2.0+ (DT)
     Call trace:
      dump_backtrace+0x0/0x148
      show_stack+0x14/0x20
      dump_stack+0xd4/0x11c
      lockdep_rcu_suspicious+0xcc/0x110
      dev_init_scheduler+0x114/0x150
      blackhole_netdev_init+0x40/0x80
      do_one_initcall+0x178/0x37c
      kernel_init_freeable+0x490/0x530
      kernel_init+0x10/0x100
      ret_from_fork+0x10/0x1c


> ---
> v1->v2->v3
>  no change
>
> drivers/net/loopback.c    | 76 ++++++++++++++++++++++++++++++++++-----
> include/linux/netdevice.h |  2 ++
> 2 files changed, 69 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/net/loopback.c b/drivers/net/loopback.c
> index 87d361666cdd..3b39def5471e 100644
> --- a/drivers/net/loopback.c
> +++ b/drivers/net/loopback.c
> @@ -55,6 +55,13 @@
> #include <net/net_namespace.h>
> #include <linux/u64_stats_sync.h>
>
> +/* blackhole_netdev - a device used for dsts that are marked expired!
> + * This is global device (instead of per-net-ns) since it's not needed
> + * to be per-ns and gets initialized at boot time.
> + */
> +struct net_device *blackhole_netdev;
> +EXPORT_SYMBOL(blackhole_netdev);
> +
> /* The higher levels take care of making this non-reentrant (it's
>  * called with bh's disabled).
>  */
> @@ -150,12 +157,14 @@ static const struct net_device_ops loopback_ops = {
> 	.ndo_set_mac_address = eth_mac_addr,
> };
>
> -/* The loopback device is special. There is only one instance
> - * per network namespace.
> - */
> -static void loopback_setup(struct net_device *dev)
> +static void gen_lo_setup(struct net_device *dev,
> +			 unsigned int mtu,
> +			 const struct ethtool_ops *eth_ops,
> +			 const struct header_ops *hdr_ops,
> +			 const struct net_device_ops *dev_ops,
> +			 void (*dev_destructor)(struct net_device *dev))
> {
> -	dev->mtu		= 64 * 1024;
> +	dev->mtu		= mtu;
> 	dev->hard_header_len	= ETH_HLEN;	/* 14	*/
> 	dev->min_header_len	= ETH_HLEN;	/* 14	*/
> 	dev->addr_len		= ETH_ALEN;	/* 6	*/
> @@ -174,11 +183,20 @@ static void loopback_setup(struct net_device *dev)
> 		| NETIF_F_NETNS_LOCAL
> 		| NETIF_F_VLAN_CHALLENGED
> 		| NETIF_F_LOOPBACK;
> -	dev->ethtool_ops	= &loopback_ethtool_ops;
> -	dev->header_ops		= &eth_header_ops;
> -	dev->netdev_ops		= &loopback_ops;
> +	dev->ethtool_ops	= eth_ops;
> +	dev->header_ops		= hdr_ops;
> +	dev->netdev_ops		= dev_ops;
> 	dev->needs_free_netdev	= true;
> -	dev->priv_destructor	= loopback_dev_free;
> +	dev->priv_destructor	= dev_destructor;
> +}
> +
> +/* The loopback device is special. There is only one instance
> + * per network namespace.
> + */
> +static void loopback_setup(struct net_device *dev)
> +{
> +	gen_lo_setup(dev, (64 * 1024), &loopback_ethtool_ops, &eth_header_ops,
> +		     &loopback_ops, loopback_dev_free);
> }
>
> /* Setup and register the loopback device. */
> @@ -213,3 +231,43 @@ static __net_init int loopback_net_init(struct net *net)
> struct pernet_operations __net_initdata loopback_net_ops = {
> 	.init = loopback_net_init,
> };
> +
> +/* blackhole netdevice */
> +static netdev_tx_t blackhole_netdev_xmit(struct sk_buff *skb,
> +					 struct net_device *dev)
> +{
> +	kfree_skb(skb);
> +	net_warn_ratelimited("%s(): Dropping skb.\n", __func__);
> +	return NETDEV_TX_OK;
> +}
> +
> +static const struct net_device_ops blackhole_netdev_ops = {
> +	.ndo_start_xmit = blackhole_netdev_xmit,
> +};
> +
> +/* This is a dst-dummy device used specifically for invalidated
> + * DSTs and unlike loopback, this is not per-ns.
> + */
> +static void blackhole_netdev_setup(struct net_device *dev)
> +{
> +	gen_lo_setup(dev, ETH_MIN_MTU, NULL, NULL, &blackhole_netdev_ops, NULL);
> +}
> +
> +/* Setup and register the blackhole_netdev. */
> +static int __init blackhole_netdev_init(void)
> +{
> +	blackhole_netdev = alloc_netdev(0, "blackhole_dev", NET_NAME_UNKNOWN,
> +					blackhole_netdev_setup);
> +	if (!blackhole_netdev)
> +		return -ENOMEM;
> +
> +	dev_init_scheduler(blackhole_netdev);
> +	dev_activate(blackhole_netdev);
> +
> +	blackhole_netdev->flags |= IFF_UP | IFF_RUNNING;
> +	dev_net_set(blackhole_netdev, &init_net);
> +
> +	return 0;
> +}
> +
> +device_initcall(blackhole_netdev_init);
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index eeacebd7debb..88292953aa6f 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4870,4 +4870,6 @@ do {								\
> #define PTYPE_HASH_SIZE	(16)
> #define PTYPE_HASH_MASK	(PTYPE_HASH_SIZE - 1)
>
> +extern struct net_device *blackhole_netdev;
> +
> #endif	/* _LINUX_NETDEVICE_H */
>
Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds

