Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A18535A380
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233980AbhDIQhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:37:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52702 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232395AbhDIQhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 12:37:46 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1lUu8M-0005Xp-Cg; Fri, 09 Apr 2021 16:37:26 +0000
From:   Colin King <colin.king@canonical.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Huazhong Tan <tanhuazhong@huawei.com>,
        Jiaran Zhang <zhangjiaran@huawei.com>, netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] net: hns3: Fix potential null pointer defererence of null ae_dev
Date:   Fri,  9 Apr 2021 17:37:26 +0100
Message-Id: <20210409163726.670672-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The reset_prepare and reset_done calls have a null pointer check
on ae_dev however ae_dev is being dereferenced via the call to
ns3_is_phys_func with the ae->pdev argument. Fix this by performing
a null pointer check on ae_dev and hence short-circuiting the
dereference to ae_dev on the call to ns3_is_phys_func.

Addresses-Coverity: ("Dereference before null check")
Fixes: 715c58e94f0d ("net: hns3: add suspend and resume pm_ops")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 25afe5a3348c..c21dd11baed9 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2369,9 +2369,9 @@ static int __maybe_unused hns3_suspend(struct device *dev)
 {
 	struct hnae3_ae_dev *ae_dev = dev_get_drvdata(dev);
 
-	if (hns3_is_phys_func(ae_dev->pdev)) {
+	if (ae_dev && hns3_is_phys_func(ae_dev->pdev)) {
 		dev_info(dev, "Begin to suspend.\n");
-		if (ae_dev && ae_dev->ops && ae_dev->ops->reset_prepare)
+		if (ae_dev->ops && ae_dev->ops->reset_prepare)
 			ae_dev->ops->reset_prepare(ae_dev, HNAE3_FUNC_RESET);
 	}
 
@@ -2382,9 +2382,9 @@ static int __maybe_unused hns3_resume(struct device *dev)
 {
 	struct hnae3_ae_dev *ae_dev = dev_get_drvdata(dev);
 
-	if (hns3_is_phys_func(ae_dev->pdev)) {
+	if (ae_dev && hns3_is_phys_func(ae_dev->pdev)) {
 		dev_info(dev, "Begin to resume.\n");
-		if (ae_dev && ae_dev->ops && ae_dev->ops->reset_done)
+		if (ae_dev->ops && ae_dev->ops->reset_done)
 			ae_dev->ops->reset_done(ae_dev);
 	}
 
-- 
2.30.2

