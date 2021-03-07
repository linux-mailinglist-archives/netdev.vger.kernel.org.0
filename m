Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2878632FFA5
	for <lists+netdev@lfdr.de>; Sun,  7 Mar 2021 09:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhCGIfF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Mar 2021 03:35:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbhCGIe7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Mar 2021 03:34:59 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D3A0C06174A;
        Sun,  7 Mar 2021 00:34:59 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id o38so4388862pgm.9;
        Sun, 07 Mar 2021 00:34:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Ztm3kMmO9foaT7tkUJFO2YdMILbFbAnDhEHXV2g/J4w=;
        b=NJfBKm+6Po22NyGTrZqqEVmEdEdNe+GTidqjmEHd716kY6jxMvgBzSwkpnaTI77CtW
         JWHi8stDcqW/bJtC7/luFcI9f5Os5LmJw4snh6bikdIqOEfLSmNcMikTolRd6wotD34V
         J03OhLtLPoMP9pP21hYJN1+VS+pTxPuzwmQ8y6+fIlyLAMZLtfqiESrd6NxOdK0EeaDp
         AadGekm+9mRbu8OzMoqhwZcevH4jFMi837azJda0h/u4EcgC0kh2huL0y00kRyYWXfah
         aEcUQLsfXJ92j0FmJajL6EUu0r55zhbzpULw5a539NaMcaYXYr/BHoX4c7/RHGf5zTEM
         cM7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Ztm3kMmO9foaT7tkUJFO2YdMILbFbAnDhEHXV2g/J4w=;
        b=WxnZL9fKQmMMytzb7BeM1eGe935vCvA1nfsM34pU7bWET8THaqYl/Fi6M+PB54zaGi
         3IS+18G0OPpM/a+AgVL+b8hzvazeJ5ZlcVwXrDjpvVIbhg+eWIr0RS+oNz06ngNkYNvx
         EI/qqVVW7OXLJulzt0anMFnp4ro+Y2yf4mDbdvBKDPwnXyGOseLfVpg7gz9kgchMPb5B
         DWxfVp5Pg7JuvN/ZZ48wLZHzWFvcgLftOFKYcNTr/AdiQlFcAWI4M5KUbYBepmy0hj0f
         ZB1Wjth0HG+Kux+JV8DbZyTxvxDH8jfP0mV3ysHf0aDTTILN3HjodJjJukjBEHBWljzf
         thzw==
X-Gm-Message-State: AOAM532AxyqYRbzp8w1F3h4xh17UtrHfgN5L4MsWMBbrDzJnnZUJHKVM
        6cgIAXARnPR3LlgnS4xX62s=
X-Google-Smtp-Source: ABdhPJybCcPmwbuOYWbrYhW2kHIrHuCrDvfX/nvpR5jnAaXI3Xa0YmksH8Y+lKaOZJmJeoyoy7h3+Q==
X-Received: by 2002:a65:524b:: with SMTP id q11mr15570433pgp.207.1615106098837;
        Sun, 07 Mar 2021 00:34:58 -0800 (PST)
Received: from localhost.localdomain ([45.135.186.66])
        by smtp.gmail.com with ESMTPSA id h6sm6747519pfv.84.2021.03.07.00.34.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Mar 2021 00:34:58 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] rsi: fix error return code of rsi_load_9116_firmware()
Date:   Sun,  7 Mar 2021 00:34:45 -0800
Message-Id: <20210307083445.21322-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When kmemdup() returns NULL to ta_firmware, no error return code of
rsi_load_9116_firmware() is assigned.
To fix this bug, status is assigned with -ENOMEM in this case.

Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index ce9892152f4d..32ecb8b3d6c5 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -1038,8 +1038,10 @@ static int rsi_load_9116_firmware(struct rsi_hw *adapter)
 	}
 
 	ta_firmware = kmemdup(fw_entry->data, fw_entry->size, GFP_KERNEL);
-	if (!ta_firmware)
+	if (!ta_firmware) {
+		status = -ENOMEM;
 		goto fail_release_fw;
+	}
 	fw_p = ta_firmware;
 	instructions_sz = fw_entry->size;
 	rsi_dbg(INFO_ZONE, "FW Length = %d bytes\n", instructions_sz);
-- 
2.17.1

