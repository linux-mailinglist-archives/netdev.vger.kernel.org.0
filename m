Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C74C4D40E0
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 06:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239651AbiCJFs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 00:48:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239636AbiCJFsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 00:48:18 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92A42F957C
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 21:47:18 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 132so3850217pga.5
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 21:47:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WarTF79sMF9Xn0mTSt/aSUNBEE1Q4B+hWX/sa1IOapE=;
        b=FnhORxPJsZtiDhe4i3M84qF6hNu4q54JxjK3HKH6aJKkF27L2NInWZWZLwqUT0pxFD
         24gceujrYjnMDk6/7+ktZLkg7VMFXrYMqZG+NJW+s0D74FMuxZvMce/yv14VDDgeMWXs
         BIyJOLc9bsarXJ6OkzBBQkGoB+h2yLScHLcXt9jYyE65zeeYWGNvlyf78Y2ydUaAsqNh
         HNmAHLb9e+KE5I6UL3CQYHM5wT4MMcwY+q8mBItVfWM+dCfMq3Xgnmi4mwQ6/+9DxABD
         be/7FqR7hvuP/U32Rh9Y1wU31sT6A107E6VbPuhJfrj3zP5+WPmp3WEy57buqYLi9eJl
         2LLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WarTF79sMF9Xn0mTSt/aSUNBEE1Q4B+hWX/sa1IOapE=;
        b=wI1zZcyoGd6r6WwkBLfTqLrOBLO0dJhjM6fLiGisxPOpZZuMlcHaY6aLdPL7RTchzy
         zK5THM+yOI9+8tlTt6HUEKA4tXRTDU6WWiGYWLFuiLC459xnkx8dN+duW58TWdmcIGR6
         qa9JE1ZISADc4E1M8tnMx4NFkCO0NKwn2SRbsvYLQwDYY2lys23fyKanftDoDJQg/a+C
         t4OHX9RlBaCaI2p7XfZYwzIh8QaikJbMBjp3uqK45vmsnEns8eySf/50txojBEg0Obac
         EQmowBhZk9yrqHQswrIHZ69E9074Zc26iXgVFFy4dQXLwOEAQ3ygK/OtT8je4Zfz0jeU
         ldhQ==
X-Gm-Message-State: AOAM532qi/62Z8MKgeWoIyuMDks/qTLnQHPfPRN8SpcA0uXXihNmWhpD
        q++BiAxHdE891feXk6jqJ7Q=
X-Google-Smtp-Source: ABdhPJwjUd8makr3FYAa4X8DYRDQIh241S/+nW985N+7Njc524fy9OhIK6iyD4DPRvf71Zx058m96Q==
X-Received: by 2002:a05:6a00:230f:b0:4f4:13a9:9a53 with SMTP id h15-20020a056a00230f00b004f413a99a53mr3430329pfh.11.1646891238060;
        Wed, 09 Mar 2022 21:47:18 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c6c7:6f77:9634:183c])
        by smtp.gmail.com with ESMTPSA id 16-20020a056a00073000b004dfe2217090sm5270779pfm.200.2022.03.09.21.47.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 21:47:17 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v4 net-next 05/14] ipv6/gso: remove temporary HBH/jumbo header
Date:   Wed,  9 Mar 2022 21:46:54 -0800
Message-Id: <20220310054703.849899-6-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.1.616.g0bdcbb4464-goog
In-Reply-To: <20220310054703.849899-1-eric.dumazet@gmail.com>
References: <20220310054703.849899-1-eric.dumazet@gmail.com>
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
2.35.1.616.g0bdcbb4464-goog

