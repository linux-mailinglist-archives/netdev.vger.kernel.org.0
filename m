Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A9D85E566B
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 00:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiIUW4p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 18:56:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbiIUW4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 18:56:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0089A90815
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 15:56:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3809962DE0
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 22:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34018C433C1;
        Wed, 21 Sep 2022 22:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663801001;
        bh=GrU3rCLzr60PoQHSqHPiPtjOUmEaAoq2FbQcBW2y/0I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AJXm6t3gxZaw53fJG5wgwYHoJj23YMYFyPeLBxnafilPEF4c9ldWsHi5pdM0M7Zsw
         5bTR3A4n9Hv8eZcv7xN8/EOHOjX8AmCLkPNKb0XQYUKjopKpQq/hijII8zcgyFXk1C
         E6JVA+IwkLeoEW8SKlDGwxkYL3uIv2d39Y5abt1civrJv1xgqZlpNGdFoMW+o6Y/AW
         BNE5LYGgkkq9Nuw2hwqK7+GRAvaXEvEAo43qRiSfhLxNi5hN5Vs0AtdEjAm0jkb7r4
         VXnT0rmEeO9rRny3X6fJ1DtumS+K3/cKfZLoDeuQKxPrsq5yXdy6U5e8PI47fMCBcR
         CNmkSKDe80+Sw==
Date:   Wed, 21 Sep 2022 15:56:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Nikolay Aleksandrov <razor@blackwall.org>
Subject: Re: [PATCH net-next] rtnetlink: Honour NLM_F_ECHO flag in
 rtnl_{new, set}link
Message-ID: <20220921155640.1f3dce59@kernel.org>
In-Reply-To: <20220921161409.GA11793@debian.home>
References: <20220921030721.280528-1-liuhangbin@gmail.com>
        <20220921060123.1236276d@kernel.org>
        <20220921161409.GA11793@debian.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Sep 2022 18:14:09 +0200 Guillaume Nault wrote:
> > I'd love to hear what others think. IMO we should declare a moratorium
> > on any use of netlink flags and fixed fields, push netlink towards
> > being a simple conduit for TLVs.  
> 
> At my previous employer, we had a small program inserting and removing
> routes depending on several external events (not a full-fledged routing
> daemon). NLM_F_ECHO was used at least to log the real kernel actions (as
> opposed to what the program intended to do) and link that to the events
> that triggered these actions. That was really helpful for network
> administrators. Yes, we were lucky that the RTM_NEWROUTE and
> RTM_DELROUTE message handlers supported NLM_F_ECHO. I was surprised when
> I later realised that RTM_NEWLINK and many others didn't.
> 
> Then, a few years ago, I had questions from another team (maybe Network
> Manager but I'm not sure) who asked how to reliably retrieve
> informations like the ifindex of newly created devices. That's the use
> case NLM_F_ECHO is for, but lacking this feature this team had to
> rely on a more convoluted and probably racy way. That was the moment
> I decided to expose the problem to our team. Fast-forwarding a couple
> of years and Hangbin picked up the task.

Looking closer at the code it seems like what NLM_F_ECHO does in most
places is to loop notifications resulting from the command back onto
the requesting socket. See nlmsg_notify(), report is usually passed 
as nlmsg_report(req).

I guess that answers Hangbin's question - yes, I'd vote that we just
pass the nlh to rtnl_notify() and let the netlink core do its thing.

In general I still don't think NLM_F_ECHO makes for a reasonable API.
It may seem okay to those who are willing to write manual netlink
parsers but for a normal programmer the ability to receive directly
notifications resulting from a API call they made is going to mean..
nothing they can have prior experience with. NEWLINK should have
reported the allocated handle / ifindex from the start :(

The "give me back the notifications" semantics match well your use
case to log what the command has done, in that case there is no need 
to "return" all the notifications from the API call.
