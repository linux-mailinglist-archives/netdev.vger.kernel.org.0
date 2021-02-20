Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641FD320486
	for <lists+netdev@lfdr.de>; Sat, 20 Feb 2021 10:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbhBTI6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Feb 2021 03:58:30 -0500
Received: from lucky1.263xmail.com ([211.157.147.134]:52820 "EHLO
        lucky1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhBTI62 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Feb 2021 03:58:28 -0500
X-Greylist: delayed 431 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Feb 2021 03:58:22 EST
Received: from localhost (unknown [192.168.167.235])
        by lucky1.263xmail.com (Postfix) with ESMTP id 01BFDC78E1;
        Sat, 20 Feb 2021 16:46:05 +0800 (CST)
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ADDR-CHECKED4: 1
X-ANTISPAM-LEVEL: 2
X-ABS-CHECKED: 0
Received: from localhost.localdomain (unknown [113.57.152.160])
        by smtp.263.net (postfix) whith ESMTP id P19729T140184970585856S1613810765103785_;
        Sat, 20 Feb 2021 16:46:05 +0800 (CST)
X-IP-DOMAINF: 1
X-UNIQUE-TAG: <04315e02bf5ca4945840c9eb391ee223>
X-RL-SENDER: chenhaoa@uniontech.com
X-SENDER: chenhaoa@uniontech.com
X-LOGIN-NAME: chenhaoa@uniontech.com
X-FST-TO: tony0620emma@gmail.com
X-SENDER-IP: 113.57.152.160
X-ATTACHMENT-NUM: 0
X-System-Flag: 0
From:   Hao Chen <chenhaoa@uniontech.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hao Chen <chenhaoa@uniontech.com>
Subject: [PATCH] rtw88: 8822ce: fix wifi disconnect after S3/S4 on HONOR laptop
Date:   Sat, 20 Feb 2021 16:46:02 +0800
Message-Id: <20210220084602.22386-1-chenhaoa@uniontech.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the laptop HONOR MagicBook 14 sleep to S3/S4, the laptop can't
resume.
The dmesg of kernel report:
"[   99.990168] pcieport 0000:00:01.2: can't change power state
from D3hot to D0 (config space inaccessible)
[   99.993334] rtw_pci 0000:01:00.0: can't change power state
from D3hot to D0 (config space inaccessible)
[  104.435004] rtw_pci 0000:01:00.0: mac power on failed
[  104.435010] rtw_pci 0000:01:00.0: failed to power on mac"
When try to pointer the driver.pm to NULL, the problem is fixed.
This driver hasn't implemented pm ops yet.It makes the sleep and
wake procedure expected when pm's ops not NULL.

Fixed: commit e3037485c68e ("rtw88: new Realtek 802.11ac driver")

Signed-off-by: Hao Chen <chenhaoa@uniontech.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822ce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
index 3845b1333dc3..b4c6762ba7ac 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822ce.c
@@ -25,7 +25,7 @@ static struct pci_driver rtw_8822ce_driver = {
 	.id_table = rtw_8822ce_id_table,
 	.probe = rtw_pci_probe,
 	.remove = rtw_pci_remove,
-	.driver.pm = &rtw_pm_ops,
+	.driver.pm = NULL,
 	.shutdown = rtw_pci_shutdown,
 };
 module_pci_driver(rtw_8822ce_driver);
-- 
2.20.1



