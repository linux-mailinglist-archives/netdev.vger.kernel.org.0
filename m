Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A61C577739
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:12:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiGQQM2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiGQQM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:12:26 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAFFC13CE6
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:24 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id q13-20020a17090a304d00b001f1af9a18a2so1941648pjl.5
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:12:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=E18DipzlHTOPrZ1X/RxGRT5qcnFx2LP+FUY7Y7RSdQs=;
        b=BhAIVG+kWJEvDgTK17VfboQjIlRxEzi/ja7mZtmTV/+t/3E26Wb6PvaltvuTfD0KU4
         3idlsp3pKbiGVkDgQt+/3zZSa7dYU31utTq1QZfI/1uPxv1QBxE5VgC3B5C/2xuGXYjB
         BHfeOJHQOJUU5HtkrlAP6hqY2qu/R7NZ9RLKJmbPvpacp+PmRFp+HpiH/b8XIuiTu1am
         hslfyIAvb21vcFdajvgmkLENjQiJ0CnBtmnHx1Sg7HC1Y8ggVNtmnOXIM7uvvGbPlyCT
         tnBfhwrM3qp5VN17Rd3Xfa8orb+b9CGuX6oO6JR2lYAihIZZyoUl7cj3AUyASi/v4c0G
         Xnfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=E18DipzlHTOPrZ1X/RxGRT5qcnFx2LP+FUY7Y7RSdQs=;
        b=jcqPzsuMVUEx4sP7h3LEPKCzc7iAsmQXCnebECw4Y2UG2JWYPt0TADiuY0kGH9aKtV
         UDbjarqrXPRKrP6j/MbrwFzVcEhISwSEQoVejD6a4oMkiw6er430k7oUfQpQSJHwZ3gn
         A2OkeSq0DiiuBvlceukqj6Gy8LaYoV7pMLkZFGbvcK/Qtcsk0zE87vAGL2eSSaDbhBSc
         q1KDiDUvUf0ca5DAEZh07rMi3Aoau6HinlldVOng9b/USiqQCuvvg9D/UIaFELU5T8D8
         qI8yjshL6XFHpvbNV8QXfbXH9YgYhgH8ga+YRfDt1pqK44zaT4xNRuI+Dz+K8ULqVO7S
         SW7Q==
X-Gm-Message-State: AJIora/qYc6B1iemCNtaptUuJ3QVmIBiqY1XYK9LDc5GAZs3HCKWaApR
        dkIDbIRWSMIRi2yu+/Kz9W8=
X-Google-Smtp-Source: AGRyM1tsOMMbEORPdKVcqXa3W+F74XBuzLftWgdQXAzgn1VuFdD2sfIqm7weFaWKBkIRbHbcW2StkA==
X-Received: by 2002:a17:903:11c5:b0:16c:ece7:f687 with SMTP id q5-20020a17090311c500b0016cece7f687mr2412270plh.165.1658074344261;
        Sun, 17 Jul 2022 09:12:24 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id x10-20020a170902ec8a00b0016bde5edfb1sm7443026plg.171.2022.07.17.09.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Jul 2022 09:12:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net v2 2/8] amt: remove unnecessary locks
Date:   Sun, 17 Jul 2022 16:09:04 +0000
Message-Id: <20220717160910.19156-3-ap420073@gmail.com>
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

By the previous patch, amt gateway handlers are changed to worked by
a single thread.
So, most locks for gateway are not needed.
So, it removes.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---

v2:
 - No changes.

 drivers/net/amt.c | 32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 21104efd803f..42220d857f8a 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -577,8 +577,8 @@ static struct sk_buff *amt_build_igmp_gq(struct amt_dev *amt)
 	return skb;
 }
 
-static void __amt_update_gw_status(struct amt_dev *amt, enum amt_status status,
-				   bool validate)
+static void amt_update_gw_status(struct amt_dev *amt, enum amt_status status,
+				 bool validate)
 {
 	if (validate && amt->status >= status)
 		return;
@@ -600,14 +600,6 @@ static void __amt_update_relay_status(struct amt_tunnel_list *tunnel,
 	tunnel->status = status;
 }
 
-static void amt_update_gw_status(struct amt_dev *amt, enum amt_status status,
-				 bool validate)
-{
-	spin_lock_bh(&amt->lock);
-	__amt_update_gw_status(amt, status, validate);
-	spin_unlock_bh(&amt->lock);
-}
-
 static void amt_update_relay_status(struct amt_tunnel_list *tunnel,
 				    enum amt_status status, bool validate)
 {
@@ -700,9 +692,7 @@ static void amt_send_discovery(struct amt_dev *amt)
 	if (unlikely(net_xmit_eval(err)))
 		amt->dev->stats.tx_errors++;
 
-	spin_lock_bh(&amt->lock);
-	__amt_update_gw_status(amt, AMT_STATUS_SENT_DISCOVERY, true);
-	spin_unlock_bh(&amt->lock);
+	amt_update_gw_status(amt, AMT_STATUS_SENT_DISCOVERY, true);
 out:
 	rcu_read_unlock();
 }
@@ -937,18 +927,14 @@ static void amt_secret_work(struct work_struct *work)
 
 static void amt_event_send_discovery(struct amt_dev *amt)
 {
-	spin_lock_bh(&amt->lock);
 	if (amt->status > AMT_STATUS_SENT_DISCOVERY)
 		goto out;
 	get_random_bytes(&amt->nonce, sizeof(__be32));
-	spin_unlock_bh(&amt->lock);
 
 	amt_send_discovery(amt);
-	spin_lock_bh(&amt->lock);
 out:
 	mod_delayed_work(amt_wq, &amt->discovery_wq,
 			 msecs_to_jiffies(AMT_DISCOVERY_TIMEOUT));
-	spin_unlock_bh(&amt->lock);
 }
 
 static void amt_discovery_work(struct work_struct *work)
@@ -966,7 +952,6 @@ static void amt_event_send_request(struct amt_dev *amt)
 {
 	u32 exp;
 
-	spin_lock_bh(&amt->lock);
 	if (amt->status < AMT_STATUS_RECEIVED_ADVERTISEMENT)
 		goto out;
 
@@ -976,21 +961,18 @@ static void amt_event_send_request(struct amt_dev *amt)
 		amt->ready4 = false;
 		amt->ready6 = false;
 		amt->remote_ip = 0;
-		__amt_update_gw_status(amt, AMT_STATUS_INIT, false);
+		amt_update_gw_status(amt, AMT_STATUS_INIT, false);
 		amt->req_cnt = 0;
 		goto out;
 	}
-	spin_unlock_bh(&amt->lock);
 
 	amt_send_request(amt, false);
 	amt_send_request(amt, true);
-	spin_lock_bh(&amt->lock);
-	__amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
+	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
 	amt->req_cnt++;
 out:
 	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
 	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
-	spin_unlock_bh(&amt->lock);
 }
 
 static void amt_req_work(struct work_struct *work)
@@ -2386,12 +2368,10 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		ihv3 = skb_pull(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*iph) + AMT_IPHDR_OPTS);
-		spin_lock_bh(&amt->lock);
 		amt->ready4 = true;
 		amt->mac = amtmq->response_mac;
 		amt->req_cnt = 0;
 		amt->qi = ihv3->qqic;
-		spin_unlock_bh(&amt->lock);
 		skb->protocol = htons(ETH_P_IP);
 		eth->h_proto = htons(ETH_P_IP);
 		ip_eth_mc_map(iph->daddr, eth->h_dest);
@@ -2411,12 +2391,10 @@ static bool amt_membership_query_handler(struct amt_dev *amt,
 		mld2q = skb_pull(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
 		skb_reset_transport_header(skb);
 		skb_push(skb, sizeof(*ip6h) + AMT_IP6HDR_OPTS);
-		spin_lock_bh(&amt->lock);
 		amt->ready6 = true;
 		amt->mac = amtmq->response_mac;
 		amt->req_cnt = 0;
 		amt->qi = mld2q->mld2q_qqic;
-		spin_unlock_bh(&amt->lock);
 		skb->protocol = htons(ETH_P_IPV6);
 		eth->h_proto = htons(ETH_P_IPV6);
 		ipv6_eth_mc_map(&ip6h->daddr, eth->h_dest);
-- 
2.17.1

