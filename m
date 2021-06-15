Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15DAD3A7302
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 02:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhFOAcu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 20:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbhFOAcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 20:32:48 -0400
Received: from mail-lf1-x12c.google.com (mail-lf1-x12c.google.com [IPv6:2a00:1450:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF28BC0613A4
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:30 -0700 (PDT)
Received: by mail-lf1-x12c.google.com with SMTP id p17so23930319lfc.6
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 17:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XmeWAbPsSaBx+nU+8yJYFKGc/MDEqnOyHS9fhBTh5DI=;
        b=pCDKEo6hVU/EbsWnloeduAMgDTgpkbEU9IgTzxZXP+gzZNuJW/y0sUggNlIia30VLL
         aZZVUz24p4mHfhyUTsszpf8X5fSvVdCFBx0FS9YnuDY6Dlfbjo0enkxsj7fhjbhdj5zc
         WrF3ydnMv/WhRxlSDZsIS50AgrwwoXxPA5RCLEzmC4bBeb62p46jtNVjut2WBEzUcFXY
         HaPM6uRAtwH47836MYhX0aRNM/3zU8YIsMkuUw9bYb/RDWGZvfZ3XEFltGWD5YXfTrSv
         QAXF53Rqugt1i24z46iBgPKqAcBXE5pLjt+Q1SkVZPYM32R6pmina+QA1H9th0aOTy9k
         YEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XmeWAbPsSaBx+nU+8yJYFKGc/MDEqnOyHS9fhBTh5DI=;
        b=rJmTU2YNseKYqCtfkqDybUh4gWSDkrD0S7IbtpE2ndazhjQHR5SNraE6lftv3DN7Wx
         hwFQpiDspbM8yEmcPwAbwGxZcd9meCAv9/P7YPZImN8T2fOYOanHByzYaQM2RurULuyn
         vEMWwd/FOXr9TJmS3RdhWAXSBiBu2/UTvLZivRzfdWVLAYDBnZhIzj1FxqMAhRxz6CU1
         DP4004Pk4AM0B+nQeMsFwpHl5Y0IE66uzbAMbxg9qO0M+8NaKelnepjrs8wWh05q/P7T
         YAurgt0lQAV+LA2Kd0cVn70cak3ulpdXQFjDnEeMpWjdNMOobNlGVQ4Ry4dboDLpylgk
         Tluw==
X-Gm-Message-State: AOAM532eV9wRkPACKyy2qhiHjPwCox/a4xh37npiVleAl6qSo6uRhFgS
        w4FjJQmqKOE93ti348x8EwY=
X-Google-Smtp-Source: ABdhPJxKzGKsQQHJRq6T+y7qW+i/Fbh7cDdDgQL1g756thAxl7m1j007UyowwSo/PHLxh2WWDCH6wA==
X-Received: by 2002:ac2:4888:: with SMTP id x8mr13738167lfc.489.1623717029392;
        Mon, 14 Jun 2021 17:30:29 -0700 (PDT)
Received: from rsa-laptop.internal.lan ([217.25.229.52])
        by smtp.gmail.com with ESMTPSA id 9sm1635522lfy.41.2021.06.14.17.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 17:30:28 -0700 (PDT)
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
To:     Loic Poulain <loic.poulain@linaro.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 09/10] net: mhi_net: create default link via WWAN core
Date:   Tue, 15 Jun 2021 03:30:15 +0300
Message-Id: <20210615003016.477-10-ryazanov.s.a@gmail.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210615003016.477-1-ryazanov.s.a@gmail.com>
References: <20210615003016.477-1-ryazanov.s.a@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Utilize the just introduced WWAN core feature to create a default netdev
for the default data channel. Since the netdev is now created via the
WWAN core, rely on it ability to destroy all child netdevs on ops
unregistering.

While at it, remove the RTNL lock acquiring hacks that were earlier used
to call addlink/dellink without holding the RTNL lock. Also make the
WWAN netdev ops structure static to make sparse happy.

Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>
---
 drivers/net/mhi/net.c | 54 +++++--------------------------------------
 1 file changed, 6 insertions(+), 48 deletions(-)

diff --git a/drivers/net/mhi/net.c b/drivers/net/mhi/net.c
index b003003cbd42..06253acecaa2 100644
--- a/drivers/net/mhi/net.c
+++ b/drivers/net/mhi/net.c
@@ -342,10 +342,7 @@ static int mhi_net_newlink(void *ctxt, struct net_device *ndev, u32 if_id,
 	/* Number of transfer descriptors determines size of the queue */
 	mhi_netdev->rx_queue_sz = mhi_get_free_desc_count(mhi_dev, DMA_FROM_DEVICE);
 
-	if (extack)
-		err = register_netdevice(ndev);
-	else
-		err = register_netdev(ndev);
+	err = register_netdevice(ndev);
 	if (err)
 		goto out_err;
 
@@ -370,10 +367,7 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
 	struct mhi_net_dev *mhi_netdev = netdev_priv(ndev);
 	struct mhi_device *mhi_dev = ctxt;
 
-	if (head)
-		unregister_netdevice_queue(ndev, head);
-	else
-		unregister_netdev(ndev);
+	unregister_netdevice_queue(ndev, head);
 
 	mhi_unprepare_from_transfer(mhi_dev);
 
@@ -382,7 +376,7 @@ static void mhi_net_dellink(void *ctxt, struct net_device *ndev,
 	dev_set_drvdata(&mhi_dev->dev, NULL);
 }
 
-const struct wwan_ops mhi_wwan_ops = {
+static const struct wwan_ops mhi_wwan_ops = {
 	.priv_size = sizeof(struct mhi_net_dev),
 	.setup = mhi_net_setup,
 	.newlink = mhi_net_newlink,
@@ -392,55 +386,19 @@ const struct wwan_ops mhi_wwan_ops = {
 static int mhi_net_probe(struct mhi_device *mhi_dev,
 			 const struct mhi_device_id *id)
 {
-	const struct mhi_device_info *info = (struct mhi_device_info *)id->driver_data;
 	struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
-	struct net_device *ndev;
-	int err;
-
-	err = wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev,
-				WWAN_NO_DEFAULT_LINK);
-	if (err)
-		return err;
-
-	if (!create_default_iface)
-		return 0;
-
-	/* Create a default interface which is used as either RMNET real-dev,
-	 * MBIM link 0 or ip link 0)
-	 */
-	ndev = alloc_netdev(sizeof(struct mhi_net_dev), info->netname,
-			    NET_NAME_PREDICTABLE, mhi_net_setup);
-	if (!ndev) {
-		err = -ENOMEM;
-		goto err_unregister;
-	}
-
-	SET_NETDEV_DEV(ndev, &mhi_dev->dev);
 
-	err = mhi_net_newlink(mhi_dev, ndev, 0, NULL);
-	if (err)
-		goto err_release;
-
-	return 0;
-
-err_release:
-	free_netdev(ndev);
-err_unregister:
-	wwan_unregister_ops(&cntrl->mhi_dev->dev);
-
-	return err;
+	return wwan_register_ops(&cntrl->mhi_dev->dev, &mhi_wwan_ops, mhi_dev,
+				 create_default_iface ? 0 :
+				 WWAN_NO_DEFAULT_LINK);
 }
 
 static void mhi_net_remove(struct mhi_device *mhi_dev)
 {
-	struct mhi_net_dev *mhi_netdev = dev_get_drvdata(&mhi_dev->dev);
 	struct mhi_controller *cntrl = mhi_dev->mhi_cntrl;
 
 	/* rtnetlink takes care of removing remaining links */
 	wwan_unregister_ops(&cntrl->mhi_dev->dev);
-
-	if (create_default_iface)
-		mhi_net_dellink(mhi_dev, mhi_netdev->ndev, NULL);
 }
 
 static const struct mhi_device_info mhi_hwip0 = {
-- 
2.26.3

