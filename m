Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E121C2CAAEB
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 19:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392271AbgLASkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 13:40:01 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:9764 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388802AbgLASkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 13:40:00 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc68dd80000>; Tue, 01 Dec 2020 10:39:20 -0800
Received: from reg-r-vrt-018-180.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Tue, 1 Dec 2020 18:39:18 +0000
References: <20201127151205.23492-1-vladbu@nvidia.com> <20201130185222.6b24ed42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <ygnh4kl6klja.fsf@nvidia.com> <20201201090331.469dd407@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next] net: sched: remove redundant 'rtnl_held' argument
In-Reply-To: <20201201090331.469dd407@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Tue, 1 Dec 2020 20:39:16 +0200
Message-ID: <ygnh1rg9l6az.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606847960; bh=L4RutL184GlIBp15dmR05c376rHR1sw0LHAfgprZrqY=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=PUPR6JK73DzXUxr/VODXStgRC55nsFnczywogSMi64YGhbnDEf0g5PhttmdGU21zz
         lkolvIXXXymn37CphPVb9Bwv3+Zchw9jDsZ9e6GH/dWLpyXm6qnQ5asuE8TdFsh+ON
         a9Bog19GVmtVU4ulL2zOiTo0/92/Gp6YGmXocz4ZKNtpWTJYHyagpzzPZHt1jHZXxM
         YKN2sBaqhENDi7H+IXJgXHdHjPDwQun9n5LlUFadpyRLzCYdaLaW8srimWcIJWHSxj
         1N13PLJvEUyir/RmnlR1vLnb8wU1/WdAtYsjH8o+U7oocAx9o9xGy3KRBFeclSJXsX
         WuMD4rOAOgzmw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 01 Dec 2020 at 19:03, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 1 Dec 2020 09:55:37 +0200 Vlad Buslov wrote:
>> On Tue 01 Dec 2020 at 04:52, Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Fri, 27 Nov 2020 17:12:05 +0200 Vlad Buslov wrote:  
>> >> @@ -2262,7 +2260,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>> >>  
>> >>  	if (prio == 0) {
>> >>  		tfilter_notify_chain(net, skb, block, q, parent, n,
>> >> -				     chain, RTM_DELTFILTER, rtnl_held);
>> >> +				     chain, RTM_DELTFILTER);
>> >>  		tcf_chain_flush(chain, rtnl_held);
>> >>  		err = 0;
>> >>  		goto errout;  
>> >
>> > Hum. This looks off.  
>> 
>> Hi Jakub,
>> 
>> Prio==0 means user requests to flush whole chain. In such case rtnl lock
>> is obtained earlier in tc_del_tfilter():
>> 
>> 	/* Take rtnl mutex if flushing whole chain, block is shared (no qdisc
>> 	 * found), qdisc is not unlocked, classifier type is not specified,
>> 	 * classifier is not unlocked.
>> 	 */
>> 	if (!prio ||
>> 	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
>> 	    !tcf_proto_is_unlocked(name)) {
>> 		rtnl_held = true;
>> 		rtnl_lock();
>> 	}
>> 
>
> Makes sense, although seems a little fragile. Why not put a true in
> there, in that case?

Because, as I described in commit message, the function will trigger an
assertion if called without rtnl lock, so passing rtnl_held==false
argument makes no sense and is confusing for the reader.

>
> Do you have a larger plan here? The motivation seems a little unclear
> if I'm completely honest. Are you dropping the rtnl_held from all callers 
> of __tcf_get_next_proto() just to save the extra argument / typing?

The plan is to have 'rtnl_held' arg for functions that can be called
without rtnl lock and not have such argument for functions that require
caller to hold rtnl :)

To elaborate further regarding motivation for this patch: some time ago
I received an email asking why I have rtnl_held arg in function that has
ASSERT_RTNL() in one of its dependencies. I re-read the code and
determined that it was a leftover from earlier version and is not needed
in code that was eventually upstreamed. Removing the argument was an
easy decision since Jiri hates those and repeatedly asked me to minimize
usage of such function arguments, so I didn't expect it to be
controversial.

> That's nice but there's also value in the API being consistent.

Cls_api has multiple functions that don't have 'rtnl_held' argument.
Only functions that can work without rtnl lock have it. Why do you
suggest it is inconsistent to remove it here?

