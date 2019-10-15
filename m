Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5E5D7D6D
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 19:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731402AbfJORWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 13:22:06 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:56055 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726125AbfJORWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 13:22:05 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=zhiyuan2048@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0Tf9iD7o_1571160121;
Received: from 192.168.1.9(mailfrom:zhiyuan2048@linux.alibaba.com fp:SMTPD_---0Tf9iD7o_1571160121)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 16 Oct 2019 01:22:02 +0800
Subject: Re: [PATCH net] net: sched: act_mirred: drop skb's dst_entry in
 ingress redirection
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20191012071620.8595-1-zhiyuan2048@linux.alibaba.com>
 <CAM_iQpVkTb6Qf9J-PuXJoQTZa5ojN_oun64SMv9Kji7tZkxSyA@mail.gmail.com>
From:   Zhiyuan Hou <zhiyuan2048@linux.alibaba.com>
Message-ID: <e2bd3004-9f4b-f3ce-1214-2140f0b7cc61@linux.alibaba.com>
Date:   Wed, 16 Oct 2019 01:22:01 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <CAM_iQpVkTb6Qf9J-PuXJoQTZa5ojN_oun64SMv9Kji7tZkxSyA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2019/10/15 1:57 上午, Cong Wang wrote:
> On Sat, Oct 12, 2019 at 12:16 AM Zhiyuan Hou
> <zhiyuan2048@linux.alibaba.com> wrote:
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
>>          if (!want_ingress)
>>                  err = dev_queue_xmit(skb2);
>> -       else
>> +       else {
>> +               skb_dst_drop(skb2);
>>                  err = netif_receive_skb(skb2);
>> +       }
> Good catch!
>
> I don't want to be picky, but it seems this is only needed
> when redirecting from egress to ingress, right? That is,
> ingress to ingress, or ingress to egress is okay? If not,
> please fix all the cases while you are on it?
Sure. But I think this patch is also needed when redirecting from
ingress to ingress. Because we cannot assure that a skb has null dst
in ingress redirection path. For example, if redirecting a skb from
loopback's ingress to other device's ingress, the skb will take a
dst.

As commit logs point out, skb with valid dst cannot be made routing
decision in following process. original dst may cause skb loss or
other unexpected behavior.
>
> Thanks.
