Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CB13D9F2F
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 10:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234995AbhG2IIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 04:08:39 -0400
Received: from mail.netfilter.org ([217.70.188.207]:40712 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234917AbhG2IIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 04:08:39 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 50C916411D;
        Thu, 29 Jul 2021 10:08:03 +0200 (CEST)
Date:   Thu, 29 Jul 2021 10:08:29 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nf_conntrack_bridge: Fix memory leak when
 error
Message-ID: <20210729080829.GA16912@salvia>
References: <20210729074658.8538-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210729074658.8538-1-yajun.deng@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 03:46:58PM +0800, Yajun Deng wrote:
> It should be added kfree_skb_list() when err is not equal to zero
> in nf_br_ip_fragment().
> 
> v2: keep this aligned with IPv6.
> 
> Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 8d033a75a766..3cf5457919c6 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -88,6 +88,11 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
>  
>  			skb = ip_fraglist_next(&iter);
>  		}
> +
> +		if (!err)
> +			return 0;
> +
> +		kfree_skb_list(iter.frag_list);

Actually:
		kfree_skb_list(iter.frag);

I used frag_list instead of frag in my snippet.

>  		return err;
>  	}
>  slow_path:
> -- 
> 2.32.0
> 
