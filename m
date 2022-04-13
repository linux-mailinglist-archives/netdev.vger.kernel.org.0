Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5ECD24FF33A
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbiDMJUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:20:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbiDMJUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:20:22 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27C251E75;
        Wed, 13 Apr 2022 02:17:45 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id w7so1438807pfu.11;
        Wed, 13 Apr 2022 02:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=tz5dWuELBA/iPFeCUwqUqTCIDdY/keZQPX5lNBv6mfg=;
        b=S15LxfsjJ7VtU+jLif+PoGVD12PMyIA4UE53je4fmZBYj6DmqNi/RJiIYQ1CvZOBeb
         H/whVGvDBOkquSrZWL69NZD7wk9kzBjjy0+ULHaWUhOD0ga2o+4peMsyFZFk1vuSR62W
         MDpgNp0wXqAO3V3RrJb8FBS7vCC7qOZce4c3ZujXAFASrcHZ9Pgro5C9sRUMa7dW8NB/
         cSoB/eXMKR0vV/PlxJRf1LDhe2t4PVVHQy8kok/UXtZh35W4D59H0EqasViZNvxyRK2t
         2qdE7zIwsY3sbS1nFm3ewjewGDpMkSoJblS/ZS3upWM36h3IKIlIux+cMyUe0F6ahagm
         MVew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=tz5dWuELBA/iPFeCUwqUqTCIDdY/keZQPX5lNBv6mfg=;
        b=RZkjukrU2GJNOtPENR8gu1iJMSO5uX+wPm5wPHl+2URT/5669a+5t3mxSPQhsOnAgB
         mzr0FeDGoZn448jmQJ37MwIKOFckZxHJdhFgsLdeooyuJvcIWhEp4glpQEu+e+iI08tF
         NVBOeH5UcBGrp8CEBk/a/KjGeC3xZeL8NXz+fMIRtE8q7b+/HRJ7dti14hh6IuL9rKgY
         4fm6v1dXyPrMdvzyBcVB78t23gug9n2r54IrovIztv2ScBtnOwaVn3xm09SJ8Uajteiv
         xRUPwGIh8dstmCSv9retDhrxPPjT7aD5xDAvu2Bv76Wc1NiEyC1i4SeAJyy4l+Val5L/
         JUkA==
X-Gm-Message-State: AOAM533YsMyXqlrriLVf+b7N5ArVve7/F8M460tNXabIBlw+Ham7wX1l
        RtAobkNcd7gH/BoT1T3cR/DLiFXCkAmvgw==
X-Google-Smtp-Source: ABdhPJwJWC+oe4G9+3nv/Ooabuax/OuMo+x+Scpy5Khtg0OBD7X0uysKsgX7llq0gccOfhHz0K/WGA==
X-Received: by 2002:a05:6a00:17a6:b0:505:a751:8354 with SMTP id s38-20020a056a0017a600b00505a7518354mr19101372pfg.82.1649841465196;
        Wed, 13 Apr 2022 02:17:45 -0700 (PDT)
Received: from localhost.localdomain ([119.3.119.18])
        by smtp.gmail.com with ESMTPSA id n19-20020a635c53000000b0039dc2ea9876sm834512pgm.49.2022.04.13.02.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 02:17:44 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     pizza@shaftnet.org, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, linville@tuxdriver.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH v3] cw1200: fix incorrect check to determine if no element is found in list
Date:   Wed, 13 Apr 2022 17:17:23 +0800
Message-Id: <20220413091723.17596-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bug is here: "} else if (item) {".

The list iterator value will *always* be set and non-NULL by
list_for_each_entry(), so it is incorrect to assume that the iterator
value will be NULL if the list is empty or no element is found in list.

Use a new value 'iter' as the list iterator, while use the old value
'item' as a dedicated pointer to point to the found element, which
1. can fix this bug, due to now 'item' is NULL only if it's not found.
2. do not need to change all the uses of 'item' after the loop.
3. can also limit the scope of the list iterator 'iter' *only inside*
   the traversal loop by simply declaring 'iter' inside the loop in the
   future, as usage of the iterator outside of the list_for_each_entry
   is considered harmful. https://lkml.org/lkml/2022/2/17/1032

Fixes: a910e4a94f692 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
---
changes since v2:
 - rebase on latest wireless-next (Kalle Valo)
changes since v1:
 - fix incorrect check to item (Jakob Koschel)

v2: https://lore.kernel.org/lkml/20220320035436.11293-1-xiam0nd.tong@gmail.com/
v1: https://lore.kernel.org/all/20220319063800.28791-1-xiam0nd.tong@gmail.com/
---
 drivers/net/wireless/st/cw1200/queue.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/queue.c b/drivers/net/wireless/st/cw1200/queue.c
index e06da4b3b0d4..805a3c1bf8fe 100644
--- a/drivers/net/wireless/st/cw1200/queue.c
+++ b/drivers/net/wireless/st/cw1200/queue.c
@@ -91,23 +91,25 @@ static void __cw1200_queue_gc(struct cw1200_queue *queue,
 			      bool unlock)
 {
 	struct cw1200_queue_stats *stats = queue->stats;
-	struct cw1200_queue_item *item = NULL, *tmp;
+	struct cw1200_queue_item *item = NULL, *iter, *tmp;
 	bool wakeup_stats = false;
 
-	list_for_each_entry_safe(item, tmp, &queue->queue, head) {
-		if (time_is_after_jiffies(item->queue_timestamp + queue->ttl))
+	list_for_each_entry_safe(iter, tmp, &queue->queue, head) {
+		if (time_is_after_jiffies(iter->queue_timestamp + queue->ttl)) {
+			item = iter;
 			break;
+		}
 		--queue->num_queued;
-		--queue->link_map_cache[item->txpriv.link_id];
+		--queue->link_map_cache[iter->txpriv.link_id];
 		spin_lock_bh(&stats->lock);
 		--stats->num_queued;
-		if (!--stats->link_map_cache[item->txpriv.link_id])
+		if (!--stats->link_map_cache[iter->txpriv.link_id])
 			wakeup_stats = true;
 		spin_unlock_bh(&stats->lock);
 		cw1200_debug_tx_ttl(stats->priv);
-		cw1200_queue_register_post_gc(head, item);
-		item->skb = NULL;
-		list_move_tail(&item->head, &queue->free_pool);
+		cw1200_queue_register_post_gc(head, iter);
+		iter->skb = NULL;
+		list_move_tail(&iter->head, &queue->free_pool);
 	}
 
 	if (wakeup_stats)
-- 
2.17.1

