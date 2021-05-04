Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0823E372FB4
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 20:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231576AbhEDS3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 14:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230385AbhEDS3P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 14:29:15 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5483DC061574
        for <netdev@vger.kernel.org>; Tue,  4 May 2021 11:28:20 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id b21so5696960plz.0
        for <netdev@vger.kernel.org>; Tue, 04 May 2021 11:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8UOlp7map5ZsHANtrSTdMd5aGUgZsChYhjXvfmqv5ts=;
        b=QVw5h6Ss155q1f0Yl8xQztITzd7XJhwZGJKJxd1bv7gA/lls9MkidQ9kdWhGmSdd3i
         9M3a2W23r5jhmI0ArnWCD6JcQAgFlXcK+kgtGoOu0nr2qACz7lDsXLM/svWC84Ufa5Qh
         h//vvkjiwkEBJCaGU9eA9x4/nnwn/iXsXphc43hCx7W2M0TdpQTLUx+BQu/k+o59x/44
         MAYCVRABeLfqOVWhBlctat/IdO98RGnSeyr4ue+lOsb3Su0VwKJr00jR6z9DvFhjkpNW
         Wgf8jozm8ygruiLnGoUQCqRzpizPNlXccjSWrivQoJgh/lflN9niMh05yLCYWSygAsie
         PIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8UOlp7map5ZsHANtrSTdMd5aGUgZsChYhjXvfmqv5ts=;
        b=PiT5D0SEo6MVit9EYE7nCJDXFEdyaGddeUhn1doFijzE6J1/zG4imW7gfZEGpt9rJ4
         qgjk4hBVEoIFU+zGdobEvHGhGacrDrxbZ3/NXebF2QYWSALf6Rw9aM9XetQjcuyNAkW4
         FCthSr15E00Yxdx6hipXHu768TbXRgDOWZOvumSXU6Lllj+czL8FdVRGBKMjNMumOqbZ
         FXhFAnL7SR3O5kcl2WpLLZaVflU4IwdAUA9mC5WR1cjD9+fblnQjjAhmWAXdguodLc1f
         GdTfcPPPPrUqeaKAsWFyyiDJpWce9cLwzYLUOHI5WU/AnQDI/6U5K9gxmNUxMwbU/PYk
         QLBg==
X-Gm-Message-State: AOAM5331ssq7J+lD2RPe4tJtmAU7b15G8yU+3GuYhFUP2Pu2Sj7kSlXO
        ku5wyhGdxSkIlx/ogQasvlJfG5WJmTy9Ig==
X-Google-Smtp-Source: ABdhPJwZd4sFlxV93gZmHiYwdPGRIcOKRWYKxf/s1TENDl5yHR2sqSF3aYQB87j84cVMUvo9BgJ/Eg==
X-Received: by 2002:a17:902:361:b029:e9:8392:7abd with SMTP id 88-20020a1709020361b02900e983927abdmr27495296pld.8.1620152899555;
        Tue, 04 May 2021 11:28:19 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id y13sm4205437pgs.93.2021.05.04.11.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 11:28:18 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Cc:     drivers@pensando.io, Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net] ionic: fix ptp support config breakage
Date:   Tue,  4 May 2021 11:28:09 -0700
Message-Id: <20210504182809.71312-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Driver link failed with undefined references in some
kernel config variations.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
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

