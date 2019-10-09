Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A366FD0CA0
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 12:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731155AbfJIKSL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 06:18:11 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54048 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731118AbfJIKSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 06:18:10 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CBDAA1A0180;
        Wed,  9 Oct 2019 12:18:08 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 6000B1A002C;
        Wed,  9 Oct 2019 12:18:04 +0200 (CEST)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id A0B26402E4;
        Wed,  9 Oct 2019 18:17:58 +0800 (SGT)
From:   Anson Huang <Anson.Huang@nxp.com>
To:     fugang.duan@nxp.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, andy.shevchenko@gmail.com,
        rafael.j.wysocki@intel.com, swboyd@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Linux-imx@nxp.com
Subject: [PATCH 1/2] net: fec_main: Use platform_get_irq_byname_optional() to avoid error message
Date:   Wed,  9 Oct 2019 18:15:47 +0800
Message-Id: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
X-Mailer: git-send-email 2.7.4
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Failed to get irq using name is NOT fatal as driver will use index
to get irq instead, use platform_get_irq_byname_optional() instead
of platform_get_irq_byname() to avoid below error message during
probe:

[    0.819312] fec 30be0000.ethernet: IRQ int0 not found
[    0.824433] fec 30be0000.ethernet: IRQ int1 not found
[    0.829539] fec 30be0000.ethernet: IRQ int2 not found

Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index d4d4c72..22c01b2 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3558,7 +3558,7 @@ fec_probe(struct platform_device *pdev)
 
 	for (i = 0; i < irq_cnt; i++) {
 		snprintf(irq_name, sizeof(irq_name), "int%d", i);
-		irq = platform_get_irq_byname(pdev, irq_name);
+		irq = platform_get_irq_byname_optional(pdev, irq_name);
 		if (irq < 0)
 			irq = platform_get_irq(pdev, i);
 		if (irq < 0) {
-- 
2.7.4

