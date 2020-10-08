Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63E892875BB
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 16:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730525AbgJHOJp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 10:09:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27918 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730476AbgJHOJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 10:09:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602166177;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=32w48iMNGkmD+it7eg91axPb7iDFt5xqhVL3TNeV8g4=;
        b=VMRJ8zTPtzzzH12RTc67hGLxpA2Sb+5OUbLveOB0DIAEeoEsaXjh9Fs/nf7OtdnIJIsWWp
        1R49ef8DlShjDzb4owKdCvpCfZrD87FE9r4LRq+UPe8RfzyAAv+B0RvjG0zgKGUJx/dR1Z
        7rKvZ1u5jDDSonZ8t4C6Iq2cHS8ccDI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-zNhDG5Z2O_CA2BDK9_zNpA-1; Thu, 08 Oct 2020 10:09:33 -0400
X-MC-Unique: zNhDG5Z2O_CA2BDK9_zNpA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA0C4804018;
        Thu,  8 Oct 2020 14:09:31 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.40.208.18])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D42CD55768;
        Thu,  8 Oct 2020 14:09:28 +0000 (UTC)
Received: from [192.168.42.3] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id E58A730736C8B;
        Thu,  8 Oct 2020 16:09:27 +0200 (CEST)
Subject: [PATCH bpf-next V3 6/6] net: inline and splitup is_skb_forwardable
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        maze@google.com, lmb@cloudflare.com, shaun@tigera.io,
        Lorenzo Bianconi <lorenzo@kernel.org>, marek@cloudflare.com,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, eyal.birger@gmail.com
Date:   Thu, 08 Oct 2020 16:09:27 +0200
Message-ID: <160216616785.882446.3058399056188507434.stgit@firesoul>
In-Reply-To: <160216609656.882446.16642490462568561112.stgit@firesoul>
References: <160216609656.882446.16642490462568561112.stgit@firesoul>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The BPF-helper bpf_skb_fib_lookup() use is_skb_forwardable() that
also checks if net_device is "up", which is unnecessary for this
helper. This patch splitup is_skb_forwardable() into is_skb_fwd_size_ok()
such that the helper can use this instead.

This change also cause is_skb_forwardable() to be inlined in the
existing call sites. Most importantly in dev_forward_skb().

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 include/linux/netdevice.h |   27 +++++++++++++++++++++++++--
 net/core/dev.c            |   21 ---------------------
 net/core/filter.c         |    2 +-
 3 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 58fb7b4869ba..4857c54590b5 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3862,8 +3862,31 @@ int xdp_umem_query(struct net_device *dev, u16 queue_id);
 
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
 int dev_forward_skb(struct net_device *dev, struct sk_buff *skb);
-bool is_skb_forwardable(const struct net_device *dev,
-			const struct sk_buff *skb);
+
+static __always_inline bool is_skb_fwd_size_ok(const struct net_device *dev,
+					       const struct sk_buff *skb)
+{
+	const u32 vlan_hdr_len = 4; /* VLAN_HLEN */
+	unsigned int mtu = dev->mtu + dev->hard_header_len + vlan_hdr_len;
+
+	/* Assumes SKB length at L2 */
+	if (likely(skb->len <= mtu))
+		return true;
+
+	/* If TSO is enabled, we don't care about the length as the packet
+	 * could be forwarded without being segmented before.
+	 */
+	return skb_is_gso(skb);
+}
+
+static __always_inline bool is_skb_forwardable(const struct net_device *dev,
+					       const struct sk_buff *skb)
+{
+	if (unlikely(!(dev->flags & IFF_UP)))
+		return false;
+
+	return is_skb_fwd_size_ok(dev, skb);
+}
 
 static __always_inline int ____dev_forward_skb(struct net_device *dev,
 					       struct sk_buff *skb,
diff --git a/net/core/dev.c b/net/core/dev.c
index 96b455f15872..21b62bda0ef9 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -2186,27 +2186,6 @@ static inline void net_timestamp_set(struct sk_buff *skb)
 			__net_timestamp(SKB);			\
 	}							\
 
-bool is_skb_forwardable(const struct net_device *dev, const struct sk_buff *skb)
-{
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
-}
-EXPORT_SYMBOL_GPL(is_skb_forwardable);
-
 int __dev_forward_skb(struct net_device *dev, struct sk_buff *skb)
 {
 	int ret = ____dev_forward_skb(dev, skb, true);
diff --git a/net/core/filter.c b/net/core/filter.c
index a8e24092e4f5..14e6b93757d4 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5502,7 +5502,7 @@ BPF_CALL_4(bpf_skb_fib_lookup, struct sk_buff *, skb,
 		struct net_device *dev;
 
 		dev = dev_get_by_index_rcu(net, params->ifindex);
-		if (!is_skb_forwardable(dev, skb))
+		if (!is_skb_fwd_size_ok(dev, skb))
 			rc = BPF_FIB_LKUP_RET_FRAG_NEEDED;
 
 		params->mtu = dev->mtu; /* union with tot_len */


