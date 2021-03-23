Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D77F3459A7
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 09:26:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbhCWI0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 04:26:23 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:49620 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229962AbhCWI0G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Mar 2021 04:26:06 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 603BD20322
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:26:05 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Wrv7V-aogxoT for <netdev@vger.kernel.org>;
        Tue, 23 Mar 2021 09:26:00 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 13E0720184
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 09:26:00 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 23 Mar 2021 09:25:59 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 23 Mar
 2021 09:25:59 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 0E0433180449; Tue, 23 Mar 2021 09:25:59 +0100 (CET)
Date:   Tue, 23 Mar 2021 09:25:59 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
Subject: [PATCH ipsec] xfrm: Provide private skb extensions for segmented and
 hw offloaded ESP packets
Message-ID: <20210323082559.GO62598@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec
crypto offload.") added a XFRM_XMIT flag to avoid duplicate ESP trailer
insertion on HW offload. This flag is set on the secpath that is shared
amongst segments. This lead to a situation where some segments are
not transformed correctly when segmentation happens at layer 3.

Fix this by using private skb extensions for segmented and hw offloaded
ESP packets.

Fixes: 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec crypto offload.")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 include/linux/skbuff.h  |  1 +
 net/core/skbuff.c       | 23 ++++++++++++++++++-----
 net/ipv4/esp4_offload.c | 16 +++++++++++++++-
 net/ipv6/esp6_offload.c | 16 +++++++++++++++-
 net/xfrm/xfrm_device.c  |  2 --
 5 files changed, 49 insertions(+), 9 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 6d0a33d1c0db..89e39dea6834 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4243,6 +4243,7 @@ void *__skb_ext_set(struct sk_buff *skb, enum skb_ext_id id,
 void *skb_ext_add(struct sk_buff *skb, enum skb_ext_id id);
 void __skb_ext_del(struct sk_buff *skb, enum skb_ext_id id);
 void __skb_ext_put(struct skb_ext *ext);
+struct skb_ext *skb_ext_cow(struct skb_ext *old, unsigned int old_active); 
 
 static inline void skb_ext_put(struct sk_buff *skb)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 545a472273a5..5a7cddc6aee1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6282,14 +6282,11 @@ struct skb_ext *__skb_ext_alloc(gfp_t flags)
 	return new;
 }
 
-static struct skb_ext *skb_ext_maybe_cow(struct skb_ext *old,
-					 unsigned int old_active)
+struct skb_ext *skb_ext_cow(struct skb_ext *old,
+				     unsigned int old_active)
 {
 	struct skb_ext *new;
 
-	if (refcount_read(&old->refcnt) == 1)
-		return old;
-
 	new = kmem_cache_alloc(skbuff_ext_cache, GFP_ATOMIC);
 	if (!new)
 		return NULL;
@@ -6306,6 +6303,22 @@ static struct skb_ext *skb_ext_maybe_cow(struct skb_ext *old,
 			xfrm_state_hold(sp->xvec[i]);
 	}
 #endif
+	return new;
+}
+EXPORT_SYMBOL(skb_ext_cow);
+
+static struct skb_ext *skb_ext_maybe_cow(struct skb_ext *old,
+					 unsigned int old_active)
+{
+	struct skb_ext *new;
+
+	if (refcount_read(&old->refcnt) == 1)
+		return old;
+
+	new = skb_ext_cow(old, old_active);
+	if (!new)
+		return NULL;
+
 	__skb_ext_put(old);
 	return new;
 }
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 601f5fbfc63f..4e85e38c5fe3 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -251,6 +251,7 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	struct crypto_aead *aead;
 	struct esp_info esp;
 	bool hw_offload = true;
+	struct skb_ext *ext;
 	__u32 seq;
 
 	esp.inplace = true;
@@ -312,8 +313,21 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 	ip_hdr(skb)->tot_len = htons(skb->len);
 	ip_send_check(ip_hdr(skb));
 
-	if (hw_offload)
+	if (hw_offload) {
+		ext = skb_ext_cow(skb->extensions, skb->active_extensions);
+		if (!ext)
+			return -ENOMEM;
+
+		__skb_ext_put(skb->extensions);
+		skb->extensions = ext;
+
+		xo = xfrm_offload(skb);
+		if (!xo)
+			return -EINVAL;
+
+		xo->flags |= XFRM_XMIT;
 		return 0;
+	}
 
 	err = esp_output_tail(x, skb, &esp);
 	if (err)
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 1ca516fb30e1..2dc006930e32 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -286,6 +286,7 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 	struct xfrm_offload *xo;
 	struct crypto_aead *aead;
 	struct esp_info esp;
+	struct skb_ext *ext;
 	bool hw_offload = true;
 	__u32 seq;
 
@@ -346,8 +347,21 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 
 	ipv6_hdr(skb)->payload_len = htons(len);
 
-	if (hw_offload)
+	if (hw_offload) {
+		ext = skb_ext_cow(skb->extensions, skb->active_extensions);
+		if (!ext)
+			return -ENOMEM;
+
+		__skb_ext_put(skb->extensions);
+		skb->extensions = ext;
+
+		xo = xfrm_offload(skb);
+		if (!xo)
+			return -EINVAL;
+
+		xo->flags |= XFRM_XMIT;
 		return 0;
+	}
 
 	err = esp6_output_tail(x, skb, &esp);
 	if (err)
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index edf11893dbe8..6d6917b68856 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -134,8 +134,6 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
-	xo->flags |= XFRM_XMIT;
-
 	if (skb_is_gso(skb) && unlikely(x->xso.dev != dev)) {
 		struct sk_buff *segs;
 
-- 
2.25.1

