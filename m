Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636942DB7CF
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 01:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgLPAaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 19:30:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:42426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725275AbgLPAaJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 19:30:09 -0500
Date:   Tue, 15 Dec 2020 16:29:26 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608078568;
        bh=VTkAUEAF6WkXQR4gu6m9CwYBNRNST+TytdolTSVmuu4=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=hhQqeADMM/A/U51ubJr3+NZz/pYlUuGyNii/DZaPzs1vQVe2E8N6wY+3WWUanwz/z
         11YuG4J85z9xZAqrkCMqXpuoxaWz431qvDAMfl7pIsbuyVnVX6xWr99iw2o9FmdOkN
         ZoFxZhTYn5nKCA7z70/FUD0DyenyDwMVPa+fQcbmATsTeRi5h5vKDlLBTYJJK1CXyD
         T4tv0mnvMv/B7ccj3jH4rfvtW4XeaLe+I7QrgFi1hm5ueOANyJ3JODDRZBbo14b/m/
         rBs8XEyTH3TR4g08BHOKY7p8M4/vlwUWZAG719/ocuXGSc02uyJvIxa2B886LA8tJB
         G6tOfhXK9uhMw==
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
Subject: Re: [net-next v5 04/15] devlink: Support add and delete devlink
 port
Message-ID: <20201215162926.0d7f3683@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215090358.240365-5-saeed@kernel.org>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-5-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Dec 2020 01:03:47 -0800 Saeed Mahameed wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> Extended devlink interface for the user to add and delete port.
> Extend devlink to connect user requests to driver to add/delete
> such port in the device.
> 
> When driver routines are invoked, devlink instance lock is not held.
> This enables driver to perform several devlink objects registration,
> unregistration such as (port, health reporter, resource etc)
> by using existing devlink APIs.
> This also helps to uniformly use the code for port unregistration
> during driver unload and during port deletion initiated by user.
> 
> Examples of add, show and delete commands:
> $ devlink dev eswitch set pci/0000:06:00.0 mode switchdev
> 
> $ devlink port show
> pci/0000:06:00.0/65535: type eth netdev ens2f0np0 flavour physical port 0 splittable false
> 
> $ devlink port add pci/0000:06:00.0 flavour pcisf pfnum 0 sfnum 88
> 
> $ devlink port show pci/0000:06:00.0/32768
> pci/0000:06:00.0/32768: type eth netdev eth0 flavour pcisf controller 0 pfnum 0 sfnum 88 external false splittable false
>   function:
>     hw_addr 00:00:00:00:88:88 state inactive opstate detached
> 
> $ udevadm test-builtin net_id /sys/class/net/eth0
> Load module index
> Parsed configuration file /usr/lib/systemd/network/99-default.link
> Created link configuration context.
> Using default interface naming scheme 'v245'.
> ID_NET_NAMING_SCHEME=v245
> ID_NET_NAME_PATH=enp6s0f0npf0sf88
> ID_NET_NAME_SLOT=ens2f0npf0sf88
> Unload module index
> Unloaded link configuration context.
> 
> Signed-off-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Vu Pham <vuhuong@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 5bd43f0a79a8..f8cff3e402da 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -153,6 +153,17 @@ struct devlink_port {
>  	struct mutex reporters_lock; /* Protects reporter_list */
>  };
>  
> +struct devlink_port_new_attrs {
> +	enum devlink_port_flavour flavour;
> +	unsigned int port_index;
> +	u32 controller;
> +	u32 sfnum;
> +	u16 pfnum;

Oh. So you had the structure which actually gets stored in memory for
the lifetime of the device in patch 3 mispacked (u32 / u16 / u32 / u8).
But this one with arguments is packed. Please be consistent.

> +	u8 port_index_valid:1,
> +	   controller_valid:1,
> +	   sfnum_valid:1;
> +};
> +
>  struct devlink_sb_pool_info {
>  	enum devlink_sb_pool_type pool_type;
>  	u32 size;
> @@ -1363,6 +1374,34 @@ struct devlink_ops {
>  	int (*port_function_hw_addr_set)(struct devlink *devlink, struct devlink_port *port,
>  					 const u8 *hw_addr, int hw_addr_len,
>  					 struct netlink_ext_ack *extack);
> +	/**
> +	 * @port_new: Port add function.
> +	 *
> +	 * Should be used by device driver to let caller add new port of a
> +	 * specified flavour with optional attributes.

Add a new port of a specified flavor with optional attributes.

> +	 * Driver should return -EOPNOTSUPP if it doesn't support port addition

s/should/must/

> +	 * of a specified flavour or specified attributes. Driver should set
> +	 * extack error message in case of fail to add the port. Devlink core

s/fail to add the port/failure/

> +	 * does not hold a devlink instance lock when this callback is invoked.

Called without holding the devlink instance lock.

> +	 * Driver must ensures synchronization when adding or deleting a port.

s/ensures/ensure/ but really that's pretty obvious from the previous
sentence.

> +	 * Driver must register a port with devlink core.

s/must/is expected to/

Please make sure your comments and documentation are proof read by
someone.

> +static int devlink_nl_cmd_port_new_doit(struct sk_buff *skb,
> +					struct genl_info *info)
> +{
> +	struct netlink_ext_ack *extack = info->extack;
> +	struct devlink_port_new_attrs new_attrs = {};
> +	struct devlink *devlink = info->user_ptr[0];
> +
> +	if (!info->attrs[DEVLINK_ATTR_PORT_FLAVOUR] ||
> +	    !info->attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]) {
> +		NL_SET_ERR_MSG_MOD(extack, "Port flavour or PCI PF are not specified");
> +		return -EINVAL;
> +	}
> +	new_attrs.flavour = nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_FLAVOUR]);
> +	new_attrs.pfnum =
> +		nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_PCI_PF_NUMBER]);
> +
> +	if (info->attrs[DEVLINK_ATTR_PORT_INDEX]) {
> +		new_attrs.port_index =
> +			nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_INDEX]);
> +		new_attrs.port_index_valid = true;
> +	}

This is the desired port index of the new port?
Or the index of the parent port?
Let's make it abundantly clear since its a pass-thru argument for the
driver to interpret.

> +	if (info->attrs[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER]) {
> +		new_attrs.controller =
> +			nla_get_u16(info->attrs[DEVLINK_ATTR_PORT_CONTROLLER_NUMBER]);
> +		new_attrs.controller_valid = true;
> +	}
> +	if (info->attrs[DEVLINK_ATTR_PORT_PCI_SF_NUMBER]) {
> +		new_attrs.sfnum = nla_get_u32(info->attrs[DEVLINK_ATTR_PORT_PCI_SF_NUMBER]);
> +		new_attrs.sfnum_valid = true;
> +	}
> +
> +	if (!devlink->ops->port_new)
> +		return -EOPNOTSUPP;

Why is this check not at the beginning of the function?
Also should there be an extack on it?

> +	return devlink->ops->port_new(devlink, &new_attrs, extack);

This should return the identifier of the created port back to user
space.
