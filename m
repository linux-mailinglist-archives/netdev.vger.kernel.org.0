Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E8B1A7581
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 10:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406996AbgDNIJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 04:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406984AbgDNIJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 04:09:03 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17CEC0A3BE2
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 01:09:02 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id l1so9140924pld.14
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 01:09:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=NSjekJEL9dfitQBDMlYCs94wAxGHyeVP0lyLYkmsTXc=;
        b=mmXkF1TiPnLArNENdITTbIK7PKEuRC0AWfk37LwCXOlAJi5whkVBaXbVlSthCWmVAp
         gprYNFHBDQOKwlHBdcRMXZvSpOLbn4DSE/YkC+XaFlVLdQfiXqhsyr5PnsfeQFzyqdB2
         ZkKZUhxsDmTr286OImNRkE5EVZRJuzd1Df6fqdbii8zhXu1WXcY0/OIFdDwpjUIn7KNi
         jOoSbcvXclS2ileGlm4eHyvhEDOR8fnKc+umRQS9MgG+YQvk6TOfedJKHkubEPdqOB6W
         bEqS/aaEsA2iYjWu2+7pKsxGiI0/gzpTZ+/PxnNljZV2PgZv+FJHYwyhYkZykwFk3AkU
         AgUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=NSjekJEL9dfitQBDMlYCs94wAxGHyeVP0lyLYkmsTXc=;
        b=P8esEyS1DgoDwTnle7gGEGHPhC+Liva1RKdruPqVvLzUfn7Wosa8/SoYox8rODEY3F
         pCYfG9HRi4LU5RpVdQDNdq2it3vhW+YRRQ26YYUpovaDEz0gxYNM7lbk+UiKi7eJuIse
         DhqoILq/1Sb5Oy00ZI1Mv8iA8Zde2K9WJYIMtVSQc6nBzfk//M093+qqLMcJ0ZazTGbJ
         Bv0fo+Q3jlXG2+XsiQ54qKRKiQ/LDWFUAc17gLHVflySxipgNDveKYdpTKWCKSh982b5
         ZebOjpIMoQXdUjJd0u0h7C22afK9Fpvazmi8WgJeWFabELYyFc2dLvEP5kjpPRYLyjWo
         HW/g==
X-Gm-Message-State: AGi0Pubj6Tzusd/MsbhsD993wwBpbfCDAWsDEtucSQA8lYAobdkzGo9x
        iruqXD+LvTGNJW2Mh0TwwS+VPgD8aeTf
X-Google-Smtp-Source: APiQypI8baE5/Q7SqmnUzI3AwP72Y2H9nKVzkJ7fBqelS6PhL2rYS2Ti9BIkayNWGf2zD1m0exBOQ/IlWhvs
X-Received: by 2002:a63:2901:: with SMTP id p1mr20524245pgp.444.1586851742111;
 Tue, 14 Apr 2020 01:09:02 -0700 (PDT)
Date:   Tue, 14 Apr 2020 16:08:40 +0800
Message-Id: <20200414160758.v1.1.Idab9dcdc7da549ed1fd5c66341fb8baffaee8d10@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v1] Bluetooth: L2CAP: add support for waiting disconnection resp
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

Whenever we disconnect a L2CAP connection, we would immediately
report a disconnection event (EPOLLHUP) to the upper layer, without
waiting for the response of the other device.

This patch offers an option to wait until we receive a disconnection
response before reporting disconnection event, by using the "how"
parameter in l2cap_sock_shutdown(). Therefore, upper layer can opt
to wait for disconnection response by shutdown(sock, SHUT_WR).

This can be used to enforce proper disconnection order in HID,
where the disconnection of the interrupt channel must be complete
before attempting to disconnect the control channel.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
---

 net/bluetooth/l2cap_sock.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/bluetooth/l2cap_sock.c b/net/bluetooth/l2cap_sock.c
index 1cea42ee1e922..a995d2c51fa7f 100644
--- a/net/bluetooth/l2cap_sock.c
+++ b/net/bluetooth/l2cap_sock.c
@@ -1271,14 +1271,21 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 	struct l2cap_conn *conn;
 	int err = 0;
 
-	BT_DBG("sock %p, sk %p", sock, sk);
+	BT_DBG("sock %p, sk %p, how %d", sock, sk, how);
+
+	/* 'how' parameter is mapped to sk_shutdown as follows:
+	 * SHUT_RD   (0) --> RCV_SHUTDOWN  (1)
+	 * SHUT_WR   (1) --> SEND_SHUTDOWN (2)
+	 * SHUT_RDWR (2) --> SHUTDOWN_MASK (3)
+	 */
+	how++;
 
 	if (!sk)
 		return 0;
 
 	lock_sock(sk);
 
-	if (sk->sk_shutdown)
+	if ((sk->sk_shutdown & how) == how)
 		goto shutdown_already;
 
 	BT_DBG("Handling sock shutdown");
@@ -1301,11 +1308,20 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 		 * has already been actioned to close the L2CAP
 		 * link such as by l2cap_disconnection_req().
 		 */
-		if (sk->sk_shutdown)
-			goto has_shutdown;
+		if ((sk->sk_shutdown & how) == how)
+			goto shutdown_matched;
 	}
 
-	sk->sk_shutdown = SHUTDOWN_MASK;
+	/* Try setting the RCV_SHUTDOWN bit, return early if SEND_SHUTDOWN
+	 * is already set
+	 */
+	if ((how & RCV_SHUTDOWN) && !(sk->sk_shutdown & RCV_SHUTDOWN)) {
+		sk->sk_shutdown |= RCV_SHUTDOWN;
+		if ((sk->sk_shutdown & how) == how)
+			goto shutdown_matched;
+	}
+
+	sk->sk_shutdown |= SEND_SHUTDOWN;
 	release_sock(sk);
 
 	l2cap_chan_lock(chan);
@@ -1335,7 +1351,7 @@ static int l2cap_sock_shutdown(struct socket *sock, int how)
 		err = bt_sock_wait_state(sk, BT_CLOSED,
 					 sk->sk_lingertime);
 
-has_shutdown:
+shutdown_matched:
 	l2cap_chan_put(chan);
 	sock_put(sk);
 
@@ -1363,7 +1379,7 @@ static int l2cap_sock_release(struct socket *sock)
 
 	bt_sock_unlink(&l2cap_sk_list, sk);
 
-	err = l2cap_sock_shutdown(sock, 2);
+	err = l2cap_sock_shutdown(sock, SHUT_RDWR);
 	chan = l2cap_pi(sk)->chan;
 
 	l2cap_chan_hold(chan);
-- 
2.26.0.110.g2183baf09c-goog

