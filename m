Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C292F31950B
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 22:22:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhBKVUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 16:20:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhBKVUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 16:20:33 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65A56C06178A
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:19:33 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id u8so7191771ior.13
        for <netdev@vger.kernel.org>; Thu, 11 Feb 2021 13:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cH4qjKY0CS8cPWsSWSIfB/XmNwAKP+9ETXOQq1WP0+o=;
        b=j2q608rJJFE+nLbZ3vJpb510PbN918XLbfooaDSSYI6GuTE/UF93JfR3B5LwQTTFxP
         7veyTPNG6WRMMoLkm3oRjH1H8GMiyfjIuXV68XJfnlvu2Yk6ZkPOGUHJE1zJJXO3zhy6
         348tcI0DbxjG/x/fQ4SMH8YV45JrB1DoOqXjnLmuPF+C9LYsYZMhxWfmisg0SAfBMM4Z
         nfpOq+2e/8jPHlRg2CyTSqBcNUoe8LO3yFnmem4ThMfYzc+FGm0GyS9kelhApIj3OZrS
         n3Ms5UHmi3qqwdQ+UR8SGL8qpZ+1cFsancrcl33ePmMVBAQWzp6kzlX8ho+b3HtVOUjW
         G9qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cH4qjKY0CS8cPWsSWSIfB/XmNwAKP+9ETXOQq1WP0+o=;
        b=a06neAbcMZHlN7sXrODD/g6pnHq0rhSDSCmM5xH/Owk3Wu3Dk3wsaeaH9MqkfQuGjH
         NBhNjL3nTXCNjGz0ZsBmkoI48S5aDdzzHYbcSsUk+6Y8w22xuRCgW2R+s+GNEI9eTAYG
         FTR5/miMOxB69WR0iqbZUS8m6AULR27vrEehAaSQivpS9iHkdoPJmGBbeZvdajWP0SV9
         4pn1H2KNj3G1dih+QK0ZBuNgW7hps0Ef0S7qvX8dV/fuJVZ+fgdUK4pfrv3xX3EmTJD/
         O5tIGcyd2wZfdnucj5aF0Bl/YjfGgYUiW6X1P12eeHr1Gd6ugycKamf10JFRfraWRyob
         hiwQ==
X-Gm-Message-State: AOAM532091OlS7KlR/YSg23o7SVm05a6E/GmTtqylrrqQdYfRwMXnQ0S
        HhYLv68Zop7Q30lsLAOPmt+38Q==
X-Google-Smtp-Source: ABdhPJyHi0jpvZQRcM2ThmuxoElLYv2QeWBKH88pRAEiGwCzLXgsdusDB3U3V9DizoCZeqjRv5UofQ==
X-Received: by 2002:a5e:9409:: with SMTP id q9mr7011153ioj.54.1613078372886;
        Thu, 11 Feb 2021 13:19:32 -0800 (PST)
Received: from beast.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id j10sm3155718ilc.50.2021.02.11.13.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 13:19:32 -0800 (PST)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     elder@kernel.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 net-next 2/5] net: ipa: don't report EPROBE_DEFER error
Date:   Thu, 11 Feb 2021 15:19:24 -0600
Message-Id: <20210211211927.28061-3-elder@linaro.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210211211927.28061-1-elder@linaro.org>
References: <20210211211927.28061-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When initializing the IPA core clock and interconnects, it's
possible we'll get an EPROBE_DEFER error.  This isn't really an
error, it's just means we need to be re-probed later.

Check the return code when initializing these, and if it's
EPROBE_DEFER, skip printing the error message.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/ipa_clock.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_clock.c
index 354675a643db5..238a713f6b604 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_clock.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2021 Linaro Ltd.
  */
 
 #include <linux/refcount.h>
@@ -68,8 +68,9 @@ static int ipa_interconnect_init_one(struct device *dev,
 	if (IS_ERR(path)) {
 		int ret = PTR_ERR(path);
 
-		dev_err(dev, "error %d getting %s interconnect\n", ret,
-			data->name);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "error %d getting %s interconnect\n", ret,
+				data->name);
 
 		return ret;
 	}
@@ -281,7 +282,10 @@ ipa_clock_init(struct device *dev, const struct ipa_clock_data *data)
 
 	clk = clk_get(dev, "core");
 	if (IS_ERR(clk)) {
-		dev_err(dev, "error %ld getting core clock\n", PTR_ERR(clk));
+		ret = PTR_ERR(clk);
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "error %d getting core clock\n", ret);
+
 		return ERR_CAST(clk);
 	}
 
-- 
2.20.1

