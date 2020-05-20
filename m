Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 276681DB8B8
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 17:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgETPxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 11:53:55 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50239 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726824AbgETPxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 11:53:54 -0400
Received: by mail-wm1-f65.google.com with SMTP id m12so3003986wmc.0
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 08:53:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4G4wQvf4fPflZ6+ui8oysG+9GFvQgx6HsOsbxQDcOHY=;
        b=Xk05PwzJmEJITEJEQTn9rMGG9ZtCRN+wAgAtu/7lN5nkhvXFfT56jaT28+DwDOjOBb
         pz8voGhcRu8Ks56Gg27IMutnFUoQrI6MS7nVzEA06azptXiBCAecO86FV4K6O9uxF2fq
         f+YDbWYlp2zIPjOMiTYT5xbn+NtyJzFoqLO8aR1StkqFRSD47rWXadHDxf9BDmt9XqNF
         WTzZ5oGZSBQzTHJ62xooRIBL267J+zzttleOWQuESfxTLbqQbCja1rR89giuQDnMkOwC
         flsucqrMPcj8+9Pz3ZUhU7W0XfbGumbwynupDRWi2xQhCEcnIV0Qsu4Ng/slpL1uoayF
         mPVg==
X-Gm-Message-State: AOAM5305TP5YFom1v74R3VxzIQ2EhK2Ev8Jbie+9erWkzUMulD7REAr4
        xiM9LDpWdjPBAu/iopD7JTE=
X-Google-Smtp-Source: ABdhPJxasqfC1GKUsFMB0a53nJfuYMEzDAknnYg3yuvkeIG8j9WG4srPVolnmuGumEjFDGfwuy4FKg==
X-Received: by 2002:a7b:cc92:: with SMTP id p18mr5409064wma.174.1589990031147;
        Wed, 20 May 2020 08:53:51 -0700 (PDT)
Received: from zenbook-val.localdomain (bbcs-65-74.pub.wingo.ch. [144.2.65.74])
        by smtp.gmail.com with ESMTPSA id s11sm3216208wrp.79.2020.05.20.08.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 08:53:50 -0700 (PDT)
From:   Valentin Longchamp <valentin@longchamp.me>
To:     linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, hkallweit1@gmail.com
Cc:     Valentin Longchamp <valentin@longchamp.me>,
        Matteo Ghidoni <matteo.ghidoni@ch.abb.com>
Subject: [PATCH] net/ethernet/freescale: rework quiesce/activate for ucc_geth
Date:   Wed, 20 May 2020 17:53:50 +0200
Message-Id: <20200520155350.1372-1-valentin@longchamp.me>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ugeth_quiesce/activate are used to halt the controller when there is a
link change that requires to reconfigure the mac.

The previous implementation called netif_device_detach(). This however
causes the initial activation of the netdevice to fail precisely because
it's detached. For details, see [1].

A possible workaround was the revert of commit
net: linkwatch: add check for netdevice being present to linkwatch_do_dev
However, the check introduced in the above commit is correct and shall be
kept.

The netif_device_detach() is thus replaced with
netif_tx_stop_all_queues() that prevents any tranmission. This allows to
perform mac config change required by the link change, without detaching
the corresponding netdevice and thus not preventing its initial
activation.

[1] https://lists.openwall.net/netdev/2020/01/08/201

Signed-off-by: Valentin Longchamp <valentin@longchamp.me>
Acked-by: Matteo Ghidoni <matteo.ghidoni@ch.abb.com>
---
 drivers/net/ethernet/freescale/ucc_geth.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/freescale/ucc_geth.c b/drivers/net/ethernet/freescale/ucc_geth.c
index 6e5f6dd169b5..552e7554a9f8 100644
--- a/drivers/net/ethernet/freescale/ucc_geth.c
+++ b/drivers/net/ethernet/freescale/ucc_geth.c
@@ -42,6 +42,7 @@
 #include <soc/fsl/qe/ucc.h>
 #include <soc/fsl/qe/ucc_fast.h>
 #include <asm/machdep.h>
+#include <net/sch_generic.h>
 
 #include "ucc_geth.h"
 
@@ -1548,11 +1549,8 @@ static int ugeth_disable(struct ucc_geth_private *ugeth, enum comm_dir mode)
 
 static void ugeth_quiesce(struct ucc_geth_private *ugeth)
 {
-	/* Prevent any further xmits, plus detach the device. */
-	netif_device_detach(ugeth->ndev);
-
-	/* Wait for any current xmits to finish. */
-	netif_tx_disable(ugeth->ndev);
+	/* Prevent any further xmits */
+	netif_tx_stop_all_queues(ugeth->ndev);
 
 	/* Disable the interrupt to avoid NAPI rescheduling. */
 	disable_irq(ugeth->ug_info->uf_info.irq);
@@ -1565,7 +1563,10 @@ static void ugeth_activate(struct ucc_geth_private *ugeth)
 {
 	napi_enable(&ugeth->napi);
 	enable_irq(ugeth->ug_info->uf_info.irq);
-	netif_device_attach(ugeth->ndev);
+
+	/* allow to xmit again  */
+	netif_tx_wake_all_queues(ugeth->ndev);
+	__netdev_watchdog_up(ugeth->ndev);
 }
 
 /* Called every time the controller might need to be made
-- 
2.25.1

