Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFE4A48112
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 13:42:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfFQLmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 07:42:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:45809 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725763AbfFQLmT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 07:42:19 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
        (Exim 4.76)
        (envelope-from <colin.king@canonical.com>)
        id 1hcq1e-0000cD-U1; Mon, 17 Jun 2019 11:42:15 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: hns3: fix dereference of ae_dev before it is null checked
Date:   Mon, 17 Jun 2019 12:42:14 +0100
Message-Id: <20190617114214.25276-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Pointer ae_dev is null checked however, prior to that it is dereferenced
when assigned pointer ops. Fix this by assigning pointer ops after ae_dev
has been null checked.

Addresses-Coverity: ("Dereference before null check")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 951a8125ea0c..58633cdcdcfd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -1940,13 +1940,14 @@ static pci_ers_result_t hns3_error_detected(struct pci_dev *pdev,
 static pci_ers_result_t hns3_slot_reset(struct pci_dev *pdev)
 {
 	struct hnae3_ae_dev *ae_dev = pci_get_drvdata(pdev);
-	const struct hnae3_ae_ops *ops = ae_dev->ops;
+	const struct hnae3_ae_ops *ops;
 	enum hnae3_reset_type reset_type;
 	struct device *dev = &pdev->dev;
 
 	if (!ae_dev || !ae_dev->ops)
 		return PCI_ERS_RESULT_NONE;
 
+	ops = ae_dev->ops;
 	/* request the reset */
 	if (ops->reset_event) {
 		if (!ae_dev->override_pci_need_reset) {
-- 
2.20.1

