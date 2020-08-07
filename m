Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CC723EBED
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 13:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHGLIr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 07:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728142AbgHGKxh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 06:53:37 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C46C0617AA
        for <netdev@vger.kernel.org>; Fri,  7 Aug 2020 03:52:24 -0700 (PDT)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1k3zym-0004nC-IY; Fri, 07 Aug 2020 12:52:04 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1k3zyk-0007Jp-9r; Fri, 07 Aug 2020 12:52:02 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        syzbot+f03d384f3455d28833eb@syzkaller.appspotmail.com,
        linux-stable <stable@vger.kernel.org>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        David Jander <david@protonic.nl>
Subject: [PATCH v1 3/5] can: j1939: socket: j1939_sk_bind(): make sure ml_priv is allocated
Date:   Fri,  7 Aug 2020 12:51:58 +0200
Message-Id: <20200807105200.26441-4-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200807105200.26441-1-o.rempel@pengutronix.de>
References: <20200807105200.26441-1-o.rempel@pengutronix.de>
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

This patch adds check to ensure that the struct net_device::ml_priv is
allocated, as it is used later by the j1939 stack.

The allocation is done by all mainline CAN network drivers, but when using
bond or team devices this is not the case.

Bail out if no ml_priv is allocated.

Reported-by: syzbot+f03d384f3455d28833eb@syzkaller.appspotmail.com
Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Cc: linux-stable <stable@vger.kernel.org> # >= v5.4
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/socket.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index b9a17c2ee16f..27542de233c7 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -467,6 +467,14 @@ static int j1939_sk_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 			goto out_release_sock;
 		}
 
+		if (!ndev->ml_priv) {
+			netdev_warn_once(ndev,
+					 "No CAN mid layer private allocated, please fix your driver and use alloc_candev()!\n");
+			dev_put(ndev);
+			ret = -ENODEV;
+			goto out_release_sock;
+		}
+
 		priv = j1939_netdev_start(ndev);
 		dev_put(ndev);
 		if (IS_ERR(priv)) {
-- 
2.28.0

