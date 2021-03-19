Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D7E34198A
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 11:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbhCSKI2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 06:08:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhCSKIU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 06:08:20 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C24C06174A
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 03:08:19 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id jy13so8721927ejc.2
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 03:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=phTDAE8iRMqs4t75T6eGXp5k8sWyX6fk4giY2iB2Xdo=;
        b=tCCKzqEOQOuTZY6AutV1f6lj8hC4xhVcr4lVR2ENGVnggiVaRpbpRqaYz27Rp3Tj2d
         MWYH/5AR8mxVxRnp4CsgnR0k/r/pDeyplcz2rjeY1XhXGf3Z4BtFmtAW3R5Red4cXdxK
         0+hp/zL6FWO+C7cAFbhYtnUjYJ6cuMnb8aWcwtobveAqQKZJu8QHV+7Zg9dvnDn/Ycw3
         apVq0/5Oip3UDnT3zPjzOHzOTEBLOQP3obacHM1GPuVCR2kgf8aHPTQnmIYmqWf2Hyzb
         9Jh0qTlON6lnlnMx68LNmmuM4vg9YqA3qSYQIhvFQ6MDDQ0w/xMsdMSTwD/8Xaapf2mP
         yO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=phTDAE8iRMqs4t75T6eGXp5k8sWyX6fk4giY2iB2Xdo=;
        b=U6M1pb+7CD6bhdBGPIlNOAHxwhABxE9/ovRthi5PJLq3ppt/HNhVVqfNrkN7fPEf8E
         RvrqgZOAr+xJ205tf806J9TP+DvW2bdNo/s07ZMvLUWzDrJOL7JFXKEl5rdhQWq45K/z
         h9cz6BpIkQH852K/pNwI6rayw8/hHN/+d0YgDXuLwN2FTr/A//NYA773WNMZUWFBiNlm
         LQSXaKaMVOEcUp6p6lykAvvq9CmgfyUQakZBq8DxgqZ4btxmu49Alf6yY6I8iCTdU6tA
         61MsOPdwmw+UGWvxCuQmZor7al3NBuym/6oapinDXgzaqF2QP1LfXHXjVCLmz97qroav
         9wbw==
X-Gm-Message-State: AOAM5317ATL8Yq90X2lGZ/mJIZ/zB4oIwKC3rD1KhkrGUghpZBrYG8m1
        6C9tzRPLTUr/Jle5bWUt73Q=
X-Google-Smtp-Source: ABdhPJx5bJrMvrNk2CPElIKOWbKxKxcBpP/nSnhZJPejo3xC0yzBiLRnS3uifY1C3ymyPYRDCQODfQ==
X-Received: by 2002:a17:906:a896:: with SMTP id ha22mr3321268ejb.503.1616148493726;
        Fri, 19 Mar 2021 03:08:13 -0700 (PDT)
Received: from localhost.localdomain (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id u15sm3847336eds.6.2021.03.19.03.08.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 03:08:13 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Alex Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Michael Walle <michael@walle.cc>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next] net: enetc: teardown CBDR during PF/VF unbind
Date:   Fri, 19 Mar 2021 12:08:06 +0200
Message-Id: <20210319100806.801581-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Michael reports that after the blamed patch, unbinding a VF would cause
these transactions to remain pending, and trigger some warnings with the
DMA API debug:

$ echo 1 > /sys/bus/pci/devices/0000\:00\:00.0/sriov_numvfs
pci 0000:00:01.0: [1957:ef00] type 00 class 0x020001
fsl_enetc_vf 0000:00:01.0: Adding to iommu group 19
fsl_enetc_vf 0000:00:01.0: enabling device (0000 -> 0002)
fsl_enetc_vf 0000:00:01.0 eno0vf0: renamed from eth0

$ echo 0 > /sys/bus/pci/devices/0000\:00\:00.0/sriov_numvfs
DMA-API: pci 0000:00:01.0: device driver has pending DMA allocations while released from device [count=1]
One of leaked entries details: [size=2048 bytes] [mapped with DMA_BIDIRECTIONAL] [mapped as coherent]
WARNING: CPU: 0 PID: 2547 at kernel/dma/debug.c:853 dma_debug_device_change+0x174/0x1c8
(...)
Call trace:
 dma_debug_device_change+0x174/0x1c8
 blocking_notifier_call_chain+0x74/0xa8
 device_release_driver_internal+0x18c/0x1f0
 device_release_driver+0x20/0x30
 pci_stop_bus_device+0x8c/0xe8
 pci_stop_and_remove_bus_device+0x20/0x38
 pci_iov_remove_virtfn+0xb8/0x128
 sriov_disable+0x3c/0x110
 pci_disable_sriov+0x24/0x30
 enetc_sriov_configure+0x4c/0x108
 sriov_numvfs_store+0x11c/0x198
(...)
DMA-API: Mapped at:
 dma_entry_alloc+0xa4/0x130
 debug_dma_alloc_coherent+0xbc/0x138
 dma_alloc_attrs+0xa4/0x108
 enetc_setup_cbdr+0x4c/0x1d0
 enetc_vf_probe+0x11c/0x250
pci 0000:00:01.0: Removing from iommu group 19

This happens because stupid me moved enetc_teardown_cbdr outside of
enetc_free_si_resources, but did not bother to keep calling
enetc_teardown_cbdr from all the places where enetc_free_si_resources
was called. In particular, now it is no longer called from the main
unbind function, just from the probe error path.

Fixes: 4b47c0b81ffd ("net: enetc: don't initialize unused ports from a separate code path")
Reported-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc_pf.c | 1 +
 drivers/net/ethernet/freescale/enetc/enetc_vf.c | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_pf.c b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
index bea1d935fa1c..60f20970a79d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_pf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_pf.c
@@ -1226,6 +1226,7 @@ static void enetc_pf_remove(struct pci_dev *pdev)
 	enetc_free_msix(priv);
 
 	enetc_free_si_resources(priv);
+	enetc_teardown_cbdr(&si->cbd_ring);
 
 	free_netdev(si->ndev);
 
diff --git a/drivers/net/ethernet/freescale/enetc/enetc_vf.c b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
index 371a34d3c6b4..03090ba7e226 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_vf.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_vf.c
@@ -223,6 +223,7 @@ static void enetc_vf_remove(struct pci_dev *pdev)
 	enetc_free_msix(priv);
 
 	enetc_free_si_resources(priv);
+	enetc_teardown_cbdr(&si->cbd_ring);
 
 	free_netdev(si->ndev);
 
-- 
2.25.1

