Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA440438BF6
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhJXUr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232129AbhJXUrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 16:47:22 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BE4C06122A
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 13:44:58 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mekMS-0006SC-Ud
        for netdev@vger.kernel.org; Sun, 24 Oct 2021 22:44:56 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D70BD69C5EE
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 20:43:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9105669C572;
        Sun, 24 Oct 2021 20:43:30 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8c8be900;
        Sun, 24 Oct 2021 20:43:28 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Qing Wang <wangqing@vivo.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 09/15] can: at91/janz-ican3: replace snprintf() in show functions with sysfs_emit()
Date:   Sun, 24 Oct 2021 22:43:19 +0200
Message-Id: <20211024204325.3293425-10-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024204325.3293425-1-mkl@pengutronix.de>
References: <20211024204325.3293425-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qing Wang <wangqing@vivo.com>

The sysfs show() functions must not use snprintf() when formatting the
value to be returned to user space.

Fix the following coccicheck warning:
| drivers/net/can/at91_can.c:1185: WARNING: use scnprintf or sprintf.
| drivers/net/can/janz-ican3.c:1834: WARNING: use scnprintf or sprintf.
|
| Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Link: https://lore.kernel.org/all/1634280624-4816-1-git-send-email-wangqing@vivo.com
Signed-off-by: Qing Wang <wangqing@vivo.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/at91_can.c   | 4 ++--
 drivers/net/can/janz-ican3.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index b06af90a9964..3aea32c9b108 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1170,9 +1170,9 @@ static ssize_t mb0_id_show(struct device *dev,
 	struct at91_priv *priv = netdev_priv(to_net_dev(dev));
 
 	if (priv->mb0_id & CAN_EFF_FLAG)
-		return snprintf(buf, PAGE_SIZE, "0x%08x\n", priv->mb0_id);
+		return sysfs_emit(buf, "0x%08x\n", priv->mb0_id);
 	else
-		return snprintf(buf, PAGE_SIZE, "0x%03x\n", priv->mb0_id);
+		return sysfs_emit(buf, "0x%03x\n", priv->mb0_id);
 }
 
 static ssize_t mb0_id_store(struct device *dev,
diff --git a/drivers/net/can/janz-ican3.c b/drivers/net/can/janz-ican3.c
index c68ad56628bd..32006dbf5abd 100644
--- a/drivers/net/can/janz-ican3.c
+++ b/drivers/net/can/janz-ican3.c
@@ -1831,7 +1831,7 @@ static ssize_t termination_show(struct device *dev,
 		return -ETIMEDOUT;
 	}
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", mod->termination_enabled);
+	return sysfs_emit(buf, "%u\n", mod->termination_enabled);
 }
 
 static ssize_t termination_store(struct device *dev,
-- 
2.33.0


