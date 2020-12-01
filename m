Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268EC2CA946
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 18:05:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392101AbgLAREN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 12:04:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:44988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392064AbgLAREN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Dec 2020 12:04:13 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35C70206B7;
        Tue,  1 Dec 2020 17:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606842212;
        bh=JTGI0nZdjXxAlArUZ44TztiPtAywd73FfBis+NM9wGc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GpMeHflUX9mpZ7C6m/i5ioE2J5ttgVFuH/TBYcS6a2TtNOYF9F7Yf24xd37WkXhZj
         TWc1Pamh54wiL1fcJklRV8zEtggHY0O1s+z16cnGNbGGLAwsY5HLvPzzmkKFieypog
         GseLqx7vFJwkLsa/zith5v7lRAGjohlBscOu9VVQ=
Date:   Tue, 1 Dec 2020 09:03:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next] net: sched: remove redundant 'rtnl_held'
 argument
Message-ID: <20201201090331.469dd407@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <ygnh4kl6klja.fsf@nvidia.com>
References: <20201127151205.23492-1-vladbu@nvidia.com>
        <20201130185222.6b24ed42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <ygnh4kl6klja.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Dec 2020 09:55:37 +0200 Vlad Buslov wrote:
> On Tue 01 Dec 2020 at 04:52, Jakub Kicinski <kuba@kernel.org> wrote:
> > On Fri, 27 Nov 2020 17:12:05 +0200 Vlad Buslov wrote:  
> >> @@ -2262,7 +2260,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
> >>  
> >>  	if (prio == 0) {
> >>  		tfilter_notify_chain(net, skb, block, q, parent, n,
> >> -				     chain, RTM_DELTFILTER, rtnl_held);
> >> +				     chain, RTM_DELTFILTER);
> >>  		tcf_chain_flush(chain, rtnl_held);
> >>  		err = 0;
> >>  		goto errout;  
> >
> > Hum. This looks off.  
> 
> Hi Jakub,
> 
> Prio==0 means user requests to flush whole chain. In such case rtnl lock
> is obtained earlier in tc_del_tfilter():
> 
> 	/* Take rtnl mutex if flushing whole chain, block is shared (no qdisc
> 	 * found), qdisc is not unlocked, classifier type is not specified,
> 	 * classifier is not unlocked.
> 	 */
> 	if (!prio ||
> 	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
> 	    !tcf_proto_is_unlocked(name)) {
> 		rtnl_held = true;
> 		rtnl_lock();
> 	}
> 

Makes sense, although seems a little fragile. Why not put a true in
there, in that case?

Do you have a larger plan here? The motivation seems a little unclear
if I'm completely honest. Are you dropping the rtnl_held from all callers 
of __tcf_get_next_proto() just to save the extra argument / typing?
That's nice but there's also value in the API being consistent.
