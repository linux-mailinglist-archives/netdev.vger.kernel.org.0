Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9B24A7D8D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348891AbiBCBwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348894AbiBCBwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:00 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB132C061401
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:00 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id c9so851201plg.11
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=yKGkaktrCx/5DHxPDheliVbX84VuGZGwuAJO0WasO08=;
        b=nUHIFWDxBsTfeXtOjHfe9F1iZirVF2WDRO1uNASMkq9F2UOvqqv5hXOCsqn708aSB5
         ih+L4Fn559a1UT9KHXKcPBwkxFSzdqB9c3PddCzv+dIV+1uuHT2k+c/Dj1yIcD3VZwUa
         m65pKcb7FF/WrbeAKu+UeSPJRpOuR4cfwHUdifPJqGMxUk8LW2o/buQTMp+wMLAG2nWy
         4F+6qiOfla86zu0B1CPsc4XsymFXJUdIpz5BP/SSPU+xguavreQb6SezUs6Rb5VhufqJ
         YeFM3X0w9a/gph8H1FdGVBiZRrPazGul+gpf2n0gRGoZFK7Kkia9Jqr6gAu+a4JkUqdf
         z9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yKGkaktrCx/5DHxPDheliVbX84VuGZGwuAJO0WasO08=;
        b=QnxqA0dq77I5qGQP3bf9CTEQRRDc/ScvOFyI22HKfT/rnQAxkDM7m3TVWPQjW0UIIH
         zvZ2Pr3Atwcgs93cZCAgVgLMZjO5P8I+Ls7dMsJ5PV8KgPpdUYz569EGxwrnceQKUUGp
         bxMru/RqTKS6PCNumcr+IVuGEVW2zPArfTdZJXirNCim0PoxTY7IG0NXDzEip/T8MI1Y
         0ULE7V7RX1GCzwhcatNW5rLShBqd5ZnIPJhQGg9NtRb7YXtZLSIepwon1Jx1wk1LsGVL
         WNrlD+A/uCiHMmnZ5Y8kHQoL10dyLRyLs/HnvTtDwABUT7a402+rL2veluo13vtVLvvn
         qB2w==
X-Gm-Message-State: AOAM530JkIdk8cKisLoOnjFjgIoo846ePwyqmkuUbCBb4zm1E9+eH0e8
        aZ58QmhTDIiZSCMBrE3nTUI=
X-Google-Smtp-Source: ABdhPJz7SmRhASJETLI0wCW2hV24TT/w4fW/huxPImlVvdub7MORw/3/gUrfDWQgUV8T+OpIJlxNww==
X-Received: by 2002:a17:90b:1e05:: with SMTP id pg5mr11295416pjb.86.1643853120305;
        Wed, 02 Feb 2022 17:52:00 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:00 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 05/15] ipv6/gso: remove temporary HBH/jumbo header
Date:   Wed,  2 Feb 2022 17:51:30 -0800
Message-Id: <20220203015140.3022854-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

ipv6 tcp and gro stacks will soon be able to build big TCP packets,
with an added temporary Hop By Hop header.

If GSO is involved for these large packets, we need to remove
the temporary HBH header before segmentation happens.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/ipv6.h | 31 +++++++++++++++++++++++++++++++
 net/core/skbuff.c  | 21 ++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index ea2a4351b654f8bc96503aae2b9adcd478e1f8b2..96e916fb933c3e7d4288e86790fcb2bb1353a261 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -464,6 +464,37 @@ bool ipv6_opt_accepted(const struct sock *sk, const struct sk_buff *skb,
 struct ipv6_txoptions *ipv6_update_options(struct sock *sk,
 					   struct ipv6_txoptions *opt);
 
+/* This helper is specialized for BIG TCP needs.
+ * It assumes the hop_jumbo_hdr will immediately follow the IPV6 header.
+ * It assumes headers are already in skb->head, thus the sk argument is only read.
+ */
+static inline bool ipv6_has_hopopt_jumbo(const struct sk_buff *skb)
+{
+	struct hop_jumbo_hdr *jhdr;
+	struct ipv6hdr *nhdr;
+
+	if (likely(skb->len <= GRO_MAX_SIZE))
+		return false;
+
+	if (skb->protocol != htons(ETH_P_IPV6))
+		return false;
+
+	if (skb_network_offset(skb) +
+	    sizeof(struct ipv6hdr) +
+	    sizeof(struct hop_jumbo_hdr) > skb_headlen(skb))
+		return false;
+
+	nhdr = ipv6_hdr(skb);
+
+	if (nhdr->nexthdr != NEXTHDR_HOP)
+		return false;
+
+	jhdr = (struct hop_jumbo_hdr *) (nhdr + 1);
+	if (jhdr->tlv_type != IPV6_TLV_JUMBO || jhdr->hdrlen != 0)
+		return false;
+	return true;
+}
+
 static inline bool ipv6_accept_ra(struct inet6_dev *idev)
 {
 	/* If forwarding is enabled, RA are not accepted unless the special
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0118f0afaa4fce8da167ddf39de4c9f3880ca05b..53f17c7392311e7123628fcab4617efc169905a1 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3959,8 +3959,9 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	skb_frag_t *frag = skb_shinfo(head_skb)->frags;
 	unsigned int mss = skb_shinfo(head_skb)->gso_size;
 	unsigned int doffset = head_skb->data - skb_mac_header(head_skb);
+	int hophdr_len = sizeof(struct hop_jumbo_hdr);
 	struct sk_buff *frag_skb = head_skb;
-	unsigned int offset = doffset;
+	unsigned int offset;
 	unsigned int tnl_hlen = skb_tnl_header_len(head_skb);
 	unsigned int partial_segs = 0;
 	unsigned int headroom;
@@ -3968,6 +3969,7 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	__be16 proto;
 	bool csum, sg;
 	int nfrags = skb_shinfo(head_skb)->nr_frags;
+	struct ipv6hdr *h6;
 	int err = -ENOMEM;
 	int i = 0;
 	int pos;
@@ -3992,6 +3994,23 @@ struct sk_buff *skb_segment(struct sk_buff *head_skb,
 	}
 
 	__skb_push(head_skb, doffset);
+
+	if (ipv6_has_hopopt_jumbo(head_skb)) {
+		/* remove the HBH header.
+		 * Layout: [Ethernet header][IPv6 header][HBH][TCP header]
+		 */
+		memmove(head_skb->data + hophdr_len,
+			head_skb->data,
+			ETH_HLEN + sizeof(struct ipv6hdr));
+		head_skb->data += hophdr_len;
+		head_skb->len -= hophdr_len;
+		head_skb->network_header += hophdr_len;
+		head_skb->mac_header += hophdr_len;
+		doffset -= hophdr_len;
+		h6 = (struct ipv6hdr *)(head_skb->data + ETH_HLEN);
+		h6->nexthdr = IPPROTO_TCP;
+	}
+	offset = doffset;
 	proto = skb_network_protocol(head_skb, NULL);
 	if (unlikely(!proto))
 		return ERR_PTR(-EINVAL);
-- 
2.35.0.rc2.247.g8bbb082509-goog

