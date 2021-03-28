Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3BC34BDA9
	for <lists+netdev@lfdr.de>; Sun, 28 Mar 2021 19:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhC1Rba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Mar 2021 13:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbhC1RbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Mar 2021 13:31:18 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5809C061762
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:18 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id z3so10459600ioc.8
        for <netdev@vger.kernel.org>; Sun, 28 Mar 2021 10:31:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qv30pzI3zwmFw9Iia44xcHu7h1Qg2DXbxdalh98PfsI=;
        b=Ee1M7mbekaNT7LhG4C/KiXAOx11189FcQDXokcoib8UB+YNmWOaD/9E9z80fjrDiIl
         fw496M5qPxQ7113cVh5VBC2sq/LPe43I9wq/RtQCtq27wA5m0ydKM2/vgEQ8YiT32Ibv
         UzeFz1+TYLylr66pMReHpimV2R+MfsXOCZYZpCfygSgxEyO9RCFoj7APXpJY5oh7isFh
         E/MqiJIVQrZ5m6FsI93f9VbciYKR21c/O1P3vl4LwRWEQ2+Q4wWZNOCgOSVny4ffjgij
         NWEr3yrMRoGxS07iKXhxVK/Ze0qDKWzTI4gRH77azm4wbdPJU/wmfJhFQvK6uTtjRd4U
         i1rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qv30pzI3zwmFw9Iia44xcHu7h1Qg2DXbxdalh98PfsI=;
        b=chtrfBQYv54ZBBIFJ0RZ0VogQBw8VM2pZvIYq7XjfHlOAItyoe2lzgL9dzLP1EYZwj
         RrBGQSE7ydiVQx2aPYGe+mhKULVcMCWu6l6t/Iqp95/d5cizpYSst/9+1KSyRwCyg9No
         YCzYGvroF2cSXNajVPPoEphT8wCxX4xgUeEtwEL9td0U4KCVr7+Ufu3EstdE2PgcVrUM
         mXnN+KTUISnGQ+yMN7YSyOsNwXZiKMoBGPyiqrtIqKtRFOl/ERy+I8PJzWU2yBZ56EnU
         cKXazYo30rAYXrUHU7gWspQ3jvFYUlbHgjo9fhPJxqc7lrMbVawuK3OXpDhL7N3NKxT8
         0m3A==
X-Gm-Message-State: AOAM532fcuxEYx8RzL1MUc2DEANeLe/d9zwg7Vljvir/TDCk04BB8l17
        az6Nqgsr80y11GWib0LVELvwTQ==
X-Google-Smtp-Source: ABdhPJwh1NmslvCGIIYwVa6Y/OW/+XvLOhnYiVe/sNh6eTeCmZUL0UeT8V9nO3ZCTjnIRDR7gdLQUw==
X-Received: by 2002:a6b:d20e:: with SMTP id q14mr17513741iob.200.1616952678218;
        Sun, 28 Mar 2021 10:31:18 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id d22sm8014422iof.48.2021.03.28.10.31.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Mar 2021 10:31:17 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/7] net: ipa: don't define endpoints unnecessarily
Date:   Sun, 28 Mar 2021 12:31:07 -0500
Message-Id: <20210328173111.3399063-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210328173111.3399063-1-elder@linaro.org>
References: <20210328173111.3399063-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We don't typically need much information about modem endpoints.
Normally we need to specify information about modem endpoints in
configuration data in only two cases:
  - When a modem TX endpoint supports filtering
  - When another endpoint's configuration refers to it

For the first case, the AP initializes the filter table, and must
know how many endpoints (AP and modem) support filtering.  An
example of the second case is the AP->modem TX endpoint, which
defines the modem<-AP RX endpoint as its status endpoint.

There is one exception to this, and it's due to a hardware quirk.
For IPA v4.2 (only) there is a problem related to allocating GSI
channels.  And to work around this, the AP allocates *all* GSI
channels at startup time--including those used by the modem.

Get rid of the configuration information for two endpoints not
required for the SDM845.  SC7180 runs IPA v4.2, so we can't
eliminate any modem endpoint definitions there.

Two more minor changes:
  - Reorder the members defined for the ipa_endpoint_name enumerated
    type to match the order used in configuration data files when
    defining endpoints.
  - Add a new name, IPA_ENDPOINT_MODEM_DL_NLO_TX, which can be used
    for IPA v4.5+.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_data-sdm845.c | 12 ------------
 drivers/net/ipa/ipa_endpoint.h    | 11 ++++++-----
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ipa/ipa_data-sdm845.c b/drivers/net/ipa/ipa_data-sdm845.c
index 49a18b1047c58..ed0bfe0634d98 100644
--- a/drivers/net/ipa/ipa_data-sdm845.c
+++ b/drivers/net/ipa/ipa_data-sdm845.c
@@ -144,12 +144,6 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			},
 		},
 	},
-	[IPA_ENDPOINT_MODEM_COMMAND_TX] = {
-		.ee_id		= GSI_EE_MODEM,
-		.channel_id	= 1,
-		.endpoint_id	= 4,
-		.toward_ipa	= true,
-	},
 	[IPA_ENDPOINT_MODEM_LAN_TX] = {
 		.ee_id		= GSI_EE_MODEM,
 		.channel_id	= 0,
@@ -159,12 +153,6 @@ static const struct ipa_gsi_endpoint_data ipa_gsi_endpoint_data[] = {
 			.filter_support	= true,
 		},
 	},
-	[IPA_ENDPOINT_MODEM_LAN_RX] = {
-		.ee_id		= GSI_EE_MODEM,
-		.channel_id	= 3,
-		.endpoint_id	= 13,
-		.toward_ipa	= false,
-	},
 	[IPA_ENDPOINT_MODEM_AP_TX] = {
 		.ee_id		= GSI_EE_MODEM,
 		.channel_id	= 4,
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 0d410b0504562..f034a9e6ef215 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -25,15 +25,16 @@ struct ipa_gsi_endpoint_data;
 #define IPA_MTU			ETH_DATA_LEN
 
 enum ipa_endpoint_name {
-	IPA_ENDPOINT_AP_MODEM_TX,
-	IPA_ENDPOINT_MODEM_LAN_TX,
-	IPA_ENDPOINT_MODEM_COMMAND_TX,
 	IPA_ENDPOINT_AP_COMMAND_TX,
-	IPA_ENDPOINT_MODEM_AP_TX,
 	IPA_ENDPOINT_AP_LAN_RX,
+	IPA_ENDPOINT_AP_MODEM_TX,
 	IPA_ENDPOINT_AP_MODEM_RX,
-	IPA_ENDPOINT_MODEM_AP_RX,
+	IPA_ENDPOINT_MODEM_COMMAND_TX,
+	IPA_ENDPOINT_MODEM_LAN_TX,
 	IPA_ENDPOINT_MODEM_LAN_RX,
+	IPA_ENDPOINT_MODEM_AP_TX,
+	IPA_ENDPOINT_MODEM_AP_RX,
+	IPA_ENDPOINT_MODEM_DL_NLO_TX,
 	IPA_ENDPOINT_COUNT,	/* Number of names (not an index) */
 };
 
-- 
2.27.0

