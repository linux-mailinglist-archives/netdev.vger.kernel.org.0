Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0181D2CB740
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 09:33:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387724AbgLBIct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 03:32:49 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15832 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726961AbgLBIcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 03:32:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc751080001>; Wed, 02 Dec 2020 00:32:08 -0800
Received: from reg-r-vrt-018-180.nvidia.com (10.124.1.5) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Wed, 2 Dec 2020 08:32:06 +0000
References: <20201127151205.23492-1-vladbu@nvidia.com> <20201130185222.6b24ed42@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <ygnh4kl6klja.fsf@nvidia.com> <20201201090331.469dd407@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com> <ygnh1rg9l6az.fsf@nvidia.com> <20201201112444.1d25d9c6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>
Subject: Re: [PATCH net-next] net: sched: remove redundant 'rtnl_held' argument
In-Reply-To: <20201201112444.1d25d9c6@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Wed, 2 Dec 2020 10:32:03 +0200
Message-ID: <ygnhy2igk3r0.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606897928; bh=p1OUljy39pPqG+iXbveBnch+ivIraXSNoqFfEUql3Nw=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=K3+XbPHP7JRn5HR+QglxWfDgG1SYy3OtQaatvZ1FS7VePZ/D3j+6/pfYDPYejYJZz
         /QbUsuTIoTMhM+p6D5yAmtESJ6bdwNo3MPxOw/ZhinA7JAa2PrXoIHQlRYfAnrt4el
         9PRfkiNDvMZX8I7uGfa144FZAlVSKckJZO5f4nJk67TJTlHrRexfrwepN8Xi1QVIcD
         8Pd4gevCfApGGydn0gZQa11ICvCylMX7ClGwQKHdGh/tzCOkkhO0ZEphIupFOnlCd6
         qHwC5O/QmXChJy95395dhctJSNlWgsG501UqAtTjEbLLnQwGMlkiJwQMqeie42Dqaz
         PgacTKnCEr8sA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 01 Dec 2020 at 21:24, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 1 Dec 2020 20:39:16 +0200 Vlad Buslov wrote:
>> On Tue 01 Dec 2020 at 19:03, Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Tue, 1 Dec 2020 09:55:37 +0200 Vlad Buslov wrote:  
>> >> On Tue 01 Dec 2020 at 04:52, Jakub Kicinski <kuba@kernel.org> wrote:  
>> >> > On Fri, 27 Nov 2020 17:12:05 +0200 Vlad Buslov wrote:    
>> >> >> @@ -2262,7 +2260,7 @@ static int tc_del_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
>> >> >>  
>> >> >>  	if (prio == 0) {
>> >> >>  		tfilter_notify_chain(net, skb, block, q, parent, n,
>> >> >> -				     chain, RTM_DELTFILTER, rtnl_held);
>> >> >> +				     chain, RTM_DELTFILTER);
>> >> >>  		tcf_chain_flush(chain, rtnl_held);
>> >> >>  		err = 0;
>> >> >>  		goto errout;    
>> >> >
>> >> > Hum. This looks off.    
>> >> 
>> >> Hi Jakub,
>> >> 
>> >> Prio==0 means user requests to flush whole chain. In such case rtnl lock
>> >> is obtained earlier in tc_del_tfilter():
>> >> 
>> >> 	/* Take rtnl mutex if flushing whole chain, block is shared (no qdisc
>> >> 	 * found), qdisc is not unlocked, classifier type is not specified,
>> >> 	 * classifier is not unlocked.
>> >> 	 */
>> >> 	if (!prio ||
>> >> 	    (q && !(q->ops->cl_ops->flags & QDISC_CLASS_OPS_DOIT_UNLOCKED)) ||
>> >> 	    !tcf_proto_is_unlocked(name)) {
>> >> 		rtnl_held = true;
>> >> 		rtnl_lock();
>> >> 	}
>> >>   
>> >
>> > Makes sense, although seems a little fragile. Why not put a true in
>> > there, in that case?  
>> 
>> Because, as I described in commit message, the function will trigger an
>> assertion if called without rtnl lock, so passing rtnl_held==false
>> argument makes no sense and is confusing for the reader.
>
> The assumption being that tcf_ functions without the arg must hold the
> lock?

Yes.

>
>> > Do you have a larger plan here? The motivation seems a little unclear
>> > if I'm completely honest. Are you dropping the rtnl_held from all callers 
>> > of __tcf_get_next_proto() just to save the extra argument / typing?  
>> 
>> The plan is to have 'rtnl_held' arg for functions that can be called
>> without rtnl lock and not have such argument for functions that require
>> caller to hold rtnl :)
>> 
>> To elaborate further regarding motivation for this patch: some time ago
>> I received an email asking why I have rtnl_held arg in function that has
>> ASSERT_RTNL() in one of its dependencies. I re-read the code and
>> determined that it was a leftover from earlier version and is not needed
>> in code that was eventually upstreamed. Removing the argument was an
>> easy decision since Jiri hates those and repeatedly asked me to minimize
>> usage of such function arguments, so I didn't expect it to be
>> controversial.
>> 
>> > That's nice but there's also value in the API being consistent.  
>> 
>> Cls_api has multiple functions that don't have 'rtnl_held' argument.
>> Only functions that can work without rtnl lock have it. Why do you
>> suggest it is inconsistent to remove it here?
>
> I see. I was just trying to figure out if you have a plan for larger
> restructuring to improve the situation. I also dislike to arguments
> being passed around in a seemingly random fashion. Removing or adding
> them to a single function does not move the needle much, IMO.

No, this is not part of larger effort. I would like to stop passing
'rtnl_held' everywhere, but for that I need other drivers that implement
TC offload to stop requiring rtnl lock, which would allow removing
rtnl_held from tcf_proto_ops callbacks.

>
> But since the patch is correct I'll apply it now, thanks!

Thank you!

