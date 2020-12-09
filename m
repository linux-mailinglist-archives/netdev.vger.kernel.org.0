Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023E72D44E7
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733311AbgLIO47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:56:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733310AbgLIO4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:56:43 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57694C061794
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 06:56:03 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id a3so1960436wmb.5
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ecliB25BkDl7EtZQbZOa7FY8xOJRTZHDugkajt346ps=;
        b=cM7DPz1e0wcHHZ9QaAHOeggqlWF/cZuUV42BMeczFGC5+e84TsMwJcw4tXIl9ns1kj
         L3aAJtygMKOM2wVxvo93uEq6Fq9MeJNcdCARhMQp07zoZWEUzyWQmFRYvwxCzYwdoIa5
         hF99N00s0iugtQkoBh2oOzmi8Cxat6/gWampLmDqBbroEZ3xhfh821B8RrNdVKAXhQeN
         H4J3B9Fx3xM2Z6i33jMTg1ASNtqDImExfHmlvwmkA5Bl6stHTYPqbNbh6/Ljl7bc6eGw
         0P4FMYYhaWdbfQXnOPACLDi/hZ6f1HwIqVjQnQDcLPniqeguWX/PXe+bpR18XIwprUGj
         q5wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ecliB25BkDl7EtZQbZOa7FY8xOJRTZHDugkajt346ps=;
        b=EcmUWbzuht9ajSacFRHT5TM5Td92oA5CuCTa6+cQXz3+Ah1pgbaTflxG39/NKKPbf4
         mAdA42SEWptd7BrzyWgnUDWz9JfuCqxnAK459nZKGAoCWTDqibhWWLFRaPjkRRILUCWa
         BfuwsvLwBk0U/HBJGY0KAfe6Fd6U6oCa0BDLr++KnsUSBRx/F1kKP3nJNt/sxNauvHhM
         iFZnFgdPpWbBXfLffTmiD3DmNmzXKCA7TUmijkEwwdKzEq+UIeWkaUesz/rYh3EV4dud
         GS0kEl45wAp29LyeFn5BgKy9gacOTcb7l00JGeH+Dc8MhUO+453h5zWm+zd5Gu0I0rsT
         i+SA==
X-Gm-Message-State: AOAM5305+ikTPXdXNZPgjYBXAU506JAmxZkctcL9VjFXn5+owbLvMZBL
        u6lMNquBE99nCg5FTwYbjVUFag==
X-Google-Smtp-Source: ABdhPJwbVyhyvERj8OwNjWetMWm4OEdK1qiCddorl/OduN1GwtyyVG7K2q3FLuwAnoRMsCCBqd5ajw==
X-Received: by 2002:a05:600c:410d:: with SMTP id j13mr3196810wmi.95.1607525761755;
        Wed, 09 Dec 2020 06:56:01 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:c728:53f6:5e7e:2f63])
        by smtp.gmail.com with ESMTPSA id i11sm3782219wrm.1.2020.12.09.06.56.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 09 Dec 2020 06:56:01 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org
Cc:     manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH 2/3] net: mhi: Get RX queue size from MHI core
Date:   Wed,  9 Dec 2020 16:03:02 +0100
Message-Id: <1607526183-25652-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607526183-25652-1-git-send-email-loic.poulain@linaro.org>
References: <1607526183-25652-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX queue size can be determined at runtime by retrieveing the
number of available transfer descriptors

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/mhi_net.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/mhi_net.c b/drivers/net/mhi_net.c
index 8e72d94..0333e07 100644
--- a/drivers/net/mhi_net.c
+++ b/drivers/net/mhi_net.c
@@ -256,9 +256,6 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	mhi_netdev->mdev = mhi_dev;
 	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 
-	/* All MHI net channels have 128 ring elements (at least for now) */
-	mhi_netdev->rx_queue_sz = 128;
-
 	INIT_DELAYED_WORK(&mhi_netdev->rx_refill, mhi_net_rx_refill_work);
 	u64_stats_init(&mhi_netdev->stats.rx_syncp);
 	u64_stats_init(&mhi_netdev->stats.tx_syncp);
@@ -268,6 +265,9 @@ static int mhi_net_probe(struct mhi_device *mhi_dev,
 	if (err)
 		goto out_err;
 
+	/* Number of transfer descriptors determines size of the queue */
+	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
+
 	err = register_netdev(ndev);
 	if (err)
 		goto out_err;
-- 
2.7.4

