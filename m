Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37FF22FF0
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 11:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731937AbfETJLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 05:11:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:36816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731095AbfETJLe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 May 2019 05:11:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CC74420656;
        Mon, 20 May 2019 09:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558343494;
        bh=U76uCPWwkjAlQMoQuk81T5lqeD1YoluVf7Go70H7KkY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RVY8Ip1ZIHJa47llpQIR+xlhZFIjFM2mNqU7bQOaQCZKKmr0HZdum/SK2Ufw9j+N5
         haRFjmJW2ZHWFyjvr9ABoHwQBGKA8ZCvG5A/7WjMFZSnzObB2AtBY/VIwBGeg8QNzv
         16GBOD3fLTHAClbFFk6ZinGouARHnBWxm2nl6RmQ=
Date:   Mon, 20 May 2019 11:11:31 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Nathan Chancellor <natechancellor@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Haller <thaller@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH 4.9 41/51] fib_rules: return 0 directly if an exactly
 same rule exists when NLM_F_EXCL not supplied
Message-ID: <20190520091131.GA1593@kroah.com>
References: <20190515090616.669619870@linuxfoundation.org>
 <20190515090628.066392616@linuxfoundation.org>
 <20190519154348.GA113991@archlinux-epyc>
 <a36e3204-b52d-0bf0-f956-654189a18156@gmail.com>
 <20190520090429.GA25812@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520090429.GA25812@kroah.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 11:04:29AM +0200, Greg Kroah-Hartman wrote:
> On Sun, May 19, 2019 at 06:29:19PM -0600, David Ahern wrote:
> > On 5/19/19 9:43 AM, Nathan Chancellor wrote:
> > > Hi all,
> > > 
> > > This commit is causing issues on Android devices when Wi-Fi and mobile
> > > data are both enabled. The device will do a soft reboot consistently.
> > > So far, I've had reports on the Pixel 3 XL, OnePlus 6, Pocophone, and
> > > Note 9 and I can reproduce on my OnePlus 6.
> > > 
> > > Sorry for taking so long to report this, I just figured out how to
> > > reproduce it today and I didn't want to report it without that.
> > > 
> > > Attached is a full dmesg and the relevant snippet from Android's logcat.
> > > 
> > > Let me know what I can do to help debug,
> > > Nathan
> > > 
> > 
> > It's a backport problem. err needs to be reset to 0 before the goto.
> 
> Ah, I see it, let me go queue up a fix for this.

Here's the fix I'm queueing up now:


From b42f0ebbe4431ff7ce99c916555418f4a4c2be67 Mon Sep 17 00:00:00 2001
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 20 May 2019 11:07:29 +0200
Subject: [PATCH] fib_rules: fix error in backport of e9919a24d302 ("fib_rules:
 return 0...")

When commit e9919a24d302 ("fib_rules: return 0 directly if an exactly
same rule exists when NLM_F_EXCL not supplied") was backported to 4.9.y,
it changed the logic a bit as err should have been reset before exiting
the test, like it happens in the original logic.

If this is not set, errors happen :(

Reported-by: Nathan Chancellor <natechancellor@gmail.com>
Reported-by: David Ahern <dsahern@gmail.com>
Reported-by: Florian Westphal <fw@strlen.de>
Cc: Hangbin Liu <liuhangbin@gmail.com>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/fib_rules.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/fib_rules.c b/net/core/fib_rules.c
index bb26457e8c21..c03dd2104d33 100644
--- a/net/core/fib_rules.c
+++ b/net/core/fib_rules.c
@@ -430,6 +430,7 @@ int fib_nl_newrule(struct sk_buff *skb, struct nlmsghdr *nlh)
 		goto errout_free;
 
 	if (rule_exists(ops, frh, tb, rule)) {
+		err = 0;
 		if (nlh->nlmsg_flags & NLM_F_EXCL)
 			err = -EEXIST;
 		goto errout_free;
-- 
2.21.0

