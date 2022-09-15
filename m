Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991F35B963C
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 10:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiIOIWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 04:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbiIOIVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 04:21:30 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F21898349
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 01:20:39 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oYk6u-0004ae-Ur
        for netdev@vger.kernel.org; Thu, 15 Sep 2022 10:20:37 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A4F64E39E4
        for <netdev@vger.kernel.org>; Thu, 15 Sep 2022 08:20:20 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B9FBAE3959;
        Thu, 15 Sep 2022 08:20:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id dc3afb83;
        Thu, 15 Sep 2022 08:20:16 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 23/23] can: raw: add CAN XL support
Date:   Thu, 15 Sep 2022 10:20:13 +0200
Message-Id: <20220915082013.369072-24-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220915082013.369072-1-mkl@pengutronix.de>
References: <20220915082013.369072-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

Enable CAN_RAW sockets to read and write CAN XL frames analogue to the
CAN FD extension (new CAN_RAW_XL_FRAMES sockopt).

A CAN XL network interface is capable to handle Classical CAN, CAN FD and
CAN XL frames. When CAN_RAW_XL_FRAMES is enabled, the CAN_RAW socket checks
whether the addressed CAN network interface is capable to handle the
provided CAN frame.

In opposite to the fixed number of bytes for
- CAN frames (CAN_MTU = sizeof(struct can_frame))
- CAN FD frames (CANFD_MTU = sizeof(struct can_frame))
the number of bytes when reading/writing CAN XL frames depends on the
number of data bytes. For efficiency reasons the length of the struct
canxl_frame is truncated to the needed size for read/write operations.
This leads to a calculated size of CANXL_HDR_SIZE + canxl_frame::len which
is enforced on write() operations and guaranteed on read() operations.

NB: Valid length values are 1 .. 2048 (CANXL_MIN_DLEN .. CANXL_MAX_DLEN).

Acked-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Link: https://lore.kernel.org/all/20220912170725.120748-8-socketcan@hartkopp.net
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 include/uapi/linux/can/raw.h |  1 +
 net/can/raw.c                | 55 ++++++++++++++++++++++++++++--------
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/can/raw.h b/include/uapi/linux/can/raw.h
index 3386aa81fdf2..ff12f525c37c 100644
--- a/include/uapi/linux/can/raw.h
+++ b/include/uapi/linux/can/raw.h
@@ -62,6 +62,7 @@ enum {
 	CAN_RAW_RECV_OWN_MSGS,	/* receive my own msgs (default:off) */
 	CAN_RAW_FD_FRAMES,	/* allow CAN FD frames (default:off) */
 	CAN_RAW_JOIN_FILTERS,	/* all filters must match to trigger */
+	CAN_RAW_XL_FRAMES,	/* allow CAN XL frames (default:off) */
 };
 
 #endif /* !_UAPI_CAN_RAW_H */
diff --git a/net/can/raw.c b/net/can/raw.c
index e7dfa3584e29..3eb7d3e2b541 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -50,6 +50,7 @@
 #include <linux/skbuff.h>
 #include <linux/can.h>
 #include <linux/can/core.h>
+#include <linux/can/dev.h> /* for can_is_canxl_dev_mtu() */
 #include <linux/can/skb.h>
 #include <linux/can/raw.h>
 #include <net/sock.h>
@@ -87,6 +88,7 @@ struct raw_sock {
 	int loopback;
 	int recv_own_msgs;
 	int fd_frames;
+	int xl_frames;
 	int join_filters;
 	int count;                 /* number of active filters */
 	struct can_filter dfilter; /* default/single filter */
@@ -129,8 +131,9 @@ static void raw_rcv(struct sk_buff *oskb, void *data)
 	if (!ro->recv_own_msgs && oskb->sk == sk)
 		return;
 
-	/* do not pass non-CAN2.0 frames to a legacy socket */
-	if (!ro->fd_frames && oskb->len != CAN_MTU)
+	/* make sure to not pass oversized frames to the socket */
+	if ((can_is_canfd_skb(oskb) && !ro->fd_frames && !ro->xl_frames) ||
+	    (can_is_canxl_skb(oskb) && !ro->xl_frames))
 		return;
 
 	/* eliminate multiple filter matches for the same skb */
@@ -345,6 +348,7 @@ static int raw_init(struct sock *sk)
 	ro->loopback         = 1;
 	ro->recv_own_msgs    = 0;
 	ro->fd_frames        = 0;
+	ro->xl_frames        = 0;
 	ro->join_filters     = 0;
 
 	/* alloc_percpu provides zero'ed memory */
@@ -668,6 +672,15 @@ static int raw_setsockopt(struct socket *sock, int level, int optname,
 
 		break;
 
+	case CAN_RAW_XL_FRAMES:
+		if (optlen != sizeof(ro->xl_frames))
+			return -EINVAL;
+
+		if (copy_from_sockptr(&ro->xl_frames, optval, optlen))
+			return -EFAULT;
+
+		break;
+
 	case CAN_RAW_JOIN_FILTERS:
 		if (optlen != sizeof(ro->join_filters))
 			return -EINVAL;
@@ -750,6 +763,12 @@ static int raw_getsockopt(struct socket *sock, int level, int optname,
 		val = &ro->fd_frames;
 		break;
 
+	case CAN_RAW_XL_FRAMES:
+		if (len > sizeof(int))
+			len = sizeof(int);
+		val = &ro->xl_frames;
+		break;
+
 	case CAN_RAW_JOIN_FILTERS:
 		if (len > sizeof(int))
 			len = sizeof(int);
@@ -775,7 +794,11 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	struct sk_buff *skb;
 	struct net_device *dev;
 	int ifindex;
-	int err;
+	int err = -EINVAL;
+
+	/* check for valid CAN frame sizes */
+	if (size < CANXL_HDR_SIZE + CANXL_MIN_DLEN || size > CANXL_MTU)
+		return -EINVAL;
 
 	if (msg->msg_name) {
 		DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);
@@ -795,15 +818,6 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (!dev)
 		return -ENXIO;
 
-	err = -EINVAL;
-	if (ro->fd_frames && dev->mtu == CANFD_MTU) {
-		if (unlikely(size != CANFD_MTU && size != CAN_MTU))
-			goto put_dev;
-	} else {
-		if (unlikely(size != CAN_MTU))
-			goto put_dev;
-	}
-
 	skb = sock_alloc_send_skb(sk, size + sizeof(struct can_skb_priv),
 				  msg->msg_flags & MSG_DONTWAIT, &err);
 	if (!skb)
@@ -813,10 +827,27 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	can_skb_prv(skb)->ifindex = dev->ifindex;
 	can_skb_prv(skb)->skbcnt = 0;
 
+	/* fill the skb before testing for valid CAN frames */
 	err = memcpy_from_msg(skb_put(skb, size), msg, size);
 	if (err < 0)
 		goto free_skb;
 
+	err = -EINVAL;
+	if (ro->xl_frames && can_is_canxl_dev_mtu(dev->mtu)) {
+		/* CAN XL, CAN FD and Classical CAN */
+		if (!can_is_canxl_skb(skb) && !can_is_canfd_skb(skb) &&
+		    !can_is_can_skb(skb))
+			goto free_skb;
+	} else if (ro->fd_frames && dev->mtu == CANFD_MTU) {
+		/* CAN FD and Classical CAN */
+		if (!can_is_canfd_skb(skb) && !can_is_can_skb(skb))
+			goto free_skb;
+	} else {
+		/* Classical CAN */
+		if (!can_is_can_skb(skb))
+			goto free_skb;
+	}
+
 	sockcm_init(&sockc, sk);
 	if (msg->msg_controllen) {
 		err = sock_cmsg_send(sk, msg, &sockc);
-- 
2.35.1


