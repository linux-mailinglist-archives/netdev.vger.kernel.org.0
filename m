Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 245AD1CA087
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 04:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgEHCL3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 22:11:29 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4285 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726509AbgEHCL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 22:11:29 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 94F8C3C73EEDD81B0199;
        Fri,  8 May 2020 10:11:27 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.487.0; Fri, 8 May 2020 10:11:19 +0800
From:   Wei Yongjun <weiyongjun1@huawei.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        Tomasz Duszynski <tduszynski@marvell.com>
CC:     Wei Yongjun <weiyongjun1@huawei.com>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>, Hulk Robot <hulkci@huawei.com>
Subject: [PATCH net-next] octeontx2-vf: Fix error return code in otx2vf_probe()
Date:   Fri, 8 May 2020 02:15:19 +0000
Message-ID: <20200508021519.179062-1-weiyongjun1@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix to return negative error code -ENOMEM from the alloc failed error
handling case instead of 0, as done elsewhere in this function.

Fixes: 3184fb5ba96e ("octeontx2-vf: Virtual function driver support")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index 187c633a7af5..f4227517dc8e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -497,13 +497,17 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	hw->irq_name = devm_kmalloc_array(&hw->pdev->dev, num_vec, NAME_SIZE,
 					  GFP_KERNEL);
-	if (!hw->irq_name)
+	if (!hw->irq_name) {
+		err = -ENOMEM;
 		goto err_free_netdev;
+	}
 
 	hw->affinity_mask = devm_kcalloc(&hw->pdev->dev, num_vec,
 					 sizeof(cpumask_var_t), GFP_KERNEL);
-	if (!hw->affinity_mask)
+	if (!hw->affinity_mask) {
+		err = -ENOMEM;
 		goto err_free_netdev;
+	}
 
 	err = pci_alloc_irq_vectors(hw->pdev, num_vec, num_vec, PCI_IRQ_MSIX);
 	if (err < 0) {



