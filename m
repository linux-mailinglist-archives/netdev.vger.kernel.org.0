Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00E25717C8
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:58:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232887AbiGLK6A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbiGLK5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:57:41 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9733AEF45
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:40 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o12so7163578pfp.5
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=sS1sxxt896YlUH8DlnqNj5vGkKCZA4/SobMileCBQiw=;
        b=PE7Mj6ktrq0WDR1s0P1e6EAd0/F7KSqa61YBCorR8nDzz06KRTld9UPHvoUZcH5dcN
         0d6skSRbQIVEyrQW6Ri/59Vu6E9jHJy4bQaGSdAIH6py7TZo1GDRr1Lcf+bHsGR669D1
         KiCyVKe6TYTC3ktbYsCnRzyiIUdJYeGw8HCYMxqu/4f14c/qKxsRPI9YkQ06qjSPYCaD
         NdCKFOvEP819y7fPj7km2a7aXrfD94Ey4CpBcbXt9hmLE/PrVzjF4yIfkLZvZ4xujKed
         2JPYZUSEAzpKrxxsithJeBkdnHuiBNMZMLU9V5I+s+i2uN++ABsuth7vwBf08MCDkSR4
         7hZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=sS1sxxt896YlUH8DlnqNj5vGkKCZA4/SobMileCBQiw=;
        b=feYZdrdc6dApiimoHcMAQ7AbM52h+B+gFIhCdsPa1N9pFSjcX0aGYHcPWPm9PfcDrQ
         kEYeFipoqWfUipf0n+YMb7/1KiS6HSG/ceVF5CoMVKY/ID8dwLjdMQp3ccZETzsyZ0pP
         YhUSCC0ZJMHgNKeWdmu5Zp7amHPQPAPbBrEky//QlVIDZun4X/aOJ86Blh7E4cuocmDc
         p3fO8awi8bPvcsWNB9BMGFlFcisNh0HbLMxZJ7hoa0pf5ZBxUpZYHotIIcNpESmT3eq+
         OaYSF8T/tunNUFfDXuQS0gVwtEpAgQmdWPSEZ+/2ym//vf2tUby9lXWdnBdapA8aFY7p
         kObg==
X-Gm-Message-State: AJIora91hH6HuYDqY0J843nrS+yUITin5ftoi5IPX1lMxn4hTBF3pTcA
        SXebgHDOCitEYxrwc0LwQ5g=
X-Google-Smtp-Source: AGRyM1uoi+/p8SXUKIwaMhf58f5t+gpS9cLzXwPR8Ai8dyCdYqVl6GlDMybEvRm0n7PW4CdOStOObQ==
X-Received: by 2002:a62:a113:0:b0:51c:1b4c:38d1 with SMTP id b19-20020a62a113000000b0051c1b4c38d1mr23066388pff.13.1657623460075;
        Tue, 12 Jul 2022 03:57:40 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016c37fe48casm5681714plb.193.2022.07.12.03.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:57:39 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 6/8] amt: drop unexpected query message
Date:   Tue, 12 Jul 2022 10:57:12 +0000
Message-Id: <20220712105714.12282-7-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220712105714.12282-1-ap420073@gmail.com>
References: <20220712105714.12282-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

AMT gateway interface should not receive unexpected query messages.
In order to drop unexpected query messages, it checks nonce.
And it also checks ready4 and ready6 variables to drop duplicated messages.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 6a12c32fb3a1..dbaf490cc33f 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -967,8 +967,11 @@ static void amt_event_send_request(struct amt_dev *amt)
 		goto out;
 	}
 
-	if (!amt->req_cnt)
+	if (!amt->req_cnt) {
+		WRITE_ONCE(amt->ready4, false);
+		WRITE_ONCE(amt->ready6, false);
 		get_random_bytes(&amt->nonce, sizeof(__be32));
+	}
 
 	amt_send_request(amt, false);
 	amt_send_request(amt, true);
@@ -2353,6 +2356,9 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 	if (amtmq->reserved || amtmq->version)
 		return true;
 
+	if (amtmq->nonce != amt->nonce)
+		return true;
+
 	hdr_size -= sizeof(*eth);
 	if (iptunnel_pull_header(skb, hdr_size, htons(ETH_P_TEB), false))
 		return true;
@@ -2367,6 +2373,9 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 
 	iph = ip_hdr(skb);
 	if (iph->version == 4) {
+		if (READ_ONCE(amt->ready4))
+			return true;
+
 		if (!pskb_may_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS +
 				   sizeof(*ihv3)))
 			return true;
@@ -2389,6 +2398,9 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		struct mld2_query *mld2q;
 		struct ipv6hdr *ip6h;
 
+		if (READ_ONCE(amt->ready6))
+			return true;
+
 		if (!pskb_may_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS +
 				   sizeof(*mld2q)))
 			return true;
-- 
2.17.1

