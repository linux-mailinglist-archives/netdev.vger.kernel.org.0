Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9FD557773A
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232667AbiGQQMq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:12:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbiGQQMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:12:36 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C12E140F7
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:34 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id b2so7108603plx.7
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=t2JmiWu5xuS6YJGZJO3rAneJ9uWBddl1DmsWrtCvXJU=;
        b=l+pXb0ZsEGIomyR7nEvSPvFK/ejghSc5X7bUjDNYYAbBAPJw84tJGqjTSQcT777iuC
         unHUb4/TZIXrp4HV3q0GFIagV3LDoNypyXiY7/kCoM0Tn2cF49KM8/hrQRJTw7DbEVob
         JTdADdMVYEXBlKxsjYPGVGzh3z9oD6Ur66GUzYzCkkfFcSM3oVapVqmyN3WvwH14U/Ff
         h/csOZHwM72Ysxf3vdxmy4Re2tx0BBG9EJBibAJPsNiZRP5dMNDyKpJ2nl7JtcJq/z8V
         K0J44Ks6aIO94RkY13fMm/ehkNQzN/ZwRBWOMVyEFY2wNkuNJx6xtX9117XV+ieIhzPL
         yumw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=t2JmiWu5xuS6YJGZJO3rAneJ9uWBddl1DmsWrtCvXJU=;
        b=OJs4TvLOMKYFr3et6gm7merEKIe662iXoPZLXlKAomsKnJCeXsBYZKfK1Q9QelZaE7
         gsWEgxiM9rCGVii7BfKIA6JDI20DTDVkx42PPMgfsnQN0Hr5MB35CeYqSMa91/WbNEQN
         0zau3irffVSbSKgTAp8Db8hVa/eL+d0ciK98w4LVXon9+iSKioYosCZcVv+6LzDQbjPK
         hF91J0LrK0aAepwCWj5DuRQybco0olx0oBgzNCao25GI714XZMWpMzzzB1jweaU9QNgy
         EPW+AQ4SKVqOhJQFtmvyKW5t/cXQrKq/JNtYpjSqwb9qGkSMc4Pfr/LyotqO2wmfVEu4
         qg6Q==
X-Gm-Message-State: AJIora9EBBg18vJpafukoQ/VAZq7Pbt+XpMfDyCuIRwbOi9cSlK6HcPN
        IXUjLypq+FF2qA7HoRbA8fo=
X-Google-Smtp-Source: AGRyM1vPAh/yMwyIL8xTlZbx1S01AqtVy34ZUHTeAuv6dE3vnrF1PJ1op8/4yoNg/qCIzCD5aY/Q0Q==
X-Received: by 2002:a17:902:a406:b0:16b:c816:6427 with SMTP id p6-20020a170902a40600b0016bc8166427mr24146848plq.88.1658074354176;
        Sun, 17 Jul 2022 09:12:34 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902ec8a00b0016bde5edfb1sm7443026plg.171.2022.07.17.09.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 09:12:33 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 6/8] amt: drop unexpected query message
Date:   Sun, 17 Jul 2022 16:09:08 +0000
Message-Id: <20220717160910.19156-7-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220717160910.19156-1-ap420073@gmail.com>
References: <20220717160910.19156-1-ap420073@gmail.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

v2:
 - No changes.

 drivers/net/amt.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 3e41dc6235b7..396cfee018a0 100644
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

