Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 341054A7D8E
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 02:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348897AbiBCBwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 20:52:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348855AbiBCBwD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 20:52:03 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203D4C06173B
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 17:52:02 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id v15-20020a17090a4ecf00b001b82db48754so1401845pjl.2
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 17:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M0CvqSum6+XdHivNp9h5db+obqXQFYnrbVFzkgyj3D8=;
        b=c+c35QzNIjvNmL/d9TQFDJYXEs7zf8v2yMbzjenSJlN/PLOOWZN4clo7WY6bokRSpw
         NE70Qm8oNiNH6j+UfAZDEdFUeF/mzEH+e11ElGwZmDWZPI7OBpm0wTBoh55fKvrxrobi
         a5IGYW5WXbUA5rmjAn1TysVsnL/1ljvv+Oc1zH0TI+xoqu/DyNNuEoOJO7bScKL3va7F
         1jOJt3qXbgXTqubEtjXBg/DclTCLOZjtL3gZEJfRhQxe3FZ424ujIAut4ilkj2v/B+rZ
         +7GMm7PFKYI8aN65oQ06PASzRUFFSV1mqB7wGTrvsgBlwB0hfCi2gRTO1SQioog4Kwl3
         z2mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M0CvqSum6+XdHivNp9h5db+obqXQFYnrbVFzkgyj3D8=;
        b=NW7EpJII1zPmVjIKY9kOK2GRsDT/qgYu1VFwLW8BuvLX9/TD9eJ0gE5876RZUNlNjW
         WDldFVMNR2oSIPTutOthMQuwyfku/C3usiIrBe1GlMJN2kzl814QuReCtO3BGu2e7rRC
         8red/67z4nb691rrbz6U4R5N+dMU/3drTNPHXZvolpRtUs+AHaQea1p59fbhzA7o8SU+
         IJgKmJwoflXU7z3xZxrZPXgnFscHsiX7yt1synpglLF53SNjoN0e092ohC+x4vFRka83
         53J/CeS/SDQ2hRZg59aG+qikfW8k+h7vpvgBSsFd8UKmrtoc+Fej8WBJGjzooMCsq8ag
         wPsA==
X-Gm-Message-State: AOAM533XpFoD7XPyqoFIUgltCd515RtDCQ3cfTnx4O69GnC6GnPP9ihE
        URRBfLOVUT8KpM9MjEWM7sgkDLtdSAU=
X-Google-Smtp-Source: ABdhPJyLycfsZbMjxP54WK7ust51bS4ik8CLBRVrvarvL+72z9wOLBJ4GDqMciWQMubC7wvSrcZkjQ==
X-Received: by 2002:a17:90b:4c04:: with SMTP id na4mr11094059pjb.62.1643853122532;
        Wed, 02 Feb 2022 17:52:02 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:697a:fa00:b793:ed3a])
        by smtp.gmail.com with ESMTPSA id qe16sm509611pjb.22.2022.02.02.17.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Feb 2022 17:52:02 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net-next 06/15] ipv6/gro: insert temporary HBH/jumbo header
Date:   Wed,  2 Feb 2022 17:51:31 -0800
Message-Id: <20220203015140.3022854-7-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.35.0.rc2.247.g8bbb082509-goog
In-Reply-To: <20220203015140.3022854-1-eric.dumazet@gmail.com>
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

Following patch will add GRO_IPV6_MAX_SIZE, allowing gro to build
BIG TCP ipv6 packets (bigger than 64K).

This patch changes ipv6_gro_complete() to insert a HBH/jumbo header
so that resulting packet can go through IPv6/TCP stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv6/ip6_offload.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index d37a79a8554e92a1dcaa6fd023cafe2114841ece..dac6f60436e167a3d979fef02f25fc039c6ed37d 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -318,15 +318,43 @@ static struct sk_buff *ip4ip6_gro_receive(struct list_head *head,
 INDIRECT_CALLABLE_SCOPE int ipv6_gro_complete(struct sk_buff *skb, int nhoff)
 {
 	const struct net_offload *ops;
-	struct ipv6hdr *iph = (struct ipv6hdr *)(skb->data + nhoff);
+	struct ipv6hdr *iph;
 	int err = -ENOSYS;
+	u32 payload_len;
 
 	if (skb->encapsulation) {
 		skb_set_inner_protocol(skb, cpu_to_be16(ETH_P_IPV6));
 		skb_set_inner_network_header(skb, nhoff);
 	}
 
-	iph->payload_len = htons(skb->len - nhoff - sizeof(*iph));
+	payload_len = skb->len - nhoff - sizeof(*iph);
+	if (unlikely(payload_len > IPV6_MAXPLEN)) {
+		struct hop_jumbo_hdr *hop_jumbo;
+		int hoplen = sizeof(*hop_jumbo);
+
+		/* Move network header left */
+		memmove(skb_mac_header(skb) - hoplen, skb_mac_header(skb),
+			skb->transport_header - skb->mac_header);
+		skb->data -= hoplen;
+		skb->len += hoplen;
+		skb->mac_header -= hoplen;
+		skb->network_header -= hoplen;
+		iph = (struct ipv6hdr *)(skb->data + nhoff);
+		hop_jumbo = (struct hop_jumbo_hdr *)(iph + 1);
+
+		/* Build hop-by-hop options */
+		hop_jumbo->nexthdr = iph->nexthdr;
+		hop_jumbo->hdrlen = 0;
+		hop_jumbo->tlv_type = IPV6_TLV_JUMBO;
+		hop_jumbo->tlv_len = 4;
+		hop_jumbo->jumbo_payload_len = htonl(payload_len + hoplen);
+
+		iph->nexthdr = NEXTHDR_HOP;
+		iph->payload_len = 0;
+	} else {
+		iph = (struct ipv6hdr *)(skb->data + nhoff);
+		iph->payload_len = htons(payload_len);
+	}
 
 	nhoff += sizeof(*iph) + ipv6_exthdrs_len(iph, &ops);
 	if (WARN_ON(!ops || !ops->callbacks.gro_complete))
-- 
2.35.0.rc2.247.g8bbb082509-goog

