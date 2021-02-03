Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE1430D20C
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 04:20:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232462AbhBCDR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 22:17:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232754AbhBCDN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Feb 2021 22:13:56 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D94CC06178B;
        Tue,  2 Feb 2021 19:13:59 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id p15so20433105ilq.8;
        Tue, 02 Feb 2021 19:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=XnToDhqvOGorj7hvZSnusu9WNXJGjBnLUH5yiwRdgu8=;
        b=TjH+OsffVeBJvXrguAJHZxd2D0liB08aV+e7ykeL8ClVhFBAv1JCgzd/B2kAKySntx
         fS4eDW4bZY5f076oA1jEQewiXvSiL2Upr88GMMRjmH1o6gypfRNOnp7dTVeCOaWX0c+w
         4CorVVS4tc8d53eFaDNnlG2jmXSri03MyGoTEnIvaf0FCQhtbXajQ0Yw0QWoW9h/rbxO
         dppNP010cYvlUaTDTb+VRrAwl0No54tnwBY5nkVL2+lXL5GX6HJRDSXp/AQ8LSEf81em
         Mnye9Rw6BMA4EaYL9HdkQs4F7aDWKtjTWkYsn+Dozp+ouZ+EqEQsDHXc5lXuUWInoKav
         DAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=XnToDhqvOGorj7hvZSnusu9WNXJGjBnLUH5yiwRdgu8=;
        b=KfrwKlgVz9yV2I9OVy9zT/E59FKyGbdc8+NXyW/1kRlS6Q1UVsKVKMEQyIVswB3FhJ
         Z/jPubbMAg0bhgV5rJ7bbXC/20nWPZfX7AwfYWbqFJduu4ggIyD07oGxJ506/CcfgJCY
         ySc/eTQ1q5mEMhYEKirTGcQJPomhugvGTABq3p6rS51FpiSOdumtkxpbVHMD4GCpiBkP
         gSuUJ3pV/Z4/YMB2XvPhSk6kn7fOUzHIr8jMx2FkIE14js9GjVnPJXhyAh822rr+p/IO
         L7apd+wr9xMNaFIrBhNDf+3CtaXonSohPgxv5nwhwhg+1l3cxDVVoAFW3088R31douhK
         T+eg==
X-Gm-Message-State: AOAM5332yEe5/pY85lDx7iFuZY9Y/qLkdGWPSnjn6bHtr/vqA0256jiM
        UdUCzwcLNpAsY2TjJLKXTFX/MNJF3lEiXlNz
X-Google-Smtp-Source: ABdhPJyMr7+tYlDvAU+h2vOwodlBsOLXTHP5PJ4wHA4CqIXDTByfa9t74X0a2Ui/32O7DxV7Em22IQ==
X-Received: by 2002:a05:6e02:b2c:: with SMTP id e12mr1023773ilu.143.1612322038719;
        Tue, 02 Feb 2021 19:13:58 -0800 (PST)
Received: from spring-Precision-5820-Tower.cs.umn.edu ([2607:ea00:101:3c74:297f:a8c4:e9e5:62a4])
        by smtp.gmail.com with ESMTPSA id w9sm453709ioj.0.2021.02.02.19.13.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 Feb 2021 19:13:58 -0800 (PST)
From:   Wenjia Zhao <driverfuzzing@gmail.com>
Cc:     driverfuzzing@gmail.com, Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] net: hns3: double free 'skb'
Date:   Tue,  2 Feb 2021 21:13:43 -0600
Message-Id: <1612322024-93322-1-git-send-email-driverfuzzing@gmail.com>
X-Mailer: git-send-email 2.7.4
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net: hns3: double free 'skb'

The false branch of (tx_ret == NETDEV_TX_OK) free the skb. However, the
kfree_skb(skb) in the out label will be execute when exits the function.
So the skb has a double-free bugs.

Remove the kfree_skb(skb) at line 269

Signed-off-by: Wenjia Zhao <driverfuzzing@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
index 2622e04..1b926ff 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c
@@ -266,7 +266,6 @@ static int hns3_lp_run_test(struct net_device *ndev, enum hnae3_loop mode)
 		if (tx_ret == NETDEV_TX_OK) {
 			good_cnt++;
 		} else {
-			kfree_skb(skb);
 			netdev_err(ndev, "hns3_lb_run_test xmit failed: %d\n",
 				   tx_ret);
 		}
-- 
2.7.4

