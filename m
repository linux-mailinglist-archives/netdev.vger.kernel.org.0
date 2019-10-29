Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13C3E7DAA
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 01:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbfJ2Ayc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 20:54:32 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:55350 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727336AbfJ2Ayb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 20:54:31 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iPFmH-0000V8-1x; Tue, 29 Oct 2019 01:54:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     syzbot+c54f457cad330e57e967@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, netfilter-devel@vger.kernel.org,
        Florian Westphal <fw@strlen.de>,
        Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next] inet: do not call sublist_rcv on empty list
Date:   Tue, 29 Oct 2019 01:44:04 +0100
Message-Id: <20191029004404.8563-1-fw@strlen.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <0000000000003cc4980596006472@google.com>
References: <0000000000003cc4980596006472@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot triggered struct net NULL deref in NF_HOOK_LIST:
RIP: 0010:NF_HOOK_LIST include/linux/netfilter.h:331 [inline]
RIP: 0010:ip6_sublist_rcv+0x5c9/0x930 net/ipv6/ip6_input.c:292
 ipv6_list_rcv+0x373/0x4b0 net/ipv6/ip6_input.c:328
 __netif_receive_skb_list_ptype net/core/dev.c:5274 [inline]

Reason:
void ipv6_list_rcv(struct list_head *head, struct packet_type *pt,
                   struct net_device *orig_dev)
[..]
        list_for_each_entry_safe(skb, next, head, list) {
		/* iterates list */
                skb = ip6_rcv_core(skb, dev, net);
		/* ip6_rcv_core drops skb -> NULL is returned */
                if (skb == NULL)
                        continue;
	[..]
	}
	/* sublist is empty -> curr_net is NULL */
        ip6_sublist_rcv(&sublist, curr_dev, curr_net);

Before the recent change NF_HOOK_LIST did a list iteration before
struct net deref, i.e. it was a no-op in the empty list case.

List iteration now happens after *net deref, causing crash.

Follow the same pattern as the ip(v6)_list_rcv loop and add a list_empty
test for the final sublist dispatch too.

Cc: Edward Cree <ecree@solarflare.com>
Reported-by: syzbot+c54f457cad330e57e967@syzkaller.appspotmail.com
Fixes: ca58fbe06c54 ("netfilter: add and use nf_hook_slow_list()")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/ip_input.c  | 3 ++-
 net/ipv6/ip6_input.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index c59a78a267c3..24a95126e698 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -611,5 +611,6 @@ void ip_list_rcv(struct list_head *head, struct packet_type *pt,
 		list_add_tail(&skb->list, &sublist);
 	}
 	/* dispatch final sublist */
-	ip_sublist_rcv(&sublist, curr_dev, curr_net);
+	if (!list_empty(&sublist))
+		ip_sublist_rcv(&sublist, curr_dev, curr_net);
 }
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 3d71c7d6102c..ef7f707d9ae3 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -325,7 +325,8 @@ void ipv6_list_rcv(struct list_head *head, struct packet_type *pt,
 		list_add_tail(&skb->list, &sublist);
 	}
 	/* dispatch final sublist */
-	ip6_sublist_rcv(&sublist, curr_dev, curr_net);
+	if (!list_empty(&sublist))
+		ip6_sublist_rcv(&sublist, curr_dev, curr_net);
 }
 
 INDIRECT_CALLABLE_DECLARE(int udpv6_rcv(struct sk_buff *));
-- 
2.23.0

