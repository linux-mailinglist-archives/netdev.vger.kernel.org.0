Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7E134CC1B
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 11:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbhC2Izh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 04:55:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236675AbhC2IyE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 04:54:04 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3AFCC061756
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 01:54:03 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lQnes-0003WO-Et
        for netdev@vger.kernel.org; Mon, 29 Mar 2021 10:54:02 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 193856029A5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 08:54:01 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 873D8602989;
        Mon, 29 Mar 2021 08:53:57 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5a2e5dce;
        Mon, 29 Mar 2021 08:53:56 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Richard Weinberger <richard@nod.at>,
        Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [net 1/3] can: bcm/raw: fix msg_namelen values depending on CAN_REQUIRED_SIZE
Date:   Mon, 29 Mar 2021 10:53:53 +0200
Message-Id: <20210329085355.921447-2-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210329085355.921447-1-mkl@pengutronix.de>
References: <20210329085355.921447-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

Since commit f5223e9eee65 ("can: extend sockaddr_can to include j1939
members") the sockaddr_can has been extended in size and a new
CAN_REQUIRED_SIZE macro has been introduced to calculate the protocol
specific needed size.

The ABI for the msg_name and msg_namelen has not been adapted to the
new CAN_REQUIRED_SIZE macro for the other CAN protocols which leads to
a problem when an existing binary reads the (increased) struct
sockaddr_can in msg_name.

Fixes: f5223e9eee65 ("can: extend sockaddr_can to include j1939 members")
Reported-by: Richard Weinberger <richard@nod.at>
Tested-by: Richard Weinberger <richard@nod.at>
Acked-by: Kurt Van Dijck <dev.kurt@vandijck-laurijssen.be>
Link: https://lore.kernel.org/linux-can/1135648123.112255.1616613706554.JavaMail.zimbra@nod.at/T/#t
Link: https://lore.kernel.org/r/20210325125850.1620-1-socketcan@hartkopp.net
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/bcm.c | 10 ++++++----
 net/can/raw.c | 14 ++++++++------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/net/can/bcm.c b/net/can/bcm.c
index 0e5c37be4a2b..909b9e684e04 100644
--- a/net/can/bcm.c
+++ b/net/can/bcm.c
@@ -86,6 +86,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Oliver Hartkopp <oliver.hartkopp@volkswagen.de>");
 MODULE_ALIAS("can-proto-2");
 
+#define BCM_MIN_NAMELEN CAN_REQUIRED_SIZE(struct sockaddr_can, can_ifindex)
+
 /*
  * easy access to the first 64 bit of can(fd)_frame payload. cp->data is
  * 64 bit aligned so the offset has to be multiples of 8 which is ensured
@@ -1292,7 +1294,7 @@ static int bcm_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 		/* no bound device as default => check msg_name */
 		DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);
 
-		if (msg->msg_namelen < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+		if (msg->msg_namelen < BCM_MIN_NAMELEN)
 			return -EINVAL;
 
 		if (addr->can_family != AF_CAN)
@@ -1534,7 +1536,7 @@ static int bcm_connect(struct socket *sock, struct sockaddr *uaddr, int len,
 	struct net *net = sock_net(sk);
 	int ret = 0;
 
-	if (len < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+	if (len < BCM_MIN_NAMELEN)
 		return -EINVAL;
 
 	lock_sock(sk);
@@ -1616,8 +1618,8 @@ static int bcm_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
-		__sockaddr_check_size(sizeof(struct sockaddr_can));
-		msg->msg_namelen = sizeof(struct sockaddr_can);
+		__sockaddr_check_size(BCM_MIN_NAMELEN);
+		msg->msg_namelen = BCM_MIN_NAMELEN;
 		memcpy(msg->msg_name, skb->cb, msg->msg_namelen);
 	}
 
diff --git a/net/can/raw.c b/net/can/raw.c
index 37b47a39a3ed..139d9471ddcf 100644
--- a/net/can/raw.c
+++ b/net/can/raw.c
@@ -60,6 +60,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Urs Thuermann <urs.thuermann@volkswagen.de>");
 MODULE_ALIAS("can-proto-1");
 
+#define RAW_MIN_NAMELEN CAN_REQUIRED_SIZE(struct sockaddr_can, can_ifindex)
+
 #define MASK_ALL 0
 
 /* A raw socket has a list of can_filters attached to it, each receiving
@@ -394,7 +396,7 @@ static int raw_bind(struct socket *sock, struct sockaddr *uaddr, int len)
 	int err = 0;
 	int notify_enetdown = 0;
 
-	if (len < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+	if (len < RAW_MIN_NAMELEN)
 		return -EINVAL;
 	if (addr->can_family != AF_CAN)
 		return -EINVAL;
@@ -475,11 +477,11 @@ static int raw_getname(struct socket *sock, struct sockaddr *uaddr,
 	if (peer)
 		return -EOPNOTSUPP;
 
-	memset(addr, 0, sizeof(*addr));
+	memset(addr, 0, RAW_MIN_NAMELEN);
 	addr->can_family  = AF_CAN;
 	addr->can_ifindex = ro->ifindex;
 
-	return sizeof(*addr);
+	return RAW_MIN_NAMELEN;
 }
 
 static int raw_setsockopt(struct socket *sock, int level, int optname,
@@ -739,7 +741,7 @@ static int raw_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	if (msg->msg_name) {
 		DECLARE_SOCKADDR(struct sockaddr_can *, addr, msg->msg_name);
 
-		if (msg->msg_namelen < CAN_REQUIRED_SIZE(*addr, can_ifindex))
+		if (msg->msg_namelen < RAW_MIN_NAMELEN)
 			return -EINVAL;
 
 		if (addr->can_family != AF_CAN)
@@ -832,8 +834,8 @@ static int raw_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	sock_recv_ts_and_drops(msg, sk, skb);
 
 	if (msg->msg_name) {
-		__sockaddr_check_size(sizeof(struct sockaddr_can));
-		msg->msg_namelen = sizeof(struct sockaddr_can);
+		__sockaddr_check_size(RAW_MIN_NAMELEN);
+		msg->msg_namelen = RAW_MIN_NAMELEN;
 		memcpy(msg->msg_name, skb->cb, msg->msg_namelen);
 	}
 

base-commit: 1b479fb801602b22512f53c19b1f93a4fc5d5d9d
-- 
2.30.2


