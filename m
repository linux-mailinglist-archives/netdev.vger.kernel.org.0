Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE97277AAA
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgIXUpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXUpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 16:45:41 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9AEEF239EC;
        Thu, 24 Sep 2020 20:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600980340;
        bh=TTUD3mp29SDOqlb14S/9NEvYQH7a/ui/4mXy2anRnfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=za27fgq9EL2F81s27VN+E67BZEFM0jmf/fsli8SQVGUeTOckC5//fHZMVwc4gpUXo
         YPfOsvmFkOrD20QhJ2SI2pr4I6omX6zfF+E7dQrIW6dS2K8ioWiGEY8CBj9clRBwuR
         cWl9iW86tNLr/oaweHWYXfCakERLi0FG6jVWKz7A=
Date:   Thu, 24 Sep 2020 13:45:38 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next RFC v5 02/15] devlink: Add reload action limit
 level
Message-ID: <20200924134538.1b13f6db@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <13ff51f8-10d8-df3a-048e-cfd8563dc2de@nvidia.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
        <1600445211-31078-3-git-send-email-moshe@mellanox.com>
        <20200923113648.7398276d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <13ff51f8-10d8-df3a-048e-cfd8563dc2de@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020 22:29:55 +0300 Moshe Shemesh wrote:
> >> @@ -3964,6 +3965,7 @@ static int mlx4_devlink_reload_down(struct devlink *devlink, bool netns_change,
> >>   }
> >>
> >>   static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> >> +                               enum devlink_reload_action_limit_level limit_level,
> >>                                  struct netlink_ext_ack *extack, unsigned long *actions_performed)
> >>   {
> >>        struct mlx4_priv *priv = devlink_priv(devlink);
> >> @@ -3985,6 +3987,7 @@ static int mlx4_devlink_reload_up(struct devlink *devlink, enum devlink_reload_a
> >>   static const struct devlink_ops mlx4_devlink_ops = {
> >>        .port_type_set  = mlx4_devlink_port_type_set,
> >>        .supported_reload_actions = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT),
> >> +     .supported_reload_action_limit_levels = BIT(DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE),  
> > Please cut down the name lenghts, this is just lazy.
> >
> > 'supported_reload_limits' or 'cap_reload_limits' is perfectly
> > sufficient.
> >
> > 'reload_limits' would be even better. Cause what else would it be if
> > not a capability.  
> 
> Sounds good.
> 
> So instead of supported_reload_actions_limit_levels will have reload_limits.
> 
> Instead of supported_reload_actions will have reload_actions, OK ?

Sounds good.

> May also use reload_limit_level instead of reload_action_limit_level 
> everywhere if its clear enough.

I think reload_limits is clear. I'd also cut down the length of the
defines / enum names.

> > Besides I don't think drivers should have to fill negative attributes
> > (that they don't support something). Everyone is always going to
> > support NONE, since it's "unspecified" / "pick your favorite", right?  
> 
> Good point, will remove it.
> 
> >>        .reload_down    = mlx4_devlink_reload_down,
> >>        .reload_up      = mlx4_devlink_reload_up,
> >>   };
> >> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> >> index fdba7ab58a79..0c5d942dcbd5 100644
> >> --- a/include/uapi/linux/devlink.h
> >> +++ b/include/uapi/linux/devlink.h
> >> @@ -289,6 +289,22 @@ enum devlink_reload_action {
> >>        DEVLINK_RELOAD_ACTION_MAX = __DEVLINK_RELOAD_ACTION_MAX - 1
> >>   };
> >>
> >> +/**
> >> + * enum devlink_reload_action_limit_level - Reload action limit level.
> >> + * @DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE: No constrains on action. Action may include
> >> + *                                          reset or downtime as needed.
> >> + * @DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET: No reset allowed, no down time allowed,
> >> + *                                              no link flap and no configuration is lost.
> >> + */
> >> +enum devlink_reload_action_limit_level {  
> > You reserved UNSPEC for actions but not for limit level?  
> 
> 
> Yes, I used LIMIT_LEVEL_NONE = 0 as no limit needed, so I skipped UNSPEC.
> 
> Maybe should add UNSPEC and use UNSPEC as no limit needed. But UNSPEC is 
> kind of invalid.

Yeah, if we have UNSPEC then it should be invalid.

I'm mostly asking for consistency, either have UNSPEC for both actions
and limits or for neither.

> >> +     DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NONE,
> >> +     DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET,
> >> +
> >> +     /* Add new reload actions limit level above */
> >> +     __DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX,
> >> +     DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX = __DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_MAX - 1
> >> +};
> >> +
> >>   enum devlink_attr {
> >>        /* don't change the order or add anything between, this is ABI! */
> >>        DEVLINK_ATTR_UNSPEC,
> >> @@ -480,6 +496,7 @@ enum devlink_attr {
> >>
> >>        DEVLINK_ATTR_RELOAD_ACTION,             /* u8 */
> >>        DEVLINK_ATTR_RELOAD_ACTIONS_PERFORMED,  /* nested */
> >> +     DEVLINK_ATTR_RELOAD_ACTION_LIMIT_LEVEL, /* u8 */
> >>
> >>        /* add new attributes above here, update the policy in devlink.c */
> >>
> >> diff --git a/net/core/devlink.c b/net/core/devlink.c
> >> index 318ef29f81f2..fee6fcc7dead 100644
> >> --- a/net/core/devlink.c
> >> +++ b/net/core/devlink.c
> >> @@ -462,12 +462,45 @@ static int devlink_nl_put_handle(struct sk_buff *msg, struct devlink *devlink)
> >>        return 0;
> >>   }
> >>
> >> +struct devlink_reload_combination {
> >> +     enum devlink_reload_action action;
> >> +     enum devlink_reload_action_limit_level limit_level;
> >> +};
> >> +
> >> +static const struct devlink_reload_combination devlink_reload_invalid_combinations[] = {
> >> +     {
> >> +             /* can't reinitialize driver with no down time */
> >> +             .action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT,
> >> +             .limit_level = DEVLINK_RELOAD_ACTION_LIMIT_LEVEL_NO_RESET,
> >> +     },
> >> +};
> >> +
> >> +static bool
> >> +devlink_reload_combination_is_invalid(enum devlink_reload_action action,
> >> +                                   enum devlink_reload_action_limit_level limit_level)
> >> +{
> >> +     int i;
> >> +
> >> +     for (i = 0 ; i <  ARRAY_SIZE(devlink_reload_invalid_combinations) ; i++)  
> > Whitespace. Did you checkpatch?  
> 
> 
> Yes, checked it again now, it still pass. I think checkpatch doesn't see 
> double space.

And the spaces before semicolons? It's sad if checkpatch misses such
basic stuff :(

> But anyway, I missed it, I will fix.
