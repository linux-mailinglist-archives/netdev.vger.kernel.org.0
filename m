Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA2C4E7DF8
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:23:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiCYUmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 16:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiCYUmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 16:42:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 099AC17F3DF;
        Fri, 25 Mar 2022 13:40:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E362B829A3;
        Fri, 25 Mar 2022 20:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C067C004DD;
        Fri, 25 Mar 2022 20:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648240842;
        bh=0lBSG7GB/U8B6WPdDTFnKxY0g5umJvPVCbTCx5CJxJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LGN+clpXlJtDj+wh5NzJmBYvZ0RhrVyQ2RF1Pw0NQ1ybhy1ErvCbiz1TZHKa1K39B
         OQu+ZqXXsmTVJodZ9j//7zp+BTbM2qTAxByUshIbMyK9i7vmJk7jmfliSHGH0OBGXv
         iAUEPrrezMTopFJ+nJJBE5XBZeFor0U3oA/VYcq22u/sk7M6hufw415k/Or/3Wpc7w
         WVs5yJWekRV8G0f02bvJPjzjKX+UwCYEmAPGaQw1xWRndAcdHtN/JuQkwgPm8k9Quz
         GOYxVjNc0AJNmuxWjsllq5S5JjUkFmx4//jsoy+CS35o/nPS5fUEOejaoIVW7Lc5t4
         IX7mrT9sxwKaQ==
Date:   Fri, 25 Mar 2022 13:40:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     William McVicker <willmcvicker@google.com>,
        linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
Message-ID: <20220325134040.0d98835b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
References: <0000000000009e9b7105da6d1779@google.com>
        <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
        <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
        <YjpGlRvcg72zNo8s@google.com>
        <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
        <Yjzpo3TfZxtKPMAG@google.com>
        <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
        <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
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

On Fri, 25 Mar 2022 18:01:30 +0100 Johannes Berg wrote:
> That's not a bad idea, but I think I wouldn't want to backport that, so
> separately :) I don't think that fundamentally changes the locking
> properties though.
> 
> 
> Couple of more questions I guess: First, are we assuming that the
> cfg80211 code *is* actually broken, even if it looks like nothing can
> cause the situation, due to the empty todo list?

Right.

> Given that we have rtnl_lock_unregistering() (and also
> rtnl_lock_unregistering_all()), it looks like we *do* in fact at least
> not want to make an assumption that no user of __rtnl_unlock() can have
> added a todo item.
> 
> I mean, there's technically yet *another* thing we could do - something
> like this:
> 
> [this doesn't compile, need to suitably make net_todo_list non-static]
> --- a/net/core/rtnetlink.c
> +++ b/net/core/rtnetlink.c
> @@ -95,6 +95,7 @@ void __rtnl_unlock(void)
>  
>         defer_kfree_skb_list = NULL;
>  
> +       WARN_ON(!list_empty(&net_todo_list));
>         mutex_unlock(&rtnl_mutex);
>  
>         while (head) {

Yeah, I think we could do that.

> and actually that would allow us to get rid of rtnl_lock_unregistering()
> and rtnl_lock_unregistering_all() simply because we'd actually guarantee
> the invariant that when the RTNL is freshly locked, the list is empty
> (by guaranteeing that it's always empty when it's unlocked, since it can
> only be added to under RTNL).

TBH I don't know what you mean by rtnl_lock_unregistering(), I don't
have that in my tree. rtnl_lock_unregistering_all() can't hurt the case
we're talking about AFAICT.

Eric removed some of the netns / loopback dependencies in net-next, 
make sure you pull!

> With some suitable commentary, that might also be a reasonable thing?
> __rtnl_unlock() is actually rather pretty rare, and not exported.

The main use for it seems to be re-locking before loading a module,
which TBH I have no idea why, is it just a cargo cult or a historical
thing :S  I don't see how letting netdevs leave before _loading_ 
a module makes any difference whatsoever.

> However, if you don't like that ...
> 
> I've been testing with this patch, to make lockdep complain:
> 
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -9933,6 +9933,11 @@ void netdev_run_todo(void)
>         if (!list_empty(&list))
>                 rcu_barrier();
>  
> +#ifdef CONFIG_LOCKDEP
> +       rtnl_lock();
> +       __rtnl_unlock();
> +#endif
> +
>         while (!list_empty(&list)) {
>                 struct net_device *dev
>                         = list_first_entry(&list, struct net_device, todo_list);
> 
> 
> That causes lockdep to complain for cfg80211 even if the list *is* in
> fact empty.
> 
> Would you be open to adding something like that? Perhaps if I don't just
> do the easy rtnl_lock/unlock, but try to find the corresponding lockdep-
> only things to do there, to cause lockdep to do things without really
> locking? OTOH, the locking overhead of the RTNL we just unlocked is
> probably minimal, vs. the actual work *lockdep* is doing to track all
> this ...

The WARN_ON() you suggested up front make perfect sense to me.
You can also take the definition of net_unlink_todo() out of
netdevice.h while at it because o_0
