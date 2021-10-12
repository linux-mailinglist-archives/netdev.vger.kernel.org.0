Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE98942B006
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 01:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234783AbhJLXRl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 19:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232246AbhJLXRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Oct 2021 19:17:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5856C061570
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 16:15:38 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id oa4so786918pjb.2
        for <netdev@vger.kernel.org>; Tue, 12 Oct 2021 16:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=JcTR72fwEk1Vx6Ss0BL8G1waeMrec73Nd9tDgWpYWow=;
        b=Z1reI5PWUVzZIOLBQhWRG0L70cCx/ypS1G+0q/RnZeH5t7FPabkxDMV+hI8WlmPFrz
         KgEGNsgmIm93nrSpLQFegAsUEvwRBQw+e8UYP1VqFLPMOcowmzQtCl8zqGAffSXQXNSE
         iHfc4MUJR8CZn576EpQbAnsuisPJcx4MlGJUT1RqUcsaXUWcOF4aSqMvkRzpuvooE/28
         5p6RakRqL4MnyxI4+u6v+GiLQs1XVlebsAkWuTmUnqseuQTABaUZQDvD0GsCCioQ9pSa
         ShppNm8FwVzowjc1m3ujRKSJRIdXIC0slPUvYLmoFb/NnQcGhz78lMLpET4NfppV7hFA
         F1cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JcTR72fwEk1Vx6Ss0BL8G1waeMrec73Nd9tDgWpYWow=;
        b=1nph6x4Nj0mbfO2IabWNr7+bAkVyYvUznjqDoLG6pukikWhu4kvlDjmTHTBIOOxelF
         hnWsO8vi8yr7BtY7k4PKiUuTFjQ+zI1qwPwsfbzfRKGAt/QuulfC/1vcP26s8bBKTBfD
         I7jZkCPtw2AtRFSwu9CcNKkuJSFO170i1V5zHdl0AWrkkVqLatlbyA/j9oObVui+d/3h
         QIY39FRg3nbFko/EUJnk/gAzzknKU+ncH69ymxWIVUEn4MglzN+g05fCBMwC2PtiTl2l
         ZfNxcYAnL5GMKLMbxGt+yV/uLr8booIh5ohg4MsAKcns1mgLkWE9QbzS84Eck38jByXW
         Pi4w==
X-Gm-Message-State: AOAM533dkYIjXc/n6C1POW9pAzwMiYoREtjZ/Rc0LCR42vJpYPPlCW90
        k++ukBV7uP08VOpBzKjUMr/JMQ==
X-Google-Smtp-Source: ABdhPJwOOTy6Lq3tPZzqTBdt/ZCnuLOb5xPhkCBw+/jyuKHHGckAeX+nPzt8SiwKPno3bSpzWrUx9A==
X-Received: by 2002:a17:90a:11:: with SMTP id 17mr9296542pja.238.1634080538401;
        Tue, 12 Oct 2021 16:15:38 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i2sm3165460pjt.21.2021.10.12.16.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Oct 2021 16:15:38 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Leon Romanovsky <leonro@nvidia.com>
Subject: [PATCH net-next] ionic: no devlink_unregister if not registered
Date:   Tue, 12 Oct 2021 16:15:20 -0700
Message-Id: <20211012231520.72582-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Don't try to unregister the devlink if it hasn't been registered
yet.  This bit of error cleanup code got missed in the recent
devlink registration changes.

Fixes: 7911c8bd546f ("ionic: Move devlink registration to be last devlink command")
Cc: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_devlink.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
index 2267da95640b..4297ed9024c0 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_devlink.c
@@ -87,7 +87,6 @@ int ionic_devlink_register(struct ionic *ionic)
 	err = devlink_port_register(dl, &ionic->dl_port, 0);
 	if (err) {
 		dev_err(ionic->dev, "devlink_port_register failed: %d\n", err);
-		devlink_unregister(dl);
 		return err;
 	}
 
-- 
2.17.1

