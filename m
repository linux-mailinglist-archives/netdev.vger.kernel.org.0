Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA593565E7
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 10:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236665AbhDGIBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 04:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235854AbhDGIBe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 04:01:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D6BFC06175F
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 01:01:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lU37r-0001sa-Uz
        for netdev@vger.kernel.org; Wed, 07 Apr 2021 10:01:24 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 788BB6097DC
        for <netdev@vger.kernel.org>; Wed,  7 Apr 2021 08:01:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 4FB086097CB;
        Wed,  7 Apr 2021 08:01:20 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 8c9f63b1;
        Wed, 7 Apr 2021 08:01:19 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Marc Kleine-Budde <mkl@pengutronix.de>,
        Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Subject: [net-next 1/6] can: skb: alloc_can{,fd}_skb(): set "cf" to NULL if skb allocation fails
Date:   Wed,  7 Apr 2021 10:01:13 +0200
Message-Id: <20210407080118.1916040-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407080118.1916040-1-mkl@pengutronix.de>
References: <20210407080118.1916040-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The handling of CAN bus errors typically consist of allocating a CAN
error SKB using alloc_can_err_skb() followed by stats handling and
filling the error details in the newly allocated CAN error SKB. Even
if the allocation of the SKB fails the stats handling should not be
skipped.

The common pattern in CAN drivers is to allocate the skb and work on
the struct can_frame pointer "cf", if it has been assigned by
alloc_can_err_skb().

|	skb = alloc_can_err_skb(priv->ndev, &cf);
|
| 	/* RX errors */
| 	if (bdiag1 & (MCP251XFD_REG_BDIAG1_DCRCERR |
| 		      MCP251XFD_REG_BDIAG1_NCRCERR)) {
| 		netdev_dbg(priv->ndev, "CRC error\n");
|
| 		stats->rx_errors++;
| 		if (cf)
| 			cf->data[3] |= CAN_ERR_PROT_LOC_CRC_SEQ;
| 	}

In case of an OOM alloc_can_err_skb() returns NULL, but doesn't set
"cf" to NULL as well. For the above pattern to work the "cf" has to be
initialized to NULL, which is easily forgotten.

To solve this kind of problems, set "cf" to NULL if
alloc_can_err_skb() returns NULL.

Link: https://lore.kernel.org/r/20210402102245.1512583-1-mkl@pengutronix.de
Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/skb.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 387c0bc0fb9c..61660248c69e 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -183,8 +183,11 @@ struct sk_buff *alloc_can_skb(struct net_device *dev, struct can_frame **cf)
 
 	skb = netdev_alloc_skb(dev, sizeof(struct can_skb_priv) +
 			       sizeof(struct can_frame));
-	if (unlikely(!skb))
+	if (unlikely(!skb)) {
+		*cf = NULL;
+
 		return NULL;
+	}
 
 	skb->protocol = htons(ETH_P_CAN);
 	skb->pkt_type = PACKET_BROADCAST;
@@ -211,8 +214,11 @@ struct sk_buff *alloc_canfd_skb(struct net_device *dev,
 
 	skb = netdev_alloc_skb(dev, sizeof(struct can_skb_priv) +
 			       sizeof(struct canfd_frame));
-	if (unlikely(!skb))
+	if (unlikely(!skb)) {
+		*cfd = NULL;
+
 		return NULL;
+	}
 
 	skb->protocol = htons(ETH_P_CANFD);
 	skb->pkt_type = PACKET_BROADCAST;

base-commit: 0b35e0deb5bee7d4882356d6663522c1562a8321
-- 
2.30.2


