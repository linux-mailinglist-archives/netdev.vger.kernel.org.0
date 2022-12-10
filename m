Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3A4F648D18
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 05:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiLJEQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 23:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiLJEPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 23:15:37 -0500
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D518775095
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 20:15:36 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id k21-20020aa78215000000b00575ab46ca2cso4507207pfi.20
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 20:15:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=C6RTbmmSkPOFm902+mLMHGPXN9xcjb04HtLDqi+Zh0c=;
        b=m016B3i2vKK71JoU/QuaKOQwHq3IqeqUowJnhViy6hBpmgxKeZFYoihD6DtUoJHPfR
         WHxJAWKBdiO9gjwKaXZaOb1uoJ6NakmPTQqe3n08tCsLWj8o61rF8C+yAk//QJzFr/bF
         rpJGYCKIgC97ZuG1tSE6i+c8erLeDoqBJoq6/lkYAb1k+YfdffkGxExc8ZJXElPRhJ6B
         VgiX3kN/x/2NCKMqK6o7PT91d6X63/1VwudkBy29bSPGGWwoU2AqnRivktuZmjUgXCzx
         9HyokCsFDpAHBnpShIBvvB/v55F4RS0prZFTJEyUQp2jn69yLncx1rix50GtHZ8ofg4K
         s4mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C6RTbmmSkPOFm902+mLMHGPXN9xcjb04HtLDqi+Zh0c=;
        b=ZS49KcxdcLSipHYk3QjMvjQLVM0i+bL50s1YfxVKkjeDZn/ArAcjLUf1xiKO+pOF+K
         kts005c/ht5pjmU4nh9pXk56gtHjWbHbFKAoaxCLERV3mcMn91f5Yig+sbzm7PWer+4E
         UdUD/Bqjd9X9LkCcORkSKL5ZZUYPHN8AAoUCMGkORqVjBKpNu823DtlccLYOLrb9mE7e
         fqMi5bqJnO71JjlR/2jVzdm4iZGu7ag3lXN+METNGJm3G8BebT9aB9yxN62MGMDuXmWL
         zl3SdDOYW3PPDVLUGVwRda6W2EO/6/Fgb7ENXG4r+GhrUQCLizPt5uZUeHQ06q1oY5QO
         +F6Q==
X-Gm-Message-State: ANoB5pmTZ2EA7J2cbbWTImZJSSI/9Wg9+uyXJyh4LM1yBxVsGP2hBv0m
        WL6Mz4R5wh40r2uOBp584tyQi6tCfld6kEc=
X-Google-Smtp-Source: AA0mqf6HXkAwZX78onTFSv87WbXAsJWHol/sDFzMQYGV54edq8aIUAXDT0CxnANGm1GyunbNYT2ZiHR6crPYy+0=
X-Received: from coco0920.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5738])
 (user=lixiaoyan job=sendgmr) by 2002:a17:90a:384c:b0:219:ed2c:f253 with SMTP
 id l12-20020a17090a384c00b00219ed2cf253mr15590300pjf.211.1670645736363; Fri,
 09 Dec 2022 20:15:36 -0800 (PST)
Date:   Sat, 10 Dec 2022 04:15:30 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc1.256.g54fd8350bd-goog
Message-ID: <20221210041531.3586437-1-lixiaoyan@google.com>
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
Cc:     netdev@vger.kernel.org, inux-kernel@vger.kernel.org,
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

