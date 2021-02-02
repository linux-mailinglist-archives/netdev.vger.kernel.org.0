Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702D530C682
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236775AbhBBQuz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:50:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33303 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236475AbhBBQ3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 11:29:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612283237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9seBZNHM+5uP+de0lrHuyXLHlHRuD9Gu/yddHt+Xx60=;
        b=X6NfnB/CkoXZAz0xGljouPwkEwmjRlh6CJx2/ODQ54nUtYjCovxvN1cTIGo0qgU52JKexn
        SY5bAxFL7uYcwPyFcmnP3Qd0tbXWjE4CyPYfgzPf4nrkWnc8l/GWEzo/QMJyXe+pA88OKK
        cVz0One/yHpirrd6PjO3JIQM28HAEzg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-475-_eJ182O6O1e1opvoipW1ww-1; Tue, 02 Feb 2021 11:27:14 -0500
X-MC-Unique: _eJ182O6O1e1opvoipW1ww-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A60101934100;
        Tue,  2 Feb 2021 16:27:11 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3613819C71;
        Tue,  2 Feb 2021 16:27:08 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 1065030736C73;
        Tue,  2 Feb 2021 17:27:07 +0100 (CET)
Subject: [PATCH bpf-next V15 5/7] bpf: drop MTU check when doing TC-BPF
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
Date:   Tue, 02 Feb 2021 17:27:07 +0100
Message-ID: <161228322699.576669.4552578542207702644.stgit@firesoul>
In-Reply-To: <161228314075.576669.15427172810948915572.stgit@firesoul>
References: <161228314075.576669.15427172810948915572.stgit@firesoul>
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

V15:
 - missing static for function declaration

V9:
 - Make net_device "up" (IFF_UP) check explicit in skb_do_redirect

V4:
 - Keep net_device "up" (IFF_UP) check.
 - Adjustment to handle bpf_redirect_peer() helper

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
Acked-by: John Fastabend <john.fastabend@gmail.com>
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
index bae35c1ae192..e0bc6fb3639b 100644
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
+static int __dev_forward_skb2(struct net_device *dev, struct sk_buff *skb,
+			      bool check_mtu)
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
index f6777e8f9ff7..28735dbb7059 100644
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


