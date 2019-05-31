Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E106130BB6
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 11:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfEaJgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 05:36:22 -0400
Received: from m97188.mail.qiye.163.com ([220.181.97.188]:21683 "EHLO
        m97188.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbfEaJgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 05:36:22 -0400
Received: from [192.168.188.14] (unknown [120.132.1.226])
        by m97188.mail.qiye.163.com (Hmail) with ESMTPA id A45779670D1;
        Fri, 31 May 2019 17:36:16 +0800 (CST)
Subject: Re: [PATCH net-next,v2] netfilter: nf_conntrack_bridge: fix
 CONFIG_IPV6=y
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org
References: <20190531091526.1671-1-pablo@netfilter.org>
From:   wenxu <wenxu@ucloud.cn>
Message-ID: <73e16ff5-88b3-b856-ad08-dae2f600a8e5@ucloud.cn>
Date:   Fri, 31 May 2019 17:36:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190531091526.1671-1-pablo@netfilter.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-HM-Spam-Status: e1kIGBQJHllBWVZKVU1KSEtLS0tITklDTkJOWVdZKFlBSUI3V1ktWUFJV1
        kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PC46GDo6HzgyTSIRCBIVEjM6
        STQaCi5VSlVKTk5CSUJOSExNQ0NOVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJS1VK
        SElVSlVJSU1ZV1kIAVlBSE9ISTcG
X-HM-Tid: 0a6b0d3f3da220bckuqya45779670d1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Signed-off-by: wenxu <wenxu@ucloud.cn>

On 5/31/2019 5:15 PM, Pablo Neira Ayuso wrote:
> This patch fixes a few problems with CONFIG_IPV6=y and
> CONFIG_NF_CONNTRACK_BRIDGE=m:
>
> In file included from net/netfilter/utils.c:5:
> include/linux/netfilter_ipv6.h: In function 'nf_ipv6_br_defrag':
> include/linux/netfilter_ipv6.h:110:9: error: implicit declaration of function 'nf_ct_frag6_gather'; did you mean 'nf_ct_attach'? [-Werror=implicit-function-declaration]
>
> And these too:
>
> net/ipv6/netfilter.c:242:2: error: unknown field 'br_defrag' specified in initializer
> net/ipv6/netfilter.c:243:2: error: unknown field 'br_fragment' specified in initializer
>
> This patch includes an original chunk from wenxu.
>
> Fixes: 764dd163ac92 ("netfilter: nf_conntrack_bridge: add support for IPv6")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: Yuehaibing <yuehaibing@huawei.com>
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: wenxu <wenxu@ucloud.cn>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: Forgot to include "net-next" and added Reported-by to all people that have
>     reported problems.
>
>  include/linux/netfilter_ipv6.h | 2 ++
>  net/ipv6/netfilter.c           | 2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> index a21b8c9623ee..3a3dc4b1f0e7 100644
> --- a/include/linux/netfilter_ipv6.h
> +++ b/include/linux/netfilter_ipv6.h
> @@ -96,6 +96,8 @@ static inline int nf_ip6_route(struct net *net, struct dst_entry **dst,
>  #endif
>  }
>  
> +#include <net/netfilter/ipv6/nf_defrag_ipv6.h>
> +
>  static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
>  				    u32 user)
>  {
> diff --git a/net/ipv6/netfilter.c b/net/ipv6/netfilter.c
> index c6665382acb5..9530cc280953 100644
> --- a/net/ipv6/netfilter.c
> +++ b/net/ipv6/netfilter.c
> @@ -238,7 +238,7 @@ static const struct nf_ipv6_ops ipv6ops = {
>  	.route_input		= ip6_route_input,
>  	.fragment		= ip6_fragment,
>  	.reroute		= nf_ip6_reroute,
> -#if IS_MODULE(CONFIG_NF_CONNTRACK_BRIDGE)
> +#if IS_MODULE(CONFIG_IPV6)
>  	.br_defrag		= nf_ct_frag6_gather,
>  	.br_fragment		= br_ip6_fragment,
>  #endif
