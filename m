Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D70893EC6E8
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 05:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbhHODeC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 23:34:02 -0400
Received: from smtp11.smtpout.orange.fr ([80.12.242.133]:51027 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235779AbhHODd6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 23:33:58 -0400
Received: from tomoyo.flets-east.jp ([114.149.34.46])
        by mwinf5d21 with ME
        id hfZ7250050zjR6y03fZRx8; Sun, 15 Aug 2021 05:33:28 +0200
X-ME-Helo: tomoyo.flets-east.jp
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sun, 15 Aug 2021 05:33:28 +0200
X-ME-IP: 114.149.34.46
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     =?UTF-8?q?Stefan=20M=C3=A4tje?= <Stefan.Maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v5 1/7] can: netlink: allow user to turn off unsupported features
Date:   Sun, 15 Aug 2021 12:32:42 +0900
Message-Id: <20210815033248.98111-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
References: <20210815033248.98111-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sanity checks on the control modes will reject any request related
to an unsupported features, even turning it off.

Example on an interface which does not support CAN-FD:

$ ip link set can0 type can bitrate 500000 fd off
RTNETLINK answers: Operation not supported

This patch lets such command go through (but requests to turn on an
unsupported feature are, of course, still denied).

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index 147c23d7dab7..80425636049d 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -116,7 +116,7 @@ static int can_changelink(struct net_device *dev, struct nlattr *tb[],
 		maskedflags = cm->flags & cm->mask;
 
 		/* check whether provided bits are allowed to be passed */
-		if (cm->mask & ~(priv->ctrlmode_supported | ctrlstatic))
+		if (maskedflags & ~(priv->ctrlmode_supported | ctrlstatic))
 			return -EOPNOTSUPP;
 
 		/* do not check for static fd-non-iso if 'fd' is disabled */
-- 
2.31.1

