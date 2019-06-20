Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECDBD4D219
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 17:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbfFTP0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 11:26:09 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:19049 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726428AbfFTP0J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 Jun 2019 11:26:09 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 00609F52E4A9FE473DD7;
        Thu, 20 Jun 2019 23:26:05 +0800 (CST)
Received: from [127.0.0.1] (10.133.213.239) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 20 Jun 2019
 23:26:02 +0800
Subject: Re: [PATCH net-next] netfilter: ipv6: Fix build error without
 CONFIG_IPV6
To:     <pablo@netfilter.org>, <kadlec@blackhole.kfki.hu>, <fw@strlen.de>,
        <davem@davemloft.net>, <rdunlap@infradead.org>
References: <20190612084715.21656-1-yuehaibing@huawei.com>
CC:     <linux-kernel@vger.kernel.org>, <coreteam@netfilter.org>,
        <netfilter-devel@vger.kernel.org>, <netdev@vger.kernel.org>
From:   Yuehaibing <yuehaibing@huawei.com>
Message-ID: <d2eba9e4-34be-f9bb-f0fd-024fe81d2b02@huawei.com>
Date:   Thu, 20 Jun 2019 23:26:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.2.0
MIME-Version: 1.0
In-Reply-To: <20190612084715.21656-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Friendly ping...

On 2019/6/12 16:47, YueHaibing wrote:
> If CONFIG_IPV6 is not set, building fails:
> 
> net/bridge/netfilter/nf_conntrack_bridge.o: In function `nf_ct_bridge_pre':
> nf_conntrack_bridge.c:(.text+0x41c): undefined symbol `nf_ct_frag6_gather'
> net/bridge/netfilter/nf_conntrack_bridge.o: In function `nf_ct_bridge_post':
> nf_conntrack_bridge.c:(.text+0x820): undefined symbol `br_ip6_fragment'
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: c9bb6165a16e ("netfilter: nf_conntrack_bridge: fix CONFIG_IPV6=y")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  include/linux/netfilter_ipv6.h | 10 ++++++++--
>  1 file changed, 8 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/netfilter_ipv6.h b/include/linux/netfilter_ipv6.h
> index 3a3dc4b..0e1febc 100644
> --- a/include/linux/netfilter_ipv6.h
> +++ b/include/linux/netfilter_ipv6.h
> @@ -108,8 +108,11 @@ static inline int nf_ipv6_br_defrag(struct net *net, struct sk_buff *skb,
>  		return 1;
>  
>  	return v6_ops->br_defrag(net, skb, user);
> -#else
> +#endif
> +#if IS_BUILTIN(CONFIG_IPV6)
>  	return nf_ct_frag6_gather(net, skb, user);
> +#else
> +	return 1;
>  #endif
>  }
>  
> @@ -133,8 +136,11 @@ static inline int nf_br_ip6_fragment(struct net *net, struct sock *sk,
>  		return 1;
>  
>  	return v6_ops->br_fragment(net, sk, skb, data, output);
> -#else
> +#endif
> +#if IS_BUILTIN(CONFIG_IPV6)
>  	return br_ip6_fragment(net, sk, skb, data, output);
> +#else
> +	return 1;
>  #endif
>  }
>  
> 

