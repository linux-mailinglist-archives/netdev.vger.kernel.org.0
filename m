Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDCE526963
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:34:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383359AbiEMSed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383355AbiEMSeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:25 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA806005C
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:24 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id h24so2940881pgh.12
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6/IVrc+Ey0Jm1Ug9sRKkrej9ee9YLPPE75TJPe7ZRDw=;
        b=f+Ubc9susxayKG/OZRQ8pdwl7vwyxUEUnm6rn+VdBa8OaEPqSVE/XaiQ67qo/4Mcx6
         wotAWht4wPeNzH//cLRGgOWr6BP9lNX7A2VEcWr2wpuNUNPYBK9z13nZEJfj7LBhWwuD
         xp8Ji9mu7wDn2sRSRoV6Vy3RzsBBC1JONa0yJvuZ4f2DR6cUW5/o8qZT134pU9ReObEt
         NTcmfzoyVXPzNVrybF2nAW+02yOOta37DDmxxHTShWHS+InUe1s1BZ2AQsskPv0qCXgO
         bYAzBKjgkHtlN9iqtc+YIStS+zQDu2Phza2osNA0mcPcOg1ADqHkElR7n4ZXKzmM+E+K
         5mZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6/IVrc+Ey0Jm1Ug9sRKkrej9ee9YLPPE75TJPe7ZRDw=;
        b=gPwygy5cwxCpYjo/vbsItnDOxHgmDWND3xPQdBtgo0CtuEdoUUXz8wiaB6HEPwKSmM
         t5RvYe8MyVOw99U7CzWiArnPL/q8jvQIwew1C/ulD81Vke/S0GZbiZNVjoQ5pYD7TFP/
         ZlPE7qEzLxCnjXvoWvrkNDh2yCHlNxno8SgRumfh06TLu9nK74Xxu/pPASeetrNWX9Ce
         H0k31lwt+7B2r1CnQ0rhE4j7WeNsbboeVIRgyN5sRQoj2/XpwOMCe5XmyyH6EOF8UyTe
         DeFAfnLdzeOt5xz5XSLcJ3NxUZ+6B1CjVxaLUrY4wKbx6vAGXwqbvmzCuQDIZlw8SelL
         Tm4A==
X-Gm-Message-State: AOAM532y5CNuEJYRaJ7M09gpWDcWpA9hclQxUa+ajqCwT0y2tKv6igQF
        sozh47e6piGwanLBWV+nbtg=
X-Google-Smtp-Source: ABdhPJxTfze0fJGHVtBd7TAmwiozOwiqRKhkq/r4QhDkfarZFBuadTBR4ZrSTe8sg8merY3KLnv0WQ==
X-Received: by 2002:a63:798c:0:b0:3db:7719:59d3 with SMTP id u134-20020a63798c000000b003db771959d3mr5014291pgc.303.1652466864099;
        Fri, 13 May 2022 11:34:24 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:23 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v7 net-next 06/13] ipv6/gso: remove temporary HBH/jumbo header
Date:   Fri, 13 May 2022 11:34:01 -0700
Message-Id: <20220513183408.686447-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.550.gb090851708-goog
In-Reply-To: <20220513183408.686447-1-eric.dumazet@gmail.com>
References: <20220513183408.686447-1-eric.dumazet@gmail.com>
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
Acked-by: Alexander Duyck <alexanderduyck@fb.com>
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
2.36.0.550.gb090851708-goog

