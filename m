Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C032D57B1
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 10:58:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729978AbgLJJ4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 04:56:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728802AbgLJJ4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 04:56:40 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DE8CC061257
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 01:55:20 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1knIfO-00010t-Gb
        for netdev@vger.kernel.org; Thu, 10 Dec 2020 10:55:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 5C2B45AA1C9
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 09:55:15 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 8310B5AA199;
        Thu, 10 Dec 2020 09:55:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f8ccf389;
        Thu, 10 Dec 2020 09:55:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Sean Nyekjaer <sean@geanix.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 3/7] can: m_can: m_can_config_endisable(): remove double clearing of clock stop request bit
Date:   Thu, 10 Dec 2020 10:55:03 +0100
Message-Id: <20201210095507.1551220-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210095507.1551220-1-mkl@pengutronix.de>
References: <20201210095507.1551220-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Nyekjaer <sean@geanix.com>

The CSR bit is already cleared when arriving here so remove this section of
duplicate code.

The registers set in m_can_config_endisable() is set to same exact values as
before this patch.

Signed-off-by: Sean Nyekjaer <sean@geanix.com>
Acked-by: Sriram Dash <sriram.dash@samsung.com>
Acked-by: Dan Murphy <dmurphy@ti.com>
Link: https://lore.kernel.org/r/20191211063227.84259-1-sean@geanix.com
Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 05c978d1c53d..8f389df26afc 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -380,10 +380,6 @@ void m_can_config_endisable(struct m_can_classdev *cdev, bool enable)
 		cccr &= ~CCCR_CSR;
 
 	if (enable) {
-		/* Clear the Clock stop request if it was set */
-		if (cccr & CCCR_CSR)
-			cccr &= ~CCCR_CSR;
-
 		/* enable m_can configuration */
 		m_can_write(cdev, M_CAN_CCCR, cccr | CCCR_INIT);
 		udelay(5);
-- 
2.29.2


