Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E47616E0F
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 20:55:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiKBTy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 15:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbiKBTyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 15:54:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E57B4B1;
        Wed,  2 Nov 2022 12:54:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E416761BC2;
        Wed,  2 Nov 2022 19:54:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05FCC433D6;
        Wed,  2 Nov 2022 19:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667418860;
        bh=27qzGMYGtNSKlLUnIthNAVdPl5pdVmwU9oEmpTQQiaM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J6VGthnYPkXbyAEpPL/Y/K/cOGH7h3RnU5GzbqnKLaa5c8Jcc9UDtwFyoQl6R6okl
         S+T0m3IZ/PE894fnMDvx0Y8wpH2rF+jkS6KIS7p9AdIvxrE7IzclJdhaiCzKddYaHZ
         /0wOoqqsP4IQCq9YiONTA3Tjozlb6k42Wn16GfWHf2dB8eenDyfdVTAGbXFJJNk2k9
         rr3QD32Q/h02ZCvHdeojOeZD8KWQ0y2tyf54rTBIaFROMtyVSHmcHJ7YjrScpyCefK
         GtivOHInc6V76P8OmIld8AgGGKkM7FZH+jpOHmzJ6b/dHlRKBM5HKFfUy01Z4yn6s3
         1aTnL6QU+6o/g==
Date:   Wed, 2 Nov 2022 12:54:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roman Gushchin <roman.gushchin@linux.dev>
Cc:     Andrew Lunn <andrew@lunn.ch>, Andy Ren <andy.ren@getcruise.com>,
        netdev@vger.kernel.org, richardbgobert@gmail.com,
        davem@davemloft.net, wsa+renesas@sang-engineering.com,
        edumazet@google.com, petrm@nvidia.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net-next v2] netconsole: Enable live renaming for
 network interfaces used by netconsole
Message-ID: <20221102125418.272c4381@kernel.org>
In-Reply-To: <Y2KlfhfijyNl8yxT@P9FQF9L96D.corp.robot.car>
References: <20221102002420.2613004-1-andy.ren@getcruise.com>
        <Y2G+SYXyZAB/r3X0@lunn.ch>
        <20221101204006.75b46660@kernel.org>
        <Y2KlfhfijyNl8yxT@P9FQF9L96D.corp.robot.car>
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

On Wed, 2 Nov 2022 10:14:38 -0700 Roman Gushchin wrote:
> > Agreed. BTW I wonder if we really want to introduce a netconsole
> > specific uAPI for this or go ahead with something more general.  
> 
> Netconsole is a bit special because it brings an interface up very early.
> E.g. in our case without the netconsole the renaming is happening before
> the interface is brought up.
> 
> I wonder if the netconsole-specific flag should allow renaming only once.
>  
> > A sysctl for global "allow UP rename"?  
> 
> This will work for us, but I've no idea what it will break for other users
> and how to check it without actually trying to break :) And likely we won't
> learn about it for quite some time, asssuming they don't run net-next.

Then again IFF_LIVE_RENAME_OK was added in 5.2 so quite a while back.

> > We added the live renaming for failover a while back and there were 
> > no reports of user space breaking as far as I know. So perhaps nobody
> > actually cares and we should allow renaming all interfaces while UP?
> > For backwards compat we can add a sysctl as mentioned or a rtnetlink 
> > "I know what I'm doing" flag? 
> > 
> > Maybe print an info message into the logs for a few releases to aid
> > debug?
> > 
> > IOW either there is a reason we don't allow rename while up, and
> > netconsole being bound to an interface is immaterial. Or there is 
> > no reason and we should allow all.  
> 
> My understanding is that it's not an issue for the kernel, but might be
> an issue for some userspace apps which do not expect it.

There are in-kernel notifier users which could cache the name on up /
down. But yes, the user space is the real worry.

> If you prefer to go with the 'global sysctl' approach, how the path forward
> should look like?

That's the question. The sysctl would really just be to cover our back
sides, and be able to tell the users "you opted in by setting that
sysctl, we didn't break backward compat". But practically speaking, 
its a different entity that'd be flipping the sysctl (e.g. management
daemon) and different entity that'd be suffering (e.g. routing daemon).
So the sysctl doesn't actually help anyone :/

So maybe we should just risk it and wonder about workarounds once
complains surface, if they do. Like generate fake down/up events.
Or create some form of "don't allow live renames now" lock-like
thing a process could take.

Adding a couple more CCs and if nobody screams at us I vote we just
remove the restriction instead of special casing.
