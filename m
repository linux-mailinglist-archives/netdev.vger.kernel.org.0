Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13E8D277E
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 12:50:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732838AbfJJKuk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 06:50:40 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:58789 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732317AbfJJKuk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 06:50:40 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iIW1i-0005dm-GW; Thu, 10 Oct 2019 12:50:34 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iIW1g-0000y4-Iy; Thu, 10 Oct 2019 12:50:32 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     dev.kurt@vandijck-laurijssen.be, mkl@pengutronix.de,
        wg@grandegger.com
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>, kernel@pengutronix.de,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] can: j1939: fix memory leak if filters was set
Date:   Thu, 10 Oct 2019 12:50:31 +0200
Message-Id: <20191010105031.3507-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.23.0
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

Filters array is coped from user space and linked to the j1939 socket.
On socket release this memory was not freed.

Fixes: 9d71dd0c7009 ("can: add support of SAE J1939 protocol")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
---
 net/can/j1939/socket.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/can/j1939/socket.c b/net/can/j1939/socket.c
index 5c6eabcb5df1..4d8ba701e15d 100644
--- a/net/can/j1939/socket.c
+++ b/net/can/j1939/socket.c
@@ -580,6 +580,7 @@ static int j1939_sk_release(struct socket *sock)
 		j1939_netdev_stop(priv);
 	}
 
+	kfree(jsk->filters);
 	sock_orphan(sk);
 	sock->sk = NULL;
 
-- 
2.23.0

