Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E31AF27607D
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 20:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgIWSuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 14:50:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:41550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726460AbgIWSuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Sep 2020 14:50:08 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9478B206DB;
        Wed, 23 Sep 2020 18:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600887007;
        bh=+tvIza0qIz65xcsawMrOFO+H2aLSjb+k4ITXz5zPKio=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q4zQ/lt/9ubIEVMllyA5eyqLxHkEnjLCNPUWD7jWNWe7RRbalnK8/irOuldN7VIDZ
         72IC99K0IwzgA/349IJkLjlYBhKYGVvFanKOfiHw/G6OS9ZQHEFUon1jNb0Ym7ZoBD
         l26yoq1XLAiiZ0nvmP1vA410UiLituIsLkrNYd2I=
Date:   Wed, 23 Sep 2020 11:50:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next RFC v5 04/15] devlink: Add reload actions stats
 to dev get
Message-ID: <20200923115004.2392fae6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1600445211-31078-5-git-send-email-moshe@mellanox.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
        <1600445211-31078-5-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Sep 2020 19:06:40 +0300 Moshe Shemesh wrote:
> Expose devlink reload actions stats to the user through devlink dev
> get command.
> 
> Examples:
> $ devlink dev show
> pci/0000:82:00.0:
>   stats:
>       reload_action_stats:
>         driver_reinit 2
>         fw_activate 1
>         fw_activate_no_reset 0
>         remote_driver_reinit 0
>         remote_fw_activate 0
>         remote_fw_activate_no_reset 0
> pci/0000:82:00.1:
>   stats:
>       reload_action_stats:
>         driver_reinit 0
>         fw_activate 0
>         fw_activate_no_reset 0
>         remote_driver_reinit 1
>         remote_fw_activate 1
>         remote_fw_activate_no_reset 0
> 
> $ devlink dev show -jp
> {
>     "dev": {
>         "pci/0000:82:00.0": {
>             "stats": {
>                 "reload_action_stats": [ {
>                         "driver_reinit": 2
>                     },{
>                         "fw_activate": 1
>                     },{
>                         "fw_activate_no_reset": 0
>                     },{
>                         "remote_driver_reinit": 0
>                     },{
>                         "remote_fw_activate": 0
>                     },{
>                         "remote_fw_activate_no_reset": 0
>                     } ]
>             }
>         },
>         "pci/0000:82:00.1": {
>             "stats": {
>                 "reload_action_stats": [ {
>                         "driver_reinit": 0
>                     },{
>                         "fw_activate": 0
>                     },{
>                         "fw_activate_no_reset": 0
>                     },{
>                         "remote_driver_reinit": 1
>                     },{
>                         "remote_fw_activate": 1
>                     },{
>                         "remote_fw_activate_no_reset": 0
>                     } ]
>             }
>         }
>     }
> }
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> ---
> v4 -> v5:
> - Add remote actions stats
> - If devlink reload is not supported, show only remote_stats
> v3 -> v4:
> - Renamed DEVLINK_ATTR_RELOAD_ACTION_CNT to
>   DEVLINK_ATTR_RELOAD_ACTION_STAT
> - Add stats per action per limit level
> v2 -> v3:
> - Add reload actions counters instead of supported reload actions
>   (reload actions counters are only for supported action so no need for
>    both)
> v1 -> v2:
> - Removed DEVLINK_ATTR_RELOAD_DEFAULT_LEVEL
> - Removed DEVLINK_ATTR_RELOAD_LEVELS_INFO
> - Have actions instead of levels
> ---
>  include/uapi/linux/devlink.h |  5 +++
>  net/core/devlink.c           | 70 ++++++++++++++++++++++++++++++++++++
>  2 files changed, 75 insertions(+)
> 
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index 0c5d942dcbd5..648d53be691e 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -497,7 +497,12 @@ enum devlink_attr {
>  	DEVLINK_ATTR_RELOAD_ACTION,		/* u8 */
>  	DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,	/* nested */
>  	DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL,	/* u8 */
> +	DEVLINK_ATTR_RELOAD_ACTION_STATS,	/* nested */
> +	DEVLINK_ATTR_RELOAD_ACTION_STAT,	/* nested */
> +	DEVLINK_ATTR_RELOAD_ACTION_STAT_REMOTE,	/* flag */
> +	DEVLINK_ATTR_RELOAD_ACTION_STAT_VALUE,	/* u32 */
>  
> +	DEVLINK_ATTR_DEV_STATS,			/* nested */
>  	/* add new attributes above here, update the policy in devlink.c */

I'd propose this nesting:

	[DEV_STATS]
		[RELOAD_STATS]
			[DEV_STATS_ENTRY]
				[ACTION]
				[LIMIT]
				[VALUE]
			[DEV_STATS_ENTRY]
				[...]
		[REMOTE_RELOAD_STATS]
			[DEV_STATS_ENTRY]
				[ACTION]
				[LIMIT]
				[VALUE]
			[DEV_STATS_ENTRY]
				[...]

Then you can fill in the inside of the [REMOTE_]RELOAD_STATS nests with
a helper, and similarly user space can separate the two in JSON more
cleanly than string concat.

>  	__DEVLINK_ATTR_MAX,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index 1509c2ffb98b..71aeda259e6a 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -501,10 +501,39 @@ devlink_reload_action_limit_level_is_supported(struct devlink *devlink,
>  	return test_bit(limit_level, &devlink->ops->supported_reload_action_limit_levels);
>  }
>  
> +static int devlink_reload_action_stat_put(struct sk_buff *msg, enum devlink_reload_action action,
> +					  enum devlink_reload_action_limit_level limit_level,
> +					  bool is_remote, u32 value)
> +{
> +	struct nlattr *reload_action_stat;
> +
> +	reload_action_stat = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT);
> +	if (!reload_action_stat)
> +		return -EMSGSIZE;
> +
> +	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION, action))
> +		goto nla_put_failure;
> +	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL, limit_level))
> +		goto nla_put_failure;
> +	if (is_remote && nla_put_flag(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT_REMOTE))
> +		goto nla_put_failure;
> +	if (nla_put_u32(msg, DEVLINK_ATTR_RELOAD_ACTION_STAT_VALUE, value))
> +		goto nla_put_failure;
> +	nla_nest_end(msg, reload_action_stat);
> +	return 0;
> +
> +nla_put_failure:
> +	nla_nest_cancel(msg, reload_action_stat);
> +	return -EMSGSIZE;
> +}
> +
>  static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>  			   enum devlink_command cmd, u32 portid,
>  			   u32 seq, int flags)
>  {
> +	struct nlattr *dev_stats, *reload_action_stats;
> +	int i, j, stat_idx;
> +	u32 value;
>  	void *hdr;
>  
>  	hdr = genlmsg_put(msg, portid, seq, &devlink_nl_family, flags, cmd);
> @@ -516,9 +545,50 @@ static int devlink_nl_fill(struct sk_buff *msg, struct devlink *devlink,
>  	if (nla_put_u8(msg, DEVLINK_ATTR_RELOAD_FAILED, devlink->reload_failed))
>  		goto nla_put_failure;
>  
> +	dev_stats = nla_nest_start(msg, DEVLINK_ATTR_DEV_STATS);
> +	if (!dev_stats)
> +		goto nla_put_failure;
> +	reload_action_stats = nla_nest_start(msg, DEVLINK_ATTR_RELOAD_ACTION_STATS);
> +	if (!reload_action_stats)
> +		goto dev_stats_nest_cancel;
> +
> +	for (j = 0; j <= DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX; j++) {
> +		if (!devlink_reload_action_limit_level_is_supported(devlink, j))
> +			continue;
> +		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
> +			if (!devlink_reload_action_is_supported(devlink, i) ||
> +			    devlink_reload_combination_is_invalid(i, j))
> +				continue;
> +
> +			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
> +			value = devlink->reload_action_stats[stat_idx];
> +			if (devlink_reload_action_stat_put(msg, i, j, false, value))
> +				goto reload_action_stats_nest_cancel;
> +		}
> +	}
> +
> +	for (j = 0; j <= DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX; j++) {
> +		for (i = 0; i <= DEVLINK_RELOAD_ACTION_MAX; i++) {
> +			if (i == DEVLINK_RELOAD_ACTION_UNSPEC ||
> +			    devlink_reload_combination_is_invalid(i, j))
> +				continue;
> +
> +			stat_idx = j * __DEVLINK_RELOAD_ACTION_MAX + i;
> +			value = devlink->remote_reload_action_stats[stat_idx];
> +			if (devlink_reload_action_stat_put(msg, i, j, true, value))
> +				goto reload_action_stats_nest_cancel;
> +		}
> +	}

This calls for a helper.
