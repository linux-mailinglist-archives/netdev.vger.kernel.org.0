Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCF26439F2
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 01:29:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231559AbiLFA3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 19:29:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbiLFA3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 19:29:16 -0500
Received: from mail.nfschina.com (mail.nfschina.com [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 41BB8B3D;
        Mon,  5 Dec 2022 16:29:15 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 7E7321E80D57;
        Tue,  6 Dec 2022 08:24:58 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id RWHGksHZdfdj; Tue,  6 Dec 2022 08:24:55 +0800 (CST)
Received: from [172.30.38.124] (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 4FA151E80D0E;
        Tue,  6 Dec 2022 08:24:55 +0800 (CST)
Subject: Re: [PATCH] netfilter: initialize 'ret' variable
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>
References: <20221202070331.10865-1-liqiong@nfschina.com>
 <Y43/iCzGY7qJckCe@salvia>
From:   liqiong <liqiong@nfschina.com>
Message-ID: <287de53c-78f1-94b5-6399-772e347057b5@nfschina.com>
Date:   Tue, 6 Dec 2022 08:29:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <Y43/iCzGY7qJckCe@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022年12月05日 22:26, Pablo Neira Ayuso 写道:
> On Fri, Dec 02, 2022 at 03:03:31PM +0800, Li Qiong wrote:
>> The 'ret' should need to be initialized to 0, in case
>> return a uninitialized value.
>>
>> Signed-off-by: Li Qiong <liqiong@nfschina.com>
>> ---
>>  net/netfilter/nf_flow_table_ip.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
>> index b350fe9d00b0..225ff865d609 100644
>> --- a/net/netfilter/nf_flow_table_ip.c
>> +++ b/net/netfilter/nf_flow_table_ip.c
>> @@ -351,7 +351,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>>  	struct rtable *rt;
>>  	struct iphdr *iph;
>>  	__be32 nexthop;
>> -	int ret;
>> +	int ret = 0;
>>  
>>  	if (skb->protocol != htons(ETH_P_IP) &&
>>  	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &offset))
>> @@ -613,7 +613,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>>  	u32 hdrsize, offset = 0;
>>  	struct ipv6hdr *ip6h;
>>  	struct rt6_info *rt;
>> -	int ret;
>> +	int ret = 0;
>>  
>>  	if (skb->protocol != htons(ETH_P_IPV6) &&
>>  	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IPV6), &offset))
> This can only happen with tuplehash->tuple.xmit_type:
>
> - FLOW_OFFLOAD_XMIT_UNSPEC
> - FLOW_OFFLOAD_XMIT_TC
>
> but this should not ever happen in that path.
>
> Instead, I'd suggest to add a 'default' case to the switch, set ret to
> NF_DROP and WARN_ON_ONCE(1).
Thanks,  I will send a v2 patch.


