Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 235E7C912C
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 20:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729043AbfJBSxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 14:53:55 -0400
Received: from correo.us.es ([193.147.175.20]:52770 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728000AbfJBSxy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Oct 2019 14:53:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D281A15AEA4
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 20:53:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BDC71DA4D0
        for <netdev@vger.kernel.org>; Wed,  2 Oct 2019 20:53:49 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B3709DA801; Wed,  2 Oct 2019 20:53:49 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E303DA4CA;
        Wed,  2 Oct 2019 20:53:47 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 02 Oct 2019 20:53:47 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 23B8E42EE38E;
        Wed,  2 Oct 2019 20:53:47 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/2] netfilter: drop bridge nf reset from nf_reset
Date:   Wed,  2 Oct 2019 20:53:44 +0200
Message-Id: <20191002185345.3137-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191002185345.3137-1-pablo@netfilter.org>
References: <20191002185345.3137-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 174e23810cd31
("sk_buff: drop all skb extensions on free and skb scrubbing") made napi
recycle always drop skb extensions.  The additional skb_ext_del() that is
performed via nf_reset on napi skb recycle is not needed anymore.

Most nf_reset() calls in the stack are there so queued skb won't block
'rmmod nf_conntrack' indefinitely.

This removes the skb_ext_del from nf_reset, and renames it to a more
fitting nf_reset_ct().

In a few selected places, add a call to skb_ext_reset to make sure that
no active extensions remain.

I am submitting this for "net", because we're still early in the release
cycle.  The patch applies to net-next too, but I think the rename causes
needless divergence between those trees.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 drivers/net/ppp/pptp.c                | 4 ++--
 drivers/net/tun.c                     | 2 +-
 drivers/net/virtio_net.c              | 2 +-
 drivers/net/vrf.c                     | 8 ++++----
 drivers/net/wireless/mac80211_hwsim.c | 4 ++--
 drivers/staging/octeon/ethernet-tx.c  | 6 ++----
 include/linux/skbuff.h                | 5 +----
 net/batman-adv/soft-interface.c       | 2 +-
 net/core/skbuff.c                     | 2 +-
 net/dccp/ipv4.c                       | 2 +-
 net/ipv4/ip_input.c                   | 2 +-
 net/ipv4/ipmr.c                       | 4 ++--
 net/ipv4/netfilter/nf_dup_ipv4.c      | 2 +-
 net/ipv4/raw.c                        | 2 +-
 net/ipv4/tcp_ipv4.c                   | 2 +-
 net/ipv4/udp.c                        | 4 ++--
 net/ipv6/ip6_input.c                  | 2 +-
 net/ipv6/netfilter/nf_dup_ipv6.c      | 2 +-
 net/ipv6/raw.c                        | 2 +-
 net/l2tp/l2tp_core.c                  | 2 +-
 net/l2tp/l2tp_eth.c                   | 2 +-
 net/l2tp/l2tp_ip.c                    | 2 +-
 net/l2tp/l2tp_ip6.c                   | 2 +-
 net/netfilter/ipvs/ip_vs_xmit.c       | 2 +-
 net/openvswitch/vport-internal_dev.c  | 2 +-
 net/packet/af_packet.c                | 4 ++--
 net/sctp/input.c                      | 2 +-
 net/xfrm/xfrm_input.c                 | 2 +-
 net/xfrm/xfrm_interface.c             | 2 +-
 net/xfrm/xfrm_output.c                | 2 +-
 net/xfrm/xfrm_policy.c                | 2 +-
 31 files changed, 40 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ppp/pptp.c b/drivers/net/ppp/pptp.c
index 734de7de03f7..e1fabb3e3246 100644
--- a/drivers/net/ppp/pptp.c
+++ b/drivers/net/ppp/pptp.c
@@ -238,7 +238,7 @@ static int pptp_xmit(struct ppp_channel *chan, struct sk_buff *skb)
 	skb_dst_drop(skb);
 	skb_dst_set(skb, &rt->dst);
 
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	skb->ip_summed = CHECKSUM_NONE;
 	ip_select_ident(net, skb, NULL);
@@ -358,7 +358,7 @@ static int pptp_rcv(struct sk_buff *skb)
 	po = lookup_chan(htons(header->call_id), iph->saddr);
 	if (po) {
 		skb_dst_drop(skb);
-		nf_reset(skb);
+		nf_reset_ct(skb);
 		return sk_receive_skb(sk_pppox(po), skb, 0);
 	}
 drop:
diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index aab0be40d443..812dc3a65efb 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1104,7 +1104,7 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	skb_orphan(skb);
 
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	if (ptr_ring_produce(&tfile->tx_ring, skb))
 		goto drop;
diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ba98e0971b84..5a635f028bdc 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -1585,7 +1585,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* Don't wait up for transmitted skbs to be freed. */
 	if (!use_napi) {
 		skb_orphan(skb);
-		nf_reset(skb);
+		nf_reset_ct(skb);
 	}
 
 	/* If running out of space, stop queue to avoid getting packets that we
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index a4b38a980c3c..ee52bde058df 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -366,7 +366,7 @@ static int vrf_finish_output6(struct net *net, struct sock *sk,
 	struct neighbour *neigh;
 	int ret;
 
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	skb->protocol = htons(ETH_P_IPV6);
 	skb->dev = dev;
@@ -459,7 +459,7 @@ static struct sk_buff *vrf_ip6_out_direct(struct net_device *vrf_dev,
 
 	/* reset skb device */
 	if (likely(err == 1))
-		nf_reset(skb);
+		nf_reset_ct(skb);
 	else
 		skb = NULL;
 
@@ -560,7 +560,7 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	bool is_v6gw = false;
 	int ret = -EINVAL;
 
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(skb_headroom(skb) < hh_len && dev->header_ops)) {
@@ -670,7 +670,7 @@ static struct sk_buff *vrf_ip_out_direct(struct net_device *vrf_dev,
 
 	/* reset skb device */
 	if (likely(err == 1))
-		nf_reset(skb);
+		nf_reset_ct(skb);
 	else
 		skb = NULL;
 
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 635956024e88..45c73a6f09a1 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1261,8 +1261,8 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	skb_orphan(skb);
 	skb_dst_drop(skb);
 	skb->mark = 0;
-	secpath_reset(skb);
-	nf_reset(skb);
+	skb_ext_reset(skb);
+	nf_reset_ct(skb);
 
 	/*
 	 * Get absolute mactime here so all HWs RX at the "same time", and
diff --git a/drivers/staging/octeon/ethernet-tx.c b/drivers/staging/octeon/ethernet-tx.c
index c64728fc21f2..a62057555d1b 100644
--- a/drivers/staging/octeon/ethernet-tx.c
+++ b/drivers/staging/octeon/ethernet-tx.c
@@ -349,10 +349,8 @@ int cvm_oct_xmit(struct sk_buff *skb, struct net_device *dev)
 	 */
 	dst_release(skb_dst(skb));
 	skb_dst_set(skb, NULL);
-#ifdef CONFIG_XFRM
-	secpath_reset(skb);
-#endif
-	nf_reset(skb);
+	skb_ext_reset(skb);
+	nf_reset_ct(skb);
 
 #ifdef CONFIG_NET_SCHED
 	skb->tc_index = 0;
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index e7d3b1a513ef..4351577b14d7 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4160,15 +4160,12 @@ static inline void __skb_ext_copy(struct sk_buff *d, const struct sk_buff *s) {}
 static inline void skb_ext_copy(struct sk_buff *dst, const struct sk_buff *s) {}
 #endif /* CONFIG_SKB_EXTENSIONS */
 
-static inline void nf_reset(struct sk_buff *skb)
+static inline void nf_reset_ct(struct sk_buff *skb)
 {
 #if defined(CONFIG_NF_CONNTRACK) || defined(CONFIG_NF_CONNTRACK_MODULE)
 	nf_conntrack_put(skb_nfct(skb));
 	skb->_nfct = 0;
 #endif
-#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	skb_ext_del(skb, SKB_EXT_BRIDGE_NF);
-#endif
 }
 
 static inline void nf_reset_trace(struct sk_buff *skb)
diff --git a/net/batman-adv/soft-interface.c b/net/batman-adv/soft-interface.c
index a1146cb10919..9cbed6f5a85a 100644
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -436,7 +436,7 @@ void batadv_interface_rx(struct net_device *soft_iface,
 	/* clean the netfilter state now that the batman-adv header has been
 	 * removed
 	 */
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	if (unlikely(!pskb_may_pull(skb, ETH_HLEN)))
 		goto dropped;
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 01d65206f4fb..529133611ea2 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5120,7 +5120,7 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->ignore_df = 0;
 	skb_dst_drop(skb);
 	skb_ext_reset(skb);
-	nf_reset(skb);
+	nf_reset_ct(skb);
 	nf_reset_trace(skb);
 
 #ifdef CONFIG_NET_SWITCHDEV
diff --git a/net/dccp/ipv4.c b/net/dccp/ipv4.c
index b685bc82f8d0..d9b4200ed12d 100644
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -871,7 +871,7 @@ static int dccp_v4_rcv(struct sk_buff *skb)
 
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	return __sk_receive_skb(sk, skb, 1, dh->dccph_doff * 4, refcounted);
 
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 1e2392b7c64e..c59a78a267c3 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -199,7 +199,7 @@ void ip_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int protocol)
 				kfree_skb(skb);
 				return;
 			}
-			nf_reset(skb);
+			nf_reset_ct(skb);
 		}
 		ret = INDIRECT_CALL_2(ipprot->handler, tcp_v4_rcv, udp_rcv,
 				      skb);
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 313470f6bb14..716d5472c022 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1794,7 +1794,7 @@ static void ip_encap(struct net *net, struct sk_buff *skb,
 	ip_send_check(iph);
 
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
-	nf_reset(skb);
+	nf_reset_ct(skb);
 }
 
 static inline int ipmr_forward_finish(struct net *net, struct sock *sk,
@@ -2140,7 +2140,7 @@ int ip_mr_input(struct sk_buff *skb)
 
 			mroute_sk = rcu_dereference(mrt->mroute_sk);
 			if (mroute_sk) {
-				nf_reset(skb);
+				nf_reset_ct(skb);
 				raw_rcv(mroute_sk, skb);
 				return 0;
 			}
diff --git a/net/ipv4/netfilter/nf_dup_ipv4.c b/net/ipv4/netfilter/nf_dup_ipv4.c
index af3fbf76dbd3..6cc5743c553a 100644
--- a/net/ipv4/netfilter/nf_dup_ipv4.c
+++ b/net/ipv4/netfilter/nf_dup_ipv4.c
@@ -65,7 +65,7 @@ void nf_dup_ipv4(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
 	/* Avoid counting cloned packets towards the original connection. */
-	nf_reset(skb);
+	nf_reset_ct(skb);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 #endif
 	/*
diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 80da5a66d5d7..3183413ebc6c 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -332,7 +332,7 @@ int raw_rcv(struct sock *sk, struct sk_buff *skb)
 		kfree_skb(skb);
 		return NET_RX_DROP;
 	}
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	skb_push(skb, skb->data - skb_network_header(skb));
 
diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 2ee45e3755e9..bf124b1742df 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1916,7 +1916,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
 	if (tcp_v4_inbound_md5_hash(sk, skb))
 		goto discard_and_relse;
 
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	if (tcp_filter(sk, skb))
 		goto discard_and_relse;
diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
index cf755156a684..e8443cc5c1ab 100644
--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1969,7 +1969,7 @@ static int udp_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	 */
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto drop;
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	if (static_branch_unlikely(&udp_encap_needed_key) && up->encap_type) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
@@ -2298,7 +2298,7 @@ int __udp4_lib_rcv(struct sk_buff *skb, struct udp_table *udptable,
 
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
 		goto drop;
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	/* No socket. Drop packet silently, if checksum is wrong */
 	if (udp_lib_checksum_complete(skb))
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index d432d0011c16..7e5df23cbe7b 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -371,7 +371,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			/* Free reference early: we don't need it any more,
 			   and it may hold ip_conntrack module loaded
 			   indefinitely. */
-			nf_reset(skb);
+			nf_reset_ct(skb);
 
 			skb_postpull_rcsum(skb, skb_network_header(skb),
 					   skb_network_header_len(skb));
diff --git a/net/ipv6/netfilter/nf_dup_ipv6.c b/net/ipv6/netfilter/nf_dup_ipv6.c
index e6c9da9866b1..a0a2de30be3e 100644
--- a/net/ipv6/netfilter/nf_dup_ipv6.c
+++ b/net/ipv6/netfilter/nf_dup_ipv6.c
@@ -54,7 +54,7 @@ void nf_dup_ipv6(struct net *net, struct sk_buff *skb, unsigned int hooknum,
 		return;
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-	nf_reset(skb);
+	nf_reset_ct(skb);
 	nf_ct_set(skb, NULL, IP_CT_UNTRACKED);
 #endif
 	if (hooknum == NF_INET_PRE_ROUTING ||
diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
index 6e1888ee4036..a77f6b7d3a7c 100644
--- a/net/ipv6/raw.c
+++ b/net/ipv6/raw.c
@@ -215,7 +215,7 @@ static bool ipv6_raw_deliver(struct sk_buff *skb, int nexthdr)
 
 			/* Not releasing hash table! */
 			if (clone) {
-				nf_reset(clone);
+				nf_reset_ct(clone);
 				rawv6_rcv(sk, clone);
 			}
 		}
diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 105e5a7092e7..f82ea12bac37 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1078,7 +1078,7 @@ int l2tp_xmit_skb(struct l2tp_session *session, struct sk_buff *skb, int hdr_len
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED |
 			      IPSKB_REROUTED);
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	bh_lock_sock(sk);
 	if (sock_owned_by_user(sk)) {
diff --git a/net/l2tp/l2tp_eth.c b/net/l2tp/l2tp_eth.c
index bd3f39349d40..fd5ac2788e45 100644
--- a/net/l2tp/l2tp_eth.c
+++ b/net/l2tp/l2tp_eth.c
@@ -151,7 +151,7 @@ static void l2tp_eth_dev_recv(struct l2tp_session *session, struct sk_buff *skb,
 	skb->ip_summed = CHECKSUM_NONE;
 
 	skb_dst_drop(skb);
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	rcu_read_lock();
 	dev = rcu_dereference(spriv->dev);
diff --git a/net/l2tp/l2tp_ip.c b/net/l2tp/l2tp_ip.c
index 622833317dcb..0d7c887a2b75 100644
--- a/net/l2tp/l2tp_ip.c
+++ b/net/l2tp/l2tp_ip.c
@@ -193,7 +193,7 @@ static int l2tp_ip_recv(struct sk_buff *skb)
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_put;
 
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	return sk_receive_skb(sk, skb, 1);
 
diff --git a/net/l2tp/l2tp_ip6.c b/net/l2tp/l2tp_ip6.c
index 687e23a8b326..802f19aba7e3 100644
--- a/net/l2tp/l2tp_ip6.c
+++ b/net/l2tp/l2tp_ip6.c
@@ -206,7 +206,7 @@ static int l2tp_ip6_recv(struct sk_buff *skb)
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_put;
 
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	return sk_receive_skb(sk, skb, 1);
 
diff --git a/net/netfilter/ipvs/ip_vs_xmit.c b/net/netfilter/ipvs/ip_vs_xmit.c
index 9c464d24beec..888d3068a492 100644
--- a/net/netfilter/ipvs/ip_vs_xmit.c
+++ b/net/netfilter/ipvs/ip_vs_xmit.c
@@ -613,7 +613,7 @@ static inline int ip_vs_tunnel_xmit_prepare(struct sk_buff *skb,
 	if (unlikely(cp->flags & IP_VS_CONN_F_NFCT))
 		ret = ip_vs_confirm_conntrack(skb);
 	if (ret == NF_ACCEPT) {
-		nf_reset(skb);
+		nf_reset_ct(skb);
 		skb_forward_csum(skb);
 	}
 	return ret;
diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
index d2437b5b2f6a..21c90d3a7ebf 100644
--- a/net/openvswitch/vport-internal_dev.c
+++ b/net/openvswitch/vport-internal_dev.c
@@ -237,7 +237,7 @@ static netdev_tx_t internal_dev_recv(struct sk_buff *skb)
 	}
 
 	skb_dst_drop(skb);
-	nf_reset(skb);
+	nf_reset_ct(skb);
 	secpath_reset(skb);
 
 	skb->pkt_type = PACKET_HOST;
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index e2742b006d25..82a50e850245 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -1821,7 +1821,7 @@ static int packet_rcv_spkt(struct sk_buff *skb, struct net_device *dev,
 	skb_dst_drop(skb);
 
 	/* drop conntrack reference */
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	spkt = &PACKET_SKB_CB(skb)->sa.pkt;
 
@@ -2121,7 +2121,7 @@ static int packet_rcv(struct sk_buff *skb, struct net_device *dev,
 	skb_dst_drop(skb);
 
 	/* drop conntrack reference */
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	spin_lock(&sk->sk_receive_queue.lock);
 	po->stats.stats1.tp_packets++;
diff --git a/net/sctp/input.c b/net/sctp/input.c
index 1008cdc44dd6..5a070fb5b278 100644
--- a/net/sctp/input.c
+++ b/net/sctp/input.c
@@ -201,7 +201,7 @@ int sctp_rcv(struct sk_buff *skb)
 
 	if (!xfrm_policy_check(sk, XFRM_POLICY_IN, skb, family))
 		goto discard_release;
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	if (sk_filter(sk, skb))
 		goto discard_release;
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 6088bc2dc11e..9b599ed66d97 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -706,7 +706,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 	if (err)
 		goto drop;
 
-	nf_reset(skb);
+	nf_reset_ct(skb);
 
 	if (decaps) {
 		sp = skb_sec_path(skb);
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index 2ab4859df55a..0f5131bc3342 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -185,7 +185,7 @@ static void xfrmi_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->skb_iif = 0;
 	skb->ignore_df = 0;
 	skb_dst_drop(skb);
-	nf_reset(skb);
+	nf_reset_ct(skb);
 	nf_reset_trace(skb);
 
 	if (!xnet)
diff --git a/net/xfrm/xfrm_output.c b/net/xfrm/xfrm_output.c
index 9499b35feb92..b1db55b50ba1 100644
--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -502,7 +502,7 @@ int xfrm_output_resume(struct sk_buff *skb, int err)
 	struct net *net = xs_net(skb_dst(skb)->xfrm);
 
 	while (likely((err = xfrm_output_one(skb, err)) == 0)) {
-		nf_reset(skb);
+		nf_reset_ct(skb);
 
 		err = skb_dst(skb)->ops->local_out(net, skb->sk, skb);
 		if (unlikely(err != 1))
diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 21e939235b39..f2d1e573ea55 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2808,7 +2808,7 @@ static void xfrm_policy_queue_process(struct timer_list *t)
 			continue;
 		}
 
-		nf_reset(skb);
+		nf_reset_ct(skb);
 		skb_dst_drop(skb);
 		skb_dst_set(skb, dst);
 
-- 
2.11.0

