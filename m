Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 693704DB9B5
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 21:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358041AbiCPUut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 16:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242606AbiCPUur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 16:50:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F78239141
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 13:49:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nUaaI-0003pv-QV
        for netdev@vger.kernel.org; Wed, 16 Mar 2022 21:49:30 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 0AAA64CBA4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 20:47:12 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9D1664CB6C;
        Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 09d47ba5;
        Wed, 16 Mar 2022 20:47:11 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Derek Will <derekrobertwill@gmail.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH net-next 3/5] can: isotp: support MSG_TRUNC flag when reading from socket
Date:   Wed, 16 Mar 2022 21:47:08 +0100
Message-Id: <20220316204710.716341-4-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220316204710.716341-1-mkl@pengutronix.de>
References: <20220316204710.716341-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Hartkopp <socketcan@hartkopp.net>

When providing the MSG_TRUNC flag via recvmsg() syscall the return value
provides the real length of the packet or datagram, even when it was longer
than the passed buffer.

Fixes: e057dd3fc20f ("can: add ISO 15765-2:2016 transport protocol")
Link: https://github.com/linux-can/can-utils/issues/347#issuecomment-1065932671
Link: https://lore.kernel.org/all/20220316164258.54155-3-socketcan@hartkopp.net
Suggested-by: Derek Will <derekrobertwill@gmail.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
---
 net/can/isotp.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 6b6c82206c30..f6f8ba1f816d 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -1047,29 +1047,28 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 	struct sock *sk = sock->sk;
 	struct sk_buff *skb;
 	struct isotp_sock *so = isotp_sk(sk);
-	int err = 0;
-	int noblock;
+	int noblock = flags & MSG_DONTWAIT;
+	int ret = 0;
 
-	noblock = flags & MSG_DONTWAIT;
-	flags &= ~MSG_DONTWAIT;
+	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC))
+		return -EINVAL;
 
 	if (!so->bound)
 		return -EADDRNOTAVAIL;
 
-	skb = skb_recv_datagram(sk, flags, noblock, &err);
+	flags &= ~MSG_DONTWAIT;
+	skb = skb_recv_datagram(sk, flags, noblock, &ret);
 	if (!skb)
-		return err;
+		return ret;
 
 	if (size < skb->len)
 		msg->msg_flags |= MSG_TRUNC;
 	else
 		size = skb->len;
 
-	err = memcpy_to_msg(msg, skb->data, size);
-	if (err < 0) {
-		skb_free_datagram(sk, skb);
-		return err;
-	}
+	ret = memcpy_to_msg(msg, skb->data, size);
+	if (ret < 0)
+		goto out_err;
 
 	sock_recv_timestamp(msg, sk, skb);
 
@@ -1079,9 +1078,13 @@ static int isotp_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		memcpy(msg->msg_name, skb->cb, msg->msg_namelen);
 	}
 
+	/* set length of return value */
+	ret = (flags & MSG_TRUNC) ? skb->len : size;
+
+out_err:
 	skb_free_datagram(sk, skb);
 
-	return size;
+	return ret;
 }
 
 static int isotp_release(struct socket *sock)
-- 
2.35.1


