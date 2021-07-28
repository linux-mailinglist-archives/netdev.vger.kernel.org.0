Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C2D3D9304
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhG1QTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:19:10 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39104 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1QS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:18:56 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id 8C071642C6;
        Wed, 28 Jul 2021 18:18:23 +0200 (CEST)
Date:   Wed, 28 Jul 2021 18:18:49 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     kadlec@netfilter.org, fw@strlen.de, roopa@nvidia.com,
        nikolay@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netfilter: nf_conntrack_bridge: Fix not free when error
Message-ID: <20210728161849.GA10433@salvia>
References: <20210726035702.11964-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
In-Reply-To: <20210726035702.11964-1-yajun.deng@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

On Mon, Jul 26, 2021 at 11:57:02AM +0800, Yajun Deng wrote:
> It should be added kfree_skb_list() when err is not equal to zero
> in nf_br_ip_fragment().
> 
> Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  net/bridge/netfilter/nf_conntrack_bridge.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
> index 8d033a75a766..059f53903eda 100644
> --- a/net/bridge/netfilter/nf_conntrack_bridge.c
> +++ b/net/bridge/netfilter/nf_conntrack_bridge.c
> @@ -83,12 +83,16 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
>  
>  			skb->tstamp = tstamp;
>  			err = output(net, sk, data, skb);
> -			if (err || !iter.frag)
> -				break;
> -
> +			if (err) {
> +				kfree_skb_list(iter.frag);
> +				return err;
> +			}
> +
> +			if (!iter.frag)
> +				return 0;
> +
>  			skb = ip_fraglist_next(&iter);
>  		}
> -		return err;

Why removing this line above? It enters slow_path: on success.

This patch instead will keep this aligned with IPv6.

>  	}
>  slow_path:
>  	/* This is a linearized skbuff, the original geometry is lost for us.
> -- 
> 2.32.0
> 

--y0ulUmNC+osPPQO6
Content-Type: text/x-diff; charset=utf-8
Content-Disposition: attachment; filename="x.patch"

diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 8d033a75a766..3cf5457919c6 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -88,6 +88,11 @@ static int nf_br_ip_fragment(struct net *net, struct sock *sk,
 
 			skb = ip_fraglist_next(&iter);
 		}
+
+		if (!err)
+			return 0;
+
+		kfree_skb_list(iter.frag_list);
 		return err;
 	}
 slow_path:

--y0ulUmNC+osPPQO6--
