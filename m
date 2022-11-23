Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC1BE6356BA
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:34:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237817AbiKWJdN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbiKWJcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:32:21 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7321CB14
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 01:31:22 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 648C6204E0;
        Wed, 23 Nov 2022 10:31:21 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YwYORbTJs8RU; Wed, 23 Nov 2022 10:31:20 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 382052052D;
        Wed, 23 Nov 2022 10:31:20 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 32E8380004A;
        Wed, 23 Nov 2022 10:31:20 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 23 Nov 2022 10:31:20 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Wed, 23 Nov
 2022 10:31:19 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 378653182F9A; Wed, 23 Nov 2022 10:31:19 +0100 (CET)
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>
Subject: [PATCH 3/6] xfrm: replay: Fix ESN wrap around for GSO
Date:   Wed, 23 Nov 2022 10:31:13 +0100
Message-ID: <20221123093117.434274-4-steffen.klassert@secunet.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221123093117.434274-1-steffen.klassert@secunet.com>
References: <20221123093117.434274-1-steffen.klassert@secunet.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Langrock <christian.langrock@secunet.com>

When using GSO it can happen that the wrong seq_hi is used for the last
packets before the wrap around. This can lead to double usage of a
sequence number. To avoid this, we should serialize this last GSO
packet.

Fixes: d7dbefc45cf5 ("xfrm: Add xfrm_replay_overflow functions for offloading")
Co-developed-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Christian Langrock <christian.langrock@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
---
 net/ipv4/esp4_offload.c |  3 +++
 net/ipv6/esp6_offload.c |  3 +++
 net/xfrm/xfrm_device.c  | 15 ++++++++++++++-
 net/xfrm/xfrm_replay.c  |  2 +-
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 170152772d33..3969fa805679 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -314,6 +314,9 @@ static int esp_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features_
 			xo->seq.low += skb_shinfo(skb)->gso_segs;
 	}
 
+	if (xo->seq.low < seq)
+		xo->seq.hi++;
+
 	esp.seqno = cpu_to_be64(seq + ((u64)xo->seq.hi << 32));
 
 	ip_hdr(skb)->tot_len = htons(skb->len);
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 79d43548279c..242f4295940e 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -346,6 +346,9 @@ static int esp6_xmit(struct xfrm_state *x, struct sk_buff *skb,  netdev_features
 			xo->seq.low += skb_shinfo(skb)->gso_segs;
 	}
 
+	if (xo->seq.low < seq)
+		xo->seq.hi++;
+
 	esp.seqno = cpu_to_be64(xo->seq.low + ((u64)xo->seq.hi << 32));
 
 	len = skb->len - sizeof(struct ipv6hdr);
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 5f5aafd418af..21269e8f2db4 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -97,6 +97,18 @@ static void xfrm_outer_mode_prep(struct xfrm_state *x, struct sk_buff *skb)
 	}
 }
 
+static inline bool xmit_xfrm_check_overflow(struct sk_buff *skb)
+{
+	struct xfrm_offload *xo = xfrm_offload(skb);
+	__u32 seq = xo->seq.low;
+
+	seq += skb_shinfo(skb)->gso_segs;
+	if (unlikely(seq < xo->seq.low))
+		return true;
+
+	return false;
+}
+
 struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t features, bool *again)
 {
 	int err;
@@ -134,7 +146,8 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		return skb;
 	}
 
-	if (skb_is_gso(skb) && unlikely(x->xso.dev != dev)) {
+	if (skb_is_gso(skb) && (unlikely(x->xso.dev != dev) ||
+				unlikely(xmit_xfrm_check_overflow(skb)))) {
 		struct sk_buff *segs;
 
 		/* Packet got rerouted, fixup features and segment it. */
diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 9f4d42eb090f..ce56d659c55a 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -714,7 +714,7 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 			oseq += skb_shinfo(skb)->gso_segs;
 		}
 
-		if (unlikely(oseq < replay_esn->oseq)) {
+		if (unlikely(xo->seq.low < replay_esn->oseq)) {
 			XFRM_SKB_CB(skb)->seq.output.hi = ++oseq_hi;
 			xo->seq.hi = oseq_hi;
 			replay_esn->oseq_hi = oseq_hi;
-- 
2.25.1

