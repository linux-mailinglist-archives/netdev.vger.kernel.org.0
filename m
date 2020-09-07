Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3A2225F32D
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 08:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726511AbgIGGc6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 02:32:58 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:41204 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726278AbgIGGcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 02:32:51 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3DCC047700AF50E80729;
        Mon,  7 Sep 2020 14:32:48 +0800 (CST)
Received: from localhost.localdomain (10.175.112.70) by
 DGGEMS402-HUB.china.huawei.com (10.3.19.202) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 7 Sep 2020 14:32:43 +0800
From:   Zhang Changzhong <zhangchangzhong@huawei.com>
To:     <robin@protonic.nl>, <linux@rempel-privat.de>,
        <kernel@pengutronix.de>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] can: j1939: j1939_sk_bind(): return failure if netdev is down
Date:   Mon, 7 Sep 2020 14:31:48 +0800
Message-ID: <1599460308-18770-1-git-send-email-zhangchangzhong@huawei.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.112.70]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
---
 net/can/j1939/socket.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 1be4c89..f239665 100644
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
2.9.5

