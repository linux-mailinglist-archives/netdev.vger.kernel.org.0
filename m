Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D936116427
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 00:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726857AbfLHXcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Dec 2019 18:32:06 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:36832 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726811AbfLHXcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Dec 2019 18:32:05 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1ie61r-0004Ux-1X; Mon, 09 Dec 2019 00:31:55 +0100
Date:   Mon, 9 Dec 2019 00:31:55 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH netfilter] netfilter: bridge: make sure to pull arp
 header in br_nf_forward_arp()
Message-ID: <20191208233155.GH795@breakpoint.cc>
References: <20191207224339.91704-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191207224339.91704-1-edumazet@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <edumazet@google.com> wrote:
> syzbot is kind enough to remind us we need to call skb_may_pull()

[..]

> Fixes: c4e70a87d975 ("netfilter: bridge: rename br_netfilter.c to br_netfilter_hooks.c")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: syzbot <syzkaller@googlegroups.com>
> ---
> 
> Note: Fixes: tag does not point to real bug origin, but is old enough
>      to cover all stable versions.

Indeed, looks like a day0 bug.  We don't have this problem for ipv4/6
because the prerouting hook does pskb_may_pull() as part of ipv4/6
header checks.  Arp doesn't have anything like it.

>  		nf_bridge_pull_encap_header(skb);
>  	}
>  
> +	if (unlikely(!pskb_may_pull(skb, sizeof(struct arphdr))))
> +		return NF_DROP;
> +
>  	if (arp_hdr(skb)->ar_pln != 4) {

Thats indeed the only location where we call NFPROTO_ARP hooks,
so this looks like the proper fix/location.

Thanks Eric!

Reviewed-by: Florian Westphal <fw@strlen.de>
