Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC23641064
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:12:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbiLBWMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:12:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiLBWMT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:12:19 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0D2F899B
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 14:12:18 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id t5-20020a5b07c5000000b006dfa2102debso6517610ybq.4
        for <netdev@vger.kernel.org>; Fri, 02 Dec 2022 14:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aqtQqt3CYbfEmZYhGTH/QgYDRef/TM1s51odegjsqeI=;
        b=HdgVFnSLUnEmFG4MkBjFMO4G2tTWjjsOcCEdrCCe+T/mJxH48wYxh0iNqe6oMNckjR
         OPoNQfdgUK0jrKTtdGC9jVZRT8z+mfsZwc65UsCrVc/ms9azzlRS/eOsXn00RItDM4TL
         1b623/78nCbsdtkrLJe7LBgL2mlvaW2QnLxQDEECMJy8iN18LfGdLCv1XAanIvgQ/ifn
         hKzUAN9CEY98iN9PzLbfT3UDryQE3BXEzb/qWphS/1MWZNDX25qiiIeHhGSWJ6UVIcVG
         0Uqu6qrgKrnGHZJ3OKKgpDfz8JkTn92v0KcwF/ZxfzKV+epZN5gnlW3XbWzpPa8xogbh
         tpTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aqtQqt3CYbfEmZYhGTH/QgYDRef/TM1s51odegjsqeI=;
        b=v6EeYFxRUybG8DDSPLwOBmFNzYZsK0NCZfGj+JnxMbwtLF5fn3L0sPEknpu5qg5+AD
         ZxIk63VjJ/VhJnpp/UGMwmL7N8Ev/GWuZsRnjNNE+P8pn2AawjPR/mdtArv8pmnDX3Ry
         /mZVveXjBX1YQLlNA3g1BduCDNWESJ6/2H3HB4EfP21T5AGXjwFVtmsTQ6vQkpmqOnrC
         f0LYArN6jyafyWHtDx0qxkFjSJAvg2Qwu0qQqrS6PDIFRrz2HQvnVYCeyfjYqYGkKS+g
         xfyM4cjaEQppQciox5IZOhtDt4wA3DIk2WfdHxZakgzD3TD834P0sEzePGZywkE8ZSWm
         agRw==
X-Gm-Message-State: ANoB5pm3zIU5dMJlsy21B/TFc951zlejK9QX/nyZfBwB+zVtg2z289q8
        DCA1SjPm346R4v6iuePyFdGN/elKLwoAWCg=
X-Google-Smtp-Source: AA0mqf5ciOxlekVv9aOeSzePlJQ4uYKqkzOIVZqTyxgblQDfY//KIiJDG0IH/dEbc4yf6QjRcXFMEfjrtp//x28=
X-Received: from lixiaoyan-desktop.svl.corp.google.com ([2620:15c:2c4:201:806c:1abb:ce24:13cf])
 (user=lixiaoyan job=sendgmr) by 2002:a81:510:0:b0:356:4adb:67b4 with SMTP id
 16-20020a810510000000b003564adb67b4mr57763344ywf.141.1670019138178; Fri, 02
 Dec 2022 14:12:18 -0800 (PST)
Date:   Fri,  2 Dec 2022 14:12:12 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.39.0.rc0.267.gcb52ba06e7-goog
Message-ID: <20221202221213.236564-1-lixiaoyan@google.com>
Subject: [RFC net-next v4 1/2] IPv6/GRO: generic helper to remove temporary
 HBH/jumbo header in driver
From:   Coco Li <lixiaoyan@google.com>
To:     "David S. Miller" <davem@davemloft.net>,
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
2.39.0.rc0.267.gcb52ba06e7-goog

