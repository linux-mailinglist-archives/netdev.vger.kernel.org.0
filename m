Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B74D379FD9
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 08:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbhEKGnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 02:43:06 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2691 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhEKGnE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 02:43:04 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FfSv959Dxz1BKkF;
        Tue, 11 May 2021 14:39:17 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.498.0; Tue, 11 May 2021 14:41:51 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <isdn@linux-pingi.de>, <davem@davemloft.net>,
        <gustavoars@kernel.org>, <christophe.jaillet@wanadoo.fr>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] mISDN: fix possible use-after-free in HFC_cleanup()
Date:   Tue, 11 May 2021 14:58:53 +0800
Message-ID: <1620716333-108153-1-git-send-email-zou_wei@huawei.com>
X-Mailer: git-send-email 2.6.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.103.112]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This module's remove path calls del_timer(). However, that function
does not wait until the timer handler finishes. This means that the
timer handler may still be running after the driver's remove function
has finished, which would result in a use-after-free.

Fix by calling del_timer_sync(), which makes sure the timer handler
has finished, and unable to re-schedule itself.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zou Wei <zou_wei@huawei.com>
---
 drivers/isdn/hardware/mISDN/hfcpci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 56bd2e9..e501cb0 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2342,7 +2342,7 @@ static void __exit
 HFC_cleanup(void)
 {
 	if (timer_pending(&hfc_tl))
-		del_timer(&hfc_tl);
+		del_timer_sync(&hfc_tl);
 
 	pci_unregister_driver(&hfc_driver);
 }
-- 
2.6.2

