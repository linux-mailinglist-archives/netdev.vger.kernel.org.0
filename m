Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5B4D526966
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 20:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383365AbiEMSek (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 14:34:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383342AbiEMSe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 14:34:28 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB6C5F8DD
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:25 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id g184so8264918pgc.1
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 11:34:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=J+gz86KAG8HATh4t70llK1mL8wNt91QibPVvj9k6Ux4=;
        b=PJdVnProiSK/KGZSjK8WP6XDuRuyVNywTpfRbYmqYNfwpqt/jkhNox2nJlUAVADjp5
         TmT5lwI7jc+C65FMn9nB1Dxznb9WfCJMF8Q3K16feDX5d7aakYY/ksBV3+qLOgEs7/BY
         yPMR+p6+M5c8VbJiipZE43fHcv/D9oXu8Bq0XG9Bq9kUKnnuUtGzfl5e9Fsm85aGIuJr
         fOiA8El4yeVx+1lZF8BtVV/qrs4ccQgar45JpsXARggBIAYQReMU6on7itUebdxNBMQY
         mTF2L+O+5qF45NdjHuYlphW44bQwiy6l8zagM2IKF2Ru4YyHEs+P1bd4D8LmZw18D/TB
         Ph2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J+gz86KAG8HATh4t70llK1mL8wNt91QibPVvj9k6Ux4=;
        b=CGMlj3P0nQkOTYQi3//ie8wl2WLYydAP7ASKud3r3LpKRqsD5D7ATr0ZaGKXXiD0PD
         /NYjyGDUZgMBtqjTO+3pwvi2DZu5vuMoz/nkH/n3UKWMgMnl8gl8PSdVbeicneVEr2TA
         G7C4N3HkgW54PKZ/m+pjxE/fmYEW2zuGqIP9JP3alkjMzVwYbJi1PogGqoGMBHuucU1a
         Xfc1w9oEjwRpekrFATBn2Ap4xlS0gyVchqh6XQQS30/oNlxZxF80QLbSV0DE44l0/Meu
         97+ZzMjXJcOnyaja5kTMVLRMXUQCJki+fmfZQxJh9h+/oontmv30TStcGsLqd36xy9vQ
         yr8A==
X-Gm-Message-State: AOAM531fUd7/INEnCwra4NWrqriF+UUGv6/yttMZZzQwr/Ds7gSHLzL0
        yY0uYAoQ+gLmvTZQQ/O3tas=
X-Google-Smtp-Source: ABdhPJxKDrt+aR6zt5HTudtQzsO/O7QpHvBzGNMfaP4QtlG4zNJbRSrz0YoNNgNdY40kRRz+eyd6XQ==
X-Received: by 2002:a63:2bc4:0:b0:3ab:1d76:64db with SMTP id r187-20020a632bc4000000b003ab1d7664dbmr4946068pgr.508.1652466865483;
        Fri, 13 May 2022 11:34:25 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:c436:3fa3:479f:a7a])
        by smtp.gmail.com with ESMTPSA id q13-20020aa7842d000000b0050dc76281cesm2053566pfn.168.2022.05.13.11.34.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 11:34:25 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v7 net-next 07/13] ipv6/gro: insert temporary HBH/jumbo header
Date:   Fri, 13 May 2022 11:34:02 -0700
Message-Id: <20220513183408.686447-8-eric.dumazet@gmail.com>
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

Following patch will add GRO_IPV6_MAX_SIZE, allowing gro to build
BIG TCP ipv6 packets (bigger than 64K).

This patch changes ipv6_gro_complete() to insert a HBH/jumbo header
so that resulting packet can go through IPv6/TCP stacks.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Alexander Duyck <alexanderduyck@fb.com>
---
 net/ipv6/ip6_offload.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ip6_offload.c b/net/ipv6/ip6_offload.c
index a6a6c1539c28d242ef8c35fcd5ce900512ce912d..d12dba2dd5354dbb79bb80df4038dec2544cddeb 100644
--- a/net/ipv6/ip6_offload.c
+++ b/net/ipv6/ip6_offload.c
@@ -342,15 +342,43 @@ static struct sk_buff *ip4ip6_gro_receive(struct list_head *head,
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
2.36.0.550.gb090851708-goog

