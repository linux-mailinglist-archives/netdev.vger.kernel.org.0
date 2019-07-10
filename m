Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF13764799
	for <lists+netdev@lfdr.de>; Wed, 10 Jul 2019 15:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbfGJNwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jul 2019 09:52:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34152 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727637AbfGJNwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Jul 2019 09:52:13 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4D53686679;
        Wed, 10 Jul 2019 13:52:12 +0000 (UTC)
Received: from hog.localdomain, (ovpn-204-67.brq.redhat.com [10.40.204.67])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CEB9560A35;
        Wed, 10 Jul 2019 13:52:10 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Edward Cree <ecree@solarflare.com>,
        Andreas Steinmetz <ast@domdv.de>
Subject: [PATCH net] net: fix use-after-free in __netif_receive_skb_core
Date:   Wed, 10 Jul 2019 15:52:29 +0200
Message-Id: <e909b8fe24b9eac71de52c4f80f7f3f6e5770199.1562766613.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Wed, 10 Jul 2019 13:52:12 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When __netif_receive_skb_core handles a shared skb, it can be
reallocated in a few different places:
 - the device's rx_handler
 - vlan_do_receive
 - skb_vlan_untag

To deal with that, rx_handlers and vlan_do_receive get passed a
reference to the skb, and skb_vlan_untag just returns the new
skb. This was not a problem until commit 88eb1944e18c ("net: core:
propagate SKB lists through packet_type lookup"), which moved the
final handling of the skb via pt_prev out of
__netif_receive_skb_core. After this commit, when the skb is
reallocated by __netif_receive_skb_core, KASAN reports a
use-after-free on the old skb:

BUG: KASAN: use-after-free in __netif_receive_skb_one_core+0x15c/0x180
Call Trace:
 <IRQ>
 __netif_receive_skb_one_core+0x15c/0x180
 process_backlog+0x1b5/0x630
 ? net_rx_action+0x247/0xd00
 net_rx_action+0x3fa/0xd00
 ? napi_complete_done+0x360/0x360
 __do_softirq+0x257/0xa0b
 do_softirq_own_stack+0x2a/0x40
 </IRQ>
 ? __dev_queue_xmit+0x12ba/0x3120
 do_softirq+0x5d/0x60
 [...]

Allocated by task 505:
 __kasan_kmalloc.constprop.0+0xd6/0x140
 kmem_cache_alloc+0xd4/0x2e0
 skb_clone+0x106/0x300
 deliver_clone+0x3f/0xa0
 maybe_deliver+0x1c0/0x2b0
 br_flood+0xd4/0x320
 br_dev_xmit+0xbc0/0x1080
 dev_hard_start_xmit+0x139/0x750
 __dev_queue_xmit+0x24eb/0x3120
 packet_sendmsg+0x1bfa/0x50e0
 [...]

Freed by task 505:
 __kasan_slab_free+0x138/0x1e0
 kmem_cache_free+0xa2/0x2e0
 macsec_handle_frame+0xa24/0x2e60
 __netif_receive_skb_core+0xe2a/0x2c90
 __netif_receive_skb_one_core+0x96/0x180
 process_backlog+0x1b5/0x630
 net_rx_action+0x3fa/0xd00
 __do_softirq+0x257/0xa0b

The solution is to pass a reference to the skb to
__netif_receive_skb_core, as we already do with the rx_handlers, so
that its callers use the new skb.

Fixes: 88eb1944e18c ("net: core: propagate SKB lists through packet_type lookup")
Reported-by: Andreas Steinmetz <ast@domdv.de>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
---
 net/core/dev.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index d6edd218babd..0bbf6d2a9c32 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4809,11 +4809,12 @@ static inline int nf_ingress(struct sk_buff *skb, struct packet_type **pt_prev,
 	return 0;
 }
 
-static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
+static int __netif_receive_skb_core(struct sk_buff **pskb, bool pfmemalloc,
 				    struct packet_type **ppt_prev)
 {
 	struct packet_type *ptype, *pt_prev;
 	rx_handler_func_t *rx_handler;
+	struct sk_buff *skb = *pskb;
 	struct net_device *orig_dev;
 	bool deliver_exact = false;
 	int ret = NET_RX_DROP;
@@ -4852,6 +4853,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 	if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
 	    skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
 		skb = skb_vlan_untag(skb);
+		*pskb = skb;
 		if (unlikely(!skb))
 			goto out;
 	}
@@ -4878,6 +4880,7 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 #ifdef CONFIG_NET_INGRESS
 	if (static_branch_unlikely(&ingress_needed_key)) {
 		skb = sch_handle_ingress(skb, &pt_prev, &ret, orig_dev);
+		*pskb = skb;
 		if (!skb)
 			goto out;
 
@@ -4891,11 +4894,14 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 		goto drop;
 
 	if (skb_vlan_tag_present(skb)) {
+		bool ret2;
 		if (pt_prev) {
 			ret = deliver_skb(skb, pt_prev, orig_dev);
 			pt_prev = NULL;
 		}
-		if (vlan_do_receive(&skb))
+		ret2 = vlan_do_receive(pskb);
+		skb = *pskb;
+		if (ret2)
 			goto another_round;
 		else if (unlikely(!skb))
 			goto out;
@@ -4903,11 +4909,14 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 
 	rx_handler = rcu_dereference(skb->dev->rx_handler);
 	if (rx_handler) {
+		rx_handler_result_t res;
 		if (pt_prev) {
 			ret = deliver_skb(skb, pt_prev, orig_dev);
 			pt_prev = NULL;
 		}
-		switch (rx_handler(&skb)) {
+		res = rx_handler(pskb);
+		skb = *pskb;
+		switch (res) {
 		case RX_HANDLER_CONSUMED:
 			ret = NET_RX_SUCCESS;
 			goto out;
@@ -4931,15 +4940,20 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
 			skb->pkt_type = PACKET_OTHERHOST;
 		} else if (skb->protocol == cpu_to_be16(ETH_P_8021Q) ||
 			   skb->protocol == cpu_to_be16(ETH_P_8021AD)) {
+			bool ret2;
+
 			/* Outer header is 802.1P with vlan 0, inner header is
 			 * 802.1Q or 802.1AD and vlan_do_receive() above could
 			 * not find vlan dev for vlan id 0.
 			 */
 			__vlan_hwaccel_clear_tag(skb);
 			skb = skb_vlan_untag(skb);
+			*pskb = skb;
 			if (unlikely(!skb))
 				goto out;
-			if (vlan_do_receive(&skb))
+			ret2 = vlan_do_receive(pskb);
+			skb = *pskb;
+			if (ret2)
 				/* After stripping off 802.1P header with vlan 0
 				 * vlan dev is found for inner header.
 				 */
@@ -5004,7 +5018,7 @@ static int __netif_receive_skb_one_core(struct sk_buff *skb, bool pfmemalloc)
 	struct packet_type *pt_prev = NULL;
 	int ret;
 
-	ret = __netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+	ret = __netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 	if (pt_prev)
 		ret = INDIRECT_CALL_INET(pt_prev->func, ipv6_rcv, ip_rcv, skb,
 					 skb->dev, pt_prev, orig_dev);
@@ -5082,7 +5096,7 @@ static void __netif_receive_skb_list_core(struct list_head *head, bool pfmemallo
 		struct packet_type *pt_prev = NULL;
 
 		skb_list_del_init(skb);
-		__netif_receive_skb_core(skb, pfmemalloc, &pt_prev);
+		__netif_receive_skb_core(&skb, pfmemalloc, &pt_prev);
 		if (!pt_prev)
 			continue;
 		if (pt_curr != pt_prev || od_curr != orig_dev) {
-- 
2.22.0

