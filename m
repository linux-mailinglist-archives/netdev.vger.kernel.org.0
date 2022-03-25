Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D50ED4E7C11
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233387AbiCYV0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:26:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbiCYV0w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:26:52 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3759123932C;
        Fri, 25 Mar 2022 14:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=QEDhIgJeIbzCTSaqjVqTZlpKCAowR+UcFnXwn8gtAfA=;
        t=1648243516; x=1649453116; b=pf8OVm9SPCIjev//bYF0G+SVdxQ9cy1rcFiKdhlOzQgt58D
        MAGmC/4Byaal5ODDkraahfVJWGOn7MCS6vG0uTChP0UYTa8kZxdC0eZw2tdVX9kByv1Z74AjDu3cW
        1LWKYuijksu9NuxrSVHZKt6ZkwtCZ3/N+1lT8uTGrd7oltKxuoDZat1zty3tvhffh9o9dyXmeUVco
        aCCY/QprEZlfAS6A7lco2UfUgrzwS6Kt8RzptXbt5kK3e/dWg6o31pEE/Oc6PS2dw8UqPmKTMh/az
        BALcmIMsMtT439hfI4CQiOI2gLQY4vtSOsG/5AlkVEImqQ02mrmZujHxSnOucHUw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXrQg-000VlP-Hr;
        Fri, 25 Mar 2022 22:25:06 +0100
Message-ID: <46b8555d4cded50bc5573fd9b7dd444021317a6b.camel@sipsolutions.net>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
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
Date:   Fri, 25 Mar 2022 22:25:05 +0100
In-Reply-To: <20220325134040.0d98835b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-03-25 at 13:40 -0700, Jakub Kicinski wrote:
> On Fri, 25 Mar 2022 18:01:30 +0100 Johannes Berg wrote:
> > That's not a bad idea, but I think I wouldn't want to backport that, so
> > separately :) I don't think that fundamentally changes the locking
> > properties though.
> > 
> > 
> > Couple of more questions I guess: First, are we assuming that the
> > cfg80211 code *is* actually broken, even if it looks like nothing can
> > cause the situation, due to the empty todo list?
> 
> Right.

I guess that the below is basically saying "it's not really broken" :)

> > Given that we have rtnl_lock_unregistering() (and also
> > rtnl_lock_unregistering_all()), it looks like we *do* in fact at least
> > not want to make an assumption that no user of __rtnl_unlock() can have
> > added a todo item.
> > 
> > I mean, there's technically yet *another* thing we could do - something
> > like this:
> > 
> > [this doesn't compile, need to suitably make net_todo_list non-static]
> > --- a/net/core/rtnetlink.c
> > +++ b/net/core/rtnetlink.c
> > @@ -95,6 +95,7 @@ void __rtnl_unlock(void)
> >  
> >         defer_kfree_skb_list = NULL;
> >  
> > +       WARN_ON(!list_empty(&net_todo_list));
> >         mutex_unlock(&rtnl_mutex);
> >  
> >         while (head) {
> 
> Yeah, I think we could do that.

It seems that would be simpler. Even if I might eventually still want to
do the cfg80211 change, but it would give us some confidence that this
really cannot be happening anywhere.


> TBH I don't know what you mean by rtnl_lock_unregistering(), I don't
> have that in my tree. rtnl_lock_unregistering_all() can't hurt the case
> we're talking about AFAICT.
> 
> Eric removed some of the netns / loopback dependencies in net-next, 
> make sure you pull!

Sorry, yeah, I was looking at an older tree where I was testing on in
the simulation environment - this disappeared in commit 8a4fc54b07d7
("net: get rid of rtnl_lock_unregistering()").

> > With some suitable commentary, that might also be a reasonable thing?
> > __rtnl_unlock() is actually rather pretty rare, and not exported.
> 
> The main use for it seems to be re-locking before loading a module,
> which TBH I have no idea why, is it just a cargo cult or a historical
> thing :S  I don't see how letting netdevs leave before _loading_ 
> a module makes any difference whatsoever.

Indeed.


> The WARN_ON() you suggested up front make perfect sense to me.
> You can also take the definition of net_unlink_todo() out of
> netdevice.h while at it because o_0

Heh indeed, what?

But (and now I'll CC even more people...) if we can actually have an
invariant that while RTNL is unlocked the todo list is empty, then we
also don't need rtnl_lock_unregistering_all(), and can remove the
netdev_unregistering_wq, etc., no?

IOW, I'm not sure why we needed commit 50624c934db1 ("net: Delay
default_device_exit_batch until no devices are unregistering v2"), but I
also have little doubt that we did.

Ah, no. This isn't about locking in this case, it's literally about
ensuring that free_netdev() has been called in netdev_run_todo()?

Which we don't care about in cfg80211 - we just care about the list
being empty so there's no chance we'll reacquire the RTNL.

johannes
