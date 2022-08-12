Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F3E05915E7
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 21:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235663AbiHLTZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 15:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbiHLTZO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 15:25:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC892B8;
        Fri, 12 Aug 2022 12:25:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 822C361786;
        Fri, 12 Aug 2022 19:25:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76DD6C433D6;
        Fri, 12 Aug 2022 19:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660332310;
        bh=0+lCa3Lw/uI704NKn0CRHe4OSa4UTxWw50oFGOX9HPg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fubw96tYs+TNoIY57YLdw2X/9/wamLfGw6T4Gp5DcLWcTXIsu8xSztR2sQMLD9+6d
         mrpfYAlDqgJjpSgfA1LhdpgShoWZYAUB8+Rq4Daia6Qz7xRYdserWqUvN4ojoh/OAV
         X1TOkfA8t+rj9JItHxJcU97eS0GHWdptXHZZDAiaowp2+zmSfc/vFB0yd9j10qIg4j
         xz406CH15OzHuDdgPXpM5J0foB9+khbHrLmtOhpc2Iu3H1VK5BWi2B/Cjejin4Nk4s
         jDepratPaH6Lo5SNUw81L6ewXjUXpREXL7y67MDEkPG5QBYfAQ8ftLu9GNK06+8IAD
         1H0izDxAH92Aw==
Date:   Fri, 12 Aug 2022 12:25:09 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Siddh Raman Pant <code@siddh.me>
Cc:     "Greg KH" <gregkh@linuxfoundation.org>,
        "johannes berg" <johannes@sipsolutions.net>,
        "david s. miller" <davem@davemloft.net>,
        "eric dumazet" <edumazet@google.com>,
        "paolo abeni" <pabeni@redhat.com>,
        "netdev" <netdev@vger.kernel.org>,
        "syzbot+6cb476b7c69916a0caca" 
        <syzbot+6cb476b7c69916a0caca@syzkaller.appspotmail.com>,
        "linux-wireless" <linux-wireless@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>,
        "syzbot+f9acff9bf08a845f225d" 
        <syzbot+f9acff9bf08a845f225d@syzkaller.appspotmail.com>,
        "syzbot+9250865a55539d384347" 
        <syzbot+9250865a55539d384347@syzkaller.appspotmail.com>,
        "linux-kernel-mentees" 
        <linux-kernel-mentees@lists.linuxfoundation.org>
Subject: Re: [PATCH v2] wifi: cfg80211: Fix UAF in ieee80211_scan_rx()
Message-ID: <20220812122509.281f0536@kernel.org>
In-Reply-To: <18292e1dcd8.2359a549180213.8185874405406307019@siddh.me>
References: <20220726123921.29664-1-code@siddh.me>
        <18291779771.584fa6ab156295.3990923778713440655@siddh.me>
        <YvZEfnjGIpH6XjsD@kroah.com>
        <18292791718.88f48d22175003.6675210189148271554@siddh.me>
        <YvZxfpY4JUqvsOG5@kroah.com>
        <18292e1dcd8.2359a549180213.8185874405406307019@siddh.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 21:57:31 +0530 Siddh Raman Pant wrote:
> On Fri, 12 Aug 2022 20:57:58 +0530  Greg KH  wrote:
> > rcu just delays freeing of an object, you might just be delaying the
> > race condition.  Just moving a single object to be freed with rcu feels
> > very odd if you don't have another reference somewhere.  
> 
> As mentioned in patch message, in net/mac80211/scan.c, we have:
>         void ieee80211_scan_rx(struct ieee80211_local *local, struct sk_buff *skb)
>         {
>                 ...
>                 scan_req = rcu_dereference(local->scan_req);
>                 sched_scan_req = rcu_dereference(local->sched_scan_req);
> 
>                 if (scan_req)
>                         scan_req_flags = scan_req->flags;
>                 ...
>         }
> 
> So scan_req is probably supposed to be protected by RCU.
> 
> Also, in ieee80211_local's definition at net/mac80211/ieee80211_i.h, we have:
>         struct cfg80211_scan_request __rcu *scan_req;
> 
> Thus, scan_req is indeed supposed to be protected by RCU, which this patch
> addresses by adding a RCU head to the type's struct, and using kfree_rcu().
> 
> The above snippet is where the UAF happens (you can refer to syzkaller's log),
> because __cfg80211_scan_done() is called and frees the pointer.

Similarly to Greg, I'm not very familiar with the code base but one
sure way to move things forward would be to point out a commit which
broke things and put it in a Fixes tag. Much easier to validate a fix
by looking at where things went wrong.
