Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D63649D552
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 23:19:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233449AbiAZWSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 17:18:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233365AbiAZWSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 17:18:53 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573F5C06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:18:53 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id t32so577341pgm.7
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 14:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FZouSr9TAlelZRwtS6TKOdeYH1dxDyHrivrG4UWi6aY=;
        b=pCw1JaoBI87xZyASQ2zBq0kUaHQkbXAeg3PzhyvorB8ky9/UyZB0QtGrUmx1Z0pqgd
         AGh8SVZOQqMOAaVdWo7urIWGh3MNWA5u/wQ4IIiEDYDnpSAxXs8PI349uL4A3hqL5KSO
         e1celx5uilrES4T0WlxSRy5giPrlHehRV4NEk780iX+myM/MPzfZXg9+d3wLF5HZTI+0
         xIHPWDQ/JdjbcHqYIJOGGUufDLrvMRxUSQ1idA1U14MqVGVK7EGMM5A85+gpBalsP2nn
         yk7mQ99Isi0W0oyjPWNTIXdoZj9kfVb0raeK1DqC9xtRcVwFzBJK3u/R5KefvcEpcFjJ
         +tSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FZouSr9TAlelZRwtS6TKOdeYH1dxDyHrivrG4UWi6aY=;
        b=RQWb602hXkSu7cEv+31y4XOLvSdtY/5l2+3AUTZilVvAxvidjrI25zphlwa7bcvPcn
         xM14ZUSdzHErwnORxMFzp5Lh+rp62mu9aH9LoAknXN6DvgtS7o3SYe5mFEMwJV6WTInu
         ptONzEK2vCCuVJxLb7Yntiz9U0UhzDFeMpXbE/H1mmFJPwHQFwnC/CgSwsRvHjADBdEF
         LHp9D6Rd7t0FUDEiap02ZXwcVxajR0cm3CrWxg/mAf1Oro30OapkrZ7/pnME8ms3V1cs
         P7qTzYKcpbNhU/OCJcc6JqgiBbEkD149ccdEbImB2Ed4amUoZBPaCvITBMyOnT5W3gPG
         rleQ==
X-Gm-Message-State: AOAM532ijqLB5KvayvbyRVdO2GwKVtP4n8oP9iM0i0SzLVKkJsLJYyoP
        hYbx+sFfaGfLWEs7uUrBvTfpyA==
X-Google-Smtp-Source: ABdhPJwBdBPkz8G0TIYzxSkkmqHgn6ds8XO8ZxbMCK49rP+RL4F0T2bMG7KCVBpwABoxWWoJIJRAUQ==
X-Received: by 2002:a05:6a00:1956:: with SMTP id s22mr397112pfk.48.1643235532791;
        Wed, 26 Jan 2022 14:18:52 -0800 (PST)
Received: from localhost.localdomain ([2401:4900:1f3a:4e9b:8fa7:36dc:a805:c73f])
        by smtp.gmail.com with ESMTPSA id t17sm4233742pgm.69.2022.01.26.14.18.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 14:18:52 -0800 (PST)
From:   Bhupesh Sharma <bhupesh.sharma@linaro.org>
To:     linux-arm-msm@vger.kernel.org
Cc:     bhupesh.sharma@linaro.org, bhupesh.linux@gmail.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        robh+dt@kernel.org, agross@kernel.org, sboyd@kernel.org,
        tdas@codeaurora.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, bjorn.andersson@linaro.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 8/8] clk: qcom: gcc-sm8150: Use PWRSTS_ON (only) as a workaround for emac gdsc
Date:   Thu, 27 Jan 2022 03:47:25 +0530
Message-Id: <20220126221725.710167-9-bhupesh.sharma@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
References: <20220126221725.710167-1-bhupesh.sharma@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

EMAC GDSC currently has issues (seen on SA8155p-ADP) when its
turn'ed ON, once its already in OFF state. So, use PWRSTS_ON
state (only) as a workaround for now.

Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bhupesh Sharma <bhupesh.sharma@linaro.org>
---
 drivers/clk/qcom/gcc-sm8150.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-sm8150.c b/drivers/clk/qcom/gcc-sm8150.c
index 2e71afed81fd..fd7e931d3c09 100644
--- a/drivers/clk/qcom/gcc-sm8150.c
+++ b/drivers/clk/qcom/gcc-sm8150.c
@@ -3449,12 +3449,16 @@ static struct clk_branch gcc_video_xo_clk = {
 	},
 };
 
+/* To Do: EMAC GDSC currently has issues when its turn'ed ON, once
+ * its already in OFF state. So use PWRSTS_ON state (only) as a
+ * workaround for now.
+ */
 static struct gdsc emac_gdsc = {
 	.gdscr = 0x6004,
 	.pd = {
 		.name = "emac_gdsc",
 	},
-	.pwrsts = PWRSTS_OFF_ON,
+	.pwrsts = PWRSTS_ON,
 	.flags = POLL_CFG_GDSCR,
 };
 
-- 
2.34.1

