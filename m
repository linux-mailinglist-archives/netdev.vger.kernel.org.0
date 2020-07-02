Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0CB211FA0
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728152AbgGBJRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:17:55 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:15955 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgGBJRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 05:17:55 -0400
Received: from [192.168.188.14] (unknown [106.75.220.2])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A34F241F43;
        Thu,  2 Jul 2020 17:17:51 +0800 (CST)
Subject: Re: [PATCH net 1/2] net/sched: act_ct: fix restore the qdisc_skb_cb
 after defrag
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <1593422178-26949-1-git-send-email-wenxu@ucloud.cn>
 <20200701.152116.1519098438346883237.davem@davemloft.net>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <89404b82-71b8-c94d-1e0b-11e3755da0b3@ucloud.cn>
Date:   Thu, 2 Jul 2020 17:17:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200701.152116.1519098438346883237.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEhIS0tLS01IQ0JNSkNZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkdIjULOBw4FUopIiQLDUoeTA8vOjocVlZVQ05CKElZV1kJDh
        ceCFlBWTU0KTY6NyQpLjc#WVdZFhoPEhUdFFlBWTQwWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NCo6Ghw5Gj8dOhUBSA0DTkg0
        PT4KC09VSlVKTkJITUNKT0xKQ01JVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLTVVM
        TlVJSUtVSVlXWQgBWUFJTENINwY+
X-HM-Tid: 0a730ed168ff2086kuqya34f241f43
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/2/2020 6:21 AM, David Miller wrote:
> From: wenxu@ucloud.cn
> Date: Mon, 29 Jun 2020 17:16:17 +0800
>
>> From: wenxu <wenxu@ucloud.cn>
>>
>> The fragment packets do defrag in tcf_ct_handle_fragments
>> will clear the skb->cb which make the qdisc_skb_cb clear
>> too and set the pkt_len to 0. The bytes always 0 when dump
>> the filter. And it also update the pkt_len after all the
>> fragments finish the defrag to one packet and make the
>> following action counter correct.
>>
>> filter protocol ip pref 2 flower chain 0 handle 0x2
>>   eth_type ipv4
>>   dst_ip 1.1.1.1
>>   ip_flags frag/firstfrag
>>   skip_hw
>>   not_in_hw
>>  action order 1: ct zone 1 nat pipe
>>   index 2 ref 1 bind 1 installed 11 sec used 11 sec
>>  Action statistics:
>>  Sent 0 bytes 11 pkt (dropped 0, overlimits 0 requeues 0)
>>  backlog 0b 0p requeues 0
>>  cookie e04106c2ac41769b278edaa9b5309960
>>
>> Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
> This is a much larger and serious problem IMHO.  And this fix is
> not sufficient.
>
> Nothing can clobber the qdisc_skb_cb like this in these packet flows
> otherwise we will have serious crashes and problems.  Some packet
> schedulers store pointers in the qdisc CB private area, for example.
Why store all the cb private and restore it can't total fix this?
>
> We need to somehow elide the CB clear when packets are defragmented by
> connection tracking.
you means add new function like ip_defrag_nocb for qdisc cb case?
>
