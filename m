Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC8EA2B373A
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 18:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727337AbgKORlg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 12:41:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726704AbgKORlg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 12:41:36 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CCFC0613D1
        for <netdev@vger.kernel.org>; Sun, 15 Nov 2020 09:41:35 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1keM1u-0005uQ-1q; Sun, 15 Nov 2020 18:41:34 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de,
        Anant Thazhemadam <anant.thazhemadam@gmail.com>,
        syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 01/15] can: af_can: prevent potential access of uninitialized member in can_rcv()
Date:   Sun, 15 Nov 2020 18:41:17 +0100
Message-Id: <20201115174131.2089251-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201115174131.2089251-1-mkl@pengutronix.de>
References: <20201115174131.2089251-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>

In can_rcv(), cfd->len is uninitialized when skb->len = 0, and this
uninitialized cfd->len is accessed nonetheless by pr_warn_once().

Fix this uninitialized variable access by checking cfd->len's validity
condition (cfd->len > CAN_MAX_DLEN) separately after the skb->len's
condition is checked, and appropriately modify the log messages that
are generated as well.
In case either of the required conditions fail, the skb is freed and
NET_RX_DROP is returned, same as before.

Fixes: 8cb68751c115 ("can: af_can: can_rcv(): replace WARN_ONCE by pr_warn_once")
Reported-by: syzbot+9bcb0c9409066696d3aa@syzkaller.appspotmail.com
Tested-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Link: https://lore.kernel.org/r/20201103213906.24219-2-anant.thazhemadam@gmail.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/af_can.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 6373ab9c5507..e8d4e3ef5322 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -677,16 +677,25 @@ static int can_rcv(struct sk_buff *skb, struct net_device *dev,
 {
 	struct canfd_frame *cfd = (struct canfd_frame *)skb->data;
 
-	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU ||
-		     cfd->len > CAN_MAX_DLEN)) {
-		pr_warn_once("PF_CAN: dropped non conform CAN skbuf: dev type %d, len %d, datalen %d\n",
+	if (unlikely(dev->type != ARPHRD_CAN || skb->len != CAN_MTU)) {
+		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d\n",
+			     dev->type, skb->len);
+		goto free_skb;
+	}
+
+	/* This check is made separately since cfd->len would be uninitialized if skb->len = 0. */
+	if (unlikely(cfd->len > CAN_MAX_DLEN)) {
+		pr_warn_once("PF_CAN: dropped non conform CAN skbuff: dev type %d, len %d, datalen %d\n",
 			     dev->type, skb->len, cfd->len);
-		kfree_skb(skb);
-		return NET_RX_DROP;
+		goto free_skb;
 	}
 
 	can_receive(skb, dev);
 	return NET_RX_SUCCESS;
+
+free_skb:
+	kfree_skb(skb);
+	return NET_RX_DROP;
 }
 
 static int canfd_rcv(struct sk_buff *skb, struct net_device *dev,

base-commit: ceb736e1d45c253f5e86b185ca9b497cdd43063f
-- 
2.29.2

