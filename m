Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA69435D1D
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 10:42:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbhJUIoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 04:44:18 -0400
Received: from mx24.baidu.com ([111.206.215.185]:45580 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231459AbhJUIoR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 04:44:17 -0400
Received: from BC-Mail-Ex12.internal.baidu.com (unknown [172.31.51.52])
        by Forcepoint Email with ESMTPS id E6DB256BB77BCB746554;
        Thu, 21 Oct 2021 16:42:00 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BC-Mail-Ex12.internal.baidu.com (172.31.51.52) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.12; Thu, 21 Oct 2021 16:42:00 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Thu, 21 Oct 2021 16:42:00 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <caihuoqing@baidu.com>
CC:     Derek Chickles <dchickles@marvell.com>,
        Satanand Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] net: liquidio: Make use of the helper macro kthread_run()
Date:   Thu, 21 Oct 2021 16:41:58 +0800
Message-ID: <20211021084158.2183-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-EX02.internal.baidu.com (172.31.51.42) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Repalce kthread_create/wake_up_process() with kthread_run()
to simplify the code.

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/ethernet/cavium/liquidio/lio_main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/cavium/liquidio/lio_main.c b/drivers/net/ethernet/cavium/liquidio/lio_main.c
index 1daf63e437ce..12eee2bc7f5c 100644
--- a/drivers/net/ethernet/cavium/liquidio/lio_main.c
+++ b/drivers/net/ethernet/cavium/liquidio/lio_main.c
@@ -892,12 +892,11 @@ liquidio_probe(struct pci_dev *pdev, const struct pci_device_id __maybe_unused *
 			bus = pdev->bus->number;
 			device = PCI_SLOT(pdev->devfn);
 			function = PCI_FUNC(pdev->devfn);
-			oct_dev->watchdog_task = kthread_create(
-			    liquidio_watchdog, oct_dev,
-			    "liowd/%02hhx:%02hhx.%hhx", bus, device, function);
-			if (!IS_ERR(oct_dev->watchdog_task)) {
-				wake_up_process(oct_dev->watchdog_task);
-			} else {
+			oct_dev->watchdog_task = kthread_run(liquidio_watchdog,
+							     oct_dev,
+							     "liowd/%02hhx:%02hhx.%hhx",
+							     bus, device, function);
+			if (IS_ERR(oct_dev->watchdog_task)) {
 				oct_dev->watchdog_task = NULL;
 				dev_err(&oct_dev->pci_dev->dev,
 					"failed to create kernel_thread\n");
-- 
2.25.1

