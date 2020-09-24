Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25193277A85
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgIXUi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:38:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:40912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgIXUi1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 16:38:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96AEA21D7F;
        Thu, 24 Sep 2020 20:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600979906;
        bh=i5iUU92lMRTTto/ol9MCYB2GbieyfMfeaDb9LBG6iGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2IyXtoPeBUkfVwfxxRaC0UFQk15jy3HlTqX8BN81fCJM9zv+vWThN0OJ08UNZ14BM
         SyGOdPmvnXet7nEAtkQWKUr6wk6ua/POw7PzHtqLdGnwpOwtELX4Tzxe4AuhMFEgJZ
         oAyXGlah5CYMhKRAp5ExRQ0RMwaHz5CvRf76gh1I=
Date:   Thu, 24 Sep 2020 13:38:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next RFC v5 01/15] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200924133824.206b6308@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9bdd7d82-aed2-aa0a-f167-eaae237d658c@nvidia.com>
References: <1600445211-31078-1-git-send-email-moshe@mellanox.com>
        <1600445211-31078-2-git-send-email-moshe@mellanox.com>
        <20200923112543.4dc12600@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9bdd7d82-aed2-aa0a-f167-eaae237d658c@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020 22:01:42 +0300 Moshe Shemesh wrote:
> On 9/23/2020 9:25 PM, Jakub Kicinski wrote:
> >> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>
> >> @@ -3971,15 +3972,19 @@ static int mlx4_devlink_reload_up(struct devlink *devlink,
> >>        int err;
> >>
> >>        err = mlx4_restart_one_up(persist->pdev, true, devlink);
> >> -     if (err)
> >> +     if (err) {
> >>                mlx4_err(persist->dev, "mlx4_restart_one_up failed, ret=%d\n",
> >>                         err);
> >> +             return err;
> >> +     }
> >> +     *actions_performed = BIT(DEVLINK_RELOAD_ACTION_DRIVER_REINIT);  
> > FWIW I think drivers should be able to assign this even if they return
> > an error. On error there is no certainty what actions were actually
> > performed (e.g. when timeout happened but the device did the reset a
> > little later) so this argument should not be interpreted in presence of
> > errors, anyway.  
> 
> Not sure I got it. Do you mean driver can assign it anyway and devlink 
> should ignore in case of failure ?

Yup.

> As I implemented here devlink already ignores actions_performed in case 
> driver returns with error.

Right, but you're changing all bunch of drivers like this:

 static void reload()
 {		
-	return do_it();
+	int err;
+
+	err = do_it();
+	if (err)
+		return err;
+
+	*actions_performed = SOMETHING;
+	return 0;
 }

When you can instead:

 static void reload()
 {		
+	*actions_performed = SOMETHING;
 	return do_it();
 }

> >> @@ -3011,12 +3064,43 @@ static int devlink_nl_cmd_reload(struct sk_buff *skb, struct genl_info *info)
> >>                        return PTR_ERR(dest_net);
> >>        }
> >>
> >> -     err = devlink_reload(devlink, dest_net, info->extack);
> >> +     if (info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
> >> +             action = nla_get_u8(info->attrs[DEVLINK_ATTR_RELOAD_ACTION]);
> >> +     else
> >> +             action = DEVLINK_RELOAD_ACTION_DRIVER_REINIT;
> >> +
> >> +     if (action == DEVLINK_RELOAD_ACTION_UNSPEC) {
> >> +             NL_SET_ERR_MSG_MOD(info->extack, "Invalid reload action");
> >> +             return -EINVAL;
> >> +     } else if (!devlink_reload_action_is_supported(devlink, action)) {
> >> +             NL_SET_ERR_MSG_MOD(info->extack, "Requested reload action is not supported by the driver");
> >> +             return -EOPNOTSUPP;
> >> +     }
> >> +
> >> +     err = devlink_reload(devlink, dest_net, action, info->extack, &actions_performed);  
> > Perhaps we can pass the requested action to the driver via
> > actions_performed already, and then all the drivers which
> > only do what they're asked to don't have to touch it?  
> 
> Not sure about it. Note that in the next patch I add here limit_level 
> and that has only input param, so I think it would be confusing.

I don't think it'd be, but don't feel strongly either.

> >>        if (dest_net)
> >>                put_net(dest_net);
> >>
> >> -     return err;
> >> +     if (err)
> >> +             return err;
> >> +     /* For backward compatibility generate reply only if attributes used by user */
> >> +     if (!info->attrs[DEVLINK_ATTR_RELOAD_ACTION])
> >> +             return 0;
> >> +
> >> +     msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> >> +     if (!msg)
> >> +             return -ENOMEM;
> >> +
> >> +     err = devlink_nl_reload_actions_performed_fill(msg, devlink, actions_performed,
> >> +                                                    DEVLINK_CMD_RELOAD, info->snd_portid,
> >> +                                                    info->snd_seq, 0);
> >> +     if (err) {
> >> +             nlmsg_free(msg);
> >> +             return err;
> >> +     }
> >> +
> >> +     return genlmsg_reply(msg, info);  
> > Are you using devlink_nl_reload_actions_performed_fill() somewhere else?  
> No
> > I'd move the nlmsg_new() / genlmsg_reply() into the helper.  
> 
> Can do it, but there are many _fill() functions in devlink.c code to 
> fill the data, none of them include nlmsg_new() and genlmsg_reply() 
> that's always in the calling function, even if the calling function adds 
> only that. So I guess I will leave it for consistency.

Don't call the helper _fill() and you'll be good.

> >>   }
> >>
> >>   static int devlink_nl_flash_update_fill(struct sk_buff *msg,
> >> @@ -7069,6 +7153,7 @@ static const struct nla_policy devlink_nl_policy[DEVLINK_ATTR_MAX + 1] = {
> >>        [DEVLINK_ATTR_TRAP_POLICER_RATE] = { .type = NLA_U64 },
> >>        [DEVLINK_ATTR_TRAP_POLICER_BURST] = { .type = NLA_U64 },
> >>        [DEVLINK_ATTR_PORT_FUNCTION] = { .type = NLA_NESTED },
> >> +     [DEVLINK_ATTR_RELOAD_ACTION] = { .type = NLA_U8 },  
> > Why not just range validation here?  
> 
> All devlink attributes that pass here go through devlink_nl_poicy this 
> way, including other enums.
> 
> I think changing that should be in a different patch for all, not in 
> this patchset.

I don't think this is on purpose. Please use range validation in new
code from the start. We support dumping policies to user space, it's
useful to know the range of parameters from the policy.
