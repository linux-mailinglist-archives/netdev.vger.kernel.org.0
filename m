Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F5B1DAF7B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 11:55:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726832AbgETJzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 05:55:24 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:3521 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbgETJzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 05:55:22 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.11]) by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee55ec4fe6c984-67feb; Wed, 20 May 2020 17:54:52 +0800 (CST)
X-RM-TRANSID: 2ee55ec4fe6c984-67feb
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[117.136.67.50])
        by rmsmtp-syy-appsvr06-12006 (RichMail) with SMTP id 2ee65ec4fe6835b-f17be;
        Wed, 20 May 2020 17:54:52 +0800 (CST)
X-RM-TRANSID: 2ee65ec4fe6835b-f17be
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, ralf@linux-mips.org, paulburton@kernel.org,
        tbogendoerfer@suse.de
Cc:     linux-mips@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net: sgi: ioc3-eth: Fix return value check in ioc3eth_probe()
Date:   Wed, 20 May 2020 17:55:32 +0800
Message-Id: <20200520095532.20780-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the function devm_platform_ioremap_resource(), if get resource
failed, the return value is ERR_PTR() not NULL. Thus it must be
replaced by IS_ERR(), or else it may result in crashes if a critical
error path is encountered.

Fixes: 0ce5ebd24d25 ("mfd: ioc3: Add driver for SGI IOC3 chip")
Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/sgi/ioc3-eth.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/sgi/ioc3-eth.c b/drivers/net/ethernet/sgi/ioc3-eth.c
index db6b2988e..8021a3d34 100644
--- a/drivers/net/ethernet/sgi/ioc3-eth.c
+++ b/drivers/net/ethernet/sgi/ioc3-eth.c
@@ -865,17 +865,17 @@ static int ioc3eth_probe(struct platform_device *pdev)
 	ip = netdev_priv(dev);
 	ip->dma_dev = pdev->dev.parent;
 	ip->regs = devm_platform_ioremap_resource(pdev, 0);
-	if (!ip->regs) {
-		err = -ENOMEM;
+	if (IS_ERR(ip->regs)) {
+		err = PTR_ERR(ip->regs);
 		goto out_free;
 	}
 
 	ip->ssram = devm_platform_ioremap_resource(pdev, 1);
-	if (!ip->ssram) {
-		err = -ENOMEM;
+	if (IS_ERR(ip->ssram)) {
+		err = PTR_ERR(ip->ssram);
 		goto out_free;
 	}
-
+
 	dev->irq = platform_get_irq(pdev, 0);
 	if (dev->irq < 0) {
 		err = dev->irq;
-- 
2.20.1.windows.1



