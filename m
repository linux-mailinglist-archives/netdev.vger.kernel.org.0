Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 667C857C17
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 08:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfF0GWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 02:22:47 -0400
Received: from m9783.mail.qiye.163.com ([220.181.97.83]:62308 "EHLO
        m9783.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726643AbfF0GWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 02:22:47 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9783.mail.qiye.163.com (Hmail) with ESMTPA id BDEF7C1A63;
        Thu, 27 Jun 2019 14:22:41 +0800 (CST)
Subject: Re: [PATCH 2/3 nf-next] netfilter:nf_flow_table: Support bridge type
 flow offload
To:     Florian Westphal <fw@strlen.de>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1561545148-11978-1-git-send-email-wenxu@ucloud.cn>
 <1561545148-11978-2-git-send-email-wenxu@ucloud.cn>
 <20190626183816.3ux3iifxaal4ffil@breakpoint.cc>
 <20190626191945.2mktaqrcrfcrfc66@breakpoint.cc>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <dce5cba2-766c-063e-745f-23b3dd83494b@ucloud.cn>
Date:   Thu, 27 Jun 2019 14:22:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190626191945.2mktaqrcrfcrfc66@breakpoint.cc>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVkpVSkJCS0tLSUhCSExJSU5ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MlE6Ngw6Hjg0IgsfEkI1PUlJ
        T0saFExVSlVKTk1KTUpNTk1JS0lCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSEtMTjcG
X-HM-Tid: 0a6b9799b7182085kuqybdef7c1a63
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/27/2019 3:19 AM, Florian Westphal wrote:
> Florian Westphal <fw@strlen.de> wrote:
>> wenxu@ucloud.cn <wenxu@ucloud.cn> wrote:
>>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>>> index 0016bb8..9af01ef 100644
>>> --- a/net/netfilter/nf_flow_table_ip.c
>>> +++ b/net/netfilter/nf_flow_table_ip.c
>>> -	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
>>> +	if (family == NFPROTO_IPV4) {
>>> +		iph = ip_hdr(skb);
>>> +		ip_decrease_ttl(iph);
>>> +
>>> +		nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
>>> +		skb_dst_set_noref(skb, &rt->dst);
>>> +		neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
>>> +	} else {
>>> +		const struct net_bridge_port *p;
>>> +
>>> +		if (vlan_tag && (p = br_port_get_rtnl_rcu(state->in)))
>>> +			__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, vlan_tag);
>>> +		else
>>> +			__vlan_hwaccel_clear_tag(skb);
>>> +
>>> +		br_dev_queue_push_xmit(state->net, state->sk, skb);
>> Won't that result in a module dep on bridge?
I  will fix it in version 2
>>
>> Whats the idea with this patch?
>>
>> Do you see a performance improvement when bypassing bridge layer? If so,
>> how much?
>>
>> I just wonder if its really cheaper than not using bridge conntrack in
>> the first place :-)

This patch is based on the conntrack function in bridge.  It will bypass the fdb lookup

and conntrack lookup to get the performance  improvement. The more important things

for hardware offload in the future with nf_tables add hardware offload support

>
