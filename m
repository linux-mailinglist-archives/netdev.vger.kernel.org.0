Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3E8F697C2
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 17:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731581AbfGONuf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 09:50:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731955AbfGONu3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 09:50:29 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 896AB2067C;
        Mon, 15 Jul 2019 13:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563198628;
        bh=CGAunlT7Noi4iBaQk9/HGjgIGmvAcb1wMMKm1D0nFvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Chkfwv/uYzfUJKPwX+OmvPlqJ9XSbZme/e/ArGZnl5to39bdAgYTDgrTjwZH3RyDv
         Fndr5HYunIknUM5HjI/z0hmddgF5Dlq65c7EQZpog+VKfgcVs+1OLhg6/ixa/TVgIQ
         LQw4JjE1AGXhqui79BpcaO5i1B/0Gk6v3JBCwFyo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Weihang Li <liweihang@hisilicon.com>,
        Peng Li <lipeng321@huawei.com>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 064/249] net: hns3: add a check to pointer in error_detected and slot_reset
Date:   Mon, 15 Jul 2019 09:43:49 -0400
Message-Id: <20190715134655.4076-64-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715134655.4076-1-sashal@kernel.org>
References: <20190715134655.4076-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weihang Li <liweihang@hisilicon.com>

[ Upstream commit 661262bc3e0ecc9a1aed39c6b2a99766da2c22e2 ]

If we add a VF without loading hclgevf.ko and then there is a RAS error
occurs, PCIe AER will call error_detected and slot_reset of all functions,
and will get a NULL pointer when we check ad_dev->ops->handle_hw_ras_error.
This will cause a call trace and failures on handling of follow-up RAS
errors.

This patch check ae_dev and ad_dev->ops at first to solve above issues.

Signed-off-by: Weihang Li <liweihang@hisilicon.com>
Signed-off-by: Peng Li <lipeng321@huawei.com>
Signed-off-by: Huazhong Tan <tanhuazhong@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index cd59c0cc636a..5611b990ac34 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1916,9 +1916,9 @@ static pci_ers_result_t hns3_error_detected(struct pci_dev *pdev,
 	if (state == pci_channel_io_perm_failure)
 		return PCI_ERS_RESULT_DISCONNECT;
 
-	if (!ae_dev) {
+	if (!ae_dev || !ae_dev->ops) {
 		dev_err(&pdev->dev,
-			"Can't recover - error happened during device init\n");
+			"Can't recover - error happened before device initialized\n");
 		return PCI_ERS_RESULT_NONE;
 	}
 
@@ -1937,6 +1937,9 @@ static pci_ers_result_t hns3_slot_reset(struct pci_dev *pdev)
 
 	dev_info(dev, "requesting reset due to PCI error\n");
 
+	if (!ae_dev || !ae_dev->ops)
+		return PCI_ERS_RESULT_NONE;
+
 	/* request the reset */
 	if (ae_dev->ops->reset_event) {
 		if (!ae_dev->override_pci_need_reset)
-- 
2.20.1

