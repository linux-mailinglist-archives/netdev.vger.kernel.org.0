Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B835F443AE
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392468AbfFMQbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:31:13 -0400
Received: from www62.your-server.de ([213.133.104.62]:57734 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730888AbfFMI1j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 04:27:39 -0400
Received: from [88.198.220.132] (helo=sslproxy03.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbL53-00021U-3x; Thu, 13 Jun 2019 10:27:33 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hbL52-0006vF-So; Thu, 13 Jun 2019 10:27:32 +0200
Subject: Re: [PATCH net-next] net: sched: ingress: set 'unlocked' flag for
 Qdisc ops
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexei.starovoitov@gmail.com" <alexei.starovoitov@gmail.com>
References: <20190612071435.7367-1-vladbu@mellanox.com>
 <52082ab2-7db8-b047-f42f-a5c69ba9c303@iogearbox.net>
 <vbf4l4u7yme.fsf@mellanox.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <72a3e9e9-e417-d46a-e0b2-b7e684c60b47@iogearbox.net>
Date:   Thu, 13 Jun 2019 10:27:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <vbf4l4u7yme.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25478/Wed Jun 12 10:14:54 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/13/2019 09:06 AM, Vlad Buslov wrote:
> On Wed 12 Jun 2019 at 19:33, Daniel Borkmann <daniel@iogearbox.net> wrote:
>> On 06/12/2019 09:14 AM, Vlad Buslov wrote:
>>> To remove rtnl lock dependency in tc filter update API when using ingress
>>> Qdisc, set QDISC_CLASS_OPS_DOIT_UNLOCKED flag in ingress Qdisc_class_ops.
>>>
>>> Ingress Qdisc ops don't require any modifications to be used without rtnl
>>> lock on tc filter update path. Ingress implementation never changes its
>>> q->block and only releases it when Qdisc is being destroyed. This means it
>>> is enough for RTM_{NEWTFILTER|DELTFILTER|GETTFILTER} message handlers to
>>> hold ingress Qdisc reference while using it without relying on rtnl lock
>>> protection. Unlocked Qdisc ops support is already implemented in filter
>>> update path by unlocked cls API patch set.
>>>
>>> Signed-off-by: Vlad Buslov <vladbu@mellanox.com>
>>> ---
>>>  net/sched/sch_ingress.c | 1 +
>>>  1 file changed, 1 insertion(+)
>>>
>>> diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
>>> index 0f65f617756b..d5382554e281 100644
>>> --- a/net/sched/sch_ingress.c
>>> +++ b/net/sched/sch_ingress.c
>>> @@ -114,6 +114,7 @@ static int ingress_dump(struct Qdisc *sch, struct sk_buff *skb)
>>>  }
>>>
>>>  static const struct Qdisc_class_ops ingress_class_ops = {
>>> +	.flags		=	QDISC_CLASS_OPS_DOIT_UNLOCKED,
>>>  	.leaf		=	ingress_leaf,
>>>  	.find		=	ingress_find,
>>>  	.walk		=	ingress_walk,
>>>
>>
>> Vlad, why is clsact_class_ops not updated here? Please elaborate!
> 
> Daniel, no particular reason to not enable unlocked execution for
> clsact. I set the unlocked flag for ingress because that was the Qdisc
> that I tested all my parallel tc changes on. However, ingress and clsact
> implementations are quite similar, so I can send a followup patch that
> updates clsact_class_ops, if you want.

Yes, please do, they are pretty much the same except that clsact supersedes
ingress in that it also offers an egress hook.
