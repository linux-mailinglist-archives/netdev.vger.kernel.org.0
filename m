Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21C23D295C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387430AbfJJMSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:18:02 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:54979 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387411AbfJJMSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:18:01 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iIXOJ-0006Lw-PA; Thu, 10 Oct 2019 14:17:59 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org, linux-can <linux-can@vger.kernel.org>
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        jhofstee@victronenergy.com,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 05/29] can: flexcan: disable completely the ECC mechanism
Date:   Thu, 10 Oct 2019 14:17:26 +0200
Message-Id: <20191010121750.27237-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010121750.27237-1-mkl@pengutronix.de>
References: <20191010121750.27237-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joakim Zhang <qiangqing.zhang@nxp.com>

The ECC (memory error detection and correction) mechanism can be
activated or not, controlled by the ECCDIS bit in CAN_MECR. When
disabled, updates on indications and reporting registers are stopped.
So if want to disable ECC completely, had better assert ECCDIS bit, not
just mask the related interrupts.

Fixes: cdce844865be ("can: flexcan: add vf610 support for FlexCAN")
Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index dc5695dffc2e..1cd5179cb876 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -1188,6 +1188,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		reg_mecr = priv->read(&regs->mecr);
 		reg_mecr &= ~FLEXCAN_MECR_ECRWRDIS;
 		priv->write(reg_mecr, &regs->mecr);
+		reg_mecr |= FLEXCAN_MECR_ECCDIS;
 		reg_mecr &= ~(FLEXCAN_MECR_NCEFAFRZ | FLEXCAN_MECR_HANCEI_MSK |
 			      FLEXCAN_MECR_FANCEI_MSK);
 		priv->write(reg_mecr, &regs->mecr);
-- 
2.23.0

