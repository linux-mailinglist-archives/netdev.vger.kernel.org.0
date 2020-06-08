Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9E21F2FF9
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731231AbgFIAzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728412AbgFHXJ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3915B208C9;
        Mon,  8 Jun 2020 23:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657765;
        bh=hS28z6xSWw2sPqJgW7kXj7XRamTjmuW8YLgw81pClG0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SY3QElyJXncNMHxNSHQWhxnXzkSdOjg9mWPVJzZUyVu1DdElHRwzNtSWZ32ejlS2p
         NM2285EHTgyTtqlaBbexvQo7DsCbWyoN7doKd+Iga6B5eEcRk/6mXJpa0x16sB5De4
         ztx17+VbVPXm5hOme3hd0wCd/CxHp/tsiAlXFS5E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Wei Yongjun <weiyongjun1@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 150/274] octeontx2-pf: Fix error return code in otx2_probe()
Date:   Mon,  8 Jun 2020 19:04:03 -0400
Message-Id: <20200608230607.3361041-150-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 654cad8b6a17dcb00077070b27bc65873951a568 ]

Fix to return negative error code -ENOMEM from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: 5a6d7c9daef3 ("octeontx2-pf: Mailbox communication with AF")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 411e5ea1031e..64786568af0d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1856,13 +1856,17 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	num_vec = pci_msix_vec_count(pdev);
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
 
 	/* Map CSRs */
 	pf->reg_base = pcim_iomap(pdev, PCI_CFG_REG_BAR_NUM, 0);
-- 
2.25.1

