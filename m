Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A69FBF0312
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390577AbfKEQdr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:33:47 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58079 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390299AbfKEQcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:39 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1l0-0002Hp-01; Tue, 05 Nov 2019 17:32:38 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 05/33] can: flexcan: disable completely the ECC mechanism
Date:   Tue,  5 Nov 2019 17:31:47 +0100
Message-Id: <20191105163215.30194-6-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191105163215.30194-1-mkl@pengutronix.de>
References: <20191105163215.30194-1-mkl@pengutronix.de>
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
2.24.0.rc1

