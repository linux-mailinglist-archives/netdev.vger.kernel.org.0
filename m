Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14754642A5B
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 15:26:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiLEO0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 09:26:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbiLEO0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 09:26:23 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF0761E1;
        Mon,  5 Dec 2022 06:26:22 -0800 (PST)
Date:   Mon, 5 Dec 2022 15:26:16 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Li Qiong <liqiong@nfschina.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] netfilter: initialize 'ret' variable
Message-ID: <Y43/iCzGY7qJckCe@salvia>
References: <20221202070331.10865-1-liqiong@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221202070331.10865-1-liqiong@nfschina.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 03:03:31PM +0800, Li Qiong wrote:
> The 'ret' should need to be initialized to 0, in case
> return a uninitialized value.
> 
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
>  net/netfilter/nf_flow_table_ip.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index b350fe9d00b0..225ff865d609 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -351,7 +351,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>  	struct rtable *rt;
>  	struct iphdr *iph;
>  	__be32 nexthop;
> -	int ret;
> +	int ret = 0;
>  
>  	if (skb->protocol != htons(ETH_P_IP) &&
>  	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IP), &offset))
> @@ -613,7 +613,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  	u32 hdrsize, offset = 0;
>  	struct ipv6hdr *ip6h;
>  	struct rt6_info *rt;
> -	int ret;
> +	int ret = 0;
>  
>  	if (skb->protocol != htons(ETH_P_IPV6) &&
>  	    !nf_flow_skb_encap_protocol(skb, htons(ETH_P_IPV6), &offset))

This can only happen with tuplehash->tuple.xmit_type:

- FLOW_OFFLOAD_XMIT_UNSPEC
- FLOW_OFFLOAD_XMIT_TC

but this should not ever happen in that path.

Instead, I'd suggest to add a 'default' case to the switch, set ret to
NF_DROP and WARN_ON_ONCE(1).
