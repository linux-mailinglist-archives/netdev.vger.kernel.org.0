Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622255717BF
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiGLK5h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbiGLK5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:57:31 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38E43AEF44
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:30 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id s206so7229722pgs.3
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K71MS99bqz99tan2aa/FDDH12hy8394zX/UitXYZGEs=;
        b=eA1rm4w6Fx0fZRqOYJimlzIG2zvmbB8m5tYv9Y1JKQWbcRRiThxlmPEQYvhIJmDonx
         MtE564Vg8Ron4N7cfolfdvIbrfAdPI9d55SAEC1QngK6vP6yfsyDEhXFaSUzA+BPIxrN
         T71amjmp1wgeyRL3wYwiKu3Z76VEbf1+oVCKzyY7VAmU3L3mV2HpT6jzgVcjKHzZ7yi0
         VENd/wsKvg4tm6Wgy41u5fEb+gdv3dloWbFqUymHE0ikhjhfAsPDCOmqKJKU5kjn+JFr
         k247+6P+vomE8R6OXsmO4mH3ZTSHPxeEhufPvZoI15RvXGKZwZSDY4gcSay1uuofYapI
         YbGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K71MS99bqz99tan2aa/FDDH12hy8394zX/UitXYZGEs=;
        b=yz2+OKnWR197KiHiTLyeed868a5u2Aefz/Wnplvmlwx6AZo3MBdJjr3I9t/6n++Jql
         mwPnfLqTsmfliDzebWAxJwf1uPLj0X9kUmmPnhgd4XBK/W1ncJgALno+wxnNAYBLGDCD
         59dcXZpsvgoD5nhfB1kFdQ0CHEcQ7kF1NiEyOvoYAcQ1jZdvjlOgdT12xYY5sJ08/mRr
         oZjOoTGVCgSiWSGaqpQd42CS5mm7B3gWv7kPXYO+iIwtWgdDrPhMSeEe+kL/WJl/wFSX
         7X/rKIQCnwy3YC1WVi/8mdHkEn8r+Ueypp3C9I9W6HFGuBwdMBjt7j7yraN3T6XKxYix
         ifqg==
X-Gm-Message-State: AJIora+uRRr75T9w0dHJEXXr8c2vmI0NKsIYdmoXZrzqbhfrqKSHjc3G
        z8lVoWAuhxeadHIJdQ+u5kU=
X-Google-Smtp-Source: AGRyM1vtaS/K/rmpIA7rjknq7p4F1ObPFn9CNzn3fiACx4w0ikB9MwKIqGO83Okm2/CMGWKthSky9Q==
X-Received: by 2002:aa7:9583:0:b0:52a:f076:5043 with SMTP id z3-20020aa79583000000b0052af0765043mr1008312pfj.9.1657623449623;
        Tue, 12 Jul 2022 03:57:29 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id im22-20020a170902bb1600b0016c37fe48casm5681714plb.193.2022.07.12.03.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 03:57:28 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net 2/8] amt: remove unnecessary locks
Date:   Tue, 12 Jul 2022 10:57:08 +0000
Message-Id: <20220712105714.12282-3-ap420073@gmail.com>
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

By the previous patch, amt gateway handlers are changed to worked by
a single thread.
So, most locks for gateway are not needed.
So, it removes.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 032c2934e466..3ff8e522b92a 100644
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

