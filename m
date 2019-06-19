Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 504934B080
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 05:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfFSDrc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 23:47:32 -0400
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:6399 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfFSDrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 23:47:31 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 73A925C194E;
        Wed, 19 Jun 2019 11:47:26 +0800 (CST)
Subject: Re: [PATCH net-next] netfilter: bridge: add nft_bridge_pvid to tag
 the default pvid for non-tagged packet
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
References: <1560600861-8848-1-git-send-email-wenxu@ucloud.cn>
 <20190618164007.suuaa5zx2b242ey7@salvia>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <88cace34-c54e-dd2b-7045-197136a9a246@ucloud.cn>
Date:   Wed, 19 Jun 2019 11:47:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190618164007.suuaa5zx2b242ey7@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-HM-Spam-Status: e1kfGhgUHx5ZQUhXWQgYFAkeWUFZVkpVSE5MS0tLSUhKTE9JQ01ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PiI6Kxw4GTg9FBA#NhlJLBwe
        DkkKCw9VSlVKTk1LQkpNS09NTUJNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSU1JQjcG
X-HM-Tid: 0a6b6dd8b30d2087kuqy73a925c194e
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 6/19/2019 12:40 AM, Pablo Neira Ayuso wrote:
> On Sat, Jun 15, 2019 at 08:14:21PM +0800, wenxu@ucloud.cn wrote:
> [...]
>> +static void nft_bridge_pvid_eval(const struct nft_expr *expr,
>> +				 struct nft_regs *regs,
>> +				 const struct nft_pktinfo *pkt)
>> +{
>> +	struct sk_buff *skb = pkt->skb;
>> +	struct net_bridge_port *p;
>> +
>> +	p = br_port_get_rtnl_rcu(skb->dev);
>> +
>> +	if (p && br_opt_get(p->br, BROPT_VLAN_ENABLED) &&
>> +	    !skb_vlan_tag_present(skb)) {
>> +		u16 pvid = br_get_pvid(nbp_vlan_group_rcu(p));
>> +
>> +		if (pvid)
>> +			__vlan_hwaccel_put_tag(skb, p->br->vlan_proto, pvid);
> I see two things here:
>
> #1 Extend new NFT_META_BRIDGE_PVID nft_meta to fetch of 'pvid',
>    probably add net/bridge/netfilter/nft_meta_bridge.c for this.
I can get this, it provide a bridge pvid (get meta). But why put it in

nft_meta_bridge.c but not nft_meta.c?

>
> #2 Extend nft_meta to allow to set the vlan tag via
>    __vlan_hwaccel_put_tag().

why there is also extend nft_meta?  So it's a set meta. Is "vlan id set"

 not base on nft_payload ?

>
> If these two changes are in place, then it should be possible to set
> skbuff vlan id based on the pvid, if this is what you need.
>
> This would allow for:
>
>         vlan id set bridge pvid
>
