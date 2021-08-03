Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E2003DEF89
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 16:01:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236469AbhHCOBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 10:01:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbhHCOBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 10:01:20 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 589C5C061757
        for <netdev@vger.kernel.org>; Tue,  3 Aug 2021 07:01:09 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id z3so19530195ile.12
        for <netdev@vger.kernel.org>; Tue, 03 Aug 2021 07:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4FkXmwZPUxx9Kh0iEhc1aEIbzGzoOTpM7okfkLR98cU=;
        b=aF9KTYAgOsz50XZP4YPUlPm/QRzuXhmNTsANGWhurLcpCVFS5is8Yv36Nr/jWPRvPS
         AAS94gr2lbE8EDGjGQugS1gb8asej41DSwXPo2KcJN2cL7gnaQjSQBxiF1Q55ZFnsNmo
         cGf9MuFMEbvCIloQEz4YB7WjpK4lH/wCPqhWLr2P1s1pRXLyBt98aag+hj8kfE+krrzv
         n/G3Qw9NKCnJKHulNP1KEtrgr+KohM4lEV3RXMRMeXlNaDYeot5AMbGzCLUZvpFX6T6g
         IODxbCiS3LnElBpBTWzFEjolqoPMcpeMh7B5YkohquHyd2Hv+47hoSDqTrQKPbFb/VRD
         owgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4FkXmwZPUxx9Kh0iEhc1aEIbzGzoOTpM7okfkLR98cU=;
        b=HzCWY1gZbk674Ycm+sU36+590CKYL/ufmlub1oFn6LzBLYt7bk7BiKDUmBXVEqnfku
         k/yQ+q3OsQ+X4lvLhvk0kXVKUOcyHVM5QbRMOGpjbQbBgmDSNxWCMI513bJovF+MgtmB
         GG6Lu0nGgn2O5n0MN9Tj1zCDMNomr3WWe//7svav58tvkvlqNjnyDUr/2ftQYU7gdR4n
         2xYFphhPkeqAvYEcewXh9PIfG07xQ7XOYQ5h1yxweTQo7yLQ0WWYcxuZIbT/LDBF5X+Q
         gM7bhGNMaZPCqSIpoCoNf1f/4FBSbm5v30sKIMyV+bUyX16XSKmwFUxvE8r/XZ4fDPfL
         wspw==
X-Gm-Message-State: AOAM5339RxB0RRIV6rGo5mBh3mQyKuZtUcOOrrnIC51jutMMZi2WWX0h
        DgWoAhQyvSQNGpnOZDr/48ikAA==
X-Google-Smtp-Source: ABdhPJzJXX2epgpAZG/0csa9FRc5wSnU1Hmz3hOiBw12Fk95VXdEehkt3O7l64nRJi0ebpQYkp7KSg==
X-Received: by 2002:a05:6e02:198f:: with SMTP id g15mr199659ilf.120.1627999268671;
        Tue, 03 Aug 2021 07:01:08 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id w7sm9456798iox.1.2021.08.03.07.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Aug 2021 07:01:08 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/6] net: ipa: use gsi->version for channel suspend/resume
Date:   Tue,  3 Aug 2021 09:00:58 -0500
Message-Id: <20210803140103.1012697-2-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210803140103.1012697-1-elder@linaro.org>
References: <20210803140103.1012697-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The GSI layer has the IPA version now, so there's no need for
version-specific flags to be passed from IPA.  One instance of
this is in gsi_channel_suspend() and gsi_channel_resume(), which
indicate whether or not the endpoint suspend is implemented by
GSI stopping the channel.  We can make that determination based
on gsi->version, eliminating the need for a Boolean flag in those
functions.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c          | 14 ++++++++------
 drivers/net/ipa/gsi.h          | 19 +++++++++++++++++--
 drivers/net/ipa/ipa_endpoint.c | 14 ++------------
 3 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index 3de67ba066a68..e143deddb7c09 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1026,13 +1026,14 @@ void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell)
 	mutex_unlock(&gsi->mutex);
 }
 
-/* Stop a STARTED channel for suspend (using stop if requested) */
-int gsi_channel_suspend(struct gsi *gsi, u32 channel_id, bool stop)
+/* Stop a started channel for suspend */
+int gsi_channel_suspend(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 	int ret;
 
-	ret = __gsi_channel_stop(channel, stop);
+	/* Prior to IPA v4.0 suspend/resume is not implemented by GSI */
+	ret = __gsi_channel_stop(channel, gsi->version >= IPA_VERSION_4_0);
 	if (ret)
 		return ret;
 
@@ -1042,12 +1043,13 @@ int gsi_channel_suspend(struct gsi *gsi, u32 channel_id, bool stop)
 	return 0;
 }
 
-/* Resume a suspended channel (starting will be requested if STOPPED) */
-int gsi_channel_resume(struct gsi *gsi, u32 channel_id, bool start)
+/* Resume a suspended channel (starting if stopped) */
+int gsi_channel_resume(struct gsi *gsi, u32 channel_id)
 {
 	struct gsi_channel *channel = &gsi->channel[channel_id];
 
-	return __gsi_channel_start(channel, start);
+	/* Prior to IPA v4.0 suspend/resume is not implemented by GSI */
+	return __gsi_channel_start(channel, gsi->version >= IPA_VERSION_4_0);
 }
 
 /**
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 81cd7b07f6e14..97163b58b4ebc 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -232,8 +232,23 @@ int gsi_channel_stop(struct gsi *gsi, u32 channel_id);
  */
 void gsi_channel_reset(struct gsi *gsi, u32 channel_id, bool doorbell);
 
-int gsi_channel_suspend(struct gsi *gsi, u32 channel_id, bool stop);
-int gsi_channel_resume(struct gsi *gsi, u32 channel_id, bool start);
+/**
+ * gsi_channel_suspend() - Suspend a GSI channel
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel to suspend
+ *
+ * For IPA v4.0+, suspend is implemented by stopping the channel.
+ */
+int gsi_channel_suspend(struct gsi *gsi, u32 channel_id);
+
+/**
+ * gsi_channel_resume() - Resume a suspended GSI channel
+ * @gsi:	GSI pointer
+ * @channel_id:	Channel to resume
+ *
+ * For IPA v4.0+, the stopped channel is started again.
+ */
+int gsi_channel_resume(struct gsi *gsi, u32 channel_id);
 
 /**
  * gsi_init() - Initialize the GSI subsystem
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 8070d1a1d5dfd..08ee37ae28813 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1587,7 +1587,6 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 {
 	struct device *dev = &endpoint->ipa->pdev->dev;
 	struct gsi *gsi = &endpoint->ipa->gsi;
-	bool stop_channel;
 	int ret;
 
 	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
@@ -1598,11 +1597,7 @@ void ipa_endpoint_suspend_one(struct ipa_endpoint *endpoint)
 		(void)ipa_endpoint_program_suspend(endpoint, true);
 	}
 
-	/* Starting with IPA v4.0, endpoints are suspended by stopping the
-	 * underlying GSI channel rather than using endpoint suspend mode.
-	 */
-	stop_channel = endpoint->ipa->version >= IPA_VERSION_4_0;
-	ret = gsi_channel_suspend(gsi, endpoint->channel_id, stop_channel);
+	ret = gsi_channel_suspend(gsi, endpoint->channel_id);
 	if (ret)
 		dev_err(dev, "error %d suspending channel %u\n", ret,
 			endpoint->channel_id);
@@ -1612,7 +1607,6 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 {
 	struct device *dev = &endpoint->ipa->pdev->dev;
 	struct gsi *gsi = &endpoint->ipa->gsi;
-	bool start_channel;
 	int ret;
 
 	if (!(endpoint->ipa->enabled & BIT(endpoint->endpoint_id)))
@@ -1621,11 +1615,7 @@ void ipa_endpoint_resume_one(struct ipa_endpoint *endpoint)
 	if (!endpoint->toward_ipa)
 		(void)ipa_endpoint_program_suspend(endpoint, false);
 
-	/* Starting with IPA v4.0, the underlying GSI channel must be
-	 * restarted for resume.
-	 */
-	start_channel = endpoint->ipa->version >= IPA_VERSION_4_0;
-	ret = gsi_channel_resume(gsi, endpoint->channel_id, start_channel);
+	ret = gsi_channel_resume(gsi, endpoint->channel_id);
 	if (ret)
 		dev_err(dev, "error %d resuming channel %u\n", ret,
 			endpoint->channel_id);
-- 
2.27.0

