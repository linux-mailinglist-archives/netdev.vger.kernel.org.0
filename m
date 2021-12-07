Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274B846AEFC
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 01:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378217AbhLGAYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 19:24:50 -0500
Received: from aposti.net ([89.234.176.197]:52456 "EHLO aposti.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378219AbhLGAYt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 19:24:49 -0500
From:   Paul Cercueil <paul@crapouillou.net>
To:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Jonathan Cameron <jic23@kernel.org>
Cc:     list@opendingux.net, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-pm@vger.kernel.org,
        Paul Cercueil <paul@crapouillou.net>,
        Heiner Kallweit <hkallweit1@gmail.com>, nic_swsd@realtek.com,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 1/5] r8169: Avoid misuse of pm_ptr() macro
Date:   Tue,  7 Dec 2021 00:20:58 +0000
Message-Id: <20211207002102.26414-2-paul@crapouillou.net>
In-Reply-To: <20211207002102.26414-1-paul@crapouillou.net>
References: <20211207002102.26414-1-paul@crapouillou.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pm_ptr() macro should be used when the suspend and resume functions
can be compiled independently of the CONFIG_PM Kconfig option.

In the case of this driver, the suspend and resume functions are inside
a section protected by a #ifdef CONFIG_PM guard. Therefore pm_ptr()
should not be used.

Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: <nic_swsd@realtek.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>

---
 drivers/net/ethernet/realtek/r8169_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 86c44bc5f73f..6b81f95698f0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -5441,7 +5441,9 @@ static struct pci_driver rtl8169_pci_driver = {
 	.probe		= rtl_init_one,
 	.remove		= rtl_remove_one,
 	.shutdown	= rtl_shutdown,
-	.driver.pm	= pm_ptr(&rtl8169_pm_ops),
+#ifdef CONFIG_PM
+	.driver.pm	= &rtl8169_pm_ops,
+#endif
 };
 
 module_pci_driver(rtl8169_pci_driver);
-- 
2.33.0

