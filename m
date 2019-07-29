Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F7C7894D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 12:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbfG2KLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 06:11:21 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42627 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728181AbfG2KLU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 06:11:20 -0400
Received: by mail-pg1-f194.google.com with SMTP id t132so27996735pgb.9
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 03:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sVBNAf95q6jypq4wLZfcnOmVKvbyuP49IlqEtPfC/Yk=;
        b=U1AgvUpxWglfNOSxYHYrwcWQEgp+rhB2jHfUv5RaZpW928L1mZ6DmP1brrV6lJpuvn
         apUspCHaPwb4Kpi0dz8cos3AXoWg342fuM8ZxZJzKBVkwVMlEShkrE+EOc9YWR9RqpPL
         RtrqBoGS5d5sJGRoglIzEaLzyUluYztUdJ3f0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sVBNAf95q6jypq4wLZfcnOmVKvbyuP49IlqEtPfC/Yk=;
        b=Ov28y8CWYXRULJsHIy2iZZiiCZndgxXHUAd60j7KEefKJhioIs0uzEPUiW13vRLPIR
         Laom62MbmAz2j1bFrp4bHe9zzjKTmJDLTlwTV3W5QV134iKzHsJOT0BJi6aYXS44Jsh3
         kxJ65TWRBuhJaUr29FRXTf8daqbNn4CNeIbCwMwSsW560CgCQKQV0xwUEt1nbfDoAnp3
         flS/qSt9cgq4E+kCpKsrdr+6LiVkgbdXAuAuSkMXAMJIfNlGmfRjJ/FRqG/ZFeKIYdiO
         h8LXmk+iNc1kaFzQAMQc/MewQN6py5QVqLAAxTby5bUb9GmoMcaPMOVIOz0aITLLzjGL
         4Pcw==
X-Gm-Message-State: APjAAAVMpv6Dlmeqpf0p9mJsDiXWutWtSD2Ig4eQVrPP2uaJ4swVrD+w
        On0iK9W4zI5FBedZGXFYD9Av46tv7ao=
X-Google-Smtp-Source: APXvYqzIurYg1maUECZrcP+5s0I/cCGaTkkaLB8BtimgoCfIaKUbwsquYUsdJkZCXRzBJ6xSoVQfaQ==
X-Received: by 2002:a17:90a:25c8:: with SMTP id k66mr111766042pje.129.1564395079704;
        Mon, 29 Jul 2019 03:11:19 -0700 (PDT)
Received: from localhost.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e124sm99045812pfh.181.2019.07.29.03.11.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 03:11:19 -0700 (PDT)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 06/16] bnxt_en: Refactor tunneled hardware GRO logic.
Date:   Mon, 29 Jul 2019 06:10:23 -0400
Message-Id: <1564395033-19511-7-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
References: <1564395033-19511-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 2 GRO functions to set up the hardware GRO SKB fields for 2
different hardware chips have practically identical logic for
tunneled packets.  Refactor the logic into a separate bnxt_gro_tunnel()
function that can be used by both functions.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 69 +++++++++++++------------------
 1 file changed, 28 insertions(+), 41 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 810eea2..4856fd7 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1207,6 +1207,31 @@ static void bnxt_abort_tpa(struct bnxt_cp_ring_info *cpr, u16 idx, u32 agg_bufs)
 		bnxt_reuse_rx_agg_bufs(cpr, idx, 0, agg_bufs, true);
 }
 
+#ifdef CONFIG_INET
+static void bnxt_gro_tunnel(struct sk_buff *skb, __be16 ip_proto)
+{
+	struct udphdr *uh = NULL;
+
+	if (ip_proto == htons(ETH_P_IP)) {
+		struct iphdr *iph = (struct iphdr *)skb->data;
+
+		if (iph->protocol == IPPROTO_UDP)
+			uh = (struct udphdr *)(iph + 1);
+	} else {
+		struct ipv6hdr *iph = (struct ipv6hdr *)skb->data;
+
+		if (iph->nexthdr == IPPROTO_UDP)
+			uh = (struct udphdr *)(iph + 1);
+	}
+	if (uh) {
+		if (uh->check)
+			skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL_CSUM;
+		else
+			skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL;
+	}
+}
+#endif
+
 static struct sk_buff *bnxt_gro_func_5731x(struct bnxt_tpa_info *tpa_info,
 					   int payload_off, int tcp_ts,
 					   struct sk_buff *skb)
@@ -1264,28 +1289,10 @@ static struct sk_buff *bnxt_gro_func_5731x(struct bnxt_tpa_info *tpa_info,
 	}
 
 	if (inner_mac_off) { /* tunnel */
-		struct udphdr *uh = NULL;
 		__be16 proto = *((__be16 *)(skb->data + outer_ip_off -
 					    ETH_HLEN - 2));
 
-		if (proto == htons(ETH_P_IP)) {
-			struct iphdr *iph = (struct iphdr *)skb->data;
-
-			if (iph->protocol == IPPROTO_UDP)
-				uh = (struct udphdr *)(iph + 1);
-		} else {
-			struct ipv6hdr *iph = (struct ipv6hdr *)skb->data;
-
-			if (iph->nexthdr == IPPROTO_UDP)
-				uh = (struct udphdr *)(iph + 1);
-		}
-		if (uh) {
-			if (uh->check)
-				skb_shinfo(skb)->gso_type |=
-					SKB_GSO_UDP_TUNNEL_CSUM;
-			else
-				skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL;
-		}
+		bnxt_gro_tunnel(skb, proto);
 	}
 #endif
 	return skb;
@@ -1332,28 +1339,8 @@ static struct sk_buff *bnxt_gro_func_5730x(struct bnxt_tpa_info *tpa_info,
 		return NULL;
 	}
 
-	if (nw_off) { /* tunnel */
-		struct udphdr *uh = NULL;
-
-		if (skb->protocol == htons(ETH_P_IP)) {
-			struct iphdr *iph = (struct iphdr *)skb->data;
-
-			if (iph->protocol == IPPROTO_UDP)
-				uh = (struct udphdr *)(iph + 1);
-		} else {
-			struct ipv6hdr *iph = (struct ipv6hdr *)skb->data;
-
-			if (iph->nexthdr == IPPROTO_UDP)
-				uh = (struct udphdr *)(iph + 1);
-		}
-		if (uh) {
-			if (uh->check)
-				skb_shinfo(skb)->gso_type |=
-					SKB_GSO_UDP_TUNNEL_CSUM;
-			else
-				skb_shinfo(skb)->gso_type |= SKB_GSO_UDP_TUNNEL;
-		}
-	}
+	if (nw_off) /* tunnel */
+		bnxt_gro_tunnel(skb, skb->protocol);
 #endif
 	return skb;
 }
-- 
2.5.1

