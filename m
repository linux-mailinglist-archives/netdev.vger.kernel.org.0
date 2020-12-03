Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899FA2CD83D
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 14:55:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbgLCNwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 08:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbgLCNwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 08:52:14 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13969C061A56
        for <netdev@vger.kernel.org>; Thu,  3 Dec 2020 05:50:56 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id u19so2158623edx.2
        for <netdev@vger.kernel.org>; Thu, 03 Dec 2020 05:50:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7cVseWE6MIn0vIOshUQxsts71GrP62tJMM0vJ2mEO6M=;
        b=dSHcHuRESYLtlZtJIQdqGBUk0OZD2FHTCPmivLVjMLany23ElrfmjTJ5QNuXbr51/t
         FAxaJiOYERb1JckT6NM6S5qBJkYfbIUgnWBr4SIUckpOfvLa6FerK5Gy+XHNksXuEhji
         IRB+aPMkqGj4Xfr1m7rQx/u/2zCNvktGFS/Ziayy1AUQy0ExZC5TFSmTaPIsCIyW30Lf
         XE48qB6V1B8IltXD7ldz7T/LZ3qND7n05B7pijClTcATNDO4+hbMCCP6baNAIgZHbMRk
         afbgWtuUmLykXV0VbY4D2uJSS5hMGsoU3b5VKHHBMsFEuuqFAw96/D3jEBv5b4MBHdUL
         osgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7cVseWE6MIn0vIOshUQxsts71GrP62tJMM0vJ2mEO6M=;
        b=DgnYD41wgIy/y4VOp4HzgR96abGl/jkFVdiqoxXw89Ggl3X2QHN6SvAVzBq7z68yKt
         yqOVZhLeNjxS3WFMW5mN26T6DKTBL2+6ZBH/39NVufXeWam5oBqCwGaDSaJl9VrMcKFP
         OoZGefj7nY8EbdYl7hk2R2lchK7k0kylirKF82Nzc5bJWodWpLkzr9zP+haxDFmCS4Tn
         D6j8C6Xb2MqPSJ5IEhxtreCHs2if1uFYVFjERnHRzh3oimSMTKcAQsFBFnmMBVxGH3au
         Wb9U8pXNO/TvjfY0wqLjDscslI0b1hXoxLyQVhsDoqIrYyzEn5URRz7SfpE0UZnBSPMp
         oXVA==
X-Gm-Message-State: AOAM531qDFlOhSGTrFZ8FtwURDjWjJgVu6IOeUZgQI+W0Wy4ZuB35hK5
        5V8BxByMioR8yeLwGhdHJkilPw==
X-Google-Smtp-Source: ABdhPJz1lQsVMRY0JLAQ4IxHktkgOk18n2IR9qX57KDkm0D+iuVmWR4/8SHNzfogWx+ZyolX8rkCcA==
X-Received: by 2002:a50:b404:: with SMTP id b4mr2873495edh.369.1607003454809;
        Thu, 03 Dec 2020 05:50:54 -0800 (PST)
Received: from belels006.local.ess-mail.com (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id t19sm903192eje.86.2020.12.03.05.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Dec 2020 05:50:54 -0800 (PST)
From:   Patrick Havelange <patrick.havelange@essensium.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Patrick Havelange <patrick.havelange@essensium.com>
Subject: [PATCH net 3/4] net: freescale/fman-mac: remove direct use of __devm_request_region
Date:   Thu,  3 Dec 2020 14:50:38 +0100
Message-Id: <20201203135039.31474-4-patrick.havelange@essensium.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201203135039.31474-1-patrick.havelange@essensium.com>
References: <20201203135039.31474-1-patrick.havelange@essensium.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since the main fman driver is no longer reserving the complete fman
memory region, it is no longer needed to use a custom call to
__devm_request_region, so replace it with devm_request_mem_region

Signed-off-by: Patrick Havelange <patrick.havelange@essensium.com>
---
 drivers/net/ethernet/freescale/fman/mac.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 901749a7a318..35ca33335aed 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -690,12 +690,10 @@ static int mac_probe(struct platform_device *_of_dev)
 		goto _return_of_get_parent;
 	}
 
-	mac_dev->res = __devm_request_region(dev,
-					     fman_get_mem_region(priv->fman),
-					     res.start, resource_size(&res),
-					     "mac");
+	mac_dev->res = devm_request_mem_region(dev, res.start,
+					       resource_size(&res), "mac");
 	if (!mac_dev->res) {
-		dev_err(dev, "__devm_request_mem_region(mac) failed\n");
+		dev_err(dev, "devm_request_mem_region(mac) failed\n");
 		err = -EBUSY;
 		goto _return_of_get_parent;
 	}
-- 
2.17.1

