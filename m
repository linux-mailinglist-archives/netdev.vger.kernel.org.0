Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19A0C1D5A8B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 22:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726261AbgEOUHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 16:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726183AbgEOUHm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 16:07:42 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D2FC05BD0B
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 13:07:42 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id g20so1718166qvb.9
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 13:07:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VnxRWHDXHhnTZy+gwKWC5VS3DYI6cRqhNhPWiq4rZmg=;
        b=Tv+lROKByW/LBPC0MoPALLkGwSNyeqW0JW97X019XsYzrTpHJ1jejK1GDUnGz2qpW4
         Eklk4GhajSlShVGuB/rxGAQ4l5ohbG31MBGzav8b2hgh9lnHhDt+Btva8nEY3epA2JhO
         AGFPo36fVH0LmUwzlsJ1UbuQsS0bEtoKt9GaFjhInArgcGibLC/oa5IFYTmO9G65GLUi
         ul9WcXUzWkcFjX/fTDC96YmaQ8P56slnE8SA0Mxkdbx8WXHPpS6G303UxjkRd1mrlocl
         aefrDa2CmQ0BDhjSGMakOygFLbkDm3nutDEuA0Ihvg2QMA6EIAevt8ETDiQXibZk9s7T
         0BVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VnxRWHDXHhnTZy+gwKWC5VS3DYI6cRqhNhPWiq4rZmg=;
        b=KyHeNogq37vadSSphiiLUvhcIO2IyfhA914GKzQQAdtosnAtT0V2s3VPnioxxTc7ok
         dWm6QpTm5pGeu7KXlqB8v2nk3ZgF2Uq8J5acUhpUzQDn5ffz/Pk8E6SO9qg3QDL4mPhh
         MjYA1nY4V9t84T6q9exP/SbOFeYNU6RNRHwW4veJR8EGtYnOhk1wUXRdavLuVV31x1Sa
         TswCpqLocke38SXUL/QjXlcsrBLZNAXjjTc/XRfBULtLeMIDl1TX4zPpTs54Y7pxDEyT
         /vzJOAMxJ0Di1HIM3GYLXEqo4dhK4njMnjFZdqtagl+57rZNcTWpkjoiACJ0td33Lbke
         LyFw==
X-Gm-Message-State: AOAM5316w18xuc+DaLStY9giT0SVTnJZFykEmkELvk7kRI6DsTaTdLtq
        RuSBC8TJVALsNGIXRBAyIqT2zA==
X-Google-Smtp-Source: ABdhPJzDnLFI//uXsW8EBqoqzHLUpXo1v2yfY/OVy6VaSEXRw3Oh6dIVhIfzxprXD6TWafpO8bjl4g==
X-Received: by 2002:a0c:f485:: with SMTP id i5mr5365095qvm.144.1589573261453;
        Fri, 15 May 2020 13:07:41 -0700 (PDT)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id 132sm2328246qkj.117.2020.05.15.13.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 13:07:41 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net
Cc:     evgreen@chromium.org.net, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/2] net: ipa: don't use noirq suspend/resume callbacks
Date:   Fri, 15 May 2020 15:07:30 -0500
Message-Id: <20200515200731.2931-2-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200515200731.2931-1-elder@linaro.org>
References: <20200515200731.2931-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use the suspend and resume callbacks rather than suspend_noirq and
resume_noirq.  With IPA v4.2, we use the CHANNEL_STOP command to
implement a suspend, and without interrupts enabled, that command
won't complete.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index e0b1fe3c34f9..76d5108b8403 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -933,8 +933,8 @@ static int ipa_resume(struct device *dev)
 }
 
 static const struct dev_pm_ops ipa_pm_ops = {
-	.suspend_noirq	= ipa_suspend,
-	.resume_noirq	= ipa_resume,
+	.suspend	= ipa_suspend,
+	.resume		= ipa_resume,
 };
 
 static struct platform_driver ipa_driver = {
-- 
2.20.1

