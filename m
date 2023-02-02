Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE51687917
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232256AbjBBJlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbjBBJlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:41:08 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BEB82400
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:41:07 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id t13-20020a056902018d00b0074747131938so1211749ybh.12
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 01:41:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=B1baGWQpS7BV0KxvdBGq01iTQqixi/UOlQF1ObtsFz8=;
        b=BXue/1Pe6MQI1NE+bs0g8oDdJZ3hU5IwA57tnffSURtGZOiMrrs+e48K2m5I5IK3Jl
         FY89PbYly+coG+JLlHzTW705EsF+YY1TXjM0I/p5S8aXNaOesqRnDgyCS8Yjy6/4qiGg
         negVxL70OzMKrVPkl5q7ggItf9PGLqORTU3FMj5rmz2hcTM3bncbIztd0cNbL6M1jOHn
         NC0eNCXUfaRjFDU4aBHiWblCEgQoPLllICx3fe/OBntNThdG8mMoCeMtb7+KXWuICmce
         FeYcyB/be6y715puyrHoFju6J2whZNAKAIN4sgOqrQXxThsfYOcIiuy+j6prvv77P7qm
         Rwxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=B1baGWQpS7BV0KxvdBGq01iTQqixi/UOlQF1ObtsFz8=;
        b=fD0MMvPjC3Lo+i7nEXjSzb25wCgIlKadwOXLW39heGWZ+DkhfTRbblF0Nuq+TixvGl
         t8srwyNuEg1o1BUe4aymHoPr0uvTJnX2PEFzzQ9/h/cGGLvqZgreTRL1LiPxEdeQaIBZ
         QEKNouo4g042RZ+KRoDGG/vWyQyhAsoHxMQadKnb6+3ypfs3togGui/8UQvC69I64qBH
         qLWUjF0vZeMULkWWvtvhx4stun/czsRYNlRTcPm1tvt1k8HFFHI3n4DQyNUTIvTJUzRl
         iSkSFqCP0dQtQyT1VTADUrTgP0sprMjTocc4z+RYMrcvNZFO5Iu9S9s9Unog4K0WNYZw
         0LYA==
X-Gm-Message-State: AO0yUKUzPIO5loli0HtbZIX4Qf1N30/9Ti8oOhFQZInpOOGYwgIVffDf
        lDJuBe6dQZfgGPCNb2jqNO2oXc5agcnX1Q==
X-Google-Smtp-Source: AK7set/xFkhqfDlL4MARaoOtvMjJpNBTDn87nEPBjORL2rxmMV7ZT7QIDntdcIq1yKptHFkSjRxogr9KlMvWGA==
X-Received: from edumazet1.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:395a])
 (user=edumazet job=sendgmr) by 2002:a05:6902:1081:b0:80b:52b3:6423 with SMTP
 id v1-20020a056902108100b0080b52b36423mr579037ybu.383.1675330866574; Thu, 02
 Feb 2023 01:41:06 -0800 (PST)
Date:   Thu,  2 Feb 2023 09:40:59 +0000
In-Reply-To: <20230202094100.3083177-1-edumazet@google.com>
Mime-Version: 1.0
References: <20230202094100.3083177-1-edumazet@google.com>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
Message-ID: <20230202094100.3083177-3-edumazet@google.com>
Subject: [PATCH net-next 2/3] ipv4: raw: add drop reasons
From:   Eric Dumazet <edumazet@google.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com,
        Eric Dumazet <edumazet@google.com>
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

Use existing helpers and drop reason codes for RAW input path.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 net/ipv4/raw.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/raw.c b/net/ipv4/raw.c
index 006c1f0ed8b4731a8c64de282409e4bb03a6c1a6..9865d15a08dfe96f0027c51a2d580dfa5903e5d4 100644
--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -287,11 +287,13 @@ void raw_icmp_error(struct sk_buff *skb, int protocol, u32 info)
 
 static int raw_rcv_skb(struct sock *sk, struct sk_buff *skb)
 {
+	enum skb_drop_reason reason;
+
 	/* Charge it to the socket. */
 
 	ipv4_pktinfo_prepare(sk, skb);
-	if (sock_queue_rcv_skb(sk, skb) < 0) {
-		kfree_skb(skb);
+	if (sock_queue_rcv_skb_reason(sk, skb, &reason) < 0) {
+		kfree_skb_reason(skb, reason);
 		return NET_RX_DROP;
 	}
 
@@ -302,7 +304,7 @@ int raw_rcv(struct sock *sk, struct sk_buff *skb)
 {
 	if (!xfrm4_policy_check(sk, XFRM_POLICY_IN, skb)) {
 		atomic_inc(&sk->sk_drops);
-		kfree_skb(skb);
+		kfree_skb_reason(skb, SKB_DROP_REASON_XFRM_POLICY);
 		return NET_RX_DROP;
 	}
 	nf_reset_ct(skb);
-- 
2.39.1.456.gfc5497dd1b-goog

