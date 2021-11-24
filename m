Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0C3245CD76
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 20:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhKXTre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 14:47:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235200AbhKXTrd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 14:47:33 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7A2C061746
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 11:44:23 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id p23so4685991iod.7
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 11:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=r/sq+osswXVFeooo9nOfGZuqrilTERPbfSJVItpOsc8=;
        b=ZAwprTOp0FJmJtOESrlWSqdjW2DMJt0L+ZvBTbVhnC4TNq/z4gkPGH8uHuKkgpTxrs
         +brCsDwDDwcI7KWBtc+EpzpHYujIrBtdb1YQePRAJ6uSKF0xq0WdMso9EGS4ZCkvxyYu
         2EipvOx+5CBc4hSJuOMCVyeMm/UZK5zvWsYDItYG7zmX9a9SdElypNVaWQvHVLqczql9
         QBBMH5qhk+5SbXjusyRJNaO7/fCrthE9TJywDuhmV919vyXnONnDnWHMkTYaTn5A27PK
         DQRSRXiVbp+1TX5H5znPSFBM/KKxERcsSC1WSlVxaJyJwwg7u+tV+6HgV3oqIxNx/DD6
         u8rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=r/sq+osswXVFeooo9nOfGZuqrilTERPbfSJVItpOsc8=;
        b=eGOjoWv++WzPElll61seybSTA6GhgQfaSxCUm4n8tfdZqM3DMWKi3oQ715k010DhGk
         RlSV+WNGmhpinlFHv46R85NPX3TUqV1QmDwGoSsjHO2nB1F6iCn+F4whxnzBhjys+DNf
         aHaya5Plwt2UQ6R5U6aZSLcX/xrME8irW2qkD5LjBh7n4DhfKbLZxPSqUJB7IqokEfWj
         /ie4PqRXjIf54GeB6QNN0/QKvvyXY81xlMi1wzFv2qXx2NMPwPqP76j/Gr/ruSfeRGMi
         jtwb7HKp7ejAX6JPzErfmGS36/sKIIhmiIhbsoz2DYQNh1K3hcIeT/Xl5PTmP897vhZM
         zrCg==
X-Gm-Message-State: AOAM531n+tNs6muGPwyvP0OFOlwQ0LNwoV5bxsqRj/MneOhbT4ecN3OV
        pVFLxWVa01y82y2xIV3VyMW46Q==
X-Google-Smtp-Source: ABdhPJwkd/DZevG8n91IJeK/VAmWkoyvdVdeJQS54FEgMeaUE75nbpKTsIv7qIP2YoI5+pOH4UxoZA==
X-Received: by 2002:a05:6638:f83:: with SMTP id h3mr19660272jal.102.1637783062341;
        Wed, 24 Nov 2021 11:44:22 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r14sm490145iov.14.2021.11.24.11.44.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 11:44:21 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: ipa: introduce channel flow control
Date:   Wed, 24 Nov 2021 13:44:15 -0600
Message-Id: <20211124194416.707007-2-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124194416.707007-1-elder@linaro.org>
References: <20211124194416.707007-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One quirk for certain versions of IPA is that endpoint DELAY mode
does not work properly.  IPA DELAY mode prevents any packets from
being delivered to the IPA core for processing on a TX endpoint.
The AP uses DELAY mode when the modem crashes, to prevent modem TX
endpoints from generating traffic during crash recovery.  Without
this, there is a chance the hardware will stall during recovery from
a modem crash.

To achieve a similar effect, a GSI FLOW_CONTROLLED channel state
was created.  A STARTED TX channel can be placed in FLOW_CONTROLLED
state, which prevents the transfer of any more packets.  A channel
in FLOW_CONTROLLED state can be either returned to STARTED state, or
can be transitioned to STOPPED state.

Because this operates on GSI channels, two generic commands were
added to allow the AP to control this state for modem channels
(similar to the ALLOCATE and HALT channel commands).

Previously the code assumed this quirk only applied to IPA v4.2.
In fact, channel flow control (rather than endpoint DELAY mode)
should be used for all versions *starting* with IPA v4.2.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c          | 52 ++++++++++++++++++++++++++--------
 drivers/net/ipa/gsi.h          | 10 +++++++
 drivers/net/ipa/gsi_reg.h      |  2 ++
 drivers/net/ipa/ipa_endpoint.c | 50 +++++++++++++++++++-------------
 4 files changed, 82 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index a2fcdb1abdb96..5f9e9fb501e7f 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1171,18 +1171,23 @@ static void gsi_isr_gp_int1(struct gsi *gsi)
 	u32 result;
 	u32 val;
 
-	/* This interrupt is used to handle completions of the two GENERIC
-	 * GSI commands.  We use these to allocate and halt channels on
-	 * the modem's behalf due to a hardware quirk on IPA v4.2.  Once
-	 * allocated, the modem "owns" these channels, and as a result we
-	 * have no way of knowing the channel's state at any given time.
+	/* This interrupt is used to handle completions of GENERIC GSI
+	 * commands.  We use these to allocate and halt channels on the
+	 * modem's behalf due to a hardware quirk on IPA v4.2.  The modem
+	 * "owns" channels even when the AP allocates them, and have no
+	 * way of knowing whether a modem channel's state has been changed.
+	 *
+	 * We also use GENERIC commands to enable/disable channel flow
+	 * control for IPA v4.2+.
 	 *
 	 * It is recommended that we halt the modem channels we allocated
 	 * when shutting down, but it's possible the channel isn't running
 	 * at the time we issue the HALT command.  We'll get an error in
 	 * that case, but it's harmless (the channel is already halted).
+	 * Similarly, we could get an error back when updating flow control
+	 * on a channel because it's not in the proper state.
 	 *
-	 * For this reason, we silently ignore a CHANNEL_NOT_RUNNING error
+	 * In either case, we silently ignore a CHANNEL_NOT_RUNNING error
 	 * if we receive it.
 	 */
 	val = ioread32(gsi->virt + GSI_CNTXT_SCRATCH_0_OFFSET);
@@ -1648,6 +1653,10 @@ static void gsi_channel_teardown_one(struct gsi *gsi, u32 channel_id)
 	gsi_evt_ring_de_alloc_command(gsi, evt_ring_id);
 }
 
+/* We use generic commands only to operate on modem channels.  We don't have
+ * the ability to determine channel state for a modem channel, so we simply
+ * issue the command and wait for it to complete.
+ */
 static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 			       enum gsi_generic_cmd_opcode opcode)
 {
@@ -1655,12 +1664,14 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	bool timeout;
 	u32 val;
 
-	/* The error global interrupt type is always enabled (until we
-	 * teardown), so we won't change that.  A generic EE command
-	 * completes with a GSI global interrupt of type GP_INT1.  We
-	 * only perform one generic command at a time (to allocate or
-	 * halt a modem channel) and only from this function.  So we
-	 * enable the GP_INT1 IRQ type here while we're expecting it.
+	/* The error global interrupt type is always enabled (until we tear
+	 * down), so we will keep it enabled.
+	 *
+	 * A generic EE command completes with a GSI global interrupt of
+	 * type GP_INT1.  We only perform one generic command at a time
+	 * (to allocate, halt, or enable/disable flow control on a modem
+	 * channel), and only from this function.  So we enable the GP_INT1
+	 * IRQ type here, and disable it again after the command completes.
 	 */
 	val = BIT(ERROR_INT) | BIT(GP_INT1);
 	iowrite32(val, gsi->virt + GSI_CNTXT_GLOB_IRQ_EN_OFFSET);
@@ -1710,6 +1721,23 @@ static void gsi_modem_channel_halt(struct gsi *gsi, u32 channel_id)
 			ret, channel_id);
 }
 
+/* Enable or disable flow control for a modem GSI TX channel (IPA v4.2+) */
+void
+gsi_modem_channel_flow_control(struct gsi *gsi, u32 channel_id, bool enable)
+{
+	u32 command;
+	int ret;
+
+	command = enable ? GSI_GENERIC_ENABLE_FLOW_CONTROL
+			 : GSI_GENERIC_DISABLE_FLOW_CONTROL;
+
+	ret = gsi_generic_command(gsi, channel_id, command);
+	if (ret)
+		dev_err(gsi->dev,
+			"error %d %sabling mode channel %u flow control\n",
+			ret, enable ? "en" : "dis", channel_id);
+}
+
 /* Setup function for channels */
 static int gsi_channel_setup(struct gsi *gsi)
 {
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 88b80dc3db79f..41b3ab14c5124 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -101,6 +101,7 @@ enum gsi_channel_state {
 	GSI_CHANNEL_STATE_STARTED		= 0x2,
 	GSI_CHANNEL_STATE_STOPPED		= 0x3,
 	GSI_CHANNEL_STATE_STOP_IN_PROC		= 0x4,
+	GSI_CHANNEL_STATE_FLOW_CONTROLLED	= 0x5,	/* IPA v4.2+ */
 	GSI_CHANNEL_STATE_ERROR			= 0xf,
 };
 
@@ -218,6 +219,15 @@ int gsi_channel_start(struct gsi *gsi, u32 channel_id);
  */
 int gsi_channel_stop(struct gsi *gsi, u32 channel_id);
 
+/**
+ * gsi_modem_channel_flow_control() - Set channel flow control state (IPA v4.2+)
+ * @gsi:	GSI pointer returned by gsi_setup()
+ * @channel_id:	Modem TX channel to control
+ * @enable:	Whether to enable flow control (i.e., prevent flow)
+ */
+void gsi_modem_channel_flow_control(struct gsi *gsi, u32 channel_id,
+				    bool enable);
+
 /**
  * gsi_channel_reset() - Reset an allocated GSI channel
  * @gsi:	GSI pointer
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index bf9593d9eaead..4ab23998b3485 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -318,6 +318,8 @@ enum gsi_evt_cmd_opcode {
 enum gsi_generic_cmd_opcode {
 	GSI_GENERIC_HALT_CHANNEL		= 0x1,
 	GSI_GENERIC_ALLOCATE_CHANNEL		= 0x2,
+	GSI_GENERIC_ENABLE_FLOW_CONTROL		= 0x3,	/* IPA v4.2+ */
+	GSI_GENERIC_DISABLE_FLOW_CONTROL	= 0x4,	/* IPA v4.2+ */
 };
 
 /* The next register is present for IPA v3.5.1 and above */
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index ef790fd0ab56a..d89347a88e50b 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -237,7 +237,8 @@ static struct gsi_trans *ipa_endpoint_trans_alloc(struct ipa_endpoint *endpoint,
 }
 
 /* suspend_delay represents suspend for RX, delay for TX endpoints.
- * Note that suspend is not supported starting with IPA v4.0.
+ * Note that suspend is not supported starting with IPA v4.0, and
+ * delay mode should not be used starting with IPA v4.2.
  */
 static bool
 ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
@@ -248,11 +249,8 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 	u32 mask;
 	u32 val;
 
-	/* Suspend is not supported for IPA v4.0+.  Delay doesn't work
-	 * correctly on IPA v4.2.
-	 */
 	if (endpoint->toward_ipa)
-		WARN_ON(ipa->version == IPA_VERSION_4_2);
+		WARN_ON(ipa->version >= IPA_VERSION_4_2);
 	else
 		WARN_ON(ipa->version >= IPA_VERSION_4_0);
 
@@ -270,15 +268,15 @@ ipa_endpoint_init_ctrl(struct ipa_endpoint *endpoint, bool suspend_delay)
 	return state;
 }
 
-/* We currently don't care what the previous state was for delay mode */
+/* We don't care what the previous state was for delay mode */
 static void
 ipa_endpoint_program_delay(struct ipa_endpoint *endpoint, bool enable)
 {
+	/* Delay mode should not be used for IPA v4.2+ */
+	WARN_ON(endpoint->ipa->version >= IPA_VERSION_4_2);
 	WARN_ON(!endpoint->toward_ipa);
 
-	/* Delay mode doesn't work properly for IPA v4.2 */
-	if (endpoint->ipa->version != IPA_VERSION_4_2)
-		(void)ipa_endpoint_init_ctrl(endpoint, enable);
+	(void)ipa_endpoint_init_ctrl(endpoint, enable);
 }
 
 static bool ipa_endpoint_aggr_active(struct ipa_endpoint *endpoint)
@@ -355,26 +353,29 @@ ipa_endpoint_program_suspend(struct ipa_endpoint *endpoint, bool enable)
 	return suspended;
 }
 
-/* Enable or disable delay or suspend mode on all modem endpoints */
+/* Put all modem RX endpoints into suspend mode, and stop transmission
+ * on all modem TX endpoints.  Prior to IPA v4.2, endpoint DELAY mode is
+ * used for TX endpoints; starting with IPA v4.2 we use GSI channel flow
+ * control instead.
+ */
 void ipa_endpoint_modem_pause_all(struct ipa *ipa, bool enable)
 {
 	u32 endpoint_id;
 
-	/* DELAY mode doesn't work correctly on IPA v4.2 */
-	if (ipa->version == IPA_VERSION_4_2)
-		return;
-
 	for (endpoint_id = 0; endpoint_id < IPA_ENDPOINT_MAX; endpoint_id++) {
 		struct ipa_endpoint *endpoint = &ipa->endpoint[endpoint_id];
 
 		if (endpoint->ee_id != GSI_EE_MODEM)
 			continue;
 
-		/* Set TX delay mode or RX suspend mode */
-		if (endpoint->toward_ipa)
+		if (!endpoint->toward_ipa)
+			(void)ipa_endpoint_program_suspend(endpoint, enable);
+		else if (ipa->version < IPA_VERSION_4_2)
 			ipa_endpoint_program_delay(endpoint, enable);
 		else
-			(void)ipa_endpoint_program_suspend(endpoint, enable);
+			gsi_modem_channel_flow_control(&ipa->gsi,
+						       endpoint->channel_id,
+						       enable);
 	}
 }
 
@@ -1519,10 +1520,19 @@ static void ipa_endpoint_reset(struct ipa_endpoint *endpoint)
 
 static void ipa_endpoint_program(struct ipa_endpoint *endpoint)
 {
-	if (endpoint->toward_ipa)
-		ipa_endpoint_program_delay(endpoint, false);
-	else
+	if (endpoint->toward_ipa) {
+		/* Newer versions of IPA use GSI channel flow control
+		 * instead of endpoint DELAY mode to prevent sending data.
+		 * Flow control is disabled for newly-allocated channels,
+		 * and we can assume flow control is not (ever) enabled
+		 * for AP TX channels.
+		 */
+		if (endpoint->ipa->version < IPA_VERSION_4_2)
+			ipa_endpoint_program_delay(endpoint, false);
+	} else {
+		/* Ensure suspend mode is off on all AP RX endpoints */
 		(void)ipa_endpoint_program_suspend(endpoint, false);
+	}
 	ipa_endpoint_init_cfg(endpoint);
 	ipa_endpoint_init_nat(endpoint);
 	ipa_endpoint_init_hdr(endpoint);
-- 
2.32.0

