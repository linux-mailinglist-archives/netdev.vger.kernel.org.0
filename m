Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AE552712A
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 15:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiENNOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 09:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbiENNOs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 09:14:48 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D423F30E
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 06:14:47 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id n18so10410437plg.5
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 06:14:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Jmb3Ndg7jfYVywDZX/NNUJumL5I0p4LoTySk26ze9bc=;
        b=aUrZFjnNMtSznB9Igmnv31JGPObIuyQ8nhrlcmtuKCr0TRahG1//Vnc5pMxUJ1R1ns
         N6SkX7xymHlYs0RrCo4qrvlR35WSu8EZ+BCvATf/UWp0Yw8/TsGpgi30/lNoK83tKn5J
         9CQNOQ3urBJ1QwXWDfUjTDmdj/EBcqvKn/pPWKXTUv93RVV+thh+cDipx7K4HK0z0ixK
         lngcNC+NciGE4cuN5rag5+rbKkEjQHLdEirA0QOEl0yVOrEg1pWuLyhHjURk6tTbfc02
         DFP5LzcAvzq5xkInqjcnLwgY2V9Cbf8HE/leN3AfEm5nHnU+lENZALomJzc+dUfcJ8m0
         McQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Jmb3Ndg7jfYVywDZX/NNUJumL5I0p4LoTySk26ze9bc=;
        b=PzXErYV8nZ2IWKRyE5zAnu54I/zgmPeVBfC119kfnCcZmJOgoN17kfgglNOfdWwzcH
         9W30LuiCnk7AQBzF0jvXBTYU7WbMSa+E22YBdIgoZZQtWfr0AtLZ6u2VqGCFsFA6dx0e
         CxX7wkCR+7mfVvZjvkn77ELIv6iJ90LnRRpKufNz1Sg3Au0bDn0FMhWdIZisPkTUmaGH
         PGEVcVJAVWpHiZbd6gWB4ANxEH52C38osbY1fIWbo2bFyeWYqD3Y15slxzpdf1XYKIkb
         Y73XK9pIJ3FnboQ5Vzrw/j6D+zuzQx8/vO1M7qlvZ6cVZYF5y3Ku4v0gTB0dLfNLFVU9
         BwSA==
X-Gm-Message-State: AOAM531C/0kM/8MrVKf+zKtK2KGeHP6BrN9WNmvbA7G7Cu7JA9QLgsOU
        VkxhEi9UfMZOamZx/AGl6GI=
X-Google-Smtp-Source: ABdhPJxRZclNnh8FArhuL4HbD4ycAPLV5eyt5F/UfFyaBj0BnX5Y4tMKQN1fcHhSavBHy83VeazvJA==
X-Received: by 2002:a17:902:700b:b0:15f:a51a:cdeb with SMTP id y11-20020a170902700b00b0015fa51acdebmr9169471plk.137.1652534086697;
        Sat, 14 May 2022 06:14:46 -0700 (PDT)
Received: from localhost.localdomain ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902bf4200b0015f44241a31sm3651750pls.110.2022.05.14.06.14.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 06:14:45 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net] amt: fix gateway mode stuck
Date:   Sat, 14 May 2022 13:13:46 +0000
Message-Id: <20220514131346.17045-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If a gateway can not receive any response to requests from a relay,
gateway resets status from SENT_REQUEST to INIT and variable about a
relay as well. And then it should start the full establish step
from sending a discovery message and receiving advertisement message.
But, after failure in amt_req_work() it continues sending a request
message step with flushed(invalid) relay information and sets SENT_REQUEST.
So, a gateway can't be established with a relay.
In order to avoid this situation, it stops sending the request message
step if it fails.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/amt.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index 10455c9b9da0..6ce2ecd07640 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -943,7 +943,7 @@ static void amt_req_work(struct work_struct *work)
 	if (amt->status < AMT_STATUS_RECEIVED_ADVERTISEMENT)
 		goto out;
 
-	if (amt->req_cnt++ > AMT_MAX_REQ_COUNT) {
+	if (amt->req_cnt > AMT_MAX_REQ_COUNT) {
 		netdev_dbg(amt->dev, "Gateway is not ready");
 		amt->qi = AMT_INIT_REQ_TIMEOUT;
 		amt->ready4 = false;
@@ -951,13 +951,15 @@ static void amt_req_work(struct work_struct *work)
 		amt->remote_ip = 0;
 		__amt_update_gw_status(amt, AMT_STATUS_INIT, false);
 		amt->req_cnt = 0;
+		goto out;
 	}
 	spin_unlock_bh(&amt->lock);
 
 	amt_send_request(amt, false);
 	amt_send_request(amt, true);
-	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
 	spin_lock_bh(&amt->lock);
+	__amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
+	amt->req_cnt++;
 out:
 	exp = min_t(u32, (1 * (1 << amt->req_cnt)), AMT_MAX_REQ_TIMEOUT);
 	mod_delayed_work(amt_wq, &amt->req_wq, msecs_to_jiffies(exp * 1000));
@@ -2696,9 +2698,10 @@ static int amt_rcv(struct sock *sk, struct sk_buff *skb)
 				err = true;
 				goto drop;
 			}
-			if (amt_advertisement_handler(amt, skb))
+			err = amt_advertisement_handler(amt, skb);
+			if (err)
 				amt->dev->stats.rx_dropped++;
-			goto out;
+			break;
 		case AMT_MSG_MULTICAST_DATA:
 			if (iph->saddr != amt->remote_ip) {
 				netdev_dbg(amt->dev, "Invalid Relay IP\n");
-- 
2.17.1

