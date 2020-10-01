Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2867D280961
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgJAVZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:25:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:39362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbgJAVZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 17:25:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E9FF720796;
        Thu,  1 Oct 2020 21:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601587523;
        bh=z9qChKyiXBJIvvzoDEBPPNvdqvYMu7kAtRlPFN7R4Os=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P3fQwq+56xcDw775iu5eI8mg/BhV/jsGdOA8h97pglr2yH8y7NDwL1CMRIJuEkRtU
         6zMDakFz/x8bDqQA0SLVhLx+z1Do9Bp9P44N2y61Xh5vSz4CzQl085tsKXW5rX7lYp
         ZmibhOQ+kEPB7RTGFaemleLfS2Cu1Y90M9nlCuj8=
Date:   Thu, 1 Oct 2020 14:25:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 04/16] devlink: Add reload stats
Message-ID: <20201001142521.0c9ac25c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601560759-11030-5-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
        <1601560759-11030-5-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 16:59:07 +0300 Moshe Shemesh wrote:
> Add reload stats to hold the history per reload action type and limit.
> 
> For example, the number of times fw_activate has been performed on this
> device since the driver module was added or if the firmware activation
> was performed with or without reset.
> 
> Add devlink notification on stats update.
> 
> Expose devlink reload stats to the user through devlink dev get command.
> 
> Examples:
> $ devlink dev show
> pci/0000:82:00.0:
>   stats:
>       reload_stats:
>         driver_reinit 2
>         fw_activate 1
>         fw_activate_no_reset 0
> pci/0000:82:00.1:
>   stats:
>       reload_stats:
>         driver_reinit 1
>         fw_activate 0
>         fw_activate_no_reset 0
> 
> $ devlink dev show -jp
> {
>     "dev": {
>         "pci/0000:82:00.0": {
>             "stats": {
>                 "reload_stats": [ {
>                         "driver_reinit": 2
>                     },{
>                         "fw_activate": 1
>                     },{
>                         "fw_activate_no_reset": 0
>                     } ]
>             }
>         },
>         "pci/0000:82:00.1": {
>             "stats": {
>                 "reload_stats": [ {
>                         "driver_reinit": 1
>                     },{
>                         "fw_activate": 0
>                     },{
>                         "fw_activate_no_reset": 0
>                     } ]

This will be a question to the user space part but IDK why every stat
is in a separate object?

Instead of doing an array of objects -> [ {}, {}, {} ]
make "reload_stats" itself an object.

>             }
>         }
>     }
> }
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Minor nits, looks good overall:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 6de7d6aa6ed1..05516f1e4c3e 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -500,10 +500,68 @@ devlink_reload_limit_is_supported(struct devlink *devlink, enum devlink_reload_l
>  	return test_bit(limit, &devlink->ops->reload_limits);
>  }
>  
> +static int devlink_reload_stat_put(struct sk_buff *msg, enum devlink_reload_action action,
> +				   enum devlink_reload_limit limit, u32 value)
> +{
> +	struct nlattr *reload_stats_entry;
> +
> +	reload_stats_entry = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS_ENTRY);
> +	if (!reload_stats_entry)
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, action))
> +		goto nla_put_failure;
> +	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_LIMIT, limit))
> +		goto nla_put_failure;
> +	if (nla_put_u32(msg, DEVLINK_ATTR_RELOAD_STATS_VALUE, value))
> +		goto nla_put_failure;

nit: it's common to combine such expressions into:

if (nla_put...() ||
    nla_put...() ||
    nla_put...())
    goto ...;

> +	nla_nest_end(msg, reload_stats_entry);
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(msg, reload_stats_entry);
> +	return -EMSGSIZE;
> +}
> +
> +static int devlink_reload_stats_put(struct sk_buff *msg, struct devlink *devlink)
> +{
> +	struct nlattr *reload_stats_attr;
> +	int i, j, stat_idx;
> +	u32 value;
> +
> +	reload_stats_attr = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_STATS);
> +
> +	if (!reload_stats_attr)
> +		return -EMSGSIZE;
> +
> +	for (j = 0; j <= DEVLINK_RELOAD_LIMIT_MAX; j++) {
> +		if (j != DEVLINK_RELOAD_LIMIT_UNSPEC &&

Why check this? It can't be supported.

> +		    !devlink_reload_limit_is_supported(devlink, j))
> +			continue;
> +		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
> +			if (!devlink_reload_action_is_supported(devlink, i) ||
> +			    devlink_reload_combination_is_invalid(i, j))

Again, devlink instance would not have been registered with invalid
combinations, right?

> +				continue;
> +
> +			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
> +			value = devlink->reload_stats[stat_idx];
> +			if (devlink_reload_stat_put(msg, i, j, value))
> +				goto nla_put_failure;
> +		}
> +	}
> +	nla_nest_end(msg, reload_stats_attr);
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(msg, reload_stats_attr);
> +	return -EMSGSIZE;
> +}


> @@ -3004,6 +3072,34 @@ bool devlink_is_reload_failed(const struct devlink *devlink)
>  }
>  EXPORT_SYMBOL_GPL(devlink_is_reload_failed);
>  
> +static void
> +__devlink_reload_stats_update(struct devlink *devlink, u32 *reload_stats,
> +			      enum devlink_reload_limit limit, unsigned long actions_performed)

> +	for (action = 0; action <= DEVLINK_RELOAD_ACTION_MAX; action++) {

nit: for_each_set_bit

> +		if (!test_bit(action, &actions_performed))
> +			continue;
> +		stat_idx = limit * __DEVLINK_RELOAD_ACTION_MAX + action;
> +		reload_stats[stat_idx]++;
> +	}
> +	devlink_notify(devlink, DEVLINK_CMD_NEW);
> +}
