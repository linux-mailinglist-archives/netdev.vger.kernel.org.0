Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF30308E78
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbhA2U0J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:26:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233204AbhA2UVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:21:25 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF9E7C061788
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:25 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id h11so10606187ioh.11
        for <netdev@vger.kernel.org>; Fri, 29 Jan 2021 12:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LCw8t3dNLb85N9LUx0CmQJolraUZfpfFkvo2+8sOa0o=;
        b=g2i4IwJ+Kj8enui+8IT7o5h9xAiJjUactPE+pJmvcAY7VNWDwx/jQ2ubO5SGGU2Rmd
         l/fDq7rjrUXlJyU35nRapnL0exdNhPeD6v2WiVNScBZUf9o+F5VCCW5VmPvZxHxcIDB4
         IQf65oz5qpCDZKu2dUBvfr0T6Iacjk8Qp2jsqgVvyhQmKPg0zbYXkX6x4eYq6KufgK4o
         Z8/67LJISEBEiSL5Nlsc0g5Vk88Mk68BVTxcz3CEz22Zr+b2OWuWJqmxL72b8UQxRuWf
         O4qcac3ZSCyWk9PtrVnpx3kgSev0bZe+Gn+e0G+MlAfhzJ8gle1AHSB3LBTB5NtD8jly
         aCbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LCw8t3dNLb85N9LUx0CmQJolraUZfpfFkvo2+8sOa0o=;
        b=XAEiZPpL5xvSUm06lwYJtSGpemwEv4lXXOxigI0Xp9AxlJJuU+bSSnvwQnHed1j6WM
         DhwF28fTISOwLqiMxBEHSjcr6IA2J1N2LJRIpEbZEr3KTP/gBJMPSjtdjECBbupMTLg/
         W8cS9I6A93xhUT1oDJMC4lbFJ/N9ipoRZGRokj8IoVokWha5i4yi3g8EP00K5oO8lDwt
         xxBe1yCH3C/di1aClLScSNxx9M55iOKwbv1NzazsDQtvCNF4HRjiM7b9MaNa+ah4hFWO
         001KdctrHNCwsK7MPC4pnw5HZnwlu9+oXBHGm6eQSKVL1nUQ1XzARXhZHvd/Cv0lYEvK
         2w4w==
X-Gm-Message-State: AOAM5304dOnWYF0H+wMbiRZKkAlTL7oCV6yFw52INL218HGoaZW/RPw6
        1xpvG67Kmw4g2+ye5MwLfGE5rA==
X-Google-Smtp-Source: ABdhPJwEPu3+q3wOtNmhi0OavTcDqf0tLsgVDEnMvJryLK9+j9CtD/JnDfWM6yR+o11zak3wx4cYNQ==
X-Received: by 2002:a05:6602:4b:: with SMTP id z11mr4864766ioz.47.1611951625315;
        Fri, 29 Jan 2021 12:20:25 -0800 (PST)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h23sm4645738ila.15.2021.01.29.12.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Jan 2021 12:20:24 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/9] net: ipa: introduce gsi_channel_stop_retry()
Date:   Fri, 29 Jan 2021 14:20:12 -0600
Message-Id: <20210129202019.2099259-3-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210129202019.2099259-1-elder@linaro.org>
References: <20210129202019.2099259-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Create a new helper function that encapsulates issuing a set of
channel stop commands, retrying if appropriate, with a short delay
between attempts.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 4a3e125e898f6..bd1bf388d9892 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -892,15 +892,12 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id)
 	return ret;
 }
 
-/* Stop a started channel */
-int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
+static int gsi_channel_stop_retry(struct gsi_channel *channel)
 {
-	struct gsi_channel *channel = &gsi->channel[channel_id];
 	u32 retries = GSI_CHANNEL_STOP_RETRIES;
+	struct gsi *gsi = channel->gsi;
 	int ret;
 
-	gsi_channel_freeze(channel);
-
 	mutex_lock(&gsi->mutex);
 
 	do {
@@ -912,6 +909,19 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 
 	mutex_unlock(&gsi->mutex);
 
+	return ret;
+}
+
+/* Stop a started channel */
+int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
+{
+	struct gsi_channel *channel = &gsi->channel[channel_id];
+	int ret;
+
+	gsi_channel_freeze(channel);
+
+	ret = gsi_channel_stop_retry(channel);
+
 	/* Re-thaw the channel if an error occurred while stopping */
 	if (ret)
 		gsi_channel_thaw(channel);
-- 
2.27.0

