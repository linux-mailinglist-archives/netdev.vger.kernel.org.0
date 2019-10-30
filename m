Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31B8CE9445
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 01:55:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726855AbfJ3AzI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 20:55:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33798 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfJ3AzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 20:55:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0DCBA140C36A6;
        Tue, 29 Oct 2019 17:55:08 -0700 (PDT)
Date:   Tue, 29 Oct 2019 17:55:07 -0700 (PDT)
Message-Id: <20191029.175507.928629384409280095.davem@davemloft.net>
To:     fw@strlen.de
Cc:     netdev@vger.kernel.org,
        syzbot+c54f457cad330e57e967@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, netfilter-devel@vger.kernel.org,
        ecree@solarflare.com
Subject: Re: [PATCH net-next] inet: do not call sublist_rcv on empty list
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191029004404.8563-1-fw@strlen.de>
References: <0000000000003cc4980596006472@google.com>
        <20191029004404.8563-1-fw@strlen.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 17:55:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>
Date: Tue, 29 Oct 2019 01:44:04 +0100

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

Applied.
