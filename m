Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B7A92356FE
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 15:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgHBNLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 09:11:32 -0400
Received: from zg8tmja5ljk3lje4mi4ymjia.icoremail.net ([209.97.182.222]:45614
        "HELO zg8tmja5ljk3lje4mi4ymjia.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S1726578AbgHBNLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 09:11:32 -0400
Received: from oslab.tsinghua.edu.cn (unknown [166.111.139.112])
        by app-5 (Coremail) with SMTP id EwQGZQCnrnJtuyZfHMLtAw--.12483S2;
        Sun, 02 Aug 2020 21:11:14 +0800 (CST)
From:   Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
To:     doshir@vmware.com, pv-drivers@vmware.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
Subject: [PATCH] net: vmxnet3: avoid accessing the data mapped to streaming DMA
Date:   Sun,  2 Aug 2020 21:11:07 +0800
Message-Id: <20200802131107.15857-1-baijiaju@tsinghua.edu.cn>
X-Mailer: git-send-email 2.17.1
X-CM-TRANSID: EwQGZQCnrnJtuyZfHMLtAw--.12483S2
X-Coremail-Antispam: 1UD129KBjvJXoW7trWUKr1fCrW5AFy5AF48Xrb_yoW8urW3pF
        ZxJ3WrJr42gr1qy3yrur4rW3W5Gr4rta4xKa4Utw1fWa9xZF1Iyr9Yyryjy34rK34Duan8
        JFn2vw4rJr1xtw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkv14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCY02Avz4vE14v_Xr4l
        42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJV
        WUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAK
        I48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r
        4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF
        0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JU-_-PUUUUU=
X-CM-SenderInfo: xedlyxhdmxq3pvlqwxlxdovvfxof0/
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In vmxnet3_probe_device(), "adapter" is mapped to streaming DMA:
  adapter->adapter_pa = dma_map_single(..., adapter, ...);

Then "adapter" is accessed at many places in this function.

Theses accesses may cause data inconsistency between CPU cache and 
hardware.

To fix this problem, dma_map_single() is called after these accesses.

Signed-off-by: Jia-Ju Bai <baijiaju@tsinghua.edu.cn>
---
 drivers/net/vmxnet3/vmxnet3_drv.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/vmxnet3/vmxnet3_drv.c b/drivers/net/vmxnet3/vmxnet3_drv.c
index ca395f9679d0..96a4c28ba429 100644
--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -3445,14 +3445,6 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	}
 
 	spin_lock_init(&adapter->cmd_lock);
-	adapter->adapter_pa = dma_map_single(&adapter->pdev->dev, adapter,
-					     sizeof(struct vmxnet3_adapter),
-					     PCI_DMA_TODEVICE);
-	if (dma_mapping_error(&adapter->pdev->dev, adapter->adapter_pa)) {
-		dev_err(&pdev->dev, "Failed to map dma\n");
-		err = -EFAULT;
-		goto err_set_mask;
-	}
 	adapter->shared = dma_alloc_coherent(
 				&adapter->pdev->dev,
 				sizeof(struct Vmxnet3_DriverShared),
@@ -3628,6 +3620,16 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 	}
 
 	vmxnet3_check_link(adapter, false);
+
+	adapter->adapter_pa = dma_map_single(&adapter->pdev->dev, adapter,
+					     sizeof(struct vmxnet3_adapter),
+					     PCI_DMA_TODEVICE);
+	if (dma_mapping_error(&adapter->pdev->dev, adapter->adapter_pa)) {
+		dev_err(&pdev->dev, "Failed to map dma\n");
+		err = -EFAULT;
+		goto err_register;
+	}
+
 	return 0;
 
 err_register:
@@ -3655,8 +3657,6 @@ vmxnet3_probe_device(struct pci_dev *pdev,
 			  sizeof(struct Vmxnet3_DriverShared),
 			  adapter->shared, adapter->shared_pa);
 err_alloc_shared:
-	dma_unmap_single(&adapter->pdev->dev, adapter->adapter_pa,
-			 sizeof(struct vmxnet3_adapter), PCI_DMA_TODEVICE);
 err_set_mask:
 	free_netdev(netdev);
 	return err;
-- 
2.17.1

