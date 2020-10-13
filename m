Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34F0B28D727
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 01:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730044AbgJMXqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 19:46:18 -0400
Received: from correo.us.es ([193.147.175.20]:59930 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730013AbgJMXqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 19:46:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 53625E4BA7
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 01:46:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3FA2BDA78C
        for <netdev@vger.kernel.org>; Wed, 14 Oct 2020 01:46:09 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 35270DA730; Wed, 14 Oct 2020 01:46:09 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 27DD6DA73D;
        Wed, 14 Oct 2020 01:46:07 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 14 Oct 2020 01:46:07 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id E78DB42EFB80;
        Wed, 14 Oct 2020 01:46:06 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH 4/4] netfilter: nf_log: missing vlan offload tag and proto
Date:   Wed, 14 Oct 2020 01:45:59 +0200
Message-Id: <20201013234559.15113-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201013234559.15113-1-pablo@netfilter.org>
References: <20201013234559.15113-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dump vlan tag and proto for the usual vlan offload case if the
NF_LOG_MACDECODE flag is set on. Without this information the logging is
misleading as there is no reference to the VLAN header.

[12716.993704] test: IN=veth0 OUT= MACSRC=86:6c:92:ea:d6:73 MACDST=0e:3b:eb:86:73:76 VPROTO=8100 VID=10 MACPROTO=0800 SRC=192.168.10.2 DST=172.217.168.163 LEN=52 TOS=0x00 PREC=0x00 TTL=64 ID=2548 DF PROTO=TCP SPT=55848 DPT=80 WINDOW=501 RES=0x00 ACK FIN URGP=0
[12721.157643] test: IN=veth0 OUT= MACSRC=86:6c:92:ea:d6:73 MACDST=0e:3b:eb:86:73:76 VPROTO=8100 VID=10 MACPROTO=0806 ARP HTYPE=1 PTYPE=0x0800 OPCODE=2 MACSRC=86:6c:92:ea:d6:73 IPSRC=192.168.10.2 MACDST=0e:3b:eb:86:73:76 IPDST=192.168.10.1

Fixes: 83e96d443b37 ("netfilter: log: split family specific code to nf_log_{ip,ip6,common}.c files")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_log.h   |  1 +
 net/ipv4/netfilter/nf_log_arp.c  | 19 +++++++++++++++++--
 net/ipv4/netfilter/nf_log_ipv4.c |  6 ++++--
 net/ipv6/netfilter/nf_log_ipv6.c |  8 +++++---
 net/netfilter/nf_log_common.c    | 12 ++++++++++++
 5 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_log.h b/include/net/netfilter/nf_log.h
index 0d3920896d50..716db4a0fed8 100644
--- a/include/net/netfilter/nf_log.h
+++ b/include/net/netfilter/nf_log.h
@@ -108,6 +108,7 @@ int nf_log_dump_tcp_header(struct nf_log_buf *m, const struct sk_buff *skb,
 			   unsigned int logflags);
 void nf_log_dump_sk_uid_gid(struct net *net, struct nf_log_buf *m,
 			    struct sock *sk);
+void nf_log_dump_vlan(struct nf_log_buf *m, const struct sk_buff *skb);
 void nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
 			       unsigned int hooknum, const struct sk_buff *skb,
 			       const struct net_device *in,
diff --git a/net/ipv4/netfilter/nf_log_arp.c b/net/ipv4/netfilter/nf_log_arp.c
index 7a83f881efa9..136030ad2e54 100644
--- a/net/ipv4/netfilter/nf_log_arp.c
+++ b/net/ipv4/netfilter/nf_log_arp.c
@@ -43,16 +43,31 @@ static void dump_arp_packet(struct nf_log_buf *m,
 			    const struct nf_loginfo *info,
 			    const struct sk_buff *skb, unsigned int nhoff)
 {
-	const struct arphdr *ah;
-	struct arphdr _arph;
 	const struct arppayload *ap;
 	struct arppayload _arpp;
+	const struct arphdr *ah;
+	unsigned int logflags;
+	struct arphdr _arph;
 
 	ah = skb_header_pointer(skb, 0, sizeof(_arph), &_arph);
 	if (ah == NULL) {
 		nf_log_buf_add(m, "TRUNCATED");
 		return;
 	}
+
+	if (info->type == NF_LOG_TYPE_LOG)
+		logflags = info->u.log.logflags;
+	else
+		logflags = NF_LOG_DEFAULT_MASK;
+
+	if (logflags & NF_LOG_MACDECODE) {
+		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
+			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
+		nf_log_dump_vlan(m, skb);
+		nf_log_buf_add(m, "MACPROTO=%04x ",
+			       ntohs(eth_hdr(skb)->h_proto));
+	}
+
 	nf_log_buf_add(m, "ARP HTYPE=%d PTYPE=0x%04x OPCODE=%d",
 		       ntohs(ah->ar_hrd), ntohs(ah->ar_pro), ntohs(ah->ar_op));
 
diff --git a/net/ipv4/netfilter/nf_log_ipv4.c b/net/ipv4/netfilter/nf_log_ipv4.c
index 0c72156130b6..d07583fac8f8 100644
--- a/net/ipv4/netfilter/nf_log_ipv4.c
+++ b/net/ipv4/netfilter/nf_log_ipv4.c
@@ -284,8 +284,10 @@ static void dump_ipv4_mac_header(struct nf_log_buf *m,
 
 	switch (dev->type) {
 	case ARPHRD_ETHER:
-		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM MACPROTO=%04x ",
-			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
+		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
+			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
+		nf_log_dump_vlan(m, skb);
+		nf_log_buf_add(m, "MACPROTO=%04x ",
 			       ntohs(eth_hdr(skb)->h_proto));
 		return;
 	default:
diff --git a/net/ipv6/netfilter/nf_log_ipv6.c b/net/ipv6/netfilter/nf_log_ipv6.c
index da64550a5707..8210ff34ed9b 100644
--- a/net/ipv6/netfilter/nf_log_ipv6.c
+++ b/net/ipv6/netfilter/nf_log_ipv6.c
@@ -297,9 +297,11 @@ static void dump_ipv6_mac_header(struct nf_log_buf *m,
 
 	switch (dev->type) {
 	case ARPHRD_ETHER:
-		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM MACPROTO=%04x ",
-		       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest,
-		       ntohs(eth_hdr(skb)->h_proto));
+		nf_log_buf_add(m, "MACSRC=%pM MACDST=%pM ",
+			       eth_hdr(skb)->h_source, eth_hdr(skb)->h_dest);
+		nf_log_dump_vlan(m, skb);
+		nf_log_buf_add(m, "MACPROTO=%04x ",
+			       ntohs(eth_hdr(skb)->h_proto));
 		return;
 	default:
 		break;
diff --git a/net/netfilter/nf_log_common.c b/net/netfilter/nf_log_common.c
index ae5628ddbe6d..fd7c5f0f5c25 100644
--- a/net/netfilter/nf_log_common.c
+++ b/net/netfilter/nf_log_common.c
@@ -171,6 +171,18 @@ nf_log_dump_packet_common(struct nf_log_buf *m, u_int8_t pf,
 }
 EXPORT_SYMBOL_GPL(nf_log_dump_packet_common);
 
+void nf_log_dump_vlan(struct nf_log_buf *m, const struct sk_buff *skb)
+{
+	u16 vid;
+
+	if (!skb_vlan_tag_present(skb))
+		return;
+
+	vid = skb_vlan_tag_get(skb);
+	nf_log_buf_add(m, "VPROTO=%04x VID=%u ", ntohs(skb->vlan_proto), vid);
+}
+EXPORT_SYMBOL_GPL(nf_log_dump_vlan);
+
 /* bridge and netdev logging families share this code. */
 void nf_log_l2packet(struct net *net, u_int8_t pf,
 		     __be16 protocol,
-- 
2.20.1

