Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F068394E8
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732314AbfFGS4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:56:00 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:32970 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731177AbfFGSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:55:58 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so1707210pfq.0
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 11:55:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=herbertland-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=F35bB8qVqL1kghXhAXBYlshqx70lIJ8NcnxFixYXJAU=;
        b=Ft/i+yf7D1FV7srBVD2twGrAiihIseiixCo56nMmWEblW1UTMMzuXFbgPlLatUboz5
         Zk7J+x6cXF0c7dovTTKOrLPrjbt0cfjHLPK67nLGFAxbO4kF399/poAPYnlsxjgR2nfk
         N7EPdOFXghDhdIJlGovUAHyZCUhIZ5x8nWypF8UfChuypoUDr/Zk6n7McqUHlBMCFXYt
         iRncdurmEs6W9pxzff5TkdTqOr8V6OnI71xgGmvxuM7cvHefYas41v/xGZZHYDxN/DGM
         Ks/i0LpCtSVEK2cGLNFEu3qou62GPZL7GDXw8BxABbtMujbuJoEbLXoY8DJvK1QvxzaP
         5/ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=F35bB8qVqL1kghXhAXBYlshqx70lIJ8NcnxFixYXJAU=;
        b=W+uN/dkWpBBiM98S3DyZiR9ewgeoI4PUEwVTel90k9TUylbrutrJEz+GFGhr92qyA2
         J76y8UvrurAASur0nG3J9hbu4jnXyEC692Vjpw9zqvkdTVP5Xv1G2g1dNvbbc2N8Lm+B
         UxQ/wu26UUchrMUkeGLwoiyLIv++hBBhwgKsD1b2dCqmTpX05frBTx5o/7NskLXhKmrO
         0uo1zIJGFWV1F8xPohbkrJdICc405OA02UXTZRlhgzAnbcb/iorcQQ/LjLjsItQuBca0
         klHtvCWbLS/yJy8FfYOp9vfEvTls+Wu6W9VdY+6/MBg1zB+f3uTrfD6X8A4HBxj4ID0a
         +T1A==
X-Gm-Message-State: APjAAAVplSmvBMHFxTlyPAyxwxIP13p3JuErqaOlp9V7LJ3HfGtwgVcQ
        Lt5bFFkaKBcxkEeFF5SjF8V2lA==
X-Google-Smtp-Source: APXvYqz5VXTkZ2jwl7gq+3TXtmmHUkYMDcEb/LTJi8uEugKY5fZV2RRwjIcFyOIqIbaV3394aS0ung==
X-Received: by 2002:a63:a84c:: with SMTP id i12mr4473339pgp.115.1559933758058;
        Fri, 07 Jun 2019 11:55:58 -0700 (PDT)
Received: from localhost.localdomain (c-73-223-249-119.hsd1.ca.comcast.net. [73.223.249.119])
        by smtp.gmail.com with ESMTPSA id i25sm3181933pfr.73.2019.06.07.11.55.56
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Fri, 07 Jun 2019 11:55:57 -0700 (PDT)
From:   Tom Herbert <tom@herbertland.com>
X-Google-Original-From: Tom Herbert <tom@quantonium.net>
To:     davem@davemloft.net, netdev@vger.kernel.org, dlebrun@google.com
Cc:     Tom Herbert <tom@quantonium.net>
Subject: [RFC v2 PATCH 3/5] ipv6: Paramterize TLV parsing
Date:   Fri,  7 Jun 2019 11:55:06 -0700
Message-Id: <1559933708-13947-4-git-send-email-tom@quantonium.net>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1559933708-13947-1-git-send-email-tom@quantonium.net>
References: <1559933708-13947-1-git-send-email-tom@quantonium.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add parameters to ip6_parse_tlv that will allow leveraging the function
for parsing segment routing TLVs. The new parameters are offset of
TLVs, length of the TLV block, and a function that is called in the case
of an unrecognized option.

Signed-off-by: Tom Herbert <tom@quantonium.net>
---
 net/ipv6/exthdrs.c | 35 ++++++++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 20291c2..a394d20 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -112,15 +112,26 @@ static bool ip6_tlvopt_unknown(struct sk_buff *skb, int optoff,
 	return false;
 }
 
-/* Parse tlv encoded option header (hop-by-hop or destination) */
+/* Parse tlv encoded option header (hop-by-hop or destination)
+ *
+ * Arguments:
+ *   procs - TLV proc structure
+ *   skb - skbuff containing TLVs
+ *   max_count - absolute value is maximum nuber of TLVs. If less than zero
+ *		 then unknown TLVs are disallowed regardless of disposition
+ *		 indicated by TLV type
+ *   off - offset of first TLV relative to the first byte of the extension
+ *	   header which is transport header of the skb
+ *   len - length of TLV block
+ *   unknown_opt - function called when unknown option is encountered
+ */
 
 static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
-			  struct sk_buff *skb,
-			  int max_count)
+			  struct sk_buff *skb, int max_count, int off, int len,
+			  bool (*unknown_opt)(struct sk_buff *skb, int optoff,
+					      bool disallow_unknowns))
 {
-	int len = (skb_transport_header(skb)[1] + 1) << 3;
 	const unsigned char *nh = skb_network_header(skb);
-	int off = skb_network_header_len(skb);
 	const struct tlvtype_proc *curr;
 	bool disallow_unknowns = false;
 	int tlv_count = 0;
@@ -131,11 +142,11 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 		max_count = -max_count;
 	}
 
-	if (skb_transport_offset(skb) + len > skb_headlen(skb))
+	if (skb_transport_offset(skb) + off + len > skb_headlen(skb))
 		goto bad;
 
-	off += 2;
-	len -= 2;
+	/* Offset relative to network header for parse loop */
+	off += skb_network_header_len(skb);
 
 	while (len > 0) {
 		int optlen = nh[off + 1] + 2;
@@ -187,7 +198,7 @@ static bool ip6_parse_tlv(const struct tlvtype_proc *procs,
 				}
 			}
 			if (curr->type < 0 &&
-			    !ip6_tlvopt_unknown(skb, off, disallow_unknowns))
+			    !unknown_opt(skb, off, disallow_unknowns))
 				return false;
 
 			padlen = 0;
@@ -309,7 +320,8 @@ static int ipv6_destopt_rcv(struct sk_buff *skb)
 #endif
 
 	if (ip6_parse_tlv(tlvprocdestopt_lst, skb,
-			  init_net.ipv6.sysctl.max_dst_opts_cnt)) {
+			  init_net.ipv6.sysctl.max_dst_opts_cnt,
+			  2, extlen - 2, ip6_tlvopt_unknown)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 #if IS_ENABLED(CONFIG_IPV6_MIP6)
@@ -848,7 +860,8 @@ int ipv6_parse_hopopts(struct sk_buff *skb)
 
 	opt->flags |= IP6SKB_HOPBYHOP;
 	if (ip6_parse_tlv(tlvprochopopt_lst, skb,
-			  init_net.ipv6.sysctl.max_hbh_opts_cnt)) {
+			  init_net.ipv6.sysctl.max_hbh_opts_cnt,
+			  2, extlen - 2, ip6_tlvopt_unknown)) {
 		skb->transport_header += extlen;
 		opt = IP6CB(skb);
 		opt->nhoff = sizeof(struct ipv6hdr);
-- 
2.7.4

