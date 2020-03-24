Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13E6A190F37
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 14:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgCXNSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 09:18:35 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:52818 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728735AbgCXNSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 09:18:32 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jGjRt-0000Da-Qt; Tue, 24 Mar 2020 14:18:29 +0100
Date:   Tue, 24 Mar 2020 14:18:29 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Martin Zaharinov <micron10@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: Bug URGENT Report with new kernel 5.5.10-5.6-rc6
Message-ID: <20200324131829.GF3305@breakpoint.cc>
References: <20200319003823.3b709ad8@elisabeth>
 <CALidq=Xow0EkAP4LkqvQiDOmVDduEwLKa4c-A54or3GMj6+qVw@mail.gmail.com>
 <20200319103438.GO979@breakpoint.cc>
 <20200319104750.x2zz7negjbm6lwch@salvia>
 <20200319105248.GP979@breakpoint.cc>
 <fff10500-8b87-62f0-ec89-49453cf9ae57@gmail.com>
 <4d9f339c-b0a7-1861-7d76-e0f2cee92b8c@gmail.com>
 <CALidq=VJuhEPO-FWOuUdSG+-VO+h7VHfmtQiAxikxH+vMB+vdQ@mail.gmail.com>
 <CALidq=Wq3FaGPbbjDvcjvw3V=yPWNMPDeFFy-bDL6fffdjb2rw@mail.gmail.com>
 <CALidq=VYSt3WbtapwL-n8cG71=ysYDJTo3L---xj4U1rEC63KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALidq=VYSt3WbtapwL-n8cG71=ysYDJTo3L---xj4U1rEC63KQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin Zaharinov <micron10@gmail.com> wrote:
> Hi All
> More information :
> 
> After this bug one of cpu goin lock and load on 100%
> After reboot machine start and work fine but after go to load time night
> when user is online machine get in dmesg same crash log and go to lock
> other cpu
> Hear is bug report :
> 
> 
> [21542.828151] ------------[ cut here ]------------
> [21542.828979] refcount_t: underflow; use-after-free.
> [21542.829840] WARNING: CPU: 52 PID: 0 at lib/refcount.c:28
> refcount_warn_saturate+0xd8/0xe0
> [21542.831211] Modules linked in: udp_diag raw_diag unix_diag
> af_packet_diag sch_hfsc iptable_filter xt_IMQ iptable_mangle xt_addrtype
> xt_nat xt_MASQUERADE iptable_nat ip_tables bpfilter  sch_fq_pie sch_pie
> netconsole imq r8169 realtek tg3 igb i2c_algo_bit ixgbe mdio libphy
> nf_nat_sip nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_tftp
> nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack
> nf_defrag_ipv6 nf_defrag_ipv4 pppoe pptp gre pppox ppp_mppe ppp_generic
> slhc libarc4 tun megaraid_sas ipmi_si ipmi_devintf ipmi_msghandler
> sch_fq_codel

Does this patch help?

diff --git a/include/net/netfilter/nf_queue.h b/include/net/netfilter/nf_queue.h
--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -14,7 +14,10 @@ struct nf_queue_entry {
 	struct sk_buff		*skb;
 	unsigned int		id;
 	unsigned int		hook_index;	/* index in hook_entries->hook[] */
-
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	struct net_device	*physin;
+	struct net_device	*physout;
+#endif
 	struct nf_hook_state	state;
 	u16			size; /* sizeof(entry) + saved route keys */
 
@@ -35,7 +38,7 @@ void nf_unregister_queue_handler(struct net *net);
 void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict);
 
 void nf_queue_entry_get_refs(struct nf_queue_entry *entry);
-void nf_queue_entry_release_refs(struct nf_queue_entry *entry);
+void nf_queue_entry_free(struct nf_queue_entry *entry);
 
 static inline void init_hashrandom(u32 *jhash_initval)
 {
diff --git a/net/netfilter/nf_queue.c b/net/netfilter/nf_queue.c
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -46,25 +46,7 @@ void nf_unregister_queue_handler(struct net *net)
 }
 EXPORT_SYMBOL(nf_unregister_queue_handler);
 
-static void nf_queue_entry_release_br_nf_refs(struct sk_buff *skb)
-{
-#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
-
-	if (nf_bridge) {
-		struct net_device *physdev;
-
-		physdev = nf_bridge_get_physindev(skb);
-		if (physdev)
-			dev_put(physdev);
-		physdev = nf_bridge_get_physoutdev(skb);
-		if (physdev)
-			dev_put(physdev);
-	}
-#endif
-}
-
-void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
+static void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 {
 	struct nf_hook_state *state = &entry->state;
 
@@ -76,24 +58,34 @@ void nf_queue_entry_release_refs(struct nf_queue_entry *entry)
 	if (state->sk)
 		sock_put(state->sk);
 
-	nf_queue_entry_release_br_nf_refs(entry->skb);
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (entry->physin)
+		dev_put(entry->physin);
+	if (entry->physout)
+		dev_put(entry->physout);
+#endif
 }
-EXPORT_SYMBOL_GPL(nf_queue_entry_release_refs);
 
-static void nf_queue_entry_get_br_nf_refs(struct sk_buff *skb)
+void nf_queue_entry_free(struct nf_queue_entry *entry)
+{
+	nf_queue_entry_release_refs(entry);
+	kfree(entry);
+}
+EXPORT_SYMBOL_GPL(nf_queue_entry_free);
+
+static void __nf_queue_entry_init_physdevs(struct nf_queue_entry *entry)
 {
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
+	const struct sk_buff *skb = entry->skb;
+	struct nf_bridge_info *nf_bridge;
 
+	nf_bridge = nf_bridge_info_get(skb);
 	if (nf_bridge) {
-		struct net_device *physdev;
-
-		physdev = nf_bridge_get_physindev(skb);
-		if (physdev)
-			dev_hold(physdev);
-		physdev = nf_bridge_get_physoutdev(skb);
-		if (physdev)
-			dev_hold(physdev);
+		entry->physin = nf_bridge_get_physindev(skb);
+		entry->physout = nf_bridge_get_physoutdev(skb);
+	} else {
+		entry->physin = NULL;
+		entry->physout = NULL;
 	}
 #endif
 }
@@ -110,7 +102,12 @@ void nf_queue_entry_get_refs(struct nf_queue_entry *entry)
 	if (state->sk)
 		sock_hold(state->sk);
 
-	nf_queue_entry_get_br_nf_refs(entry->skb);
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	if (entry->physin)
+		dev_hold(entry->physin);
+	if (entry->physout)
+		dev_hold(entry->physout);
+#endif
 }
 EXPORT_SYMBOL_GPL(nf_queue_entry_get_refs);
 
@@ -201,6 +198,8 @@ static int __nf_queue(struct sk_buff *skb, const struct nf_hook_state *state,
 		.size	= sizeof(*entry) + route_key_size,
 	};
 
+	__nf_queue_entry_init_physdevs(entry);
+
 	nf_queue_entry_get_refs(entry);
 
 	switch (entry->state.pf) {
@@ -304,12 +303,10 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
-	nf_queue_entry_release_refs(entry);
-
 	i = entry->hook_index;
 	if (WARN_ON_ONCE(!hooks || i >= hooks->num_hook_entries)) {
 		kfree_skb(skb);
-		kfree(entry);
+		nf_queue_entry_free(entry);
 		return;
 	}
 
@@ -348,6 +345,6 @@ void nf_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 		kfree_skb(skb);
 	}
 
-	kfree(entry);
+	nf_queue_entry_free(entry);
 }
 EXPORT_SYMBOL(nf_reinject);
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 76535fd9278c..3243a31f6e82 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -737,12 +737,6 @@ static void nf_bridge_adjust_segmented_data(struct sk_buff *skb)
 #define nf_bridge_adjust_segmented_data(s) do {} while (0)
 #endif
 
-static void free_entry(struct nf_queue_entry *entry)
-{
-	nf_queue_entry_release_refs(entry);
-	kfree(entry);
-}
-
 static int
 __nfqnl_enqueue_packet_gso(struct net *net, struct nfqnl_instance *queue,
 			   struct sk_buff *skb, struct nf_queue_entry *entry)
@@ -768,7 +762,7 @@ __nfqnl_enqueue_packet_gso(struct net *net, struct nfqnl_instance *queue,
 		entry_seg->skb = skb;
 		ret = __nfqnl_enqueue_packet(net, queue, entry_seg);
 		if (ret)
-			free_entry(entry_seg);
+			nf_queue_entry_free(entry_seg);
 	}
 	return ret;
 }
@@ -827,7 +821,7 @@ nfqnl_enqueue_packet(struct nf_queue_entry *entry, unsigned int queuenum)
 
 	if (queued) {
 		if (err) /* some segments are already queued */
-			free_entry(entry);
+			nf_queue_entry_free(entry);
 		kfree_skb(skb);
 		return 0;
 	}
