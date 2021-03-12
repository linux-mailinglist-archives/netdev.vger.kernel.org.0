Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F73C3390EA
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 16:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhCLPNK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 10:13:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231994AbhCLPMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 10:12:55 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80500C061574
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 07:12:55 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id m7so7016855iow.7
        for <netdev@vger.kernel.org>; Fri, 12 Mar 2021 07:12:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1eAf7XHun/r1nyfyWnh0YUK8Tw5feFEiDHVXlmI2i/4=;
        b=L9J5XOFM+tUsF0a+JOdmeFuicTc8KdqOsosjj2zQuZOGGzQ18Ly2OAHISm3GKXXdS0
         hSkFKT6Q+UXEeip8HbrPWIQ+fTXrsBwfbDOwns9lOM6f7vccjT8/wb0EY+I81m226sFQ
         4l0BadeWEdCN1hav3kkEZml2smyxNIkh/qRFVp5vfZODCJ1gEZVI0dcOBPIgFixZcEEP
         HANmVovS++S2/W1qB2A/NO+OA8pSuFCiO0v8eP08aeMPEhqMBB+XqS3AvOnWyluwiWuH
         4INnylJ9BkaOFJZl4G0j6Tk5jtInT81hv/kEswdr9QB0OUb78ctfs34qOJUAdhEe32Xe
         DCtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1eAf7XHun/r1nyfyWnh0YUK8Tw5feFEiDHVXlmI2i/4=;
        b=Ag3Bb+kKFX5VfNh2mGzeQJUkKzTqnCEWtsieoKBNSGjzfur32fN1f90N8T5lIjRlib
         YpUJge2tIJSnmuK+7M/gxtG2BXsq1Tf/1CTSMhM0kpRVwm/QeLVrj4V3dwMictEUJMAT
         EzDCinEseOi4FdBDSOAW0YqomdXS6/L3fMrG5NPSZp3qWSxDvFnvNP4vStBqMeVbolab
         jyop9bbRGnW+4nd7vSmUoGQovyud0N/6TLFl5cUZgWd2DSmG77xtRludhN/MZlQCmHV8
         VuMMo8tm89haIlaeWkh5qRVr12ZDNS2VY/JwrqUuHWlG+Y6kQXDfvUx7eYrX/RVRZnIl
         x3OA==
X-Gm-Message-State: AOAM531QOmTlrJGzcrJxojdnshNPvZg21qfHbXNEIuzPJPEQyFsE5B4P
        p3s7ySzZp4pK6psW1LEgbBuKDA==
X-Google-Smtp-Source: ABdhPJxjMDzchE+ZmuHLfDbQNeOf5+Je4pdz+mYURBsR0RkgWEpKRsqKaDMq2dWnqBTt/ZhKCvpyPQ==
X-Received: by 2002:a6b:6e06:: with SMTP id d6mr10291475ioh.116.1615561974993;
        Fri, 12 Mar 2021 07:12:54 -0800 (PST)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id u15sm3046764iln.84.2021.03.12.07.12.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 07:12:54 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     sujitka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net] net: ipa: terminate message handler arrays
Date:   Fri, 12 Mar 2021 09:12:48 -0600
Message-Id: <20210312151249.481395-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When a QMI handle is initialized, an array of message handler
structures is provided, defining how any received message should
be handled based on its type and message ID.  The QMI core code
traverses this array when a message arrives and calls the function
associated with the (type, msg_id) found in the array.

The array is supposed to be terminated with an empty (all zero)
entry though.  Without it, an unsupported message will cause
the QMI core code to go past the end of the array.

Fix this bug, by properly terminating the message handler arrays
provided when QMI handles are set up by the IPA driver.

Fixes: 530f9216a9537 ("soc: qcom: ipa: AP/modem communications")
Reported-by: Sujit Kautkar <sujitka@chromium.org>
Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_qmi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 2fc64483f2753..e594bf3b600f0 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -249,6 +249,7 @@ static const struct qmi_msg_handler ipa_server_msg_handlers[] = {
 		.decoded_size	= IPA_QMI_DRIVER_INIT_COMPLETE_REQ_SZ,
 		.fn		= ipa_server_driver_init_complete,
 	},
+	{ },
 };
 
 /* Handle an INIT_DRIVER response message from the modem. */
@@ -269,6 +270,7 @@ static const struct qmi_msg_handler ipa_client_msg_handlers[] = {
 		.decoded_size	= IPA_QMI_INIT_DRIVER_RSP_SZ,
 		.fn		= ipa_client_init_driver,
 	},
+	{ },
 };
 
 /* Return a pointer to an init modem driver request structure, which contains
-- 
2.27.0

