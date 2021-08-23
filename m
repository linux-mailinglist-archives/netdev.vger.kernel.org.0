Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 225693F49DE
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 13:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhHWLeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 07:34:01 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:25933 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236447AbhHWLd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 07:33:58 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.3]) by rmmx-syy-dmz-app08-12008 (RichMail) with SMTP id 2ee86123876ccd8-049f5; Mon, 23 Aug 2021 19:33:02 +0800 (CST)
X-RM-TRANSID: 2ee86123876ccd8-049f5
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost.localdomain (unknown[223.112.105.130])
        by rmsmtp-syy-appsvr02-12002 (RichMail) with SMTP id 2ee261238767421-c70cc;
        Mon, 23 Aug 2021 19:33:02 +0800 (CST)
X-RM-TRANSID: 2ee261238767421-c70cc
From:   Tang Bin <tangbin@cmss.chinamobile.com>
To:     davem@davemloft.net, wg@grandegger.com, mkl@pengutronix.de,
        kuba@kernel.org, kevinbrace@bracecomputerlab.com,
        romieu@fr.zoreil.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Tang Bin <tangbin@cmss.chinamobile.com>
Subject: [PATCH 1/3] via-rhine: Use of_device_get_match_data to simplify code
Date:   Mon, 23 Aug 2021 19:33:36 +0800
Message-Id: <20210823113338.3568-2-tangbin@cmss.chinamobile.com>
X-Mailer: git-send-email 2.20.1.windows.1
In-Reply-To: <20210823113338.3568-1-tangbin@cmss.chinamobile.com>
References: <20210823113338.3568-1-tangbin@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Retrieve OF match data, it's better and cleaner to use
'of_device_get_match_data' over 'of_match_device'.

Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
---
 drivers/net/ethernet/via/via-rhine.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/via/via-rhine.c b/drivers/net/ethernet/via/via-rhine.c
index 961b623b7..3b73a9c55 100644
--- a/drivers/net/ethernet/via/via-rhine.c
+++ b/drivers/net/ethernet/via/via-rhine.c
@@ -1113,13 +1113,12 @@ static int rhine_init_one_pci(struct pci_dev *pdev,
 
 static int rhine_init_one_platform(struct platform_device *pdev)
 {
-	const struct of_device_id *match;
 	const u32 *quirks;
 	int irq;
 	void __iomem *ioaddr;
 
-	match = of_match_device(rhine_of_tbl, &pdev->dev);
-	if (!match)
+	quirks = of_device_get_match_data(&pdev->dev);
+	if (!quirks)
 		return -EINVAL;
 
 	ioaddr = devm_platform_ioremap_resource(pdev, 0);
@@ -1130,10 +1129,6 @@ static int rhine_init_one_platform(struct platform_device *pdev)
 	if (!irq)
 		return -EINVAL;
 
-	quirks = match->data;
-	if (!quirks)
-		return -EINVAL;
-
 	return rhine_init_one_common(&pdev->dev, *quirks,
 				     (long)ioaddr, ioaddr, irq);
 }
-- 
2.20.1.windows.1



