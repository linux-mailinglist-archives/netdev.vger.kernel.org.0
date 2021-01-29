Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56E92308E70
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233210AbhA2UYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbhA2UW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:22:27 -0500
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5894AC061352
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:32 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id n2so10641770iom.7
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ElDz97SBJk86D1CLyyXPt5PTHHmYPT5bhsYpZ6Pd9RU=;
        b=G43Dmqbcif+yph9EzWLQByK13wZEhDmXd5y88G+31juZ8A0nLAIG3uKDaAi8nbOgqq
         PPINUPrkY0nPzc4tYOGrNGRhEuZWn+s2juH3I86KGseiCs2PJRF8qE6lrAAoiP7QLaV4
         h+cix/NzrT4RYoAbyPeUN/Z1zzXByzqcBj1JtWbe/4GAIJGaCScjHlT1oCLff7XhMaRC
         gE4tXyA8T2dgJ7ycFWlZXnWQ03Nfla4HmDD5NU9dw6Cg7Bic+Hro1ZGA73zjdxig8lCU
         E9vmAbEKWzkGdT1HdTVn3Hn02iDCvn+n3OxcDsfUK+ONWHVhlUhCffDDLTKdkSdo352b
         hMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ElDz97SBJk86D1CLyyXPt5PTHHmYPT5bhsYpZ6Pd9RU=;
        b=Clv1o865jksCohk/3nql5D0S7NFtOwUoUBk4iWDBK2SD4gMMwLOg3eU2P1EQS/I2jy
         PJHwHomh75gk80v3Z7Tmt32673WRCZN0G2EhZQmNRPN8YSvCORIrSnXq9qPaAUkG4PVB
         KdsFWTmJuBVITXFiSf3ndovQPqdwsuGD5aX8m21gr4kr+Q9ho/hwTC8PCgNsqnnHOJUA
         6l6iXpq3JP84YkEO4BbkQsOREdhdbeeBjc3xWkAsLgJKZZh3Cw7aWlJOFwKR65+5p5VY
         6lnBsvvc5Wpdv7vC9lZv4rZj/v16Q/S0cMuRwu7rHcub14oc2EHMSPiDDGdLmSCvVNgy
         sYNw==
X-Gm-Message-State: AOAM533qJnSx1blszZDBmJ6OpbEOsDiR4IdJ5o+MGMHoFblGv1BFxmIA
        F1dKzolrc6jkwTZ0hJLyI0P3yA==
X-Google-Smtp-Source: ABdhPJzzJTXyqYe8AQpHf69zhEIoJ3a0seHvTq03ID/GYjcmE8lPX7JOQeShN9Ao2Qpv1PrUl9a/MA==
X-Received: by 2002:a6b:5915:: with SMTP id n21mr5464846iob.20.1611951631841;
        Fri, 29 Jan 2021 12:20:31 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h23sm4645738ila.15.2021.01.29.12.20.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 12:20:31 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 8/9] net: ipa: expand last transaction check
Date:   Fri, 29 Jan 2021 14:20:18 -0600
Message-Id: <20210129202019.2099259-9-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210129202019.2099259-1-elder@linaro.org>
References: <20210129202019.2099259-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Transactions to send data for a network device can be allocated at
any time up until the point the TX queue is stopped.  It is possible
for ipa_start_xmit() to be called in one context just before a
the transmit queue is stopped in another.

Update gsi_channel_trans_last() so that for TX channels the
allocated and pending transaction lists are checked--in addition
to the completed and polled lists--to determine the "last"
transaction.  This means any transaction that has been allocated
before the TX queue is stopped will be allowed to complete before
we conclude the channel is quiesced.

Rework the function a bit to use a list pointer and gotos.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 34 +++++++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 74d1dd04ad6e9..217ca21bfe043 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -725,22 +725,38 @@ static void gsi_evt_ring_program(struct gsi *gsi, u32 evt_ring_id)
 	gsi_evt_ring_doorbell(gsi, evt_ring_id, 0);
 }
 
-/* Return the last (most recent) transaction completed on a channel. */
+/* Find the transaction whose completion indicates a channel is quiesced */
 static struct gsi_trans *gsi_channel_trans_last(struct gsi_channel *channel)
 {
 	struct gsi_trans_info *trans_info = &channel->trans_info;
+	const struct list_head *list;
 	struct gsi_trans *trans;
 
 	spin_lock_bh(&trans_info->spinlock);
 
-	if (!list_empty(&trans_info->complete))
-		trans = list_last_entry(&trans_info->complete,
-					struct gsi_trans, links);
-	else if (!list_empty(&trans_info->polled))
-		trans = list_last_entry(&trans_info->polled,
-					struct gsi_trans, links);
-	else
-		trans = NULL;
+	/* There is a small chance a TX transaction got allocated just
+	 * before we disabled transmits, so check for that.
+	 */
+	if (channel->toward_ipa) {
+		list = &trans_info->alloc;
+		if (!list_empty(list))
+			goto done;
+		list = &trans_info->pending;
+		if (!list_empty(list))
+			goto done;
+	}
+
+	/* Otherwise (TX or RX) we want to wait for anything that
+	 * has completed, or has been polled but not released yet.
+	 */
+	list = &trans_info->complete;
+	if (!list_empty(list))
+		goto done;
+	list = &trans_info->polled;
+	if (list_empty(list))
+		list = NULL;
+done:
+	trans = list ? list_last_entry(list, struct gsi_trans, links) : NULL;
 
 	/* Caller will wait for this, so take a reference */
 	if (trans)
-- 
2.27.0

