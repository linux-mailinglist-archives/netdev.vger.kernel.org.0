Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA0E72FD0BD
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 13:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbhATMvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 07:51:21 -0500
Received: from smtp06.smtpout.orange.fr ([80.12.242.128]:57658 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388251AbhATLoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 06:44:05 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d11 with ME
        id JziC2400E3PnFJp03ziJfJ; Wed, 20 Jan 2021 12:42:22 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Wed, 20 Jan 2021 12:42:22 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        linux-can@vger.kernel.org
Cc:     netdev@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        Loris Fauster <loris.fauster@ttcontrol.com>,
        Alejandro Concepcion Rodriguez <alejandro@acoro.eu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 1/3] can: dev: can_restart: fix use after free bug
Date:   Wed, 20 Jan 2021 20:41:35 +0900
Message-Id: <20210120114137.200019-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210120114137.200019-1-mailhol.vincent@wanadoo.fr>
References: <20210120114137.200019-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

After calling netif_rx_ni(skb), dereferencing skb is unsafe.
Especially, the can_frame cf which aliases skb memory is accessed
after the netif_rx_ni() in:
      stats->rx_bytes += cf->len;

Reordering the lines solves the issue.

Fixes: 39549eef3587 ("can: CAN Network device driver and Netlink interface")
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
*Remark for upstream*
drivers/net/can/dev.c has been moved to drivers/net/can/dev/dev.c in
below commit, please carry the patch forward.
Reference: 3e77f70e7345 ("can: dev: move driver related infrastructure
into separate subdir")
---
 drivers/net/can/dev.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 3486704c8a95..8b1ae023cb21 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -592,11 +592,11 @@ static void can_restart(struct net_device *dev)
 
 	cf->can_id |= CAN_ERR_RESTARTED;
 
-	netif_rx_ni(skb);
-
 	stats->rx_packets++;
 	stats->rx_bytes += cf->len;
 
+	netif_rx_ni(skb);
+
 restart:
 	netdev_dbg(dev, "restarted\n");
 	priv->can_stats.restarts++;
-- 
2.26.2

