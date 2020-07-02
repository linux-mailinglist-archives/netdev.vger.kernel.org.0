Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B94A211F7B
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 11:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgGBJJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 05:09:41 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:6805 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbgGBJJl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 05:09:41 -0400
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 261584EB6E99CFD40B6F;
        Thu,  2 Jul 2020 17:09:40 +0800 (CST)
Received: from kernelci-master.huawei.com (10.175.101.6) by
 DGGEMS410-HUB.china.huawei.com (10.3.19.210) with Microsoft SMTP Server id
 14.3.487.0; Thu, 2 Jul 2020 17:09:32 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Hulk Robot <hulkci@huawei.com>, Tariq Toukan <tariqt@mellanox.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Vaibhav Gupta <vaibhavgupta40@gmail.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
Subject: [PATCH net-next] mlx4: Mark PM functions as __maybe_unused
Date:   Thu, 2 Jul 2020 17:19:46 +0800
Message-ID: <20200702091946.5144-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.175.101.6]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In certain configurations without power management support, the
following warnings happen:

drivers/net/ethernet/mellanox/mlx4/main.c:4388:12:
 warning: 'mlx4_resume' defined but not used [-Wunused-function]
 4388 | static int mlx4_resume(struct device *dev_d)
      |            ^~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx4/main.c:4373:12: warning:
 'mlx4_suspend' defined but not used [-Wunused-function]
 4373 | static int mlx4_suspend(struct device *dev_d)
      |            ^~~~~~~~~~~~
      
Mark these functions as __maybe_unused to make it clear to the
compiler that this is going to happen based on the configuration,
which is the standard for these types of functions.

Fixes: 0e3e206a3e12 ("mlx4: use generic power management")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/mellanox/mlx4/main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/main.c b/drivers/net/ethernet/mellanox/mlx4/main.c
index 4cae7db8d49c..954c22c79f6b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/main.c
+++ b/drivers/net/ethernet/mellanox/mlx4/main.c
@@ -4370,7 +4370,7 @@ static const struct pci_error_handlers mlx4_err_handler = {
 	.resume		= mlx4_pci_resume,
 };
 
-static int mlx4_suspend(struct device *dev_d)
+static int __maybe_unused mlx4_suspend(struct device *dev_d)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);
@@ -4385,7 +4385,7 @@ static int mlx4_suspend(struct device *dev_d)
 	return 0;
 }
 
-static int mlx4_resume(struct device *dev_d)
+static int __maybe_unused mlx4_resume(struct device *dev_d)
 {
 	struct pci_dev *pdev = to_pci_dev(dev_d);
 	struct mlx4_dev_persistent *persist = pci_get_drvdata(pdev);

