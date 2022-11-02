Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4952C616A53
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 18:15:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiKBRPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 13:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKBRO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 13:14:56 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DEB2186;
        Wed,  2 Nov 2022 10:14:55 -0700 (PDT)
Date:   Wed, 2 Nov 2022 10:14:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667409294;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xtTSxM1Q/qUYa04qDvMF9fQMU1lb3nJ4Yr7MTQ7VghU=;
        b=HGPpAdSi8jBVZcmLugyVIGYvvWkqF3VSKjIyZSapgYT5aDBIwno6PFiycmuKqNRsi6eCEU
        00g6vsaXFrHI8ZLMVDXPBYRRjci2zvrdgfTapXezF72FnhcQyMODDDKyeJs8AgdHDo+xZ1
        Ak9oegP1g8hgVuDq9qb8v6diwqyoY50=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, Andy Ren <andy.ren@getcruise.com>,
        netdev@vger.kernel.org, richardbgobert@gmail.com,
        davem@davemloft.net, wsa+renesas@sang-engineering.com,
        edumazet@google.com, petrm@nvidia.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] netconsole: Enable live renaming for network
 interfaces used by netconsole
Message-ID: <Y2KlfhfijyNl8yxT@P9FQF9L96D.corp.robot.car>
References: <20221102002420.2613004-1-andy.ren@getcruise.com>
 <Y2G+SYXyZAB/r3X0@lunn.ch>
 <20221101204006.75b46660@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101204006.75b46660@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 01, 2022 at 08:40:06PM -0700, Jakub Kicinski wrote:
> On Wed, 2 Nov 2022 01:48:09 +0100 Andrew Lunn wrote:
> > Changing the interface name while running is probably not an
> > issue. There are a few drivers which report the name to the firmware,
> > presumably for logging, and phoning home, but it should not otherwise
> > affect the hardware.
> 
> Agreed. BTW I wonder if we really want to introduce a netconsole
> specific uAPI for this or go ahead with something more general.

Netconsole is a bit special because it brings an interface up very early.
E.g. in our case without the netconsole the renaming is happening before
the interface is brought up.

I wonder if the netconsole-specific flag should allow renaming only once.

> A sysctl for global "allow UP rename"?

This will work for us, but I've no idea what it will break for other users
and how to check it without actually trying to break :) And likely we won't
learn about it for quite some time, asssuming they don't run net-next.

> 
> We added the live renaming for failover a while back and there were 
> no reports of user space breaking as far as I know. So perhaps nobody
> actually cares and we should allow renaming all interfaces while UP?
> For backwards compat we can add a sysctl as mentioned or a rtnetlink 
> "I know what I'm doing" flag? 
> 
> Maybe print an info message into the logs for a few releases to aid
> debug?
> 
> IOW either there is a reason we don't allow rename while up, and
> netconsole being bound to an interface is immaterial. Or there is 
> no reason and we should allow all.

My understanding is that it's not an issue for the kernel, but might be
an issue for some userspace apps which do not expect it.

If you prefer to go with the 'global sysctl' approach, how the path forward
should look like?

Thanks!
