Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 142D8D291A
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 14:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733279AbfJJMR5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 08:17:57 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58525 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733116AbfJJMR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 08:17:57 -0400
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iIXOG-0006Lw-1G; Thu, 10 Oct 2019 14:17:56 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org, linux-can <linux-can@vger.kernel.org>
Cc:     davem@davemloft.net, kernel@pengutronix.de,
        jhofstee@victronenergy.com,
        =?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Wen Yang <wenyang@linux.alibaba.com>,
        Franklin S Cooper Jr <fcooper@ti.com>,
        linux-stable <stable@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 01/29] can: dev: add missing of_node_put() after calling of_get_child_by_name()
Date:   Thu, 10 Oct 2019 14:17:22 +0200
Message-Id: <20191010121750.27237-2-mkl@pengutronix.de>
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

From: Wen Yang <wenyang@linux.alibaba.com>

of_node_put() needs to be called when the device node which is got
from of_get_child_by_name() finished using.

Fixes: 2290aefa2e90 ("can: dev: Add support for limiting configured bitrate")
Cc: Franklin S Cooper Jr <fcooper@ti.com>
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index ac86be52b461..1c88c361938c 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -848,6 +848,7 @@ void of_can_transceiver(struct net_device *dev)
 		return;
 
 	ret = of_property_read_u32(dn, "max-bitrate", &priv->bitrate_max);
+	of_node_put(dn);
 	if ((ret && ret != -EINVAL) || (!ret && !priv->bitrate_max))
 		netdev_warn(dev, "Invalid value for transceiver max bitrate. Ignoring bitrate limit.\n");
 }
-- 
2.23.0

