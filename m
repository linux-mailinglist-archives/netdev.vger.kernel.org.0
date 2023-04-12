Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F30A06DFC86
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbjDLRQx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:16:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbjDLRQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:16:51 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B358061A9
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=0Lxp0E7TrNJkuKwuF7/AFHrqCEanjqnJ8qQ2PCQ1ffs=; b=jTcEhfMidHypvuC+c2aaxtusJM
        UW0BOzwzFD+MADTHWUjHjjyhn/UX2DJWs1dds9OFEGxmfp4t8gf1AmlqSni1SyjdngOb8wOoR1UaM
        vRfYbEI6w9J+2Lt4QkFXbKJc6RlxB6dYiDuI5yEMLSHRz5ilRA9HbbJT2zbqJY3itn6I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1pme4L-00A7In-E5; Wed, 12 Apr 2023 19:15:41 +0200
Date:   Wed, 12 Apr 2023 19:15:41 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
Subject: Re: [RFC PATCH v2 net-next 6/7] net: ethtool: add a mutex protecting
 RSS contexts
Message-ID: <61041c56-f7d2-49f8-9fc3-57852a96105a@lunn.ch>
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
 <9e2bcb887b5cf9cbb8c0c4ba126115fe01a01f3f.1681236654.git.ecree.xilinx@gmail.com>
 <ea711ae7-c730-4347-a148-0602c69c9828@lunn.ch>
 <69612358-2003-677a-80a2-5971dc026646@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69612358-2003-677a-80a2-5971dc026646@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 05:16:11PM +0100, Edward Cree wrote:
> On 11/04/2023 21:40, Andrew Lunn wrote:
> > On Tue, Apr 11, 2023 at 07:26:14PM +0100, edward.cree@amd.com wrote:
> >> While this is not needed to serialise the ethtool entry points (which
> >>  are all under RTNL), drivers may have cause to asynchronously access
> >>  dev->ethtool->rss_ctx; taking dev->ethtool->rss_lock allows them to
> >>  do this safely without needing to take the RTNL.
> > 
> > What is actually wrong with taking RTNL? KISS is often best,
> > especially for locks.
> 
> The examples I have of driver code that needs to access rss_ctx (in the
>  sfc driver) are deep inside call chains where RTNL may or may not
>  already be held.
> 1) filter insertion.  E.g. ethtool -U is already holding RTNL, but other
>  sources of filters (e.g. aRFS) aren't, and thus taking it if necessary
>  might mean passing a 'bool rtnl_locked' all the way down the chain.
> 2) device reset handling (we have to restore the RSS contexts in the
>  hardware after a reset).  Again resets don't always happen under RTNL,
>  and I don't fully understand the details (EFX_ASSERT_RESET_SERIALISED()).
> So it makes life much simpler if we just have a finer-grained lock we can
>  just take when we need to.
> Also, RTNL is a very big hammer that serialises all kinds of operations
>  across all the netdevs in the system, holding it for any length of time
>  can cause annoying user-visible latency (e.g. iirc sshd accepting a new
>  connection has to wait for it) so I prefer to avoid it if possible.  If
>  anything we want to be breaking up this BKL[1], not making it bigger.

Hi Ed

I have to wonder if your locking model is wrong. When i look at the
next patch, i see the driver is also using this lock. And i generally
find that is wrong.

As a rule of thumb, driver writes don't understand locking. Yes, there
are some that do, but most don't. As core code developers, i find it
good practice to have the locks in the core, and only in the
core. Drivers writers should not need to worry about locking. The API
into the driver will take the locks needed before entering the driver,
and release them on exit.

So i don't really agree with 'it makes life much simpler if we just
have a finer-grained lock'. It makes life more complex having to help
driver writers find the corruption and deadlock bugs in their code
because they got the locking wrong.

Please try to work on the abstraction so that drivers don't need this
lock, just the core.

	Andrew
