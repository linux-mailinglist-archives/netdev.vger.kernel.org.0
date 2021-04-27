Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFE436BED6
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 07:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhD0FWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 01:22:39 -0400
Received: from mout01.posteo.de ([185.67.36.65]:53155 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhD0FWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Apr 2021 01:22:36 -0400
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 1D702240029
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 07:21:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
        t=1619500912; bh=r49o/Gcq6TCorMWcYz7eb/OdEGXFuPCA/ZwX7ZH817k=;
        h=From:To:Subject:Date:From;
        b=jASVHDZY5jtu84PyQzgXYQ9SYofOzkZDhGy+zjeBE0cGCRL2WTdQM0n4OpbzomEwp
         LzJLVpzXqgZJpKIp+xA/0n1OYn4nKhm9sgnt+/QLCO5wehNMeUV27GFyEhgoe1PnEf
         waDLZDshOYV8/UvA9Lxppqo/IXSMBiKTZV2yTazPy172SlK8VBGqMwvpKFIdg4p24W
         c5lDdC06CnqowpubHTHO9PhdnuMQW0ydgulZE1y2NPfRT2epMzSOcYJULiyMDaNp03
         x763UQxBogfuuBf2TXPvbS3NFG2FcFwnSRsDT+cxDeFpZ3KW7J0UrX71fu1+3M5UsG
         0qqIostB4ASCQ==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4FTqrH3zRrz9rxM;
        Tue, 27 Apr 2021 07:21:51 +0200 (CEST)
From:   Patrick Menschel <menschel.p@posteo.de>
To:     Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/3] can-isotp: Change error format from decimal to symbolic error names
Date:   Tue, 27 Apr 2021 05:21:47 +0000
Message-Id: <20210427052150.2308-2-menschel.p@posteo.de>
In-Reply-To: <20210427052150.2308-1-menschel.p@posteo.de>
References: <20210427052150.2308-1-menschel.p@posteo.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch changes the format string for errors from
decimal %d to symbolic error names %pe to achieve
more comprehensive log messages.

Signed-off-by: Patrick Menschel <menschel.p@posteo.de>
---
 net/can/isotp.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/can/isotp.c b/net/can/isotp.c
index 9f94ad3ca..2c4f84fac 100644
--- a/net/can/isotp.c
+++ b/net/can/isotp.c
@@ -221,8 +221,8 @@ static int isotp_send_fc(struct sock *sk, int ae, u8 flowstatus)
 
 	can_send_ret = can_send(nskb, 1);
 	if (can_send_ret)
-		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
-			       __func__, can_send_ret);
+		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
+			       __func__, ERR_PTR(can_send_ret));
 
 	dev_put(dev);
 
@@ -798,8 +798,8 @@ static enum hrtimer_restart isotp_tx_timer_handler(struct hrtimer *hrtimer)
 
 		can_send_ret = can_send(skb, 1);
 		if (can_send_ret)
-			pr_notice_once("can-isotp: %s: can_send_ret %d\n",
-				       __func__, can_send_ret);
+			pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
+				       __func__, ERR_PTR(can_send_ret));
 
 		if (so->tx.idx >= so->tx.len) {
 			/* we are done */
@@ -946,8 +946,8 @@ static int isotp_sendmsg(struct socket *sock, struct msghdr *msg, size_t size)
 	err = can_send(skb, 1);
 	dev_put(dev);
 	if (err) {
-		pr_notice_once("can-isotp: %s: can_send_ret %d\n",
-			       __func__, err);
+		pr_notice_once("can-isotp: %s: can_send_ret %pe\n",
+			       __func__, ERR_PTR(err));
 		return err;
 	}
 
-- 
2.17.1

