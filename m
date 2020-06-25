Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEB9209F00
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 14:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404791AbgFYM6i convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 08:58:38 -0400
Received: from smtprelay08.ispgateway.de ([134.119.228.98]:28265 "EHLO
        smtprelay08.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404650AbgFYM6i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 08:58:38 -0400
X-Greylist: delayed 2034 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jun 2020 08:58:36 EDT
Received: from [89.1.81.74] (helo=ipc1.ka-ro)
        by smtprelay08.ispgateway.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.92.3)
        (envelope-from <LW@KARO-electronics.de>)
        id 1joQvk-0003Qs-9b; Thu, 25 Jun 2020 14:24:36 +0200
Date:   Thu, 25 Jun 2020 14:24:35 +0200
From:   Lothar =?UTF-8?B?V2HDn21hbm4=?= <LW@KARO-electronics.de>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Sriram Dash <sriram.dash@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH BUGFIX] can: m_can: make m_can driver work with sleep state
 pinconfig
Message-ID: <20200625142435.50371e2f@ipc1.ka-ro>
Organization: Ka-Ro electronics GmbH
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Df-Sender: bHdAa2Fyby1lbGVjdHJvbmljcy5kb21haW5mYWN0b3J5LWt1bmRlLmRl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

When trying to use the m_can driver on an stm32mp15 based system, I
found that I could not send or receive any data.
Analyzing the pinctrl registers revealed, that the pins were
configured for sleep state even when the can interfaces were in use.

Looking at the m_can_platform.c driver I found that:

commit f524f829b75a ("can: m_can: Create a m_can platform framework")

introduced a call to m_can_class_suspend() in the m_can_runtime_suspend()
function which wasn't there in the original code and which causes the
pins used by the controller to be configured for sleep state.

commit 0704c5743694 ("can: m_can_platform: remove unnecessary m_can_class_resume() call")
already removed a bogus call to m_can_class_resume() from the
m_can_runtime_resume() function, but failed to remove the matching
call to m_can_class_suspend() from the m_can_runtime_suspend() function.

Removing the bogus call to m_can_class_suspend() in the
m_can_runtime_suspend() function fixes this.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Fixes: 0704c5743694 ("can: m_can_platform: remove unnecessary m_can_class_resume() call")
Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
---
 drivers/net/can/m_can/m_can_platform.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index 38ea5e600fb8..e6d0cb9ee02f 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -144,8 +144,6 @@ static int __maybe_unused m_can_runtime_suspend(struct device *dev)
 	struct net_device *ndev = dev_get_drvdata(dev);
 	struct m_can_classdev *mcan_class = netdev_priv(ndev);
 
-	m_can_class_suspend(dev);
-
 	clk_disable_unprepare(mcan_class->cclk);
 	clk_disable_unprepare(mcan_class->hclk);
 
-- 
2.11.0



-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
