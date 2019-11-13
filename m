Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65332FADBC
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 10:56:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfKMJ4B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 04:56:01 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52085 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727482AbfKMJz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 04:55:58 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iUpNU-0006Nh-RC; Wed, 13 Nov 2019 10:55:56 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+95c8e0d9dffde15b6c5c@syzkaller.appspotmail.com
Subject: [PATCH 3/9] can: j1939: main: j1939_ndev_to_priv(): avoid crash if can_ml_priv is NULL
Date:   Wed, 13 Nov 2019 10:55:44 +0100
Message-Id: <20191113095550.26527-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191113095550.26527-1-mkl@pengutronix.de>
References: <20191113095550.26527-1-mkl@pengutronix.de>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

This patch avoids a NULL pointer deref crash if ndev->ml_priv is NULL.

Reported-by: syzbot+95c8e0d9dffde15b6c5c@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/j1939/main.c b/net/can/j1939/main.c
index def2f813ffce..8dc935dc2e54 100644
--- a/net/can/j1939/main.c
+++ b/net/can/j1939/main.c
@@ -207,6 +207,9 @@ static inline struct j1939_priv *j1939_ndev_to_priv(struct net_device *ndev)
 {
 	struct can_ml_priv *can_ml_priv = ndev->ml_priv;
 
+	if (!can_ml_priv)
+		return NULL;
+
 	return can_ml_priv->j1939_priv;
 }
 
-- 
2.24.0

