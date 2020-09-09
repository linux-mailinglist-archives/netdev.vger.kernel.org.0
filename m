Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DED92623F1
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 02:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729614AbgIIAVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 20:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727940AbgIIAVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 20:21:34 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4391C061756
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 17:21:33 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id y2so673403ilp.7
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 17:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4AO2162Bte/ulZ9CvnofKmBqr4RKglDOxVaujf63iCE=;
        b=a1TuTK4MtJFjMI99KomH5XteYCTQYRkUTzIPMFhkGS3RBppusrMHJ1452iq2Akobdl
         mOT92hlud7Ezx19XbZ+Q+T9GD2D2QAwRSz5xDLCmueKASaMZy7Fb3pua5Yny9LJpyjay
         qt6AwEKqxOBcn/baHxGgfksCzuBagajdJD1ykKc5VUALsLpxNjjBwTKC0CHdWkdMD2qx
         nx20wh0CxVzBoW0f1K06wYNTOXdnEuNVA37OuJfS/CoWDbhAuF5OxGSlSQkGrrrpFy9O
         K4pJ6ejXwWaKa6UJegzqfqzGQDyIBFMGd9oYYDfdw1U7fttRIVZLGTzWtP1kF68lcN/j
         ukIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4AO2162Bte/ulZ9CvnofKmBqr4RKglDOxVaujf63iCE=;
        b=t/EkyhclHaMKaR+vM0UiEbMq6kpIaf3Q3yhZfmxlSlP15FzcNvRp5EdVgE88zn/Rdh
         feG7XIFBAuvCZS2lkn50BhlCcXb1CqVmWRFBq8xy9NAn5BiYiABF7mHgQj1elESkTOb/
         4zos+LzNZEUVHkJ8stOjPXZ3eMqv14pEjC09IkSUlNnyMBSuXT9m3FEMQustvJiUsPnw
         2PkKdif36Sk/Acq+fO9uVNYTxR+7mN4wRl6kffnlBEmKwpI84JwJiz3lOUs1WBROIdKV
         eSGjnWk4uho0d4ipjcro3JLgiW91WMFAOHSvyNiffE/L+hyuRo1F96JzUnIx/RCy/19Z
         rNNA==
X-Gm-Message-State: AOAM532zXMIVjasdVhDyDMOE+wouMVS5araEMPQ+4MVH6xDBF6BEPCX6
        QQVMGuMgJORYcQ0HduDd936RSQ==
X-Google-Smtp-Source: ABdhPJxJHNJvd6vjUWApZQY6Iihzu397LyiVMDZUtmGPGDmu/Zlt6omKQG/F4Y+EvlSaPNiE71np+A==
X-Received: by 2002:a92:9604:: with SMTP id g4mr1495062ilh.6.1599610893171;
        Tue, 08 Sep 2020 17:21:33 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id f21sm457739ioh.1.2020.09.08.17.21.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 17:21:32 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/5] net: ipa: use atomic exchange for suspend reference
Date:   Tue,  8 Sep 2020 19:21:23 -0500
Message-Id: <20200909002127.21089-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200909002127.21089-1-elder@linaro.org>
References: <20200909002127.21089-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We take a single IPA clock reference to keep the clock running
until we get a system suspend operation.  When a system suspend
request arrives, we drop that reference, and if that's the last
reference (likely) we'll proceed with suspending endpoints and
disabling the IPA core clock and interconnects.

In most places we simply set the reference count to 0 or 1
atomically.  Instead--primarily to catch coding errors--use an
atomic exchange to update the reference count value, and report
an error in the event the previous value was unexpected.

In a few cases it's not hard to see that the error message should
never be reported.  Report them anyway, but add some excitement
to the message by ending it with an exclamation point.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 1fdfec41e4421..6b843fc989122 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -83,6 +83,7 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 	/* Take a a single clock reference to prevent suspend.  All
 	 * endpoints will be resumed as a result.  This reference will
 	 * be dropped when we get a power management suspend request.
+	 * The first call activates the clock; ignore any others.
 	 */
 	if (!atomic_xchg(&ipa->suspend_ref, 1))
 		ipa_clock_get(ipa);
@@ -502,13 +503,15 @@ static void ipa_resource_deconfig(struct ipa *ipa)
  */
 static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 {
+	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
 	/* Get a clock reference to allow initialization.  This reference
 	 * is held after initialization completes, and won't get dropped
 	 * unless/until a system suspend request arrives.
 	 */
-	atomic_set(&ipa->suspend_ref, 1);
+	if (atomic_xchg(&ipa->suspend_ref, 1))
+		dev_err(dev, "suspend clock reference already taken!\n");
 	ipa_clock_get(ipa);
 
 	ipa_hardware_config(ipa);
@@ -544,7 +547,8 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 err_hardware_deconfig:
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-	atomic_set(&ipa->suspend_ref, 0);
+	if (!atomic_xchg(&ipa->suspend_ref, 0))
+		dev_err(dev, "suspend clock reference already dropped!\n");
 
 	return ret;
 }
@@ -562,7 +566,8 @@ static void ipa_deconfig(struct ipa *ipa)
 	ipa_endpoint_deconfig(ipa);
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-	atomic_set(&ipa->suspend_ref, 0);
+	if (!atomic_xchg(&ipa->suspend_ref, 0))
+		dev_err(&ipa->pdev->dev, "no suspend clock reference\n");
 }
 
 static int ipa_firmware_load(struct device *dev)
@@ -913,7 +918,8 @@ static int ipa_suspend(struct device *dev)
 	struct ipa *ipa = dev_get_drvdata(dev);
 
 	ipa_clock_put(ipa);
-	atomic_set(&ipa->suspend_ref, 0);
+	if (!atomic_xchg(&ipa->suspend_ref, 0))
+		dev_err(dev, "suspend: missing suspend clock reference\n");
 
 	return 0;
 }
@@ -933,7 +939,8 @@ static int ipa_resume(struct device *dev)
 	/* This clock reference will keep the IPA out of suspend
 	 * until we get a power management suspend request.
 	 */
-	atomic_set(&ipa->suspend_ref, 1);
+	if (atomic_xchg(&ipa->suspend_ref, 1))
+		dev_err(dev, "resume: duplicate suspend clock reference\n");
 	ipa_clock_get(ipa);
 
 	return 0;
-- 
2.20.1

