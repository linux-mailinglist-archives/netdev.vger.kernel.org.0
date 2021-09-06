Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7015401915
	for <lists+netdev@lfdr.de>; Mon,  6 Sep 2021 11:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241464AbhIFJo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Sep 2021 05:44:26 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:15294 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241546AbhIFJoR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Sep 2021 05:44:17 -0400
Received: from dggeml757-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4H33NL5N1Jz8srt;
        Mon,  6 Sep 2021 17:42:42 +0800 (CST)
Received: from localhost.localdomain (10.175.104.82) by
 dggeml757-chm.china.huawei.com (10.1.199.137) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 6 Sep 2021 17:43:09 +0800
From:   Ziyang Xuan <william.xuanziyang@huawei.com>
To:     <robin@protonic.nl>
CC:     <linux@rempel-privat.de>, <socketcan@hartkopp.net>,
        <mkl@pengutronix.de>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] can: j1939: fix errant alert in j1939_tp_rxtimer
Date:   Mon, 6 Sep 2021 17:42:19 +0800
Message-ID: <20210906094219.95924-1-william.xuanziyang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.104.82]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggeml757-chm.china.huawei.com (10.1.199.137)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the session state is J1939_SESSION_DONE, j1939_tp_rxtimer() will
give an alert "rx timeout, send abort", but do nothing actually.
Move the alert into session active judgment condition, it is more
reasonable.

One of the scenarioes is that j1939_tp_rxtimer() execute followed by
j1939_xtp_rx_abort_one(). After j1939_xtp_rx_abort_one(), the session
state is J1939_SESSION_DONE, then j1939_tp_rxtimer() give an alert.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
---
 net/can/j1939/transport.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/can/j1939/transport.c b/net/can/j1939/transport.c
index 0f8309314075..d3f0a062b400 100644
--- a/net/can/j1939/transport.c
+++ b/net/can/j1939/transport.c
@@ -1226,12 +1226,11 @@ static enum hrtimer_restart j1939_tp_rxtimer(struct hrtimer *hrtimer)
 		session->err = -ETIME;
 		j1939_session_deactivate(session);
 	} else {
-		netdev_alert(priv->ndev, "%s: 0x%p: rx timeout, send abort\n",
-			     __func__, session);
-
 		j1939_session_list_lock(session->priv);
 		if (session->state >= J1939_SESSION_ACTIVE &&
 		    session->state < J1939_SESSION_ACTIVE_MAX) {
+			netdev_alert(priv->ndev, "%s: 0x%p: rx timeout, send abort\n",
+				     __func__, session);
 			j1939_session_get(session);
 			hrtimer_start(&session->rxtimer,
 				      ms_to_ktime(J1939_XTP_ABORT_TIMEOUT_MS),
-- 
2.25.1

