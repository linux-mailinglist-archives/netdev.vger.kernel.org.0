Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DF56293FC4
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 17:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436710AbgJTPmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 11:42:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50694 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436532AbgJTPmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 11:42:12 -0400
Received: from 1.general.cking.uk.vpn ([10.172.193.212] helo=localhost)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <colin.king@canonical.com>)
        id 1kUtm0-0007wZ-Fx; Tue, 20 Oct 2020 15:42:04 +0000
From:   Colin King <colin.king@canonical.com>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] can: isotp: make const array static, makes object smaller
Date:   Tue, 20 Oct 2020 16:42:03 +0100
Message-Id: <20201020154203.54711-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Don't populate the const array plen on the stack but instead it
static. Makes the object code smaller by 926 bytes.

Before:
   text	   data	    bss	    dec	    hex	filename
  26531	   1943	     64	  28538	   6f7a	net/can/isotp.o

After:
   text	   data	    bss	    dec	    hex	filename
  25509	   2039	     64	  27612	   6bdc	net/can/isotp.o

(gcc version 10.2.0)

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/can/isotp.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 4c2062875893..3fd714f81875 100644
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
2.27.0

