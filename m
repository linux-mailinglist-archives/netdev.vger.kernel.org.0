Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DEE35DDF3
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 13:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244553AbhDMLnV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 07:43:21 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:41882 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238540AbhDMLnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 07:43:20 -0400
Received: from tomoyo.flets-east.jp ([153.202.107.157])
        by mwinf5d89 with ME
        id sBio2400A3PnFJp03Biwal; Tue, 13 Apr 2021 13:43:00 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Tue, 13 Apr 2021 13:43:00 +0200
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH] can: etas_es58x: fix null pointer dereference when handling error frames
Date:   Tue, 13 Apr 2021 20:42:42 +0900
Message-Id: <20210413114242.2760-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

During the handling of CAN bus errors, a CAN error SKB is allocated
using alloc_can_err_skb(). Even if the allocation of the SKB fails,
the function continues in order to do the stats handling.

All access to the can_frame pointer (cf) should be guarded by an if
statement:
	if (cf)

However, the increment of the rx_bytes stats:
	netdev->stats.rx_bytes += cf->can_dlc;
dereferences the cf pointer and was not guarded by an if condition
leading to a NULL pointer dereference if the can_err_skb() function
failed.

Replacing the cf->can_dlc by the macro CAN_ERR_DLC (which is the
length of any CAN error frames) solves this NULL pointer dereference.

Fixes: 8537257874e9 ("can: etas_es58x: add core support for ETAS ES58X CAN USB interfaces")
Reported-by: Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
Hi Marc,

I am really sorry, but I was just notified about this issue litteraly
a few minutes after you send the pull request to net-next.

I am not sure how to proceed. You might either cancel the pull request
and squash this to 8537257874e9 ("can: etas_es58x: add core support
for ETAS ES58X CAN USB interfaces") or send it as a separate patch.

Please let me know if you need me to do anything.

Yours sincerely,
Vincent Mailhol
---
 drivers/net/can/usb/etas_es58x/es58x_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/usb/etas_es58x/es58x_core.c b/drivers/net/can/usb/etas_es58x/es58x_core.c
index 7222b3b6ca46..57e5f94468e9 100644
--- a/drivers/net/can/usb/etas_es58x/es58x_core.c
+++ b/drivers/net/can/usb/etas_es58x/es58x_core.c
@@ -856,7 +856,7 @@ int es58x_rx_err_msg(struct net_device *netdev, enum es58x_err error,
 	 * consistency.
 	 */
 	netdev->stats.rx_packets++;
-	netdev->stats.rx_bytes += cf->can_dlc;
+	netdev->stats.rx_bytes += CAN_ERR_DLC;
 
 	if (cf) {
 		if (cf->data[1])
-- 
2.26.3

