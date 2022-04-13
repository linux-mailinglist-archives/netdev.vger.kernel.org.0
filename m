Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF8454FF288
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 10:46:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234127AbiDMIrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 04:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234123AbiDMIq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 04:46:58 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52874AE2C;
        Wed, 13 Apr 2022 01:44:28 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id u2so1168614pgq.10;
        Wed, 13 Apr 2022 01:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q3CF2CYyk/KU/cKIRGIDMOGHVL/2+I9I23VjG1uUJC8=;
        b=CSMXfbjUMzMQUSHDlcY6940ReprM7qI7VMrvYmu6L+uFOM7DoT5aUGa8icSjL4eGYv
         wCdwhr7PYc5HtsEDZGHhJ2MePSWgmgg8qtGdp2rin2Zm8pN6Cl41cEQ+66wVpHFk/PPD
         QN9cQe+XT2w7+4QBaMZtRvt7czuI/YwA0obZfwfN72e2mk1l7F7BIsewf7nCo5ZCcdRq
         4wpofjJIDIaiGdEDMOpX/PsqZN7FpAlKtlOafykU0F28edsB4JzoovC1RkgfkYkq3PDl
         AknCMLvf3Fpnn4AoiuO+5g1hVkfspoTf7B4oZO2Hp1xxQVdl79Qfqn+xclZrezquJXjI
         fAPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q3CF2CYyk/KU/cKIRGIDMOGHVL/2+I9I23VjG1uUJC8=;
        b=bscO76cCV6d2iZXUkgG6ahrMCriC0593Vy60dBWdKwLex4QCPpCkbFRs1ofeDoJ75V
         i4vnaGoxdotrXVAmTvQx31QWP8e/RXLEs1uU1JKSXd58VYykY94CECao5jH9+YtdnFqS
         9VSvM2tW+ulNK24lwLAzX7DcR9/Nk+GuL2IqglXh8NNurS+XbJIW1vJ6AEYHryqpTJ5k
         IKzoSXpcmnz8bGqy7LqJqon+Du9fczsHv8gwhoChtS9lDR8O011jhBtohk7LiKG1vWCd
         PAXWShIDcevXWVOz0cU23A9Juc4cK/iCVI1iOz6ncsPoBd5pCRv1l/yBDueVBtuf91EF
         lGRA==
X-Gm-Message-State: AOAM530f9914tkoSY9KchLTDQifalUqZoISoS2e+tofLzgNhI8nzrIFp
        qauFFm82r56Nia2JNa0LTuY=
X-Google-Smtp-Source: ABdhPJwHcdm+jreTHfL7OfNFwhm+bX5jRBwz/tWPt6br+WjRQnxT3R65fOAW2S0C/jOsToIKS7ehGg==
X-Received: by 2002:a05:6a00:2354:b0:505:c6c3:af87 with SMTP id j20-20020a056a00235400b00505c6c3af87mr14012849pfj.78.1649839468233;
        Wed, 13 Apr 2022 01:44:28 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.119])
        by smtp.gmail.com with ESMTPSA id l5-20020a63f305000000b0039daaa10a1fsm2410335pgh.65.2022.04.13.01.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 01:44:27 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     dsahern@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        benbjiang@tencent.com, flyingpeng@tencent.com,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org,
        mengensun@tencent.com, dongli.zhang@oracle.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 9/9] net: ipv6: add skb drop reasons to ip6_protocol_deliver_rcu()
Date:   Wed, 13 Apr 2022 16:16:00 +0800
Message-Id: <20220413081600.187339-10-imagedong@tencent.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220413081600.187339-1-imagedong@tencent.com>
References: <20220413081600.187339-1-imagedong@tencent.com>
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

From: Menglong Dong <imagedong@tencent.com>

Replace kfree_skb() used in ip6_protocol_deliver_rcu() with
kfree_skb_reason().

No new reasons are added.

Some paths are ignored, as they are not common, such as encapsulation
on non-final protocol.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
Reviewed-by: Jiang Biao <benbjiang@tencent.com>
Reviewed-by: Hao Peng <flyingpeng@tencent.com>
---
 net/ipv6/ip6_input.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 1b925ecb26e9..126ae3aa67e1 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -362,6 +362,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 	const struct inet6_protocol *ipprot;
 	struct inet6_dev *idev;
 	unsigned int nhoff;
+	SKB_DR(reason);
 	bool raw;
 
 	/*
@@ -421,12 +422,16 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			if (ipv6_addr_is_multicast(&hdr->daddr) &&
 			    !ipv6_chk_mcast_addr(dev, &hdr->daddr,
 						 &hdr->saddr) &&
-			    !ipv6_is_mld(skb, nexthdr, skb_network_header_len(skb)))
+			    !ipv6_is_mld(skb, nexthdr, skb_network_header_len(skb))) {
+				SKB_DR_SET(reason, IP_INADDRERRORS);
 				goto discard;
+			}
 		}
 		if (!(ipprot->flags & INET6_PROTO_NOPOLICY) &&
-		    !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))
+		    !xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb)) {
+			SKB_DR_SET(reason, XFRM_POLICY);
 			goto discard;
+		}
 
 		ret = INDIRECT_CALL_2(ipprot->handler, tcp_v6_rcv, udpv6_rcv,
 				      skb);
@@ -452,8 +457,11 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 						IPSTATS_MIB_INUNKNOWNPROTOS);
 				icmpv6_send(skb, ICMPV6_PARAMPROB,
 					    ICMPV6_UNK_NEXTHDR, nhoff);
+				SKB_DR_SET(reason, IP_NOPROTO);
+			} else {
+				SKB_DR_SET(reason, XFRM_POLICY);
 			}
-			kfree_skb(skb);
+			kfree_skb_reason(skb, reason);
 		} else {
 			__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDELIVERS);
 			consume_skb(skb);
@@ -463,7 +471,7 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 
 discard:
 	__IP6_INC_STATS(net, idev, IPSTATS_MIB_INDISCARDS);
-	kfree_skb(skb);
+	kfree_skb_reason(skb, reason);
 }
 
 static int ip6_input_finish(struct net *net, struct sock *sk, struct sk_buff *skb)
-- 
2.35.1

