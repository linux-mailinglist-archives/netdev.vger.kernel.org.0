Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68B811A5DC0
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 11:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgDLJ0N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 05:26:13 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:3994 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgDLJ0N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 05:26:13 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.19]) by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee55e92de9da03-1fbc8; Sun, 12 Apr 2020 17:25:51 +0800 (CST)
X-RM-TRANSID: 2ee55e92de9da03-1fbc8
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.1.172.56])
        by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea5e92de9c9bf-68f8a;
        Sun, 12 Apr 2020 17:25:51 +0800 (CST)
X-RM-TRANSID: 2eea5e92de9c9bf-68f8a
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     khalasa@piap.pl, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Shengju Zhang <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH] net: ethernet: ixp4xx: Add error handling in ixp4xx_eth_probe()
Date:   Sun, 12 Apr 2020 17:27:28 +0800
Message-Id: <20200412092728.8396-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ixp4xx_eth_probe() does not perform sufficient error
checking after executing devm_ioremap_resource(),which can result
in crashes if a critical error path is encountered.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
Signed-off-by: Shengju Zhang <zhangshengju@cmss.chinamobile.com>
---
 drivers/net/ethernet/xscale/ixp4xx_eth.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/xscale/ixp4xx_eth.c b/drivers/net/ethernet/xscale/ixp4xx_eth.c
index 269596c15..2e5202923 100644
--- a/drivers/net/ethernet/xscale/ixp4xx_eth.c
+++ b/drivers/net/ethernet/xscale/ixp4xx_eth.c
@@ -1387,6 +1387,8 @@ static int ixp4xx_eth_probe(struct platform_device *pdev)
 		return -ENODEV;
 	regs_phys = res->start;
 	port->regs = devm_ioremap_resource(dev, res);
+	if (IS_ERR(port->regs))
+		return PTR_ERR(port->regs);
 
 	switch (port->id) {
 	case IXP4XX_ETH_NPEA:
-- 
2.20.1.windows.1



