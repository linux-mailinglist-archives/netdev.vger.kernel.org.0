Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5535AF275
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 19:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiIFR2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 13:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234611AbiIFR2D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 13:28:03 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77D9520BE6
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 10:19:48 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id g1so3761127iob.13
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 10:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=SsJOWqNx8N+KalhLrOerr5OsTlnBZPakmw9e8MRgY0g=;
        b=vx/kh62Ife6c+24oArxDVg8MLRZ+fIlND7Px2yBWCn0y49bs13cZky6OvL66p1RuuF
         IdI+D6I/5ejj8lLBgUg/O+COgCc3PUHkQUFdOiqb3ho831UEUwb4jrbIo7Ok9FLpY6iG
         Db7BtivIRzxYAsSvYvHqion/mU5HThu1+ELuq6zeT2ULCLnEexWMYK2cP2+XVXy6pQKT
         BKgKR47VTpA3LAEwxKpR2vjzD00DdyKnDbJpgeNkDwlJbtFGe0x1qwmSPpZi65WauS7p
         f/R/frSx33ZvT5B6KxNB1QL3vzGViwwuSvDN6oMxxTSkS5vtkHnZVlPGwAVVejX3Yl83
         j45A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=SsJOWqNx8N+KalhLrOerr5OsTlnBZPakmw9e8MRgY0g=;
        b=wtnBIXJzreFn2UmpLjBTK0aHVmiOogzL0OlCvjklnfjuQDogTWhymr4qwa//WG7T+f
         L8YGFgraA15PfGzKnv7OIl6Wp3qTNWRVSi5yYQ/7IU9tZQr4GCowHFJbRZhnBb4x4eb0
         jQRkk7yTiPCvc6MmSMFhC7WMuDEWaW1RhrwJWrR7xqmRQS8VgYUHiiQk5uRLzZ3CHcE0
         z3BQBODlFQPFlt1UTrHH8xAC7rC8i0ZZxj2J1bY7UoOoEqBZ51yj4bdAwSZM0ifLXoj6
         sG7hELaJLtx9oNjHG865ly59FC7iqcAE2PmMFkXl/wSi5yeFjdazXLy1zu3/G2I9a3l7
         4oMw==
X-Gm-Message-State: ACgBeo1AiSr+LEjHOf9EQdVgrbbQD2yJPVesee79Y9/Y34BlyTGuew92
        NRWBWa4z3pAnSW7bSwo23qHd5Q==
X-Google-Smtp-Source: AA6agR5Ls+KS2KaQXrYHynxqMo7Jc06iL1OoIgqwOs+7lEPkYc9ibsgoqmXwY9Bl7WvR42wfIgZnRw==
X-Received: by 2002:a05:6638:3e90:b0:34c:f1b5:d600 with SMTP id ch16-20020a0566383e9000b0034cf1b5d600mr13635084jab.166.1662484787455;
        Tue, 06 Sep 2022 10:19:47 -0700 (PDT)
Received: from presto.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id q10-20020a056e020c2a00b002eb3f5fc4easm5292204ilg.27.2022.09.06.10.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 10:19:46 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: ipa: always use transaction IDs instead of lists
Date:   Tue,  6 Sep 2022 12:19:38 -0500
Message-Id: <20220906171942.957704-2-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220906171942.957704-1-elder@linaro.org>
References: <20220906171942.957704-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In gsi_channel_trans_complete(), use the completed and pending IDs
to determine whether there are any transactions in completed state.

Similarly, in gsi_channel_trans_cancel_pending(), use the pending
and committed IDs to mark pending transactions cancelled.  Rearrange
the logic a bit there for a simpler result.

This removes the only user of list_last_entry_or_null(), so get rid
of that macro.

Remove the temporary warnings added by the previous commit.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_private.h | 14 ---------
 drivers/net/ipa/gsi_trans.c   | 58 ++++++++++-------------------------
 2 files changed, 16 insertions(+), 56 deletions(-)

diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index 51bbc7a40dc2d..0b2516fa21b5d 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -16,20 +16,6 @@ struct gsi_channel;
 
 #define GSI_RING_ELEMENT_SIZE	16	/* bytes; must be a power of 2 */
 
-/**
- * list_last_entry_or_null - get the last element from a list
- * @ptr:	the list head to take the element from.
- * @type:	the type of the struct this is embedded in.
- * @member:	the name of the list_head within the struct.
- *
- * Note that if the list is empty, it returns NULL.
- */
-#define list_last_entry_or_null(ptr, type, member) ({ \
-	struct list_head *head__ = (ptr); \
-	struct list_head *pos__ = READ_ONCE(head__->prev); \
-	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
-})
-
 /**
  * gsi_trans_move_complete() - Mark a GSI transaction completed
  * @trans:	Transaction to commit
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 05ab4d052c68b..a131a4fbb53fc 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -239,22 +239,11 @@ struct gsi_trans *gsi_channel_trans_complete(struct gsi_channel *channel)
 {
 	struct gsi_trans_info *trans_info = &channel->trans_info;
 	u16 trans_id = trans_info->completed_id;
-	struct gsi_trans *trans;
 
-	trans = list_first_entry_or_null(&trans_info->complete,
-					 struct gsi_trans, links);
-
-	if (!trans) {
-		WARN_ON(trans_id != trans_info->pending_id);
+	if (trans_id == trans_info->pending_id)
 		return NULL;
-	}
 
-	if (!WARN_ON(trans_id == trans_info->pending_id)) {
-		trans_id %= channel->tre_count;
-		WARN_ON(trans != &trans_info->trans[trans_id]);
-	}
-
-	return trans;
+	return &trans_info->trans[trans_id %= channel->tre_count];
 }
 
 /* Move a transaction from the allocated list to the committed list */
@@ -705,47 +694,32 @@ void gsi_trans_complete(struct gsi_trans *trans)
 void gsi_channel_trans_cancel_pending(struct gsi_channel *channel)
 {
 	struct gsi_trans_info *trans_info = &channel->trans_info;
-	struct gsi_trans *trans;
-	struct gsi_trans *first;
-	struct gsi_trans *last;
-	bool cancelled;
+	u16 trans_id = trans_info->pending_id;
 
 	/* channel->gsi->mutex is held by caller */
 	spin_lock_bh(&trans_info->spinlock);
 
-	cancelled = !list_empty(&trans_info->pending);
-	list_for_each_entry(trans, &trans_info->pending, links)
-		trans->cancelled = true;
-
 	list_splice_tail_init(&trans_info->pending, &trans_info->complete);
 
-	first = list_first_entry_or_null(&trans_info->complete,
-					 struct gsi_trans, links);
-	last = list_last_entry_or_null(&trans_info->complete,
-				       struct gsi_trans, links);
-
 	spin_unlock_bh(&trans_info->spinlock);
 
+	/* If there are no pending transactions, we're done */
+	if (trans_id == trans_info->committed_id)
+		return;
+
+	/* Mark all pending transactions cancelled */
+	do {
+		struct gsi_trans *trans;
+
+		trans = &trans_info->trans[trans_id % channel->tre_count];
+		trans->cancelled = true;
+	} while (++trans_id != trans_info->committed_id);
+
 	/* All pending transactions are now completed */
-	WARN_ON(cancelled != (trans_info->pending_id !=
-				trans_info->committed_id));
-
 	trans_info->pending_id = trans_info->committed_id;
 
 	/* Schedule NAPI polling to complete the cancelled transactions */
-	if (cancelled) {
-		u16 trans_id;
-
-		napi_schedule(&channel->napi);
-
-		trans_id = trans_info->completed_id;
-		trans = &trans_info->trans[trans_id % channel->tre_count];
-		WARN_ON(trans != first);
-
-		trans_id = trans_info->pending_id - 1;
-		trans = &trans_info->trans[trans_id % channel->tre_count];
-		WARN_ON(trans != last);
-	}
+	napi_schedule(&channel->napi);
 }
 
 /* Issue a command to read a single byte from a channel */
-- 
2.34.1

