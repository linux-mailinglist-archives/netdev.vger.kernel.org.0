Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5299D21020F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 04:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgGAC25 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 22:28:57 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:51869 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgGAC24 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 22:28:56 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 6C11E41D25;
        Wed,  1 Jul 2020 10:27:56 +0800 (CST)
Subject: Re: [PATCH net] net/sched: act_mirred: fix fragment the packet after
 defrag in act_ct
To:     Eric Dumazet <eric.dumazet@gmail.com>, paulb@mellanox.com
Cc:     netdev@vger.kernel.org
References: <1593485646-14989-1-git-send-email-wenxu@ucloud.cn>
 <b01df9df-4b46-ea62-9591-66c720a2a4ab@gmail.com>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <09f485dd-79ab-9978-e28a-703c9af318c2@ucloud.cn>
Date:   Wed, 1 Jul 2020 10:27:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <b01df9df-4b46-ea62-9591-66c720a2a4ab@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSUlDS0tLS09PQ0lJTUJZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXMjULOBw*I0wBDghCKw8eLy8OSjocVlZVTUhOSkIoSVlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PRQ6DRw5NTg4TiwCEgoiDU8R
        QhAaCy9VSlVKTkJITkxLT0xMS0tIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJQkxCNwY+
X-HM-Tid: 0a730833c25a2086kuqy6c11e41d25
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/30/2020 11:57 PM, Eric Dumazet wrote:
>
> On 6/29/20 7:54 PM, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> The fragment packets do defrag in act_ct module. The reassembled packet
>> over the mtu in the act_mirred. This big packet should be fragmented
>> to send out.
>>
>> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>> This patch is based on
>> http://patchwork.ozlabs.org/project/netdev/patch/1593422178-26949-1-git-send-email-wenxu@ucloud.cn/
>>
>>  include/net/sch_generic.h |   6 +-
>>  net/sched/act_ct.c        |   7 ++-
>>  net/sched/act_mirred.c    | 157 ++++++++++++++++++++++++++++++++++++++++++++--
>>  3 files changed, 158 insertions(+), 12 deletions(-)
>>
>> diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
>> index c510b03..3597244 100644
>> --- a/include/net/sch_generic.h
>> +++ b/include/net/sch_generic.h
>> @@ -384,6 +384,7 @@ struct qdisc_skb_cb {
>>  	};
>>  #define QDISC_CB_PRIV_LEN 20
>>  	unsigned char		data[QDISC_CB_PRIV_LEN];
>> +	u16			mru;
>>  };
>>
>
> Wow, this change is potentially a big problem.
>
> Explain why act_ct/act_mirred need to pollute qdisc_skb_cb 

Hi Eric,

In the act_ct the fragment packets will defrag to a big packet and do conntrack things.

But in the latter filter mirred action, the big packet normally send over the mtu of outgoing device.

In this case the packet should be fragment to send And the frag size should based on origin frag size

recored in act_ct.  In the act_ct the frag size should retore in qdisc_skb_cb and act_mirred get it to do fragment.


So there are any other good method?


BR

wenxu 

>
>
>
