Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8577F6925BA
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:47:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233253AbjBJSrl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:47:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbjBJSrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:47:33 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A52FC7D895
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:47:17 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id f187-20020a251fc4000000b0087f69905709so5760949ybf.10
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:47:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j6OC1pAg+2FYT6fdOJayBgZ5XN9AuPjAWR6eOh1MDjQ=;
        b=Tl1UNMcdTn48W62SovmAnXS9b/Tzz10fjsn5bdRFXJHunSYedGWIp1ek9w7U7qgTpY
         OxEwnx0JnYqQCePuVm7mO+CMksTQzXRv/n0kpVZl9MgLrA0yEr5uJEsHZY5jsePQYDpf
         Sf1kTMNEwbQDRf8IoBLXtAkjjxffPyPAg9pRreyVSushyqviS5KSj5L2tNOKUVYimRty
         oR5h9yY9ccqYmxWO1SnKl4IMvr7zo2t2kYEhF+Z4JMhMwMN2uV3j8X3bVZhZjKz/wbVd
         l6FMyrdiKJ4RI0wFi9D1EZ+rynYvSvd8bQVD4Zqtl2YHBMBkx8k3sAOB60Z0G2j7uh1B
         3SAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j6OC1pAg+2FYT6fdOJayBgZ5XN9AuPjAWR6eOh1MDjQ=;
        b=b04KLZErSsgun3YXCXU7EGv9gohAS+HjTC2X6kt7Q8u9OBKcf2n63mpbg8O+Yz5Yo9
         r2UW6d35a4lcWyrmTsTbsfnGXujEv157RK2Y33qVWK4A+hYx8cV066oPuz1T7DuGy/0H
         GeP7ToxXimAiNOgMWM/jcbe7z8bD9wEn/Bt6aJgT8r1J47bXcnWwPCz5UXv7fmYsnu9d
         C6C5L4deyXYkSBT1uEfiqFtXpVDgcPO4IbHQLG3g7VresS22jUqavW5BsSfvQJWe4l9H
         LVLA3JT7Q3ji0EEF7d5H95sN+3LkprV8aVxnM5qxLB0q3CPbWASeWWpknbx96a4EH1CX
         DUUw==
X-Gm-Message-State: AO0yUKXDcl0YwfHSN6AOrWqs9eay6Jy3j5Hw85FEbGWv3MbzbfjAJz+C
        CXPQ1+3YYeJM49FzbNxCRygV2TZ93s6Qmw==
X-Google-Smtp-Source: AK7set93goLTRbWTIw8LuwqFrerqzjle12s/W8ubc3qiDMBwUg2wqmmoEKJq6+OWLDlVnOi/Tdufim4bH3JK0w==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a81:d24f:0:b0:52e:e6ed:3091 with SMTP id
 m15-20020a81d24f000000b0052ee6ed3091mr19162ywl.529.1676054836871; Fri, 10 Feb
 2023 10:47:16 -0800 (PST)
Date:   Fri, 10 Feb 2023 18:47:08 +0000
In-Reply-To: <20230210184708.2172562-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230210184708.2172562-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.581.gbfd45094c4-goog
Message-ID: <20230210184708.2172562-5-edumazet@google.com>
Subject: [PATCH net-next 4/4] ipv6: icmp6: add drop reason support to ndisc_rcv()
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Creates three new drop reasons:

SKB_DROP_REASON_IPV6_NDISC_FRAG: invalid frag (suppress_frag_ndisc).

SKB_DROP_REASON_IPV6_NDISC_HOP_LIMIT: invalid hop limit.

SKB_DROP_REASON_IPV6_NDISC_BAD_CODE: invalid NDISC icmp6 code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 include/net/dropreason.h |  9 +++++++++
 include/net/ndisc.h      |  2 +-
 net/ipv6/icmp.c          |  2 +-
 net/ipv6/ndisc.c         | 13 +++++++------
 4 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/include/net/dropreason.h b/include/net/dropreason.h
index 6c41e535175cfba44f1f948305c5a1ebc5be9a18..ef3f65d135d375920e88759890947ed0f6e87e10 100644
--- a/include/net/dropreason.h
+++ b/include/net/dropreason.h
@@ -73,6 +73,9 @@
 	FN(FRAG_TOO_FAR)		\
 	FN(TCP_MINTTL)			\
 	FN(IPV6_BAD_EXTHDR)		\
+	FN(IPV6_NDISC_FRAG)		\
+	FN(IPV6_NDISC_HOP_LIMIT)	\
+	FN(IPV6_NDISC_BAD_CODE)		\
 	FNe(MAX)
 
 /**
@@ -321,6 +324,12 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_MINTTL,
 	/** @SKB_DROP_REASON_IPV6_BAD_EXTHDR: Bad IPv6 extension header. */
 	SKB_DROP_REASON_IPV6_BAD_EXTHDR,
+	/** @SKB_DROP_REASON_IPV6_NDISC_FRAG: invalid frag (suppress_frag_ndisc). */
+	SKB_DROP_REASON_IPV6_NDISC_FRAG,
+	/** @SKB_DROP_REASON_IPV6_NDISC_HOP_LIMIT: invalid hop limit. */
+	SKB_DROP_REASON_IPV6_NDISC_HOP_LIMIT,
+	/** @SKB_DROP_REASON_IPV6_NDISC_BAD_CODE: invalid NDISC icmp6 code. */
+	SKB_DROP_REASON_IPV6_NDISC_BAD_CODE,
 	/**
 	 * @SKB_DROP_REASON_MAX: the maximum of drop reason, which shouldn't be
 	 * used as a real 'reason'
diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index da7eec8669ec4125b0b238f3af8627cd57a279b4..07e5168cdaf9a5a5a180a2d97c646552655982ce 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -445,7 +445,7 @@ int ndisc_late_init(void);
 void ndisc_late_cleanup(void);
 void ndisc_cleanup(void);
 
-int ndisc_rcv(struct sk_buff *skb);
+enum skb_drop_reason ndisc_rcv(struct sk_buff *skb);
 
 struct sk_buff *ndisc_ns_create(struct net_device *dev, const struct in6_addr *solicit,
 				const struct in6_addr *saddr, u64 nonce);
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 40bb5dedac09e4e4f3bd15944538c4324d028674..f32bc98155bfb027dd3328eefd4a26a1d067c013 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -969,7 +969,7 @@ static int icmpv6_rcv(struct sk_buff *skb)
 	case NDISC_NEIGHBOUR_SOLICITATION:
 	case NDISC_NEIGHBOUR_ADVERTISEMENT:
 	case NDISC_REDIRECT:
-		ndisc_rcv(skb);
+		reason = ndisc_rcv(skb);
 		break;
 
 	case ICMPV6_MGM_QUERY:
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 3a553494ff16468401f88a384423729a673188b3..9548b5a44714f98975a8b7194bc81cbb0f72697f 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1804,15 +1804,16 @@ static bool ndisc_suppress_frag_ndisc(struct sk_buff *skb)
 	return false;
 }
 
-int ndisc_rcv(struct sk_buff *skb)
+enum skb_drop_reason ndisc_rcv(struct sk_buff *skb)
 {
 	struct nd_msg *msg;
+	SKB_DR(reason);
 
 	if (ndisc_suppress_frag_ndisc(skb))
-		return 0;
+		return SKB_DROP_REASON_IPV6_NDISC_FRAG;
 
 	if (skb_linearize(skb))
-		return 0;
+		return SKB_DROP_REASON_NOMEM;
 
 	msg = (struct nd_msg *)skb_transport_header(skb);
 
@@ -1821,13 +1822,13 @@ int ndisc_rcv(struct sk_buff *skb)
 	if (ipv6_hdr(skb)->hop_limit != 255) {
 		ND_PRINTK(2, warn, "NDISC: invalid hop-limit: %d\n",
 			  ipv6_hdr(skb)->hop_limit);
-		return 0;
+		return SKB_DROP_REASON_IPV6_NDISC_HOP_LIMIT;
 	}
 
 	if (msg->icmph.icmp6_code != 0) {
 		ND_PRINTK(2, warn, "NDISC: invalid ICMPv6 code: %d\n",
 			  msg->icmph.icmp6_code);
-		return 0;
+		return SKB_DROP_REASON_IPV6_NDISC_BAD_CODE;
 	}
 
 	switch (msg->icmph.icmp6_type) {
@@ -1853,7 +1854,7 @@ int ndisc_rcv(struct sk_buff *skb)
 		break;
 	}
 
-	return 0;
+	return reason;
 }
 
 static int ndisc_netdev_event(struct notifier_block *this, unsigned long event, void *ptr)
-- 
2.39.1.581.gbfd45094c4-goog

