Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDC824E7CC6
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:22:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233560AbiCYVuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:50:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233526AbiCYVuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:50:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159EC15AAF8;
        Fri, 25 Mar 2022 14:48:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B60B7B829BA;
        Fri, 25 Mar 2022 21:48:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB32C2BBE4;
        Fri, 25 Mar 2022 21:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648244921;
        bh=g3tMjcH8Q1ET2Bd+kcytt3Y3iDDh51rlme44+V0MJas=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o7wYz+O2Ruoaq98WvBaydW+RfhoZE9XDULwEk5PULFW6Rrl6KNo085xqkgHwzdgDR
         ET2DppVTaCNrcuEQ6gghWc+snJbqdYcY/Uasu8P2PaCgrc65855Kewera4YoTclbIW
         nKf5Nzr1olQV4SaxHtvHKllQqSrqX/6jkFTK4fefoIg/3JIjkDjEaqlJhFPov1jKSJ
         PYh4Kyb5X1xs/UWjObQkTvQf3NPT7jVKpg/PkSrIE1QjTHcEJ1rL8US2ii2tTUmlPp
         GaZE9LWtXB8IX0e1VzLxdJrt/DpPnjzEv6Vx7tBhzSJDSwIYvEwEHg/4Xu/FfKfl/t
         xuOk2otDHeH2A==
Date:   Fri, 25 Mar 2022 14:48:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     William McVicker <willmcvicker@google.com>,
        linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Cong Wang <cwang@twopensource.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
Message-ID: <20220325144839.7110fc8d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <46b8555d4cded50bc5573fd9b7dd444021317a6b.camel@sipsolutions.net>
References: <0000000000009e9b7105da6d1779@google.com>
        <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
        <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
        <YjpGlRvcg72zNo8s@google.com>
        <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
        <Yjzpo3TfZxtKPMAG@google.com>
        <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
        <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
        <20220325134040.0d98835b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <46b8555d4cded50bc5573fd9b7dd444021317a6b.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Mar 2022 22:25:05 +0100 Johannes Berg wrote:
> > > With some suitable commentary, that might also be a reasonable thing?
> > > __rtnl_unlock() is actually rather pretty rare, and not exported.  
> > 
> > The main use for it seems to be re-locking before loading a module,
> > which TBH I have no idea why, is it just a cargo cult or a historical
> > thing :S  I don't see how letting netdevs leave before _loading_ 
> > a module makes any difference whatsoever.  
> 
> Indeed.
> 
> > The WARN_ON() you suggested up front make perfect sense to me.
> > You can also take the definition of net_unlink_todo() out of
> > netdevice.h while at it because o_0  
> 
> Heh indeed, what?

To be clear - I just meant that it's declaring a static variable in 
a header, so I doubt that it'll do the right thing unless it's only
called from one compilation unit.

> But (and now I'll CC even more people...) if we can actually have an
> invariant that while RTNL is unlocked the todo list is empty, then we
> also don't need rtnl_lock_unregistering_all(), and can remove the
> netdev_unregistering_wq, etc., no?
> 
> IOW, I'm not sure why we needed commit 50624c934db1 ("net: Delay
> default_device_exit_batch until no devices are unregistering v2"), but I
> also have little doubt that we did.
> 
> Ah, no. This isn't about locking in this case, it's literally about
> ensuring that free_netdev() has been called in netdev_run_todo()?

Yup, multiple contexts sitting independently in netdev_run_todo() and
chewing on netdevs is slightly different. destructors of those netdevs
could be pointing at memory of a module being unloaded.

> Which we don't care about in cfg80211 - we just care about the list
> being empty so there's no chance we'll reacquire the RTNL.
