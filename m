Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1BD45CD78
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 20:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235920AbhKXTrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 14:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbhKXTre (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Nov 2021 14:47:34 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88FD6C061746
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 11:44:24 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id z18so4690269iof.5
        for <netdev@vger.kernel.org>; Wed, 24 Nov 2021 11:44:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9+1wmLMR32a4owb7dmiLLzwYsR7GITdvUE8vjTvuilE=;
        b=W9Wsncv65+Y3CmoeAbhZYtPAmBFUAnhs9JZy2aq+yOyfzrBfTfBGYf89XsdwCV4Fdc
         TM0XqH+T4oVJks86UJIwZS0vxGcrHu6qqWg5CyZ58pUq+Rv1DfGXKYbpIpX85F+vgdkV
         tVl6XoSVEeJEekdCKf4rTkUsw8bW0zEn7veEyeLzB+ndpYC7ZooXSn/Cpp3HboXiqhb+
         3hpHzFvMIowiSU7Lkmhumlx3ZSCw4a8IFTv4ssNSh7cV2mz7HXjSLajnUtFZ1WkrIWah
         rHu2DMxbhgBCjtd17YDjowYWq/JvNrpYeCklyJJP1cp/JsG3WdEOGPwbeQbx5DjPtt7X
         nm1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9+1wmLMR32a4owb7dmiLLzwYsR7GITdvUE8vjTvuilE=;
        b=4t1y4ZAyzqJpaAHTOcc0JQd/9SDqgk47CnK5NeCqe9LTZXH0lj5KL8mcCoioel6wky
         Q/bSWtBzdGCVuL2k1UHXj/osRmZRvXGbVcT7najTXY+fIkuUqnOVJk5bLPdji3c3da3q
         Koa026A3Op7t0KOo2XublAln/il07DAWmL3xpxPFoUCfqqRJGjfCgcSFl+uOVj7KM35+
         eYs5+KCFicv9yJA5hpiF6/WXhgNFVMJx9/x5ltfmb0c/vaNxWmi6qbqrRGTKBey37Opm
         k52XZjp0C/F9oGaceZXMMbMbXvXSSj/A4oOnPC8mpAbYFcNPC1fo2lpacHKIBCYsppJ6
         xmZg==
X-Gm-Message-State: AOAM531OSh3Og7uBnlf5q1zIlxBdSryEYxO5NzAuucqwfIQrFt3SG7Qe
        EpgppJ5lPa050v8XX9B68tjvhQ==
X-Google-Smtp-Source: ABdhPJzPyTIl2t/oL3DjN5/Lhw+wTdL2jGh8m7uzJGY603AFVNlHPu0JZoBNTAXesEg3q0f5NEvjWQ==
X-Received: by 2002:a6b:7306:: with SMTP id e6mr17042524ioh.25.1637783063826;
        Wed, 24 Nov 2021 11:44:23 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id r14sm490145iov.14.2021.11.24.11.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 11:44:23 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     pkurapat@codeaurora.org, avuyyuru@codeaurora.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, evgreen@chromium.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] net: ipa: support enhanced channel flow control
Date:   Wed, 24 Nov 2021 13:44:16 -0600
Message-Id: <20211124194416.707007-3-elder@linaro.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211124194416.707007-1-elder@linaro.org>
References: <20211124194416.707007-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

IPA v4.2 introduced GSI channel flow control, used instead of IPA
endpoint DELAY mode to prevent a TX channel from injecting packets
into the IPA core.  It used a new FLOW_CONTROLLED channel state
which could be entered using GSI generic commands.

IPA v4.11 extended the channel flow control model.  Rather than
having a distinct FLOW_CONTROLLED channel state, each channel has a
"flow control" property that can be enabled or not--independent of
the channel state.  The AP (or modem) can modify this property using
the same GSI generic commands as before.

The AP only uses channel flow control on modem TX channels, and only
when recovering from a modem crash.  The AP has no way to discover
the state of a modem channel, so the fact that (starting with IPA
v4.11) flow control no longer uses a distinct channel state is
invisible to the AP.  So enhanced flow control generally does not
change the way AP uses flow control.

There are a few small differences, however:
  - There is a notion of "primary" or "secondary" flow control, and
    when enabling or disabling flow control that must be specified
    in a new field in the GSI generic command register.  For now, we
    always specify 0 (meaning "primary").
  - When disabling flow control, it's possible a request will need
    to be retried.  We retry up to 5 times in this case.
  - Another new generic command allows the current flow control
    state to be queried.  We do not use this.

Other than the need for retries, the code essentially works the same
way as before.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c     | 20 ++++++++++++++++----
 drivers/net/ipa/gsi.h     |  2 +-
 drivers/net/ipa/gsi_reg.h |  2 ++
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 5f9e9fb501e7f..1125926367b2c 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -93,6 +93,7 @@
 
 #define GSI_CHANNEL_STOP_RETRIES	10
 #define GSI_CHANNEL_MODEM_HALT_RETRIES	10
+#define GSI_CHANNEL_MODEM_FLOW_RETRIES	5	/* disable flow control only */
 
 #define GSI_MHI_EVENT_ID_START		10	/* 1st reserved event id */
 #define GSI_MHI_EVENT_ID_END		16	/* Last reserved event id */
@@ -1658,7 +1659,8 @@ static void gsi_channel_teardown_one(struct gsi *gsi, u32 channel_id)
  * issue the command and wait for it to complete.
  */
 static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
-			       enum gsi_generic_cmd_opcode opcode)
+			       enum gsi_generic_cmd_opcode opcode,
+			       u8 params)
 {
 	struct completion *completion = &gsi->completion;
 	bool timeout;
@@ -1685,6 +1687,7 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 	val = u32_encode_bits(opcode, GENERIC_OPCODE_FMASK);
 	val |= u32_encode_bits(channel_id, GENERIC_CHID_FMASK);
 	val |= u32_encode_bits(GSI_EE_MODEM, GENERIC_EE_FMASK);
+	val |= u32_encode_bits(params, GENERIC_PARAMS_FMASK);
 
 	timeout = !gsi_command(gsi, GSI_GENERIC_CMD_OFFSET, val, completion);
 
@@ -1703,7 +1706,7 @@ static int gsi_generic_command(struct gsi *gsi, u32 channel_id,
 static int gsi_modem_channel_alloc(struct gsi *gsi, u32 channel_id)
 {
 	return gsi_generic_command(gsi, channel_id,
-				   GSI_GENERIC_ALLOCATE_CHANNEL);
+				   GSI_GENERIC_ALLOCATE_CHANNEL, 0);
 }
 
 static void gsi_modem_channel_halt(struct gsi *gsi, u32 channel_id)
@@ -1713,7 +1716,7 @@ static void gsi_modem_channel_halt(struct gsi *gsi, u32 channel_id)
 
 	do
 		ret = gsi_generic_command(gsi, channel_id,
-					  GSI_GENERIC_HALT_CHANNEL);
+					  GSI_GENERIC_HALT_CHANNEL, 0);
 	while (ret == -EAGAIN && retries--);
 
 	if (ret)
@@ -1725,13 +1728,22 @@ static void gsi_modem_channel_halt(struct gsi *gsi, u32 channel_id)
 void
 gsi_modem_channel_flow_control(struct gsi *gsi, u32 channel_id, bool enable)
 {
+	u32 retries = 0;
 	u32 command;
 	int ret;
 
 	command = enable ? GSI_GENERIC_ENABLE_FLOW_CONTROL
 			 : GSI_GENERIC_DISABLE_FLOW_CONTROL;
+	/* Disabling flow control on IPA v4.11+ can return -EAGAIN if enable
+	 * is underway.  In this case we need to retry the command.
+	 */
+	if (!enable && gsi->version >= IPA_VERSION_4_11)
+		retries = GSI_CHANNEL_MODEM_FLOW_RETRIES;
+
+	do
+		ret = gsi_generic_command(gsi, channel_id, command, 0);
+	while (ret == -EAGAIN && retries--);
 
-	ret = gsi_generic_command(gsi, channel_id, command);
 	if (ret)
 		dev_err(gsi->dev,
 			"error %d %sabling mode channel %u flow control\n",
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 41b3ab14c5124..5370a282a9f57 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -101,7 +101,7 @@ enum gsi_channel_state {
 	GSI_CHANNEL_STATE_STARTED		= 0x2,
 	GSI_CHANNEL_STATE_STOPPED		= 0x3,
 	GSI_CHANNEL_STATE_STOP_IN_PROC		= 0x4,
-	GSI_CHANNEL_STATE_FLOW_CONTROLLED	= 0x5,	/* IPA v4.2+ */
+	GSI_CHANNEL_STATE_FLOW_CONTROLLED	= 0x5,	/* IPA v4.2-v4.9 */
 	GSI_CHANNEL_STATE_ERROR			= 0xf,
 };
 
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index 4ab23998b3485..8906f4381032e 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -313,6 +313,7 @@ enum gsi_evt_cmd_opcode {
 #define GENERIC_OPCODE_FMASK		GENMASK(4, 0)
 #define GENERIC_CHID_FMASK		GENMASK(9, 5)
 #define GENERIC_EE_FMASK		GENMASK(13, 10)
+#define GENERIC_PARAMS_FMASK		GENMASK(31, 24)	/* IPA v4.11+ */
 
 /** enum gsi_generic_cmd_opcode - GENERIC_OPCODE field values in GENERIC_CMD */
 enum gsi_generic_cmd_opcode {
@@ -320,6 +321,7 @@ enum gsi_generic_cmd_opcode {
 	GSI_GENERIC_ALLOCATE_CHANNEL		= 0x2,
 	GSI_GENERIC_ENABLE_FLOW_CONTROL		= 0x3,	/* IPA v4.2+ */
 	GSI_GENERIC_DISABLE_FLOW_CONTROL	= 0x4,	/* IPA v4.2+ */
+	GSI_GENERIC_QUERY_FLOW_CONTROL		= 0x5,	/* IPA v4.11+ */
 };
 
 /* The next register is present for IPA v3.5.1 and above */
-- 
2.32.0

