Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3C263E097
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 20:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiK3TVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 14:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiK3TUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 14:20:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB1E91C21
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 11:20:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AF81B81CB8
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 19:20:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04AC7C433D6;
        Wed, 30 Nov 2022 19:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669836039;
        bh=9AIdWgwx1mDtWEGrCCdaSLV0AmX/ddZzwZmhxSwrRU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oS7F9iILbsVDYr4VVgsufOYfmFXYnjlky/5roEHgUwW5a1Ts7NdBMkoIHxBxgONCH
         ghmZ7rfqUXUFwBpRAeuruczOtB17A9nLgNjc23cDkc3ufnsNW2DROFZdL51lgldzZl
         MpiEBr95pddzyMrq/YDL1+FpYNPmgPXhdAX5LRC/fAKbw1T6gb6a7gFaahaZwG8Jmt
         0cDXi1BxcfO0VWgTJVjRxDZXZBIB9dv5r0p9FG72fEvpAvcEK98zeJiOI8CxdqbnmQ
         HPr5ezJ2fvSbSsouc/LCslqsYvMPNu7hG4UIQn6KMlkrlcuL6DIeK2u9SgY2+cS1I+
         Dku9wMwwUU10w==
Date:   Wed, 30 Nov 2022 21:20:34 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jiri Pirko <jiri@resnulli.us>, Ido Schimmel <idosch@idosch.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4etAg+vcnRCMWx9@unreal>
References: <20221123181800.1e41e8c8@kernel.org>
 <Y4R9dT4QXgybUzdO@shredder>
 <Y4SGYr6VBkIMTEpj@nanopsycho>
 <20221128102043.35c1b9c1@kernel.org>
 <Y4XDbEWmLRE3D1Bx@nanopsycho>
 <20221129181826.79cef64c@kernel.org>
 <Y4dBrx3GTl2TLIrJ@nanopsycho>
 <20221130084659.618a8d60@kernel.org>
 <Y4eMFUBWKuLLavGB@nanopsycho>
 <20221130092042.0c223a8c@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130092042.0c223a8c@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 30, 2022 at 09:20:42AM -0800, Jakub Kicinski wrote:
> On Wed, 30 Nov 2022 18:00:05 +0100 Jiri Pirko wrote:
> > Wed, Nov 30, 2022 at 05:46:59PM CET, kuba@kernel.org wrote:
> > >On Wed, 30 Nov 2022 12:42:39 +0100 Jiri Pirko wrote:  
> > >> **)
> > >> I see. With the change I suggest, meaning doing
> > >> devlink_port_register/unregister() and netdev_register/unregister only
> > >> for registered devlink instance, you don't need this at all. When you
> > >> hit this compat callback, the netdevice is there and therefore devlink
> > >> instance is registered for sure.  
> > >
> > >If you move devlink registration up it has to be under the instance
> > >lock, otherwise we're back to reload problems. That implies unregister
> > >should be under the lock too. But then we can't wait for refs in
> > >unregister. Perhaps I don't understand the suggestion.  
> > 
> > I unlock for register and for the rest of the init I lock again.
> 
> The moment you register that instance callbacks can start coming.
> Leon move the register call last for a good reason - all drivers
> we looked at had bugs in handling init.

Plus we had very cozy lock->unlock->lock sequences during devlink
command execution, which caused to races between devlink calls
and driver initialization.

So I'm also interested to see what Jiri meant by saying "I unlock for
register and for the rest of the init I lock again".

Thanks
