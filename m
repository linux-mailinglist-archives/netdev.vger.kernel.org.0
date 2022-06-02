Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1D853BA66
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235420AbiFBOBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:01:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbiFBOBY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:01:24 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2ACF29DC37
        for <netdev@vger.kernel.org>; Thu,  2 Jun 2022 07:01:23 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e66so4820878pgc.8
        for <netdev@vger.kernel.org>; Thu, 02 Jun 2022 07:01:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vp5waJ5s4F5VHc+rhaAMNO0Y7f4Er9EIwxw8IO5Dbok=;
        b=gXknmAfjcjbF4ZJb9Z1RBDz0QXphgKP/hiOwuqtL/mRxzmyFezhIj2XptO3ihwNBC3
         JY7mF9KRKZqCMVGHogpA/dBjDhg6fwYaXUXb5YxJMeDGdgAvbaAn7JGGRfg2dvC5GX+p
         EQF6TEHz/X1G/pg0H9zua0C3wcSA8n9LSJRL/0rx7T4MrkTdA3bnYQZ25g1mswdrXOpK
         fkWjN9bZJ0i/FSGhhHrUXX1SYU6KNocbOvpCfwgXa2zrapXAmXCGYiQv3PiRuANTIUxH
         cLnKvau72v4qE3sye1tsCx4Yr3BRDRYmKWvPgVMcQ5mowcNpIjrQUxLNeWA5xFMBYtZl
         UuoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vp5waJ5s4F5VHc+rhaAMNO0Y7f4Er9EIwxw8IO5Dbok=;
        b=xKA7TReLk6TYr19M4SilwSwkY+XUVxfx2lxgRPfSmYdRL5uXxjIDBEuR2zaMQ0y9dO
         z6UgVjN0nTdepqodiB0dqIAS8KagJNT/kHGu15MkQOw3Yct1mQjRpyssp0ybDmeGa2Yl
         aULkgfWC/SWgkPkg4jdU49q+QN3BFoPdbL3z46qYYUH04NEK2MdLuc53PJIPyiHlEbzG
         KFrr+7usGt6c2hBnCBeihUxO/MX/BOtVbbDWL1WQKMe0/Wdg11oko0tb+fimoxuHFEPx
         BLQ4DPnrePPR6fOvgTIIZoSmb36d6swD0XJ2oPgHEZFVjosyNDL5EKOnqwN4+0qQSjcy
         04wg==
X-Gm-Message-State: AOAM5326jgZDhluC8TniVTddJGjKeFfIZBrtIBe6VW2Yw6oIO2fbqgJc
        Wdf69XdRjTRKZtG2AbDq34c=
X-Google-Smtp-Source: ABdhPJzTQu6n+cvsjbZYilpIJXjI1LvSIjB1PbkLiTk7O1pLgz3tSpE4cZLH6pzDgL9L5PV3qlJORA==
X-Received: by 2002:a63:f113:0:b0:3fc:a9a6:91f with SMTP id f19-20020a63f113000000b003fca9a6091fmr4347744pgi.598.1654178483055;
        Thu, 02 Jun 2022 07:01:23 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id k13-20020aa7998d000000b0050dc76281ecsm108463pfh.198.2022.06.02.07.01.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 07:01:22 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 1/3] amt: fix wrong usage of pskb_may_pull()
Date:   Thu,  2 Jun 2022 14:01:06 +0000
Message-Id: <20220602140108.18329-2-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220602140108.18329-1-ap420073@gmail.com>
References: <20220602140108.18329-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It adds missing pskb_may_pull() in amt_update_handler() and
amt_multicast_data_handler().
And it fixes wrong parameter of pskb_may_pull() in
amt_advertisement_handler() and amt_membership_query_handler().

Reported-by: Jakub Kicinski <kuba@kernel.org>
Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 55 +++++++++++++++++++++++++++++++----------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index ebee5f07a208..900948e135ad 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -2220,8 +2220,7 @@ static bool amt_advertisement_handler(struct amt_dev *amt, struct sk_buff *skb)
 	struct amt_header_advertisement *amta;
 	int hdr_size;
 
-	hdr_size = sizeof(*amta) - sizeof(struct amt_header);
-
+	hdr_size = sizeof(*amta) + sizeof(struct udphdr);
 	if (!pskb_may_pull(skb, hdr_size))
 		return true;
 
@@ -2251,19 +2250,27 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	struct ethhdr *eth;
 	struct iphdr *iph;
 
+	hdr_size = sizeof(*amtmd) + sizeof(struct udphdr);
+	if (!pskb_may_pull(skb, hdr_size))
+		return true;
+
 	amtmd = (struct amt_header_mcast_data *)(udp_hdr(skb) + 1);
 	if (amtmd->reserved || amtmd->version)
 		return true;
 
-	hdr_size = sizeof(*amtmd) + sizeof(struct udphdr);
 	if (iptunnel_pull_header(skb, hdr_size, htons(ETH_P_IP), false))
 		return true;
+
 	skb_reset_network_header(skb);
 	skb_push(skb, sizeof(*eth));
 	skb_reset_mac_header(skb);
 	skb_pull(skb, sizeof(*eth));
 	eth = eth_hdr(skb);
+
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return true;
 	iph = ip_hdr(skb);
+
 	if (iph->version == 4) {
 		if (!ipv4_is_multicast(iph->daddr))
 			return true;
@@ -2274,6 +2281,9 @@ static bool amt_multicast_data_handler(struct amt_dev *amt, struct sk_buff *skb)
 	} else if (iph->version == 6) {
 		struct ipv6hdr *ip6h;
 
+		if (!pskb_may_pull(skb, sizeof(*ip6h)))
+			return true;
+
 		ip6h = ipv6_hdr(skb);
 		if (!ipv6_addr_is_multicast(&ip6h->daddr))
 			return true;
@@ -2306,8 +2316,7 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	struct iphdr *iph;
 	int hdr_size, len;
 
-	hdr_size = sizeof(*amtmq) - sizeof(struct amt_header);
-
+	hdr_size = sizeof(*amtmq) + sizeof(struct udphdr);
 	if (!pskb_may_pull(skb, hdr_size))
 		return true;
 
@@ -2315,22 +2324,27 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	if (amtmq->reserved || amtmq->version)
 		return true;
 
-	hdr_size = sizeof(*amtmq) + sizeof(struct udphdr) - sizeof(*eth);
+	hdr_size -= sizeof(*eth);
 	if (iptunnel_pull_header(skb, hdr_size, htons(ETH_P_TEB), false))
 		return true;
+
 	oeth = eth_hdr(skb);
 	skb_reset_mac_header(skb);
 	skb_pull(skb, sizeof(*eth));
 	skb_reset_network_header(skb);
 	eth = eth_hdr(skb);
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return true;
+
 	iph = ip_hdr(skb);
 	if (iph->version == 4) {
-		if (!ipv4_is_multicast(iph->daddr))
-			return true;
 		if (!pskb_may_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS +
 				   sizeof(*ihv3)))
 			return true;
 
+		if (!ipv4_is_multicast(iph->daddr))
+			return true;
+
 		ihv3 = skb_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
@@ -2345,15 +2359,17 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		ip_eth_mc_map(iph->daddr, eth->h_dest);
 #if IS_ENABLED(CONFIG_IPV6)
 	} else if (iph->version == 6) {
-		struct ipv6hdr *ip6h = ipv6_hdr(skb);
 		struct mld2_query *mld2q;
+		struct ipv6hdr *ip6h;
 
-		if (!ipv6_addr_is_multicast(&ip6h->daddr))
-			return true;
 		if (!pskb_may_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS +
 				   sizeof(*mld2q)))
 			return true;
 
+		ip6h = ipv6_hdr(skb);
+		if (!ipv6_addr_is_multicast(&ip6h->daddr))
+			return true;
+
 		mld2q = skb_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
@@ -2389,23 +2405,23 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 {
 	struct amt_header_membership_update *amtmu;
 	struct amt_tunnel_list *tunnel;
-	struct udphdr *udph;
 	struct ethhdr *eth;
 	struct iphdr *iph;
-	int len;
+	int len, hdr_size;
 
 	iph = ip_hdr(skb);
-	udph = udp_hdr(skb);
 
-	if (__iptunnel_pull_header(skb, sizeof(*udph), skb->protocol,
-				   false, false))
+	hdr_size = sizeof(*amtmu) + sizeof(struct udphdr);
+	if (!pskb_may_pull(skb, hdr_size))
 		return true;
 
-	amtmu = (struct amt_header_membership_update *)skb->data;
+	amtmu = (struct amt_header_membership_update *)(udp_hdr(skb) + 1);
 	if (amtmu->reserved || amtmu->version)
 		return true;
 
-	skb_pull(skb, sizeof(*amtmu));
+	if (iptunnel_pull_header(skb, hdr_size, skb->protocol, false))
+		return true;
+
 	skb_reset_network_header(skb);
 
 	list_for_each_entry_rcu(tunnel, &amt->tunnel_list, list) {
@@ -2426,6 +2442,9 @@ static bool amt_update_handler(struct amt_dev *amt, struct sk_buff *skb)
 	return true;
 
 report:
+	if (!pskb_may_pull(skb, sizeof(*iph)))
+		return true;
+
 	iph = ip_hdr(skb);
 	if (iph->version == 4) {
 		if (ip_mc_check_igmp(skb)) {
-- 
2.17.1

