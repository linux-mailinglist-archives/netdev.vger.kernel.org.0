Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A34A1E8C6C
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 02:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728349AbgE3AEK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 20:04:10 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:62714 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726898AbgE3AEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 20:04:09 -0400
Received: from [192.168.1.7] (unknown [101.81.68.199])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id C3EE641796;
        Sat, 30 May 2020 08:04:06 +0800 (CST)
Subject: Re: [PATCH] net/sched: act_ct: add nat mangle action only for
 NAT-conntrack
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     paulb@mellanox.com, netdev@vger.kernel.org, davem@davemloft.net
References: <1590725265-17136-1-git-send-email-wenxu@ucloud.cn>
 <20200529175650.GF74252@localhost.localdomain>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <09b6cd0b-5477-0e84-2a95-12eee55845d0@ucloud.cn>
Date:   Sat, 30 May 2020 08:04:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200529175650.GF74252@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVTENKS0tLS0pDSkpCQ0pZV1koWU
        FJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkXMjULOBw6IyMBDUkUDz0eTTwQDDocVlZVTkpNT0MoSVlXWQ
        kOFx4IWUFZNTQpNjo3JCkuNz5ZV1kWGg8SFR0UWUFZNDBZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OSo6LQw4Hjg6DT8rIiEPE0hP
        IjYKCT5VSlVKTkJLTEJMS09MSkpNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpLSlVD
        SlVNQ1VKQkJZV1kIAVlBSENCTjcG
X-HM-Tid: 0a7262e494cd2086kuqyc3ee641796
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2020/5/30 1:56, Marcelo Ricardo Leitner 写道:
> On Fri, May 29, 2020 at 12:07:45PM +0800, wenxu@ucloud.cn wrote:
>> From: wenxu <wenxu@ucloud.cn>
>>
>> Currently add nat mangle action with comparing invert and ori tuple.
>> It is better to check IPS_NAT_MASK flags first to avoid non necessary
>> memcmp for non-NAT conntrack.
>>
>> Signed-off-by: wenxu <wenxu@ucloud.cn>
>> ---
>>  net/sched/act_ct.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index c50a86a..d621152 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -198,18 +198,21 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
>>  					    struct flow_action *action)
>>  {
>>  	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
>> +	bool nat = ct->status & IPS_NAT_MASK;
>>  	struct nf_conntrack_tuple target;
> [A]
>
>>  
>>  	nf_ct_invert_tuple(&target, &ct->tuplehash[!dir].tuple);
>>  
>>  	switch (tuple->src.l3num) {
>>  	case NFPROTO_IPV4:
>> -		tcf_ct_flow_table_add_action_nat_ipv4(tuple, target,
>> -						      action);
>> +		if (nat)
> Why do the same check multiple times, on all actions? As no other
> action is performed if not doing a nat, seems at [A] above, it could
> just:
>
> if (!nat)
> 	return 0;

This function is not always return 0.  It is the same for non-nat conntrack.

If the ether proto is not ipv4 or ipv6 and the ip_proto is not tcp and udp,

this function should return -EOPNOTSUPP. Check the nat for each type

is just to following the rule.

>
>> +			tcf_ct_flow_table_add_action_nat_ipv4(tuple, target,
>> +							      action);
>>  		break;
>>  	case NFPROTO_IPV6:
>> -		tcf_ct_flow_table_add_action_nat_ipv6(tuple, target,
>> -						      action);
>> +		if (nat)
>> +			tcf_ct_flow_table_add_action_nat_ipv6(tuple, target,
>> +							      action);
>>  		break;
>>  	default:
>>  		return -EOPNOTSUPP;
>> @@ -217,10 +220,14 @@ static int tcf_ct_flow_table_add_action_nat(struct net *net,
>>  
>>  	switch (nf_ct_protonum(ct)) {
>>  	case IPPROTO_TCP:
>> -		tcf_ct_flow_table_add_action_nat_tcp(tuple, target, action);
>> +		if (nat)
>> +			tcf_ct_flow_table_add_action_nat_tcp(tuple, target,
>> +							     action);
>>  		break;
>>  	case IPPROTO_UDP:
>> -		tcf_ct_flow_table_add_action_nat_udp(tuple, target, action);
>> +		if (nat)
>> +			tcf_ct_flow_table_add_action_nat_udp(tuple, target,
>> +							     action);
>>  		break;
>>  	default:
>>  		return -EOPNOTSUPP;
>> -- 
>> 1.8.3.1
>>
