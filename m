Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF156AA621
	for <lists+netdev@lfdr.de>; Sat,  4 Mar 2023 01:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjCDAMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 19:12:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjCDAMt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 19:12:49 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D0D20D3D;
        Fri,  3 Mar 2023 16:12:48 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id s12so4807796qtq.11;
        Fri, 03 Mar 2023 16:12:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677888767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bk6+YBR983JyQwllGJ82zvIQOjlCZFKU6yx52rHjP08=;
        b=KBCtTQZ4+S/BA2pezxtPA/TQyl4+x+VaX7FfYWCEqC0U303cN/OAz6kqFxFMWVB1gQ
         s70d/f9K09hLL+suxIcmlQK0LJ0cDMn3hghizkMZfe5zPJN5UoBvYjzbKUrB3xsEKHdA
         aKSj22d6RYnmCl64TpjOzvKlZAg3kIqf0a6FnQ7J4pwKGAH3b9INA7sM7lMTt4TEu5dV
         G44YCTjsJIj5lGsUgWWSQ8DlsUNs5ejy2fc/HO+D4Ovj/+Z1u4/Vi1TW9wm0J0XjkerJ
         fmgGRO8hAsE/Vu0lBkEqLX40eQdTz6l7SXvicV3hdozzgib4oliwDaN4ZU3BakdVwMgo
         cQFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677888767;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bk6+YBR983JyQwllGJ82zvIQOjlCZFKU6yx52rHjP08=;
        b=0bXEkcMR2z4DHH02s0Nz99hrskzX9mM9BdKQA284KSF4FiZSPwiGNh8P3PJmUq+1C3
         4beXhDVZ4Gi0EnaTWg7A2OsSP2cxrYxzAIUxjTAbcSixHBOW/VOhQLI/BlT00ktjJV0E
         a4pK3B3WqCy/UtLcOhduaZ6PBeLxPB6z3vE3ZLYIp19y3/ufV8lIPHKdGoScDN1LrwFP
         6D9K9F/xD5yZJXd/4PJ2kKnHyX63Ls+kN+YL/LAbW8mt9p18t/t/d+0hoF4snVJxHT49
         goy37HJ3dW3TsIRqmPjOp1intG5k2meVEwRiaVRIEuhg3YYyYkpDeTC8W0z2d8SjkHV2
         h2lQ==
X-Gm-Message-State: AO0yUKV92taH9tyG6ykNlXCGaUHVQtB01cxO1r+uvLJMnUimuMnXaPr4
        oH+xVbaT+Iw4m8nX6eJG3z4liipokkF+7w==
X-Google-Smtp-Source: AK7set/W2jfHT+nvHW4TDjrGMEhF1onLtCsnhbX1oNJPIbSpxso/q/iDdUf2rv94w7z0vV2Uvboldg==
X-Received: by 2002:a05:622a:54c:b0:3bf:d9d2:484f with SMTP id m12-20020a05622a054c00b003bfd9d2484fmr6548391qtx.11.1677888767428;
        Fri, 03 Mar 2023 16:12:47 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id d79-20020ae9ef52000000b007296805f607sm2749242qkg.17.2023.03.03.16.12.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 16:12:47 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: [PATCH nf-next 3/6] netfilter: bridge: move pskb_trim_rcsum out of br_nf_check_hbh_len
Date:   Fri,  3 Mar 2023 19:12:39 -0500
Message-Id: <688b6037c640efeb6141d4646cc9dc1b657796e7.1677888566.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677888566.git.lucien.xin@gmail.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

br_nf_check_hbh_len() is a function to check the Hop-by-hop option
header, and shouldn't do pskb_trim_rcsum() there. This patch is to
pass pkt_len out to br_validate_ipv6() and do pskb_trim_rcsum()
after calling br_validate_ipv6() instead.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/bridge/br_netfilter_ipv6.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
index 50f564c33551..07289e4f3213 100644
--- a/net/bridge/br_netfilter_ipv6.c
+++ b/net/bridge/br_netfilter_ipv6.c
@@ -43,11 +43,11 @@
 /* We only check the length. A bridge shouldn't do any hop-by-hop stuff
  * anyway
  */
-static int br_nf_check_hbh_len(struct sk_buff *skb)
+static int br_nf_check_hbh_len(struct sk_buff *skb, u32 *plen)
 {
 	int len, off = sizeof(struct ipv6hdr);
 	unsigned char *nh;
-	u32 pkt_len;
+	u32 pkt_len = 0;
 
 	if (!pskb_may_pull(skb, off + 8))
 		return -1;
@@ -83,10 +83,6 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
 				return -1;
 			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
 				return -1;
-			if (pskb_trim_rcsum(skb,
-					    pkt_len + sizeof(struct ipv6hdr)))
-				return -1;
-			nh = skb_network_header(skb);
 		}
 		off += optlen;
 		len -= optlen;
@@ -94,6 +90,8 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
 	if (len)
 		return -1;
 
+	if (pkt_len)
+		*plen = pkt_len;
 	return 0;
 }
 
@@ -116,22 +114,19 @@ int br_validate_ipv6(struct net *net, struct sk_buff *skb)
 		goto inhdr_error;
 
 	pkt_len = ntohs(hdr->payload_len);
+	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb, &pkt_len))
+		goto drop;
 
-	if (pkt_len || hdr->nexthdr != NEXTHDR_HOP) {
-		if (pkt_len + ip6h_len > skb->len) {
-			__IP6_INC_STATS(net, idev,
-					IPSTATS_MIB_INTRUNCATEDPKTS);
-			goto drop;
-		}
-		if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
-			__IP6_INC_STATS(net, idev,
-					IPSTATS_MIB_INDISCARDS);
-			goto drop;
-		}
-		hdr = ipv6_hdr(skb);
+	if (pkt_len + ip6h_len > skb->len) {
+		__IP6_INC_STATS(net, idev,
+				IPSTATS_MIB_INTRUNCATEDPKTS);
+		goto drop;
 	}
-	if (hdr->nexthdr == NEXTHDR_HOP && br_nf_check_hbh_len(skb))
+	if (pskb_trim_rcsum(skb, pkt_len + ip6h_len)) {
+		__IP6_INC_STATS(net, idev,
+				IPSTATS_MIB_INDISCARDS);
 		goto drop;
+	}
 
 	memset(IP6CB(skb), 0, sizeof(struct inet6_skb_parm));
 	/* No IP options in IPv6 header; however it should be
-- 
2.39.1

