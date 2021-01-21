Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A5C2FE962
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730799AbhAULzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:55:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730849AbhAULt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 06:49:56 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB57C061786
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:48:28 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id e22so3368643iom.5
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lB7a5cRodpbpGb/+6TS9nogIS/hSgl+bcWuo7lSLV6I=;
        b=TZOGTIjV+H03KgIz69zU7KTj3IXoyXgRRTOVe++ketr0sARbl8xJe3yneNmzr+VKT0
         RIATGg9tYV+y3+3o3LOe8XVizpY+jv0GiDTmUXZdxIamIVlEXzv38Ro4OJhjiWXv8x2C
         FQ2k9I/gWte1WsL0an9l5lqIyXoNmIL6dsvGVJRlQBOV4haNZaNH50K+aG8sopmtgpLo
         8nhEsgjC/mlb1XNunkblS/8d8nOGVakFsDnPDXVgqMjOxKmOsFs9izi1wVdAVvJVJhGb
         NLHv/vT81WPx2tby6Yx0bAXj32YDzGrDkQAwbibIC4hwGAr1TP93/GQqK+ftbTng7bIl
         K81g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lB7a5cRodpbpGb/+6TS9nogIS/hSgl+bcWuo7lSLV6I=;
        b=SX3KoFzlP4d871HOYGgL+6MAXc1PLzD45ye1RRFySTS8x7O85fiHw9PjQoS7Suj/Dj
         f0bykhKS5GLeMU4M9tVr/C2R7C7qc/2yZZOANycI21LKoufGr4d37h0GK1Q1KbpT84OV
         uqrmN/sGfT1XpbuIeblMnPCGNR+RSkGr7CwtEPmjBZ4ses7Cw5Vq0TulTC+o6NS3+BD0
         ut/9PbBBhDWfMDZqnYpLMH7SpTb9bcdJ6hb8LTAvXcQ2K2ag4lwNT/DlM4bATMusWkk+
         5A8M7L8s3Mxe6lonzsPM7tl4OYnFleNrGMb9Lzt6ERKmkvunQpSdypOFHivgWVV4YL/X
         FxTg==
X-Gm-Message-State: AOAM531IJxOf2k+5PnAKf9NQJYafNFyJM7RyiKWDtU9cb61xl0ZVLzre
        c6Lm8/4bjvqszKN9EkycjnsKeScWexHOZw==
X-Google-Smtp-Source: ABdhPJwJvvZ2kxflrv8hBAliZCP7BjHsin3er74h5nRggXVLFMEB55yoXJEQNV+sWNGW9vmN6FtrmA==
X-Received: by 2002:a92:cccd:: with SMTP id u13mr11747369ilq.273.1611229707990;
        Thu, 21 Jan 2021 03:48:27 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p5sm2762766ilm.80.2021.01.21.03.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 03:48:27 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/5] net: ipa: have gsi_channel_update() return a value
Date:   Thu, 21 Jan 2021 05:48:19 -0600
Message-Id: <20210121114821.26495-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210121114821.26495-1-elder@linaro.org>
References: <20210121114821.26495-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Have gsi_channel_update() return the first transaction in the
updated completed transaction list, or NULL if no new transactions
have been added.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Do not drop the static keyword that limits the function scope.

 drivers/net/ipa/gsi.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 634f514e861e7..6e5817e16c0f6 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1452,7 +1452,7 @@ void gsi_channel_doorbell(struct gsi_channel *channel)
 }
 
 /* Consult hardware, move any newly completed transactions to completed list */
-static void gsi_channel_update(struct gsi_channel *channel)
+static struct gsi_trans *gsi_channel_update(struct gsi_channel *channel)
 {
 	u32 evt_ring_id = channel->evt_ring_id;
 	struct gsi *gsi = channel->gsi;
@@ -1471,7 +1471,7 @@ static void gsi_channel_update(struct gsi_channel *channel)
 	offset = GSI_EV_CH_E_CNTXT_4_OFFSET(evt_ring_id);
 	index = gsi_ring_index(ring, ioread32(gsi->virt + offset));
 	if (index == ring->index % ring->count)
-		return;
+		return NULL;
 
 	/* Get the transaction for the latest completed event.  Take a
 	 * reference to keep it from completing before we give the events
@@ -1496,6 +1496,8 @@ static void gsi_channel_update(struct gsi_channel *channel)
 	gsi_evt_ring_doorbell(channel->gsi, channel->evt_ring_id, index);
 
 	gsi_trans_free(trans);
+
+	return gsi_channel_trans_complete(channel);
 }
 
 /**
@@ -1516,11 +1518,8 @@ static struct gsi_trans *gsi_channel_poll_one(struct gsi_channel *channel)
 
 	/* Get the first transaction from the completed list */
 	trans = gsi_channel_trans_complete(channel);
-	if (!trans) {
-		/* List is empty; see if there's more to do */
-		gsi_channel_update(channel);
-		trans = gsi_channel_trans_complete(channel);
-	}
+	if (!trans)	/* List is empty; see if there's more to do */
+		trans = gsi_channel_update(channel);
 
 	if (trans)
 		gsi_trans_move_polled(trans);
-- 
2.20.1

