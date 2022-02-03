Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83DE4A8966
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:10:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234690AbiBCRJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352549AbiBCRJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:09:44 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486AAC061755
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:09:40 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id e79so4011350iof.13
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mXk6/jklZ0AYGAuxmfmw3LNYpU5JINoBQKXGEs/0Dho=;
        b=EefgkxqQKQHG4WYyEScxAiis4foYHb61WzvZjo2f5v0DG/JRMQWY2zr68+cuogzJVf
         XEsaQs1Op9xOiOTzQugXWOcqNBWig8cY0shQQmpiz4tprv7COJERf6r4JBaN3myo11y6
         QKH2k77gLUeBKGmaodl6ZRgvkPxbGp0ekZiRjdwGILD2YNzFVbuQI0y7rzrW7ZjejH4y
         OTn9mRT7HlradYtEr9ArcsGuNkDD1RPrK/+/t6PbbBrKr4/OCRzX9xxcAPMqsD6qzt6j
         Nv/BUtntiLDNhzhe/XVTwz+8EGoH1jdrZEvzqwCkv3taEsRB0BvylUS3Pxt6/rKW4Lf9
         HhIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mXk6/jklZ0AYGAuxmfmw3LNYpU5JINoBQKXGEs/0Dho=;
        b=v2LSvVCps3oOgfgwpdMOZHg7sOOVgdvKfmjFH9r9lRWPZrVh8UMN4QPqOylMszgWXb
         1MVrXJ3H3XcjlPUGRI8xTKH5n/fXS/0SkG4w/VnZlvf548TbPLZ9tpJBnMP0tesw9j6O
         /nX+dU9DDl46/BqkJ/Yv0GD2V0ansqnzJIb4BUajdA3uMiv+C24qWjOKgQEzLobGVWjq
         THwt8+jVRiGwDSEWaOTxkrUwF8Mi0GnvfIYAtUr5d+glaOev6fOd1Geyltb14p3TLCwv
         xHZV+o+yQTWzhs4a+LyIm/zfYU1EeNBW6Q2uQdiGSf93OlBaeXopTFyDUDPNQVrF9omp
         SnMg==
X-Gm-Message-State: AOAM5333Cw1wtg84kT2bs/UCg3XqM2vXxcHtcA5asbRivS+50JwYDtxB
        bVJTeLsvo4F91980BFZbKRkBFA==
X-Google-Smtp-Source: ABdhPJxXK062Agk9lwAVE0WtsAmkZa/PY1YW9Q/CwQlOV+ymoLZp3RIzIk6m1kR1w3/YcJYuVxyLFQ==
X-Received: by 2002:a02:cc97:: with SMTP id s23mr12490030jap.31.1643908179655;
        Thu, 03 Feb 2022 09:09:39 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id m12sm21869671iow.54.2022.02.03.09.09.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 09:09:39 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, mka@chromium.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, avuyyuru@codeaurora.org,
        jponduru@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 05/10] net: ipa: allocate transaction in replenish loop
Date:   Thu,  3 Feb 2022 11:09:22 -0600
Message-Id: <20220203170927.770572-6-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220203170927.770572-1-elder@linaro.org>
References: <20220203170927.770572-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When replenishing, have ipa_endpoint_replenish() allocate a
transaction, and pass that to ipa_endpoint_replenish_one() to fill.
Then, if that produces no error, commit the transaction within the
replenish loop as well.  In this way we can distinguish between
transaction failures and buffer allocation/mapping failures.

Failure to allocate a transaction simply means the hardware already
has as many receive buffers as it can hold.  In that case we can
break out of the replenish loop because there's nothing more to do.

If we fail to allocate or map pages for the receive buffer, just
try again later.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_endpoint.c | 40 ++++++++++++++--------------------
 1 file changed, 16 insertions(+), 24 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 274cf1c30b593..f5367b902c27c 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1036,24 +1036,19 @@ static void ipa_endpoint_status(struct ipa_endpoint *endpoint)
 	iowrite32(val, ipa->reg_virt + offset);
 }
 
-static int
-ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint, bool doorbell)
+static int ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint,
+				      struct gsi_trans *trans)
 {
-	struct gsi_trans *trans;
 	struct page *page;
 	u32 buffer_size;
 	u32 offset;
 	u32 len;
 	int ret;
 
-	trans = ipa_endpoint_trans_alloc(endpoint, 1);
-	if (!trans)
-		return -ENOMEM;
-
 	buffer_size = endpoint->data->rx.buffer_size;
 	page = dev_alloc_pages(get_order(buffer_size));
 	if (!page)
-		goto err_trans_free;
+		return -ENOMEM;
 
 	/* Offset the buffer to make space for skb headroom */
 	offset = NET_SKB_PAD;
@@ -1061,19 +1056,11 @@ ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint, bool doorbell)
 
 	ret = gsi_trans_page_add(trans, page, len, offset);
 	if (ret)
-		goto err_free_pages;
-	trans->data = page;	/* transaction owns page now */
+		__free_pages(page, get_order(buffer_size));
+	else
+		trans->data = page;	/* transaction owns page now */
 
-	gsi_trans_commit(trans, doorbell);
-
-	return 0;
-
-err_free_pages:
-	__free_pages(page, get_order(buffer_size));
-err_trans_free:
-	gsi_trans_free(trans);
-
-	return -ENOMEM;
+	return ret;
 }
 
 /**
@@ -1089,6 +1076,7 @@ ipa_endpoint_replenish_one(struct ipa_endpoint *endpoint, bool doorbell)
  */
 static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint)
 {
+	struct gsi_trans *trans;
 	struct gsi *gsi;
 	u32 backlog;
 
@@ -1100,15 +1088,18 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint)
 		return;
 
 	while (atomic_dec_not_zero(&endpoint->replenish_backlog)) {
-		bool doorbell;
+		trans = ipa_endpoint_trans_alloc(endpoint, 1);
+		if (!trans)
+			break;
+
+		if (ipa_endpoint_replenish_one(endpoint, trans))
+			goto try_again_later;
 
 		if (++endpoint->replenish_ready == IPA_REPLENISH_BATCH)
 			endpoint->replenish_ready = 0;
 
 		/* Ring the doorbell if we've got a full batch */
-		doorbell = !endpoint->replenish_ready;
-		if (ipa_endpoint_replenish_one(endpoint, doorbell))
-			goto try_again_later;
+		gsi_trans_commit(trans, !endpoint->replenish_ready);
 	}
 
 	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
@@ -1116,6 +1107,7 @@ static void ipa_endpoint_replenish(struct ipa_endpoint *endpoint)
 	return;
 
 try_again_later:
+	gsi_trans_free(trans);
 	clear_bit(IPA_REPLENISH_ACTIVE, endpoint->replenish_flags);
 
 	/* The last one didn't succeed, so fix the backlog */
-- 
2.32.0

