Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665653C60CA
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 18:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234289AbhGLQwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 12:52:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:35796 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232710AbhGLQv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 12:51:59 -0400
Received: from netfilter.org (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id C052A61657;
        Mon, 12 Jul 2021 18:48:51 +0200 (CEST)
Date:   Mon, 12 Jul 2021 18:49:04 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, mathew.j.martineau@linux.intel.com,
        matthieu.baerts@tessares.net, kadlec@netfilter.org, fw@strlen.de,
        vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com, johannes.berg@intel.com, ast@kernel.org,
        yhs@fb.com, 0x7f454c46@gmail.com, aahringo@redhat.com,
        rdunlap@infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mptcp@lists.linux.dev,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org
Subject: Re: [PATCH] net: Use nlmsg_unicast() instead of netlink_unicast()
Message-ID: <20210712164904.GA16733@salvia>
References: <20210712125301.14248-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210712125301.14248-1-yajun.deng@linux.dev>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 08:53:01PM +0800, Yajun Deng wrote:
> diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
> index 639c337c885b..aa3397eec330 100644
> --- a/net/netfilter/nft_compat.c
> +++ b/net/netfilter/nft_compat.c
> @@ -683,10 +683,8 @@ static int nfnl_compat_get_rcu(struct sk_buff *skb,
>  		goto out_put;
>  	}
>  
> -	ret = netlink_unicast(info->sk, skb2, NETLINK_CB(skb).portid,
> -			      MSG_DONTWAIT);
> -	if (ret > 0)
> -		ret = 0;
> +	ret = nlmsg_unicast(info->sk, skb2, NETLINK_CB(skb).portid);

netfilter needs nfnetlink_unicast to deal with EAGAIN, see e0241ae6ac59

So either:

a) use nfnetlink_unicast.
b) remove this chunk and I'll route a patch to fix this in the
   netfilter tree.

Pick one at your choice.

Thanks.

>  out_put:
>  	rcu_read_lock();
>  	module_put(THIS_MODULE);
