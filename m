Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E71865A8F77
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 09:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233712AbiIAHNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 03:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233425AbiIAHNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 03:13:02 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E08E193D;
        Thu,  1 Sep 2022 00:13:01 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oTeNo-0000XX-1S; Thu, 01 Sep 2022 09:13:00 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, netfilter-devel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        Harsh Modi <harshmodi@google.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net 2/4] netfilter: br_netfilter: Drop dst references before setting.
Date:   Thu,  1 Sep 2022 09:12:36 +0200
Message-Id: <20220901071238.3044-3-fw@strlen.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220901071238.3044-1-fw@strlen.de>
References: <20220901071238.3044-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harsh Modi <harshmodi@google.com>

The IPv6 path already drops dst in the daddr changed case, but the IPv4
path does not. This change makes the two code paths consistent.

Further, it is possible that there is already a metadata_dst allocated from
ingress that might already be attached to skbuff->dst while following
the bridge path. If it is not released before setting a new
metadata_dst, it will be leaked. This is similar to what is done in
bpf_set_tunnel_key() or ip6_route_input().

It is important to note that the memory being leaked is not the dst
being set in the bridge code, but rather memory allocated from some
other code path that is not being freed correctly before the skb dst is
overwritten.

An example of the leakage fixed by this commit found using kmemleak:

unreferenced object 0xffff888010112b00 (size 256):
  comm "softirq", pid 0, jiffies 4294762496 (age 32.012s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 80 16 f1 83 ff ff ff ff  ................
    e1 4e f6 82 ff ff ff ff 00 00 00 00 00 00 00 00  .N..............
  backtrace:
    [<00000000d79567ea>] metadata_dst_alloc+0x1b/0xe0
    [<00000000be113e13>] udp_tun_rx_dst+0x174/0x1f0
    [<00000000a36848f4>] geneve_udp_encap_recv+0x350/0x7b0
    [<00000000d4afb476>] udp_queue_rcv_one_skb+0x380/0x560
    [<00000000ac064aea>] udp_unicast_rcv_skb+0x75/0x90
    [<000000009a8ee8c5>] ip_protocol_deliver_rcu+0xd8/0x230
    [<00000000ef4980bb>] ip_local_deliver_finish+0x7a/0xa0
    [<00000000d7533c8c>] __netif_receive_skb_one_core+0x89/0xa0
    [<00000000a879497d>] process_backlog+0x93/0x190
    [<00000000e41ade9f>] __napi_poll+0x28/0x170
    [<00000000b4c0906b>] net_rx_action+0x14f/0x2a0
    [<00000000b20dd5d4>] __do_softirq+0xf4/0x305
    [<000000003a7d7e15>] __irq_exit_rcu+0xc3/0x140
    [<00000000968d39a2>] sysvec_apic_timer_interrupt+0x9e/0xc0
    [<000000009e920794>] asm_sysvec_apic_timer_interrupt+0x16/0x20
    [<000000008942add0>] native_safe_halt+0x13/0x20

Florian Westphal says: "Original code was likely fine because nothing
ever did set a skb->dst entry earlier than bridge in those days."

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Harsh Modi <harshmodi@google.com>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/br_netfilter_hooks.c | 2 ++
 net/bridge/br_netfilter_ipv6.c  | 1 +
 2 files changed, 3 insertions(+)

diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
index ff4779036649..f20f4373ff40 100644
--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -384,6 +384,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 				/* - Bridged-and-DNAT'ed traffic doesn't
 				 *   require ip_forwarding. */
 				if (rt->dst.dev == dev) {
+					skb_dst_drop(skb);
 					skb_dst_set(skb, &rt->dst);
 					goto bridged_dnat;
 				}
@@ -413,6 +414,7 @@ static int br_nf_pre_routing_finish(struct net *net, struct sock *sk, struct sk_
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index e4e0c836c3f5..6b07f30675bb 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -197,6 +197,7 @@ static int br_nf_pre_routing_finish_ipv6(struct net *net, struct sock *sk, struc
 			kfree_skb(skb);
 			return 0;
 		}
+		skb_dst_drop(skb);
 		skb_dst_set_noref(skb, &rt->dst);
 	}
 
-- 
2.35.1

