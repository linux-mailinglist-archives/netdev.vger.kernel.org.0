Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84E95D0CA2
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 12:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731176AbfJIKSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 06:18:18 -0400
Received: from inva020.nxp.com ([92.121.34.13]:54076 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731144AbfJIKSK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Oct 2019 06:18:10 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id C416F1A0012;
        Wed,  9 Oct 2019 12:18:09 +0200 (CEST)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 57F1E1A0266;
        Wed,  9 Oct 2019 12:18:05 +0200 (CEST)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id 991C1402EC;
        Wed,  9 Oct 2019 18:17:59 +0800 (SGT)
From:   Anson Huang <Anson.Huang@nxp.com>
To:     fugang.duan@nxp.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, andy.shevchenko@gmail.com,
        rafael.j.wysocki@intel.com, swboyd@chromium.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Linux-imx@nxp.com
Subject: [PATCH 2/2] net: fec_ptp: Use platform_get_irq_xxx_optional() to avoid error message
Date:   Wed,  9 Oct 2019 18:15:48 +0800
Message-Id: <1570616148-11571-2-git-send-email-Anson.Huang@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
References: <1570616148-11571-1-git-send-email-Anson.Huang@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use platform_get_irq_byname_optional() and platform_get_irq_optional()
instead of platform_get_irq_byname() and platform_get_irq() for optional
IRQs to avoid below error message during probe:

[    0.795803] fec 30be0000.ethernet: IRQ pps not found
[    0.800787] fec 30be0000.ethernet: IRQ index 3 not found

Fixes: 7723f4c5ecdb ("driver core: platform: Add an error message to platform_get_irq*()")
Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
---
 drivers/net/ethernet/freescale/fec_ptp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_ptp.c b/drivers/net/ethernet/freescale/fec_ptp.c
index 19e2365..945643c 100644
--- a/drivers/net/ethernet/freescale/fec_ptp.c
+++ b/drivers/net/ethernet/freescale/fec_ptp.c
@@ -600,9 +600,9 @@ void fec_ptp_init(struct platform_device *pdev, int irq_idx)
 
 	INIT_DELAYED_WORK(&fep->time_keep, fec_time_keep);
 
-	irq = platform_get_irq_byname(pdev, "pps");
+	irq = platform_get_irq_byname_optional(pdev, "pps");
 	if (irq < 0)
-		irq = platform_get_irq(pdev, irq_idx);
+		irq = platform_get_irq_optional(pdev, irq_idx);
 	/* Failure to get an irq is not fatal,
 	 * only the PTP_CLOCK_PPS clock events should stop
 	 */
-- 
2.7.4

