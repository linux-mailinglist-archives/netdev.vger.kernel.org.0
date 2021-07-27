Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7541B3D81B0
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 23:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235093AbhG0VVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 17:21:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233373AbhG0VVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 17:21:14 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F88FC0619EE
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:19:40 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id r18so421551iot.4
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 14:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=eQ0hc8oNad64A8+9UICGjrxeLo53QWe70jQkDi/osB0=;
        b=RDm8E0R5gVFNFF6I7jWcjqO9IBb4SgKvwFEh/9SaVA4RmsBUNC4YFun3P3vrUmwO6P
         w8IZfZyB9YKNO30/lw/7K8IGz1N7qmQezlvS1p7YVrqDAMUwm60V/FVdO15zRturGXrO
         yxulgpVRo7XisVygtT7mbxJsC9bYUCZJu+PBHxjakrwAXpsf3lGlRvMnhxtf+fNvvZtq
         0lWMtw3ywvOEoeebWVZ55dQJqT3De7dvkiQTH4+l8Oz0qsTLiQ8TDKxfOGLrpbEgd2S6
         UrbkNwbkPxpPdEPTleHSKOygAUFdmcDnYqORTr+J4PMomnKB2ovOnoJZCbTfZgrI6Map
         NrrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eQ0hc8oNad64A8+9UICGjrxeLo53QWe70jQkDi/osB0=;
        b=fpChbpv+1vZScXCKORCfg8+CZvmN7PDL33BO4yYrfvaakdbOL5kOWSnZ/8MR9DyEZp
         w7bgAwbfSqVMY+4vO8hQfPYpX8RCfeecGr+vxDNBuVPfnmT4C+lkyuczshJWz4vOHdg+
         sNARgT0litUp5056p2ISjPmtwel/mxr23d2xdHrEZb9NRG1TjZSNq1JN1RWnzEFM3NNV
         YnC54DymG6bQYfM4aU6ZMawljc/nn6UM4mTUR3RaNzpMpfkGDW8u3x7+9s07SiV1Bikd
         CDFDXGzm0H2hsor7fGC348HvsxVWGfnBmoFay/s3IaLM67Ihz7DeLX/LIaQEcCQa2iFU
         ZdrQ==
X-Gm-Message-State: AOAM530Vc0O/qEA+XwG2qlqAvAcNp6UrpWbkV+HpHV5I4lxTwwPFVI/V
        BQ+0bAFK/ij0JXBlGN7IjpyeDA==
X-Google-Smtp-Source: ABdhPJxfMa086pPC2uWR9P4wNz22QscLw4YvZSPqGrY38022fR+HhBZ45mKHnyQalA69izUJiAFc9Q==
X-Received: by 2002:a6b:fe03:: with SMTP id x3mr20190538ioh.120.1627420779526;
        Tue, 27 Jul 2021 14:19:39 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id s21sm3136068iot.33.2021.07.27.14.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 14:19:39 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 4/5] net: ipa: add a clock reference for netdev operations
Date:   Tue, 27 Jul 2021 16:19:32 -0500
Message-Id: <20210727211933.926593-5-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210727211933.926593-1-elder@linaro.org>
References: <20210727211933.926593-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The IPA network device can be opened at any time, and an opened
network device can be stopped any time.  Both of these callback
functions require access to the hardware, and therefore they need
the IPA clock to be operational.  Take an IPA clock reference in
both the ->open and ->stop callback functions, dropping the
reference when they are done accessing hardware.

The ->start_xmit callback requires a little different handling,
and that will be added separately.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_modem.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index a744b81db0d9f..4ea8287e9d237 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -45,9 +45,12 @@ static int ipa_open(struct net_device *netdev)
 	struct ipa *ipa = priv->ipa;
 	int ret;
 
+	ipa_clock_get(ipa);
+
 	ret = ipa_endpoint_enable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
 	if (ret)
-		return ret;
+		goto err_clock_put;
+
 	ret = ipa_endpoint_enable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
 	if (ret)
 		goto err_disable_tx;
@@ -58,6 +61,8 @@ static int ipa_open(struct net_device *netdev)
 
 err_disable_tx:
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
+err_clock_put:
+	ipa_clock_put(ipa);
 
 	return ret;
 }
@@ -73,6 +78,8 @@ static int ipa_stop(struct net_device *netdev)
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_RX]);
 	ipa_endpoint_disable_one(ipa->name_map[IPA_ENDPOINT_AP_MODEM_TX]);
 
+	ipa_clock_put(ipa);
+
 	return 0;
 }
 
-- 
2.27.0

