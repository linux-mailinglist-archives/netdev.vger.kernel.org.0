Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C95DF438BE8
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232090AbhJXUrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232049AbhJXUrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 16:47:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0BB7C061348
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 13:44:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mekMP-0006LS-5B
        for netdev@vger.kernel.org; Sun, 24 Oct 2021 22:44:53 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 94B8C69C598
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 20:43:31 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A128A69C553;
        Sun, 24 Oct 2021 20:43:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d25583e6;
        Sun, 24 Oct 2021 20:43:27 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Thomas Gleixner <tglx@linutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 01/15] can: bcm: Use hrtimer_forward_now()
Date:   Sun, 24 Oct 2021 22:43:11 +0200
Message-Id: <20211024204325.3293425-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211024204325.3293425-1-mkl@pengutronix.de>
References: <20211024204325.3293425-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

hrtimer_forward_now() provides the same functionality as the open coded
hrimer_forward() invocation. Prepares for removal of hrtimer_forward() from
the public interfaces.

Link: https://lore.kernel.org/all/20210923153339.684546907@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>
Cc: linux-can@vger.kernel.org
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: netdev@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/bcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 508f67de0b80..bc88d901a1c0 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -625,7 +625,7 @@ static enum hrtimer_restart bcm_rx_thr_handler(struct hrtimer *hrtimer)
 	struct bcm_op *op = container_of(hrtimer, struct bcm_op, thrtimer);
 
 	if (bcm_rx_thr_flush(op)) {
-		hrtimer_forward(hrtimer, ktime_get(), op->kt_ival2);
+		hrtimer_forward_now(hrtimer, op->kt_ival2);
 		return HRTIMER_RESTART;
 	} else {
 		/* rearm throttle handling */

base-commit: 4d98bb0d7ec2d0b417df6207b0bafe1868bad9f8
-- 
2.33.0


