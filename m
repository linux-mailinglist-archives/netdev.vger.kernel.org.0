Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D56E2DBC5
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 13:26:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726018AbfE2LZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 07:25:57 -0400
Received: from mail.us.es ([193.147.175.20]:53020 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbfE2LZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 07:25:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 0AD41C1B77
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 13:25:51 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id EFD6FDA714
        for <netdev@vger.kernel.org>; Wed, 29 May 2019 13:25:50 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E4C1CDA70F; Wed, 29 May 2019 13:25:50 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9EF05DA704;
        Wed, 29 May 2019 13:25:48 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 13:25:48 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 5BC504265A5B;
        Wed, 29 May 2019 13:25:48 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH net-next,v3 3/9] net: ipv4: split skbuff into fragments transformer
Date:   Wed, 29 May 2019 13:25:33 +0200
Message-Id: <20190529112539.2126-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190529112539.2126-1-pablo@netfilter.org>
References: <20190529112539.2126-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch exposes a new API to refragment a skbuff. This allows you to
split either a linear skbuff or to force the refragmentation of an
existing fraglist using a different mtu. The API consists of:

* ip_frag_init(), that initializes the internal state of the transformer.
* ip_frag_next(), that allows you to fetch the next fragment. This function
  internally allocates the skbuff that represents the fragment, it pushes
  the IPv4 header, and it also copies the payload for each fragment.

The ip_frag_state object stores the internal state of the splitter.

This code has been extracted from ip_do_fragment(). Symbols are also
exported to allow to reuse this iterator from the bridge codepath to
build its own refragmentation routine by reusing the existing codebase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip.h     |  16 +++++
 net/ipv4/ip_output.c | 200 ++++++++++++++++++++++++++++-----------------------
 2 files changed, 128 insertions(+), 88 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index be899677504b..029cc3fd26bd 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -188,6 +188,22 @@ static inline struct sk_buff *ip_fraglist_next(struct ip_fraglist_iter *iter)
 	return skb;
 }
 
+struct ip_frag_state {
+	struct iphdr	*iph;
+	unsigned int	hlen;
+	unsigned int	ll_rs;
+	unsigned int	mtu;
+	unsigned int	left;
+	int		offset;
+	int		ptr;
+	__be16		not_last_frag;
+};
+
+void ip_frag_init(struct sk_buff *skb, unsigned int hlen, unsigned int ll_rs,
+		  unsigned int mtu, struct ip_frag_state *state);
+struct sk_buff *ip_frag_next(struct sk_buff *skb,
+			     struct ip_frag_state *state);
+
 void ip_send_check(struct iphdr *ip);
 int __ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 int ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d03eb4ae0dd4..c3f139843eca 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -609,6 +609,111 @@ void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
 }
 EXPORT_SYMBOL(ip_fraglist_prepare);
 
+void ip_frag_init(struct sk_buff *skb, unsigned int hlen,
+		  unsigned int ll_rs, unsigned int mtu,
+		  struct ip_frag_state *state)
+{
+	struct iphdr *iph = ip_hdr(skb);
+
+	state->hlen = hlen;
+	state->ll_rs = ll_rs;
+	state->mtu = mtu;
+
+	state->left = skb->len - hlen;	/* Space per frame */
+	state->ptr = hlen;		/* Where to start from */
+
+	state->offset = (ntohs(iph->frag_off) & IP_OFFSET) << 3;
+	state->not_last_frag = iph->frag_off & htons(IP_MF);
+}
+EXPORT_SYMBOL(ip_frag_init);
+
+struct sk_buff *ip_frag_next(struct sk_buff *skb, struct ip_frag_state *state)
+{
+	unsigned int len = state->left;
+	struct sk_buff *skb2;
+	struct iphdr *iph;
+
+	len = state->left;
+	/* IF: it doesn't fit, use 'mtu' - the data space left */
+	if (len > state->mtu)
+		len = state->mtu;
+	/* IF: we are not sending up to and including the packet end
+	   then align the next start on an eight byte boundary */
+	if (len < state->left)	{
+		len &= ~7;
+	}
+
+	/* Allocate buffer */
+	skb2 = alloc_skb(len + state->hlen + state->ll_rs, GFP_ATOMIC);
+	if (!skb2)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 *	Set up data on packet
+	 */
+
+	ip_copy_metadata(skb2, skb);
+	skb_reserve(skb2, state->ll_rs);
+	skb_put(skb2, len + state->hlen);
+	skb_reset_network_header(skb2);
+	skb2->transport_header = skb2->network_header + state->hlen;
+
+	/*
+	 *	Charge the memory for the fragment to any owner
+	 *	it might possess
+	 */
+
+	if (skb->sk)
+		skb_set_owner_w(skb2, skb->sk);
+
+	/*
+	 *	Copy the packet header into the new buffer.
+	 */
+
+	skb_copy_from_linear_data(skb, skb_network_header(skb2), state->hlen);
+
+	/*
+	 *	Copy a block of the IP datagram.
+	 */
+	if (skb_copy_bits(skb, state->ptr, skb_transport_header(skb2), len))
+		BUG();
+	state->left -= len;
+
+	/*
+	 *	Fill in the new header fields.
+	 */
+	iph = ip_hdr(skb2);
+	iph->frag_off = htons((state->offset >> 3));
+
+	if (IPCB(skb)->flags & IPSKB_FRAG_PMTU)
+		iph->frag_off |= htons(IP_DF);
+
+	/* ANK: dirty, but effective trick. Upgrade options only if
+	 * the segment to be fragmented was THE FIRST (otherwise,
+	 * options are already fixed) and make it ONCE
+	 * on the initial skb, so that all the following fragments
+	 * will inherit fixed options.
+	 */
+	if (state->offset == 0)
+		ip_options_fragment(skb);
+
+	/*
+	 *	Added AC : If we are fragmenting a fragment that's not the
+	 *		   last fragment then keep MF on each bit
+	 */
+	if (state->left > 0 || state->not_last_frag)
+		iph->frag_off |= htons(IP_MF);
+	state->ptr += len;
+	state->offset += len;
+
+	iph->tot_len = htons(len + state->hlen);
+
+	ip_send_check(iph);
+
+	return skb2;
+}
+EXPORT_SYMBOL(ip_frag_next);
+
 /*
  *	This IP datagram is too large to be sent in one piece.  Break it up into
  *	smaller pieces (each of size equal to IP header plus
@@ -620,13 +725,11 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		   int (*output)(struct net *, struct sock *, struct sk_buff *))
 {
 	struct iphdr *iph;
-	int ptr;
 	struct sk_buff *skb2;
-	unsigned int mtu, hlen, left, len, ll_rs;
-	int offset;
-	__be16 not_last_frag;
 	struct rtable *rt = skb_rtable(skb);
+	unsigned int mtu, hlen, ll_rs;
 	struct ip_fraglist_iter iter;
+	struct ip_frag_state state;
 	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
@@ -730,105 +833,26 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	}
 
 slow_path:
-	iph = ip_hdr(skb);
-
-	left = skb->len - hlen;		/* Space per frame */
-	ptr = hlen;		/* Where to start from */
-
 	/*
 	 *	Fragment the datagram.
 	 */
 
-	offset = (ntohs(iph->frag_off) & IP_OFFSET) << 3;
-	not_last_frag = iph->frag_off & htons(IP_MF);
+	ip_frag_init(skb, hlen, ll_rs, mtu, &state);
 
 	/*
 	 *	Keep copying data until we run out.
 	 */
 
-	while (left > 0) {
-		len = left;
-		/* IF: it doesn't fit, use 'mtu' - the data space left */
-		if (len > mtu)
-			len = mtu;
-		/* IF: we are not sending up to and including the packet end
-		   then align the next start on an eight byte boundary */
-		if (len < left)	{
-			len &= ~7;
-		}
-
-		/* Allocate buffer */
-		skb2 = alloc_skb(len + hlen + ll_rs, GFP_ATOMIC);
-		if (!skb2) {
-			err = -ENOMEM;
+	while (state.left > 0) {
+		skb2 = ip_frag_next(skb, &state);
+		if (IS_ERR(skb2)) {
+			err = PTR_ERR(skb2);
 			goto fail;
 		}
 
 		/*
-		 *	Set up data on packet
-		 */
-
-		ip_copy_metadata(skb2, skb);
-		skb_reserve(skb2, ll_rs);
-		skb_put(skb2, len + hlen);
-		skb_reset_network_header(skb2);
-		skb2->transport_header = skb2->network_header + hlen;
-
-		/*
-		 *	Charge the memory for the fragment to any owner
-		 *	it might possess
-		 */
-
-		if (skb->sk)
-			skb_set_owner_w(skb2, skb->sk);
-
-		/*
-		 *	Copy the packet header into the new buffer.
-		 */
-
-		skb_copy_from_linear_data(skb, skb_network_header(skb2), hlen);
-
-		/*
-		 *	Copy a block of the IP datagram.
-		 */
-		if (skb_copy_bits(skb, ptr, skb_transport_header(skb2), len))
-			BUG();
-		left -= len;
-
-		/*
-		 *	Fill in the new header fields.
-		 */
-		iph = ip_hdr(skb2);
-		iph->frag_off = htons((offset >> 3));
-
-		if (IPCB(skb)->flags & IPSKB_FRAG_PMTU)
-			iph->frag_off |= htons(IP_DF);
-
-		/* ANK: dirty, but effective trick. Upgrade options only if
-		 * the segment to be fragmented was THE FIRST (otherwise,
-		 * options are already fixed) and make it ONCE
-		 * on the initial skb, so that all the following fragments
-		 * will inherit fixed options.
-		 */
-		if (offset == 0)
-			ip_options_fragment(skb);
-
-		/*
-		 *	Added AC : If we are fragmenting a fragment that's not the
-		 *		   last fragment then keep MF on each bit
-		 */
-		if (left > 0 || not_last_frag)
-			iph->frag_off |= htons(IP_MF);
-		ptr += len;
-		offset += len;
-
-		/*
 		 *	Put this fragment into the sending queue.
 		 */
-		iph->tot_len = htons(len + hlen);
-
-		ip_send_check(iph);
-
 		err = output(net, sk, skb2);
 		if (err)
 			goto fail;
-- 
2.11.0

