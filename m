Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8C00E8443
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 10:21:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfJ2JVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 05:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727257AbfJ2JVr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 05:21:47 -0400
Received: from localhost (unknown [77.137.89.37])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D6AF920717;
        Tue, 29 Oct 2019 09:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572340906;
        bh=mKrTfUmlDRX78JPqZRqY49HWUeLghpN6sp6EkI3pjx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=v7mVXLAG6ZPoJ83FJQR1OWC53S6aInMEE5A1KQdh8N0hQqVqstJNksQt0JKtkueAt
         2aaeuRkep/Mc9jThwHl8JffOlRQE5gK6p6+jKH2Y5stl+JgSQQ/vvxr/usKwRyba7I
         ZVrROXm/wGDdKM/p4Bi3HnYbbSIyJY4+ljRoIvSE=
Date:   Tue, 29 Oct 2019 11:21:42 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org,
        syzbot+c54f457cad330e57e967@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, netfilter-devel@vger.kernel.org,
        Edward Cree <ecree@solarflare.com>
Subject: Re: [PATCH net-next] inet: do not call sublist_rcv on empty list
Message-ID: <20191029092142.GC5545@unreal>
References: <0000000000003cc4980596006472@google.com>
 <20191029004404.8563-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191029004404.8563-1-fw@strlen.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 29, 2019 at 01:44:04AM +0100, Florian Westphal wrote:
> syzbot triggered struct net NULL deref in NF_HOOK_LIST:
> RIP: 0010:NF_HOOK_LIST include/linux/netfilter.h:331 [inline]
> RIP: 0010:ip6_sublist_rcv+0x5c9/0x930 net/ipv6/ip6_input.c:292
>  ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:328
>  __netif_receive_skb_list_ptype net/core/dev.c:5274 [inline]
>
> Reason:
> void ipv6_list_rcv(struct list_head *head, struct packet_type *pt,
>                    struct net_device *orig_dev)
> [..]
>         list_for_each_entry_safe(skb, next, head, list) {
> 		/* iterates list */
>                 skb = ip6_rcv_core(skb, dev, net);
> 		/* ip6_rcv_core drops skb -> NULL is returned */
>                 if (skb == NULL)
>                         continue;
> 	[..]
> 	}
> 	/* sublist is empty -> curr_net is NULL */
>         ip6_sublist_rcv(&sublist, curr_dev, curr_net);
>
> Before the recent change NF_HOOK_LIST did a list iteration before
> struct net deref, i.e. it was a no-op in the empty list case.
>
> List iteration now happens after *net deref, causing crash.
>
> Follow the same pattern as the ip(v6)_list_rcv loop and add a list_empty
> test for the final sublist dispatch too.
>
> Cc: Edward Cree <ecree@solarflare.com>
> Reported-by: syzbot+c54f457cad330e57e967@syzkaller.appspotmail.com
> Fixes: ca58fbe06c54 ("netfilter: add and use nf_hook_slow_list()")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/ipv4/ip_input.c  | 3 ++-
>  net/ipv6/ip6_input.c | 3 ++-
>  2 files changed, 4 insertions(+), 2 deletions(-)
>

It fixed my crash on boot.

Thanks,
Tested-by: Leon Romanovsky <leonro@mellanox.com>
