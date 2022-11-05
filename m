Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9134361A712
	for <lists+netdev@lfdr.de>; Sat,  5 Nov 2022 03:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbiKECxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 22:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKECxr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 22:53:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 263142B6
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 19:53:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3C4A6239D
        for <netdev@vger.kernel.org>; Sat,  5 Nov 2022 02:53:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6CB0C433D6;
        Sat,  5 Nov 2022 02:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667616825;
        bh=KyakwN8KnaumyotG2geQY3yVUJ091goaHayiW4Wc3dk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W6l3XlV36CtxzFTmS2e28TCWv4nuKEVYJFAx5jkeESca1Pu9MJp5bW/UYRWN2lWmU
         MUbjktxmXJtU0OVw2ryreNnEelU7iREV8mocS/85vse9sZRxeMxprAx5Pld6z7lL+B
         KWOZkzgS/DKXsLHbdyL6ReiEF0Ynp6Ols/pjO2shNRHzS160xeMs24R4vK5JKBDWzb
         tIDoRwiNoSk+hiaVvWM9U51ykLOMxS+MH+xGfa56suman9raI2aXwSTkzonCSDjY3P
         W65hEZt2sTQnLP4QkYycb9cMpSfVd4UgFfq6/5rMaiqbJh73aP1NVnl9srzgZvH5sr
         8/k33SCSkDgew==
Date:   Fri, 4 Nov 2022 19:53:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Jurgens <danielj@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <parav@nvidia.com>, <saeedm@nvidia.com>, <yishaih@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH 1/2] devlink: Expose port function commands to control
 roce
Message-ID: <20221104195343.5033e62d@kernel.org>
In-Reply-To: <20221102163954.279266-2-danielj@nvidia.com>
References: <20221102163954.279266-1-danielj@nvidia.com>
        <20221102163954.279266-2-danielj@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Nov 2022 18:39:53 +0200 Daniel Jurgens wrote:
> From: Yishai Hadas <yishaih@nvidia.com>
> 
> Expose port function commands to turn on / off roce, this is used to
> control the port roce device capabilities.
> 
> When roce is disabled for a function of the port, function cannot create
> any roce specific resources (e.g GID table).
> It also saves system memory utilization. For example disabling roce on a
> VF/SF saves 1 Mbytes of system memory per function.
> 
> Example of a PCI VF port which supports function configuration:
> Set roce of the VF's port function.
> 
> $ devlink port show pci/0000:06:00.0/2
> pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
>     function:
>         hw_addr 00:00:00:00:00:00 roce on
> 
> $ devlink port function set pci/0000:06:00.0/2 roce off
> 
> $ devlink port show pci/0000:06:00.0/2
> pci/0000:06:00.0/2: type eth netdev enp6s0pf0vf1 flavour pcivf pfnum 0 vfnum 1
>     function:
>         hw_addr 00:11:22:33:44:55 roce off
> 
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
> Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>

LGTM, handful of minor nit picks:

> diff --git a/Documentation/networking/devlink/devlink-port.rst b/Documentation/networking/devlink/devlink-port.rst
> index 7627b1da01f2..fd191622ab68 100644
> --- a/Documentation/networking/devlink/devlink-port.rst
> +++ b/Documentation/networking/devlink/devlink-port.rst
> @@ -110,7 +110,7 @@ devlink ports for both the controllers.
>  Function configuration
>  ======================
>  
> -A user can configure the function attribute before enumerating the PCI
> +A user can configure one or more function attributes before enumerating the PCI

I'm not an expert on English grammar, but this sounds odd. I think it
is a generic reference, so the most suitable form would to use plural
"Users". Since we're touching this line anyway...

>  function. Usually it means, user should configure function attribute
>  before a bus specific device for the function is created. However, when
>  SRIOV is enabled, virtual function devices are created on the PCI bus.
> @@ -122,6 +122,9 @@ A user may set the hardware address of the function using
>  'devlink port function set hw_addr' command. For Ethernet port function
>  this means a MAC address.
>  
> +A user may set also the roce capability of the function using

... and adding another instance here. "also" before "set". roce -> RoCE.

> +'devlink port function set roce' command.
> +
>  Subfunction
>  ============

> +	/**
> +	 * @port_function_roce_get: Port function's roce get function.
> +	 *
> +	 * Should be used by device drivers to report the roce state of
> +	 * a function managed by the devlink port. Driver should return
> +	 * -EOPNOTSUPP if it doesn't support port function handling for
> +	 * a particular port.

Use imperative:

	* Query RoCE state of a function managed ...
	* Return -EOPNOTSUPP if port function handing is not supported.

> +	int (*port_function_roce_get)(struct devlink_port *port, bool *on,
> +				      struct netlink_ext_ack *extack);
> +	/**
> +	 * @port_function_roce_set: Port function's roce set function.
> +	 *
> +	 * Should be used by device drivers to enable/disable the roce state of
> +	 * a function managed by the devlink port. Driver should return
> +	 * -EOPNOTSUPP if it doesn't support port function handling for
> +	 * a particular port.
> +	 */
> +	int (*port_function_roce_set)(struct devlink_port *port, bool on,

> +	DEVLINK_PORT_FN_ATTR_ROCE,	/* u8 */

Please use u32, forget u8 and u16 exist, netlink rounds up the size of
attributes to 4B, anyway.

>  
>  	__DEVLINK_PORT_FUNCTION_ATTR_MAX,
>  	DEVLINK_PORT_FUNCTION_ATTR_MAX = __DEVLINK_PORT_FUNCTION_ATTR_MAX - 1

> +static int
> +devlink_port_fn_roce_set(struct devlink_port *port,
> +			 const struct nlattr *attr,
> +			 struct netlink_ext_ack *extack)
> +{
> +	const struct devlink_ops *ops = port->devlink->ops;
> +	bool on;
> +
> +	on = nla_get_u8(attr);
> +
> +	if (!ops->port_function_roce_set) {
> +		NL_SET_ERR_MSG_MOD(extack,

NL_SET_ERR_MSG_ATTR(), please

> +				   "Port doesn't support roce function attribute");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	return ops->port_function_roce_set(port, on, extack);
> +}
> +
>  static int
>  devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *port,
>  				   struct netlink_ext_ack *extack)
> @@ -1266,6 +1313,12 @@ devlink_nl_port_function_attrs_put(struct sk_buff *msg, struct devlink_port *por
>  					   &msg_updated);
>  	if (err)
>  		goto out;
> +
> +	err = devlink_port_function_roce_fill(ops, port, msg, extack,
> +					      &msg_updated);
> +	if (err)
> +		goto out;
> +
>  	err = devlink_port_fn_state_fill(ops, port, msg, extack, &msg_updated);
>  out:
>  	if (err || !msg_updated)
> @@ -1670,6 +1723,14 @@ static int devlink_port_function_set(struct devlink_port *port,
>  		if (err)
>  			return err;
>  	}
> +
> +	attr = tb[DEVLINK_PORT_FN_ATTR_ROCE];
> +	if (attr) {
> +		err = devlink_port_fn_roce_set(port, attr, extack);

We should try a little harder to avoid partial request processing.
Let's check if the device has the callbacks for all the settings in
the request upfront?

> +		if (err)
> +			return err;
> +	}
> +
>  	/* Keep this as the last function attribute set, so that when
>  	 * multiple port function attributes are set along with state,
>  	 * Those can be applied first before activating the state.

