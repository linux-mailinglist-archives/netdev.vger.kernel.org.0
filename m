Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 598854E1993
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 04:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244682AbiCTD4H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 23:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiCTD4G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 23:56:06 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1BF514B87D;
        Sat, 19 Mar 2022 20:54:44 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id o23so7979477pgk.13;
        Sat, 19 Mar 2022 20:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=imxsjvClszLiVFlSXeqAvOWndWBefHJ4UoHE31UCw34=;
        b=f04iMKP1ycIlKTDUthtjZ2ga4WOhbsgyISVcqFlss4PfutkAoYRRaiXWFZ30XMDwDc
         T9z4n9yIAvDgClsYyBCM86sexcCYDf2mx3QqQhjiUJDng/+VU4iV9AwNRpEMCuFhWjSd
         SmniDtPR93aHeWRJmIodfrIKnKMSa6qtcrmwymzmZ3psVBiHQFI8ZvHQcMX/lXHYCxT7
         KIHhVmuVEE95Gzk82Jo93IZpDk1+3IPQCAuJwK/73YjhXs9L9jO6YRiHXOo3y2RmGWKU
         m9O93kNprA3cvRx74+jl+zkpORMBWl7A861maiUFSKdaowcDX/BcEWTooJ64TDa+E7gP
         9JWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=imxsjvClszLiVFlSXeqAvOWndWBefHJ4UoHE31UCw34=;
        b=JsNBKxLzKR3z5XDwl6N7uK/95w/uk4cvdmlthQvm98fdz19VVSfoxaKR2kAi5bQ+Gn
         HgDBw6VIUMszvLWCC1fh3gTxIZKtxDQvX573eHUDmR+Y6aPdNfWGELFiSY6ErIOXSr53
         yS9dAObGq9ea7wpYnjdKYArr6xgI1MX8EZ4EkBoji9tXKN1jxiwNYucqqJbl+GWsdNiH
         7GADF8nFj8I+fyXkcY/whZlFo5Jy1T1TQoHPDosVtBPBN1HEvsqDDVitu05sUtpeKoc3
         g/t72JvmwtuFUWUJLKs+74oiTx4uuRN2UHxvywxHsKoSa2/Te34HnBoIBWhkT7Klcbmc
         hi1Q==
X-Gm-Message-State: AOAM532T2F/osS+KApNPIAtNYzubfX9wWqaEC0BmC3yizsazL2eY1rLf
        ARzdsvRJEN+WDtuL577asR0=
X-Google-Smtp-Source: ABdhPJx9pEgM+E9i8eZPfuiCaOXD2jZ8mquslGNKq13EOY8EZHidUQqOueJRZwKSHt0tK0FfMC6zDw==
X-Received: by 2002:a05:6a00:179f:b0:4f7:8ed9:ebae with SMTP id s31-20020a056a00179f00b004f78ed9ebaemr17453768pfg.28.1647748484170;
        Sat, 19 Mar 2022 20:54:44 -0700 (PDT)
Received: from localhost.localdomain ([36.24.165.243])
        by smtp.googlemail.com with ESMTPSA id p10-20020a056a0026ca00b004f7d9dac802sm14308492pfw.114.2022.03.19.20.54.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Mar 2022 20:54:43 -0700 (PDT)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     pizza@shaftnet.org
Cc:     kvalo@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linville@tuxdriver.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jakobkoschel@gmail.com,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: [PATCH v2] cw1200: fix incorrect check to determine if no element is found in list
Date:   Sun, 20 Mar 2022 11:54:36 +0800
Message-Id: <20220320035436.11293-1-xiam0nd.tong@gmail.com>
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
changes since v1:
 - fix incorrect check to item (Jakob Koschel)

v1: https://lore.kernel.org/all/20220319063800.28791-1-xiam0nd.tong@gmail.com/
---
 drivers/net/wireless/st/cw1200/queue.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/st/cw1200/queue.c b/drivers/net/wireless/st/cw1200/queue.c
index 12952b1c29df..d8dd4fac4ef1 100644
--- a/drivers/net/wireless/st/cw1200/queue.c
+++ b/drivers/net/wireless/st/cw1200/queue.c
@@ -90,23 +90,25 @@ static void __cw1200_queue_gc(struct cw1200_queue *queue,
 			      bool unlock)
 {
 	struct cw1200_queue_stats *stats = queue->stats;
-	struct cw1200_queue_item *item = NULL, *tmp;
+	struct cw1200_queue_item *item = NULL, *iter, *tmp;
 	bool wakeup_stats = false;
 
-	list_for_each_entry_safe(item, tmp, &queue->queue, head) {
-		if (jiffies - item->queue_timestamp < queue->ttl)
+	list_for_each_entry_safe(iter, tmp, &queue->queue, head) {
+		if (jiffies - iter->queue_timestamp < queue->ttl) {
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

