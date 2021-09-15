Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDC840C805
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238078AbhIOPPv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:15:51 -0400
Received: from mx22.baidu.com ([220.181.50.185]:41264 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233711AbhIOPPu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Sep 2021 11:15:50 -0400
Received: from BJHW-Mail-Ex13.internal.baidu.com (unknown [10.127.64.36])
        by Forcepoint Email with ESMTPS id E621A8897AC90A5A8B69;
        Wed, 15 Sep 2021 22:58:40 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:58:40 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Wed, 15 Sep 2021 22:58:40 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Bin Luo <luobin9@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: hinic: Make use of the helper function dev_err_probe()
Date:   Wed, 15 Sep 2021 22:58:34 +0800
Message-ID: <20210915145835.7569-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BJHW-Mail-Ex09.internal.baidu.com (10.127.64.32) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
X-Baidu-BdMsfe-DateCheck: 1_BJHW-Mail-Ex13_2021-09-15 22:58:41:077
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When possible use dev_err_probe help to properly deal with the
PROBE_DEFER error, the benefit is that DEFER issue will be logged
in the devices_deferred debugfs file.
And using dev_err_probe() can reduce code size, and simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/huawei/hinic/hinic_main.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic/hinic_main.c b/drivers/net/ethernet/huawei/hinic/hinic_main.c
index ae707e305684..9965e8d5d0a9 100644
--- a/drivers/net/ethernet/huawei/hinic/hinic_main.c
+++ b/drivers/net/ethernet/huawei/hinic/hinic_main.c
@@ -1379,10 +1379,8 @@ static int hinic_probe(struct pci_dev *pdev,
 {
 	int err = pci_enable_device(pdev);
 
-	if (err) {
-		dev_err(&pdev->dev, "Failed to enable PCI device\n");
-		return err;
-	}
+	if (err)
+		return dev_err_probe(&pdev->dev, err, "Failed to enable PCI device\n");
 
 	err = pci_request_regions(pdev, HINIC_DRV_NAME);
 	if (err) {
-- 
2.25.1

