Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49ED2676E8
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 02:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgILAqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 20:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgILApj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 20:45:39 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577D8C061798
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z25so12910564iol.10
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 17:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=MHChCwSLb5XE4l+5ihl1Zv+E4B2BQ9FCXd7jmzoDVYY=;
        b=ffSyNW/8JF/v6l8tc3nI8IoF7xiQnY0HRqTHgNv/SS9PRGEC7eNCKWbaqGss9+qOWx
         E6U8l2D24xUGpLqYl0msG24mNR2pTe6OpAUPZJ/6agggAUogfIJPKXINiKYG5BrFOVha
         4XQa6O5yVTH60RTnb9pghEGTPD4VPJE0IyYBRSSGX896/VHLTKAnVHAjehDWBKCgLg14
         mfy4IT9r3xd2WsKo82hiusJIB2yaLAWo4FEZitCueU8DBJWAYOi56HB7E3nhrTdIfnpl
         O+wd5yC25wuTnOPG3FEApA0zqeJR5RHtwJR9viM0TIaqLzDQnpBD0mo2OQ+Y1NgTYc/m
         lPrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MHChCwSLb5XE4l+5ihl1Zv+E4B2BQ9FCXd7jmzoDVYY=;
        b=sbMI6kCEgown9r7jynVIAJ03IGV99wCA1lYT2TDVgGXMJhJ9FELxUbsd5dQmOoo0wl
         axyeYUiahxsm1puGymG6TbZjyesoQZAA/U/itZh4jf9FFJzfRvhFecI0wlHdvcXPuSjq
         QdbL4voCOUQ9JJNrgHAdIs+avkErdJClmn3mM0RcoAqCQ9goo9lBk+rL1OK/2/GNEP89
         LeRr+xnbSiD2DaU77DJf0WltDL/1RbbvXJrfiuO/guZdEQcrcY03Kf8icfuLJM67ujD+
         IU2zysFAff4fNuGm3WPBNTz1o+VucOFUK08vwZg9Pua4pbOoyzujH0/nXAt1seUau9Cf
         Qi7A==
X-Gm-Message-State: AOAM532tJWCjwD/enGJkiUCgYt47u457dxuC1d74uAnqccsDUEZOqfzo
        ZJMA5zAr/Ph1cQR6ZG5kMPrQCQ==
X-Google-Smtp-Source: ABdhPJwDhEbw3ZTxa6wizRLsgOVTqG7G4SwtZv9TT1LWMhuxL+xjyt2wRNRmEavbVBp5zFnDrpm9TQ==
X-Received: by 2002:a05:6638:248d:: with SMTP id x13mr4436283jat.39.1599871538639;
        Fri, 11 Sep 2020 17:45:38 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z4sm2107807ilh.45.2020.09.11.17.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 17:45:38 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 3/7] net: ipa: verify reference flag values
Date:   Fri, 11 Sep 2020 19:45:28 -0500
Message-Id: <20200912004532.1386-4-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200912004532.1386-1-elder@linaro.org>
References: <20200912004532.1386-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We take a single IPA clock reference to keep the clock running until
we get a system suspend operation, and maintain a flag indicating
whether that reference has been taken.  When a suspend request
arrives, we drop that reference and clear the flag.

In most places we simply set or clear the extra-reference flag.
Instead--primarily to catch coding errors--test the previous value
of the flag and report an error in the event the previous value is
unexpected.  And if the clock reference is already taken, don't take
another.

In a couple of cases it's pretty clear atomic access is not
necessary and an error should never be reported.  Report these
anyway, conveying our surprise with an added exclamation point.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Updated to operate on a bitmap bit rather than an atomic_t.

 drivers/net/ipa/ipa_main.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index 409375b96eb8f..cfdf60ded86ca 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -83,6 +83,7 @@ static void ipa_suspend_handler(struct ipa *ipa, enum ipa_irq_id irq_id)
 	/* Take a a single clock reference to prevent suspend.  All
 	 * endpoints will be resumed as a result.  This reference will
 	 * be dropped when we get a power management suspend request.
+	 * The first call activates the clock; ignore any others.
 	 */
 	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
 		ipa_clock_get(ipa);
@@ -502,14 +503,17 @@ static void ipa_resource_deconfig(struct ipa *ipa)
  */
 static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 {
+	struct device *dev = &ipa->pdev->dev;
 	int ret;
 
 	/* Get a clock reference to allow initialization.  This reference
 	 * is held after initialization completes, and won't get dropped
 	 * unless/until a system suspend request arrives.
 	 */
-	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
-	ipa_clock_get(ipa);
+	if (!__test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
+		ipa_clock_get(ipa);
+	else
+		dev_err(dev, "suspend clock reference already taken!\n");
 
 	ipa_hardware_config(ipa);
 
@@ -544,7 +548,8 @@ static int ipa_config(struct ipa *ipa, const struct ipa_data *data)
 err_hardware_deconfig:
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
+	if (!__test_and_clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
+		dev_err(dev, "suspend clock reference already dropped!\n");
 
 	return ret;
 }
@@ -562,7 +567,8 @@ static void ipa_deconfig(struct ipa *ipa)
 	ipa_endpoint_deconfig(ipa);
 	ipa_hardware_deconfig(ipa);
 	ipa_clock_put(ipa);
-	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
+	if (!test_and_clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
+		dev_err(&ipa->pdev->dev, "no suspend clock reference\n");
 }
 
 static int ipa_firmware_load(struct device *dev)
@@ -913,7 +919,8 @@ static int ipa_suspend(struct device *dev)
 	struct ipa *ipa = dev_get_drvdata(dev);
 
 	ipa_clock_put(ipa);
-	__clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
+	if (!test_and_clear_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
+		dev_err(dev, "suspend: missing suspend clock reference\n");
 
 	return 0;
 }
@@ -933,8 +940,10 @@ static int ipa_resume(struct device *dev)
 	/* This clock reference will keep the IPA out of suspend
 	 * until we get a power management suspend request.
 	 */
-	__set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags);
-	ipa_clock_get(ipa);
+	if (!test_and_set_bit(IPA_FLAG_CLOCK_HELD, ipa->flags))
+		ipa_clock_get(ipa);
+	else
+		dev_err(dev, "resume: duplicate suspend clock reference\n");
 
 	return 0;
 }
-- 
2.20.1

