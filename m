Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123BC1C4AA1
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 01:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgEDXxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 19:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgEDXxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 19:53:53 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71C6C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 16:53:52 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id t7so170057qvz.6
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 16:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=njpEHqJ2+bC0XHGj2Gh4SOikioCbruZmns91MTnO70c=;
        b=rq0x+5IDXCfi3TUfgjkNPS0lyyMoNJxroyBGpFEp0uuDKsjh73upRpIJXJU7d8CYIW
         PveqCmyT6Aap6tdsB8K1ja4FjM7MEMJgQ+M9vYhfyZ4z/1zI+7J6igQrSYRX8VKPQk1h
         iKw+gN9eTNy1EVI9MIOGvGxrVAzVGRg3tErAo7HtSG8qChG4GtTCyig9ijF9Q/3+8oxx
         vXazLQujHEpUk0aa4yA8PLoUu7t71ojy+eDCbycgOwHhYh5qjkpNxxGwxN1tSKqLG6fl
         dYQW3rQFQfRfPQzwgIQEkjeljCreNhlTkjI4Tw5dT1KdOcYFCCx5pxoxuPA2OqsyNKxA
         603A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=njpEHqJ2+bC0XHGj2Gh4SOikioCbruZmns91MTnO70c=;
        b=n7Xgm7Nnt4J5BR1A9Ty1CLMx0t5sKxZWs+wcRiY+OIm+GGM1oZdq5Ib3BqLcXGJRHW
         phrbpsA65JKkN5OI+nADMs61H+PUeX2E7dsGbbkjL7Y6EJXTCBV3OXnyyWUjqa6Y9rK7
         7t05IPB102D2AXPvi5Cdj3cp/RioBEQ5IjM+L05EHB1r6vVqBhBmngTkmv55vTwJg9zq
         vee+LTWEVSR56rkxAP4vejVPJiu5QERuLqstkwKDWn6L32hRGABSrLljEz5LwzEVXB50
         Z0hj67FizFuhn9tzc68wvQq7XQcwzRQarbA7BX16LsbfUTOR06wNqmeReyDOi6b/IPp3
         sH/A==
X-Gm-Message-State: AGi0PuYSVZvnDPZFoAOqiyMHc8TJV8rSFlunSn8beSQNa/BYGKIvdDLl
        5wHM2CubEDZV9Ki4Xu+L5miXYg==
X-Google-Smtp-Source: APiQypISe7QYS+Aaf3aiaaXANNXXtH/Gfb6cUIcrkZtDtfUMEZY9NrVMMT6X1/JOJ02CaZBNGcfNlA==
X-Received: by 2002:a05:6214:7a7:: with SMTP id v7mr135118qvz.27.1588636432088;
        Mon, 04 May 2020 16:53:52 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z18sm296004qti.47.2020.05.04.16.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 16:53:51 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: ipa: fix a bug in ipa_endpoint_stop()
Date:   Mon,  4 May 2020 18:53:41 -0500
Message-Id: <20200504235345.17118-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200504235345.17118-1-elder@linaro.org>
References: <20200504235345.17118-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In ipa_endpoint_stop(), for TX endpoints we set the number of retries
to 0.  When we break out of the loop, retries being 0 means we return
EIO rather than the value of ret (which should be 0).

Fix this by using a non-zero retry count for both RX and TX
channels, and just break out of the loop after calling
gsi_channel_stop() for TX channels.  This way only RX channels
will retry, and the retry count will be non-zero at the end
for TX channels (so the proper value gets returned).

Signed-off-by: Alex Elder <elder@linaro.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit 713b6ebb4c376b3fb65fdceb3b59e401c93248f9)
---

NOTE:  DO NOT MERGE (this has already been committed.)

 drivers/net/ipa/ipa_endpoint.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 6de03be28784..a21534f1462f 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1283,7 +1283,7 @@ static int ipa_endpoint_stop_rx_dma(struct ipa *ipa)
  */
 int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
 {
-	u32 retries = endpoint->toward_ipa ? 0 : IPA_ENDPOINT_STOP_RX_RETRIES;
+	u32 retries = IPA_ENDPOINT_STOP_RX_RETRIES;
 	int ret;
 
 	do {
@@ -1291,12 +1291,9 @@ int ipa_endpoint_stop(struct ipa_endpoint *endpoint)
 		struct gsi *gsi = &ipa->gsi;
 
 		ret = gsi_channel_stop(gsi, endpoint->channel_id);
-		if (ret != -EAGAIN)
+		if (ret != -EAGAIN || endpoint->toward_ipa)
 			break;
 
-		if (endpoint->toward_ipa)
-			continue;
-
 		/* For IPA v3.5.1, send a DMA read task and check again */
 		if (ipa->version == IPA_VERSION_3_5_1) {
 			ret = ipa_endpoint_stop_rx_dma(ipa);
-- 
2.20.1

