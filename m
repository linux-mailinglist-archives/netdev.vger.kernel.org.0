Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1AC21934D0
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 01:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbgCZABi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 20:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:41130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727420AbgCZABi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Mar 2020 20:01:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A7C320714;
        Thu, 26 Mar 2020 00:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585180897;
        bh=SDBbM6q+cyydZkiDwz4+tD/2LjR+NoatBXAynbsfpGo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DQj99x34kTt0w1ZOBjipxqMV5iS2IIFKDsdzgbzc5ZjJfrk9BT2xRQnmIplsaarkK
         dJ/EX9kNviA0Qv5uQDETXaX3BJS81F+TnAj8CnYhX0lIGZ2aELux50qAsXMxDEqtUh
         xH8eFvEQ5LT83lIryMNigk81jQEcuaK/iKaRfdrw=
Date:   Wed, 25 Mar 2020 17:01:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eran Ben Elisha <eranbe@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH net-next 2/2] devlink: Add auto dump flag to health
 reporter
Message-ID: <20200325170135.28587e4a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f947cfe1-1ec3-7bb5-90dc-3bea61b71cf3@mellanox.com>
References: <1585142784-10517-1-git-send-email-eranbe@mellanox.com>
        <1585142784-10517-3-git-send-email-eranbe@mellanox.com>
        <20200325114529.3f4179c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200325190821.GE11304@nanopsycho.orion>
        <f947cfe1-1ec3-7bb5-90dc-3bea61b71cf3@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Mar 2020 21:38:35 +0200 Eran Ben Elisha wrote:
> On 3/25/2020 9:08 PM, Jiri Pirko wrote:
> > Wed, Mar 25, 2020 at 07:45:29PM CET, kuba@kernel.org wrote:  
> >> On Wed, 25 Mar 2020 15:26:24 +0200 Eran Ben Elisha wrote:  
> >>> On low memory system, run time dumps can consume too much memory. Add
> >>> administrator ability to disable auto dumps per reporter as part of the
> >>> error flow handle routine.
> >>>
> >>> This attribute is not relevant while executing
> >>> DEVLINK_CMD_HEALTH_REPORTER_DUMP_GET.
> >>>
> >>> By default, auto dump is activated for any reporter that has a dump method,
> >>> as part of the reporter registration to devlink.
> >>>
> >>> Signed-off-by: Eran Ben Elisha <eranbe@mellanox.com>
> >>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> >>> ---
> >>>   include/uapi/linux/devlink.h |  2 ++
> >>>   net/core/devlink.c           | 26 ++++++++++++++++++++++----
> >>>   2 files changed, 24 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/include/uapi/linux/devlink.h b/include/uapi/linux/devlink.h
> >>> index dfdffc42e87d..e7891d1d2ebd 100644
> >>> --- a/include/uapi/linux/devlink.h
> >>> +++ b/include/uapi/linux/devlink.h
> >>> @@ -429,6 +429,8 @@ enum devlink_attr {
> >>>   	DEVLINK_ATTR_NETNS_FD,			/* u32 */
> >>>   	DEVLINK_ATTR_NETNS_PID,			/* u32 */
> >>>   	DEVLINK_ATTR_NETNS_ID,			/* u32 */
> >>> +
> >>> +	DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,	/* u8 */
> >>>   	/* add new attributes above here, update the policy in devlink.c */
> >>>   
> >>>   	__DEVLINK_ATTR_MAX,
> >>> diff --git a/net/core/devlink.c b/net/core/devlink.c
> >>> index ad69379747ef..e14bf3052289 100644
> >>> --- a/net/core/devlink.c
> >>> +++ b/net/core/devlink.c
> >>> @@ -4837,6 +4837,7 @@ struct devlink_health_reporter {
> >>>   	struct mutex dump_lock; /* lock parallel read/write from dump buffers */
> >>>   	u64 graceful_period;
> >>>   	bool auto_recover;
> >>> +	bool auto_dump;
> >>>   	u8 health_state;
> >>>   	u64 dump_ts;
> >>>   	u64 dump_real_ts;
> >>> @@ -4903,6 +4904,7 @@ devlink_health_reporter_create(struct devlink *devlink,
> >>>   	reporter->devlink = devlink;
> >>>   	reporter->graceful_period = graceful_period;
> >>>   	reporter->auto_recover = !!ops->recover;
> >>> +	reporter->auto_dump = !!ops->dump;
> >>>   	mutex_init(&reporter->dump_lock);
> >>>   	refcount_set(&reporter->refcount, 1);
> >>>   	list_add_tail(&reporter->list, &devlink->reporter_list);
> >>> @@ -4983,6 +4985,10 @@ devlink_nl_health_reporter_fill(struct sk_buff *msg,
> >>>   	    nla_put_u64_64bit(msg, DEVLINK_ATTR_HEALTH_REPORTER_DUMP_TS_NS,
> >>>   			      reporter->dump_real_ts, DEVLINK_ATTR_PAD))
> >>>   		goto reporter_nest_cancel;
> >>> +	if (reporter->ops->dump &&
> >>> +	    nla_put_u8(msg, DEVLINK_ATTR_HEALTH_REPORTER_AUTO_DUMP,
> >>> +		       reporter->auto_dump))
> >>> +		goto reporter_nest_cancel;  
> >>
> >> Since you're making it a u8 - does it make sense to indicate to user  
> > 
> > Please don't be mistaken. u8 carries a bool here.

Are you okay with limiting the value in the policy?

I guess the auto-recover doesn't have it so we'd create a little
inconsistency.

> >> space whether the dump is disabled or not supported?  
> > 
> > If you want to expose "not supported", I suggest to do it in another
> > attr. Because this attr is here to do the config from userspace. Would
> > be off if the same enum would carry "not supported".
> > 
> > But anyway, since you opened this can, the supported/capabilities
> > should be probably passed by a separate bitfield for all features.
> >   
> 
> Actually we supports trinary state per x attribute.
> (x can be auto-dump or auto-recover which is supported since day 1)
> 
> devlink_nl_health_reporter_fill can set
> DEVLINK_ATTR_HEALTH_REPORTER_AUTO_X to {0 , 1 , no set}
> And user space devlink propagates it accordingly.
> 
> If auto_x is supported, user will see "auto_x true"
> If auto_x is not supported, user will see "auto_x false"
> If x is not supported at all, user will not the auto_x at all for this 
> reporter.

Yeah, makes perfect the only glitch is that for auto-dump we have the
old kernel case. auto-recover was there from day 1.

> >> Right now no attribute means either old kernel or dump not possible.  
> when you run on old kernel, you will not see auto-dump attribute at all. 
> In any case you won't be able to distinguish in user space between 
> {auto-dump, no-auto-dump, no dump support}.

Right.

Anyway, I don't think this will matter in this particular case in
practice, so if you're okay with the code as is:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
