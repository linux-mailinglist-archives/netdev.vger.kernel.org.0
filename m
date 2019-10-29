Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0B8E7E44
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 02:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730201AbfJ2B4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 21:56:42 -0400
Received: from inva020.nxp.com ([92.121.34.13]:58290 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730082AbfJ2B4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Oct 2019 21:56:37 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id CCB4F1A00F4;
        Tue, 29 Oct 2019 02:56:35 +0100 (CET)
Received: from invc005.ap-rdc01.nxp.com (invc005.ap-rdc01.nxp.com [165.114.16.14])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 40EAD1A0310;
        Tue, 29 Oct 2019 02:56:33 +0100 (CET)
Received: from localhost.localdomain (shlinux2.ap.freescale.net [10.192.224.44])
        by invc005.ap-rdc01.nxp.com (Postfix) with ESMTP id B4FE3402E2;
        Tue, 29 Oct 2019 09:56:29 +0800 (SGT)
From:   Anson Huang <Anson.Huang@nxp.com>
To:     fugang.duan@nxp.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Linux-imx@nxp.com
Subject: [PATCH RESEND 2/2] net: fec_ptp: Use platform_get_irq_xxx_optional() to avoid error message
Date:   Tue, 29 Oct 2019 09:53:19 +0800
Message-Id: <1572313999-23317-2-git-send-email-Anson.Huang@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1572313999-23317-1-git-send-email-Anson.Huang@nxp.com>
References: <1572313999-23317-1-git-send-email-Anson.Huang@nxp.com>
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

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Acked-by: Fugang Duan <fugang.duan@nxp.com>
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
---
	- The patch f1da567f1dc1 ("driver core: platform: Add platform_get_irq_byname_optional()")
	  already landed on network/master, resend this patch set.
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

