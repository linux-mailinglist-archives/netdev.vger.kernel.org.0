Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FAF2CD895
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436557AbgLCOJK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:09:10 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:36219 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728727AbgLCOJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:09:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1607004375;
        s=strato-dkim-0002; d=hartkopp.net;
        h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=zGU4oUwJBFPegTJv0CVGLiubRmmiYKrA+6JGbAEjAq8=;
        b=NK57UQnjca9InHTNbLwKI6eY6Is7jTT+UpdBNtsoXpCtu+NYofLfgn+XSqjEY3txux
        voJq/LuAe9QvSaAoKZdupz/Z3XWokdjFviVGQASbq8k5Lc4iYujq/WqGaYJ+wjIhIRKf
        SwxkF8O9iitYsCDcd7t0Hz70xpNV1U4ChxSDPrPBXxUTxSb8VmCc5ZjLxMjdeSkpU8wD
        g49LNkw9UZqwKNIJEtnDDCGS6QmiWBBttzSIRnLAa1WTET9bFR0tj+Vo10Hrk1ypGE0r
        WNO2G6Sv4987L7mZIUZCsc5VHNmIQiaU5cTav2QVlGq36prnHasJzwQMP7ty2tzHs950
        Khtw==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9dyKNLCWJaRrQ0pDCeGtVbNHMQ98lI/DcPKMT"
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
        by smtp.strato.de (RZmta 47.3.4 AUTH)
        with ESMTPSA id n07f3bwB3E6EFos
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Thu, 3 Dec 2020 15:06:14 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     mkl@pengutronix.de, kuba@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Thomas Wagner <thwa1@web.de>
Subject: [PATCH 2/2] can-isotp: add SF_BROADCAST support for functional addressing
Date:   Thu,  3 Dec 2020 15:06:04 +0100
Message-Id: <20201203140604.25488-3-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201203140604.25488-1-socketcan@hartkopp.net>
References: <20201203140604.25488-1-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CAN_ISOTP_SF_BROADCAST is set in the CAN_ISOTP_OPTS flags the
CAN_ISOTP socket is switched into functional addressing mode, where
only single frame (SF) protocol data units can be send on the specified
CAN interface and the given tp.tx_id after bind().

In opposite to normal and extended addressing this socket does not
register a CAN-ID for reception which would be needed for a 1-to-1
ISOTP connection with a segmented bi-directional data transfer.

Sending SFs on this socket is therefore a TX-only 'broadcast' operation.

Suggested-by: Thomas Wagner <thwa1@web.de>
Tested-by: Thomas Wagner <thwa1@web.de>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 include/uapi/linux/can/isotp.h |  2 +-
 net/can/isotp.c                | 29 ++++++++++++++++++++---------
 2 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/uapi/linux/can/isotp.h b/include/uapi/linux/can/isotp.h
index 7793b26aa154..c55935b64ccc 100644
--- a/include/uapi/linux/can/isotp.h
+++ b/include/uapi/linux/can/isotp.h
@@ -133,11 +133,11 @@ struct can_isotp_ll_options {
 #define CAN_ISOTP_HALF_DUPLEX	0x040	/* half duplex error state handling */
 #define CAN_ISOTP_FORCE_TXSTMIN	0x080	/* ignore stmin from received FC */
 #define CAN_ISOTP_FORCE_RXSTMIN	0x100	/* ignore CFs depending on rx stmin */
 #define CAN_ISOTP_RX_EXT_ADDR	0x200	/* different rx extended addressing */
 #define CAN_ISOTP_WAIT_TX_DONE	0x400	/* wait for tx completion */
-
+#define CAN_ISOTP_SF_BROADCAST	0x800	/* 1-to-N functional addressing */
 
 /* default values */
 
 #define CAN_ISOTP_DEFAULT_FLAGS		0
 #define CAN_ISOTP_DEFAULT_EXT_ADDRESS	0x00
diff --git a/net/can/isotp.c b/net/can/isotp.c
index 26bdc3c20b7e..5ce26e568f16 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -863,10 +863,18 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	}
 
 	if (!size || size > MAX_MSG_LENGTH)
 		return -EINVAL;
 
+	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
+	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
+
+	/* does the given data fit into a single frame for SF_BROADCAST? */
+	if ((so->opt.flags & CAN_ISOTP_SF_BROADCAST) &&
+	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off))
+		return -EINVAL;
+
 	err = memcpy_from_msg(so->tx.buf, msg, size);
 	if (err < 0)
 		return err;
 
 	dev = dev_get_by_index(sock_net(sk), so->ifindex);
@@ -889,13 +897,10 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	so->tx.idx = 0;
 
 	cf = (struct canfd_frame *)skb->data;
 	skb_put(skb, so->ll.mtu);
 
-	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
-	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
-
 	/* check for single frame transmission depending on TX_DL */
 	if (size <= so->tx.ll_dl - SF_PCI_SZ4 - ae - off) {
 		/* The message size generally fits into a SingleFrame - good.
 		 *
 		 * SF_DL ESC offset optimization:
@@ -1014,11 +1019,11 @@ static int isotp_release(struct socket *sock)
 
 	hrtimer_cancel(&so->txtimer);
 	hrtimer_cancel(&so->rxtimer);
 
 	/* remove current filters & unregister */
-	if (so->bound) {
+	if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST))) {
 		if (so->ifindex) {
 			struct net_device *dev;
 
 			dev = dev_get_by_index(net, so->ifindex);
 			if (dev) {
@@ -1050,10 +1055,11 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	struct net *net = sock_net(sk);
 	int ifindex;
 	struct net_device *dev;
 	int err = 0;
 	int notify_enetdown = 0;
+	int do_rx_reg = 1;
 
 	if (len < CAN_REQUIRED_SIZE(struct sockaddr_can, can_addr.tp))
 		return -EINVAL;
 
 	if (addr->can_addr.tp.rx_id == addr->can_addr.tp.tx_id)
@@ -1064,10 +1070,14 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 		return -EADDRNOTAVAIL;
 
 	if (!addr->can_ifindex)
 		return -ENODEV;
 
+	/* do not register frame reception for functional addressing */
+	if (so->opt.flags & CAN_ISOTP_SF_BROADCAST)
+		do_rx_reg = 0;
+
 	lock_sock(sk);
 
 	if (so->bound && addr->can_ifindex == so->ifindex &&
 	    addr->can_addr.tp.rx_id == so->rxid &&
 	    addr->can_addr.tp.tx_id == so->txid)
@@ -1091,17 +1101,18 @@ static int isotp_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	if (!(dev->flags & IFF_UP))
 		notify_enetdown = 1;
 
 	ifindex = dev->ifindex;
 
-	can_rx_register(net, dev, addr->can_addr.tp.rx_id,
-			SINGLE_MASK(addr->can_addr.tp.rx_id), isotp_rcv, sk,
-			"isotp", sk);
+	if (do_rx_reg)
+		can_rx_register(net, dev, addr->can_addr.tp.rx_id,
+				SINGLE_MASK(addr->can_addr.tp.rx_id),
+				isotp_rcv, sk, "isotp", sk);
 
 	dev_put(dev);
 
-	if (so->bound) {
+	if (so->bound && do_rx_reg) {
 		/* unregister old filter */
 		if (so->ifindex) {
 			dev = dev_get_by_index(net, so->ifindex);
 			if (dev) {
 				can_rx_unregister(net, dev, so->rxid,
@@ -1300,11 +1311,11 @@ static int isotp_notifier(struct notifier_block *nb, unsigned long msg,
 
 	switch (msg) {
 	case NETDEV_UNREGISTER:
 		lock_sock(sk);
 		/* remove current filters & unregister */
-		if (so->bound)
+		if (so->bound && (!(so->opt.flags & CAN_ISOTP_SF_BROADCAST)))
 			can_rx_unregister(dev_net(dev), dev, so->rxid,
 					  SINGLE_MASK(so->rxid),
 					  isotp_rcv, sk);
 
 		so->ifindex = 0;
-- 
2.29.2

