Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D785D5BED
	for <lists+netdev@lfdr.de>; Mon, 14 Oct 2019 09:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbfJNHI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Oct 2019 03:08:27 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:39568 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730275AbfJNHI1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Oct 2019 03:08:27 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R311e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07417;MF=zhiyuan2048@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0Tez4T-K_1571036879;
Received: from houzhiyuandeMacBook-Pro.local(mailfrom:zhiyuan2048@linux.alibaba.com fp:SMTPD_---0Tez4T-K_1571036879)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 14 Oct 2019 15:08:13 +0800
Subject: Re: [PATCH net] net: sched: act_mirred: drop skb's dst_entry in
 ingress redirection
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
 <2d816fb6-befb-aaeb-328b-539507022a22@gmail.com>
From:   Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
Message-ID: <31b4e85e-bdf8-6462-dc79-06ff8d98b6cf@linux.alibaba.com>
Date:   Mon, 14 Oct 2019 15:07:59 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <2d816fb6-befb-aaeb-328b-539507022a22@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/12 6:59 下午, Eric Dumazet wrote:
>
> On 10/12/19 12:16 AM, Zhiyuan Hou wrote:
>> In act_mirred's ingress redirection, if the skb's dst_entry is valid
>> when call function netif_receive_skb, the fllowing l3 stack process
>> (ip_rcv_finish_core) will check dst_entry and skip the routing
>> decision. Using the old dst_entry is unexpected and may discard the
>> skb in some case. For example dst->dst_input points to dst_discard.
>>
>> This patch drops the skb's dst_entry before calling netif_receive_skb
>> so that the skb can be made routing decision like a normal ingress
>> skb.
>>
>> Signed-off-by: Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
>> ---
>>   net/sched/act_mirred.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
>> index 9ce073a05414..6108a64c0cd5 100644
>> --- a/net/sched/act_mirred.c
>> +++ b/net/sched/act_mirred.c
>> @@ -18,6 +18,7 @@
>>   #include <linux/gfp.h>
>>   #include <linux/if_arp.h>
>>   #include <net/net_namespace.h>
>> +#include <net/dst.h>
>>   #include <net/netlink.h>
>>   #include <net/pkt_sched.h>
>>   #include <net/pkt_cls.h>
>> @@ -298,8 +299,10 @@ static int tcf_mirred_act(struct sk_buff *skb, const struct tc_action *a,
>>   
>>   	if (!want_ingress)
>>   		err = dev_queue_xmit(skb2);
>> -	else
>> +	else {
>> +		skb_dst_drop(skb2);
>>   		err = netif_receive_skb(skb2);
>> +	}
>>   
>>   	if (err) {
>>   out:
>>
> Why is dst_discard used ?
When send a skb from local to external, the dst->dst_input will be
assigned dst_discard after routing decision. So if we redirect these
skbs to ingress stack, it will be dropped.

For ipvlan l2 mode or macvlan, clsact egress filters on master deivce
may also meet these skbs even if they came from slave device. Ingress
redirection on these skbs may drop them on l3 stack.
> This could actually drop packets, for loopback.
>
> A Fixes: tag would tremendously help, I wonder if you are not working around
> the other issue Wei was tracking yesterday ( https://www.spinics.net/lists/netdev/msg604397.html )
No, this is a different issue ^_^.
