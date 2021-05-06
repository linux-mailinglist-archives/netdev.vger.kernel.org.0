Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E150374E4D
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 06:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhEFETy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 00:19:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhEFETy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 00:19:54 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC09FC061574
        for <netdev@vger.kernel.org>; Wed,  5 May 2021 21:18:55 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id y2so2728456plr.5
        for <netdev@vger.kernel.org>; Wed, 05 May 2021 21:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=C4KhZ3DrUUzWqJZEQziV98f6gtuOT6tZYyDzY1e0Zac=;
        b=rXegKbmoxZF0za8v0uTAdaq4pYRplqlmCKfAwKKAw9JyYo2AzNOerCFk324WNx0sSU
         VFUK3hDQ43ACol17uZgVX8npt959gTY+qufEKx74LuWERlbQK4xnz+CdVrgrTVDFx7l6
         vD7bG8xbSbNlC/KZa48fOmsZ9OPL4mr7lMjpvILfHQgWCn7PTD/V2WLliqYAfDL0h1sM
         9KCFw0DSb7Hzn1QdiUettOcs/LWWlWIbVyZOKESpo3eorbn+fttiqxsqcM5kGeb/2JKy
         Dh2/EInLbRWe2dqUAaRF7YHx8r0RR3xiYoqjlYsgVFYVl03nglEi55U5i1GbIcy3StZt
         Hzdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=C4KhZ3DrUUzWqJZEQziV98f6gtuOT6tZYyDzY1e0Zac=;
        b=uL8VxH7wN9GI10AKFXALe0TektEKcDMC8Aae7YObd9g1/BJx+SkZ8CJeMXJy5YoZNY
         NNpV4em8lAkiZ9E40YM/rXf2zBLhqBGFvY2sqSZ5my2aeQNZ8v2C+NGmNLksJZzJRKjm
         CpwsjlC40vX5l6jeBFllCOmiAmJEzMlHwAj8HFDiE4BfVU4tR1k3tZWI/wjBSA2ZFahW
         6Hj8nK0/Qm+FLwNIphoR4TE1HDvexWmbdbF7pY89supqIU48qIylnX3Vcs6C+YJ+OyxS
         y2VWbFyCx5yr2onLoU1adD8YueysxhI8CU3KfF26TngTNIL4BM6YSXEJLalNBEimh0xJ
         kYZQ==
X-Gm-Message-State: AOAM530FmYGV95ZpgU/Az32WaYuaTBj4Y9QOX16k1abM0JaFn4fdBMOX
        H8mF8zHbU5gIbegenfPbX1UTo1ordB5vvg==
X-Google-Smtp-Source: ABdhPJzo/ZUmWPOyW75bHYiJPX0/N3lTfcbImmVdwKMzVm+h/bvpBa35i4TtE+uVLChBJ+NTn4vSMA==
X-Received: by 2002:a17:902:e9d1:b029:ed:1bde:8e4 with SMTP id 17-20020a170902e9d1b02900ed1bde08e4mr2662412plk.6.1620274735096;
        Wed, 05 May 2021 21:18:55 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id i126sm674177pfc.20.2021.05.05.21.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 21:18:54 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>,
        Allen Hubbe <allenbh@pensando.io>
Subject: [PATCH v3 net] ionic: fix ptp support config breakage
Date:   Wed,  5 May 2021 21:18:46 -0700
Message-Id: <20210506041846.62502-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver link failed with undefined references in some
kernel config variations.

Fixes: 61db421da31b ("ionic: link in the new hw timestamp code")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Allen Hubbe <allenbh@pensando.io>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---

v3 - put version notes below ---, added Allen's Cc
v2 - added Fixes tag

 drivers/net/ethernet/pensando/ionic/Makefile    | 3 +--
 drivers/net/ethernet/pensando/ionic/ionic_phc.c | 3 +++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/Makefile b/drivers/net/ethernet/pensando/ionic/Makefile
index 4e7642a2d25f..61c40169cb1f 100644
--- a/drivers/net/ethernet/pensando/ionic/Makefile
+++ b/drivers/net/ethernet/pensando/ionic/Makefile
@@ -5,5 +5,4 @@ obj-$(CONFIG_IONIC) := ionic.o
 
 ionic-y := ionic_main.o ionic_bus_pci.o ionic_devlink.o ionic_dev.o \
 	   ionic_debugfs.o ionic_lif.o ionic_rx_filter.o ionic_ethtool.o \
-	   ionic_txrx.o ionic_stats.o ionic_fw.o
-ionic-$(CONFIG_PTP_1588_CLOCK) += ionic_phc.o
+	   ionic_txrx.o ionic_stats.o ionic_fw.o ionic_phc.o
diff --git a/drivers/net/ethernet/pensando/ionic/ionic_phc.c b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
index a87c87e86aef..30c78808c45a 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_phc.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_phc.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017 - 2021 Pensando Systems, Inc */
 
+#if IS_ENABLED(CONFIG_PTP_1588_CLOCK)
+
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 
@@ -613,3 +615,4 @@ void ionic_lif_free_phc(struct ionic_lif *lif)
 	devm_kfree(lif->ionic->dev, lif->phc);
 	lif->phc = NULL;
 }
+#endif /* IS_ENABLED(CONFIG_PTP_1588_CLOCK) */
-- 
2.17.1

