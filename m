Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2802E2A325C
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 18:55:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgKBRyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 12:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726439AbgKBRyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 12:54:12 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05EB0C061A47
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 09:54:12 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id r12so6778744iot.4
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 09:54:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TY8f/hJb7UErE9l1O52/R43lnZDyIHDAaaf9Om5UBk0=;
        b=odoQ12IQQQ86bEKXbuj2rNLJXk/yR8omYiCjtdscZKttTWH47NAApFjVvrBknz8fIa
         SsFStRd7Z1ulg4BRGqoYtOUnx8KM27tt3NtoGcpfgu1EKrloowlef8auU1sQF/eSdGTr
         GvRJd4F9xuCYkBu6g5AUvgsGuUPXRTYxuBKSC3y7B2WPeCO3Am6/1SQlUMX5mYvFOxL8
         quFGtYeDts06wUsw+XJfQ7N/gBQM9RDYzPv+TDvoG81GKadIIULLqCScJjE1H98Fhp9G
         DJ/E1L+67n3QpsmrZCh3ttIpBthkGysSSCP9U8Y6uWjQtvfqqZw1wRF6xgJYTsPkUhxu
         PF/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TY8f/hJb7UErE9l1O52/R43lnZDyIHDAaaf9Om5UBk0=;
        b=kPQ8uQFwcSfVr2s+fgINNJ6+CQGRGoo88wdMXwtGUSGmMuvIUwOSLCmC6Ndqpab7Jw
         dVeZOqIFLN43b61kYL0g0aNI/3rQutVuB8MUdgO/WQtGvq/Cl6zs3558GySUn8mJ/plE
         yXT2718WYvJ/lkfOB/9T/S2MB+7kbX2EjwlLSl/GyXllQqSJTRgyza/YRQq0WaSYMxOl
         N9mioEUDDR5rhVxKpWSp8gPA/kQ144yOsBAVpbjzdLDQ0nuSGweB2LDg/lAt78RcUJZz
         s/JJD7VPNAK89ICQth7CR0+wO/WXkhEFaYHi7TksTg6juZ/Zsm+VSv1YR7Qw2T4zR5Ok
         7hug==
X-Gm-Message-State: AOAM531gihBJBUk08ba5RuGVdSj3VqGsrldo12hCRwzXc7Xi08bsPStD
        /qPsQQVH2qykV6rx0t3irH0KUg==
X-Google-Smtp-Source: ABdhPJy1FuCPH779RMcdRimZdawwLdFGf4366Hm9dd0i36HcZfm6/3n/xeUg3b2LMNZXi5PfV3btVw==
X-Received: by 2002:a05:6602:2407:: with SMTP id s7mr11099495ioa.79.1604339651325;
        Mon, 02 Nov 2020 09:54:11 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r4sm11089591ilj.43.2020.11.02.09.54.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 09:54:10 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 5/6] net: ipa: use version in gsi_channel_program()
Date:   Mon,  2 Nov 2020 11:53:59 -0600
Message-Id: <20201102175400.6282-6-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201102175400.6282-1-elder@linaro.org>
References: <20201102175400.6282-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the IPA version in gsi_channel_program() to determine whether
we should enable the GSI doorbell engine when requested.  This way,
callers only say whether or not it should be enabled if needed,
regardless of hardware version.

Rename the "legacy" argument to gsi_channel_reset(), and have
it indicate whether the doorbell engine should be enabled when
reprogramming following the reset.

Change all callers of gsi_channel_reset() to indicate whether to
enable the doorbell engine after reset, independent of hardware
version.

Rework a little logic in ipa_endpoint_reset() to get rid of the
"legacy" variable previously passed to gsi_channel_reset().

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c          | 10 +++++-----
 drivers/net/ipa/gsi.h          |  8 ++++----
 drivers/net/ipa/ipa_endpoint.c | 16 ++++++----------
 3 files changed, 15 insertions(+), 19 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 729ef712a10fd..f22b5d2efaf9d 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -743,8 +743,8 @@ static void gsi_channel_program(struct gsi_channel *channel, bool doorbell)
 
 	/* Max prefetch is 1 segment (do not set MAX_PREFETCH_FMASK) */
 
-	/* Enable the doorbell engine if requested */
-	if (doorbell)
+	/* We enable the doorbell engine for IPA v3.5.1 */
+	if (gsi->version == IPA_VERSION_3_5_1 && doorbell)
 		val |= USE_DB_ENG_FMASK;
 
 	/* Starting with IPA v4.0 the command channel uses the escape buffer */
@@ -831,8 +831,8 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id)
 	return ret;
 }
 
-/* Reset and reconfigure a channel (possibly leaving doorbell disabled) */
-void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool legacy)
+/* Reset and reconfigure a channel, (possibly) enabling the doorbell engine */
+void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 
@@ -843,7 +843,7 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool legacy)
 	if (gsi->version == IPA_VERSION_3_5_1 && !channel->toward_ipa)
 		gsi_channel_reset_command(channel);
 
-	gsi_channel_program(channel, legacy);
+	gsi_channel_program(channel, doorbell);
 	gsi_channel_trans_cancel_pending(channel);
 
 	mutex_unlock(&gsi->mutex);
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index cf117b52496c1..36f876fb8f5ae 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -221,15 +221,15 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id);
  * gsi_channel_reset() - Reset an allocated GSI channel
  * @gsi:	GSI pointer
  * @channel_id:	Channel to be reset
- * @legacy:	Legacy behavior
+ * @doorbell:	Whether to (possibly) enable the doorbell engine
  *
- * Reset a channel and reconfigure it.  The @legacy flag indicates
- * that some steps should be done differently for legacy hardware.
+ * Reset a channel and reconfigure it.  The @doorbell flag indicates
+ * that the doorbell engine should be enabled if needed.
  *
  * GSI hardware relinquishes ownership of all pending receive buffer
  * transactions and they will complete with their cancelled flag set.
  */
-void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool legacy);
+void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell);
 
 int gsi_channel_suspend(struct gsi *gsi, u32 channel_id, bool stop);
 int gsi_channel_resume(struct gsi *gsi, u32 channel_id, bool start);
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 6f79028910e3c..548121b1531b7 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1217,7 +1217,6 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 	struct gsi *gsi = &ipa->gsi;
 	bool suspended = false;
 	dma_addr_t addr;
-	bool legacy;
 	u32 retries;
 	u32 len = 1;
 	void *virt;
@@ -1279,8 +1278,7 @@ static int ipa_endpoint_reset_rx_aggr(struct ipa_endpoint *endpoint)
 	 * complete the channel reset sequence.  Finish by suspending the
 	 * channel again (if necessary).
 	 */
-	legacy = ipa->version == IPA_VERSION_3_5_1;
-	gsi_channel_reset(gsi, endpoint->channel_id, legacy);
+	gsi_channel_reset(gsi, endpoint->channel_id, true);
 
 	msleep(1);
 
@@ -1303,21 +1301,19 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 	u32 channel_id = endpoint->channel_id;
 	struct ipa *ipa = endpoint->ipa;
 	bool special;
-	bool legacy;
 	int ret = 0;
 
 	/* On IPA v3.5.1, if an RX endpoint is reset while aggregation
 	 * is active, we need to handle things specially to recover.
 	 * All other cases just need to reset the underlying GSI channel.
-	 *
-	 * IPA v3.5.1 enables the doorbell engine.  Newer versions do not.
 	 */
-	legacy = ipa->version == IPA_VERSION_3_5_1;
-	special = !endpoint->toward_ipa && endpoint->data->aggregation;
-	if (legacy && special && ipa_endpoint_aggr_active(endpoint))
+	special = ipa->version == IPA_VERSION_3_5_1 &&
+			!endpoint->toward_ipa &&
+			endpoint->data->aggregation;
+	if (special && ipa_endpoint_aggr_active(endpoint))
 		ret = ipa_endpoint_reset_rx_aggr(endpoint);
 	else
-		gsi_channel_reset(&ipa->gsi, channel_id, legacy);
+		gsi_channel_reset(&ipa->gsi, channel_id, true);
 
 	if (ret)
 		dev_err(&ipa->pdev->dev,
-- 
2.20.1

