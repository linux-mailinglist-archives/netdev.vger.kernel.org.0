Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8C527602D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgIWSmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:42:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:39278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbgIWSmj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 14:42:39 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2B13208B6;
        Wed, 23 Sep 2020 18:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600886558;
        bh=VRKfDZ8HoDv+Ifv5LB89WPUOboY3L7s7cFY18C8DKsg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hhCYZsNKLRRwXJgx6TUx7vdgaBS0ax7TXWpEqGSFD2V8hRO5PRq55xjZYiiOJOXl4
         3AjdBQ72NdG6lyBRKcBYudg5qjEptIG7rSYRgsc8q1Mumg97RaCNdoDkSgsi+Cv4Tp
         CWVh4poxfm9cABAMKgKNxkvparsI6k4lEGi9LFMo=
Date:   Wed, 23 Sep 2020 11:42:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v5 03/15] devlink: Add reload action stats
Message-ID: <20200923114235.6c54f726@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1600445211-31078-4-git-send-email-moshe@mellanox.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
        <1600445211-31078-4-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Sep 2020 19:06:39 +0300 Moshe Shemesh wrote:
> Add reload action stats to hold the history per reload action type and
> limit level.
> 
> For example, the number of times fw_activate has been performed on this
> device since the driver module was added or if the firmware activation
> was performed with or without reset.
> 
> The function devlink_remote_reload_actions_performed() is exported to
> enable also drivers update on reload actions performed, for example in
> case firmware activation with reset finished successfully but was
> initiated by remote host.
> 
> Add devlink notification on stats update.
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

I'd split this and the next patch by stat type (remote vs local).
Rather than split them by collect / report.

> diff --git a/include/net/devlink.h b/include/net/devlink.h
> index d8c62d605381..f09f55a47d09 100644
> --- a/include/net/devlink.h
> +++ b/include/net/devlink.h
> @@ -20,6 +20,9 @@
>  #include <uapi/linux/devlink.h>
>  #include <linux/xarray.h>
>  
> +#define DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE \
> +	(__DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX * __DEVLINK_RELOAD_ACTION_MAX)
> +
>  struct devlink_ops;
>  
>  struct devlink {
> @@ -38,6 +41,8 @@ struct devlink {
>  	struct list_head trap_policer_list;
>  	const struct devlink_ops *ops;
>  	struct xarray snapshot_ids;
> +	u32 reload_action_stats[DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE];
> +	u32 remote_reload_action_stats[DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE];
>  	struct device *dev;
>  	possible_net_t _net;
>  	struct mutex lock; /* Serializes access to devlink instance specific objects such as
> @@ -1400,6 +1405,9 @@ void
>  devlink_health_reporter_recovery_done(struct devlink_health_reporter *reporter);
>  
>  bool devlink_is_reload_failed(const struct devlink *devlink);
> +void devlink_remote_reload_actions_performed(struct devlink *devlink,
> +					     enum devlink_reload_action_limit_level limit_level,
> +					     unsigned long actions_performed);
>  
>  void devlink_flash_update_begin_notify(struct devlink *devlink);
>  void devlink_flash_update_end_notify(struct devlink *devlink);
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index fee6fcc7dead..1509c2ffb98b 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -3007,16 +3007,74 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>  }
>  EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>  
> +static void
> +__devlink_reload_action_stats_update(struct devlink *devlink,
> +				     u32 *reload_action_stats,
> +				     enum devlink_reload_action_limit_level limit_level,
> +				     unsigned long actions_performed)
> +{
> +	int stat_idx;
> +	int action;
> +
> +	if (!actions_performed)
> +		return;
> +
> +	if (WARN_ON(limit_level > DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX))
> +		return;
> +	for (action = 0; action <= DEVLINK_RELOAD_ACTION_MAX; action++) {
> +		if (!test_bit(action, &actions_performed))
> +			continue;
> +		stat_idx = limit_level * __DEVLINK_RELOAD_ACTION_MAX + action;
> +		reload_action_stats[stat_idx]++;
> +	}
> +	devlink_notify(devlink, DEVLINK_CMD_NEW);
> +}
> +
> +static void
> +devlink_reload_action_stats_update(struct devlink *devlink,
> +				   enum devlink_reload_action_limit_level limit_level,
> +				   unsigned long actions_performed)
> +{
> +	__devlink_reload_action_stats_update(devlink, devlink->reload_action_stats,
> +					     limit_level, actions_performed);
> +}
> +
> +/**
> + *	devlink_remote_reload_actions_performed - Update devlink on reload actions
> + *	  performed which are not a direct result of devlink reload call.
> + *
> + *	This should be called by a driver after performing reload actions in case it was not
> + *	a result of devlink reload call. For example fw_activate was performed as a result
> + *	of devlink reload triggered fw_activate on another host.
> + *	The motivation for this function is to keep data on reload actions performed on this
> + *	function whether it was done due to direct devlink reload call or not.
> + *
> + *	@devlink: devlink
> + *	@limit_level: reload action limit level
> + *	@actions_performed: bitmask of actions performed
> + */
> +void devlink_remote_reload_actions_performed(struct devlink *devlink,
> +					     enum devlink_reload_action_limit_level limit_level,
> +					     unsigned long actions_performed)
> +{
> +	__devlink_reload_action_stats_update(devlink, devlink->remote_reload_action_stats,
> +					     limit_level, actions_performed);
> +}
> +EXPORT_SYMBOL_GPL(devlink_remote_reload_actions_performed);
> +
>  static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>  			  enum devlink_reload_action action,
>  			  enum devlink_reload_action_limit_level limit_level,
>  			  struct netlink_ext_ack *extack, unsigned long *actions_performed)
>  {
> +	u32 remote_reload_action_stats[DEVLINK_RELOAD_ACTION_STATS_ARRAY_SIZE];
>  	int err;
>  
>  	if (!devlink->reload_enabled)
>  		return -EOPNOTSUPP;
>  
> +	memcpy(remote_reload_action_stats, devlink->remote_reload_action_stats,
> +	       sizeof(remote_reload_action_stats));
>  	err = devlink->ops->reload_down(devlink, !!dest_net, action, limit_level, extack);
>  	if (err)
>  		return err;
> @@ -3030,6 +3088,10 @@ static int devlink_reload(struct devlink *devlink, struct net *dest_net,
>  		return err;
>  
>  	WARN_ON(!test_bit(action, actions_performed));
> +	/* protect from driver updating the remote action within devlink reload */

s/protect from/catch/

> +	WARN_ON(memcmp(remote_reload_action_stats, devlink->remote_reload_action_stats,
> +		       sizeof(remote_reload_action_stats)));
> +	devlink_reload_action_stats_update(devlink, limit_level, *actions_performed);
>  	return 0;
>  }
>  

