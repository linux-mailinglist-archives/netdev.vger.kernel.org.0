Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7552C4AEB3B
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 08:38:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238405AbiBIHgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 02:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238344AbiBIHge (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 02:36:34 -0500
Received: from mo4-p00-ob.smtp.rzone.de (mo4-p00-ob.smtp.rzone.de [85.215.255.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6982EC0612C3;
        Tue,  8 Feb 2022 23:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1644392182;
    s=strato-dkim-0002; d=hartkopp.net;
    h=Message-Id:Date:Subject:Cc:To:From:Cc:Date:From:Subject:Sender;
    bh=uofCJg/T34ONKMLcKchQD8KF0UbY2L5SPwHQJUadbxY=;
    b=prFSMD8NYsuG1pAddLIluMyBi8nsd+LL7s/iENmbGYqR7/1QEgdMbwUlib52LOihjG
    paBjkOfym1cYqTnmEda9iiNaXE+W2B7W+ZxecjsXkQjjD+Y6nvUaQU6AM7HcczooyGb4
    yfb+OfzBLflA8AoRnAAANSvGn8Owds8+U4Z3kvzhveLbXxRcbGnPGAGhYzFqrhSSYOnW
    CZSaaBweWPwoZTmukfEtuGy+5E61R8qfcQHgCIkXrJEf6EDIrUTp9fFMQnopYcLptdbs
    ggvU62WqCRFyY5Hl3PNR17jwCfwaGovPHWh0IBErtXYnFV8h3BhG2jRW+eqbbWxYZoZX
    QVMg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjGrp7owjzFK3JbFk1mS/xvEBL7X5sbo3UIh9IyLecSWJafUvprl4"
X-RZG-CLASS-ID: mo00
Received: from silver.lan
    by smtp.strato.de (RZmta 47.39.0 AUTH)
    with ESMTPSA id L7379cy197aMNnA
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Wed, 9 Feb 2022 08:36:22 +0100 (CET)
From:   Oliver Hartkopp <socketcan@hartkopp.net>
To:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Cc:     mkl@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Subject: [PATCH] can: isotp: fix error path in isotp_sendmsg() to unlock wait queue
Date:   Wed,  9 Feb 2022 08:36:01 +0100
Message-Id: <20220209073601.25728-1-socketcan@hartkopp.net>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 43a08c3bdac4 ("can: isotp: isotp_sendmsg(): fix TX buffer concurrent
access in isotp_sendmsg()") introduced a new locking scheme that may render
the userspace application in a locking state when an error is detected.
This issue shows up under high load on simultaneously running isotp channels
with identical configuration which is against the ISO specification and
therefore breaks any reasonable PDU communication anyway.

Fixes: 43a08c3bdac4 ("can: isotp: isotp_sendmsg(): fix TX buffer concurrent access in isotp_sendmsg()")
Cc: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: Oliver Hartkopp <socketcan@hartkopp.net>
---
 net/can/isotp.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9149e8d8aefc..d2a430b6a13b 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -885,38 +885,38 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			goto err_out;
 	}
 
 	if (!size || size > MAX_MSG_LENGTH) {
 		err = -EINVAL;
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	/* take care of a potential SF_DL ESC offset for TX_DL > 8 */
 	off = (so->tx.ll_dl > CAN_MAX_DLEN) ? 1 : 0;
 
 	/* does the given data fit into a single frame for SF_BROADCAST? */
 	if ((so->opt.flags & CAN_ISOTP_SF_BROADCAST) &&
 	    (size > so->tx.ll_dl - SF_PCI_SZ4 - ae - off)) {
 		err = -EINVAL;
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	err = memcpy_from_msg(so->tx.buf, msg, size);
 	if (err < 0)
-		goto err_out;
+		goto err_out_drop;
 
 	dev = dev_get_by_index(sock_net(sk), so->ifindex);
 	if (!dev) {
 		err = -ENXIO;
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	skb = sock_alloc_send_skb(sk, so->ll.mtu + sizeof(struct can_skb_priv),
 				  msg->msg_flags & MSG_DONTWAIT, &err);
 	if (!skb) {
 		dev_put(dev);
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	can_skb_reserve(skb);
 	can_skb_prv(skb)->ifindex = dev->ifindex;
 	can_skb_prv(skb)->skbcnt = 0;
@@ -974,11 +974,11 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	err = can_send(skb, 1);
 	dev_put(dev);
 	if (err) {
 		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
 			       __func__, ERR_PTR(err));
-		goto err_out;
+		goto err_out_drop;
 	}
 
 	if (wait_tx_done) {
 		/* wait for complete transmission of current pdu */
 		wait_event_interruptible(so->wait, so->tx.state == ISOTP_IDLE);
@@ -987,10 +987,13 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 			return -sk->sk_err;
 	}
 
 	return size;
 
+err_out_drop:
+	/* drop this PDU and unlock a potential wait queue */
+	old_state = ISOTP_IDLE;
 err_out:
 	so->tx.state = old_state;
 	if (so->tx.state == ISOTP_IDLE)
 		wake_up_interruptible(&so->wait);
 
-- 
2.30.2

