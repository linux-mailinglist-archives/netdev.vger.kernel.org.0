Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9C856C62CA
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 10:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbjCWJIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 05:08:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjCWJHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 05:07:46 -0400
Received: from out-15.mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6966D3757A
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 02:06:50 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679562222;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IiRXdKppa9IBGp5kQGEXwtKfuR/2bgkSL+hNdkioQqs=;
        b=MUeYVTo/T72JuuTmN+VG/0fI78l9KiugDmSXdYzstalg0UCpuRmQnt59kKJLrc/m1EJMnw
        DzrmAnc9d9SFr3AI5gwjvc7RzfmXkLSjSFlIsjj6iY7Re6eVWnhRYDOI+YFMVHYQtPQUGe
        Wmizm0ZHpB7aJqHToDYspG/y2xBvCIc=
From:   Cai Huoqing <cai.huoqing@linux.dev>
To:     cai.huoqing@linux.dev
Cc:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Raju Rangoju <rajur@chelsio.com>,
        Dariusz Marcinkiewicz <reksio@newterm.pl>,
        Dimitris Michailidis <dmichail@fungible.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        Shannon Nelson <shannon.nelson@amd.com>,
        Brett Creeley <brett.creeley@amd.com>, drivers@pensando.io,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jian Shen <shenjian15@huawei.com>, Hao Lan <lanhao@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Long Li <longli@microsoft.com>, Jiri Pirko <jiri@resnulli.us>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org
Subject: [PATCH 2/8] net: hisilicon: Remove redundant pci_clear_master
Date:   Thu, 23 Mar 2023 17:03:01 +0800
Message-Id: <20230323090314.22431-2-cai.huoqing@linux.dev>
In-Reply-To: <20230323090314.22431-1-cai.huoqing@linux.dev>
References: <20230323090314.22431-1-cai.huoqing@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,TO_EQ_FM_DIRECT_MX
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove pci_clear_master to simplify the code,
the bus-mastering is also cleared in do_pci_disable_device,
like this:
./drivers/pci/pci.c:2197
static void do_pci_disable_device(struct pci_dev *dev)
{
	u16 pci_command;

	pci_read_config_word(dev, PCI_COMMAND, &pci_command);
	if (pci_command & PCI_COMMAND_MASTER) {
		pci_command &= ~PCI_COMMAND_MASTER;
		pci_write_config_word(dev, PCI_COMMAND, pci_command);
	}

	pcibios_disable_device(dev);
}.
And dev->is_busmaster is set to 0 in pci_disable_device.

Signed-off-by: Cai Huoqing <cai.huoqing@linux.dev>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 7 ++-----
 drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 6 ++----
 2 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 07ad5f35219e..c3851a6e10c0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11365,7 +11365,7 @@ static int hclge_pci_init(struct hclge_dev *hdev)
 	if (!hw->hw.io_base) {
 		dev_err(&pdev->dev, "Can't map configuration register space\n");
 		ret = -ENOMEM;
-		goto err_clr_master;
+		goto err_release_regions;
 	}
 
 	ret = hclge_dev_mem_map(hdev);
@@ -11378,8 +11378,7 @@ static int hclge_pci_init(struct hclge_dev *hdev)
 
 err_unmap_io_base:
 	pcim_iounmap(pdev, hdev->hw.hw.io_base);
-err_clr_master:
-	pci_clear_master(pdev);
+err_release_regions:
 	pci_release_regions(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
@@ -11396,7 +11395,6 @@ static void hclge_pci_uninit(struct hclge_dev *hdev)
 
 	pcim_iounmap(pdev, hdev->hw.hw.io_base);
 	pci_free_irq_vectors(pdev);
-	pci_clear_master(pdev);
 	pci_release_mem_regions(pdev);
 	pci_disable_device(pdev);
 }
@@ -11743,7 +11741,6 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	hclge_devlink_uninit(hdev);
 err_pci_uninit:
 	pcim_iounmap(pdev, hdev->hw.hw.io_base);
-	pci_clear_master(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 out:
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
index e84e5be8e59e..f24046250341 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c
@@ -2598,7 +2598,7 @@ static int hclgevf_pci_init(struct hclgevf_dev *hdev)
 	if (!hw->hw.io_base) {
 		dev_err(&pdev->dev, "can't map configuration register space\n");
 		ret = -ENOMEM;
-		goto err_clr_master;
+		goto err_release_regions;
 	}
 
 	ret = hclgevf_dev_mem_map(hdev);
@@ -2609,8 +2609,7 @@ static int hclgevf_pci_init(struct hclgevf_dev *hdev)
 
 err_unmap_io_base:
 	pci_iounmap(pdev, hdev->hw.hw.io_base);
-err_clr_master:
-	pci_clear_master(pdev);
+err_release_regions:
 	pci_release_regions(pdev);
 err_disable_device:
 	pci_disable_device(pdev);
@@ -2626,7 +2625,6 @@ static void hclgevf_pci_uninit(struct hclgevf_dev *hdev)
 		devm_iounmap(&pdev->dev, hdev->hw.hw.mem_base);
 
 	pci_iounmap(pdev, hdev->hw.hw.io_base);
-	pci_clear_master(pdev);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 }
-- 
2.34.1

