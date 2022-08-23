Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 013DD59E968
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiHWR0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233730AbiHWRZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:25:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41728A6E9
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:00:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAEFD615D7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 15:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD33CC433D6;
        Tue, 23 Aug 2022 15:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661266825;
        bh=UUHiE9LZC2RTIOCVRVF7XZp1DDcH0s01VQ1Gm7vcmt0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XqdLuYhh/AyHj69sjgRij6J/7XbGubOeNi1G95iCmEtq9nPu7T5F8Ol6zCFKgokun
         2F1i5i6XyIIY78AfWbdRrjetfzCWGwVtuFkvGM2l9W/loQDVXGabimP0rOOg34wsg5
         2IwKCYOf5gQEllcwXJCwMe1QUPrLkBBqinX6YPpga84e2Uy1k9O2X7q3Wmwz8jU3sv
         kFpcqV3sxvBTOqFGPifZsQHN74WyGLaC5NeSN3FU8f1huhxvJLLojMbZEc5QyuKnnr
         e5lag0Wy6eW1vljjcPVr5TRlzEktDUf0yRikoWsuRIGWLmKvp45+js0NjDVI4Z6EUh
         ocOe1RKkeUkrg==
Date:   Tue, 23 Aug 2022 08:00:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sergei Antonov <saproj@gmail.com>
Subject: Re: [PATCH net] net: dsa: don't dereference NULL extack in
 dsa_slave_changeupper()
Message-ID: <20220823080023.43e9da81@kernel.org>
In-Reply-To: <20220823100834.qikdvkekg6swn7rb@skbuf>
References: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
        <20220822182523.6821e176@kernel.org>
        <20220823100834.qikdvkekg6swn7rb@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Aug 2022 10:08:34 +0000 Vladimir Oltean wrote:
> On Mon, Aug 22, 2022 at 06:25:23PM -0700, Jakub Kicinski wrote:
> > On Fri, 19 Aug 2022 20:39:25 +0300 Vladimir Oltean wrote:  
> > > diff --git a/net/dsa/slave.c b/net/dsa/slave.c
> > > index c548b969b083..804a00324c8b 100644
> > > --- a/net/dsa/slave.c
> > > +++ b/net/dsa/slave.c
> > > @@ -2487,7 +2487,7 @@ static int dsa_slave_changeupper(struct net_device *dev,
> > >  			if (!err)
> > >  				dsa_bridge_mtu_normalization(dp);
> > >  			if (err == -EOPNOTSUPP) {
> > > -				if (!extack->_msg)
> > > +				if (extack && !extack->_msg)
> > >  					NL_SET_ERR_MSG_MOD(extack,
> > >  							   "Offloading not supported");  
> > 
> > Other offload paths set the extack prior to the driver call,  
> 
> Example?
> 
> > which has the same effect.  
> 
> No, definitely not the same effect. The difference between (a) setting it
> to "Offloading not supported" before the call to dsa_port_bridge_join()
> and (b) setting it to "Offloading not supported" only if dsa_port_bridge_join()
> returned -EOPNOTSUPP is that drivers don't have to set an extack message
> if they return success, or if they don't implement ds->ops->port_bridge_join.
> The behavior changes for a driver that doesn't set the extack but
> returns 0 if I do that.

Hm, I was pretty sure that's what we did in tc, but maybe it was just
discussed and never done. Let me apply, then.

> > Can't we do the same thing here?
> > Do we care about preserving the extack from another notifier 
> > handler or something? Does not seem like that's the case judging 
> > but the commit under Fixes.  
> 
> Preserving yes, from another notifier handler no.
> 
> DSA suppresses the -EOPNOTSUPP error code from this operation and
> returns 0 to user space, along with a warning note via extack.
> 
> The driver's ds->ops->port_bridge_join() method is given an extack.
> Therefore, if the driver has set the extack to anything, presumably it
> is more specific than what DSA has to say.
> 
> > If it is the case (and hopefully not) we should add a new macro wrapper.
> > Manually twiddling with a field starting with an underscore makes
> > me feel dirty. Perhaps I have been writing too much python lately.  
> 
> Ok, can do later (not "net" patch). Also, if you search for _msg in
> net/dsa/ you'll find more occurrences of accessing it directly.
