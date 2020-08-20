Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F01A924C37A
	for <lists+netdev@lfdr.de>; Thu, 20 Aug 2020 18:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbgHTQlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 12:41:32 -0400
Received: from bmailout3.hostsharing.net ([176.9.242.62]:58753 "EHLO
        bmailout3.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728209AbgHTQl1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 12:41:27 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Aug 2020 12:41:27 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout3.hostsharing.net (Postfix) with ESMTPS id 9F20C102F2492;
        Thu, 20 Aug 2020 18:35:23 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 389C9314423; Thu, 20 Aug 2020 18:35:23 +0200 (CEST)
Date:   Thu, 20 Aug 2020 18:35:23 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Laura Garcia <nevola@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next 3/3] netfilter: Introduce egress hook
Message-ID: <20200820163523.3dbiq2jwi7enpyu3@wunner.de>
References: <cover.1583927267.git.lukas@wunner.de>
 <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
 <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net>
 <20200313145526.ikovaalfuy7rnkdl@salvia>
 <1bd50836-33c4-da44-5771-654bfb0348cc@iogearbox.net>
 <20200315132836.cj36ape6rpw33iqb@salvia>
 <CAF90-WgoteQXB9WQmeT1eOHA3GpPbwPCEvNzwKkN20WqpdHW-A@mail.gmail.com>
 <20200423160542.d3f6yef4av2gqvur@wunner.de>
 <1a27351b-78a8-febc-45d7-6ee2e8ebda9e@iogearbox.net>
 <20200820103701.on5rqxawqqc7kwdw@wunner.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200820103701.on5rqxawqqc7kwdw@wunner.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 12:37:01PM +0200, Lukas Wunner wrote:
> I need a few more days to update the commit messages, perform further
> testing and apply polish, so I plan to dump the patches to the list
> next week.  Just thought I'd ask for your opinion, I'm aware this is
> difficult to judge without seeing the code.

FWIW, the code for the first variant is in the top-most commit on the
following branch:

https://github.com/l1k/linux/commits/nft_egress_v3

Again, it gives the best performance if neither nft nor tc classifying
is enabled on egress, but incurs a small performance degradation for
the tc-only case.  Ignore the commit message, I haven't updated it yet.

And to get the second variant, the following patch needs to be applied
with "patch -R -p1".  This variant speeds up the normal case but not by
as much, also speeds up tc, has worse performance for nft.  It doesn't
use a static_key for tc, save for the outer one (shared with nft),
hence no performance degradation for the tc-only case.

-- >8 --
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 93e63e756771..ef2cc21a0f11 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -785,6 +785,10 @@ struct xps_dev_maps {
 
 #endif /* CONFIG_XPS */
 
+#ifdef CONFIG_NET_EGRESS
+extern struct static_key_false egress_needed_key;
+#endif
+
 #define TC_MAX_QUEUE	16
 #define TC_BITMASK	15
 /* HW offloaded queuing disciplines txq count and offset maps */
diff --git a/include/linux/rtnetlink.h b/include/linux/rtnetlink.h
index bb9cb84114c1..49fe4f3b8fbd 100644
--- a/include/linux/rtnetlink.h
+++ b/include/linux/rtnetlink.h
@@ -97,7 +97,7 @@ void net_inc_ingress_queue(void);
 void net_dec_ingress_queue(void);
 #endif
 
-#ifdef CONFIG_NET_EGRESS
+#ifdef CONFIG_NET_SCH_EGRESS
 void net_inc_egress_queue(void);
 void net_dec_egress_queue(void);
 #endif
diff --git a/net/core/dev.c b/net/core/dev.c
index a7e2ff191481..f1ac84beef76 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1815,20 +1815,30 @@ EXPORT_SYMBOL_GPL(net_dec_ingress_queue);
 #endif
 
 #ifdef CONFIG_NET_EGRESS
-static DEFINE_STATIC_KEY_FALSE(egress_needed_key);
+DEFINE_STATIC_KEY_FALSE(egress_needed_key);
+
+#ifdef CONFIG_NET_SCH_EGRESS
+static DEFINE_STATIC_KEY_FALSE(sch_egress_needed_key);
 
 void net_inc_egress_queue(void)
 {
 	static_branch_inc(&egress_needed_key);
+	static_branch_inc(&sch_egress_needed_key);
 }
 EXPORT_SYMBOL_GPL(net_inc_egress_queue);
 
 void net_dec_egress_queue(void)
 {
+	static_branch_dec(&sch_egress_needed_key);
 	static_branch_dec(&egress_needed_key);
 }
 EXPORT_SYMBOL_GPL(net_dec_egress_queue);
-#endif
+
+#define sch_egress_needed static_branch_likely(&sch_egress_needed_key)
+#else
+#define sch_egress_needed false
+#endif /* CONFIG_NET_SCH_EGRESS */
+#endif /* CONFIG_NET_EGRESS */
 
 static DEFINE_STATIC_KEY_FALSE(netstamp_needed_key);
 #ifdef CONFIG_JUMP_LABEL
@@ -3604,7 +3614,7 @@ static int nf_egress(struct sk_buff *skb)
 static inline struct sk_buff *
 sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 {
-#ifdef CONFIG_NET_CLS_ACT
+#ifdef CONFIG_NET_SCH_EGRESS
 	struct mini_Qdisc *miniq = rcu_dereference_bh(dev->miniq_egress);
 	struct tcf_result cl_res;
 
@@ -3638,7 +3648,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	default:
 		break;
 	}
-#endif /* CONFIG_NET_CLS_ACT */
+#endif /* CONFIG_NET_SCH_EGRESS */
 
 	return skb;
 }
@@ -3655,7 +3665,10 @@ nf_sch_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 			return NULL;
 	}
 
-	return sch_handle_egress(skb, ret, dev);
+	if (sch_egress_needed)
+		return sch_handle_egress(skb, ret, dev);
+
+	return skb;
 }
 #endif /* CONFIG_NET_EGRESS */
 
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index a78a439e4fdd..8e7d5eed663c 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -358,7 +358,7 @@ static int __nf_register_net_hook(struct net *net, int pf,
 #endif
 #ifdef CONFIG_NETFILTER_EGRESS
 	if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EGRESS)
-		net_inc_egress_queue();
+		static_branch_inc(&egress_needed_key);
 #endif
 #ifdef CONFIG_JUMP_LABEL
 	static_key_slow_inc(&nf_hooks_needed[pf][reg->hooknum]);
@@ -420,7 +420,7 @@ static void __nf_unregister_net_hook(struct net *net, int pf,
 #endif
 #ifdef CONFIG_NETFILTER_EGRESS
 		if (pf == NFPROTO_NETDEV && reg->hooknum == NF_NETDEV_EGRESS)
-			net_dec_egress_queue();
+			static_branch_dec(&egress_needed_key);
 #endif
 #ifdef CONFIG_JUMP_LABEL
 		static_key_slow_dec(&nf_hooks_needed[pf][reg->hooknum]);
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index afd2ba157a13..806d5d60fc9a 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -383,6 +383,9 @@ config NET_SCH_INGRESS
 	  To compile this code as a module, choose M here: the module will be
 	  called sch_ingress with alias of sch_clsact.
 
+config NET_SCH_EGRESS
+	def_bool NET_SCH_INGRESS
+
 config NET_SCH_PLUG
 	tristate "Plug network traffic until release (PLUG)"
 	---help---
