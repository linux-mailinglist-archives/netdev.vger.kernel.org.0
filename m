Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B9F379FBE
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 08:36:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbhEKGhw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 02:37:52 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:2557 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbhEKGhw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 02:37:52 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.58])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4FfSn942d1zkWMx;
        Tue, 11 May 2021 14:34:05 +0800 (CST)
Received: from linux-lmwb.huawei.com (10.175.103.112) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Tue, 11 May 2021 14:36:33 +0800
From:   Zou Wei <zou_wei@huawei.com>
To:     <3chas3@gmail.com>
CC:     <linux-atm-general@lists.sourceforge.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Zou Wei <zou_wei@huawei.com>
Subject: [PATCH -next] atm: iphase: fix possible use-after-free in ia_module_exit()
Date:   Tue, 11 May 2021 14:53:36 +0800
Message-ID: <1620716016-107941-1-git-send-email-zou_wei@huawei.com>
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
 drivers/atm/iphase.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index 933e3ff..3f2ebfb 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -3279,7 +3279,7 @@ static void __exit ia_module_exit(void)
 {
 	pci_unregister_driver(&ia_driver);
 
-        del_timer(&ia_timer);
+	del_timer_sync(&ia_timer);
 }
 
 module_init(ia_module_init);
-- 
2.6.2

