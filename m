Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CBE063C8EF
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 21:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237209AbiK2UHC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 15:07:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237202AbiK2UG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 15:06:59 -0500
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1517C2CCAB
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 12:06:58 -0800 (PST)
Received: by mail-pl1-x64a.google.com with SMTP id y6-20020a17090322c600b00189892baa53so7552783plg.6
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 12:06:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GYy/8BW3WAe+pF6I2ukMLCY23QDbJtir2+qtUsjll+s=;
        b=GB2cmrUO3A78wrpfDHZV4b5pymx9bFEHccxTiTpmtkVerXODXn+CrBvnKsTzONHGu6
         jBxJfKmv38lBbSM3DetdND9GBRjTB4CYk2o4ssEA8G/N4A65bGCTrpKrk5zlyrCTW7ae
         6+aEVV/6JrX6+qHRlvSIjD8YIBqFm4MH9GqA9D4CdiUa4mztUi2qNo35O/BR+8xYiBJr
         up525YZ57m1zvrm1bDSs1jHtZZDydGvCfUE8kN7d/g7CeVeS5MagJlcRGkcHH+g2ZzRQ
         ITcS20qSQGbV1KOhgmjp18U/OB0qNYvfwy0/OSt6JQFyaNP8oGN9MfF5MQNUVEcdG4C+
         j5Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GYy/8BW3WAe+pF6I2ukMLCY23QDbJtir2+qtUsjll+s=;
        b=0fJe1vbejRuSUdV0TbZQzRxKwpySK0L5NZA4siSy5yflFTjfbbKwXBdU4xRRTiq4CZ
         fwunDClLUXsBuI2WjHSRyCHQjq+1CMQTgD854hepoZEumELUb0IlJ7zImAlzIF0oOHd1
         h5zQi4867mlK36MIHR/gIxPLNHPOXk1UEkRXIp6CWC+OIzpCM0p8bzN2mk/Ioli08myZ
         UbkOJetbyljhBMHCZoW4tVtnFAd4Aj8V4+gH41+bvfP80Qo0t/+UO5aDDX8EXf2129L0
         35P4PBfc6o55aQaYFNVEGY4fEvrZOG+NskI11i4ZKuBT8V2rP1+p3MBQGGhs3fi9VeO6
         Hn+g==
X-Gm-Message-State: ANoB5pnn0LfBYTj7f1p7FjQtbj1tkaWKIQkNj8Ps4U7LBu/cne0BGO+8
        oh937DZ9rOvbFDsgk2b/VD7r/MO4TnuwwiA=
X-Google-Smtp-Source: AA0mqf7mf1Ox5kJhk1hM1XqmGp4IZCa7IIIOSnocyQNyCo/w3Ps3UurbrmEs14D7h7NP56yl3wL/kYk5xI71WH4=
X-Received: from coco0920.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:5738])
 (user=lixiaoyan job=sendgmr) by 2002:a17:90a:458a:b0:214:166e:e202 with SMTP
 id v10-20020a17090a458a00b00214166ee202mr62027256pjg.165.1669752417447; Tue,
 29 Nov 2022 12:06:57 -0800 (PST)
Date:   Tue, 29 Nov 2022 20:06:52 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
Message-ID: <20221129200653.962019-1-lixiaoyan@google.com>
Subject: [RFC net-next v3 1/2] IPv6/GRO: generic helper to remove temporary
 HBH/jumbo header in driver
From:   Coco Li <lixiaoyan@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <michael.chan@broadcom.com>
Cc:     netdev@vger.kernel.org,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        linux-kernel@vger.kernel.org, Coco Li <lixiaoyan@google.com>
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

Signed-off-by: Coco Li <lixiaoyan@google.com>
---
 include/net/ipv6.h     | 35 +++++++++++++++++++++++++++++++++++
 net/ipv6/ip6_offload.c | 27 ++++-----------------------
 2 files changed, 39 insertions(+), 23 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index d383c895592a..08adec74f067 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -500,6 +500,41 @@ static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
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
+	if (unlikely(!pskb_may_pull(skb, hophdr_len)))
+		return -1;
+
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
2.38.1.584.g0f3c55d4c2-goog

