Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A334617337
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 01:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbiKCAI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 20:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiKCAI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 20:08:56 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AFF6331;
        Wed,  2 Nov 2022 17:08:54 -0700 (PDT)
Date:   Wed, 2 Nov 2022 17:08:32 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667434133;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aIozy4Ujz7Z2c69qFsPkkFtnJ9hdh3LiSwrKTFpiRvQ=;
        b=DgLbHAsLaCguIy0yqRz54f/htsOrLHkRG82+AISqC+6I57/JxLvtZbdjW7cPqrcIz2xFdg
        mXZIOLVyssiat6QSG4GmU0LCDVrkLvI355jgG4u7AXfUlYLMCmMyHxb6r1h3TUclGnNF/U
        8lDLXWV9HQtNr1twgZNpwLH1nAYYQwk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Andy Ren <andy.ren@getcruise.com>,
        netdev@vger.kernel.org, richardbgobert@gmail.com,
        davem@davemloft.net, wsa+renesas@sang-engineering.com,
        edumazet@google.com, petrm@nvidia.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net-next v2] netconsole: Enable live renaming for network
 interfaces used by netconsole
Message-ID: <Y2MGgPLFiZQYDEzE@P9FQF9L96D.corp.robot.car>
References: <20221102002420.2613004-1-andy.ren@getcruise.com>
 <Y2G+SYXyZAB/r3X0@lunn.ch>
 <20221101204006.75b46660@kernel.org>
 <Y2KlfhfijyNl8yxT@P9FQF9L96D.corp.robot.car>
 <20221102125418.272c4381@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102125418.272c4381@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 02, 2022 at 12:54:18PM -0700, Jakub Kicinski wrote:
> On Wed, 2 Nov 2022 10:14:38 -0700 Roman Gushchin wrote:
> > > Agreed. BTW I wonder if we really want to introduce a netconsole
> > > specific uAPI for this or go ahead with something more general.  
> > 
> > Netconsole is a bit special because it brings an interface up very early.
> > E.g. in our case without the netconsole the renaming is happening before
> > the interface is brought up.
> > 
> > I wonder if the netconsole-specific flag should allow renaming only once.
> >  
> > > A sysctl for global "allow UP rename"?  
> > 
> > This will work for us, but I've no idea what it will break for other users
> > and how to check it without actually trying to break :) And likely we won't
> > learn about it for quite some time, asssuming they don't run net-next.
> 
> Then again IFF_LIVE_RENAME_OK was added in 5.2 so quite a while back.
> 
> > > We added the live renaming for failover a while back and there were 
> > > no reports of user space breaking as far as I know. So perhaps nobody
> > > actually cares and we should allow renaming all interfaces while UP?
> > > For backwards compat we can add a sysctl as mentioned or a rtnetlink 
> > > "I know what I'm doing" flag? 
> > > 
> > > Maybe print an info message into the logs for a few releases to aid
> > > debug?
> > > 
> > > IOW either there is a reason we don't allow rename while up, and
> > > netconsole being bound to an interface is immaterial. Or there is 
> > > no reason and we should allow all.  
> > 
> > My understanding is that it's not an issue for the kernel, but might be
> > an issue for some userspace apps which do not expect it.
> 
> There are in-kernel notifier users which could cache the name on up /
> down. But yes, the user space is the real worry.
> 
> > If you prefer to go with the 'global sysctl' approach, how the path forward
> > should look like?
> 
> That's the question. The sysctl would really just be to cover our back
> sides, and be able to tell the users "you opted in by setting that
> sysctl, we didn't break backward compat". But practically speaking, 
> its a different entity that'd be flipping the sysctl (e.g. management
> daemon) and different entity that'd be suffering (e.g. routing daemon).
> So the sysctl doesn't actually help anyone :/

Yeah, I agree, adding another sysctl for this looks like an overkill.

> 
> So maybe we should just risk it and wonder about workarounds once
> complains surface, if they do. Like generate fake down/up events.
> Or create some form of "don't allow live renames now" lock-like
> thing a process could take.
> 
> Adding a couple more CCs and if nobody screams at us I vote we just
> remove the restriction instead of special casing.

Great, thanks!

Let's do this and if there will be serious concernes raised, let's
fallback to the netconsole-specific thing (maybe with the "allow
single renaming" semantics).

Thanks,
Roman
