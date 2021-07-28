Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9803D9324
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhG1QYr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:24:47 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31982 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230288AbhG1QYn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:24:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627489480;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dG7SShBa+93pJWuOsLAMXbghStF9LVom0np5u1WWtm4=;
        b=F+hoSFtr3l0mTK4n7qVzdOXUT0HvM7EKHIoxGbG7SGGRVEQ4jO/UcH9XYqnTlzt9q0wHdS
        OXXt2F9iv4SvZXOU5L4LGyVc/5Mw1wWDfEF3FnikC5tngvvpKvmOkCVaJvDCZMTs0FuR+I
        ++u9WtSbEkIwaogrZXHAJccwqcpnPus=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-bSi7T0MVNX6UXVi9BS0wUw-1; Wed, 28 Jul 2021 12:24:39 -0400
X-MC-Unique: bSi7T0MVNX6UXVi9BS0wUw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 356D018C8C00;
        Wed, 28 Jul 2021 16:24:38 +0000 (UTC)
Received: from gerbillo.redhat.com (ovpn-113-169.ams2.redhat.com [10.36.113.169])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 033965C1B4;
        Wed, 28 Jul 2021 16:24:36 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 4/6] net: optimize GRO for the common case.
Date:   Wed, 28 Jul 2021 18:24:02 +0200
Message-Id: <4f4b2aa4021b31c3c398d55628064e186a7ec50d.1627405778.git.pabeni@redhat.com>
In-Reply-To: <cover.1627405778.git.pabeni@redhat.com>
References: <cover.1627405778.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After the previous patches, at GRO time, skb->slow_gro is
usually 0, unless the packets comes from some H/W offload
slowpath or tunnel.

We can optimize the GRO code assuming !skb->slow_gro is likely.
This remove multiple conditionals in the most common path, at the
price of an additional one when we hit the above "slow-paths".

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
---
 net/core/dev.c    | 30 ++++++++++++++++++++++--------
 net/core/skbuff.c |  9 ++++++---
 2 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index fb5d12a3d52d..19565f7497ee 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6014,7 +6014,6 @@ static void gro_list_prepare(const struct list_head *head,
 		diffs |= skb_vlan_tag_present(p) ^ skb_vlan_tag_present(skb);
 		if (skb_vlan_tag_present(p))
 			diffs |= skb_vlan_tag_get(p) ^ skb_vlan_tag_get(skb);
-		diffs |= skb_metadata_dst_cmp(p, skb);
 		diffs |= skb_metadata_differs(p, skb);
 		if (maclen == ETH_HLEN)
 			diffs |= compare_ether_header(skb_mac_header(p),
@@ -6024,17 +6023,29 @@ static void gro_list_prepare(const struct list_head *head,
 				       skb_mac_header(skb),
 				       maclen);
 
-		diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
+		/* in most common scenarions _state is 0
+		 * otherwise we are already on some slower paths
+		 * either skip all the infrequent tests altogether or
+		 * avoid trying too hard to skip each of them individually
+		 */
+		if (!diffs && unlikely(skb->slow_gro | p->slow_gro)) {
+#if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
+			struct tc_skb_ext *skb_ext;
+			struct tc_skb_ext *p_ext;
+#endif
+
+			diffs |= skb_metadata_dst_cmp(p, skb);
+			diffs |= skb_get_nfct(p) ^ skb_get_nfct(skb);
+
 #if IS_ENABLED(CONFIG_SKB_EXTENSIONS) && IS_ENABLED(CONFIG_NET_TC_SKB_EXT)
-		if (!diffs) {
-			struct tc_skb_ext *skb_ext = skb_ext_find(skb, TC_SKB_EXT);
-			struct tc_skb_ext *p_ext = skb_ext_find(p, TC_SKB_EXT);
+			skb_ext = skb_ext_find(skb, TC_SKB_EXT);
+			p_ext = skb_ext_find(p, TC_SKB_EXT);
 
 			diffs |= (!!p_ext) ^ (!!skb_ext);
 			if (!diffs && unlikely(skb_ext))
 				diffs |= p_ext->chain ^ skb_ext->chain;
-		}
 #endif
+		}
 
 		NAPI_GRO_CB(p)->same_flow = !diffs;
 	}
@@ -6299,8 +6310,11 @@ static void napi_reuse_skb(struct napi_struct *napi, struct sk_buff *skb)
 	skb->encapsulation = 0;
 	skb_shinfo(skb)->gso_type = 0;
 	skb->truesize = SKB_TRUESIZE(skb_end_offset(skb));
-	skb_ext_reset(skb);
-	nf_reset_ct(skb);
+	if (unlikely(skb->slow_gro)) {
+		skb_ext_reset(skb);
+		nf_reset_ct(skb);
+		skb->slow_gro = 0;
+	}
 
 	napi->skb = skb;
 }
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a990e11c393c..8231cbddb6ed 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -954,9 +954,12 @@ void __kfree_skb_defer(struct sk_buff *skb)
 
 void napi_skb_free_stolen_head(struct sk_buff *skb)
 {
-	nf_reset_ct(skb);
-	skb_dst_drop(skb);
-	skb_ext_put(skb);
+	if (unlikely(skb->slow_gro)) {
+		nf_reset_ct(skb);
+		skb_dst_drop(skb);
+		skb_ext_put(skb);
+		skb->slow_gro = 0;
+	}
 	napi_skb_cache_put(skb);
 }
 
-- 
2.26.3

