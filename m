Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8190B6E8F89
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 12:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbjDTKIb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 06:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234572AbjDTKG6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 06:06:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C713646AF
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 03:06:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681985160;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=elcDYoAXlzHyUH9pw1SlfOMs4hYjrJ31y0w3piTl+NY=;
        b=gfHQMtZ49qExY1H6aH1o92UF7D7DKIH4hgANFdSDZEAshh14UUuyODqERNwfQblzyVtu5a
        Aib1iF7ar3SQWcPAEZfl7MAv1CPOB9ZOHdoH/qUtEtX7ekohVFxl+QOhPUZWsKkEHafvNz
        DZA2ojLoSsdbsgSMR4XRK2Df+kMMH0E=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-643-kAlAF34TOoiaHWWgW2asSQ-1; Thu, 20 Apr 2023 06:05:57 -0400
X-MC-Unique: kAlAF34TOoiaHWWgW2asSQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E17103802AC0;
        Thu, 20 Apr 2023 10:05:56 +0000 (UTC)
Received: from firesoul.localdomain (unknown [10.45.242.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A92C42166B33;
        Thu, 20 Apr 2023 10:05:56 +0000 (UTC)
Received: from [10.1.1.1] (localhost [IPv6:::1])
        by firesoul.localdomain (Postfix) with ESMTP id 65B9D307372E8;
        Thu, 20 Apr 2023 12:05:55 +0200 (CEST)
Subject: [PATCH net-next V1] net: flush sd->defer_list on unregister_netdevice
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     netdev@vger.kernel.org, edumazet@google.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, pabeni@redhat.com,
        kuba@kernel.org, hawk@kernel.org, davem@davemloft.net,
        lorenzo@kernel.org
Date:   Thu, 20 Apr 2023 12:05:55 +0200
Message-ID: <168198515529.808959.12962138073127060724.stgit@firesoul>
User-Agent: StGit/1.4
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When removing a net_device (that use NAPI), the sd->defer_list
system can still hold on to SKBs that have a dst_entry which can
have a netdev_hold reference.

Choose simple solution of flushing the softnet_data defer_list
system as part of unregister_netdevice flush_all_backlogs().

Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
---
 net/core/dev.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 3fc4dba71f9d..b63edd2c21e4 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5780,6 +5780,8 @@ EXPORT_SYMBOL(netif_receive_skb_list);
 
 static DEFINE_PER_CPU(struct work_struct, flush_works);
 
+static void skb_defer_free_flush(struct softnet_data *sd, bool napi_safe);
+
 /* Network device is going away, flush any packets still pending */
 static void flush_backlog(struct work_struct *work)
 {
@@ -5806,6 +5808,8 @@ static void flush_backlog(struct work_struct *work)
 			input_queue_head_incr(sd);
 		}
 	}
+
+	skb_defer_free_flush(sd, false);
 	local_bh_enable();
 }
 
@@ -5824,6 +5828,9 @@ static bool flush_required(int cpu)
 		   !skb_queue_empty_lockless(&sd->process_queue);
 	rps_unlock_irq_enable(sd);
 
+	if (READ_ONCE(sd->defer_list))
+		do_flush = true;
+
 	return do_flush;
 #endif
 	/* without RPS we can't safely check input_pkt_queue: during a
@@ -6623,23 +6630,32 @@ static int napi_threaded_poll(void *data)
 	return 0;
 }
 
-static void skb_defer_free_flush(struct softnet_data *sd)
+static void skb_defer_free_flush(struct softnet_data *sd, bool napi_safe)
 {
 	struct sk_buff *skb, *next;
+	unsigned long flags;
 
 	/* Paired with WRITE_ONCE() in skb_attempt_defer_free() */
 	if (!READ_ONCE(sd->defer_list))
 		return;
 
-	spin_lock_irq(&sd->defer_lock);
+	if (napi_safe)
+		spin_lock_irq(&sd->defer_lock);
+	else
+		spin_lock_irqsave(&sd->defer_lock, flags);
+
 	skb = sd->defer_list;
 	sd->defer_list = NULL;
 	sd->defer_count = 0;
-	spin_unlock_irq(&sd->defer_lock);
+
+	if (napi_safe)
+		spin_unlock_irq(&sd->defer_lock);
+	else
+		spin_unlock_irqrestore(&sd->defer_lock, flags);
 
 	while (skb != NULL) {
 		next = skb->next;
-		napi_consume_skb(skb, 1);
+		napi_consume_skb(skb, napi_safe);
 		skb = next;
 	}
 }
@@ -6662,7 +6678,7 @@ static __latent_entropy void net_rx_action(struct softirq_action *h)
 	for (;;) {
 		struct napi_struct *n;
 
-		skb_defer_free_flush(sd);
+		skb_defer_free_flush(sd, true);
 
 		if (list_empty(&list)) {
 			if (list_empty(&repoll)) {


