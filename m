Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933C43553A5
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 14:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344067AbhDFMWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 08:22:17 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34434 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343964AbhDFMWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 08:22:01 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B652563E34;
        Tue,  6 Apr 2021 14:21:27 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 06/28] netfilter: nf_log_common: merge with nf_log_syslog
Date:   Tue,  6 Apr 2021 14:21:11 +0200
Message-Id: <20210406122133.1644-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210406122133.1644-1-pablo@netfilter.org>
References: <20210406122133.1644-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Remove nf_log_common.  Now that all per-af modules have been merged
there is no longer a need to provide a helper module.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_log.h |  24 ----
 net/netfilter/Kconfig          |   8 +-
 net/netfilter/Makefile         |   2 -
 net/netfilter/nf_log_common.c  | 224 ---------------------------------
 net/netfilter/nf_log_syslog.c  | 181 +++++++++++++++++++++++++-
 5 files changed, 181 insertions(+), 258 deletions(-)
 delete mode 100644 net/netfilter/nf_log_common.c

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index a6b85068c294..e55eedc84ed7 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -98,28 +98,4 @@ struct nf_log_buf;
 struct nf_log_buf *nf_log_buf_open(void);
 __printf(2, 3) int nf_log_buf_add(struct nf_log_buf *m, const char *f, ...);
 void nf_log_buf_close(struct nf_log_buf *m);
-
-/* common logging functions */
-int nf_log_dump_udp_header(struct nf_log_buf *m, const struct sk_buff *skb,
-			   u8 proto, int fragment, unsigned int offset);
-int nf_log_dump_tcp_header(struct nf_log_buf *m, const struct sk_buff *skb,
-			   u8 proto, int fragment, unsigned int offset,
-			   unsigned int logflags);
-void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
-			    struct sock *sk);
-void nf_log_dump_vlan(struct nf_log_buf *m, const struct sk_buff *skb);
-void nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
-			       unsigned int hooknum, const struct sk_buff *skb,
-			       const struct net_device *in,
-			       const struct net_device *out,
-			       const struct nf_loginfo *loginfo,
-			       const char *prefix);
-void nf_log_l2packet(struct net *net, u_int8_t pf,
-		     __be16 protocol,
-		     unsigned int hooknum,
-		     const struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
-		     const struct nf_loginfo *loginfo, const char *prefix);
-
 #endif /* _NF_LOG_H */
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 6aef981a8446..fcd8682704c4 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -71,16 +71,13 @@ config NF_CONNTRACK
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-config NF_LOG_COMMON
-	tristate
-
 config NF_LOG_SYSLOG
 	tristate "Syslog packet logging"
 	default m if NETFILTER_ADVANCED=n
-	select NF_LOG_COMMON
 	help
 	  This option enable support for packet logging via syslog.
-	  It supports IPv4 and common transport protocols such as TCP and UDP.
+	  It supports IPv4, IPV6, ARP and common transport protocols such
+	  as TCP and UDP.
 	  This is a simpler but less flexible logging method compared to
 	  CONFIG_NETFILTER_NETLINK_LOG.
 	  If both are enabled the backend to use can be configured at run-time
@@ -930,7 +927,6 @@ config NETFILTER_XT_TARGET_LED
 
 config NETFILTER_XT_TARGET_LOG
 	tristate "LOG target support"
-	select NF_LOG_COMMON
 	select NF_LOG_SYSLOG
 	select NF_LOG_IPV6 if IP6_NF_IPTABLES
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 429be36fe4c7..e80e010354b1 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -48,8 +48,6 @@ obj-$(CONFIG_NF_CONNTRACK_TFTP) += nf_conntrack_tftp.o
 
 nf_nat-y	:= nf_nat_core.o nf_nat_proto.o nf_nat_helper.o
 
-# generic transport layer logging
-obj-$(CONFIG_NF_LOG_COMMON) += nf_log_common.o
 obj-$(CONFIG_NF_LOG_SYSLOG) += nf_log_syslog.o
 
 obj-$(CONFIG_NF_NAT) += nf_nat.o
diff --git a/net/netfilter/nf_log_common.c b/net/netfilter/nf_log_common.c
deleted file mode 100644
index fd7c5f0f5c25..000000000000
--- a/net/netfilter/nf_log_common.c
+++ /dev/null
@@ -1,224 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0-only
-/* (C) 1999-2001 Paul `Rusty' Russell
- * (C) 2002-2004 Netfilter Core Team <coreteam@netfilter.org>
- */
-
-#include <linux/module.h>
-#include <linux/spinlock.h>
-#include <linux/skbuff.h>
-#include <linux/if_arp.h>
-#include <linux/ip.h>
-#include <net/icmp.h>
-#include <net/udp.h>
-#include <net/tcp.h>
-#include <net/route.h>
-
-#include <linux/netfilter.h>
-#include <linux/netfilter_bridge.h>
-#include <linux/netfilter/xt_LOG.h>
-#include <net/netfilter/nf_log.h>
-
-int nf_log_dump_udp_header(struct nf_log_buf *m, const struct sk_buff *skb,
-			   u8 proto, int fragment, unsigned int offset)
-{
-	struct udphdr _udph;
-	const struct udphdr *uh;
-
-	if (proto == IPPROTO_UDP)
-		/* Max length: 10 "PROTO=UDP "     */
-		nf_log_buf_add(m, "PROTO=UDP ");
-	else	/* Max length: 14 "PROTO=UDPLITE " */
-		nf_log_buf_add(m, "PROTO=UDPLITE ");
-
-	if (fragment)
-		goto out;
-
-	/* Max length: 25 "INCOMPLETE [65535 bytes] " */
-	uh = skb_header_pointer(skb, offset, sizeof(_udph), &_udph);
-	if (uh == NULL) {
-		nf_log_buf_add(m, "INCOMPLETE [%u bytes] ", skb->len - offset);
-
-		return 1;
-	}
-
-	/* Max length: 20 "SPT=65535 DPT=65535 " */
-	nf_log_buf_add(m, "SPT=%u DPT=%u LEN=%u ",
-		       ntohs(uh->source), ntohs(uh->dest), ntohs(uh->len));
-
-out:
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nf_log_dump_udp_header);
-
-int nf_log_dump_tcp_header(struct nf_log_buf *m, const struct sk_buff *skb,
-			   u8 proto, int fragment, unsigned int offset,
-			   unsigned int logflags)
-{
-	struct tcphdr _tcph;
-	const struct tcphdr *th;
-
-	/* Max length: 10 "PROTO=TCP " */
-	nf_log_buf_add(m, "PROTO=TCP ");
-
-	if (fragment)
-		return 0;
-
-	/* Max length: 25 "INCOMPLETE [65535 bytes] " */
-	th = skb_header_pointer(skb, offset, sizeof(_tcph), &_tcph);
-	if (th == NULL) {
-		nf_log_buf_add(m, "INCOMPLETE [%u bytes] ", skb->len - offset);
-		return 1;
-	}
-
-	/* Max length: 20 "SPT=65535 DPT=65535 " */
-	nf_log_buf_add(m, "SPT=%u DPT=%u ",
-		       ntohs(th->source), ntohs(th->dest));
-	/* Max length: 30 "SEQ=4294967295 ACK=4294967295 " */
-	if (logflags & NF_LOG_TCPSEQ) {
-		nf_log_buf_add(m, "SEQ=%u ACK=%u ",
-			       ntohl(th->seq), ntohl(th->ack_seq));
-	}
-
-	/* Max length: 13 "WINDOW=65535 " */
-	nf_log_buf_add(m, "WINDOW=%u ", ntohs(th->window));
-	/* Max length: 9 "RES=0x3C " */
-	nf_log_buf_add(m, "RES=0x%02x ", (u_int8_t)(ntohl(tcp_flag_word(th) &
-					    TCP_RESERVED_BITS) >> 22));
-	/* Max length: 32 "CWR ECE URG ACK PSH RST SYN FIN " */
-	if (th->cwr)
-		nf_log_buf_add(m, "CWR ");
-	if (th->ece)
-		nf_log_buf_add(m, "ECE ");
-	if (th->urg)
-		nf_log_buf_add(m, "URG ");
-	if (th->ack)
-		nf_log_buf_add(m, "ACK ");
-	if (th->psh)
-		nf_log_buf_add(m, "PSH ");
-	if (th->rst)
-		nf_log_buf_add(m, "RST ");
-	if (th->syn)
-		nf_log_buf_add(m, "SYN ");
-	if (th->fin)
-		nf_log_buf_add(m, "FIN ");
-	/* Max length: 11 "URGP=65535 " */
-	nf_log_buf_add(m, "URGP=%u ", ntohs(th->urg_ptr));
-
-	if ((logflags & NF_LOG_TCPOPT) && th->doff*4 > sizeof(struct tcphdr)) {
-		u_int8_t _opt[60 - sizeof(struct tcphdr)];
-		const u_int8_t *op;
-		unsigned int i;
-		unsigned int optsize = th->doff*4 - sizeof(struct tcphdr);
-
-		op = skb_header_pointer(skb, offset + sizeof(struct tcphdr),
-					optsize, _opt);
-		if (op == NULL) {
-			nf_log_buf_add(m, "OPT (TRUNCATED)");
-			return 1;
-		}
-
-		/* Max length: 127 "OPT (" 15*4*2chars ") " */
-		nf_log_buf_add(m, "OPT (");
-		for (i = 0; i < optsize; i++)
-			nf_log_buf_add(m, "%02X", op[i]);
-
-		nf_log_buf_add(m, ") ");
-	}
-
-	return 0;
-}
-EXPORT_SYMBOL_GPL(nf_log_dump_tcp_header);
-
-void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
-			    struct sock *sk)
-{
-	if (!sk || !sk_fullsock(sk) || !net_eq(net, sock_net(sk)))
-		return;
-
-	read_lock_bh(&sk->sk_callback_lock);
-	if (sk->sk_socket && sk->sk_socket->file) {
-		const struct cred *cred = sk->sk_socket->file->f_cred;
-		nf_log_buf_add(m, "UID=%u GID=%u ",
-			from_kuid_munged(&init_user_ns, cred->fsuid),
-			from_kgid_munged(&init_user_ns, cred->fsgid));
-	}
-	read_unlock_bh(&sk->sk_callback_lock);
-}
-EXPORT_SYMBOL_GPL(nf_log_dump_sk_uid_gid);
-
-void
-nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
-			  unsigned int hooknum, const struct sk_buff *skb,
-			  const struct net_device *in,
-			  const struct net_device *out,
-			  const struct nf_loginfo *loginfo, const char *prefix)
-{
-	const struct net_device *physoutdev __maybe_unused;
-	const struct net_device *physindev __maybe_unused;
-
-	nf_log_buf_add(m, KERN_SOH "%c%sIN=%s OUT=%s ",
-	       '0' + loginfo->u.log.level, prefix,
-	       in ? in->name : "",
-	       out ? out->name : "");
-#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
-	physindev = nf_bridge_get_physindev(skb);
-	if (physindev && in != physindev)
-		nf_log_buf_add(m, "PHYSIN=%s ", physindev->name);
-	physoutdev = nf_bridge_get_physoutdev(skb);
-	if (physoutdev && out != physoutdev)
-		nf_log_buf_add(m, "PHYSOUT=%s ", physoutdev->name);
-#endif
-}
-EXPORT_SYMBOL_GPL(nf_log_dump_packet_common);
-
-void nf_log_dump_vlan(struct nf_log_buf *m, const struct sk_buff *skb)
-{
-	u16 vid;
-
-	if (!skb_vlan_tag_present(skb))
-		return;
-
-	vid = skb_vlan_tag_get(skb);
-	nf_log_buf_add(m, "VPROTO=%04x VID=%u ", ntohs(skb->vlan_proto), vid);
-}
-EXPORT_SYMBOL_GPL(nf_log_dump_vlan);
-
-/* bridge and netdev logging families share this code. */
-void nf_log_l2packet(struct net *net, u_int8_t pf,
-		     __be16 protocol,
-		     unsigned int hooknum,
-		     const struct sk_buff *skb,
-		     const struct net_device *in,
-		     const struct net_device *out,
-		     const struct nf_loginfo *loginfo,
-		     const char *prefix)
-{
-	switch (protocol) {
-	case htons(ETH_P_IP):
-		nf_log_packet(net, NFPROTO_IPV4, hooknum, skb, in, out,
-			      loginfo, "%s", prefix);
-		break;
-	case htons(ETH_P_IPV6):
-		nf_log_packet(net, NFPROTO_IPV6, hooknum, skb, in, out,
-			      loginfo, "%s", prefix);
-		break;
-	case htons(ETH_P_ARP):
-	case htons(ETH_P_RARP):
-		nf_log_packet(net, NFPROTO_ARP, hooknum, skb, in, out,
-			      loginfo, "%s", prefix);
-		break;
-	}
-}
-EXPORT_SYMBOL_GPL(nf_log_l2packet);
-
-static int __init nf_log_common_init(void)
-{
-	return 0;
-}
-
-static void __exit nf_log_common_exit(void) {}
-
-module_init(nf_log_common_init);
-module_exit(nf_log_common_exit);
-
-MODULE_LICENSE("GPL");
diff --git a/net/netfilter/nf_log_syslog.c b/net/netfilter/nf_log_syslog.c
index 6b56251de22a..2518818ed479 100644
--- a/net/netfilter/nf_log_syslog.c
+++ b/net/netfilter/nf_log_syslog.c
@@ -18,6 +18,7 @@
 #include <net/route.h>
 
 #include <linux/netfilter.h>
+#include <linux/netfilter_bridge.h>
 #include <linux/netfilter_ipv6.h>
 #include <linux/netfilter/xt_LOG.h>
 #include <net/netfilter/nf_log.h>
@@ -39,6 +40,16 @@ struct arppayload {
 	unsigned char ip_dst[4];
 };
 
+static void nf_log_dump_vlan(struct nf_log_buf *m, const struct sk_buff *skb)
+{
+	u16 vid;
+
+	if (!skb_vlan_tag_present(skb))
+		return;
+
+	vid = skb_vlan_tag_get(skb);
+	nf_log_buf_add(m, "VPROTO=%04x VID=%u ", ntohs(skb->vlan_proto), vid);
+}
 static void noinline_for_stack
 dump_arp_packet(struct nf_log_buf *m,
 		const struct nf_loginfo *info,
@@ -89,6 +100,30 @@ dump_arp_packet(struct nf_log_buf *m,
 		       ap->mac_src, ap->ip_src, ap->mac_dst, ap->ip_dst);
 }
 
+static void
+nf_log_dump_packet_common(struct nf_log_buf *m, u8 pf,
+			  unsigned int hooknum, const struct sk_buff *skb,
+			  const struct net_device *in,
+			  const struct net_device *out,
+			  const struct nf_loginfo *loginfo, const char *prefix)
+{
+	const struct net_device *physoutdev __maybe_unused;
+	const struct net_device *physindev __maybe_unused;
+
+	nf_log_buf_add(m, KERN_SOH "%c%sIN=%s OUT=%s ",
+		       '0' + loginfo->u.log.level, prefix,
+			in ? in->name : "",
+			out ? out->name : "");
+#if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
+	physindev = nf_bridge_get_physindev(skb);
+	if (physindev && in != physindev)
+		nf_log_buf_add(m, "PHYSIN=%s ", physindev->name);
+	physoutdev = nf_bridge_get_physoutdev(skb);
+	if (physoutdev && out != physoutdev)
+		nf_log_buf_add(m, "PHYSOUT=%s ", physoutdev->name);
+#endif
+}
+
 static void nf_log_arp_packet(struct net *net, u_int8_t pf,
 			      unsigned int hooknum, const struct sk_buff *skb,
 			      const struct net_device *in,
@@ -121,6 +156,138 @@ static struct nf_logger nf_arp_logger __read_mostly = {
 	.me		= THIS_MODULE,
 };
 
+static void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
+				   struct sock *sk)
+{
+	if (!sk || !sk_fullsock(sk) || !net_eq(net, sock_net(sk)))
+		return;
+
+	read_lock_bh(&sk->sk_callback_lock);
+	if (sk->sk_socket && sk->sk_socket->file) {
+		const struct cred *cred = sk->sk_socket->file->f_cred;
+
+		nf_log_buf_add(m, "UID=%u GID=%u ",
+			       from_kuid_munged(&init_user_ns, cred->fsuid),
+			       from_kgid_munged(&init_user_ns, cred->fsgid));
+	}
+	read_unlock_bh(&sk->sk_callback_lock);
+}
+
+static noinline_for_stack int
+nf_log_dump_tcp_header(struct nf_log_buf *m,
+		       const struct sk_buff *skb,
+		       u8 proto, int fragment,
+		       unsigned int offset,
+		       unsigned int logflags)
+{
+	struct tcphdr _tcph;
+	const struct tcphdr *th;
+
+	/* Max length: 10 "PROTO=TCP " */
+	nf_log_buf_add(m, "PROTO=TCP ");
+
+	if (fragment)
+		return 0;
+
+	/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+	th = skb_header_pointer(skb, offset, sizeof(_tcph), &_tcph);
+	if (!th) {
+		nf_log_buf_add(m, "INCOMPLETE [%u bytes] ", skb->len - offset);
+		return 1;
+	}
+
+	/* Max length: 20 "SPT=65535 DPT=65535 " */
+	nf_log_buf_add(m, "SPT=%u DPT=%u ",
+		       ntohs(th->source), ntohs(th->dest));
+	/* Max length: 30 "SEQ=4294967295 ACK=4294967295 " */
+	if (logflags & NF_LOG_TCPSEQ) {
+		nf_log_buf_add(m, "SEQ=%u ACK=%u ",
+			       ntohl(th->seq), ntohl(th->ack_seq));
+	}
+
+	/* Max length: 13 "WINDOW=65535 " */
+	nf_log_buf_add(m, "WINDOW=%u ", ntohs(th->window));
+	/* Max length: 9 "RES=0x3C " */
+	nf_log_buf_add(m, "RES=0x%02x ", (u_int8_t)(ntohl(tcp_flag_word(th) &
+					    TCP_RESERVED_BITS) >> 22));
+	/* Max length: 32 "CWR ECE URG ACK PSH RST SYN FIN " */
+	if (th->cwr)
+		nf_log_buf_add(m, "CWR ");
+	if (th->ece)
+		nf_log_buf_add(m, "ECE ");
+	if (th->urg)
+		nf_log_buf_add(m, "URG ");
+	if (th->ack)
+		nf_log_buf_add(m, "ACK ");
+	if (th->psh)
+		nf_log_buf_add(m, "PSH ");
+	if (th->rst)
+		nf_log_buf_add(m, "RST ");
+	if (th->syn)
+		nf_log_buf_add(m, "SYN ");
+	if (th->fin)
+		nf_log_buf_add(m, "FIN ");
+	/* Max length: 11 "URGP=65535 " */
+	nf_log_buf_add(m, "URGP=%u ", ntohs(th->urg_ptr));
+
+	if ((logflags & NF_LOG_TCPOPT) && th->doff * 4 > sizeof(struct tcphdr)) {
+		unsigned int optsize = th->doff * 4 - sizeof(struct tcphdr);
+		u8 _opt[60 - sizeof(struct tcphdr)];
+		unsigned int i;
+		const u8 *op;
+
+		op = skb_header_pointer(skb, offset + sizeof(struct tcphdr),
+					optsize, _opt);
+		if (!op) {
+			nf_log_buf_add(m, "OPT (TRUNCATED)");
+			return 1;
+		}
+
+		/* Max length: 127 "OPT (" 15*4*2chars ") " */
+		nf_log_buf_add(m, "OPT (");
+		for (i = 0; i < optsize; i++)
+			nf_log_buf_add(m, "%02X", op[i]);
+
+		nf_log_buf_add(m, ") ");
+	}
+
+	return 0;
+}
+
+static noinline_for_stack int
+nf_log_dump_udp_header(struct nf_log_buf *m,
+		       const struct sk_buff *skb,
+		       u8 proto, int fragment,
+		       unsigned int offset)
+{
+	struct udphdr _udph;
+	const struct udphdr *uh;
+
+	if (proto == IPPROTO_UDP)
+		/* Max length: 10 "PROTO=UDP "     */
+		nf_log_buf_add(m, "PROTO=UDP ");
+	else	/* Max length: 14 "PROTO=UDPLITE " */
+		nf_log_buf_add(m, "PROTO=UDPLITE ");
+
+	if (fragment)
+		goto out;
+
+	/* Max length: 25 "INCOMPLETE [65535 bytes] " */
+	uh = skb_header_pointer(skb, offset, sizeof(_udph), &_udph);
+	if (!uh) {
+		nf_log_buf_add(m, "INCOMPLETE [%u bytes] ", skb->len - offset);
+
+		return 1;
+	}
+
+	/* Max length: 20 "SPT=65535 DPT=65535 " */
+	nf_log_buf_add(m, "SPT=%u DPT=%u LEN=%u ",
+		       ntohs(uh->source), ntohs(uh->dest), ntohs(uh->len));
+
+out:
+	return 0;
+}
+
 /* One level of recursion won't kill us */
 static noinline_for_stack void
 dump_ipv4_packet(struct net *net, struct nf_log_buf *m,
@@ -776,8 +943,18 @@ static void nf_log_netdev_packet(struct net *net, u_int8_t pf,
 				 const struct nf_loginfo *loginfo,
 				 const char *prefix)
 {
-	nf_log_l2packet(net, pf, skb->protocol, hooknum, skb, in, out,
-			loginfo, prefix);
+	switch (skb->protocol) {
+	case htons(ETH_P_IP):
+		nf_log_ip_packet(net, pf, hooknum, skb, in, out, loginfo, prefix);
+		break;
+	case htons(ETH_P_IPV6):
+		nf_log_ip6_packet(net, pf, hooknum, skb, in, out, loginfo, prefix);
+		break;
+	case htons(ETH_P_ARP):
+	case htons(ETH_P_RARP):
+		nf_log_arp_packet(net, pf, hooknum, skb, in, out, loginfo, prefix);
+		break;
+	}
 }
 
 static struct nf_logger nf_netdev_logger __read_mostly = {
-- 
2.30.2

