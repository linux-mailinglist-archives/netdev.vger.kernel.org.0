Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC52C2CAC36
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 20:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404319AbgLATZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 14:25:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392425AbgLATZ1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 14:25:27 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F406B20758;
        Tue,  1 Dec 2020 19:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606850686;
        bh=ZdoR9s+ZGnQ9VRclKLxc6RfErJajK93WtnvbQMGKya8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bqCtU4yT+ogRm1KD72BLEvPPNQZYJgIQmyf2eCQP25CE6AgVU8zLds4vHdXcfNdXY
         h+kGWiy0yqaAxnJ516Iu2/IdRsM2+mgKRisIn/Q3XjXekGeYPSaTuBGjvqt+FI/zMs
         Kx1UMu99QLcu/YCP8uvRWdF3w+7FtRosoAJjfTns=
Date:   Tue, 1 Dec 2020 11:24:44 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next] net: sched: remove redundant 'rtnl_held'
 argument
Message-ID: <20201201112444.1d25d9c6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <ygnh1rg9l6az.fsf@nvidia.com>
References: <20201127151205.23492-1-vladbu@nvidia.com>
        <20201130185222.6b24ed42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <ygnh4kl6klja.fsf@nvidia.com>
        <20201201090331.469dd407@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <ygnh1rg9l6az.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 20:39:16 +0200 Vlad Buslov wrote:
> On Tue 01 Dec 2020 at 19:03, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Tue, 1 Dec 2020 09:55:37 +0200 Vlad Buslov wrote:  
> >> On Tue 01 Dec 2020 at 04:52, Jakub Kicinski <kuba@kernel.org> wrote:  
> >> > On Fri, 27 Nov 2020 17:12:05 +0200 Vlad Buslov wrote:    
> >> >> @@ -2262,7 +2260,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
> >> >>  
> >> >>  	if (prio == 0) {
> >> >>  		tfilter_notify_chain(net, skb, block, q, parent, n,
> >> >> -				     chain, RTM_DELTFILTER, rtnl_held);
> >> >> +				     chain, RTM_DELTFILTER);
> >> >>  		tcf_chain_flush(chain, rtnl_held);
> >> >>  		err = 0;
> >> >>  		goto errout;    
> >> >
> >> > Hum. This looks off.    
> >> 
> >> Hi Jakub,
> >> 
> >> Prio==0 means user requests to flush whole chain. In such case rtnl lock
> >> is obtained earlier in tc_del_tfilter():
> >> 
> >> 	/* Take rtnl mutex if flushing whole chain, block is shared (no qdisc
> >> 	 * found), qdisc is not unlocked, classifier type is not specified,
> >> 	 * classifier is not unlocked.
> >> 	 */
> >> 	if (!prio ||
> >> 	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
> >> 	    !tcf_proto_is_unlocked(name)) {
> >> 		rtnl_held = true;
> >> 		rtnl_lock();
> >> 	}
> >>   
> >
> > Makes sense, although seems a little fragile. Why not put a true in
> > there, in that case?  
> 
> Because, as I described in commit message, the function will trigger an
> assertion if called without rtnl lock, so passing rtnl_held==false
> argument makes no sense and is confusing for the reader.

The assumption being that tcf_ functions without the arg must hold the
lock?

> > Do you have a larger plan here? The motivation seems a little unclear
> > if I'm completely honest. Are you dropping the rtnl_held from all callers 
> > of __tcf_get_next_proto() just to save the extra argument / typing?  
> 
> The plan is to have 'rtnl_held' arg for functions that can be called
> without rtnl lock and not have such argument for functions that require
> caller to hold rtnl :)
> 
> To elaborate further regarding motivation for this patch: some time ago
> I received an email asking why I have rtnl_held arg in function that has
> ASSERT_RTNL() in one of its dependencies. I re-read the code and
> determined that it was a leftover from earlier version and is not needed
> in code that was eventually upstreamed. Removing the argument was an
> easy decision since Jiri hates those and repeatedly asked me to minimize
> usage of such function arguments, so I didn't expect it to be
> controversial.
> 
> > That's nice but there's also value in the API being consistent.  
> 
> Cls_api has multiple functions that don't have 'rtnl_held' argument.
> Only functions that can work without rtnl lock have it. Why do you
> suggest it is inconsistent to remove it here?

I see. I was just trying to figure out if you have a plan for larger
restructuring to improve the situation. I also dislike to arguments
being passed around in a seemingly random fashion. Removing or adding
them to a single function does not move the needle much, IMO.

But since the patch is correct I'll apply it now, thanks!
