Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD8649D54E
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233483AbiAZWSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:18:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233439AbiAZWSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:18:48 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D40EC061747
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:18:48 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d5so930903pjk.5
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:18:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=smLLchNakDU/Y2gvweI/PTFSbD8LwmvcGg4bfjOOIU4=;
        b=SZQpRx77W26mYz1aJh0WRCjXTe7xnesCHG/uFACh3EOTjS2L+jjY/xQ8r3drw7cFqM
         7VI7PSzVvA4q8uG1ZWGKTwvCKsUQQAOcveiNP6ujSwtOINe160WkmqwKFhcudu1MR88C
         vVzGtO2l/LG6m9vWuslxkVcPplEZs6/uSRs2P669FPJrm2Ds1CEuSYVeI0cpHNq52o/s
         SrnJe021IMjvpiPQkOhMXTlwLhakBvBm94n5ewyPI2goVOYstwdxAAUb6+wu0zdsXuWs
         x1hBxgqLfWKDrqA0Oo110jJghgMcbhae88+joOIkx2pA7LGsvDbgZsqwSvOPBAoOUd2m
         DJEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=smLLchNakDU/Y2gvweI/PTFSbD8LwmvcGg4bfjOOIU4=;
        b=T56lPhsijjP0OeVnc9RmncSkSIpZDGYMUNrHDx67PZ3iO3u1g5ELmD2WqDJYrvGb9C
         0bX173XAPaC0G7be9lbyqgql60a9/xhwamtm5D+hjCjSVUBOsWwbMJElagdCOmGSBy1R
         SKe6wx8lvdhp+MPLVNVTwT24vNbaV9deBkJfwHi3tfS3KOb7aMg+DiiyBw4bfZsgokGm
         8Z62AWZ6IvML9m2O+Gz4LvsD1tNZfDyY7WzOmN9ZyYrGAIipHl04g4W1mgaIhOQkjLUQ
         zMFuytep2ohseSoXVhMxVTY04gR3imGSsj2XWRkPrnPHi7KtrYyqdBM40XyxyMtLmt1d
         IZYg==
X-Gm-Message-State: AOAM531URMmmxo1Dj9CUum81OuPWmWOYymgWiSE6g4OxNG6R7S/SbHPW
        aiMkGJDXnM2QCu9h2owAXT+hzw==
X-Google-Smtp-Source: ABdhPJymcC9c3BX4ZgqkLwz28Sd8Cp7BgoYdAxG7f4GWjF2VV8r2M5wJcXc1mlmzjLizKXFZW8jQ8A==
X-Received: by 2002:a17:903:124f:: with SMTP id u15mr466795plh.15.1643235527588;
        Wed, 26 Jan 2022 14:18:47 -0800 (PST)
Received: from localhost.localdomain ([2401:4900:1f3a:4e9b:8fa7:36dc:a805:c73f])
        by smtp.gmail.com with ESMTPSA id t17sm4233742pgm.69.2022.01.26.14.18.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:18:47 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, sboyd@kernel.org,
        tdas@codeaurora.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, bjorn.andersson@linaro.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 7/8] clk: qcom: gcc-sm8150: use runtime PM for the clock controller
Date:   Thu, 27 Jan 2022 03:47:24 +0530
Message-Id: <20220126221725.710167-8-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On sm8150 emac clk registers are powered up by the GDSC power
domain. Use runtime PM calls to make sure that required power domain is
powered on while we access clock controller's registers.

Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/clk/qcom/gcc-sm8150.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm8150.c b/drivers/clk/qcom/gcc-sm8150.c
index ada755ad55f7..2e71afed81fd 100644
--- a/drivers/clk/qcom/gcc-sm8150.c
+++ b/drivers/clk/qcom/gcc-sm8150.c
@@ -5,6 +5,7 @@
 #include <linux/bitops.h>
 #include <linux/err.h>
 #include <linux/platform_device.h>
+#include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -3792,19 +3793,41 @@ static const struct of_device_id gcc_sm8150_match_table[] = {
 };
 MODULE_DEVICE_TABLE(of, gcc_sm8150_match_table);
 
+static void gcc_sm8150_pm_runtime_disable(void *data)
+{
+	pm_runtime_disable(data);
+}
+
 static int gcc_sm8150_probe(struct platform_device *pdev)
 {
 	struct regmap *regmap;
+	int ret;
+
+	pm_runtime_enable(&pdev->dev);
+
+	ret = devm_add_action_or_reset(&pdev->dev, gcc_sm8150_pm_runtime_disable, &pdev->dev);
+	if (ret)
+		return ret;
+
+	ret = pm_runtime_resume_and_get(&pdev->dev);
+	if (ret)
+		return ret;
 
 	regmap = qcom_cc_map(pdev, &gcc_sm8150_desc);
-	if (IS_ERR(regmap))
+	if (IS_ERR(regmap)) {
+		pm_runtime_put(&pdev->dev);
 		return PTR_ERR(regmap);
+	}
 
 	/* Disable the GPLL0 active input to NPU and GPU via MISC registers */
 	regmap_update_bits(regmap, 0x4d110, 0x3, 0x3);
 	regmap_update_bits(regmap, 0x71028, 0x3, 0x3);
 
-	return qcom_cc_really_probe(pdev, &gcc_sm8150_desc, regmap);
+	ret = qcom_cc_really_probe(pdev, &gcc_sm8150_desc, regmap);
+
+	pm_runtime_put(&pdev->dev);
+
+	return ret;
 }
 
 static struct platform_driver gcc_sm8150_driver = {
-- 
2.34.1

