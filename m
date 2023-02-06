Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49A6A68BDB9
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjBFNSV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:18:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjBFNSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:18:08 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F41424123
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:27 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1N7-0007eD-Em
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:25 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6837A171307
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:24 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 65381171298;
        Mon,  6 Feb 2023 13:16:22 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f9de0d13;
        Mon, 6 Feb 2023 13:16:21 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 02/47] can: isotp: check CAN address family in isotp_bind()
Date:   Mon,  6 Feb 2023 14:15:35 +0100
Message-Id: <20230206131620.2758724-3-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230206131620.2758724-1-mkl@pengutronix.de>
References: <20230206131620.2758724-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

Add missing check to block non-AF_CAN binds.

Syzbot created some code which matched the right sockaddr struct size
but used AF_XDP (0x2C) instead of AF_CAN (0x1D) in the address family
field:

bind$xdp(r2, &(0x7f0000000540)={0x2c, 0x0, r4, 0x0, r2}, 0x10)
                                ^^^^
This has no funtional impact but the userspace should be notified about
the wrong address family field content.

Link: https://syzkaller.appspot.com/text?tag=CrashLog&x=11ff9d8c480000
Reported-by: syzbot+5aed6c3aaba661f5b917@syzkaller.appspotmail.com
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230104201844.13168-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 608f8c24ae46..a18450ffae01 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1225,6 +1225,9 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (len < ISOTP_MIN_NAMELEN)
 		return -EINVAL;
 
+	if (addr->can_family != AF_CAN)
+		return -EINVAL;
+
 	/* sanitize tx CAN identifier */
 	if (tx_id & CAN_EFF_FLAG)
 		tx_id &= (CAN_EFF_FLAG | CAN_EFF_MASK);
-- 
2.39.1


