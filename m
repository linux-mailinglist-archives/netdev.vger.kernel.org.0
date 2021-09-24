Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3762D416EDB
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 11:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244964AbhIXJ2h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 05:28:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244448AbhIXJ2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 05:28:35 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C40E0C061574
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 02:27:02 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id s17so15046646edd.8
        for <netdev@vger.kernel.org>; Fri, 24 Sep 2021 02:27:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=pwdn27noakX7t/4lkAC9y0R8DTcQut1TWzEnNLZLsYE=;
        b=MnZmc0J0uJNcOrFPqAWxu+3iSMVQNl+zsfaSGdnYhuFq/9DahztihHvvXDZSehwsn7
         E2oqW4RDUTs8y4/G3FjlAPnJ341Iiv6HjZlMcPNIrmv01YNGFO/nEJYYJdmpwGbV1E2A
         hrmSBk2TK5WD7ycOhNpAoh8p9unQmOn1sKOq3FDAceJ5XaVS//t9W3/1jeIcJENqGJNF
         5V7U5w9zlhQP7hv31Ujh+erDGaWvLWd31PtAc7fYRHcB2y5vWn5fIVpffLTY+bU5mDW+
         IpN6LMd2pvw5VU2wIVSQmhWXbcXNop7LvrlPbYwzxu0RUjoFkPo9uEfHecHmmCebAOh8
         9Ssw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=pwdn27noakX7t/4lkAC9y0R8DTcQut1TWzEnNLZLsYE=;
        b=2/QPHvtoHfg67xo0QWHzlRdeDC6aEe69UNKzcEc82v7pT59jWfjm3D3YPEoU2655oh
         DT4Vyc/tfVJ3fhHLgl7b47nmv1S/h9TUtsxzfOBzBTRVDI2G2br9RicCTb9+gHc/CE9R
         wwql6a9PZr8/81oth2hvPCdvbDDhhMDQWoI0JLqHQwYM2e3l63uHn9MQ0C0+EOgq7OtN
         cZE9hlA7IQiRuDw/3icclkjxl8wU/tINSivc9qqEjrlN0MuqDrjPnPK+e8Gs2LTsswTw
         xlJJuY7ieLD7YOjEYC85dcft37Ws5Cmk0QoVTfLsmQc1HthdcU7j3hCpsuGG1qdLLAe/
         fyLA==
X-Gm-Message-State: AOAM533nHndOBQkViptTAkiqn48IdoC2wQWP2/UsQKa9juG13VXmuXSs
        +6UmO/CPQXe1lNsAjZxF3cU9oRx7HjjS8w==
X-Google-Smtp-Source: ABdhPJwpiRwaMu/pLQI2UNJAhGieCNxx3Mnepjruj04BwSWdrd6e5aWHt9VCEFehYAadWiyQ+xEvdQ==
X-Received: by 2002:a17:906:90c9:: with SMTP id v9mr9844467ejw.356.1632475621185;
        Fri, 24 Sep 2021 02:27:01 -0700 (PDT)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id b14sm5401350edy.56.2021.09.24.02.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 02:27:00 -0700 (PDT)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 1/1] drivers: net: mhi: fix error path in mhi_net_newlink
Date:   Fri, 24 Sep 2021 11:26:52 +0200
Message-Id: <20210924092652.3707-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix double free_netdev when mhi_prepare_for_transfer fails.

Fixes: 3ffec6a14f24 ("net: Add mhi-net driver")
Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
---
 drivers/net/mhi_net.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index d127eb6e9257..aaa628f859fd 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -321,7 +321,7 @@ static int mhi_net_newlink(struct mhi_device *mhi_dev, struct net_device *ndev)
 	/* Start MHI channels */
 	err = mhi_prepare_for_transfer(mhi_dev);
 	if (err)
-		goto out_err;
+		return err;
 
 	/* Number of transfer descriptors determines size of the queue */
 	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
@@ -331,10 +331,6 @@ static int mhi_net_newlink(struct mhi_device *mhi_dev, struct net_device *ndev)
 		return err;
 
 	return 0;
-
-out_err:
-	free_netdev(ndev);
-	return err;
 }
 
 static void mhi_net_dellink(struct mhi_device *mhi_dev, struct net_device *ndev)
-- 
2.30.2

