Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFD3E2F50D8
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728123AbhAMRQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:16:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728082AbhAMRQx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 12:16:53 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8316C0617A5
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:40 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id u17so5692481iow.1
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l1IOSEu+vyCQsNm2sF39ZzPXY+5QREQKKoylCV6H1Jg=;
        b=r1J29VmGqzEuZBHBu8w8M6gaA/yEBauw84YklgDIGC8Me5dWwVlqJEmQ9g6mUeH0f7
         neiyLIkHJ+WYeG54zWirQgT48uRaz2Nk0O4otQnLjCUVFMl+XqOzCM0f5rMemd/LDAvB
         1aa0v+tDSVv/WAbxNf/JumsXXXmcf0uEzBvbQ5gVxK3A+nkdu0gV7DgjfvH6QhLoxY3X
         kvjf4geDG88wbhVr4Opf/6pCQWkjrsukt9Fk+RFNdycpjk9u7mr1WshMH5L8nBUAO1Fy
         7K/GUWOUKAnuhN/l8GkVXYPdjQ63V8f3Ge23VRzJJa1n43a+ehLUZy8uc8yn4+VA3boT
         3mgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l1IOSEu+vyCQsNm2sF39ZzPXY+5QREQKKoylCV6H1Jg=;
        b=eeQcHrhH469n/LRBp5Jc+aocTz23AETg3kJVDgs1DzSdH4bQJaIpdG0WE56uy7Bo+4
         gBYxRI5wkvPjMw59j99XlOrvVTd2IYdoMks8JPBC40ePfNm+KakqxxBNMZ5+CtyZBb2p
         viLlM20PIquFRQ3x9aqSRQDfn1scAFCSXMeI3Q8y0aaCEnPtKb3V/30r+Dpv0xy9LeFA
         WjHSk+EXItMtMofqqQZugKud9iLGwMgRl0c+lu9a++nKDVF1hGnRjy8Wssf/cXyY1K4B
         c9GkfnUzfiMBVok5IffBdDtX8Dx7zwwpMs9hvt/7IeEUmpHO89I9IjBjtUPddVe/LZ7I
         gpGg==
X-Gm-Message-State: AOAM530Z3Vw7NVzNxLr8zJHCkKGBmlehpbJmqVj86SYkLcM6OEDI9YRn
        VSbOzs/1I1WbMLg42F4Rzcyu4Q==
X-Google-Smtp-Source: ABdhPJxm7gYHJB7apQRYjR8zQpXumSWaySY7r83l6ly50Epp/7LV1S/UqlovAbe+zT5ENtBbO3eCZg==
X-Received: by 2002:a92:4906:: with SMTP id w6mr3225429ila.234.1610558140086;
        Wed, 13 Jan 2021 09:15:40 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id h9sm1120579ili.43.2021.01.13.09.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 09:15:39 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/6] net: ipa: use usleep_range()
Date:   Wed, 13 Jan 2021 11:15:29 -0600
Message-Id: <20210113171532.19248-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210113171532.19248-1-elder@linaro.org>
References: <20210113171532.19248-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The use of msleep() for small periods (less than 20 milliseconds) is
not recommended because the actual delay can be much different than
expected.

We use msleep(1) in several places in the IPA driver to insert short
delays.  Replace them with usleep_range calls, which should reliably
delay a period in the range requested.

Fixes: 650d1603825d8 ("soc: qcom: ipa: the generic software interface")
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c          | 5 +++--
 drivers/net/ipa/ipa_endpoint.c | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index e5681a39b5fc6..93b143ba92be5 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -611,7 +611,8 @@ static void gsi_channel_reset_command(struct gsi_channel *channel)
 	struct device *dev = channel->gsi->dev;
 	enum gsi_channel_state state;
 
-	msleep(1);	/* A short delay is required before a RESET command */
+	/* A short delay is required before a RESET command */
+	usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
 
 	state = gsi_channel_state(channel);
 	if (state != GSI_CHANNEL_STATE_STOPPED &&
@@ -900,7 +901,7 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 		ret = gsi_channel_stop_command(channel);
 		if (ret != -EAGAIN)
 			break;
-		msleep(1);
+		usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
 	} while (retries--);
 
 	mutex_unlock(&gsi->mutex);
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 9f4be9812a1f3..688a3dd40510a 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1378,7 +1378,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 	do {
 		if (!ipa_endpoint_aggr_active(endpoint))
 			break;
-		msleep(1);
+		usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
 	} while (retries--);
 
 	/* Check one last time */
@@ -1399,7 +1399,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 	 */
 	gsi_channel_reset(gsi, endpoint->channel_id, true);
 
-	msleep(1);
+	usleep_range(USEC_PER_MSEC, 2 * USEC_PER_MSEC);
 
 	goto out_suspend_again;
 
-- 
2.20.1

