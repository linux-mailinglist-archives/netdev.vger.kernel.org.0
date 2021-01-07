Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBB52ECD22
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbhAGJud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:50:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727209AbhAGJuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:50:32 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EE1C0612F8
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:49:51 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxRvS-00013f-FX
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 10:49:50 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0E0AD5BBAF5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:49:10 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 70EC75BBA41;
        Thu,  7 Jan 2021 09:49:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id dc8f988f;
        Thu, 7 Jan 2021 09:49:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Phillip Schichtel <phillip@schich.tel>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 17/19] can: raw: return -ERANGE when filterset does not fit into user space buffer
Date:   Thu,  7 Jan 2021 10:48:58 +0100
Message-Id: <20210107094900.173046-18-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107094900.173046-1-mkl@pengutronix.de>
References: <20210107094900.173046-1-mkl@pengutronix.de>
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

Multiple filters (struct can_filter) can be set with the setsockopt()
function, which was originally intended as a write-only operation.

As getsockopt() also provides a CAN_RAW_FILTER option to read back the
given filters, the caller has to provide an appropriate user space buffer.
In the case this buffer is too small the getsockopt() silently truncates
the filter information and gives no information about the needed space.
This is safe but not convenient for the programmer.

In net/core/sock.c the SO_PEERGROUPS sockopt had a similar requirement
and solved it by returning -ERANGE in the case that the provided data
does not fit into the given user space buffer and fills the required size
into optlen, so that the caller can retry with a matching buffer length.

This patch adopts this approach for CAN_RAW_FILTER getsockopt().

Reported-by: Phillip Schichtel <phillip@schich.tel>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-By: Phillip Schichtel <phillip@schich.tel>
Link: https://lore.kernel.org/r/20201216174928.21663-1-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/raw.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/net/can/raw.c b/net/can/raw.c
index 6ec8aa1d0da4..37b47a39a3ed 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -665,10 +665,18 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 		if (ro->count > 0) {
 			int fsize = ro->count * sizeof(struct can_filter);
 
-			if (len > fsize)
-				len = fsize;
-			if (copy_to_user(optval, ro->filter, len))
-				err = -EFAULT;
+			/* user space buffer to small for filter list? */
+			if (len < fsize) {
+				/* return -ERANGE and needed space in optlen */
+				err = -ERANGE;
+				if (put_user(fsize, optlen))
+					err = -EFAULT;
+			} else {
+				if (len > fsize)
+					len = fsize;
+				if (copy_to_user(optval, ro->filter, len))
+					err = -EFAULT;
+			}
 		} else {
 			len = 0;
 		}
-- 
2.29.2


