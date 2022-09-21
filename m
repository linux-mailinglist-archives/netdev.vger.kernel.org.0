Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C1225BF96F
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230526AbiIUIgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230502AbiIUIgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:36:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED7F683066
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 01:36:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oavDK-0000TX-8w
        for netdev@vger.kernel.org; Wed, 21 Sep 2022 10:36:14 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A1FE6E858E
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 08:36:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B2F41E8572;
        Wed, 21 Sep 2022 08:36:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 046baafd;
        Wed, 21 Sep 2022 08:36:10 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        stable@vger.kernel.org,
        =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        Thorsten Scherer <t.scherer@eckelmann.de>
Subject: [PATCH net 1/3] can: flexcan: flexcan_mailbox_read() fix return value for drop = true
Date:   Wed, 21 Sep 2022 10:36:07 +0200
Message-Id: <20220921083609.419768-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220921083609.419768-1-mkl@pengutronix.de>
References: <20220921083609.419768-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following happened on an i.MX25 using flexcan with many packets on
the bus:

The rx-offload queue reached a length more than skb_queue_len_max. In
can_rx_offload_offload_one() the drop variable was set to true which
made the call to .mailbox_read() (here: flexcan_mailbox_read()) to
_always_ return ERR_PTR(-ENOBUFS) and drop the rx'ed CAN frame. So
can_rx_offload_offload_one() returned ERR_PTR(-ENOBUFS), too.

can_rx_offload_irq_offload_fifo() looks as follows:

| 	while (1) {
| 		skb = can_rx_offload_offload_one(offload, 0);
| 		if (IS_ERR(skb))
| 			continue;
| 		if (!skb)
| 			break;
| 		...
| 	}

The flexcan driver wrongly always returns ERR_PTR(-ENOBUFS) if drop is
requested, even if there is no CAN frame pending. As the i.MX25 is a
single core CPU, while the rx-offload processing is active, there is
no thread to process packets from the offload queue. So the queue
doesn't get any shorter and this results is a tight loop.

Instead of always returning ERR_PTR(-ENOBUFS) if drop is requested,
return NULL if no CAN frame is pending.

Changes since v1: https://lore.kernel.org/all/20220810144536.389237-1-u.kleine-koenig@pengutronix.de
- don't break in can_rx_offload_irq_offload_fifo() in case of an error,
  return NULL in flexcan_mailbox_read() in case of no pending CAN frame
  instead

Fixes: 4e9c9484b085 ("can: rx-offload: Prepare for CAN FD support")
Link: https://lore.kernel.org/all/20220811094254.1864367-1-mkl@pengutronix.de
Cc: stable@vger.kernel.org # v5.5
Suggested-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Tested-by: Thorsten Scherer <t.scherer@eckelmann.de>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/flexcan/flexcan-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/flexcan/flexcan-core.c b/drivers/net/can/flexcan/flexcan-core.c
index f857968efed7..ccb438eca517 100644
--- a/drivers/net/can/flexcan/flexcan-core.c
+++ b/drivers/net/can/flexcan/flexcan-core.c
@@ -941,11 +941,6 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 	u32 reg_ctrl, reg_id, reg_iflag1;
 	int i;
 
-	if (unlikely(drop)) {
-		skb = ERR_PTR(-ENOBUFS);
-		goto mark_as_read;
-	}
-
 	mb = flexcan_get_mb(priv, n);
 
 	if (priv->devtype_data.quirks & FLEXCAN_QUIRK_USE_RX_MAILBOX) {
@@ -974,6 +969,11 @@ static struct sk_buff *flexcan_mailbox_read(struct can_rx_offload *offload,
 		reg_ctrl = priv->read(&mb->can_ctrl);
 	}
 
+	if (unlikely(drop)) {
+		skb = ERR_PTR(-ENOBUFS);
+		goto mark_as_read;
+	}
+
 	if (reg_ctrl & FLEXCAN_MB_CNT_EDL)
 		skb = alloc_canfd_skb(offload->dev, &cfd);
 	else

base-commit: 6a1dbfefdae4f7809b3e277cc76785dac0ac1cd0
-- 
2.35.1


