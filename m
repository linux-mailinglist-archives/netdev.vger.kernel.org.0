Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560482B9DD6
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:51:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgKSWto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:49:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726449AbgKSWtl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:49:41 -0500
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886E8C0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:49:41 -0800 (PST)
Received: by mail-io1-xd41.google.com with SMTP id m9so7902614iox.10
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 14:49:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bo4MSwJ0tFuIkBE6whS0DGZ/BGwfpkBFnKgHt6nK9mc=;
        b=LW7B1p54sQ0R41QAYybP5dn8QpIlUsIfU+oEIC4hgcjr1EPQzjmgAalqONQ3S+2d6B
         z0z7uwFyxfpX68Wpbk66MqOiVQeW0MWgrEQ8OzyS2dkdtoMOROZoXS1NooiErSFswwT+
         1BRyCT+ifjMv7YFZZWPSD560NpqsESdwamWdHFxL3/GsmbYAqySkxx6RigEr2hn40Z7d
         BPQzQvBucOvQyofVIuRLeex0KgW/5bMDtOoVZux/QQJ0FCpnhRKvFqsZ+tLI63juI7uU
         ZC1k7jX4yeuoBPr1FrJuJ3HOO12JzEeAqJ1EdFCtnXYM+t5F90tTFPuzdXc6PxSItTMn
         Z/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bo4MSwJ0tFuIkBE6whS0DGZ/BGwfpkBFnKgHt6nK9mc=;
        b=Btd34Qa7LDdjbQzwWOutyZMnbNmEx2CArV9izCvEWCTQ+yRmGpLnI8leowsDpsf+Ps
         Zf+LlgX+9g4uOLVxM/L7kP9h98m6O+dV1QgG+m9ug+ua+vSDeYXzxfiZgENZ8J4pZwcJ
         yotiokxEu7pV31QdJ0KhvXCZc0xjWs46yBKM9l9IITStzQejqlBZD0MXkM0h5FXXSqQU
         5qXdRYGKr5dfJsjkXC4uA8nwrQP0zn7aFVlCK3m0LbjVyzoa14BMsJ740dXt0aPcinrZ
         jss89sEhzRlKEpmJjqOQSW8NaQ/dkYLBgyY0SLswSjMCB2w8e2TMPpIkZges5SoqoSLL
         S1Lg==
X-Gm-Message-State: AOAM5307IDjsFVdMWjeFSWYJ4kbjr5qe2jvGnqstYZsK79s/zY7EaUPG
        tYvPv6DLlDXD+rY8c+Cb/TDvbg==
X-Google-Smtp-Source: ABdhPJxt159FsjtZ0a9d3LRsiofXJXMu2XDRNt69oViEkRJfTZtIJ9N8Ueh8Z81ixfHlKIVgX51+iw==
X-Received: by 2002:a5d:8d13:: with SMTP id p19mr8920238ioj.37.1605826180967;
        Thu, 19 Nov 2020 14:49:40 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id i3sm446532iom.8.2020.11.19.14.49.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 14:49:40 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/6] net: ipa: add driver shutdown callback
Date:   Thu, 19 Nov 2020 16:49:29 -0600
Message-Id: <20201119224929.23819-7-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201119224929.23819-1-elder@linaro.org>
References: <20201119224929.23819-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A system shutdown can happen at essentially any time, and it's
possible that the IPA driver is busy when a shutdown is underway.
IPA hardware accesses IMEM and SMEM memory regions using an IOMMU,
and at some point during shutdown, needed I/O mappings could become
invalid.  This could be disastrous for any "in flight" IPA activity.

Avoid this by defining a new driver shutdown callback that stops all
IPA activity and cleanly shuts down the driver.  It merely calls the
driver's existing remove callback, reporting the error if it returns
one.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 9f4bd822ac625..bbfc071fa2a60 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -889,6 +889,15 @@ static int ipa_remove(struct platform_device *pdev)
 	return 0;
 }
 
+static void ipa_shutdown(struct platform_device *pdev)
+{
+	int ret;
+
+	ret = ipa_remove(pdev);
+	if (ret)
+		dev_err(&pdev->dev, "shutdown: remove returned %d\n", ret);
+}
+
 /**
  * ipa_suspend() - Power management system suspend callback
  * @dev:	IPA device structure
@@ -946,8 +955,9 @@ static const struct dev_pm_ops ipa_pm_ops = {
 };
 
 static struct platform_driver ipa_driver = {
-	.probe	= ipa_probe,
-	.remove	= ipa_remove,
+	.probe		= ipa_probe,
+	.remove		= ipa_remove,
+	.shutdown	= ipa_shutdown,
 	.driver	= {
 		.name		= "ipa",
 		.pm		= &ipa_pm_ops,
-- 
2.20.1

