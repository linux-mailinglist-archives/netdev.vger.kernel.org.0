Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F282D58F3
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 12:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733047AbgLJLJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 06:09:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732271AbgLJLJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 06:09:32 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84EF8C06179C
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 03:08:51 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id e25so4871223wme.0
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 03:08:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ipm7OLjcu7urJ6wZYaP0vWF1v1t82ROFjhYMYBWsWNE=;
        b=leqkZDg9rxADeTvThrR9J36plCvo8ZWUw4skR2U66CqZTKOtdzsOaCPnAQGAshozrO
         MqL0vohkgCYBPrZSpFpltMd/86C+G3Xf9MQHRh4I+YrZ2yM7dXHtx9ECQJ8ntyZaeyWZ
         DFA9PbwuPuhjoq+RW+xDl1aVEBuas/D55Ql8EzRhh+7Vq893yHPzPXS3TgTkD6gNJwDY
         DWraVEpoi3jGbS6QJlaSnJZ9j15/ER/9xMOoRG7rFVRQG5N56NN5hrIdjHDw/VdUZjAA
         95kkTGcghOU7IzcN75qhBAbSyCApYXGs+n2TWZkxJP2P4QBmasrb1WPCJwyoe5kdkH8e
         WjSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ipm7OLjcu7urJ6wZYaP0vWF1v1t82ROFjhYMYBWsWNE=;
        b=Ir7LahRebom3Nz6KVh/eBbzZ0w+dHgoIy3W48QhHMSOTbN5/qIAS0SOr/t2gEZto8F
         zb5WDhi6Fi5wra+1kutaExNXTivlwhmzNWgJsX32RnW/drxxSLaCm/vQDiFpUtUypHqn
         H0gbKsNkFhvwzm11NTxO7E/4aIynxgVG8viUbr8iw1CE9L36U2tBhkb16Fqy8DAg7vIm
         pgv1d8D4go50PKZo1UWO+AAXN8ETqr8fonR3WitT9DLg8U1pM1AHE1hxCQUQbsFUpoKN
         x3re+2lUmgS/sJrC0ouJwcze/3SFA591Xc8boq0R5vTyBbUCSBv9ZVTinRHZpEElNdUc
         jCoQ==
X-Gm-Message-State: AOAM533yMVE9AYBhKo+V+62IJj8EQGc+Zz6hBfWjZ8oBHhQ1a2PcXDcT
        uwlrVR29s/ImkhqjLZrYtQynUA==
X-Google-Smtp-Source: ABdhPJxhepATf6eciKoYilkXNk66Erurabmb2/fX8Btd2JJ58ELusqrCXzmxH2O2Yfd5QmaaN0o+fQ==
X-Received: by 2002:a1c:25c3:: with SMTP id l186mr7304637wml.113.1607598530322;
        Thu, 10 Dec 2020 03:08:50 -0800 (PST)
Received: from localhost.localdomain ([2a01:e0a:490:8730:4468:1cc2:be0c:233f])
        by smtp.gmail.com with ESMTPSA id n123sm8961809wmn.7.2020.12.10.03.08.49
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Dec 2020 03:08:49 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kuba@kernel.org, davem@davemloft.net
Cc:     manivannan.sadhasivam@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, jhugo@codeaurora.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH v2 2/3] net: mhi: Get RX queue size from MHI core
Date:   Thu, 10 Dec 2020 12:15:50 +0100
Message-Id: <1607598951-2340-2-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
References: <1607598951-2340-1-git-send-email-loic.poulain@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The RX queue size can be determined at runtime by retrieving the
number of available transfer descriptors.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 v2: Fixed commit message typo

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

