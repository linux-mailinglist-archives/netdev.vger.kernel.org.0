Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF44268F95D
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 22:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbjBHVBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 16:01:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231140AbjBHVB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 16:01:29 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF0F43EFF7
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 13:00:41 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pPrYA-00007c-Cr
        for netdev@vger.kernel.org; Wed, 08 Feb 2023 22:00:18 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C2178173CE5
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 21:00:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1ED02173CD2;
        Wed,  8 Feb 2023 21:00:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 25728532;
        Wed, 8 Feb 2023 21:00:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 1/2] can: raw: use temp variable instead of rolling back config
Date:   Wed,  8 Feb 2023 22:00:13 +0100
Message-Id: <20230208210014.3169347-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230208210014.3169347-1-mkl@pengutronix.de>
References: <20230208210014.3169347-1-mkl@pengutronix.de>
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

Introduce a temporary variable to check for an invalid configuration
attempt from user space. Before this patch the value was copied to
the real config variable and rolled back in the case of an error.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20230203090807.97100-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/raw.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index ba86782ba8bb..f64469b98260 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -523,6 +523,7 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 	struct can_filter sfilter;         /* single filter */
 	struct net_device *dev = NULL;
 	can_err_mask_t err_mask = 0;
+	int fd_frames;
 	int count = 0;
 	int err = 0;
 
@@ -664,17 +665,17 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 		break;
 
 	case CAN_RAW_FD_FRAMES:
-		if (optlen != sizeof(ro->fd_frames))
+		if (optlen != sizeof(fd_frames))
 			return -EINVAL;
 
-		if (copy_from_sockptr(&ro->fd_frames, optval, optlen))
+		if (copy_from_sockptr(&fd_frames, optval, optlen))
 			return -EFAULT;
 
 		/* Enabling CAN XL includes CAN FD */
-		if (ro->xl_frames && !ro->fd_frames) {
-			ro->fd_frames = ro->xl_frames;
+		if (ro->xl_frames && !fd_frames)
 			return -EINVAL;
-		}
+
+		ro->fd_frames = fd_frames;
 		break;
 
 	case CAN_RAW_XL_FRAMES:

base-commit: e6ebe6c12355538e9238e2051bd6757b12dbfe9c
-- 
2.39.1


