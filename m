Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E16C0191FDA
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 04:53:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgCYDxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 23:53:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727259AbgCYDxR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Mar 2020 23:53:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D69A4206F6;
        Wed, 25 Mar 2020 03:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585108396;
        bh=/PZ/bVE3uXLFk3wA1HdINHNI/inLh4WBlEaZZc88OQY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=v7UrlGVq43VFVWx6zHum3i4nRQHTUgctDuFdXAtCQ64qv4/y89d3OrzUCmg5KUH1w
         ww+6rl4Li5Ee/YDbgc1bsoP+oUMpcHT2L9AdUg6PnmtnySKF895sbjvhi5a4yfQnR+
         J7BBNYJxPlqIYG23iugZgLxJSeopCxIENLx3AyCg=
Date:   Tue, 24 Mar 2020 20:53:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 05/15] devlink: Allow setting of packet trap
 group parameters
Message-ID: <20200324205314.2d2ba2fd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200324193250.1322038-6-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
        <20200324193250.1322038-6-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Mar 2020 21:32:40 +0200 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> The previous patch allowed device drivers to publish their default
> binding between packet trap policers and packet trap groups. However,
> some users might not be content with this binding and would like to
> change it.
> 
> In case user space passed a packet trap policer identifier when setting
> a packet trap group, invoke the appropriate device driver callback and
> pass the new policer identifier.
> 
> Signed-off-by: Ido Schimmel <idosch@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/net/devlink.h |  9 +++++++++
>  net/core/devlink.c    | 43 +++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 52 insertions(+)
> 
> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index 84c28e0f2d90..dea3c3fd9634 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -847,6 +847,15 @@ struct devlink_ops {
>  	 */
>  	int (*trap_group_init)(struct devlink *devlink,
>  			       const struct devlink_trap_group *group);
> +	/**
> +	 * @trap_group_set: Trap group parameters set function.
> +	 *
> +	 * Note: @policer can be NULL when a policer is being unbound from
> +	 * @group.
> +	 */
> +	int (*trap_group_set)(struct devlink *devlink,
> +			      const struct devlink_trap_group *group,
> +			      const struct devlink_trap_policer *policer);
>  	/**
>  	 * @trap_policer_init: Trap policer initialization function.
>  	 *
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 4ec7c7578709..e3042e131c1f 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -6039,6 +6039,45 @@ devlink_trap_group_action_set(struct devlink *devlink,
>  	return 0;
>  }
>  
> +static int devlink_trap_group_set(struct devlink *devlink,
> +				  struct devlink_trap_group_item *group_item,
> +				  struct genl_info *info)
> +{
> +	struct devlink_trap_policer_item *policer_item;
> +	struct netlink_ext_ack *extack = info->extack;
> +	const struct devlink_trap_policer *policer;
> +	struct nlattr **attrs = info->attrs;
> +	int err;
> +

Why not:

	if (!attrs[DEVLINK_ATTR_TRAP_POLICER_ID])
		return 0?

> +	if (!devlink->ops->trap_group_set) {
> +		if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID])
> +			return -EOPNOTSUPP;
> +		return 0;
> +	}
> +
> +	policer_item = group_item->policer_item;
> +	if (attrs[DEVLINK_ATTR_TRAP_POLICER_ID]) {
> +		u32 policer_id;
> +
> +		policer_id = nla_get_u32(attrs[DEVLINK_ATTR_TRAP_POLICER_ID]);
> +		policer_item = devlink_trap_policer_item_lookup(devlink,
> +								policer_id);
> +		if (policer_id && !policer_item) {
> +			NL_SET_ERR_MSG_MOD(extack, "Device did not register this trap policer");

nit: is KBUILD_MODNAME still set if devlink can only be built-in now?

> +			return -ENOENT;
> +		}
> +	}
> +	policer = policer_item ? policer_item->policer : NULL;
> +
> +	err = devlink->ops->trap_group_set(devlink, group_item->group, policer);
> +	if (err)
> +		return err;
> +
> +	group_item->policer_item = policer_item;
> +
> +	return 0;
> +}
> +
>  static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
>  					      struct genl_info *info)
>  {
> @@ -6060,6 +6099,10 @@ static int devlink_nl_cmd_trap_group_set_doit(struct sk_buff *skb,
>  	if (err)
>  		return err;
>  
> +	err = devlink_trap_group_set(devlink, group_item, info);
> +	if (err)
> +		return err;

Should this unwind the action changes? Are the changes supposed to be
atomic? :S 

Also could it potentially be a problem if trap is being enabled and
policer applied - if we enable first the CPU may get overloaded and it
may be hard to apply the policer? Making sure the ordering is right
requires some careful checking, so IDK if its worth it..

>  	return 0;
>  }
>  

