Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A63F41248DC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727089AbfLROBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:01:13 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40261 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfLROBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:01:13 -0500
Received: by mail-pf1-f194.google.com with SMTP id q8so1261761pfh.7;
        Wed, 18 Dec 2019 06:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=DFCnoBm3aJ4yBdlgfovQA6oA3BnQmF1k6xZZgru1lck=;
        b=B20ej4mZOi5gLgjfFgNoUVSHyV8P35/33fTDKxA5YmemAVZk5Qdmcm92RshrqEa7Sk
         sTPnUSpSauLGWD+Db556aQJmSwl0ZAZ14YM4lgRYuQ1Gvtj6cShj2I8Ne/m54goqNaDO
         1XqsfwezGHEcyMpJa0LKFjQEF4hdhCMxigdl/fkJpryRTTJnnQgQspoiqRFi7XrQ4BYc
         GxZyTHeT2leu91F8pvWyhan6TqK6iFXvvbp8iN90NZnvuuyO3lzgT6oRVtrkh89GPjHc
         Zp2V223j0Y/xLuREkjMRGB6ekUZsas8uA4Qc3E7eknGZyE19voXRGGhsRb0kgNn8nECy
         hLmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DFCnoBm3aJ4yBdlgfovQA6oA3BnQmF1k6xZZgru1lck=;
        b=Yrab/qHk32of2WpUg1PEn4tiQ5p7i6sZqrXnwlz8Ht+NcCb7mH7EfMxnM9RZ0yI3qh
         T5zfmOBEKhg+cyfuvVIIbnUgOSLbxzHOXuSIeiBs9IoeLj5t/PtlZ5DrTTMiw1oAuvBg
         wttxJpHqFgtAfrBJrPySatLsHT3ZB4xXH69WcV06ZLW+Mu8mevuSnjMrEf7ouVyOsE5c
         +eOqDGHvVlscallU0VbguSKQMCnlfa6lTxMw3zx0nQefeejo0gdj/ooE1OSmPi5qnEpL
         JSC9jVhc75o4ywNkvgpO15OTdNWKKrvOjZFJi/K4DgSAKZm/3XNm4aS4ZHkg1eJS9MJv
         ZVXA==
X-Gm-Message-State: APjAAAUpfO2ovUVpj+Rg0xuv0BBZYZZIO2Xo0rIvc6wvaY9b0FdZrJbw
        NN35gAkwlV8AFtDRoN+NIFk=
X-Google-Smtp-Source: APXvYqwxjCJcdPd2xsTBHgah7u883gmPlr5xfXoWL1tYk7k1Gb2MINKxCgQnpEygPSN6qgrhCUOh/w==
X-Received: by 2002:a63:f455:: with SMTP id p21mr3198893pgk.436.1576677672115;
        Wed, 18 Dec 2019 06:01:12 -0800 (PST)
Received: from oslab.tsinghua.edu.cn ([166.111.139.172])
        by smtp.gmail.com with ESMTPSA id l66sm3486691pga.30.2019.12.18.06.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:01:11 -0800 (PST)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
To:     thomas.lendacky@amd.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [PATCH] net: amd: xgbe: fix possible sleep-in-atomic-context bugs in xgbe_powerdown()
Date:   Wed, 18 Dec 2019 22:01:02 +0800
Message-Id: <20191218140102.11579-1-baijiaju1990@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The driver may sleep while holding a spinlock.
The function call path (from bottom to top) in Linux 4.19 is:

drivers/net/ethernet/amd/xgbe/xgbe-drv.c, 1261: 
	flush_workqueue in xgbe_powerdown
drivers/net/ethernet/amd/xgbe/xgbe-drv.c, 1253: 
	_raw_spin_lock_irqsave in xgbe_powerdown

drivers/net/ethernet/amd/xgbe/xgbe-drv.c, 1055: 
	napi_disable in xgbe_napi_disable
drivers/net/ethernet/amd/xgbe/xgbe-drv.c, 1266: 
	xgbe_napi_disable in xgbe_powerdown
drivers/net/ethernet/amd/xgbe/xgbe-drv.c, 1253: 
	_raw_spin_lock_irqsave in xgbe_powerdown

drivers/net/ethernet/amd/xgbe/xgbe-drv.c, 1049: 
	napi_disable in xgbe_napi_disable
drivers/net/ethernet/amd/xgbe/xgbe-drv.c, 1266: 
	xgbe_napi_disable in xgbe_powerdown
drivers/net/ethernet/amd/xgbe/xgbe-drv.c, 1253: 
	_raw_spin_lock_irqsave in xgbe_powerdown

flush_workqueue() and napi_disable() can sleep at runtime.

To fix these bugs, flush_workqueue() and xgbe_napi_disable() are called
without holding the spinlock.

These bugs are found by a static analysis tool STCheck written by
myself.

Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 98f8f2033154..328361d0e190 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1257,17 +1257,18 @@ int xgbe_powerdown(struct net_device *netdev, unsigned int caller)
 	netif_tx_stop_all_queues(netdev);
 
 	xgbe_stop_timers(pdata);
-	flush_workqueue(pdata->dev_workqueue);
 
 	hw_if->powerdown_tx(pdata);
 	hw_if->powerdown_rx(pdata);
 
-	xgbe_napi_disable(pdata, 0);
-
 	pdata->power_down = 1;
 
 	spin_unlock_irqrestore(&pdata->lock, flags);
 
+	flush_workqueue(pdata->dev_workqueue);
+
+	xgbe_napi_disable(pdata, 0);
+
 	DBGPR("<--xgbe_powerdown\n");
 
 	return 0;
-- 
2.17.1

