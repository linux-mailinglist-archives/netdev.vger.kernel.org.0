Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05039783B5
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 05:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfG2DnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jul 2019 23:43:21 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:33847 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbfG2DnV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jul 2019 23:43:21 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 6294D41A53;
        Mon, 29 Jul 2019 11:43:09 +0800 (CST)
Subject: Re: [PATCH net-next] netfilter: nf_table_offload: Fix zero prio of
 flow_cls_common_offload
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        pablo@netfilter.org
Cc:     davem@davemloft.net, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1562832210-25981-1-git-send-email-wenxu@ucloud.cn>
 <20190724235151.GB4063@localhost.localdomain>
 <9775e2da-78ce-95f8-c215-b35b464ea5a9@ucloud.cn>
 <20190725034540.GJ6204@localhost.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <80fd8d7f-3437-1621-960c-02fd5173c985@ucloud.cn>
Date:   Mon, 29 Jul 2019 11:43:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190725034540.GJ6204@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSENNS0tLSk5NT0tJTkJZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6KzI6Lio4TDgyMkooNhIVTy0R
        GSxPCQxVSlVKTk1PSExKTENCTENCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBTUxOTzcG
X-HM-Tid: 0a6c3bd327672086kuqy6294d41a53
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi pablo


Any suggestion for this case.  Tthe 0 prio vlaue for driver is an invalid priority. So What should we do for this

case? Currently there is no prio for each nft rules.


BR

wenxu


On 7/25/2019 11:45 AM, Marcelo Ricardo Leitner wrote:
> On Thu, Jul 25, 2019 at 11:03:52AM +0800, wenxu wrote:
>> On 7/25/2019 7:51 AM, Marcelo Ricardo Leitner wrote:
>>> On Thu, Jul 11, 2019 at 04:03:30PM +0800, wenxu@ucloud.cn wrote:
>>>> From: wenxu <wenxu@ucloud.cn>
>>>>
>>>> The flow_cls_common_offload prio should be not zero
>>>>
>>>> It leads the invalid table prio in hw.
>>>>
>>>> # nft add table netdev firewall
>>>> # nft add chain netdev firewall acl { type filter hook ingress device mlx_pf0vf0 priority - 300 \; }
>>>> # nft add rule netdev firewall acl ip daddr 1.1.1.7 drop
>>>> Error: Could not process rule: Invalid argument
>>>>
>>>> kernel log
>>>> mlx5_core 0000:81:00.0: E-Switch: Failed to create FDB Table err -22 (table prio: 65535, level: 0, size: 4194304)
>>>>
>>>> Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
>>>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>>>> ---
>>>>  net/netfilter/nf_tables_offload.c | 3 +++
>>>>  1 file changed, 3 insertions(+)
>>>>
>>>> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
>>>> index 2c33028..01d8133 100644
>>>> --- a/net/netfilter/nf_tables_offload.c
>>>> +++ b/net/netfilter/nf_tables_offload.c
>>>> @@ -7,6 +7,8 @@
>>>>  #include <net/netfilter/nf_tables_offload.h>
>>>>  #include <net/pkt_cls.h>
>>>>  
>>>> +#define FLOW_OFFLOAD_DEFAUT_PRIO 1U
>>>> +
>>>>  static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
>>>>  {
>>>>  	struct nft_flow_rule *flow;
>>>> @@ -107,6 +109,7 @@ static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
>>>>  					struct netlink_ext_ack *extack)
>>>>  {
>>>>  	common->protocol = proto;
>>>> +	common->prio = TC_H_MAKE(FLOW_OFFLOAD_DEFAUT_PRIO << 16, 0);
>>> Note that tc semantics for this is to auto-generate a priority in such
>>> cases, instead of using a default.
>>>
>>> @tc_new_tfilter():
>>>         if (prio == 0) {
>>>                 /* If no priority is provided by the user,
>>>                  * we allocate one.
>>>                  */
>>>                 if (n->nlmsg_flags & NLM_F_CREATE) {
>>>                         prio = TC_H_MAKE(0x80000000U, 0U);
>>>                         prio_allocate = true;
>>> ...
>>>                 if (prio_allocate)
>>>                         prio = tcf_auto_prio(tcf_chain_tp_prev(chain,
>>>                                                                &chain_info));
>> Yes,The tc auto-generate a priority.  But if there is no pre
>> tcf_proto, the priority is also set as a default.
> After the first filter, there will be a tcf_proto. Please see the test below.
>
>> In nftables each rule no priortiy for each other. So It is enough to
>> set a default value which is similar as the tc.
> Yep, maybe it works for nftables. I'm just highlighting this because
> it is reusing tc infrastructure and will expose a different behavior
> to the user.  But if nftables already has this defined, that probably
> takes precedence by now and all that is left to do is to make sure any
> documentation on it is updated.  Pablo?
>
>> static inline u32 tcf_auto_prio(struct tcf_proto *tp)
>> {
>>     u32 first = TC_H_MAKE(0xC0000000U, 0U);
>                               ^^^^  base default prio, 0xC0000 = 49152
>
>>     if (tp)
>>         first = tp->prio - 1;
>>
>>     return TC_H_MAJ(first);
>> }
> # tc qdisc add dev veth1 ingress
> # tc filter add dev veth1 ingress proto ip flower src_mac ec:13:db:00:00:00 action drop
>                                                            1st filter  --^^
> # tc filter add dev veth1 ingress proto ip flower src_mac ec:13:db:00:00:01 action drop
>                                                            2nd filter  --^^
> # tc filter add dev veth1 ingress proto ip flower src_mac ec:13:db:00:00:02 action drop
>
> With no 'prio X' parameter, it uses 0 as default, and when dumped:
>
> # tc filter show dev veth1 ingress
> filter protocol ip pref 49150 flower
> filter protocol ip pref 49150 flower handle 0x1
>   src_mac ec:13:db:00:00:02
>   eth_type ipv4
>   not_in_hw
>         action order 1: gact action drop
>          random type none pass val 0
>          index 40003 ref 1 bind 1
>
> filter protocol ip pref 49151 flower
> filter protocol ip pref 49151 flower handle 0x1
>                         ^vv^^---- 2nd filter
>   src_mac ec:13:db:00:00:01
>   eth_type ipv4
>   not_in_hw
>         action order 1: gact action drop
>          random type none pass val 0
>          index 40002 ref 1 bind 1
>
> filter protocol ip pref 49152 flower
> filter protocol ip pref 49152 flower handle 0x1
>                         ^vv^^---- 1st filter
>   src_mac ec:13:db:00:00:00
>   eth_type ipv4
>   not_in_hw
>         action order 1: gact action drop
>          random type none pass val 0
>          index 40001 ref 1 bind 1
>
>
>
