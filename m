Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C481D2A5969
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731354AbgKCWGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731201AbgKCWGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:49 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB263C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:48 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4Ry-0006Ui-PQ; Tue, 03 Nov 2020 23:06:46 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Colin Ian King <colin.king@canonical.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 15/27] can: isotp: padlen(): make const array static, makes object smaller
Date:   Tue,  3 Nov 2020 23:06:24 +0100
Message-Id: <20201103220636.972106-16-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201103220636.972106-1-mkl@pengutronix.de>
References: <20201103220636.972106-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the const array plen on the stack but instead it static. Makes
the object code smaller by 926 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  26531	   1943	     64	  28538	   6f7a	net/can/isotp.o

After:
   text	   data	    bss	    dec	    hex	filename
  25509	   2039	     64	  27612	   6bdc	net/can/isotp.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20201020154203.54711-1-colin.king@canonical.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index a79287ef86da..d78ab13bd8be 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -252,14 +252,16 @@ static void isotp_rcv_skb(struct sk_buff *skb, struct sock *sk)
 
 static u8 padlen(u8 datalen)
 {
-	const u8 plen[] = {8, 8, 8, 8, 8, 8, 8, 8, 8,		/* 0 - 8 */
-			   12, 12, 12, 12,			/* 9 - 12 */
-			   16, 16, 16, 16,			/* 13 - 16 */
-			   20, 20, 20, 20,			/* 17 - 20 */
-			   24, 24, 24, 24,			/* 21 - 24 */
-			   32, 32, 32, 32, 32, 32, 32, 32,	/* 25 - 32 */
-			   48, 48, 48, 48, 48, 48, 48, 48,	/* 33 - 40 */
-			   48, 48, 48, 48, 48, 48, 48, 48};	/* 41 - 48 */
+	static const u8 plen[] = {
+		8, 8, 8, 8, 8, 8, 8, 8, 8,	/* 0 - 8 */
+		12, 12, 12, 12,			/* 9 - 12 */
+		16, 16, 16, 16,			/* 13 - 16 */
+		20, 20, 20, 20,			/* 17 - 20 */
+		24, 24, 24, 24,			/* 21 - 24 */
+		32, 32, 32, 32, 32, 32, 32, 32,	/* 25 - 32 */
+		48, 48, 48, 48, 48, 48, 48, 48,	/* 33 - 40 */
+		48, 48, 48, 48, 48, 48, 48, 48	/* 41 - 48 */
+	};
 
 	if (datalen > 48)
 		return 64;
-- 
2.28.0

