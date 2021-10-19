Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415E2432F20
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbhJSHRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234384AbhJSHRo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 03:17:44 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1613C061749
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 00:15:31 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mcjLO-0006Dr-FU
        for netdev@vger.kernel.org; Tue, 19 Oct 2021 09:15:30 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 83A9B697771
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 07:15:28 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 349E1697764;
        Tue, 19 Oct 2021 07:15:20 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 82083c34;
        Tue, 19 Oct 2021 07:15:19 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        stable@vger.kernel.org,
        Sottas Guillaume <Guillaume.Sottas@liebherr.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>
Subject: [PATCH net] can: isotp: isotp_sendmsg(): fix return error on FC timeout on TX path
Date:   Tue, 19 Oct 2021 09:15:18 +0200
Message-Id: <20211019071518.2346320-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211019071518.2346320-1-mkl@pengutronix.de>
References: <20211019071518.2346320-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When the a large chunk of data send and the receiver does not send a
Flow Control frame back in time, the sendmsg() does not return a error
code, but the number of bytes sent corresponding to the size of the
packet.

If a timeout occurs the isotp_tx_timer_handler() is fired, sets
sk->sk_err and calls the sk->sk_error_report() function. It was
wrongly expected that the error would be propagated to user space in
every case. For isotp_sendmsg() blocking on wait_event_interruptible()
this is not the case.

This patch fixes the problem by checking if sk->sk_err is set and
returning the error to user space.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://github.com/hartkopp/can-isotp/issues/42
Link: https://github.com/hartkopp/can-isotp/pull/43
Link: https://lore.kernel.org/all/20210507091839.1366379-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org
Reported-by: Sottas Guillaume (LMB) <Guillaume.Sottas@liebherr.com>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index d1f54273c0bb..df6968b28bf4 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -971,6 +971,9 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (wait_tx_done) {
 		/* wait for complete transmission of current pdu */
 		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
+
+		if (sk->sk_err)
+			return -sk->sk_err;
 	}
 
 	return size;

base-commit: 8a64ef042eab8a6cec04a6c79d44d1af79b628ca
-- 
2.33.0


