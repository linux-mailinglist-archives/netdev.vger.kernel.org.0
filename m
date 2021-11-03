Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCFE44441E
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 15:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbhKCPCO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 11:02:14 -0400
Received: from www62.your-server.de ([213.133.104.62]:36724 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231304AbhKCPCN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 11:02:13 -0400
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1miHjk-000EH6-Kv; Wed, 03 Nov 2021 15:59:36 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1miHjk-000GTT-GA; Wed, 03 Nov 2021 15:59:36 +0100
Subject: Re: [PATCH v2] net: sched: check tc_skip_classify as far as possible
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        xiangxia.m.yue@gmail.com
Cc:     netdev@vger.kernel.org, Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
References: <20211103143208.41282-1-xiangxia.m.yue@gmail.com>
 <CA+FuTSftumQMYg8fcCW3C-A0CKZC=6GYDrR3UXjaS1gNJx=5TA@mail.gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <b0c3fa7e-2e00-b4fd-d31a-54e7173be12a@iogearbox.net>
Date:   Wed, 3 Nov 2021 15:59:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <CA+FuTSftumQMYg8fcCW3C-A0CKZC=6GYDrR3UXjaS1gNJx=5TA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26342/Wed Nov  3 09:22:37 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/21 3:47 PM, Willem de Bruijn wrote:
> On Wed, Nov 3, 2021 at 10:32 AM <xiangxia.m.yue@gmail.com> wrote:
>>
>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>
>> We look up and then check tc_skip_classify flag in net
>> sched layer, even though skb don't want to be classified.
>> That case may consume a lot of cpu cycles.
>>
>> Install the rules as below:
>> $ for id in $(seq 1 100); do
>> $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
>> $ done
>>
>> netperf:
>> $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
>> $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
>>
>> Before: 10662.33 tps, 108.95 Mbit/s
>> After:  12434.48 tps, 145.89 Mbit/s
>>
>> For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.
>>
>> Cc: Willem de Bruijn <willemb@google.com>
>> Cc: Cong Wang <xiyou.wangcong@gmail.com>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>> ---
>> v2: don't delete skb_skip_tc_classify in act_api
>> ---
>>   net/core/dev.c | 3 +++
>>   1 file changed, 3 insertions(+)
>>
>> diff --git a/net/core/dev.c b/net/core/dev.c
>> index edeb811c454e..fc29a429e9ad 100644
>> --- a/net/core/dev.c
>> +++ b/net/core/dev.c
>> @@ -3940,6 +3940,9 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
>>          if (!miniq)
>>                  return skb;
>>
>> +       if (skb_skip_tc_classify(skb))
>> +               return skb;
>> +
> 
> This bit and test exist to make sure that packets redirected through
> the ifb device are redirected only once.
> 
> I was afraid that on second loop, this will also short-circuit other
> unrelated tc classifiers and actions that should take place.
> 
> The name and the variable comment make clear that the intention is
> indeed to bypass all classification.
> 
> However, the current implementation acts at tcf_action_exec. So it
> does not stop processing by fused classifier-action objects, notably tc_bpf.
> 
> So I agree both that this seems to follow the original intent, but also
> has the chance to break existing production configurations.

Agree, I share your concern.
