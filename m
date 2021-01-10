Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A094E2F0755
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 13:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbhAJMvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 07:51:21 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:21743 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbhAJMvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Jan 2021 07:51:21 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d13 with ME
        id F0pW240033PnFJp030paM0; Sun, 10 Jan 2021 13:49:37 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Sun, 10 Jan 2021 13:49:37 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        Jeroen Hofstee <jhofstee@victronenergy.com>
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v3 1/1] can: dev: add software tx timestamps
Date:   Sun, 10 Jan 2021 21:49:03 +0900
Message-Id: <20210110124903.109773-2-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210110124903.109773-1-mailhol.vincent@wanadoo.fr>
References: <20210110124903.109773-1-mailhol.vincent@wanadoo.fr>
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

Remarks:

  * By default, skb_tx_timestamp() does nothing. It needs to be
    activated by passing the SOF_TIMESTAMPING_TX_SOFTWARE flag either
    through socket options or control messages.

  * The hardware rx timestamp of a local loopback message is the
    hardware tx timestamp. This means that there are no needs to
    implement SOF_TIMESTAMPING_TX_HARDWARE for CAN sockets.

References:

Support for the error queue in CAN RAW sockets (which is needed for tx
timestamps) was introduced in:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=eb88531bdbfaafb827192d1fc6c5a3fcc4fadd96

Put the call to skb_tx_timestamp() just before adding it to the array:
https://lkml.org/lkml/2021/1/10/54

Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
---
 drivers/net/can/dev.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
index 3486704c8a95..850759c7677f 100644
--- a/drivers/net/can/dev.c
+++ b/drivers/net/can/dev.c
@@ -481,6 +481,7 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
 		skb->pkt_type = PACKET_BROADCAST;
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
 		skb->dev = dev;
+		skb_tx_timestamp(skb);
 
 		/* save this skb for tx interrupt echo handling */
 		priv->echo_skb[idx] = skb;
-- 
2.26.2

