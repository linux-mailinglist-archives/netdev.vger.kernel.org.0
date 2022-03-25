Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A134E72B2
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 13:04:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358341AbiCYMGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 08:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354326AbiCYMGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 08:06:15 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F40F747AE3;
        Fri, 25 Mar 2022 05:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=VzicDpD96H2m8g/4tL/fuQtFb6meOA3bkEUuxwrHX/g=;
        t=1648209881; x=1649419481; b=VJ8Q0r6XJT1GMIe3jAKTyofGyTo+0rUir8LBEe0X8DJ3lx3
        LrIxMfOcV4a5A2SuvbsDJOS29VP4qlpBMjxBtEMnFmn0NEf9RdPKkNcHPpUryt3kMjhu67EDk03RA
        AxFcX0Yz1UPVrbMF7xVbo7lImpWeOfB6VCED7JnbdYcO5oViNVdkuIdQFT66UL3mUhRf3c1fggfAk
        Ecd45ZehQJATjn8pZU7jBzlnbz/pTyezwGoVjgI+1fEZsHvfVr6SewgGrqDez+bNNNiQHKDdb/nat
        fB6V3AIiqS78sX6HD5J1WDQd583dlS2/5ygoRncwiBfTL9esNK9JQMx9aaAvVTlg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.95)
        (envelope-from <johannes@sipsolutions.net>)
        id 1nXig4-000Jie-7D;
        Fri, 25 Mar 2022 13:04:24 +0100
Message-ID: <19e12e6b5f04ba9e5b192001fbe31a3fc47d380a.camel@sipsolutions.net>
Subject: Re: [BUG] deadlock in nl80211_vendor_cmd
From:   Johannes Berg <johannes@sipsolutions.net>
To:     William McVicker <willmcvicker@google.com>,
        linux-wireless@vger.kernel.org
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi.bhat@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>, kernel-team@android.com,
        Paolo Abeni <pabeni@redhat.com>
Date:   Fri, 25 Mar 2022 13:04:23 +0100
In-Reply-To: <Yjzpo3TfZxtKPMAG@google.com>
References: <0000000000009e9b7105da6d1779@google.com>
         <99eda6d1dad3ff49435b74e539488091642b10a8.camel@sipsolutions.net>
         <5d5cf050-7de0-7bad-2407-276970222635@quicinc.com>
         <YjpGlRvcg72zNo8s@google.com>
         <dc556455-51a2-06e8-8ec5-b807c2901b7e@quicinc.com>
         <Yjzpo3TfZxtKPMAG@google.com>
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

Hi,

(Jakub, can you please see below, I wonder which you prefer)

> 
> I found that we can hit this same ABBA deadlock within the nl80211 code
> before ever even calling into the vendor doit() function. 

Hmm.

> The issue I found
> is caused by the way we unlock the RTNL mutex. Here is the call flow that
> leads to the deadlock:
> 
> Thread 1                         Thread 2
>  nl80211_pre_doit():
>    rtnl_lock()
>    wiphy_lock()                   nl80211_pre_doit():
>                                     rtnl_lock() // blocked by Thread 1
>    rtnl_unlock():
>      netdev_run_todo():
>        __rtnl_unlock()
>                                     <got RTNL lock>
>                                     wiphy_lock() // blocked by Thread 1
>        rtnl_lock(); // DEADLOCK
>  doit()
>  nl80211_post_doit():
>    wiphy_unlock();
> 
> Basically, unlocking the RTNL within netdev_run_todo() gives another thread
> that is waiting for the RTNL in nl80211_pre_doit() a chance to grab the
> RTNL lock leading to the deadlock. I found that there are multiple
> instances where rtnl_lock() is called within netdev_run_todo(): a couple of
> times inside netdev_wait_allrefs() and directly by netdev_run_todo().

Have you actually observed this in practice?

It's true, but dynamically this only happens if you get into the

	while (!list_empty(&list)) {
	...
	}

code in netdev_run_todo().

Which in itself can only be true if a netdev was unregistered and
netdev_run_todo() didn't run yet.

Now, since normally we go through rtnl_unlock(), it's highly likely that
we get into rtnl_lock() with the todo list being empty (but not
impossible, read on), so then rtnl_unlock()/netdev_run_todo() won't be
getting into this branch, and then the deadlock cannot happen.

Now, it might be possible somewhere in the tree to unregister a netdev
and then unlock using __rtnl_unlock(), so the todo list isn't processed
until the next time, but __rtnl_unlock() isn't exported and all the
users I found didn't seem to cause this problem.


On the other hand, clearly people thought it was worth worrying about,
there are already *two* almost identical implementations of avoiding
this problem:
 - rtnl_lock_unregistering
 - rtnl_lock_unregistering_all

(identical except for the netns list they use, partial vs. all).

So we can avoid the potential deadlock in cfg80211 in a few ways:

 1) export rtnl_lock_unregistering_all() or maybe a variant after
    refactoring the two versions, to allow cfg80211 to use it, that way
    netdev_run_todo() can never have a non-empty todo list

 2) export __rtnl_unlock() so cfg80211 can avoid running
    netdev_run_todo() in the unlock, personally I like this less because
    it might encourage random drivers to use it

 3) completely rework cfg80211's locking, adding a separate mutex for
    the wiphy list so we don't need to acquire the RTNL at all here
    (unless the ops need it, but there's no issue if we don't drop it),
    something like https://p.sipsolutions.net/27d08e1f5881a793.txt


I think I'm happy with 3) now (even if it took a couple of hours), so I
think we can go with it, just need to go through all the possibilities.

johannes
