Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1E45860EF
	for <lists+netdev@lfdr.de>; Sun, 31 Jul 2022 21:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbiGaTWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jul 2022 15:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238209AbiGaTVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jul 2022 15:21:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F140B11158
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 12:20:55 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oIEUf-0007m5-Lu
        for netdev@vger.kernel.org; Sun, 31 Jul 2022 21:20:53 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 94C3ABECE1
        for <netdev@vger.kernel.org>; Sun, 31 Jul 2022 19:20:39 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 019B2BECC7;
        Sun, 31 Jul 2022 19:20:38 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id a951d697;
        Sun, 31 Jul 2022 19:20:31 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 26/36] can: dev: add hardware TX timestamp
Date:   Sun, 31 Jul 2022 21:20:19 +0200
Message-Id: <20220731192029.746751-27-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220731192029.746751-1-mkl@pengutronix.de>
References: <20220731192029.746751-1-mkl@pengutronix.de>
MIME-Version: 1.0
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Because of the loopback feature of socket CAN, hardware TX timestamps
are nothing else than the hardware RX timespamp of the corresponding
loopback packet. This patch simply reuses the hardware RX timestamp.

The rationale to clone this timestamp value is that existing tools
which rely of libpcap (such as tcpdump) expect support for both TX and
RX hardware timestamps in order to activate the feature (i.e. no
granular control to activate either of TX or RX hardware timestamps).

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20220727101641.198847-7-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/skb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 8bb62dd864c8..07e0feac8629 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -72,6 +72,9 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 		/* save frame_len to reuse it when transmission is completed */
 		can_skb_prv(skb)->frame_len = frame_len;
 
+		if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
+			skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
+
 		skb_tx_timestamp(skb);
 
 		/* save this skb for tx interrupt echo handling */
@@ -107,6 +110,9 @@ __can_get_echo_skb(struct net_device *dev, unsigned int idx, u8 *len_ptr,
 		struct can_skb_priv *can_skb_priv = can_skb_prv(skb);
 		struct canfd_frame *cf = (struct canfd_frame *)skb->data;
 
+		if (skb_shinfo(skb)->tx_flags & SKBTX_IN_PROGRESS)
+			skb_tstamp_tx(skb, skb_hwtstamps(skb));
+
 		/* get the real payload length for netdev statistics */
 		if (cf->can_id & CAN_RTR_FLAG)
 			*len_ptr = 0;
-- 
2.35.1


