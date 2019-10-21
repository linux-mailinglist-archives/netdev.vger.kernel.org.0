Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50475DED1A
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 15:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfJUNGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 09:06:48 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:59834 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728792AbfJUNGs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 09:06:48 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R421e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e07487;MF=zhiyuan2048@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0Tfo8Fxn_1571663202;
Received: from houzhiyuandeMacBook-Pro.local(mailfrom:zhiyuan2048@linux.alibaba.com fp:SMTPD_---0Tfo8Fxn_1571663202)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 21 Oct 2019 21:06:43 +0800
Subject: Re: [PATCH net] net: sched: act_mirred: drop skb's dst_entry in
 ingress redirection
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, shmulik.ladkani@gmail.com
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
 <CAM_iQpVkTb6Qf9J-PuXJoQTZa5ojN_oun64SMv9Kji7tZkxSyA@mail.gmail.com>
 <e2bd3004-9f4b-f3ce-1214-2140f0b7cc61@linux.alibaba.com>
 <20191016151307.40f63896@jimi>
 <e16cfafe-059c-3106-835e-d32b7bb5ba61@linux.alibaba.com>
 <20191019002502.0519ea9b@jimi>
From:   Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
Message-ID: <5e9f0ae7-d31e-a428-9780-b6b7130f73f8@linux.alibaba.com>
Date:   Mon, 21 Oct 2019 21:06:42 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20191019002502.0519ea9b@jimi>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/19 5:25 上午, Eyal Birger wrote:
> Hi,
>
> On Fri, 18 Oct 2019 00:33:53 +0800
> Zhiyuan Hou <zhiyuan2048@linux.alibaba.com> wrote:
>
>> On 2019/10/16 8:13 下午, Eyal Birger wrote:
>>> Hi,
>>>
>>> On Wed, 16 Oct 2019 01:22:01 +0800
>>> Zhiyuan Hou <zhiyuan2048@linux.alibaba.com> wrote:
>>>   
>>>> On 2019/10/15 1:57 上午, Cong Wang wrote:
>>>>> On Sat, Oct 12, 2019 at 12:16 AM Zhiyuan Hou
>>>>> <zhiyuan2048@linux.alibaba.com> wrote:
>>>>>> diff --git a/net/sched/act_mirred.c b/net/sched/act_mirred.c
>>>>>> index 9ce073a05414..6108a64c0cd5 100644
>>>>>> --- a/net/sched/act_mirred.c
>>>>>> +++ b/net/sched/act_mirred.c
>>>>>> @@ -18,6 +18,7 @@
>>>>>>     #include <linux/gfp.h>
>>>>>>     #include <linux/if_arp.h>
>>>>>>     #include <net/net_namespace.h>
>>>>>> +#include <net/dst.h>
>>>>>>     #include <net/netlink.h>
>>>>>>     #include <net/pkt_sched.h>
>>>>>>     #include <net/pkt_cls.h>
>>>>>> @@ -298,8 +299,10 @@ static int tcf_mirred_act(struct sk_buff
>>>>>> *skb, const struct tc_action *a,
>>>>>>
>>>>>>            if (!want_ingress)
>>>>>>                    err = dev_queue_xmit(skb2);
>>>>>> -       else
>>>>>> +       else {
>>>>>> +               skb_dst_drop(skb2);
>>>>>>                    err = netif_receive_skb(skb2);
>>>>>> +       }
>>>>> Good catch!
>>> Indeed! Thanks for fixing this!
>>>   
>>>>> I don't want to be picky, but it seems this is only needed
>>>>> when redirecting from egress to ingress, right? That is,
>>>>> ingress to ingress, or ingress to egress is okay? If not,
>>>>> please fix all the cases while you are on it?
>>>> Sure. But I think this patch is also needed when redirecting from
>>>> ingress to ingress. Because we cannot assure that a skb has null
>>>> dst in ingress redirection path. For example, if redirecting a skb
>>>> from loopback's ingress to other device's ingress, the skb will
>>>> take a dst.
>>>>
>>>> As commit logs point out, skb with valid dst cannot be made routing
>>>> decision in following process. original dst may cause skb loss or
>>>> other unexpected behavior.
>>> On the other hand, removing the dst on ingress-to-ingress
>>> redirection may remove LWT information on incoming packets, which
>>> may be undesired.
>> Sorry, I do not understand why lwt information is needed on
>> ingress-to-ingress redirection. lwt is used on output path, isn't it?
>> Can you please give more information?
> On rx path tunnelled packets parameters received on a collect_md tunnel device
> are kept in a metadata dst. See ip_tunnel_rcv() 'tun_dst' parameter.
>
> The rx metadata dst can be matched by a number of mechanisms like routing
> rules, eBPF, OVS, and netfilter.
Yes, you are right. Thanks for your explanations.

The metadata dst should not be removed in redirection path and also
does not affect L3's routing decision.

Maybe we can add a following check to solve it before removing a dst,
what do you think?

   if (skb_valid_dst(skb2))
       skb_dst_drop(sbk2);
>
> Eyal.
