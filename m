Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7920A2FE94E
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 12:50:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730899AbhAULuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 06:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730853AbhAULt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 06:49:56 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8A1C061795
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:48:30 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id e22so3353815iog.6
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 03:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kygNnWwNHZcFAU/IIMmhkkxZa/aeNIwUlXt4TwJxOxI=;
        b=iBqbR3UUymSgU0tbCuyTM6KqEaC8KTyTxtL74a2ptRCBtg2p8l7KAc2emVSeiRVlzn
         Ol6xudYj6Xfx6Mvqe9L9bTv+hrhVwqFUvejUoPORXwkxlYxilNIh2evsIsme0A4y+pbH
         o2XXRpFMBcNA4vpBbue/O37Fu62mlx+gbtT7lXd6X0pn2Sz//LfS8O17tmJ4fDHBxlDC
         Ran//KgAXyokLzjX9TWG/swnrmFE21Bw+UR78g+nYXlLy8pJllBKM2bq+iU9Vz8JpR/a
         b+HL5//a/7Azc77jZv3t04WfD8wlb2UEiSNaZXhv/NuWCSiMwxv9Hgs/yBBYUnHN4su5
         +Bbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kygNnWwNHZcFAU/IIMmhkkxZa/aeNIwUlXt4TwJxOxI=;
        b=kTKX/BEmIbsU53j6WqeYMSekKz5UeKi94ZqUA0wmN/TnDTdoqy6h0Md/28oM7+pErv
         5zCK84nSY/p8aMj3Wh8cjdLcBSjr6iQSyNwMuOvMb+YqPgYdLWrNcsAqKYI01mAL0iKW
         NBMlGxPDGc+6FsIiUtFxdYfDpWoUoMm5KCyox2Y2HSWajeAI7YfsST6P9yafvAnXb9xT
         v2RznnMIM3qaZ2ThMsPreg/3JbVaHoYtTbZRoUl7pWPXrXODulbIiSWmmEJ9USw/sqc2
         9zMIHYsuMXCio0x8ICdgrgpjMSJ/AbNjV4lHrcyTSDhCdnu/IHcdZnrYDaG4uQ1KD/9f
         6myw==
X-Gm-Message-State: AOAM531wQXjxI9aMD7xE59/QNt7LwfxbiqiwldNUj8qPTqLJcG02fe6v
        qxtx0aUe3k3Mf7y5FbteKNq+IQ==
X-Google-Smtp-Source: ABdhPJxyMCFPpbWOZIEDq7tkNa//YBAk3BA6vKqH5lQhK9bxQp3v9W61kNtEP8l2HxV3DXSVtw7bwQ==
X-Received: by 2002:a05:6e02:1b88:: with SMTP id h8mr4380146ili.39.1611229710111;
        Thu, 21 Jan 2021 03:48:30 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id p5sm2762766ilm.80.2021.01.21.03.48.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 03:48:29 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 5/5] net: ipa: disable IEOB interrupts before clearing
Date:   Thu, 21 Jan 2021 05:48:21 -0600
Message-Id: <20210121114821.26495-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210121114821.26495-1-elder@linaro.org>
References: <20210121114821.26495-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently in gsi_isr_ieob(), event ring IEOB interrupts are disabled
one at a time.  The loop disables the IEOB interrupt for all event
rings represented in the event mask.  Instead, just disable them all
at once.

Disable them all *before* clearing the interrupt condition.  This
guarantees we'll schedule NAPI for each event once, before another
IEOB interrupt could be signaled.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 0391f5a207c9f..f79cf3c327c1c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1205,6 +1205,7 @@ static void gsi_isr_ieob(struct gsi *gsi)
 	u32 event_mask;
 
 	event_mask = ioread32(gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_OFFSET);
+	gsi_irq_ieob_disable(gsi, event_mask);
 	iowrite32(event_mask, gsi->virt + GSI_CNTXT_SRC_IEOB_IRQ_CLR_OFFSET);
 
 	while (event_mask) {
@@ -1212,7 +1213,6 @@ static void gsi_isr_ieob(struct gsi *gsi)
 
 		event_mask ^= BIT(evt_ring_id);
 
-		gsi_irq_ieob_disable_one(gsi, evt_ring_id);
 		napi_schedule(&gsi->evt_ring[evt_ring_id].channel->napi);
 	}
 }
-- 
2.20.1

