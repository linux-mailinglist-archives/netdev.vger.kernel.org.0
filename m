Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08ABA31A0B3
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 15:37:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhBLOfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 09:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbhBLOfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 09:35:30 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4090BC06178A
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 06:34:09 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id e24so9485211ioc.1
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 06:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=v3Lvt9FFJHAgc4CH+AJ2/GzMVHRqoRH1kZFxTe5Ya9c=;
        b=loM0zEcwE53gIO6GfFp/r27LVbl+e3g8ab0FC11KZ9pJqDEBhUnOXKtobAdUeSdrXF
         xru7IoFTE4kKHcjywxHLXYSgfd7FqntpTIlWTPO9YYG1Rtnga1zBblfwgklcJ+/aqYNj
         RLfHgddrb0K2uMMZAIpNzXGyl9363c7B6AwzVzJYi27T9c5f1Yr3rjDYXauLZ4o2MpXH
         A5AtMmDUR4cKlpAJ314J7Vpj2I3oVxWlDeyYww2o47Zlouh6dJRnnUFFcV1gS7iLOcze
         BOPxnTzWD+TZ5ErTOIEmtZrBnREelyEe8GSL6R8eBqWuigMpd4wQnMhXqadC2r8b6VuR
         +dsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=v3Lvt9FFJHAgc4CH+AJ2/GzMVHRqoRH1kZFxTe5Ya9c=;
        b=S4I3GfSiSrRD689AsZ7Xgno2Uj1G09aOqQbFchmM32g63onvnJfUOTw5BmtSw6dc+z
         iee44FOA14Qp6rulLUeDVJZKYCuM4SW797ec2TxlZNQtatrIXThbCMWMHb7WxRh0OEgv
         Ku7MwxLJSZPIwCQM2PQlrvZwwtLLgZr9usNIUH3NJvqlaPlL6avytPgF82K67GEj+BGk
         n+5Ht0fTUe4yLqO9YAY4LchpadeuyVABf4M1yswWGOLX0HPLy15K4Mb7bOobS2+MOZqp
         jiyq6saBOlxPW4RptOOK1+CNZWRNYbpKiUCCnmbqjfA6onf2J8qzbbamwHSey504FxhW
         HjKQ==
X-Gm-Message-State: AOAM531wx/DbsX6ks5JN++hkbIuoXuR9QQkwi3UAtRwPDZkc8I68DyiJ
        stWos67VXebz/1LYDR/f/uD6ag==
X-Google-Smtp-Source: ABdhPJzo+XhRzoT1lJOu4Qa1eRdxE7hux//SB4EdwE6GhhO3JVa3iLtge++zvFQ0lq6Vzh1N2qBpzw==
X-Received: by 2002:a6b:ee07:: with SMTP id i7mr2290856ioh.87.1613140448743;
        Fri, 12 Feb 2021 06:34:08 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j12sm4387878ila.75.2021.02.12.06.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 06:34:08 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, hkallweit1@gmail.com, evgreen@chromium.org,
        bjorn.andersson@linaro.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 net-next 2/5] net: ipa: use dev_err_probe() in ipa_clock.c
Date:   Fri, 12 Feb 2021 08:33:59 -0600
Message-Id: <20210212143402.2691-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210212143402.2691-1-elder@linaro.org>
References: <20210212143402.2691-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When initializing the IPA core clock and interconnects, it's
possible we'll get an EPROBE_DEFER error.  This isn't really an
error, it's just means we need to be re-probed later.

Use dev_err_probe() to report the error rather than dev_err().
This avoids polluting the log with these "error" messages.

Signed-off-by: Alex Elder <elder@linaro.org>
---
v3: - Use dev_err_probe(), as suggested by Heiner Kallweit.
v2: - Update copyright.

 drivers/net/ipa/ipa_clock.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 354675a643db5..69ef6ea41e619 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 
 #include <linux/refcount.h>
@@ -68,8 +68,8 @@ static int ipa_interconnect_init_one(struct device *dev,
 	if (IS_ERR(path)) {
 		int ret = PTR_ERR(path);
 
-		dev_err(dev, "error %d getting %s interconnect\n", ret,
-			data->name);
+		dev_err_probe(dev, ret, "error getting %s interconnect\n",
+			      data->name);
 
 		return ret;
 	}
@@ -281,7 +281,8 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 
 	clk = clk_get(dev, "core");
 	if (IS_ERR(clk)) {
-		dev_err(dev, "error %ld getting core clock\n", PTR_ERR(clk));
+		dev_err_probe(dev, PTR_ERR(clk), "error getting core clock\n");
+
 		return ERR_CAST(clk);
 	}
 
-- 
2.20.1

