Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DF12C8478
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 13:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725980AbgK3Myn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 07:54:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726326AbgK3Myf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 07:54:35 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21FE8C061A4B
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 04:53:17 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjig7-00043Q-Mv
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 13:53:15 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id EDC6059F912
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 12:53:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BC7D859F8EC;
        Mon, 30 Nov 2020 12:53:09 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 702e9f10;
        Mon, 30 Nov 2020 12:53:08 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Zhang Qilong <zhangqilong3@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 4/5] can: c_can: c_can_power_up(): fix error handling
Date:   Mon, 30 Nov 2020 13:53:06 +0100
Message-Id: <20201130125307.218258-5-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201130125307.218258-1-mkl@pengutronix.de>
References: <20201130125307.218258-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

In the error handling in c_can_power_up(), there are two bugs:

1) c_can_pm_runtime_get_sync() will increase usage counter if device is not
   empty. Forgetting to call c_can_pm_runtime_put_sync() will result in a
   reference leak here.

2) c_can_reset_ram() operation will set start bit when enable is true. We
   should clear it in the error handling.

We fix it by adding c_can_pm_runtime_put_sync() for 1), and
c_can_reset_ram(enable is false) for 2) in the error handling.

Fixes: 8212003260c60 ("can: c_can: Add d_can suspend resume support")
Fixes: 52cde85acc23f ("can: c_can: Add d_can raminit support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Link: https://lore.kernel.org/r/20201128133922.3276973-2-zhangqilong3@huawei.com
[mkl: return "0" instead of "ret"]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/c_can/c_can.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/c_can/c_can.c b/drivers/net/can/c_can/c_can.c
index 1ccdbe89585b..1a9e9b9a4bf6 100644
--- a/drivers/net/can/c_can/c_can.c
+++ b/drivers/net/can/c_can/c_can.c
@@ -1295,12 +1295,22 @@ int c_can_power_up(struct net_device *dev)
 				time_after(time_out, jiffies))
 		cpu_relax();
 
-	if (time_after(jiffies, time_out))
-		return -ETIMEDOUT;
+	if (time_after(jiffies, time_out)) {
+		ret = -ETIMEDOUT;
+		goto err_out;
+	}
 
 	ret = c_can_start(dev);
-	if (!ret)
-		c_can_irq_control(priv, true);
+	if (ret)
+		goto err_out;
+
+	c_can_irq_control(priv, true);
+
+	return 0;
+
+err_out:
+	c_can_reset_ram(priv, false);
+	c_can_pm_runtime_put_sync(priv);
 
 	return ret;
 }
-- 
2.29.2


