Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4646CC1F7
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 16:21:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbjC1OV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 10:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjC1OVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 10:21:25 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0E2A102;
        Tue, 28 Mar 2023 07:21:24 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id p13-20020a17090a284d00b0023d2e945aebso1831317pjf.0;
        Tue, 28 Mar 2023 07:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680013284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EBTD9anSg+DK8ZTYd/DgBczIs+okCYD2CyOH9MpwvwM=;
        b=ksycxZwnk4UEPjWWOOiiqyDfXgfNPznq5Xcrsca/beigGP9no3pfZAIphhSoCHPOVA
         iVlLABmX4ctAi9nXWG0wVJPTrvn24ketP21QZWc8l8qoN0RYxF56ep4hMtKcz0a9ddA4
         8lPxep52D0Qedn7RqeW5AF/1B1CUJfj1AJt1piKejolZYTN0llifmxmy0OUdD0kwb0ei
         zPvyQet/XJdNFZqURh/+dBl7BlTo0nIyFkqqeYRr3ZdEuObN/uTdaOjIdRZvSFcntAEU
         rkgXznM2yCPQZBsBwEOjTxONthQhDsR+EPszwLHbPa5dVjNkkgJYgzkDlfslX8ucG7yt
         +IaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680013284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EBTD9anSg+DK8ZTYd/DgBczIs+okCYD2CyOH9MpwvwM=;
        b=jhtfQPHOvcsBrLnQ0QSlS/XJ7fq8zP+R/DVCXLApZb1HLiSzJRbOwrQkSe1cIqdxd8
         dR9BkPwFNnEoB1NLvrX/3rNLGolOBxbIfrEnQh+u51aMJWBzRrInAvXb75nkqZRPxlhh
         3b8hkjtimYwG/e0CDabMlj2jiq8LUf6GHjbQIti7+Gc8VFFqpAZmGgHVtNEJ/pGfcCLn
         P+HX9pWC48/Aquvk3ruYxD2YvoyGM/krMj+doag40Ta8B3KXtVzQYeC3+BiE9ZuCuI3L
         54ehhEbLQebLg0DsVQVOTUH7g6NJfsO7G6PBcVHGLSbrFLmqc5XoRpJ2ODm0Yb3wRivq
         2NEg==
X-Gm-Message-State: AAQBX9fsBClccYF1nAbkOHyuuEXVpV5yr6pLRUdNyMLEp7cpkaq690Fv
        YK4jjg2w0gb3tnHfUp1vNkE=
X-Google-Smtp-Source: AKy350ZUOoMaKKaMZEP+Uclx7Qf8HuNoKAm6zEbBiBBN5ugLie1EzM4ICCQko4Td+hPakrvv7/LLrQ==
X-Received: by 2002:a17:902:cec6:b0:19a:ad2f:2df9 with SMTP id d6-20020a170902cec600b0019aad2f2df9mr17179609plg.55.1680013284114;
        Tue, 28 Mar 2023 07:21:24 -0700 (PDT)
Received: from KERNELXING-MB0.tencent.com ([103.7.29.31])
        by smtp.gmail.com with ESMTPSA id g7-20020a170902934700b0019d397b0f18sm21141552plp.214.2023.03.28.07.21.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 07:21:23 -0700 (PDT)
From:   Jason Xing <kerneljasonxing@gmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kerneljasonxing@gmail.com, Jason Xing <kernelxing@tencent.com>
Subject: [PATCH v2 net] net: rps: avoid raising a softirq on the current cpu when scheduling napi
Date:   Tue, 28 Mar 2023 22:21:12 +0800
Message-Id: <20230328142112.12493-1-kerneljasonxing@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kernelxing@tencent.com>

When we are scheduling napi and then RPS decides to put the skb into
a backlog queue of another cpu, we shouldn't raise the softirq for
the current cpu. When to raise a softirq is based on whether we have
more data left to process later. But apparently, as to the current
cpu, there is no indication of more data enqueued, so we do not need
this action. After enqueuing to another cpu, net_rx_action() or
process_backlog() will call ipi and then another cpu will raise the
softirq as expected.

Also, raising more softirqs which set the corresponding bit field
can make the IRQ mechanism think we probably need to start ksoftirqd
on the current cpu. Actually it shouldn't happen.

Here are some codes to clarify how it can trigger ksoftirqd:
__do_softirq()
  [1] net_rx_action() -> enqueue_to_backlog() -> raise an IRQ
  [2] check if pending is set again -> wakeup_softirqd

Comments on above:
[1] when RPS chooses another cpu to enqueue skb
[2] in __do_softirq() it will wait a little bit of time around 2 jiffies

In this patch, raising an IRQ can be avoided when RPS enqueues the skb
into another backlog queue not the current one.

I captured some data when starting one iperf3 process and found out
we can reduces around ~1500 times/sec at least calling
__raise_softirq_irqoff().

Fixes: 0a9627f2649a ("rps: Receive Packet Steering")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
---
v2:
1) change the title and add more details.
2) add one parameter to recognise whether it is napi or non-napi case
suggested by Eric.
Link: https://lore.kernel.org/lkml/20230325152417.5403-1-kerneljasonxing@gmail.com/
---
 net/core/dev.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1518a366783b..504dc3fc09b1 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4586,7 +4586,7 @@ static void trigger_rx_softirq(void *data)
  * If yes, queue it to our IPI list and return 1
  * If no, return 0
  */
-static int napi_schedule_rps(struct softnet_data *sd)
+static int napi_schedule_rps(struct softnet_data *sd, bool napi)
 {
 	struct softnet_data *mysd = this_cpu_ptr(&softnet_data);
 
@@ -4594,8 +4594,9 @@ static int napi_schedule_rps(struct softnet_data *sd)
 	if (sd != mysd) {
 		sd->rps_ipi_next = mysd->rps_ipi_list;
 		mysd->rps_ipi_list = sd;
+		if (!napi)
+			__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 
-		__raise_softirq_irqoff(NET_RX_SOFTIRQ);
 		return 1;
 	}
 #endif /* CONFIG_RPS */
@@ -4648,7 +4649,7 @@ static bool skb_flow_limit(struct sk_buff *skb, unsigned int qlen)
  * queue (may be a remote CPU queue).
  */
 static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
-			      unsigned int *qtail)
+			      unsigned int *qtail, bool napi)
 {
 	enum skb_drop_reason reason;
 	struct softnet_data *sd;
@@ -4675,7 +4676,7 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 		 * We can use non atomic operation since we own the queue lock
 		 */
 		if (!__test_and_set_bit(NAPI_STATE_SCHED, &sd->backlog.state))
-			napi_schedule_rps(sd);
+			napi_schedule_rps(sd, napi);
 		goto enqueue;
 	}
 	reason = SKB_DROP_REASON_CPU_BACKLOG;
@@ -4933,7 +4934,7 @@ static int netif_rx_internal(struct sk_buff *skb)
 		if (cpu < 0)
 			cpu = smp_processor_id();
 
-		ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
+		ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail, false);
 
 		rcu_read_unlock();
 	} else
@@ -4941,7 +4942,7 @@ static int netif_rx_internal(struct sk_buff *skb)
 	{
 		unsigned int qtail;
 
-		ret = enqueue_to_backlog(skb, smp_processor_id(), &qtail);
+		ret = enqueue_to_backlog(skb, smp_processor_id(), &qtail, false);
 	}
 	return ret;
 }
@@ -5670,7 +5671,7 @@ static int netif_receive_skb_internal(struct sk_buff *skb)
 		int cpu = get_rps_cpu(skb->dev, skb, &rflow);
 
 		if (cpu >= 0) {
-			ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
+			ret = enqueue_to_backlog(skb, cpu, &rflow->last_qtail, false);
 			rcu_read_unlock();
 			return ret;
 		}
@@ -5705,7 +5706,7 @@ void netif_receive_skb_list_internal(struct list_head *head)
 			if (cpu >= 0) {
 				/* Will be handled, remove from list */
 				skb_list_del_init(skb);
-				enqueue_to_backlog(skb, cpu, &rflow->last_qtail);
+				enqueue_to_backlog(skb, cpu, &rflow->last_qtail, true);
 			}
 		}
 	}
-- 
2.37.3

