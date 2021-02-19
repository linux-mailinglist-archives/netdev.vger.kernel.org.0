Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1E3231F3FE
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 03:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbhBSC0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 21:26:32 -0500
Received: from mail.zx2c4.com ([104.131.123.232]:46464 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229474AbhBSC0a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Feb 2021 21:26:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1613701546;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=/OckHxmsc28+h06YDMyXqUWhKATMIQExJoICDdDFTiA=;
        b=oOAAmuHtw/bBiFmWBFQuTCRGNRHo11j+dCT8skvGLd+oBgsG7PwZ6rhq/DPQIovPV/rT9x
        RKZyYHWX49tgQ7QWKqtC1p90TaPft1+adqMVA/8e2uS23co45M9gnsQezbB+L6K5dXGc+o
        LT+aAYM+kStvCMLmjjhElGiEr6VtLlQ=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id ae796534 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 19 Feb 2021 02:25:45 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, SinYu <liuxyon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        David L Stevens <david.stevens@oracle.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH net v4] net: icmp: pass zeroed opts from icmp{,v6}_ndo_send before sending
Date:   Fri, 19 Feb 2021 03:25:32 +0100
Message-Id: <20210219022532.2446968-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The icmp{,v6}_send functions make all sorts of use of skb->cb, casting
it with IPCB or IP6CB, assuming the skb to have come directly from the
inet layer. But when the packet comes from the ndo layer, especially
when forwarded, there's no telling what might be in skb->cb at that
point. As a result, the icmp sending code risks reading bogus memory
contents, which can result in nasty stack overflows such as this one
reported by a user:

    panic+0x108/0x2ea
    __stack_chk_fail+0x14/0x20
    __icmp_send+0x5bd/0x5c0
    icmp_ndo_send+0x148/0x160

In icmp_send, skb->cb is cast with IPCB and an ip_options struct is read
from it. The optlen parameter there is of particular note, as it can
induce writes beyond bounds. There are quite a few ways that can happen
in __ip_options_echo. For example:

    // sptr/skb are attacker-controlled skb bytes
    sptr = skb_network_header(skb);
    // dptr/dopt points to stack memory allocated by __icmp_send
    dptr = dopt->__data;
    // sopt is the corrupt skb->cb in question
    if (sopt->rr) {
        optlen  = sptr[sopt->rr+1]; // corrupt skb->cb + skb->data
        soffset = sptr[sopt->rr+2]; // corrupt skb->cb + skb->data
	// this now writes potentially attacker-controlled data, over
	// flowing the stack:
        memcpy(dptr, sptr+sopt->rr, optlen);
    }

In the icmpv6_send case, the story is similar, but not as dire, as only
IP6CB(skb)->iif and IP6CB(skb)->dsthao are used. The dsthao case is
worse than the iif case, but it is passed to ipv6_find_tlv, which does
a bit of bounds checking on the value.

This is easy to simulate by doing a `memset(skb->cb, 0x41,
sizeof(skb->cb));` before calling icmp{,v6}_ndo_send, and it's only by
good fortune and the rarity of icmp sending from that context that we've
avoided reports like this until now. For example, in KASAN:

    BUG: KASAN: stack-out-of-bounds in __ip_options_echo+0xa0e/0x12b0
    Write of size 38 at addr ffff888006f1f80e by task ping/89
    CPU: 2 PID: 89 Comm: ping Not tainted 5.10.0-rc7-debug+ #5
    Call Trace:
     dump_stack+0x9a/0xcc
     print_address_description.constprop.0+0x1a/0x160
     __kasan_report.cold+0x20/0x38
     kasan_report+0x32/0x40
     check_memory_region+0x145/0x1a0
     memcpy+0x39/0x60
     __ip_options_echo+0xa0e/0x12b0
     __icmp_send+0x744/0x1700

Actually, out of the 4 drivers that do this, only gtp zeroed the cb for
the v4 case, while the rest did not. So this commit actually removes the
gtp-specific zeroing, while putting the code where it belongs in the
shared infrastructure of icmp{,v6}_ndo_send.

This commit fixes the issue by passing an empty IPCB or IP6CB along to
the functions that actually do the work. For the icmp_send, this was
already trivial, thanks to __icmp_send providing the plumbing function.
For icmpv6_send, this required a tiny bit of refactoring to make it
behave like the v4 case, after which it was straight forward.

Fixes: a2b78e9b2cac ("sunvnet: generate ICMP PTMUD messages for smaller port MTUs")
Reported-by: SinYu <liuxyon@gmail.com>
Cc: Willem de Bruijn <willemb@google.com>
Cc: David L Stevens <david.stevens@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Link: https://lore.kernel.org/netdev/CAF=yD-LOF116aHub6RMe8vB8ZpnrrnoTdqhobEx+bvoA8AsP0w@mail.gmail.com/T/
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
Changes v3->v4:
- More explanation in commit message
- Pass the right parm parameter to send()
Changes v2->v3:
- Fix build errors with CONFIG_IPV6=m

 drivers/net/gtp.c      |  1 -
 include/linux/icmpv6.h | 26 ++++++++++++++++++++------
 include/linux/ipv6.h   |  1 -
 include/net/icmp.h     |  6 +++++-
 net/ipv4/icmp.c        |  5 +++--
 net/ipv6/icmp.c        | 18 +++++++++---------
 net/ipv6/ip6_icmp.c    | 12 +++++++-----
 7 files changed, 44 insertions(+), 25 deletions(-)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 4c04e271f184..fd3c2d86e48b 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -539,7 +539,6 @@ static int gtp_build_skb_ip4(struct sk_buff *skb, struct net_device *dev,
 	if (!skb_is_gso(skb) && (iph->frag_off & htons(IP_DF)) &&
 	    mtu < ntohs(iph->tot_len)) {
 		netdev_dbg(dev, "packet too big, fragmentation needed\n");
-		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 		icmp_ndo_send(skb, ICMP_DEST_UNREACH, ICMP_FRAG_NEEDED,
 			      htonl(mtu));
 		goto err_rt;
diff --git a/include/linux/icmpv6.h b/include/linux/icmpv6.h
index 1b3371ae8193..0a383202dd5e 100644
--- a/include/linux/icmpv6.h
+++ b/include/linux/icmpv6.h
@@ -3,6 +3,7 @@
 #define _LINUX_ICMPV6_H
 
 #include <linux/skbuff.h>
+#include <linux/ipv6.h>
 #include <uapi/linux/icmpv6.h>
 
 static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
@@ -15,13 +16,16 @@ static inline struct icmp6hdr *icmp6_hdr(const struct sk_buff *skb)
 #if IS_ENABLED(CONFIG_IPV6)
 
 typedef void ip6_icmp_send_t(struct sk_buff *skb, u8 type, u8 code, __u32 info,
-			     const struct in6_addr *force_saddr);
+			     const struct in6_addr *force_saddr,
+			     const struct inet6_skb_parm *parm);
 #if IS_BUILTIN(CONFIG_IPV6)
 void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
-		const struct in6_addr *force_saddr);
-static inline void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
+		const struct in6_addr *force_saddr,
+		const struct inet6_skb_parm *parm);
+static inline void __icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
+				 const struct inet6_skb_parm *parm)
 {
-	icmp6_send(skb, type, code, info, NULL);
+	icmp6_send(skb, type, code, info, NULL, parm);
 }
 static inline int inet6_register_icmp_sender(ip6_icmp_send_t *fn)
 {
@@ -34,18 +38,28 @@ static inline int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn)
 	return 0;
 }
 #else
-extern void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info);
+extern void __icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
+			  const struct inet6_skb_parm *parm);
 extern int inet6_register_icmp_sender(ip6_icmp_send_t *fn);
 extern int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn);
 #endif
 
+static inline void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
+{
+	__icmpv6_send(skb, type, code, info, IP6CB(skb));
+}
+
 int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
 			       unsigned int data_len);
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info);
 #else
-#define icmpv6_ndo_send icmpv6_send
+static inline void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
+{
+	struct inet6_skb_parm parm = { 0 };
+	__icmpv6_send(skb_in, type, code, info, &parm);
+}
 #endif
 
 #else
diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
index dda61d150a13..f514a7dd8c9c 100644
--- a/include/linux/ipv6.h
+++ b/include/linux/ipv6.h
@@ -84,7 +84,6 @@ struct ipv6_params {
 	__s32 autoconf;
 };
 extern struct ipv6_params ipv6_defaults;
-#include <linux/icmpv6.h>
 #include <linux/tcp.h>
 #include <linux/udp.h>
 
diff --git a/include/net/icmp.h b/include/net/icmp.h
index 9ac2d2672a93..fd84adc47963 100644
--- a/include/net/icmp.h
+++ b/include/net/icmp.h
@@ -46,7 +46,11 @@ static inline void icmp_send(struct sk_buff *skb_in, int type, int code, __be32
 #if IS_ENABLED(CONFIG_NF_NAT)
 void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info);
 #else
-#define icmp_ndo_send icmp_send
+static inline void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
+{
+	struct ip_options opts = { 0 };
+	__icmp_send(skb_in, type, code, info, &opts);
+}
 #endif
 
 int icmp_rcv(struct sk_buff *skb);
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 396b492c804f..616e2dc1c8fa 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -775,13 +775,14 @@ EXPORT_SYMBOL(__icmp_send);
 void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 {
 	struct sk_buff *cloned_skb = NULL;
+	struct ip_options opts = { 0 };
 	enum ip_conntrack_info ctinfo;
 	struct nf_conn *ct;
 	__be32 orig_ip;
 
 	ct = nf_ct_get(skb_in, &ctinfo);
 	if (!ct || !(ct->status & IPS_SRC_NAT)) {
-		icmp_send(skb_in, type, code, info);
+		__icmp_send(skb_in, type, code, info, &opts);
 		return;
 	}
 
@@ -796,7 +797,7 @@ void icmp_ndo_send(struct sk_buff *skb_in, int type, int code, __be32 info)
 
 	orig_ip = ip_hdr(skb_in)->saddr;
 	ip_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.ip;
-	icmp_send(skb_in, type, code, info);
+	__icmp_send(skb_in, type, code, info, &opts);
 	ip_hdr(skb_in)->saddr = orig_ip;
 out:
 	consume_skb(cloned_skb);
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index f3d05866692e..fd1f896115c1 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -331,10 +331,9 @@ static int icmpv6_getfrag(void *from, char *to, int offset, int len, int odd, st
 }
 
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
-static void mip6_addr_swap(struct sk_buff *skb)
+static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt)
 {
 	struct ipv6hdr *iph = ipv6_hdr(skb);
-	struct inet6_skb_parm *opt = IP6CB(skb);
 	struct ipv6_destopt_hao *hao;
 	struct in6_addr tmp;
 	int off;
@@ -351,7 +350,7 @@ static void mip6_addr_swap(struct sk_buff *skb)
 	}
 }
 #else
-static inline void mip6_addr_swap(struct sk_buff *skb) {}
+static inline void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt) {}
 #endif
 
 static struct dst_entry *icmpv6_route_lookup(struct net *net,
@@ -446,7 +445,8 @@ static int icmp6_iif(const struct sk_buff *skb)
  *	Send an ICMP message in response to a packet in error
  */
 void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
-		const struct in6_addr *force_saddr)
+		const struct in6_addr *force_saddr,
+		const struct inet6_skb_parm *parm)
 {
 	struct inet6_dev *idev = NULL;
 	struct ipv6hdr *hdr = ipv6_hdr(skb);
@@ -542,7 +542,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	if (!(skb->dev->flags & IFF_LOOPBACK) && !icmpv6_global_allow(net, type))
 		goto out_bh_enable;
 
-	mip6_addr_swap(skb);
+	mip6_addr_swap(skb, parm);
 
 	sk = icmpv6_xmit_lock(net);
 	if (!sk)
@@ -559,7 +559,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		/* select a more meaningful saddr from input if */
 		struct net_device *in_netdev;
 
-		in_netdev = dev_get_by_index(net, IP6CB(skb)->iif);
+		in_netdev = dev_get_by_index(net, parm->iif);
 		if (in_netdev) {
 			ipv6_dev_get_saddr(net, in_netdev, &fl6.daddr,
 					   inet6_sk(sk)->srcprefs,
@@ -640,7 +640,7 @@ EXPORT_SYMBOL(icmp6_send);
  */
 void icmpv6_param_prob(struct sk_buff *skb, u8 code, int pos)
 {
-	icmp6_send(skb, ICMPV6_PARAMPROB, code, pos, NULL);
+	icmp6_send(skb, ICMPV6_PARAMPROB, code, pos, NULL, IP6CB(skb));
 	kfree_skb(skb);
 }
 
@@ -697,10 +697,10 @@ int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
 	}
 	if (type == ICMP_TIME_EXCEEDED)
 		icmp6_send(skb2, ICMPV6_TIME_EXCEED, ICMPV6_EXC_HOPLIMIT,
-			   info, &temp_saddr);
+			   info, &temp_saddr, IP6CB(skb2));
 	else
 		icmp6_send(skb2, ICMPV6_DEST_UNREACH, ICMPV6_ADDR_UNREACH,
-			   info, &temp_saddr);
+			   info, &temp_saddr, IP6CB(skb2));
 	if (rt)
 		ip6_rt_put(rt);
 
diff --git a/net/ipv6/ip6_icmp.c b/net/ipv6/ip6_icmp.c
index 70c8c2f36c98..9e3574880cb0 100644
--- a/net/ipv6/ip6_icmp.c
+++ b/net/ipv6/ip6_icmp.c
@@ -33,23 +33,25 @@ int inet6_unregister_icmp_sender(ip6_icmp_send_t *fn)
 }
 EXPORT_SYMBOL(inet6_unregister_icmp_sender);
 
-void icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info)
+void __icmpv6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
+		   const struct inet6_skb_parm *parm)
 {
 	ip6_icmp_send_t *send;
 
 	rcu_read_lock();
 	send = rcu_dereference(ip6_icmp_send);
 	if (send)
-		send(skb, type, code, info, NULL);
+		send(skb, type, code, info, NULL, parm);
 	rcu_read_unlock();
 }
-EXPORT_SYMBOL(icmpv6_send);
+EXPORT_SYMBOL(__icmpv6_send);
 #endif
 
 #if IS_ENABLED(CONFIG_NF_NAT)
 #include <net/netfilter/nf_conntrack.h>
 void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
 {
+	struct inet6_skb_parm parm = { 0 };
 	struct sk_buff *cloned_skb = NULL;
 	enum ip_conntrack_info ctinfo;
 	struct in6_addr orig_ip;
@@ -57,7 +59,7 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
 
 	ct = nf_ct_get(skb_in, &ctinfo);
 	if (!ct || !(ct->status & IPS_SRC_NAT)) {
-		icmpv6_send(skb_in, type, code, info);
+		__icmpv6_send(skb_in, type, code, info, &parm);
 		return;
 	}
 
@@ -72,7 +74,7 @@ void icmpv6_ndo_send(struct sk_buff *skb_in, u8 type, u8 code, __u32 info)
 
 	orig_ip = ipv6_hdr(skb_in)->saddr;
 	ipv6_hdr(skb_in)->saddr = ct->tuplehash[0].tuple.src.u3.in6;
-	icmpv6_send(skb_in, type, code, info);
+	__icmpv6_send(skb_in, type, code, info, &parm);
 	ipv6_hdr(skb_in)->saddr = orig_ip;
 out:
 	consume_skb(cloned_skb);
-- 
2.30.1

