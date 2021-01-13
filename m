Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4262F583C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728536AbhANCQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbhAMVQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:16:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCBC9C06138B
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:14:37 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kznTQ-0001xh-9G
        for netdev@vger.kernel.org; Wed, 13 Jan 2021 22:14:36 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7D14C5C3090
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 21:14:29 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 7B2FA5C302A;
        Wed, 13 Jan 2021 21:14:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2257cbfd;
        Wed, 13 Jan 2021 21:14:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net-next 16/17] can: dev: can_put_echo_skb(): add software tx timestamps
Date:   Wed, 13 Jan 2021 22:14:09 +0100
Message-Id: <20210113211410.917108-17-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113211410.917108-1-mkl@pengutronix.de>
References: <20210113211410.917108-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Call skb_tx_timestamp() within can_put_echo_skb() so that a software tx
timestamp gets attached to the skb.

There two main reasons to include this call in can_put_echo_skb():

  * It easily allow to enable the tx timestamp on all devices with
    just one small change.

  * According to Documentation/networking/timestamping.rst, the tx
    timestamps should be generated in the device driver as close as possible,
    but always prior to passing the packet to the network interface. During the
    call to can_put_echo_skb(), the skb gets cloned meaning that the driver
    should not dereference the skb variable anymore after can_put_echo_skb()
    returns. This makes can_put_echo_skb() the very last place we can use the
    skb without having to access the echo_skb[] array.

Remark: by default, skb_tx_timestamp() does nothing. It needs to be activated
by passing the SOF_TIMESTAMPING_TX_SOFTWARE flag either through socket options
or control messages.

References:

 * Support for the error queue in CAN RAW sockets (which is needed for
   tx timestamps) was introduced in:
   https://git.kernel.org//torvalds/c/eb88531bdbfaafb827192d1fc6c5a3fcc4fadd96

  * Put the call to skb_tx_timestamp() just before adding it to the
    array:
    https://lore.kernel.org/r/043c3ea1-6bdd-59c0-0269-27b2b5b36cec@victronenergy.com

  * About Tx hardware timestamps
    https://lore.kernel.org/r/20210111171152.GB11715@hoboy.vegasvil.org

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20210112095437.6488-2-mailhol.vincent@wanadoo.fr
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 drivers/net/can/dev/skb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/can/dev/skb.c b/drivers/net/can/dev/skb.c
index 53683d4312f1..6a64fe410987 100644
--- a/drivers/net/can/dev/skb.c
+++ b/drivers/net/can/dev/skb.c
@@ -65,6 +65,8 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 		/* save frame_len to reuse it when transmission is completed */
 		can_skb_prv(skb)->frame_len = frame_len;
 
+		skb_tx_timestamp(skb);
+
 		/* save this skb for tx interrupt echo handling */
 		priv->echo_skb[idx] = skb;
 	} else {
-- 
2.29.2


