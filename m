Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E2DE30ADF7
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 18:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhBAReT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 12:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbhBARaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 12:30:21 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F938C0617A9
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 09:29:04 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id e7so16346713ile.7
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 09:29:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j/UQjfNJ3JWNq4bb7HzoAqoUGHmX5hqgPKQzmM+bjDk=;
        b=VyxQ5araa1L6Gf/nGTnvtNEb6ocPkU/Y50wsclb0mJSkeK1qMaoRhOHqM0A+Nhl+Bl
         zEmwH1xLfa657LIb5PDviN0SIvKBbiUm7rtUEomovKoXHN4X09i/fEp2YK9a32j7vsnG
         n2vOZaDlhuc5ewGN9dRXJ2aNR6jcq0dnkGnnVUCdPXlC2bRWy4dUvQBlTOD9XRVHD3zK
         DUhCrdA3Y+YIkseLTfU8gjBXlINJKmc6PMSSn8zePJTjBpPux7D3L3tZCBVBUpPCGEhR
         ngmLONTuuo/tcFpa7iOlTWsWmRfGvWvIUsrJ+yZRR+3jOcFmYKfasvu87touskpJC+Jw
         tMhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j/UQjfNJ3JWNq4bb7HzoAqoUGHmX5hqgPKQzmM+bjDk=;
        b=nW3ZVDjANspMuFoIicZsp/Z77ZUCG2Tc5i73k8Jr5Cjav7n9JpwsnCf3V5Ptq5sgHh
         HrRu0WhGyq/Skp7fSGQiv9PZioHtIooRebqnKSxNF9ovoEAgia8Jj/c0CodMZ0Iytrv5
         tHI17IobSxbTXA5bhq8i2akb85gpK2YLTjNtnML74DFBCaUhs2LX8HcenzTVAGVf3p9a
         yXR55DacTvNWou93UiVdGMxO4/1xSwo6eekHHNg25/0Q8x7mfywfJQuNwOYoG59rGusC
         r0BAc6KyX6otOdV1m0dUtilTtJnNQy0tYWrVlM3iNqX2gfPtYG9B5VrQ5D9fqcA8gGdb
         G15A==
X-Gm-Message-State: AOAM530acXGWqj19E+5LTbfwG7FE3BApgy5A9Fv6qknF8diXROzx6m4H
        ODGIR/PiYwyvuLszGC0KeXgDag==
X-Google-Smtp-Source: ABdhPJzcfV4LzvkxTVWq5m0CEvBaBwNSEk5coXC14ha+VjgZoJem/21Mcbw/+GCIYOeUZWGVzf+qFQ==
X-Received: by 2002:a05:6e02:1d09:: with SMTP id i9mr13862591ila.207.1612200543565;
        Mon, 01 Feb 2021 09:29:03 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id v2sm9529856ilj.19.2021.02.01.09.29.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 09:29:02 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     willemdebruijn.kernel@gmail.com, elder@kernel.org,
        evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 7/7] net: ipa: expand last transaction check
Date:   Mon,  1 Feb 2021 11:28:50 -0600
Message-Id: <20210201172850.2221624-8-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210201172850.2221624-1-elder@linaro.org>
References: <20210201172850.2221624-1-elder@linaro.org>
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
index 03498182ad024..8b64cbe4737a4 100644
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

