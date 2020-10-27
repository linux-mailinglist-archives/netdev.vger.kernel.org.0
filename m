Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5D6629BBD5
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 17:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1809640AbgJ0Q2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 12:28:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1809641AbgJ0Q1Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 12:27:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603816035;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GwGFhsfDkj/2zlCgBH4MKieSRGsQvjMho59uYLGvbB4=;
        b=NE/kaKde1FMr4+jT4N9ZbmjtTnmXYCpR8tL1+PuCYBu/nwhoOOgW7pFWIH7n1JB8/vQF0R
        1UulEju2vTbt71tGxeb/pDi3+JrJg2oGOJ1WTduuRS4a7C8KOs1PXdYxD2KuW94+ecfSjG
        1rUyPImfFQQD6SbWk4QNBy1S/wWsOyw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-343-iw1Rlcb8MkeUJB7GKW5K5w-1; Tue, 27 Oct 2020 12:27:12 -0400
X-MC-Unique: iw1Rlcb8MkeUJB7GKW5K5w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7B35A186DD46;
        Tue, 27 Oct 2020 16:27:10 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 880A05D9E8;
        Tue, 27 Oct 2020 16:27:06 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 7C82D30736C8B;
        Tue, 27 Oct 2020 17:27:05 +0100 (CET)
Subject: [PATCH bpf-next V4 4/5] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Tue, 27 Oct 2020 17:27:05 +0100
Message-ID: <160381602541.1435097.10808671917698309386.stgit@firesoul>
In-Reply-To: <160381592923.1435097.2008820753108719855.stgit@firesoul>
References: <160381592923.1435097.2008820753108719855.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The use-case for dropping the MTU check when TC-BPF does redirect to
ingress, is described by Eyal Birger in email[0]. The summary is the
ability to increase packet size (e.g. with IPv6 headers for NAT64) and
ingress redirect packet and let normal netstack fragment packet as needed.

[0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/

V4:
 - Keep net_device "up" (IFF_UP) check.
 - Adjustment to handle bpf_redirect_peer() helper

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/netdevice.h |   31 +++++++++++++++++++++++++++++--
 net/core/dev.c            |   19 ++-----------------
 net/core/filter.c         |   14 +++++++++++---
 3 files changed, 42 insertions(+), 22 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 964b494b0e8d..bd02ddab8dfe 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3891,11 +3891,38 @@ int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
 bool is_skb_forwardable(const struct net_device *dev,
 			const struct sk_buff *skb);
 
+static __always_inline bool __is_skb_forwardable(const struct net_device *dev,
+						 const struct sk_buff *skb,
+						 const bool check_mtu)
+{
+	const u32 vlan_hdr_len = 4; /* VLAN_HLEN */
+	unsigned int len;
+
+	if (!(dev->flags & IFF_UP))
+		return false;
+
+	if (!check_mtu)
+		return true;
+
+	len = dev->mtu + dev->hard_header_len + vlan_hdr_len;
+	if (skb->len <= len)
+		return true;
+
+	/* if TSO is enabled, we don't care about the length as the packet
+	 * could be forwarded without being segmented before
+	 */
+	if (skb_is_gso(skb))
+		return true;
+
+	return false;
+}
+
 static __always_inline int ____dev_forward_skb(struct net_device *dev,
-					       struct sk_buff *skb)
+					       struct sk_buff *skb,
+					       const bool check_mtu)
 {
 	if (skb_orphan_frags(skb, GFP_ATOMIC) ||
-	    unlikely(!is_skb_forwardable(dev, skb))) {
+	    unlikely(!__is_skb_forwardable(dev, skb, check_mtu))) {
 		atomic_long_inc(&dev->rx_dropped);
 		kfree_skb(skb);
 		return NET_RX_DROP;
diff --git a/net/core/dev.c b/net/core/dev.c
index 9499a414d67e..445ccf92c149 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2188,28 +2188,13 @@ static inline void net_timestamp_set(struct sk_buff *skb)
 
 bool is_skb_forwardable(const struct net_device *dev, const struct sk_buff *skb)
 {
-	unsigned int len;
-
-	if (!(dev->flags & IFF_UP))
-		return false;
-
-	len = dev->mtu + dev->hard_header_len + VLAN_HLEN;
-	if (skb->len <= len)
-		return true;
-
-	/* if TSO is enabled, we don't care about the length as the packet
-	 * could be forwarded without being segmented before
-	 */
-	if (skb_is_gso(skb))
-		return true;
-
-	return false;
+	return __is_skb_forwardable(dev, skb, true);
 }
 EXPORT_SYMBOL_GPL(is_skb_forwardable);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
 {
-	int ret = ____dev_forward_skb(dev, skb);
+	int ret = ____dev_forward_skb(dev, skb, true);
 
 	if (likely(!ret)) {
 		skb->protocol = eth_type_trans(skb, dev);
diff --git a/net/core/filter.c b/net/core/filter.c
index d66a9cba8e14..6557c4e8858c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2083,13 +2083,21 @@ static const struct bpf_func_proto bpf_csum_level_proto = {
 
 static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
 {
-	return dev_forward_skb(dev, skb);
+	int ret = ____dev_forward_skb(dev, skb, false);
+
+	if (likely(!ret)) {
+		skb->protocol = eth_type_trans(skb, dev);
+		skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
+		ret = netif_rx(skb);
+	}
+
+	return ret;
 }
 
 static inline int __bpf_rx_skb_no_mac(struct net_device *dev,
 				      struct sk_buff *skb)
 {
-	int ret = ____dev_forward_skb(dev, skb);
+	int ret = ____dev_forward_skb(dev, skb, false);
 
 	if (likely(!ret)) {
 		skb->dev = dev;
@@ -2480,7 +2488,7 @@ int skb_do_redirect(struct sk_buff *skb)
 			goto out_drop;
 		dev = ops->ndo_get_peer_dev(dev);
 		if (unlikely(!dev ||
-			     !is_skb_forwardable(dev, skb) ||
+			     !__is_skb_forwardable(dev, skb, false) ||
 			     net_eq(net, dev_net(dev))))
 			goto out_drop;
 		skb->dev = dev;


