Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C799C2B8E98
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 10:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgKSJT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 04:19:56 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8116 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725915AbgKSJT4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 04:19:56 -0500
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CcDdx2ycZzLlfP;
        Thu, 19 Nov 2020 17:19:33 +0800 (CST)
Received: from [10.74.191.121] (10.74.191.121) by
 DGGEMS411-HUB.china.huawei.com (10.3.19.211) with Microsoft SMTP Server id
 14.3.487.0; Thu, 19 Nov 2020 17:19:44 +0800
Subject: Re: [PATCH net-next] net: add in_softirq() debug checking in
 napi_consume_skb()
To:     Jakub Kicinski <kuba@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
CC:     <davem@davemloft.net>, <linmiaohe@huawei.com>,
        <martin.varghese@nokia.com>, <pabeni@redhat.com>,
        <pshelar@ovn.org>, <fw@strlen.de>, <gnault@redhat.com>,
        <steffen.klassert@secunet.com>, <kyk.segfault@gmail.com>,
        <viro@zeniv.linux.org.uk>, <vladimir.oltean@nxp.com>,
        <edumazet@google.com>, <saeed@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1603971288-4786-1-git-send-email-linyunsheng@huawei.com>
 <20201031153824.7ae83b90@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5b04ad33-1611-8d7b-8fec-4269c01ecab3@huawei.com>
 <20201102114110.4a20d461@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <5bd6de52-b8e0-db6f-3362-862ae7b2c728@huawei.com>
 <20201118074348.3bbd1468@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201118155757.GY3121392@hirez.programming.kicks-ass.net>
 <20201118082658.2aa41190@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   Yunsheng Lin <linyunsheng@huawei.com>
Message-ID: <b00f1c28-668c-ecdb-6aa7-282e57475e25@huawei.com>
Date:   Thu, 19 Nov 2020 17:19:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
In-Reply-To: <20201118082658.2aa41190@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.74.191.121]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/11/19 0:26, Jakub Kicinski wrote:
> On Wed, 18 Nov 2020 16:57:57 +0100 Peter Zijlstra wrote:
>> On Wed, Nov 18, 2020 at 07:43:48AM -0800, Jakub Kicinski wrote:
>>
>>> TBH the last sentence I wrote isn't clear even to me at this point ;D
>>>
>>> Maybe using just the macros from preempt.h - like this?
>>>
>>> #define lockdep_assert_in_softirq()                                    \
>>> do {                                                                   \
>>>        WARN_ON_ONCE(__lockdep_enabled                  &&              \
>>>                     (!in_softirq() || in_irq() || in_nmi())	\
>>> } while (0)

One thing I am not so sure about is the different irq context indicator
in preempt.h and lockdep.h, for example lockdep_assert_in_irq() uses
this_cpu_read(hardirq_context) in lockdep.h, and in_irq() uses
current_thread_info()->preempt_count in preempt.h, if they are the same
thing?

>>>
>>> We know what we're doing so in_softirq() should be fine (famous last
>>> words).  
>>
>> So that's not actually using any lockdep state. But if that's what you
>> need, I don't have any real complaints.
> 
> Great, thanks! 
> 
> The motivation was to piggy back on lockdep rather than adding a
> one-off Kconfig knob for a check in the fast path in networking.
> .
> 
