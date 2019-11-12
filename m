Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A84AF8DC5
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:16:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLLQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:16:10 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59773 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726376AbfKLLQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:16:10 -0500
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9U-0003F9-1s; Tue, 12 Nov 2019 12:16:04 +0100
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iUU9S-0004yM-Al; Tue, 12 Nov 2019 12:16:02 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+95c8e0d9dffde15b6c5c@syzkaller.appspotmail.com,
        kernel@pengutronix.de, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v1 3/9] can: j1939: main: j1939_ndev_to_priv(): avoid crash if can_ml_priv is NULL
Date:   Tue, 12 Nov 2019 12:15:54 +0100
Message-Id: <20191112111600.18719-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
In-Reply-To: <20191112111600.18719-1-o.rempel@pengutronix.de>
References: <20191112111600.18719-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
2.24.0.rc1

