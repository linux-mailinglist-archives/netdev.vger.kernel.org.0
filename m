Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 500294EB792
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 02:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241513AbiC3A4L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 20:56:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241050AbiC3A4K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 20:56:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0D310E048;
        Tue, 29 Mar 2022 17:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 063F8B8197B;
        Wed, 30 Mar 2022 00:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE617C2BBE4;
        Wed, 30 Mar 2022 00:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648601663;
        bh=ubFHj+K9Ba1I+teDUAJ4JZ4+3y1MplBuqIus6GiwDiw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CBmVsgFhCDd+NEOP2ZOO8xSxJYSrIIdrIXwb0PPG+cVPwXOeRa9wHuJhuD7X0rKua
         lAfcF+KsgnVj1artMm1qqfYlEOH96q6yGvdVKRY2JmaggOVzX9fhFjtTCVnCuA2ybb
         v0gzV9pyn3829oLYBnWI0jqN3eB7O64Q/RcXPTvl/GChNzGvLoZEBSBT6dIysui+MD
         KQ3nJAvXV+Fp4XfUXBfocdC6dRUmOs1dgJ6qqb7nllxWtGO7Q9VEr0SX+GIj7RHSGz
         8Yx0QDNvFuNo+aVCXfEZ1Hd7keBsarI+Qr/reW1y+7im0i/82dpbHYszks7ICxy5Wo
         VC/PXLSMeyVrA==
Date:   Tue, 29 Mar 2022 17:54:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexandra Winter <wintera@linux.ibm.com>,
        Nikolay Aleksandrov <razor@blackwall.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, Heiko Carstens <hca@linux.ibm.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        bridge@lists.linux-foundation.org,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Jay Vosburgh <j.vosburgh@gmail.com>
Subject: Re: [PATCH net-next v2] veth: Support bonding events
Message-ID: <20220329175421.4a6325d9@kernel.org>
In-Reply-To: <20220329114052.237572-1-wintera@linux.ibm.com>
References: <20220329114052.237572-1-wintera@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dropping the BPF people from CC and adding Hangbin, bridge and
bond/team. Please exercise some judgment when sending patches.

On Tue, 29 Mar 2022 13:40:52 +0200 Alexandra Winter wrote:
> Bonding drivers generate specific events during failover that trigger
> switch updates.  When a veth device is attached to a bridge with a
> bond interface, we want external switches to learn about the veth
> devices as well.
> 
> Example:
> 
> 	| veth_a2   |  veth_b2  |  veth_c2 |
> 	------o-----------o----------o------
> 	       \	  |	    /
> 		o	  o	   o
> 	      veth_a1  veth_b1  veth_c1
> 	      -------------------------
> 	      |        bridge         |
> 	      -------------------------
> 			bond0
> 			/  \
> 		     eth0  eth1
> 
> In case of failover from eth0 to eth1, the netdev_notifier needs to be
> propagated, so e.g. veth_a2 can re-announce its MAC address to the
> external hardware attached to eth1.
> 
> Without this patch we have seen cases where recovery after bond failover
> took an unacceptable amount of time (depending on timeout settings in the
> network).
> 
> Due to the symmetric nature of veth special care is required to avoid
> endless notification loops. Therefore we only notify from a veth
> bridgeport to a peer that is not a bridgeport.
> 
> References:
> Same handling as for macvlan:
> commit 4c9912556867 ("macvlan: Support bonding events")
> and vlan:
> commit 4aa5dee4d999 ("net: convert resend IGMP to notifier event")
> 
> Alternatives:
> Propagate notifier events to all ports of a bridge. IIUC, this was
> rejected in https://www.spinics.net/lists/netdev/msg717292.html

My (likely flawed) reading of Nik's argument was that (1) he was
concerned about GARP storms; (2) he didn't want the GARP to be
broadcast to all ports, just the bond that originated the request.

I'm not sure I follow (1), as Hangbin said the event is rare, plus 
GARP only comes from interfaces that have an IP addr, which IIUC
most bridge ports will not have.

This patch in no way addresses (2). But then, again, if we put 
a macvlan on top of a bridge master it will shotgun its GARPS all 
the same. So it's not like veth would be special in that regard.

Nik, what am I missing?

> It also seems difficult to avoid re-bouncing the notifier.

syzbot will make short work of this patch, I think the potential
for infinite loops has to be addressed somehow. IIUC this is the 
first instance of forwarding those notifiers to a peer rather
than within a upper <> lower device hierarchy which is a DAG.

> Signed-off-by: Alexandra Winter <wintera@linux.ibm.com>
> ---
>  drivers/net/veth.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index d29fb9759cc9..74b074453197 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -1579,6 +1579,57 @@ static void veth_setup(struct net_device *dev)
>  	dev->mpls_features = NETIF_F_HW_CSUM | NETIF_F_GSO_SOFTWARE;
>  }
>  
> +static bool netif_is_veth(const struct net_device *dev)
> +{
> +	return (dev->netdev_ops == &veth_netdev_ops);

brackets unnecessary 

> +}
> +
> +static void veth_notify_peer(unsigned long event, const struct net_device *dev)
> +{
> +	struct net_device *peer;
> +	struct veth_priv *priv;
> +
> +	priv = netdev_priv(dev);
> +	peer = rtnl_dereference(priv->peer);
> +	/* avoid re-bounce between 2 bridges */
> +	if (!netif_is_bridge_port(peer))
> +		call_netdevice_notifiers(event, peer);
> +}
> +
> +/* Called under rtnl_lock */
> +static int veth_device_event(struct notifier_block *unused,
> +			     unsigned long event, void *ptr)
> +{
> +	struct net_device *dev, *lower;
> +	struct list_head *iter;
> +
> +	dev = netdev_notifier_info_to_dev(ptr);
> +
> +	switch (event) {
> +	case NETDEV_NOTIFY_PEERS:
> +	case NETDEV_BONDING_FAILOVER:
> +	case NETDEV_RESEND_IGMP:
> +		/* propagate to peer of a bridge attached veth */
> +		if (netif_is_bridge_master(dev)) {

Having veth sift thru bridge ports seems strange.
In fact it could be beneficial to filter the event based on
port state (whether it's forwarding, vlan etc). But looking
at details of port state outside the bridge would be even stranger.

> +			iter = &dev->adj_list.lower;
> +			lower = netdev_next_lower_dev_rcu(dev, &iter);
> +			while (lower) {
> +				if (netif_is_veth(lower))
> +					veth_notify_peer(event, lower);
> +				lower = netdev_next_lower_dev_rcu(dev, &iter);

let's add netdev_for_each_lower_dev_rcu() rather than open-coding

> +			}
> +		}
> +		break;
> +	default:
> +		break;
> +	}
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block veth_notifier_block __read_mostly = {
> +		.notifier_call  = veth_device_event,

extra tab here

> +};
> +
>  /*
>   * netlink interface
>   */
> @@ -1824,12 +1875,14 @@ static struct rtnl_link_ops veth_link_ops = {
>  
>  static __init int veth_init(void)
>  {
> +	register_netdevice_notifier(&veth_notifier_block);

this can fail

>  	return rtnl_link_register(&veth_link_ops);
>  }
>  
>  static __exit void veth_exit(void)
>  {
>  	rtnl_link_unregister(&veth_link_ops);
> +	unregister_netdevice_notifier(&veth_notifier_block);
>  }
>  
>  module_init(veth_init);

