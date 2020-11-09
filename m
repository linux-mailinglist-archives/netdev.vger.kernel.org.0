Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1AB2AC036
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 16:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbgKIPrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 10:47:51 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:15656 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729650AbgKIPrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 10:47:51 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fa964ad0000>; Mon, 09 Nov 2020 07:47:57 -0800
Received: from reg-r-vrt-018-180.nvidia.com (172.20.13.39) by
 HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3; Mon, 9 Nov 2020 15:47:49 +0000
References: <1604791828-7431-1-git-send-email-wenxu@ucloud.cn> <1604791828-7431-4-git-send-email-wenxu@ucloud.cn> <ygnhimaewtm2.fsf@nvidia.com> <20201109145025.GB3913@localhost.localdomain>
User-agent: mu4e 1.4.12; emacs 26.2.90
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
CC:     <wenxu@ucloud.cn>, <kuba@kernel.org>, <dcaratti@redhat.com>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 net-next 3/3] net/sched: act_frag: add implict packet fragment support.
In-Reply-To: <20201109145025.GB3913@localhost.localdomain>
Date:   Mon, 9 Nov 2020 17:47:46 +0200
Message-ID: <ygnhft5iwmzh.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1604936877; bh=+SingTpQZ6JUuadDqw8l0u7aR/JiQtyKduX8ZVydBa4=;
        h=References:User-agent:From:To:CC:Subject:In-Reply-To:Date:
         Message-ID:MIME-Version:Content-Type:X-Originating-IP:
         X-ClientProxiedBy;
        b=dIFx6meGGukjpShFBc5NEvaS7NuVvdPiVSPvaQI3YBOWqprn95mfGr+YiKaUxq+f+
         oqOTBk5HX1CAW4D3unvAjN3f6DI7dT1n2HzlSKl4s/yJwAmPBcNG5R+RgTb/2l32Sb
         2IXbjGmUxfyQd8TIvg+KQOrPSl68hWq8Q+scVCMO6PGCvu0CAg0tH7xCcycGzHp+k2
         9zMTdPGR1mI3sN0Kuz3ER2KHmfT4xgk8Z2ZdKUAWLK0I0p+eCfoya44NoSXTE/YxEt
         eNiUF4kv7CKb2vkOPFKT3vz+h5EhGFffucwxPM7MXM004LNlFWVT+CBc2C5itbvH29
         qoJsamj6ZbH6Q==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Mon 09 Nov 2020 at 16:50, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> On Mon, Nov 09, 2020 at 03:24:37PM +0200, Vlad Buslov wrote:
>> On Sun 08 Nov 2020 at 01:30, wenxu@ucloud.cn wrote:
> ...
>> > @@ -974,9 +974,22 @@ config NET_ACT_TUNNEL_KEY
>> >  	  To compile this code as a module, choose M here: the
>> >  	  module will be called act_tunnel_key.
>> >  
>> > +config NET_ACT_FRAG
>> > +	tristate "Packet fragmentation"
>> > +	depends on NET_CLS_ACT
>> > +	help
>> > +         Say Y here to allow fragmenting big packets when outputting
>> > +         with the mirred action.
>> > +
>> > +	  If unsure, say N.
>> > +
>> > +	  To compile this code as a module, choose M here: the
>> > +	  module will be called act_frag.
>> > +
>> 
>> Just wondering, what is the motivation for putting the frag code into
>> standalone module? It doesn't implement usual act_* interface and is not
>> user-configurable. To me it looks like functionality that belongs to
>> act_api. Am I missing something?
>
> It's the way we found so far for not "polluting" mirred/tc with L3
> functionality, per Cong's feedbacks on previous attempts. As for why
> not act_api, this is not some code that other actions can just re-use
> and that file is already quite big, so I thought act_frag would be
> better to keep it isolated/contained.

Hmmm okay.

>
> If act_frag is confusing, then maybe act_mirred_frag? It is a mirred
> plugin now, after all.

Would be even more confusing to me since the act_frag module code is
only directly accessed from act_ct and not act_mirred :)

Anyway, I don't have a strong opinion regarding this. Just wanted to
understand the motivation.

>
> ...
>> > +int tcf_set_xmit_hook(int (*xmit_hook)(struct sk_buff *skb,
>> > +				       int (*xmit)(struct sk_buff *skb)))
>> > +{
>> > +	if (!tcf_xmit_hook_enabled())
>> > +		xchg(&tcf_xmit_hook, xmit_hook);
>> 
>> Marcelo, why did you suggest to use atomic operations to change
>> tcf_xmit_hook variable? It is not obvious to me after reading the code.
>
> I thought as a minimal way to not have problems on module removal, but
> your comment below proves it is not right/enough. :-)
>
>> 
>> > +	else if (xmit_hook != tcf_xmit_hook)
>> > +		return -EBUSY;
>> > +
>> > +	tcf_inc_xmit_hook();
>> > +
>> > +	return 0;
>> > +}
>> > +EXPORT_SYMBOL_GPL(tcf_set_xmit_hook);
>> > +
>> > +void tcf_clear_xmit_hook(void)
>> > +{
>> > +	tcf_dec_xmit_hook();
>> > +
>> > +	if (!tcf_xmit_hook_enabled())
>> > +		xchg(&tcf_xmit_hook, NULL);
>> > +}
>> > +EXPORT_SYMBOL_GPL(tcf_clear_xmit_hook);
>> > +
>> > +int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
>> > +{
>> > +	if (tcf_xmit_hook_enabled())
>> 
>> Okay, so what happens here if tcf_xmit_hook is disabled concurrently? If
>> we get here from some rule that doesn't involve act_ct but uses
>> act_mirred and act_ct is concurrently removed decrementing last
>> reference to static branch and setting tcf_xmit_hook to NULL?
>
> Yeah.. good point. Thinking further now, what about using RCU for the
> hook? AFAICT it can cover the synchronization needed when clearing the
> pointer, tcf_set_xmit_hook() should do a module_get() and
> tcf_clear_xmit_hook() can delay a module_put(act_frag) as needed with
> call_rcu.

Wouldn't it be enough to just call synchronize_rcu() in
tcf_clear_xmit_hook() after setting tcf_xmit_hook to NULL? act_ct module
removal should be very rare, so synchronously waiting for rcu grace
period to complete is probably okay.

>
> I see tcf_mirred_act is already calling rcu_dereference_bh(), so
> it's already protected by rcu read here and calling tcf_xmit_hook()
> with xmit pointer should be fine. WDYT?

Yes, good idea.

>
>> 
>> > +		return tcf_xmit_hook(skb, xmit);
>> > +	else
>> > +		return xmit(skb);
>> > +}
>> > +EXPORT_SYMBOL_GPL(tcf_dev_queue_xmit);

