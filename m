Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87E72F0CB
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 08:59:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726379AbfD3G6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 02:58:15 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:52570 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbfD3G6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 02:58:15 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hLMiS-00042s-2W; Tue, 30 Apr 2019 08:58:12 +0200
Message-ID: <e86c0165d9c6966eaa2f653674ab16485b20da47.camel@sipsolutions.net>
Subject: Re: [PATCH] netlink: limit recursion depth in policy validation
From:   Johannes Berg <johannes@sipsolutions.net>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Date:   Tue, 30 Apr 2019 08:58:10 +0200
In-Reply-To: <20190429.230803.275536802508174338.davem@davemloft.net>
References: <20190426121346.11005-1-johannes@sipsolutions.net>
         <20190429.230803.275536802508174338.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-04-29 at 23:08 -0400, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Fri, 26 Apr 2019 14:13:46 +0200
> 
> > From: Johannes Berg <johannes.berg@intel.com>
> > 
> > Now that we have nested policies, we can theoretically
> > recurse forever parsing attributes if a (sub-)policy
> > refers back to a higher level one. This is a situation
> > that has happened in nl80211, and we've avoided it there
> > by not linking it.
> > 
> > Add some code to netlink parsing to limit recursion depth,
> > allowing us to safely change nl80211 to actually link the
> > nested policy, which in turn allows some code cleanups.
> > 
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> This doesn't apply cleanly to 'net', is there some dependency I am
> unaware of or is this because of a recent mac80211 pull into my tree?

Sorry, I should've made it clear that this applies on top of the
patchset to expose netlink policies to userspace; due to all the
overlaping changes in lib/nlattr.c that seemed like the best solution to
me.

There's no real need to have this safeguard right now in net as nothing
there actually specifies a recursive policy (I knew about this issue and
explicitly made nl80211 *not* have a recursive policy as you can see in
this patch changing that), so I figured net-next was fine.

I'll rebase this on net-next along with the policy export (fixing the
full signed range thing) and resend as a combined set to clarify the
dependencies.

If you prefer to have the safeguard in net even if it shouldn't be
needed now, let me know and I'll make a version that applies there, but
note that will invariably cause conflicts with all the other changes in
lib/nlattr.c.

johannes

