Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7196A2A5978
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:07:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731164AbgKCWHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:07:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731152AbgKCWGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:47 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9830C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:46 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4Rw-0006Ui-Pq; Tue, 03 Nov 2020 23:06:44 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 12/27] can: j1939: j1939_sk_bind(): return failure if netdev is down
Date:   Tue,  3 Nov 2020 23:06:21 +0100
Message-Id: <20201103220636.972106-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Changzhong <zhangchangzhong@huawei.com>

When a netdev down event occurs after a successful call to
j1939_sk_bind(), j1939_netdev_notify() can handle it correctly.

But if the netdev already in down state before calling j1939_sk_bind(),
j1939_sk_release() will stay in wait_event_interruptible() blocked
forever. Because in this case, j1939_netdev_notify() won't be called and
j1939_tp_txtimer() won't call j1939_session_cancel() or other function
to clear session for ENETDOWN error, this lead to mismatch of
j1939_session_get/put() and jsk->skb_pending will never decrease to
zero.

To reproduce it use following commands:
1. ip link add dev vcan0 type vcan
2. j1939acd -r 100,80-120 1122334455667788 vcan0
3. presses ctrl-c and thread will be blocked forever

This patch adds check for ndev->flags in j1939_sk_bind() to avoid this
kind of situation and return with -ENETDOWN.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/r/1599460308-18770-1-git-send-email-zhangchangzhong@huawei.com
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/j1939/socket.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 1be4c898b2fa..f23966526a88 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -475,6 +475,12 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 			goto out_release_sock;
 		}
 
+		if (!(ndev->flags & IFF_UP)) {
+			dev_put(ndev);
+			ret = -ENETDOWN;
+			goto out_release_sock;
+		}
+
 		priv = j1939_netdev_start(ndev);
 		dev_put(ndev);
 		if (IS_ERR(priv)) {
-- 
2.28.0

