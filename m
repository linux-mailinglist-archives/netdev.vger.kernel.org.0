Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728B92ECDF6
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 11:37:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727711AbhAGKgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 05:36:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbhAGKgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 05:36:17 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88429C0612FD
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 02:35:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxSdB-0008S0-0i
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 11:35:01 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CEF045BBCA9
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 10:34:57 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1CECE5BBC7B;
        Thu,  7 Jan 2021 10:34:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ec42f650;
        Thu, 7 Jan 2021 10:34:52 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>,
        Sriram Dash <sriram.dash@samsung.com>,
        Sean Nyekjaer <sean@geanix.com>
Subject: [net 1/6] can: m_can: m_can_class_unregister(): remove erroneous m_can_clk_stop()
Date:   Thu,  7 Jan 2021 11:34:46 +0100
Message-Id: <20210107103451.183477-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107103451.183477-1-mkl@pengutronix.de>
References: <20210107103451.183477-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In m_can_class_register() the clock is started, but stopped on exit. When
calling m_can_class_unregister(), the clock is stopped a second time.

This patch removes the erroneous m_can_clk_stop() in  m_can_class_unregister().

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Cc: Dan Murphy <dmurphy@ti.com>
Cc: Sriram Dash <sriram.dash@samsung.com>
Reviewed-by: Sean Nyekjaer <sean@geanix.com>
Link: https://lore.kernel.org/r/20201215103238.524029-2-mkl@pengutronix.de
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/m_can/m_can.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 2c9f12401276..da551fd0f502 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1852,8 +1852,6 @@ EXPORT_SYMBOL_GPL(m_can_class_register);
 void m_can_class_unregister(struct m_can_classdev *cdev)
 {
 	unregister_candev(cdev->net);
-
-	m_can_clk_stop(cdev);
 }
 EXPORT_SYMBOL_GPL(m_can_class_unregister);
 

base-commit: 1f685e6adbbe3c7b1bd9053be771b898d9efa655
-- 
2.29.2


