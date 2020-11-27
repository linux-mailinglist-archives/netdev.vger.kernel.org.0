Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC622C627B
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729011AbgK0KEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:04:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728934AbgK0KEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Nov 2020 05:04:05 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5306CC0617A7
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 02:04:05 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kiabj-0007hf-UF
        for netdev@vger.kernel.org; Fri, 27 Nov 2020 11:04:04 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id BDB7E59DEAD
        for <netdev@vger.kernel.org>; Fri, 27 Nov 2020 10:04:02 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9A04C59DE72;
        Fri, 27 Nov 2020 10:03:54 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 6f3eee06;
        Fri, 27 Nov 2020 10:03:53 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com,
        syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com,
        syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 6/6] can: af_can: can_rx_unregister(): remove WARN() statement from list operation sanity check
Date:   Fri, 27 Nov 2020 11:03:01 +0100
Message-Id: <20201127100301.512603-7-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127100301.512603-1-mkl@pengutronix.de>
References: <20201127100301.512603-1-mkl@pengutronix.de>
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

To detect potential bugs in CAN protocol implementations (double removal of
receiver entries) a WARN() statement has been used if no matching list item was
found for removal.

The fault injection issued by syzkaller was able to create a situation where
the closing of a socket runs simultaneously to the notifier call chain for
removing the CAN network device in use.

This case is very unlikely in real life but it doesn't break anything.
Therefore we just replace the WARN() statement with pr_warn() to preserve the
notification for the CAN protocol development.

Reported-by: syzbot+381d06e0c8eaacb8706f@syzkaller.appspotmail.com
Reported-by: syzbot+d0ddd88c9a7432f041e6@syzkaller.appspotmail.com
Reported-by: syzbot+76d62d3b8162883c7d11@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/r/20201126192140.14350-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/af_can.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 5d124c155904..4c343b43067f 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -541,10 +541,13 @@ void can_rx_unregister(struct net *net, struct net_device *dev, canid_t can_id,
 
 	/* Check for bugs in CAN protocol implementations using af_can.c:
 	 * 'rcv' will be NULL if no matching list item was found for removal.
+	 * As this case may potentially happen when closing a socket while
+	 * the notifier for removing the CAN netdev is running we just print
+	 * a warning here.
 	 */
 	if (!rcv) {
-		WARN(1, "BUG: receive list entry not found for dev %s, id %03X, mask %03X\n",
-		     DNAME(dev), can_id, mask);
+		pr_warn("can: receive list entry not found for dev %s, id %03X, mask %03X\n",
+			DNAME(dev), can_id, mask);
 		goto out;
 	}
 
-- 
2.29.2


