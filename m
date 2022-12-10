Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B93648D1E
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 05:17:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiLJERe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 23:17:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiLJERK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 23:17:10 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F107D04E
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 20:16:50 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id c12-20020a170902d48c00b00189e5443387so5696462plg.15
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 20:16:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C6RTbmmSkPOFm902+mLMHGPXN9xcjb04HtLDqi+Zh0c=;
        b=BvO0Vvnynj96CFRnXCmTlxB2yUgmetu/LkyKo83qxWb7GC5KxrSYBwHscaynK6luPu
         sfvKOizMxzBtaEwMS0MrAG7ys4gWlbeE5d4PvbpEsoQCEGAnVrvs9UqIq1L3dvTrVmB4
         sxsoQzAV/K+9upPPpNXGaO513a6HTYhNAxZE8pd+mI/YOhOvgCm+Vxajs5j72RwQw1dS
         n77gzfpXonUFXlPYp7Yw3hO3zxu6aAu/cA7uyc05gF7uVoanoRiL2iIvWzicf+NFB4cl
         rypFBaVwhkN3QK5DFXDvbUHguHVLeAwQNDU8aBKYG77ZN0udlOg8YJD3P/0p6ZWf6nS+
         vNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C6RTbmmSkPOFm902+mLMHGPXN9xcjb04HtLDqi+Zh0c=;
        b=CkuwLo2fm8P7jQb6pGGBfBiBQztp5tkcTVFnn8GhNasiTgEvRKtJfqymZYsfCm87wL
         P8vsJ+zBVOVNvOU5pjfIY4CeUfYhQG11W6OYGR5P7n4hX7JNBz8nyditNNPeOx+PoEne
         ZhndKs04rs2T3H2Zk2FupyeDmZupVmTAvSuhzGHFa/2KngKlDABajpI8+ivaxOV0ul2I
         aNVlu3DYEdlPx4jUPTGvPT/vAY/gInPLEo8Cp/DSSC7C0AtAeWr1ECqayfX/rI4Elvfk
         9JrOZlXvnrwWTmN+ze68AHCeJKHJpF91n1vvpXr3iz5C7NhMmtu9glyZwOShLxF1PKqL
         IbNA==
X-Gm-Message-State: ANoB5pk6WOe8He7y94UGpB5HthHVIcrbbWfO5gwxMb+Q/yhLSUjwn/BQ
        k87dHoDWtg6ufmlg+tHvKQBtQI1y65ttrs8=
X-Google-Smtp-Source: AA0mqf5ReNfWId0H/gPB/QbbYUelHRoprIljtlKARcNQUX7xC3FBUYq9e6dGGf3dNWwFpgfcxul4j4LTOBFxFLw=
X-Received: from coco0920.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5738])
 (user=lixiaoyan job=sendgmr) by 2002:a17:90a:2a88:b0:220:1f03:129b with SMTP
 id j8-20020a17090a2a8800b002201f03129bmr28851pjd.0.1670645809623; Fri, 09 Dec
 2022 20:16:49 -0800 (PST)
Date:   Sat, 10 Dec 2022 04:16:45 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221210041646.3587757-1-lixiaoyan@google.com>
Subject: [PATCH net-next v6 1/2] IPv6/GRO: generic helper to remove temporary
 HBH/jumbo header in driver
From:   Coco Li <lixiaoyan@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HK_RANDOM_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPv6/TCP and GRO stacks can build big TCP packets with an added
temporary Hop By Hop header.

Is GSO is not involved, then the temporary header needs to be removed in
the driver. This patch provides a generic helper for drivers that need
to modify their headers in place.

Tested:
Compiled and ran with ethtool -K eth1 tso off
Could send Big TCP packets

Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 include/net/ipv6.h     | 33 +++++++++++++++++++++++++++++++++
 net/ipv6/ip6_offload.c | 27 ++++-----------------------
 2 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index d383c895592a..03f3af02a9a6 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -500,6 +500,39 @@ static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
 	return jhdr->nexthdr;
 }
 
+/* Return 0 if HBH header is successfully removed
+ * Or if HBH removal is unnecessary (packet is not big TCP)
+ * Return error to indicate dropping the packet
+ */
+static inline int ipv6_hopopt_jumbo_remove(struct sk_buff *skb)
+{
+	const int hophdr_len = sizeof(struct hop_jumbo_hdr);
+	int nexthdr = ipv6_has_hopopt_jumbo(skb);
+	struct ipv6hdr *h6;
+
+	if (!nexthdr)
+		return 0;
+
+	if (skb_cow_head(skb, 0))
+		return -1;
+
+	/* Remove the HBH header.
+	 * Layout: [Ethernet header][IPv6 header][HBH][L4 Header]
+	 */
+	memmove(skb_mac_header(skb) + hophdr_len, skb_mac_header(skb),
+		skb_network_header(skb) - skb_mac_header(skb) +
+		sizeof(struct ipv6hdr));
+
+	__skb_pull(skb, hophdr_len);
+	skb->network_header += hophdr_len;
+	skb->mac_header += hophdr_len;
+
+	h6 = ipv6_hdr(skb);
+	h6->nexthdr = nexthdr;
+
+	return 0;
+}
+
 static inline bool ipv6_accept_ra(struct inet6_dev *idev)
 {
 	/* If forwarding is enabled, RA are not accepted unless the special
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index 3ee345672849..00dc2e3b0184 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -77,7 +77,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	struct ipv6hdr *ipv6h;
 	const struct net_offload *ops;
-	int proto, nexthdr;
+	int proto, err;
 	struct frag_hdr *fptr;
 	unsigned int payload_len;
 	u8 *prevhdr;
@@ -87,28 +87,9 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 	bool gso_partial;
 
 	skb_reset_network_header(skb);
-	nexthdr = ipv6_has_hopopt_jumbo(skb);
-	if (nexthdr) {
-		const int hophdr_len = sizeof(struct hop_jumbo_hdr);
-		int err;
-
-		err = skb_cow_head(skb, 0);
-		if (err < 0)
-			return ERR_PTR(err);
-
-		/* remove the HBH header.
-		 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
-		 */
-		memmove(skb_mac_header(skb) + hophdr_len,
-			skb_mac_header(skb),
-			ETH_HLEN + sizeof(struct ipv6hdr));
-		skb->data += hophdr_len;
-		skb->len -= hophdr_len;
-		skb->network_header += hophdr_len;
-		skb->mac_header += hophdr_len;
-		ipv6h = (struct ipv6hdr *)skb->data;
-		ipv6h->nexthdr = nexthdr;
-	}
+	err = ipv6_hopopt_jumbo_remove(skb);
+	if (err)
+		return ERR_PTR(err);
 	nhoff = skb_network_header(skb) - skb_mac_header(skb);
 	if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
 		goto out;
-- 
2.39.0.rc1.256.g54fd8350bd-goog

