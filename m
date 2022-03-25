Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 288254E7998
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 18:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354507AbiCYRDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 13:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377352AbiCYRDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 13:03:18 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FB84D268;
        Fri, 25 Mar 2022 10:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=KIBXOVtkmOwL5E0vgfaT6N95rJNQ6um0hl1Uz1iYDsM=;
        t=1648227704; x=1649437304; b=L4IdXzV4ge3lc5bsXEejWvQ+wEuLPal+k1jKGIH27lTUjuR
        IvfvmSc8C1Pqh8/U4PW9DHWjMJfPMkCEPNWUiZMHWwLy5zP7GNPMKfaePQnPqYqAMs/8JB92NPezM
        CphOYxPiukqTAlkYdh12K+LAXVQKjErK0AkYpfA/klWVb2lrL+XmTwL/J2nQLRfcktIfAXK01BSLM
        wl6AME5PCbw9DuWOyNvMEzjhu2oU2v+3mX6sJPTqmdCQzzKqhAW5nDaWtfNXlJ4OlT32BjWp8w0D3
        fAbn4ccGC7+42EPk7jw8Hno5bQknFTqFOIrVtFR/gKIRb4PcmsjIlzRLXjl8fWDA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXnJb-000QWH-Nz;
        Fri, 25 Mar 2022 18:01:31 +0100
Message-ID: <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     William McVicker <willmcvicker@google.com>,
        linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Date:   Fri, 25 Mar 2022 18:01:30 +0100
In-Reply-To: <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <0000000000009e9b7105da6d1779@google.com>
         <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
         <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
         <YjpGlRvcg72zNo8s@google.com>
         <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
         <Yjzpo3TfZxtKPMAG@google.com>
         <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
         <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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

On Fri, 2022-03-25 at 09:49 -0700, Jakub Kicinski wrote:
> On Fri, 25 Mar 2022 13:04:23 +0100 Johannes Berg wrote:
> > So we can avoid the potential deadlock in cfg80211 in a few ways:
> > 
> >  1) export rtnl_lock_unregistering_all() or maybe a variant after
> >     refactoring the two versions, to allow cfg80211 to use it, that way
> >     netdev_run_todo() can never have a non-empty todo list
> > 
> >  2) export __rtnl_unlock() so cfg80211 can avoid running
> >     netdev_run_todo() in the unlock, personally I like this less because
> >     it might encourage random drivers to use it
> > 
> >  3) completely rework cfg80211's locking, adding a separate mutex for
> >     the wiphy list so we don't need to acquire the RTNL at all here
> >     (unless the ops need it, but there's no issue if we don't drop it),
> >     something like https://p.sipsolutions.net/27d08e1f5881a793.txt
> > 
> > 
> > I think I'm happy with 3) now (even if it took a couple of hours), so I
> > think we can go with it, just need to go through all the possibilities.
> 
> I like 3) as well. FWIW a few places (e.g. mlx5, devlink, I think I've
> seen more) had been converting to xarray for managing the "registered"
> objects. It may be worth looking into if you're re-doing things, anyway.
> 

That's not a bad idea, but I think I wouldn't want to backport that, so
separately :) I don't think that fundamentally changes the locking
properties though.


Couple of more questions I guess: First, are we assuming that the
cfg80211 code *is* actually broken, even if it looks like nothing can
cause the situation, due to the empty todo list?

Given that we have rtnl_lock_unregistering() (and also
rtnl_lock_unregistering_all()), it looks like we *do* in fact at least
not want to make an assumption that no user of __rtnl_unlock() can have
added a todo item.

I mean, there's technically yet *another* thing we could do - something
like this:

[this doesn't compile, need to suitably make net_todo_list non-static]
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -95,6 +95,7 @@ void __rtnl_unlock(void)
 
        defer_kfree_skb_list = NULL;
 
+       WARN_ON(!list_empty(&net_todo_list));
        mutex_unlock(&rtnl_mutex);
 
        while (head) {

and actually that would allow us to get rid of rtnl_lock_unregistering()
and rtnl_lock_unregistering_all() simply because we'd actually guarantee
the invariant that when the RTNL is freshly locked, the list is empty
(by guaranteeing that it's always empty when it's unlocked, since it can
only be added to under RTNL).

With some suitable commentary, that might also be a reasonable thing?
__rtnl_unlock() is actually rather pretty rare, and not exported.


However, if you don't like that ...

I've been testing with this patch, to make lockdep complain:

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9933,6 +9933,11 @@ void netdev_run_todo(void)
        if (!list_empty(&list))
                rcu_barrier();
 
+#ifdef CONFIG_LOCKDEP
+       rtnl_lock();
+       __rtnl_unlock();
+#endif
+
        while (!list_empty(&list)) {
                struct net_device *dev
                        = list_first_entry(&list, struct net_device, todo_list);


That causes lockdep to complain for cfg80211 even if the list *is* in
fact empty.

Would you be open to adding something like that? Perhaps if I don't just
do the easy rtnl_lock/unlock, but try to find the corresponding lockdep-
only things to do there, to cause lockdep to do things without really
locking? OTOH, the locking overhead of the RTNL we just unlocked is
probably minimal, vs. the actual work *lockdep* is doing to track all
this ...

Thanks,
johannes
