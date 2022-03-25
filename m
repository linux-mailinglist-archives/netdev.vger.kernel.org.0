Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 285874E7C60
	for <lists+netdev@lfdr.de>; Sat, 26 Mar 2022 01:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233419AbiCYVSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 17:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbiCYVST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 17:18:19 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8ACDEA6;
        Fri, 25 Mar 2022 14:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=VjjoxVuhRNNF8jYyMUMowFklmpUhYFJFF0ZY+7oRIwo=;
        t=1648243004; x=1649452604; b=HwTHh1ObyTEECo58y7w/OzGMUaz2z2uEHBYlx+QE9Eb8wY6
        ogRLiCdnzQFkHy8da3PbVtk7Vwm0JGLCDImPgMS4M/9z3zSRbQf6O3kqLnz8TmNH093NVuXnUKvqe
        vWrcH8mVeqlIAbqPtHG+ifXAX31+1M7SwJw5sC/jV9iHh+Batia0KuDMqzki2zz44HrlLGRnNlzoh
        JOw/T6IFAkQRQHtBMp6EStSyGeHUI7m+jjY9r/2Sm6IjqFmcaKXfpN9w9bFZ9+X4jIwNqAIxLxWTM
        dh0NjOK3aBL+NeUEs4LVpPmt+YygfT3MJlhilSftJkiAkkEKndA1Cxe0szWgGm1Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXrIM-000VcJ-9j;
        Fri, 25 Mar 2022 22:16:30 +0100
Message-ID: <976e8cf697c7e5bc3a752e758a484b69a058710a.camel@sipsolutions.net>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
From:   Johannes Berg <johannes@sipsolutions.net>
To:     William McVicker <willmcvicker@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-wireless@vger.kernel.org,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Date:   Fri, 25 Mar 2022 22:16:29 +0100
In-Reply-To: <Yj4ntUejxaPhrM5b@google.com>
References: <0000000000009e9b7105da6d1779@google.com>
         <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
         <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
         <YjpGlRvcg72zNo8s@google.com>
         <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
         <Yjzpo3TfZxtKPMAG@google.com>
         <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
         <20220325094952.10c46350@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <f4f8a27dc07c1adaab470fde302ed841113e6b7f.camel@sipsolutions.net>
         <Yj4FFIXi//ivQC3X@google.com> <Yj4ntUejxaPhrM5b@google.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-03-25 at 20:36 +0000, William McVicker wrote:
> 
> I found that my wlan driver is using the vendor commands to create/delete NAN
> interfaces for this Android feature called Wi-Fi aware [1]. Basically, this
> features allows users to discover other nearby devices and allows them to
> connect directly with one another over a local network. 
> 

Wait, why is it doing that? We actually support a NAN interface type
upstream :) It's not really quite fully fleshed out, but it could be?
Probably should be?


> Thread 1                         Thread 2
>  nl80211_pre_doit():
>    rtnl_lock()
>    wiphy_lock()                   nl80211_pre_doit():
>                                     rtnl_lock() // blocked by Thread 1
>  nl80211_vendor_cmd():
>    doit()
>      cfg80211_unregister_netdevice()
>    rtnl_unlock():
>      netdev_run_todo():
>        __rtnl_unlock()
>                                     <got RTNL lock>
>                                     wiphy_lock() // blocked by Thread 1
>        rtnl_lock(); // DEADLOCK
>  nl80211_post_doit():
>    wiphy_unlock();


Right, this is what I had discussed in my other mails.

Basically, you're actually doing (some form of) unregister_netdevice()
before rtnl_unlock().

Clearly this isn't possible in cfg80211 itself.

However, I couldn't entirely discount the possibility that this is
possible:

Thread 1                   Thread 2
                            rtnl_lock()
                            unregister_netdevice()
                            __rtnl_unlock()
rtnl_lock()
wiphy_lock()
netdev_run_todo()
 __rtnl_unlock()
 // list not empty now    
 // because of thread 2     rtnl_lock()
 rtnl_lock()
                            wiphy_lock()

** DEADLOCK **


Given my other discussion with Jakub though, it seems that we can indeed
make sure that this cannot happen, and then this scenario is impossible
without the unregistration you're doing.

> Since I'm unlocking the RTNL inside nl80211_vendor_cmd() after calling doit()
> instead of waiting till post_doit(), I get into the situation you mentioned
> where the net_todo_list is not empty when calling rtnl_unlock. So I decided to
> drop the rtnl_unlock() in nl80211_vendor_cmd() and defer that until
> nl80211_post_doit() after calling wiphy_unlock(). With this change, I haven't
> been able to reproduce the deadlock. So it's possible that we aren't actually
> able to hit this deadlock in nl80211_pre_doit() with the existing code since,
> as you mentioned, one wouldn't be able to call unregister_netdevice() without
> having the RTNL lock.
> 

Right, this is why I said earlier that actually adding a flag for vendor
commands to get the RTNL would be more complex - you'd have to basically
open-code pre_doit() and post_doit() in there and check the sub-command
flag at the very beginning and very end.

johannes
