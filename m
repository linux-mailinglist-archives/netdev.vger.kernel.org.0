Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FF06193095
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 19:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727469AbgCYSpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 14:45:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727027AbgCYSpc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 14:45:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F42B2074D;
        Wed, 25 Mar 2020 18:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585161931;
        bh=jvikHo9pUH9Rll6SzlHNTOYD2szmtyLRw8t6mrR8p5g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uVDt1d8hT/uhic48qJd0p2ZsfgInuYeTNvKk9rGrPvC00JqshvKj0WYyJqzLdaoyx
         lPq0ScnC0eLkWFoZj/MmnFQ3119tKTUnM0FJbBzWf8251MoVg+Ia06q7ZED6HBTEso
         bAspWGpDMZ63br+TrQE9hxYAh7YNY/cmGPoU/9nI=
Date:   Wed, 25 Mar 2020 11:45:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@mellanox.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 2/2] devlink: Add auto dump flag to health
 reporter
Message-ID: <20200325114529.3f4179c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1585142784-10517-3-git-send-email-eranbe@mellanox.com>
References: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
        <1585142784-10517-3-git-send-email-eranbe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 15:26:24 +0200 Eran Ben Elisha wrote:
> On low memory system, run time dumps can consume too much memory. Add
> administrator ability to disable auto dumps per reporter as part of the
> error flow handle routine.
> 
> This attribute is not relevant while executing
> DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET.
> 
> By default, auto dump is activated for any reporter that has a dump method,
> as part of the reporter registration to devlink.
> 
> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  include/uapi/linux/devlink.h |  2 ++
>  net/core/devlink.c           | 26 ++++++++++++++++++++++----
>  2 files changed, 24 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> index dfdffc42e87d..e7891d1d2ebd 100644
> --- a/include/uapi/linux/devlink.h
> +++ b/include/uapi/linux/devlink.h
> @@ -429,6 +429,8 @@ enum devlink_attr {
>  	DEVLINK_ATTR_NETNS_FD,			/* u32 */
>  	DEVLINK_ATTR_NETNS_PID,			/* u32 */
>  	DEVLINK_ATTR_NETNS_ID,			/* u32 */
> +
> +	DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,	/* u8 */
>  	/* add new attributes above here, update the policy in devlink.c */
>  
>  	__DEVLINK_ATTR_MAX,
> diff --git a/net/core/devlink.c b/net/core/devlink.c
> index ad69379747ef..e14bf3052289 100644
> --- a/net/core/devlink.c
> +++ b/net/core/devlink.c
> @@ -4837,6 +4837,7 @@ struct devlink_health_reporter {
>  	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
>  	u64 graceful_period;
>  	bool auto_recover;
> +	bool auto_dump;
>  	u8 health_state;
>  	u64 dump_ts;
>  	u64 dump_real_ts;
> @@ -4903,6 +4904,7 @@ devlink_health_reporter_create(struct devlink *devlink,
>  	reporter->devlink = devlink;
>  	reporter->graceful_period = graceful_period;
>  	reporter->auto_recover = !!ops->recover;
> +	reporter->auto_dump = !!ops->dump;
>  	mutex_init(&reporter->dump_lock);
>  	refcount_set(&reporter->refcount, 1);
>  	list_add_tail(&reporter->list, &devlink->reporter_list);
> @@ -4983,6 +4985,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
>  	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
>  			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
>  		goto reporter_nest_cancel;
> +	if (reporter->ops->dump &&
> +	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
> +		       reporter->auto_dump))
> +		goto reporter_nest_cancel;

Since you're making it a u8 - does it make sense to indicate to user
space whether the dump is disabled or not supported?

Right now no attribute means either old kernel or dump not possible..

>  	nla_nest_end(msg, reporter_attr);
>  	genlmsg_end(msg, hdr);
> @@ -5129,10 +5135,12 @@ int devlink_health_report(struct devlink_health_reporter *reporter,
>  
>  	reporter->health_state = DEVLINK_HEALTH_REPORTER_STATE_ERROR;
>  
> -	mutex_lock(&reporter->dump_lock);
> -	/* store current dump of current error, for later analysis */
> -	devlink_health_do_dump(reporter, priv_ctx, NULL);
> -	mutex_unlock(&reporter->dump_lock);
> +	if (reporter->auto_dump) {
> +		mutex_lock(&reporter->dump_lock);
> +		/* store current dump of current error, for later analysis */
> +		devlink_health_do_dump(reporter, priv_ctx, NULL);
> +		mutex_unlock(&reporter->dump_lock);
> +	}
>  
>  	if (reporter->auto_recover)
>  		return devlink_health_reporter_recover(reporter,
> @@ -5306,6 +5314,11 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
>  		err = -EOPNOTSUPP;
>  		goto out;
>  	}
> +	if (!reporter->ops->dump &&
> +	    info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]) {

... and then this behavior may have to change, I think?

> +		err = -EOPNOTSUPP;
> +		goto out;
> +	}
>  
>  	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD])
>  		reporter->graceful_period =
> @@ -5315,6 +5328,10 @@ devlink_nl_cmd_health_reporter_set_doit(struct sk_buff *skb,
>  		reporter->auto_recover =
>  			nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER]);
>  
> +	if (info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP])
> +		reporter->auto_dump =
> +		nla_get_u8(info->attrs[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP]);
> +
>  	devlink_health_reporter_put(reporter);
>  	return 0;
>  out:
> @@ -6053,6 +6070,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
>  	[DEVLINK_ATTR_HEALTH_REPORTER_NAME] = { .type = NLA_NUL_STRING },
>  	[DEVLINK_ATTR_HEALTH_REPORTER_GRACEFUL_PERIOD] = { .type = NLA_U64 },
>  	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_RECOVER] = { .type = NLA_U8 },
> +	[DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP] = { .type = NLA_U8 },

I'd suggest we keep the attrs in order of definition, because we should
set .strict_start_type, and then it matters which are before and which
are after.

Also please set max value of 1.

>  	[DEVLINK_ATTR_FLASH_UPDATE_FILE_NAME] = { .type = NLA_NUL_STRING },
>  	[DEVLINK_ATTR_FLASH_UPDATE_COMPONENT] = { .type = NLA_NUL_STRING },
>  	[DEVLINK_ATTR_TRAP_NAME] = { .type = NLA_NUL_STRING },

