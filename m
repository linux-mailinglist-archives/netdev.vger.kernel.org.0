Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1961B67DD18
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 06:26:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbjA0F0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 00:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjA0F0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 00:26:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2E32685D
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 21:26:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1196E619FE
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 05:26:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF563C433EF;
        Fri, 27 Jan 2023 05:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674797177;
        bh=7cCRW7ZE/dmS2yOLiVK26bi2n3cjM6ODKzo2Y3b/bSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bSt9/0WoMT+bwdv0Z3z0dHWpEGJV2zcDmAVH2hUHsHcAnrFkLb1dfmXQtmCVU6K/b
         9SDa24o05vD4LofEN4xFK/lv7nQ8e5ld126hWJTajsqO/spGjZ4FDZZFn5XS7ThHtr
         mVh1Jeb9pJrOjDPw2rAKH2p1m5cEqI2hnKSdDFnq3zhhKwBHKhEgvEGAAQ3lAAUQLH
         7V5b4QGHkHOiDYx0zNnay+skEfdarYyA7uxvbGIl4VaubixRBTXjAowQFXdIMF0+2m
         sP8fn4t76BAvlDvh42LpURmfj0UginFuzKNUrvkezreHb1AWWnwOWoS0NsYjSPIHtB
         Dg7VrY0WvquwA==
Date:   Fri, 27 Jan 2023 07:26:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        bridge@lists.linux-foundation.org,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, Nikolay Aleksandrov <razor@blackwall.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: Re: [PATCH net-next] netlink: provide an ability to set default
 extack message
Message-ID: <Y9NgdXk3NLtjG3Mj@unreal>
References: <2919eb55e2e9b92265a3ba600afc8137a901ae5f.1674760340.git.leon@kernel.org>
 <20230126223213.riq6i2gdztwuinwi@skbuf>
 <20230126143723.7593ce0b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230126143723.7593ce0b@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023 at 02:37:23PM -0800, Jakub Kicinski wrote:
> On Fri, 27 Jan 2023 00:32:13 +0200 Vladimir Oltean wrote:
> > On Thu, Jan 26, 2023 at 09:15:03PM +0200, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > In netdev common pattern, xxtack pointer is forwarded to the drivers  
> >                             ~~~~~~
> >                             extack
> > 
> > > to be filled with error message. However, the caller can easily
> > > overwrite the filled message.
> > > 
> > > Instead of adding multiple "if (!extack->_msg)" checks before any
> > > NL_SET_ERR_MSG() call, which appears after call to the driver, let's
> > > add this check to common code.
> > > 
> > > [1] https://lore.kernel.org/all/Y9Irgrgf3uxOjwUm@unreal
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > > ---  
> > 
> > I would somewhat prefer not doing this, and instead introducing a new
> > NL_SET_ERR_MSG_WEAK() of sorts.
> 
> That'd be my preference too, FWIW. It's only the offload cases which
> need this sort of fallback.

Of course not, almost any error unwind path which sets extack will need it.
See devlink as an example, but I'm confident that same issue exists in other
places too.

You are suggesting API which is very easy to do wrong.

So I prefer to stay with my proposal if it is possible.

Thanks
