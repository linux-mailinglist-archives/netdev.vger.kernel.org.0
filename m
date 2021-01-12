Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2D62F2C07
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 10:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389319AbhALJ5c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 04:57:32 -0500
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:21601 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728810AbhALJ5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 04:57:32 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d28 with ME
        id Flvf240043PnFJp03lvkoN; Tue, 12 Jan 2021 10:55:47 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Tue, 12 Jan 2021 10:55:47 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 1/1] can: dev: add software tx timestamps
Date:   Tue, 12 Jan 2021 18:54:37 +0900
Message-Id: <20210112095437.6488-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210112095437.6488-1-mailhol.vincent@wanadoo.fr>
References: <20210112095437.6488-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Call skb_tx_timestamp() within can_put_echo_skb() so that a software
tx timestamp gets attached on the skb.

There two main reasons to include this call in can_put_echo_skb():

  * It easily allow to enable the tx timestamp on all devices with
    just one small change.

  * According to Documentation/networking/timestamping.rst, the tx
    timestamps should be generated in the device driver as close as
    possible, but always prior to passing the packet to the network
    interface. During the call to can_put_echo_skb(), the skb gets
    cloned meaning that the driver should not dereference the skb
    variable anymore after can_put_echo_skb() returns. This makes
    can_put_echo_skb() the very last place we can use the skb without
    having to access the echo_skb[] array.

Remark: by default, skb_tx_timestamp() does nothing. It needs to be
activated by passing the SOF_TIMESTAMPING_TX_SOFTWARE flag either
through socket options or control messages.

References:

 * Support for the error queue in CAN RAW sockets (which is needed for
   tx timestamps) was introduced in:
   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eb88531bdbfaafb827192d1fc6c5a3fcc4fadd96

  * Put the call to skb_tx_timestamp() just before adding it to the
    array: https://lkml.org/lkml/2021/1/10/54

  * About Tx hardware timestamps
    https://lore.kernel.org/linux-can/20210111171152.GB11715@hoboy.vegasvil.org/

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
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
2.26.2

