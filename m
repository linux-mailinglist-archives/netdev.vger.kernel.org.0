Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E67B74396
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 05:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389566AbfGYDEF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 23:04:05 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:54057 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389554AbfGYDEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 23:04:04 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id D0337416D3;
        Thu, 25 Jul 2019 11:03:58 +0800 (CST)
Subject: Re: [PATCH net-next] netfilter: nf_table_offload: Fix zero prio of
 flow_cls_common_offload
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     pablo@netfilter.org, davem@davemloft.net,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
References: <1562832210-25981-1-git-send-email-wenxu@ucloud.cn>
 <20190724235151.GB4063@localhost.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <9775e2da-78ce-95f8-c215-b35b464ea5a9@ucloud.cn>
Date:   Thu, 25 Jul 2019 11:03:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190724235151.GB4063@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVSEJKS0tLSk5KTUhPSUlZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OVE6SDo4Pjg8FFY#MA4uPAg2
        SU0KCxdVSlVKTk1PS0lIQ0hCSkpMVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBT0tDTTcG
X-HM-Tid: 0a6c2715d9522086kuqyd0337416d3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/25/2019 7:51 AM, Marcelo Ricardo Leitner wrote:
> On Thu, Jul 11, 2019 at 04:03:30PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> The flow_cls_common_offload prio should be not zero
>>
>> It leads the invalid table prio in hw.
>>
>> # nft add table netdev firewall
>> # nft add chain netdev firewall acl { type filter hook ingress device mlx_pf0vf0 priority - 300 \; }
>> # nft add rule netdev firewall acl ip daddr 1.1.1.7 drop
>> Error: Could not process rule: Invalid argument
>>
>> kernel log
>> mlx5_core 0000:81:00.0: E-Switch: Failed to create FDB Table err -22 (table prio: 65535, level: 0, size: 4194304)
>>
>> Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  net/netfilter/nf_tables_offload.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/netfilter/nf_tables_offload.c b/net/netfilter/nf_tables_offload.c
>> index 2c33028..01d8133 100644
>> --- a/net/netfilter/nf_tables_offload.c
>> +++ b/net/netfilter/nf_tables_offload.c
>> @@ -7,6 +7,8 @@
>>  #include <net/netfilter/nf_tables_offload.h>
>>  #include <net/pkt_cls.h>
>>  
>> +#define FLOW_OFFLOAD_DEFAUT_PRIO 1U
>> +
>>  static struct nft_flow_rule *nft_flow_rule_alloc(int num_actions)
>>  {
>>  	struct nft_flow_rule *flow;
>> @@ -107,6 +109,7 @@ static void nft_flow_offload_common_init(struct flow_cls_common_offload *common,
>>  					struct netlink_ext_ack *extack)
>>  {
>>  	common->protocol = proto;
>> +	common->prio = TC_H_MAKE(FLOW_OFFLOAD_DEFAUT_PRIO << 16, 0);
> Note that tc semantics for this is to auto-generate a priority in such
> cases, instead of using a default.
>
> @tc_new_tfilter():
>         if (prio == 0) {
>                 /* If no priority is provided by the user,
>                  * we allocate one.
>                  */
>                 if (n->nlmsg_flags & NLM_F_CREATE) {
>                         prio = TC_H_MAKE(0x80000000U, 0U);
>                         prio_allocate = true;
> ...
>                 if (prio_allocate)
>                         prio = tcf_auto_prio(tcf_chain_tp_prev(chain,
>                                                                &chain_info));

Yes,The tc auto-generate a priority.  But if there is no pre tcf_proto, the priority is also set as a default.

In nftables each rule no priortiy for each other. So It is enough to set a default value which is similar as the

tc.

static inline u32 tcf_auto_prio(struct tcf_proto *tp)
{
    u32 first = TC_H_MAKE(0xC0000000U, 0U);

    if (tp)
        first = tp->prio - 1;

    return TC_H_MAJ(first);
}

