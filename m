Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10E32342F50
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 20:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCTThh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 15:37:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhCTThQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 15:37:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC1EC061762
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 12:37:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lNhPO-0000RR-Bz
        for netdev@vger.kernel.org; Sat, 20 Mar 2021 20:37:14 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8CFAC5FB3E9
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 19:37:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 534F05FB3D6;
        Sat, 20 Mar 2021 19:37:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 447d17a1;
        Sat, 20 Mar 2021 19:37:10 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 1/2] can: isotp: tx-path: zero initialize outgoing CAN frames
Date:   Sat, 20 Mar 2021 20:37:07 +0100
Message-Id: <20210320193708.348503-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210320193708.348503-1-mkl@pengutronix.de>
References: <20210320193708.348503-1-mkl@pengutronix.de>
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

Commit d4eb538e1f48 ("can: isotp: TX-path: ensure that CAN frame flags are
initialized") ensured the TX flags to be properly set for outgoing CAN
frames.

In fact the root cause of the issue results from a missing initialization
of outgoing CAN frames created by isotp. This is no problem on the CAN bus
as the CAN driver only picks the correctly defined content from the struct
can(fd)_frame. But when the outgoing frames are monitored (e.g. with
candump) we potentially leak some bytes in the unused content of
struct can(fd)_frame.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Link: https://lore.kernel.org/r/20210319100619.10858-1-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 430976485d95..15ea1234d457 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -196,7 +196,7 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 	nskb->dev = dev;
 	can_skb_set_owner(nskb, sk);
 	ncf = (struct canfd_frame *)nskb->data;
-	skb_put(nskb, so->ll.mtu);
+	skb_put_zero(nskb, so->ll.mtu);
 
 	/* create & send flow control reply */
 	ncf->can_id = so->txid;
@@ -779,7 +779,7 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 		can_skb_prv(skb)->skbcnt = 0;
 
 		cf = (struct canfd_frame *)skb->data;
-		skb_put(skb, so->ll.mtu);
+		skb_put_zero(skb, so->ll.mtu);
 
 		/* create consecutive frame */
 		isotp_fill_dataframe(cf, so, ae, 0);
@@ -895,7 +895,7 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	so->tx.idx = 0;
 
 	cf = (struct canfd_frame *)skb->data;
-	skb_put(skb, so->ll.mtu);
+	skb_put_zero(skb, so->ll.mtu);
 
 	/* check for single frame transmission depending on TX_DL */
 	if (size <= so->tx.ll_dl - SF_PCI_SZ4 - ae - off) {

base-commit: 5aa3c334a449bab24519c4967f5ac2b3304c8dcf
-- 
2.30.2


