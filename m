Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D44AB5EA79C
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 15:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235161AbiIZNtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 09:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235165AbiIZNsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 09:48:54 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 595991836C
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 05:05:52 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id bk15so2110265wrb.13
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 05:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=jzQu1lXZiJCwK9qdNSV4u31TVGClyVdFTZIP8mWwowU=;
        b=GSSTdQiZF4QIzUTnpnqyaz5QJfId4XzM8oPARv45/EamMvCSIh38vx+ysREzoZL+Wl
         37Sr8RKyVEq6hVV0ZFxfikeuI0BeITGA16vPUgN92FdlYzjQfvEQh6Ltfp8lDD/qjaj7
         MtGSClvGB5i+S13Ysri1UyASsSSd+saNYuw/aiHyh/DWwP4hgb12Sblu0EbEvj4gr61D
         tw8wq/d5cqFOW0diftW2IM6hmGx3kO9qgrfudKC36jmL8aaCCZ7VHfW2POX3828Ssqrg
         UhhhDafVgNY3ZtOxcfuMcFovBBChNx5VS1H1PJlKOktURqRl3PGEmRfREfDuknLaXHTn
         XG4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=jzQu1lXZiJCwK9qdNSV4u31TVGClyVdFTZIP8mWwowU=;
        b=C7rAKqTJDdqFwiF/LIqfJHA+BiSl1oDKHZxqxEzKTRdPrlRvjFWtluq/23OSiVyPJE
         reSiWAIPQPjvuHBd8sLtUihsuuuFcYNpaTlWQN9VMbm/WTK730K2zzWTFwAjXhUWVO8w
         Jb4b2mSV8IvNWI1jacePBKn9kcMuszB9W5ohpEltztICdDcmrbsuNZG0b/cHVoeLO5Iv
         p1BOerMo3ofRt3rPCdI3XCKDNZBXxWmuaY4g6fS1JOhMDxhZDSeWLaDsnvmfLE3wG3qq
         /PrBL1NJYCRUcCYBo1C1HjpKndC068FBBA9Ram5KVtBUz+i0iwW/P/u8kHTzzqShNbHF
         dEHw==
X-Gm-Message-State: ACrzQf1jEo2XncA9KmLNeKwFpWaaT5YBPrTp1itRqM4VB+5zjy9icBWo
        wnp6itfmc+aaQzd++Ksf3IGya80Mwoc=
X-Google-Smtp-Source: AMsMyM7CbftS2WGO8hPY8X9Kppv4dzYKRxOrVI/gP39aWN/qs9UyB1+Y6zVK+ei20XL7UiLYUTrt9w==
X-Received: by 2002:a5d:4d87:0:b0:22c:a868:1fd6 with SMTP id b7-20020a5d4d87000000b0022ca8681fd6mr2103271wru.295.1664193837964;
        Mon, 26 Sep 2022 05:03:57 -0700 (PDT)
Received: from imac.redhat.com ([88.97.103.74])
        by smtp.gmail.com with ESMTPSA id l39-20020a05600c1d2700b003b50428cf66sm11950345wms.33.2022.09.26.05.03.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 05:03:57 -0700 (PDT)
From:   Donald Hunter <donald.hunter@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Donald Hunter <donald.hunter@redhat.com>
Subject: [PATCH net-next] Add skb drop reasons to IPv6 UDP receive path
Date:   Mon, 26 Sep 2022 13:03:50 +0100
Message-Id: <20220926120350.14928-1-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.35.1
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

From: Donald Hunter <donald.hunter@redhat.com>

Enumerate the skb drop reasons in the receive path for IPv6 UDP packets.

Signed-off-by: Donald Hunter <donald.hunter@redhat.com>
---
 net/ipv6/udp.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 3366d6a77ff2..91e795bb9ade 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -650,16 +650,20 @@ static int __udpv6_queue_rcv_skb(struct sock *sk, struct sk_buff *skb)
 	rc = __udp_enqueue_schedule_skb(sk, skb);
 	if (rc < 0) {
 		int is_udplite = IS_UDPLITE(sk);
+		enum skb_drop_reason drop_reason;
 
 		/* Note that an ENOMEM error is charged twice */
-		if (rc == -ENOMEM)
+		if (rc == -ENOMEM) {
 			UDP6_INC_STATS(sock_net(sk),
 					 UDP_MIB_RCVBUFERRORS, is_udplite);
-		else
+			drop_reason = SKB_DROP_REASON_SOCKET_RCVBUFF;
+		} else {
 			UDP6_INC_STATS(sock_net(sk),
 				       UDP_MIB_MEMERRORS, is_udplite);
+			drop_reason = SKB_DROP_REASON_PROTO_MEM;
+		}
 		UDP6_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, drop_reason);
 		return -1;
 	}
 
@@ -675,11 +679,14 @@ static __inline__ int udpv6_err(struct sk_buff *skb,
 
 static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 {
+	enum skb_drop_reason drop_reason = SKB_DROP_REASON_NOT_SPECIFIED;
 	struct udp_sock *up = udp_sk(sk);
 	int is_udplite = IS_UDPLITE(sk);
 
-	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
+	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb)) {
+		drop_reason = SKB_DROP_REASON_XFRM_POLICY;
 		goto drop;
+	}
 
 	if (static_branch_unlikely(&udpv6_encap_needed_key) && up->encap_type) {
 		int (*encap_rcv)(struct sock *sk, struct sk_buff *skb);
@@ -738,8 +745,10 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	    udp_lib_checksum_complete(skb))
 		goto csum_error;
 
-	if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr)))
+	if (sk_filter_trim_cap(sk, skb, sizeof(struct udphdr))) {
+		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
 		goto drop;
+	}
 
 	udp_csum_pull_header(skb);
 
@@ -748,11 +757,12 @@ static int udpv6_queue_rcv_one_skb(struct sock *sk, struct sk_buff *skb)
 	return __udpv6_queue_rcv_skb(sk, skb);
 
 csum_error:
+	drop_reason = SKB_DROP_REASON_UDP_CSUM;
 	__UDP6_INC_STATS(sock_net(sk), UDP_MIB_CSUMERRORS, is_udplite);
 drop:
 	__UDP6_INC_STATS(sock_net(sk), UDP_MIB_INERRORS, is_udplite);
 	atomic_inc(&sk->sk_drops);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, drop_reason);
 	return -1;
 }
 
-- 
2.36.1

