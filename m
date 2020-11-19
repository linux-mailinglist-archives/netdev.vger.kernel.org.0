Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA80F2B9DD3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgKSWtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbgKSWtk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:49:40 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68AE6C0613D4
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:49:39 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id m13so7910360ioq.9
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:49:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cKq81cpi43e09d93bbygzldKS5y1EkrmCoJ1FsxEfQo=;
        b=uBhMmRmo4RYRxrjlkdy61T7i1J5tzRRK6MtjXiAvpQbZPTTp4HrWS4phIkHV4JFH0k
         q2/LHKK9icUfZk/DUMC++tQ4RDqnY30drTe/kLF9ncuHeIPar4jGVN0r3j+C6n7lhCz3
         nHWip5SAogVuJseM3kp2nEs21VUEdeXp3ETBj9tQQIVddTv/LFb+7qMP0X2kcuP1XGrp
         ppXovVP9YpfOswvm7AprzMnCX1fL1HDHqcqUqeaQnp0udUEBx0/sujuCb20ur/Kh3HxC
         2A1/4QDhqcIpX+vdCIZ4PaTq9xa5wfM++N5ghWIrxlSVGBsK1oJTJg4JS22GmFYXSc0l
         GnLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cKq81cpi43e09d93bbygzldKS5y1EkrmCoJ1FsxEfQo=;
        b=J7LIWtMrml7wzX1wfQd7Q1bFqGM7IdVOvHqjaFeETHQDriapeAnN44DDQBiEfs3+rE
         Pu5/DRUnKu+QQkd6mNQ9vMl8By6qe1EY/GDF5FtRmtm8LNHUksgSjZ/VD+cVkfUPamJQ
         Z/F8o9SVTQXmb8VacAaTC29Y+3G2OLMAzL8NOiQ7ZOAVw1ULrtLBaajPd69V8AInRsWQ
         LO1Rzpn8X7IAgqLMKcBed30GjY183Ml7Wi6MMT/CB8FJuESrtHV+gHNBRnzZ3FfOqVGM
         SonaboRXOmv1iozVSxlGWeci53+SASFiR2otrEy5aCvfd67MG+/MvE0ntj/BVv85etkP
         GHYw==
X-Gm-Message-State: AOAM53391SVdYDAsirTRVJyRfC3v/LQiah8MSz/YHqgYaouPm+lzGHHg
        v+kPEx8oW5wG8jc/y/KA2fXg+zQLjUzp/g==
X-Google-Smtp-Source: ABdhPJyjZlp/Tfg3ZMP9wUIXXk9YhGoOQ/YvJgOKgf3JwNJxWwrBU44DBwf/3gQoMy3LHB3R6dlc7Q==
X-Received: by 2002:a05:6638:10ea:: with SMTP id g10mr16945527jae.9.1605826178487;
        Thu, 19 Nov 2020 14:49:38 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i3sm446532iom.8.2020.11.19.14.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 14:49:37 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/6] net: ipa: support retries on generic GSI commands
Date:   Thu, 19 Nov 2020 16:49:27 -0600
Message-Id: <20201119224929.23819-5-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201119224929.23819-1-elder@linaro.org>
References: <20201119224929.23819-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When stopping an AP RX channel, there can be a transient period
while the channel enters STOP_IN_PROC state before reaching the
final STOPPED state.  In that case we make another attempt to stop
the channel.

Similarly, when stopping a modem channel (using a GSI generic
command issued from the AP), it's possible that multiple attempts
will be required before the channel reaches STOPPED state.

Add a field to the GSI structure to record an errno representing the
result code provided when a generic command completes.  If the
result learned in gsi_isr_gp_int1() is RETRY, record -EAGAIN in the
result code, otherwise record 0 for success, or -EIO for any other
result.

If we time out nf gsi_generic_command() waiting for the command to
complete, return -ETIMEDOUT (as before).  Otherwise return the
result stashed by gsi_isr_gp_int1().

Add a loop in gsi_modem_channel_halt() to reissue the HALT command
if the result code indicates -EAGAIN.  Limit this to 10 retries
(after the initial attempt).

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c | 21 +++++++++++++++++++--
 drivers/net/ipa/gsi.h |  1 +
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 7c2e820625590..eb4c5d408a835 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -92,6 +92,7 @@
 #define GSI_CMD_TIMEOUT			5	/* seconds */
 
 #define GSI_CHANNEL_STOP_RX_RETRIES	10
+#define GSI_CHANNEL_MODEM_HALT_RETRIES	10
 
 #define GSI_MHI_EVENT_ID_START		10	/* 1st reserved event id */
 #define GSI_MHI_EVENT_ID_END		16	/* Last reserved event id */
@@ -1107,10 +1108,16 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 	switch (result) {
 	case GENERIC_EE_SUCCESS:
 	case GENERIC_EE_CHANNEL_NOT_RUNNING:
+		gsi->result = 0;
+		break;
+
+	case GENERIC_EE_RETRY:
+		gsi->result = -EAGAIN;
 		break;
 
 	default:
 		dev_err(gsi->dev, "global INT1 generic result %u\n", result);
+		gsi->result = -EIO;
 		break;
 	}
 
@@ -1624,7 +1631,7 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	iowrite32(BIT(ERROR_INT), gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
 
 	if (success)
-		return 0;
+		return gsi->result;
 
 	dev_err(gsi->dev, "GSI generic command %u to channel %u timed out\n",
 		opcode, channel_id);
@@ -1640,7 +1647,17 @@ static int gsi_modem_channel_alloc(struct gsi *gsi, u32 channel_id)
 
 static void gsi_modem_channel_halt(struct gsi *gsi, u32 channel_id)
 {
-	(void)gsi_generic_command(gsi, channel_id, GSI_GENERIC_HALT_CHANNEL);
+	u32 retries = GSI_CHANNEL_MODEM_HALT_RETRIES;
+	int ret;
+
+	do
+		ret = gsi_generic_command(gsi, channel_id,
+					  GSI_GENERIC_HALT_CHANNEL);
+	while (ret == -EAGAIN && retries--);
+
+	if (ret)
+		dev_err(gsi->dev, "error %d halting modem channel %u\n",
+			ret, channel_id);
 }
 
 /* Setup function for channels */
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index ecc784e3a8127..96c9aed397aad 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -161,6 +161,7 @@ struct gsi {
 	u32 type_enabled_bitmap;	/* GSI IRQ types enabled */
 	u32 ieob_enabled_bitmap;	/* IEOB IRQ enabled (event rings) */
 	struct completion completion;	/* for global EE commands */
+	int result;			/* Negative errno (generic commands) */
 	struct mutex mutex;		/* protects commands, programming */
 };
 
-- 
2.20.1

