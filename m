Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72EBF462B83
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 05:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhK3EJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 23:09:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhK3EJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 23:09:26 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99904C061574;
        Mon, 29 Nov 2021 20:06:07 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id r5so18267335pgi.6;
        Mon, 29 Nov 2021 20:06:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/3sipgFsYx4nTsFXeXnXh9bfVECakyAq+Xo8bhn0cKY=;
        b=YNf/8WTZMctueICeEPTxKNFxLOdExgc4YxHwmBHxsyhZDOB37kpS/gwJqnLRj6pzbb
         7vjcFY8LuS1I4wGU3b1W3fByvWUrcKg9bdjYTtFF7eQLK02+rZ4w899N5YxGo47vMnMM
         DRBwHHYa8WyZDqAiDfggpdGkujtN+g+MAHn4qDInqp8+/Eu9dBtNBwrPCobtylSsBEkk
         hZDQ6j1oiqu2gfkHC4ZMVHdBTkVPXP+6iYOBmz1X0yGRQItDadLpySYPzdVjxw8F3RQm
         q2xf915EwI0av7kDHuBpeuhPpSDF0XYyP7APzhxPRip84y39d5F2Q74LAldvNantTNnT
         VzAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/3sipgFsYx4nTsFXeXnXh9bfVECakyAq+Xo8bhn0cKY=;
        b=KF4+YVNBmZKthkEXURItO5pDUc/Lc6j8DrZzk22DLHGd48hSRV10hEhKQ9tmpscZZP
         gqFMm3vsQTrXvEWiS/2+r6YDadgOk5/u+RC/WmhPhIsrEMXAvvHrcvU4vt0mLZ+CsOPZ
         lNcW/J25ymgrgp3vapwWH5iotXpBxGGME3tkRK7jNIUVnZSPDq6qmXZ85CAt7l2wP/Mk
         3rqFLodNZzIClNAofFEC40xVSkcOGuwKWTKr2cUy2f0aVhPtlwATmRvslyXOxm3WbXUm
         UmDhH1TM2ebvDRbW1cNFwhQS47g8Db3QX8jjIQ7ovWTm3zjh9QW/7AZm94lYb29IcsuN
         ktOQ==
X-Gm-Message-State: AOAM530dg6ILeQf+AhFO1XXEaJ393B3fbvjxv5F2N8d8E8WGUmR3+IzC
        AZx93EZgsasAstHSyENCxgI=
X-Google-Smtp-Source: ABdhPJwgmi0fWes54vGJMTyaEVxmZV86S5SM8EKRgEg2RclJoumK0u6HH4iSRag8Kgp7VE0otm9R2Q==
X-Received: by 2002:a05:6a00:1594:b0:49f:c5f0:19df with SMTP id u20-20020a056a00159400b0049fc5f019dfmr43134007pfk.70.1638245166942;
        Mon, 29 Nov 2021 20:06:06 -0800 (PST)
Received: from localhost.localdomain ([94.177.118.4])
        by smtp.gmail.com with ESMTPSA id s15sm748299pjs.51.2021.11.29.20.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 20:06:06 -0800 (PST)
From:   Dongliang Mu <mudongliangabcd@gmail.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Yangbo Lu <yangbo.lu@nxp.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dpaa2-eth: destroy workqueue at the end of remove function
Date:   Tue, 30 Nov 2021 12:05:54 +0800
Message-Id: <20211130040554.868846-1-mudongliangabcd@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit c55211892f46 ("dpaa2-eth: support PTP Sync packet one-step
timestamping") forgets to destroy workqueue at the end of remove
function.

Fix this by adding destroy_workqueue before fsl_mc_portal_free and
free_netdev.

Fixes: c55211892f46 ("dpaa2-eth: support PTP Sync packet one-step timestamping")
Signed-off-by: Dongliang Mu <mudongliangabcd@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
index 6451c8383639..8e643567abce 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
@@ -4550,6 +4550,8 @@ static int dpaa2_eth_remove(struct fsl_mc_device *ls_dev)
 
 	fsl_mc_portal_free(priv->mc_io);
 
+	destroy_workqueue(priv->dpaa2_ptp_wq);
+
 	dev_dbg(net_dev->dev.parent, "Removed interface %s\n", net_dev->name);
 
 	free_netdev(net_dev);
-- 
2.25.1

