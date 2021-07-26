Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD263D5B29
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhGZNcU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234533AbhGZNbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:31:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89262C06179E
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:12:09 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81Kx-00019r-VJ
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:12:08 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A849B6581D5
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:11:58 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4FA00658177;
        Mon, 26 Jul 2021 14:11:48 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 382f16d0;
        Mon, 26 Jul 2021 14:11:45 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 12/46] can: netlink: remove redundant check in can_validate()
Date:   Mon, 26 Jul 2021 16:11:10 +0200
Message-Id: <20210726141144.862529-13-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210726141144.862529-1-mkl@pengutronix.de>
References: <20210726141144.862529-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

can_validate() does a first check:

|	if (is_can_fd) {
|		if (!data[IFLA_CAN_BITTIMING] || !data[IFLA_CAN_DATA_BITTIMING])
|			return -EOPNOTSUPP;
|	}

If that first if succeeds, we know that if is_can_fd is true then
data[IFLA_CAN_BITTIMING is set.

However, the next if switch does not leverage on above knowledge and
redoes the check:

| 	if (data[IFLA_CAN_DATA_BITTIMING]) {
|		if (!is_can_fd || !data[IFLA_CAN_BITTIMING])
|		                   ^~~~~~~~~~~~~~~~~~~~~~~~
| 			return -EOPNOTSUPP;
| 	}

This patch removes that redundant check.

Link: https://lore.kernel.org/r/20210603151550.140727-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/dev/netlink.c b/drivers/net/can/dev/netlink.c
index b567fd628c17..147c23d7dab7 100644
--- a/drivers/net/can/dev/netlink.c
+++ b/drivers/net/can/dev/netlink.c
@@ -47,7 +47,7 @@ static int can_validate(struct nlattr *tb[], struct nlattr *data[],
 	}
 
 	if (data[IFLA_CAN_DATA_BITTIMING]) {
-		if (!is_can_fd || !data[IFLA_CAN_BITTIMING])
+		if (!is_can_fd)
 			return -EOPNOTSUPP;
 	}
 
-- 
2.30.2


