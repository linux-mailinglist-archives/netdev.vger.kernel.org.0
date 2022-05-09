Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D6E52078F
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 00:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbiEIW17 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 18:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbiEIW0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 18:26:03 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659E11756B1
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 15:22:05 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id bo5so13403264pfb.4
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 15:22:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vouoEdwTH20px730Nji3ldDgd4hnD+bR+BzxtMCTNyw=;
        b=CZTQ6FaoPETFLlmrX8yPkbrnHYIrnKVswuLSfwP74UoWavYGrCr2Vqla4aYUFRe5g/
         8j3sG8xYtoBVBQFIsN5O6+Zga1oaK3mCKvnYnkvQ8TSmIghxLCYYWju7+7SDsPcrJV6Q
         6D/O9+813MISsRXdzeyglUBZ/StonX4rHQAFCh15WDeSTiVYkczCet9OyFUGwJUEklKH
         jWL1dMXh0DsNoZkWiypLnFoPheeKnqwvJzxuOC1H69KHlovRFvEa6wPmFHZWJNVfkZ1+
         /BHwPW7VFhn2ms4m5oy4PrRORDsnPUea56G3yTmEkcJJicfMIJKP769T8DNiUENwzeN9
         kmLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vouoEdwTH20px730Nji3ldDgd4hnD+bR+BzxtMCTNyw=;
        b=rH8mll9R6JkxhfLgAO2ynMdPXo9Y2xxXvmw9bNO/3OJSYSuysaSJPNlXzTGtE/d+fp
         Z6IPCe9ordOcbEyh/a2kf7pHgz4XWNJLqzNdjLBvxeX3S6y9snRzDCSrlL7NyTfmC3uR
         GWnWQQLhD/P5MTw49XFACFpORHk2smcc8YWv78UDCnSUScL8EwGlwsk1bo8diML2sIPc
         j2hCjZUvgCYESWb8Qs4OMCHj+ad7DejPf5Ms7UCvoOthqTbMt+i+d7SrJkuQKvoyQ0uC
         pMjQ7uogwCuATF03YAjFAEOKnxpeHXc02el1fjw+SVvX/xg1mn9dUjP1bRBLz6QXoNQd
         SeYg==
X-Gm-Message-State: AOAM531oioEYFoDHifGWKoVJAv5fkNcxNrSz9p8fNd9cKSYGgxF3gdFN
        vaXFBdBDOywxQtLQ3s8VM3s=
X-Google-Smtp-Source: ABdhPJxL/2PeWFm2ZMQaAM6JWxq9UYebNEnS0WehfPEAlcCaQUOm24u4cQSPCiyQNTNK1g3YI95fNA==
X-Received: by 2002:a63:6987:0:b0:3c6:c3cb:cf4c with SMTP id e129-20020a636987000000b003c6c3cbcf4cmr5164966pgc.198.1652134924961;
        Mon, 09 May 2022 15:22:04 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:5d30:4e79:203f:a909])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902f0cb00b0015e8d4eb1efsm395823pla.57.2022.05.09.15.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 15:22:04 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v5 net-next 06/13] ipv6/gso: remove temporary HBH/jumbo header
Date:   Mon,  9 May 2022 15:21:42 -0700
Message-Id: <20220509222149.1763877-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
In-Reply-To: <20220509222149.1763877-1-eric.dumazet@gmail.com>
References: <20220509222149.1763877-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

ipv6 tcp and gro stacks will soon be able to build big TCP packets,
with an added temporary Hop By Hop header.

If GSO is involved for these large packets, we need to remove
the temporary HBH header before segmentation happens.

v2: perform HBH removal from ipv6_gso_segment() instead of
    skb_segment() (Alexander feedback)

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h     | 33 +++++++++++++++++++++++++++++++++
 net/ipv6/ip6_offload.c | 24 +++++++++++++++++++++++-
 2 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index 63d019953c47ea03d3b723a58c25e83c249489a9..b6df0314aa02dd1c4094620145ccb24da7195b2b 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -467,6 +467,39 @@ bool ipv6_opt_accepted(const struct sock *sk, const struct sk_buff *skb,
 struct ipv6_txoptions *ipv6_update_options(struct sock *sk,
 					   struct ipv6_txoptions *opt);
 
+/* This helper is specialized for BIG TCP needs.
+ * It assumes the hop_jumbo_hdr will immediately follow the IPV6 header.
+ * It assumes headers are already in skb->head.
+ * Returns 0, or IPPROTO_TCP if a BIG TCP packet is there.
+ */
+static inline int ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
+{
+	const struct hop_jumbo_hdr *jhdr;
+	const struct ipv6hdr *nhdr;
+
+	if (likely(skb->len <= GRO_MAX_SIZE))
+		return 0;
+
+	if (skb->protocol != htons(ETH_P_IPV6))
+		return 0;
+
+	if (skb_network_offset(skb) +
+	    sizeof(struct ipv6hdr) +
+	    sizeof(struct hop_jumbo_hdr) > skb_headlen(skb))
+		return 0;
+
+	nhdr = ipv6_hdr(skb);
+
+	if (nhdr->nexthdr != NEXTHDR_HOP)
+		return 0;
+
+	jhdr = (const struct hop_jumbo_hdr *) (nhdr + 1);
+	if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0 ||
+	    jhdr->nexthdr != IPPROTO_TCP)
+		return 0;
+	return jhdr->nexthdr;
+}
+
 static inline bool ipv6_accept_ra(struct inet6_dev *idev)
 {
 	/* If forwarding is enabled, RA are not accepted unless the special
diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index c4fc03c1ac99dbecd92e2b47b2db65374197434d..a6a6c1539c28d242ef8c35fcd5ce900512ce912d 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -77,7 +77,7 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
 	struct ipv6hdr *ipv6h;
 	const struct net_offload *ops;
-	int proto;
+	int proto, nexthdr;
 	struct frag_hdr *fptr;
 	unsigned int payload_len;
 	u8 *prevhdr;
@@ -87,6 +87,28 @@ static struct sk_buff *ipv6_gso_segment(struct sk_buff *skb,
 	bool gso_partial;
 
 	skb_reset_network_header(skb);
+	nexthdr = ipv6_has_hopopt_jumbo(skb);
+	if (nexthdr) {
+		const int hophdr_len = sizeof(struct hop_jumbo_hdr);
+		int err;
+
+		err = skb_cow_head(skb, 0);
+		if (err < 0)
+			return ERR_PTR(err);
+
+		/* remove the HBH header.
+		 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+		 */
+		memmove(skb_mac_header(skb) + hophdr_len,
+			skb_mac_header(skb),
+			ETH_HLEN + sizeof(struct ipv6hdr));
+		skb->data += hophdr_len;
+		skb->len -= hophdr_len;
+		skb->network_header += hophdr_len;
+		skb->mac_header += hophdr_len;
+		ipv6h = (struct ipv6hdr *)skb->data;
+		ipv6h->nexthdr = nexthdr;
+	}
 	nhoff = skb_network_header(skb) - skb_mac_header(skb);
 	if (unlikely(!pskb_may_pull(skb, sizeof(*ipv6h))))
 		goto out;
-- 
2.36.0.512.ge40c2bad7a-goog

