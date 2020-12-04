Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B931A2CEED9
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 14:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgLDNf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 08:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729891AbgLDNf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 08:35:57 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28601C061A53
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 05:35:17 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1klBEx-0004ec-MI
        for netdev@vger.kernel.org; Fri, 04 Dec 2020 14:35:15 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 161DF5A43B2
        for <netdev@vger.kernel.org>; Fri,  4 Dec 2020 13:35:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A33405A439B;
        Fri,  4 Dec 2020 13:35:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a744b6a7;
        Fri, 4 Dec 2020 13:35:09 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Thomas Wagner <thwa1@web.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 2/3] can: isotp: isotp_setsockopt(): block setsockopt on bound sockets
Date:   Fri,  4 Dec 2020 14:35:07 +0100
Message-Id: <20201204133508.742120-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201204133508.742120-1-mkl@pengutronix.de>
References: <20201204133508.742120-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

The isotp socket can be widely configured in its behaviour regarding addressing
types, fill-ups, receive pattern tests and link layer length. Usually all
these settings need to be fixed before bind() and can not be changed
afterwards.

This patch adds a check to enforce the common usage pattern.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Thomas Wagner <thwa1@web.de>
Link: https://lore.kernel.org/r/20201203140604.25488-2-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index d78ab13bd8be..26bdc3c20b7e 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1157,6 +1157,9 @@ static int isotp_setsockopt(struct socket *sock, int level, int optname,
 	if (level != SOL_CAN_ISOTP)
 		return -EINVAL;
 
+	if (so->bound)
+		return -EISCONN;
+
 	switch (optname) {
 	case CAN_ISOTP_OPTS:
 		if (optlen != sizeof(struct can_isotp_options))
-- 
2.29.2


