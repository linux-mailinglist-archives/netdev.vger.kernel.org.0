Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2AE2CAB8C
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731320AbgLATM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:12:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:46678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730327AbgLATMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 14:12:25 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9E3C2151B;
        Tue,  1 Dec 2020 19:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606849905;
        bh=0rk1oH1RqKRAoCWkLwxasYF5CTTqkWhV5+t/5Wc/h2c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZkcdL1lvlTWL03dqBtM9mjU6bvwDwZJumD32y9VNLQMvpz1hFRxmDhvEAjn8UtPtJ
         46xSZjH94xNY8yXzctO/wgudjiPCMevgBjvw1KXBf3etBgJtlejj9g2DC2Bw5gdIlc
         Qa3Kzx43l0rpXbBjOxcmqbB1iO0Mz+M+PoR5Dt5w=
Date:   Tue, 1 Dec 2020 11:11:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Thomas Karlsson <thomas.karlsson@paneda.se>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        <jiri@resnulli.us>, <kaber@trash.net>, <edumazet@google.com>,
        <vyasevic@redhat.com>, <alexander.duyck@gmail.com>
Subject: Re: [PATCH net-next v3] macvlan: Support for high multicast packet
 rate
Message-ID: <20201201111143.2a82d744@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <0c88607c-1b63-e8b5-8a84-14b63e55e8e2@paneda.se>
References: <485531aec7e243659ee4e3bb7fa2186d@paneda.se>
        <147b704ac1d5426fbaa8617289dad648@paneda.se>
        <20201123143052.1176407d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0c88607c-1b63-e8b5-8a84-14b63e55e8e2@paneda.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 Nov 2020 15:00:43 +0100 Thomas Karlsson wrote:
> Background:
> Broadcast and multicast packages are enqueued for later processing.
> This queue was previously hardcoded to 1000.
> 
> This proved insufficient for handling very high packet rates.
> This resulted in packet drops for multicast.
> While at the same time unicast worked fine.
> 
> The change:
> This patch make the queue length adjustable to accommodate
> for environments with very high multicast packet rate.
> But still keeps the default value of 1000 unless specified.
> 
> The queue length is specified as a request per macvlan
> using the IFLA_MACVLAN_BC_QUEUE_LEN parameter.
> 
> The actual used queue length will then be the maximum of
> any macvlan connected to the same port. The actual used
> queue length for the port can be retrieved (read only)
> by the IFLA_MACVLAN_BC_QUEUE_LEN_USED parameter for verification.
> 
> This will be followed up by a patch to iproute2
> in order to adjust the parameter from userspace.
> 
> Signed-off-by: Thomas Karlsson <thomas.karlsson@paneda.se>

Looks good! Minor nits below:

> @@ -1218,6 +1220,7 @@ static int macvlan_port_create(struct net_device *dev)
>  	for (i = 0; i < MACVLAN_HASH_SIZE; i++)
>  		INIT_HLIST_HEAD(&port->vlan_source_hash[i]);
>  
> +	port->bc_queue_len_used = MACVLAN_DEFAULT_BC_QUEUE_LEN;

Should this be inited to 0? Otherwise if the first link asks for lower
queue len than the default it will not get set, right?

>  	skb_queue_head_init(&port->bc_queue);
>  	INIT_WORK(&port->bc_work, macvlan_process_broadcast);
>  
> @@ -1486,6 +1489,12 @@ int macvlan_common_newlink(struct net *src_net, struct net_device *dev,
>  			goto destroy_macvlan_port;
>  	}
>  
> +	vlan->bc_queue_len_requested = MACVLAN_DEFAULT_BC_QUEUE_LEN;
> +	if (data && data[IFLA_MACVLAN_BC_QUEUE_LEN])
> +		vlan->bc_queue_len_requested = nla_get_u32(data[IFLA_MACVLAN_BC_QUEUE_LEN]);
> +	if (vlan->bc_queue_len_requested > port->bc_queue_len_used)
> +		port->bc_queue_len_used = vlan->bc_queue_len_requested;

Or perhaps we should just call update_port_bc_queue_len() here?

>  	err = register_netdevice(dev);
>  	if (err < 0)
>  		goto destroy_macvlan_port;

> @@ -1658,6 +1684,8 @@ static const struct nla_policy macvlan_policy[IFLA_MACVLAN_MAX + 1] = {
>  	[IFLA_MACVLAN_MACADDR] = { .type = NLA_BINARY, .len = MAX_ADDR_LEN },
>  	[IFLA_MACVLAN_MACADDR_DATA] = { .type = NLA_NESTED },
>  	[IFLA_MACVLAN_MACADDR_COUNT] = { .type = NLA_U32 },
> +	[IFLA_MACVLAN_BC_QUEUE_LEN] = { .type = NLA_U32 },
> +	[IFLA_MACVLAN_BC_QUEUE_LEN_USED] = { .type = NLA_U32 },

This is an input policy, so you can set type to NLA_REJECT and you
won't have to check if it's set on input.

>  };
>  
>  int macvlan_link_register(struct rtnl_link_ops *ops)
> @@ -1688,6 +1716,18 @@ static struct rtnl_link_ops macvlan_link_ops = {
>  	.priv_size      = sizeof(struct macvlan_dev),
>  };
>  
> +static void update_port_bc_queue_len(struct macvlan_port *port)
> +{
> +	struct macvlan_dev *vlan;
> +	u32 max_bc_queue_len_requested = 0;

Please reorder so that the vars are longest line to shortest.

> +	list_for_each_entry_rcu(vlan, &port->vlans, list) {

I don't think you need the _rcu() flavor here, this is always called
from the configuration paths holding RTNL lock, right?

> +		if (vlan->bc_queue_len_requested > max_bc_queue_len_requested)
> +			max_bc_queue_len_requested = vlan->bc_queue_len_requested;
> +	}
> +	port->bc_queue_len_used = max_bc_queue_len_requested;
> +}
> +
>  static int macvlan_device_event(struct notifier_block *unused,
>  				unsigned long event, void *ptr)
>  {
