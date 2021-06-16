Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9D53A989B
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 13:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232507AbhFPLEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 07:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232607AbhFPLEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 07:04:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F57DC0611C1
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 04:02:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ltTJ3-0007pJ-CH
        for netdev@vger.kernel.org; Wed, 16 Jun 2021 13:02:01 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 2549563D2B0
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 11:01:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1394863D292;
        Wed, 16 Jun 2021 11:01:55 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 688c17f5;
        Wed, 16 Jun 2021 11:01:54 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Norbert Slusarek <nslusarek@gmx.net>,
        linux-stable <stable@vger.kernel.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 3/4] can: bcm: fix infoleak in struct bcm_msg_head
Date:   Wed, 16 Jun 2021 13:01:51 +0200
Message-Id: <20210616110152.2456765-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210616110152.2456765-1-mkl@pengutronix.de>
References: <20210616110152.2456765-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Norbert Slusarek <nslusarek@gmx.net>

On 64-bit systems, struct bcm_msg_head has an added padding of 4 bytes between
struct members count and ival1. Even though all struct members are initialized,
the 4-byte hole will contain data from the kernel stack. This patch zeroes out
struct bcm_msg_head before usage, preventing infoleaks to userspace.

Fixes: ffd980f976e7 ("[CAN]: Add broadcast manager (bcm) protocol")
Link: https://lore.kernel.org/r/trinity-7c1b2e82-e34f-4885-8060-2cd7a13769ce-1623532166177@3c-app-gmx-bs52
Cc: linux-stable <stable@vger.kernel.org>
Signed-off-by: Norbert Slusarek <nslusarek@gmx.net>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/bcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index f00176b2a6c3..f3e4d9528fa3 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -406,6 +406,7 @@ static enum hrtimer_restart bcm_tx_timeout_handler(struct hrtimer *hrtimer)
 		if (!op->count && (op->flags & TX_COUNTEVT)) {
 
 			/* create notification to user */
+			memset(&msg_head, 0, sizeof(msg_head));
 			msg_head.opcode  = TX_EXPIRED;
 			msg_head.flags   = op->flags;
 			msg_head.count   = op->count;
@@ -443,6 +444,7 @@ static void bcm_rx_changed(struct bcm_op *op, struct canfd_frame *data)
 	/* this element is not throttled anymore */
 	data->flags &= (BCM_CAN_FLAGS_MASK|RX_RECV);
 
+	memset(&head, 0, sizeof(head));
 	head.opcode  = RX_CHANGED;
 	head.flags   = op->flags;
 	head.count   = op->count;
@@ -564,6 +566,7 @@ static enum hrtimer_restart bcm_rx_timeout_handler(struct hrtimer *hrtimer)
 	}
 
 	/* create notification to user */
+	memset(&msg_head, 0, sizeof(msg_head));
 	msg_head.opcode  = RX_TIMEOUT;
 	msg_head.flags   = op->flags;
 	msg_head.count   = op->count;
-- 
2.30.2


