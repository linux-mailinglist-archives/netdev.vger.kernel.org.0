Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 504B42B2F8F
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 19:21:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgKNSU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 13:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgKNSUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 13:20:24 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C263FC0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 10:20:22 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id z2so11426589ilh.11
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 10:20:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9XsF4YnrL1fCg1nVpbLuSpPZByDdOIuOUok90OTewKQ=;
        b=V2Ed7Phwa84huYB0Bk4VP0nIxfnmsd1r51ji2HH1REPRc3ytHG2b8icwyTAfGIaWms
         MoDFhhEFJ1ORSLEL+TTSLuUG+a/xAdk36quIOiK7a3jJqsU4amfzwTyLF5FZj6teDvnG
         JoI+es3GcCyTp/JmIsi2u5QrO0AaZeS6MNTgLGJP5JYjUhZ0PvbBgyC5kIXwgySXZpal
         7QTuHul4Rs22YbSELzePEMzLvCrte5UKwkI8P0dvOxnQ7aT2hL0C2abyLASj0/lg8bJt
         mTIOdCcntVcwF7++qdD66qha7MuZDcsYsjhci5v5UT/jBqRO/227dhIO8xgB+M0ynHYw
         lypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9XsF4YnrL1fCg1nVpbLuSpPZByDdOIuOUok90OTewKQ=;
        b=Az07CvGF9aHLEAZfKmjDBbC9b4F9My52R8+R+akW6w3RMNSSfRnjY6zS5AKxJtDUjp
         anJl39SxsGTXyvK/HkCkYbym1fjDf/38bv1ila7j93yJZlJzqzNu62IuNKnPd8KW2kYO
         /7yXWl9yk3HmeWmCezsEG5DAgBoiWioTWqWaMlNBCjbExPhs0+Q/V7BBy0fHvFelkyBU
         YCaZK+bc65b/00TnOsAj3oBaI2s5uOAz6l/GIEG2SQpdd3PC/cB/tFM56IcV6lK2oXwv
         +6+2a6Zn7wc2oQLIg/dRM0sKJ/QjBMsCbvMmlQkCvsFdErAYaD/ja0yBI8XZjrC+H6Eq
         KoFw==
X-Gm-Message-State: AOAM531fqPUIlDjNLI0a3bMrB7wDBxkk6JzGTgWnanHa+brDSzM110Ma
        VfN6reqZV0TxdvEyUSRIv/ceZA==
X-Google-Smtp-Source: ABdhPJx+jIFI8dxjhjnqyZw4e+qofknbijIx+sxBJ1rbpcXB/ZGIC23rFIkd21ZOnY2T6w820MGJqg==
X-Received: by 2002:a92:2c06:: with SMTP id t6mr3728618ile.125.1605378021915;
        Sat, 14 Nov 2020 10:20:21 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id n10sm6504653iom.36.2020.11.14.10.20.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 10:20:21 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <swboyd@chromium.org>
Subject: [PATCH net] net: ipa: lock when freeing transaction
Date:   Sat, 14 Nov 2020 12:20:17 -0600
Message-Id: <20201114182017.28270-1-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transactions sit on one of several lists, depending on their state
(allocated, pending, complete, or polled).  A spinlock protects
against concurrent access when transactions are moved between these
lists.

Transactions are also reference counted.  A newly-allocated
transaction has an initial count of 1; a transaction is released in
gsi_trans_free() only if its decremented reference count reaches 0.
Releasing a transaction includes removing it from the polled (or if
unused, allocated) list, so the spinlock is acquired when we release
a transaction.

The reference count is used to allow a caller to synchronously wait
for a committed transaction to complete.  In this case, the waiter
takes an extra reference to the transaction *before* committing it
(so it won't be freed), and releases its reference (calls
gsi_trans_free()) when it is done with it.

Similarly, gsi_channel_update() takes an extra reference to ensure a
transaction isn't released before the function is done operating on
it.  Until the transaction is moved to the completed list (by this
function) it won't be freed, so this reference is taken "safely."

But in the quiesce path, we want to wait for the "last" transaction,
which we find in the completed or polled list.  Transactions on
these lists can be freed at any time, so we (try to) prevent that
by taking the reference while holding the spinlock.

Currently gsi_trans_free() decrements a transaction's reference
count unconditionally, acquiring the lock to remove the transaction
from its list *only* when the count reaches 0.  This does not
protect the quiesce path, which depends on the lock to ensure its
extra reference prevents release of the transaction.

Fix this by only dropping the last reference to a transaction
in gsi_trans_free() while holding the spinlock.

Fixes: 9dd441e4ed575 ("soc: qcom: ipa: GSI transactions")
Reported-by: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi_trans.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 92642030e7356..e8599bb948c08 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -362,22 +362,31 @@ struct gsi_trans *gsi_channel_trans_alloc(struct gsi *gsi, u32 channel_id,
 	return trans;
 }
 
-/* Free a previously-allocated transaction (used only in case of error) */
+/* Free a previously-allocated transaction */
 void gsi_trans_free(struct gsi_trans *trans)
 {
+	refcount_t *refcount = &trans->refcount;
 	struct gsi_trans_info *trans_info;
+	bool last;
 
-	if (!refcount_dec_and_test(&trans->refcount))
+	/* We must hold the lock to release the last reference */
+	if (refcount_dec_not_one(refcount))
 		return;
 
 	trans_info = &trans->gsi->channel[trans->channel_id].trans_info;
 
 	spin_lock_bh(&trans_info->spinlock);
 
-	list_del(&trans->links);
+	/* Reference might have been added before we got the lock */
+	last = refcount_dec_and_test(refcount);
+	if (last)
+		list_del(&trans->links);
 
 	spin_unlock_bh(&trans_info->spinlock);
 
+	if (!last)
+		return;
+
 	ipa_gsi_trans_release(trans);
 
 	/* Releasing the reserved TREs implicitly frees the sgl[] and
-- 
2.20.1

