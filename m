Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0B81B3457
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 03:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbgDVBHu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 21:07:50 -0400
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:4379 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726055AbgDVBHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 21:07:49 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.5]) by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee25e9f98d6b5c-f5e92; Wed, 22 Apr 2020 09:07:34 +0800 (CST)
X-RM-TRANSID: 2ee25e9f98d6b5c-f5e92
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[112.25.154.146])
        by rmsmtp-syy-appsvr03-12003 (RichMail) with SMTP id 2ee35e9f98d3d10-2c015;
        Wed, 22 Apr 2020 09:07:34 +0800 (CST)
X-RM-TRANSID: 2ee35e9f98d3d10-2c015
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     kuba@kernel.org, khalasa@piap.pl, davem@davemloft.net,
        linus.walleij@linaro.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Subject: [PATCH v2] net: ethernet: ixp4xx: Add error handling in ixp4xx_eth_probe()
Date:   Wed, 22 Apr 2020 09:09:22 +0800
Message-Id: <20200422010922.17728-1-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The function ixp4xx_eth_probe() does not perform sufficient error
checking after executing devm_ioremap_resource(), which can result
in crashes if a critical error path is encountered.

Fixes: f458ac479777 ("ARM/net: ixp4xx: Pass ethernet physical base as resource")

Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
v2:
 - add fixed tag
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



