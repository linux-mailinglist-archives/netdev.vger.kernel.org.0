Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77E22FA87E
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 19:17:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407440AbhARSPk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 13:15:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:24540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2406791AbhARQ4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 11:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610988885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=67wJ/3lY93doSBO8DiUvbJaaboQhcdWtc+KAcQtjz2Y=;
        b=OkK7e2VwRHGxxBqIyDNaHTRAYBc2Ff5FfHT0t7DZSjzqW1NyDcv+efyBgv5afEoIWF+c3t
        jWwP2XdLUSHvHZeUJR69V0ywIzrWZn89BEa8NBPGGUYFpW1CHI3mJInlVi6OfT+0g0DCzo
        T4O+su4gmYd9URDC/h894heLwQMnAm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-553-xK5vqH0vPeSK4Z2z9u-nqQ-1; Mon, 18 Jan 2021 11:54:41 -0500
X-MC-Unique: xK5vqH0vPeSK4Z2z9u-nqQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A5768190A7A0;
        Mon, 18 Jan 2021 16:54:39 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 576961D7;
        Mon, 18 Jan 2021 16:54:36 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 542353223348F;
        Mon, 18 Jan 2021 17:54:35 +0100 (CET)
Subject: [PATCH bpf-next V12 5/7] bpf: drop MTU check when doing TC-BPF
 redirect to ingress
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com,
        colrack@gmail.com
Date:   Mon, 18 Jan 2021 17:54:35 +0100
Message-ID: <161098887527.108067.15650013825701578772.stgit@firesoul>
In-Reply-To: <161098881526.108067.7603213364270807261.stgit@firesoul>
References: <161098881526.108067.7603213364270807261.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The use-case for dropping the MTU check when TC-BPF does redirect to
ingress, is described by Eyal Birger in email[0]. The summary is the
ability to increase packet size (e.g. with IPv6 headers for NAT64) and
ingress redirect packet and let normal netstack fragment packet as needed.

[0] https://lore.kernel.org/netdev/CAHsH6Gug-hsLGHQ6N0wtixdOa85LDZ3HNRHVd0opR=19Qo4W4Q@mail.gmail.com/

V9:
 - Make net_device "up" (IFF_UP) check explicit in skb_do_redirect

V4:
 - Keep net_device "up" (IFF_UP) check.
 - Adjustment to handle bpf_redirect_peer() helper

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/netdevice.h |   32 ++++++++++++++++++++++++++++++--
 net/core/dev.c            |   32 ++++++++++++++------------------
 net/core/filter.c         |    6 +++---
 3 files changed, 47 insertions(+), 23 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 5b949076ed23..b7915484369c 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3926,14 +3926,42 @@ int xdp_umem_query(struct net_device *dev, u16 queue_id);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
 int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
+int dev_forward_skb_nomtu(struct net_device *dev, struct sk_buff *skb);
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
index bae35c1ae192..87bb2cd62189 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2194,28 +2194,14 @@ static inline void net_timestamp_set(struct sk_buff *skb)
 
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
 
-int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
+int __dev_forward_skb2(struct net_device *dev, struct sk_buff *skb,
+		     bool check_mtu)
 {
-	int ret = ____dev_forward_skb(dev, skb);
+	int ret = ____dev_forward_skb(dev, skb, check_mtu);
 
 	if (likely(!ret)) {
 		skb->protocol = eth_type_trans(skb, dev);
@@ -2224,6 +2210,11 @@ int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
 
 	return ret;
 }
+
+int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
+{
+	return __dev_forward_skb2(dev, skb, true);
+}
 EXPORT_SYMBOL_GPL(__dev_forward_skb);
 
 /**
@@ -2250,6 +2241,11 @@ int dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(dev_forward_skb);
 
+int dev_forward_skb_nomtu(struct net_device *dev, struct sk_buff *skb)
+{
+	return __dev_forward_skb2(dev, skb, false) ?: netif_rx_internal(skb);
+}
+
 static inline int deliver_skb(struct sk_buff *skb,
 			      struct packet_type *pt_prev,
 			      struct net_device *orig_dev)
diff --git a/net/core/filter.c b/net/core/filter.c
index 0be81f499f51..07876e9ab5e3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2083,13 +2083,13 @@ static const struct bpf_func_proto bpf_csum_level_proto = {
 
 static inline int __bpf_rx_skb(struct net_device *dev, struct sk_buff *skb)
 {
-	return dev_forward_skb(dev, skb);
+	return dev_forward_skb_nomtu(dev, skb);
 }
 
 static inline int __bpf_rx_skb_no_mac(struct net_device *dev,
 				      struct sk_buff *skb)
 {
-	int ret = ____dev_forward_skb(dev, skb);
+	int ret = ____dev_forward_skb(dev, skb, false);
 
 	if (likely(!ret)) {
 		skb->dev = dev;
@@ -2480,7 +2480,7 @@ int skb_do_redirect(struct sk_buff *skb)
 			goto out_drop;
 		dev = ops->ndo_get_peer_dev(dev);
 		if (unlikely(!dev ||
-			     !is_skb_forwardable(dev, skb) ||
+			     !(dev->flags & IFF_UP) ||
 			     net_eq(net, dev_net(dev))))
 			goto out_drop;
 		skb->dev = dev;


