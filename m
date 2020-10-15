Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB37728F6F7
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 18:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389869AbgJOQjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 12:39:40 -0400
Received: from correo.us.es ([193.147.175.20]:52652 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388946AbgJOQjj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 12:39:39 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 9657FE4B86
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 18:39:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 883C0DA73F
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 18:39:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7DBF5DA72F; Thu, 15 Oct 2020 18:39:37 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WELCOMELIST,USER_IN_WHITELIST
        autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 623DDDA73D;
        Thu, 15 Oct 2020 18:39:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 15 Oct 2020 18:39:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 3121542EF4E0;
        Thu, 15 Oct 2020 18:39:35 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next] netfilter: nftables: allow re-computing sctp CRC-32C in 'payload' statements
Date:   Thu, 15 Oct 2020 18:39:27 +0200
Message-Id: <20201015163927.28730-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

nftables payload statements are used to mangle SCTP headers, but they can
only replace the Internet Checksum. As a consequence, nftables rules that
mangle sport/dport/vtag in SCTP headers potentially generate packets that
are discarded by the receiver, unless the CRC-32C is "offloaded" (e.g the
rule mangles a skb having 'ip_summed' equal to 'CHECKSUM_PARTIAL'.

Fix this extending uAPI definitions and L4 checksum update function, in a
way that userspace programs (e.g. nft) can instruct the kernel to compute
CRC-32C in SCTP headers. Also ensure that LIBCRC32C is built if NF_TABLES
is 'y' or 'm' in the kernel build configuration.

Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Jakub: This is my last pending item in nf-next I think, I'm not planning to
	send a pull request for a single patch, so please directly apply this
	one to net-next. Thank you.

 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/Kconfig                    |  1 +
 net/netfilter/nft_payload.c              | 28 ++++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 352ee51707a1..98272cb5f617 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -749,10 +749,12 @@ enum nft_payload_bases {
  *
  * @NFT_PAYLOAD_CSUM_NONE: no checksumming
  * @NFT_PAYLOAD_CSUM_INET: internet checksum (RFC 791)
+ * @NFT_PAYLOAD_CSUM_SCTP: CRC-32c, for use in SCTP header (RFC 3309)
  */
 enum nft_payload_csum_types {
 	NFT_PAYLOAD_CSUM_NONE,
 	NFT_PAYLOAD_CSUM_INET,
+	NFT_PAYLOAD_CSUM_SCTP,
 };
 
 enum nft_payload_csum_flags {
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 25313c29d799..52370211e46b 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -441,6 +441,7 @@ endif # NF_CONNTRACK
 
 config NF_TABLES
 	select NETFILTER_NETLINK
+	select LIBCRC32C
 	tristate "Netfilter nf_tables support"
 	help
 	  nftables is the new packet classification framework that intends to
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 7a2e59638499..dcd3c7b8a367 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -22,6 +22,7 @@
 #include <linux/icmpv6.h>
 #include <linux/ip.h>
 #include <linux/ipv6.h>
+#include <net/sctp/checksum.h>
 
 static bool nft_payload_rebuild_vlan_hdr(const struct sk_buff *skb, int mac_off,
 					 struct vlan_ethhdr *veth)
@@ -484,6 +485,19 @@ static int nft_payload_l4csum_offset(const struct nft_pktinfo *pkt,
 	return 0;
 }
 
+static int nft_payload_csum_sctp(struct sk_buff *skb, int offset)
+{
+	struct sctphdr *sh;
+
+	if (skb_ensure_writable(skb, offset + sizeof(*sh)))
+		return -1;
+
+	sh = (struct sctphdr *)(skb->data + offset);
+	sh->checksum = sctp_compute_cksum(skb, offset);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	return 0;
+}
+
 static int nft_payload_l4csum_update(const struct nft_pktinfo *pkt,
 				     struct sk_buff *skb,
 				     __wsum fsum, __wsum tsum)
@@ -587,6 +601,13 @@ static void nft_payload_set_eval(const struct nft_expr *expr,
 	    skb_store_bits(skb, offset, src, priv->len) < 0)
 		goto err;
 
+	if (priv->csum_type == NFT_PAYLOAD_CSUM_SCTP &&
+	    pkt->tprot == IPPROTO_SCTP &&
+	    skb->ip_summed != CHECKSUM_PARTIAL) {
+		if (nft_payload_csum_sctp(skb, pkt->xt.thoff))
+			goto err;
+	}
+
 	return;
 err:
 	regs->verdict.code = NFT_BREAK;
@@ -623,6 +644,13 @@ static int nft_payload_set_init(const struct nft_ctx *ctx,
 	case NFT_PAYLOAD_CSUM_NONE:
 	case NFT_PAYLOAD_CSUM_INET:
 		break;
+	case NFT_PAYLOAD_CSUM_SCTP:
+		if (priv->base != NFT_PAYLOAD_TRANSPORT_HEADER)
+			return -EINVAL;
+
+		if (priv->csum_offset != offsetof(struct sctphdr, checksum))
+			return -EINVAL;
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.20.1

