Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDDA50079D
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 09:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbiDNHzO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 03:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240522AbiDNHzO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 03:55:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 571D439691
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 00:52:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4B7961FDA
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 07:52:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81745C385A1;
        Thu, 14 Apr 2022 07:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649922768;
        bh=704wKMvyC3AIRwuTiXmsKD2hTb93fq320qMb+12o3zE=;
        h=From:To:Cc:Subject:Date:From;
        b=M5QbwW09fNEq+mx3TMoGRXtEz+Bgucy8otu3M/mUaBDL4HbfXaK4jwNhcE8ItXtYb
         CSKYn6nxOQFRZVqeFr8nARGjUNHHBNCquT/s0nwjAlEEHJzxrsFpAVfk7SMU6R3fgG
         OSnCQmjfU2nRJE3t6ILscwT07QpUvDHvGb76JlPXk68s0DKWBHNJ1p7j6sDi0gUKFG
         RpuXc9BFgQ6BZIYaj2l/36Y1ooxYHl+vbEZxkjlzIArpLlVgaXSPTMpdqKMhXf/zaK
         eI1M/16KDZ3+bjj5BvMtGYQEzIDosynJj5LtQJoKh90ZNoBAKIOLuM0CWwp3uRMGJD
         F4YF5vZ55zjYg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Abhijit Ayarekar <aayarekar@marvell.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Satananda Burla <sburla@marvell.com>,
        Veerasenareddy Burru <vburru@marvell.com>
Subject: [PATCH net-next] octeon_ep: Remove custom driver version
Date:   Thu, 14 Apr 2022 10:52:42 +0300
Message-Id: <5d76f3116ee795071ec044eabb815d6c2bdc7dbd.1649922731.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

In review comment [1] was pointed that new code is not supposed
to set driver version and should rely on kernel version instead.

As an outcome of that comment all the dance around setting such
driver version to FW should be removed too, because in upstream
kernel whole driver will have same version so read/write from/to
FW will give same result.

[1] https://lore.kernel.org/all/YladGTmon1x3dfxI@unreal

Fixes: 862cd659a6fb ("octeon_ep: Add driver framework and device initialization")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 .../ethernet/marvell/octeon_ep/octep_ctrl_mbox.c    | 13 +------------
 drivers/net/ethernet/marvell/octeon_ep/octep_main.c |  2 --
 drivers/net/ethernet/marvell/octeon_ep/octep_main.h |  9 ---------
 3 files changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
index 8c196dadfad0..39322e4dd100 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_ctrl_mbox.c
@@ -26,9 +26,7 @@
 
 #define OCTEP_CTRL_MBOX_INFO_MAGIC_NUM_OFFSET(m)	(m)
 #define OCTEP_CTRL_MBOX_INFO_BARMEM_SZ_OFFSET(m)	((m) + 8)
-#define OCTEP_CTRL_MBOX_INFO_HOST_VERSION_OFFSET(m)	((m) + 16)
 #define OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(m)	((m) + 24)
-#define OCTEP_CTRL_MBOX_INFO_FW_VERSION_OFFSET(m)	((m) + 136)
 #define OCTEP_CTRL_MBOX_INFO_FW_STATUS_OFFSET(m)	((m) + 144)
 
 #define OCTEP_CTRL_MBOX_H2FQ_INFO_OFFSET(m)		((m) + OCTEP_CTRL_MBOX_INFO_SZ)
@@ -65,7 +63,7 @@ static u32 octep_ctrl_mbox_circq_depth(u32 pi, u32 ci, u32 mask)
 
 int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
 {
-	u64 version, magic_num, status;
+	u64 magic_num, status;
 
 	if (!mbox)
 		return -EINVAL;
@@ -81,13 +79,6 @@ int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
 		return -EINVAL;
 	}
 
-	version = readq(OCTEP_CTRL_MBOX_INFO_FW_VERSION_OFFSET(mbox->barmem));
-	if (version != OCTEP_DRV_VERSION) {
-		pr_info("octep_ctrl_mbox : Firmware version mismatch %llx != %x\n",
-			version, OCTEP_DRV_VERSION);
-		return -EINVAL;
-	}
-
 	status = readq(OCTEP_CTRL_MBOX_INFO_FW_STATUS_OFFSET(mbox->barmem));
 	if (status != OCTEP_CTRL_MBOX_STATUS_READY) {
 		pr_info("octep_ctrl_mbox : Firmware is not ready.\n");
@@ -96,7 +87,6 @@ int octep_ctrl_mbox_init(struct octep_ctrl_mbox *mbox)
 
 	mbox->barmem_sz = readl(OCTEP_CTRL_MBOX_INFO_BARMEM_SZ_OFFSET(mbox->barmem));
 
-	writeq(mbox->version, OCTEP_CTRL_MBOX_INFO_HOST_VERSION_OFFSET(mbox->barmem));
 	writeq(OCTEP_CTRL_MBOX_STATUS_INIT, OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
 
 	mbox->h2fq.elem_cnt = readl(OCTEP_CTRL_MBOX_H2FQ_ELEM_CNT_OFFSET(mbox->barmem));
@@ -248,7 +238,6 @@ int octep_ctrl_mbox_uninit(struct octep_ctrl_mbox *mbox)
 
 	writeq(OCTEP_CTRL_MBOX_STATUS_INVALID,
 	       OCTEP_CTRL_MBOX_INFO_HOST_STATUS_OFFSET(mbox->barmem));
-	writeq(0, OCTEP_CTRL_MBOX_INFO_HOST_VERSION_OFFSET(mbox->barmem));
 
 	pr_info("Octep ctrl mbox : Uninit successful.\n");
 
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
index 5d39c857ea41..3dd0af740f4f 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.c
@@ -30,7 +30,6 @@ MODULE_DEVICE_TABLE(pci, octep_pci_id_tbl);
 MODULE_AUTHOR("Veerasenareddy Burru <vburru@marvell.com>");
 MODULE_DESCRIPTION(OCTEP_DRV_STRING);
 MODULE_LICENSE("GPL");
-MODULE_VERSION(OCTEP_DRV_VERSION_STR);
 
 /**
  * octep_alloc_ioq_vectors() - Allocate Tx/Rx Queue interrupt info.
@@ -950,7 +949,6 @@ int octep_device_setup(struct octep_device *oct)
 
 	/* Initialize control mbox */
 	ctrl_mbox = &oct->ctrl_mbox;
-	ctrl_mbox->version = OCTEP_DRV_VERSION;
 	ctrl_mbox->barmem = CFG_GET_CTRL_MBOX_MEM_ADDR(oct->conf);
 	ret = octep_ctrl_mbox_init(ctrl_mbox);
 	if (ret) {
diff --git a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
index 520f2c3664f9..025626a61383 100644
--- a/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
+++ b/drivers/net/ethernet/marvell/octeon_ep/octep_main.h
@@ -12,15 +12,6 @@
 #include "octep_rx.h"
 #include "octep_ctrl_mbox.h"
 
-#define OCTEP_DRV_VERSION_MAJOR		1
-#define OCTEP_DRV_VERSION_MINOR		0
-#define OCTEP_DRV_VERSION_VARIANT	0
-
-#define OCTEP_DRV_VERSION	((OCTEP_DRV_VERSION_MAJOR << 16) + \
-				  (OCTEP_DRV_VERSION_MINOR << 8) + \
-				  OCTEP_DRV_VERSION_VARIANT)
-
-#define OCTEP_DRV_VERSION_STR	"1.0.0"
 #define OCTEP_DRV_NAME		"octeon_ep"
 #define OCTEP_DRV_STRING	"Marvell Octeon EndPoint NIC Driver"
 
-- 
2.35.1

