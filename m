Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39B6B2DB7D5
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:39:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgLPAia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:38:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:43534 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbgLPAi3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 19:38:29 -0500
Date:   Tue, 15 Dec 2020 16:37:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608079068;
        bh=d0I3wZLFxzfyWZ2VtV/JGKHi5598kKY9yv14hmrF/V4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=E1kkYpMeJSMlHpEKOBoT+eZG6JhveGGQQYkhvhdX2DKvFj2O+G9jumrJKVdNDetu6
         2XWcgx6cbUFNBrCp86kjtGE0J3pmrwyZAp9IsujRUgCi0ItY861W/WSBiKVIlnEI/w
         B/2aCiWq8EYLJg1rbovgpG5wvnxi2LzmHHdVmWpnbMLewD07iW3Crt6aUL/O0JV2vE
         a/TuYxXU9Kf3TVi43rST5vUtA46jZkfSIrdr/5spZR/+XibQF3tGJtdZnVycckhddL
         YqcLkwEmsK5e1U20XrsW5AagIb9L7NM5mDs+oZfVsRoarV48PBKyVfCoqrEk1LpXRG
         RCUVf2c5rGWdg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        david.m.ertman@intel.com, dan.j.williams@intel.com,
        kiran.patil@intel.com, gregkh@linuxfoundation.org,
        Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net-next v5 05/15] devlink: Support get and set state of port
 function
Message-ID: <20201215163747.4091ff61@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215090358.240365-6-saeed@kernel.org>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-6-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 01:03:48 -0800 Saeed Mahameed wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> devlink port function can be in active or inactive state.
> Allow users to get and set port function's state.
> 
> When the port function it activated, its operational state may change
> after a while when the device is created and driver binds to it.
> Similarly on deactivation flow.

So what's the flow device should implement?

User requests deactivated, the device sends a notification to 
the driver bound to the device. What if the driver ignores it?

> To clearly describe the state of the port function and its device's
> operational state in the host system, define state and opstate
> attributes.
> 
> Example of a PCI SF port which supports a port function:
> Create a device with ID=10 and one physical port.
> 
> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
> 
> $ devlink port show
> pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false
> 
> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
> 
> $ devlink port show pci/0000:06:00.0/32768
> pci/0000:06:00.0/32768: type eth netdev ens2f0npf0sf88 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
>   function:
>     hw_addr 00:00:00:00:88:88 state inactive opstate detached
> 
> $ devlink port function set pci/0000:06:00.0/32768 hw_addr 00:00:00:00:88:88 state active

Is request to deactivate done by settings state to inactive?

> $ devlink port show pci/0000:06:00.0/32768 -jp
> {
>     "port": {
>         "pci/0000:06:00.0/32768": {
>             "type": "eth",
>             "netdev": "ens2f0npf0sf88",
>             "flavour": "pcisf",
>             "controller": 0,
>             "pfnum": 0,
>             "sfnum": 88,
>             "external": false,
>             "splittable": false,
>             "function": {
>                 "hw_addr": "00:00:00:00:88:88",
>                 "state": "active",
>                 "opstate": "attached"
>             }
>         }
>     }
> }
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Vu Pham <vuhuong@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

> + * enum devlink_port_function_opstate - indicates operational state of port function
> + * @DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED: Driver is attached to the function of port,

This name definitely needs to be shortened.

> + *					    gracefufl tear down of the function, after

gracefufl

> + *					    inactivation of the port function, user should wait
> + *					    for operational state to turn DETACHED.

Why do you indent the comment by 40 characters and then go over 80
chars?

> + * @DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED: Driver is detached from the function of port; it is
> + *					    safe to delete the port.
> + */
> +enum devlink_port_function_opstate {
> +	DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED,

The port function must be some Mellanox speak - for the second time - 
I have no idea what it means. Please use meaningful names.

> +	DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED,
> +};
> +
>  #endif /* _UAPI_LINUX_DEVLINK_H_ */
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 11043707f63f..b8acb8842aa1 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -87,6 +87,9 @@ EXPORT_TRACEPOINT_SYMBOL_GPL(devlink_trap_report);
>  
>  static const struct nla_policy devlink_function_nl_policy[DEVLINK_PORT_FUNCTION_ATTR_MAX + 1] = {
>  	[DEVLINK_PORT_FUNCTION_ATTR_HW_ADDR] = { .type = NLA_BINARY },
> +	[DEVLINK_PORT_FUNCTION_ATTR_STATE] =
> +		NLA_POLICY_RANGE(NLA_U8, DEVLINK_PORT_FUNCTION_STATE_INACTIVE,
> +				 DEVLINK_PORT_FUNCTION_STATE_ACTIVE),
>  };
>  
>  static LIST_HEAD(devlink_list);
> @@ -746,6 +749,57 @@ devlink_port_function_hw_addr_fill(struct devlink *devlink, const struct devlink
>  	return 0;
>  }
>  
> +static bool
> +devlink_port_function_state_valid(enum devlink_port_function_state state)
> +{
> +	return state == DEVLINK_PORT_FUNCTION_STATE_INACTIVE ||
> +	       state == DEVLINK_PORT_FUNCTION_STATE_ACTIVE;
> +}
> +
> +static bool
> +devlink_port_function_opstate_valid(enum devlink_port_function_opstate state)
> +{
> +	return state == DEVLINK_PORT_FUNCTION_OPSTATE_DETACHED ||
> +	       state == DEVLINK_PORT_FUNCTION_OPSTATE_ATTACHED;
> +}
> +
> +static int
> +devlink_port_function_state_fill(struct devlink *devlink,
> +				 const struct devlink_ops *ops,
> +				 struct devlink_port *port, struct sk_buff *msg,
> +				 struct netlink_ext_ack *extack,
> +				 bool *msg_updated)
> +{
> +	enum devlink_port_function_opstate opstate;
> +	enum devlink_port_function_state state;
> +	int err;
> +
> +	if (!ops->port_function_state_get)
> +		return 0;
> +
> +	err = ops->port_function_state_get(devlink, port, &state, &opstate, extack);
> +	if (err) {
> +		if (err == -EOPNOTSUPP)
> +			return 0;
> +		return err;
> +	}
> +	if (!devlink_port_function_state_valid(state)) {
> +		WARN_ON_ONCE(1);
> +		NL_SET_ERR_MSG_MOD(extack, "Invalid state value read from driver");
> +		return -EINVAL;
> +	}
> +	if (!devlink_port_function_opstate_valid(opstate)) {
> +		WARN_ON_ONCE(1);
> +		NL_SET_ERR_MSG_MOD(extack, "Invalid operational state value read from driver");
> +		return -EINVAL;
> +	}
> +	if (nla_put_u8(msg, DEVLINK_PORT_FUNCTION_ATTR_STATE, state) ||
> +	    nla_put_u8(msg, DEVLINK_PORT_FUNCTION_ATTR_OPSTATE, opstate))
> +		return -EMSGSIZE;
> +	*msg_updated = true;
> +	return 0;
> +}
> +
>  static int
>  devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
>  				   struct netlink_ext_ack *extack)
> @@ -762,6 +816,13 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
>  
>  	ops = devlink->ops;
>  	err = devlink_port_function_hw_addr_fill(devlink, ops, port, msg, extack, &msg_updated);

Wrap your code, please.

> +	if (err)
> +		goto out;
> +	err = devlink_port_function_state_fill(devlink, ops, port, msg, extack,
> +					       &msg_updated);
> +	if (err)
> +		goto out;
> +out:
>  	if (err || !msg_updated)
>  		nla_nest_cancel(msg, function_attr);
>  	else
