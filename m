Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05904AE336
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 23:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245652AbiBHWV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 17:21:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387272AbiBHWU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 17:20:56 -0500
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEC3C0612B8;
        Tue,  8 Feb 2022 14:20:55 -0800 (PST)
Received: from localhost.localdomain (ip5f5aebc2.dynamic.kabel-deutschland.de [95.90.235.194])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 4669B61E64846;
        Tue,  8 Feb 2022 23:20:54 +0100 (CET)
From:   Paul Menzel <pmenzel@molgen.mpg.de>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Paul Menzel <pmenzel@molgen.mpg.de>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Revert "Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg"
Date:   Tue,  8 Feb 2022 23:19:11 +0100
Message-Id: <20220208221911.57058-2-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220208221911.57058-1-pmenzel@molgen.mpg.de>
References: <20220208221911.57058-1-pmenzel@molgen.mpg.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 81be03e026dc0c16dc1c64e088b2a53b73caa895.

Since the commit, transferring files greater than some bytes to the
Nokia N9 (MeeGo) or Jolla (Sailfish OS) is not possible anymore.

    # obexctl
    [NEW] Client /org/bluez/obex
    [obex]# connect 40:98:4E:5B:CE:XX
    Attempting to connect to 40:98:4E:5B:CE:XX
    [NEW] Session /org/bluez/obex/client/session0 [default]
    [NEW] ObjectPush /org/bluez/obex/client/session0
    Connection successful
    [40:98:4E:5B:CE:XX]# send /lib/systemd/systemd
    Attempting to send /lib/systemd/systemd to /org/bluez/obex/client/session0
    [NEW] Transfer /org/bluez/obex/client/session0/transfer0
    Transfer /org/bluez/obex/client/session0/transfer0
        Status: queued
        Name: systemd
        Size: 1841712
        Filename: /lib/systemd/systemd
        Session: /org/bluez/obex/client/session0
    [CHG] Transfer /org/bluez/obex/client/session0/transfer0 Status: active
    [CHG] Transfer /org/bluez/obex/client/session0/transfer0 Transferred: 32737 (@32KB/s 00:55)
    [CHG] Transfer /org/bluez/obex/client/session0/transfer0 Status: error
    [DEL] Transfer /org/bluez/obex/client/session0/transfer0

Reverting it, fixes the regression.

Link: https://lore.kernel.org/linux-bluetooth/aa3ee7ac-6c52-3861-1798-3cc1a37f6ebf@molgen.mpg.de/T/#m1f9673e4ab0d55a7dccf87905337ab2e67d689f1
Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 net/bluetooth/rfcomm/core.c | 50 ++++++-------------------------------
 net/bluetooth/rfcomm/sock.c | 46 ++++++++++++++++++++++++++--------
 2 files changed, 43 insertions(+), 53 deletions(-)

diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index 7324764384b6..f2bacb464ccf 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -549,58 +549,22 @@ struct rfcomm_dlc *rfcomm_dlc_exists(bdaddr_t *src, bdaddr_t *dst, u8 channel)
 	return dlc;
 }
 
-static int rfcomm_dlc_send_frag(struct rfcomm_dlc *d, struct sk_buff *frag)
-{
-	int len = frag->len;
-
-	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
-
-	if (len > d->mtu)
-		return -EINVAL;
-
-	rfcomm_make_uih(frag, d->addr);
-	__skb_queue_tail(&d->tx_queue, frag);
-
-	return len;
-}
-
 int rfcomm_dlc_send(struct rfcomm_dlc *d, struct sk_buff *skb)
 {
-	unsigned long flags;
-	struct sk_buff *frag, *next;
-	int len;
+	int len = skb->len;
 
 	if (d->state != BT_CONNECTED)
 		return -ENOTCONN;
 
-	frag = skb_shinfo(skb)->frag_list;
-	skb_shinfo(skb)->frag_list = NULL;
-
-	/* Queue all fragments atomically. */
-	spin_lock_irqsave(&d->tx_queue.lock, flags);
-
-	len = rfcomm_dlc_send_frag(d, skb);
-	if (len < 0 || !frag)
-		goto unlock;
-
-	for (; frag; frag = next) {
-		int ret;
-
-		next = frag->next;
-
-		ret = rfcomm_dlc_send_frag(d, frag);
-		if (ret < 0) {
-			kfree_skb(frag);
-			goto unlock;
-		}
+	BT_DBG("dlc %p mtu %d len %d", d, d->mtu, len);
 
-		len += ret;
-	}
+	if (len > d->mtu)
+		return -EINVAL;
 
-unlock:
-	spin_unlock_irqrestore(&d->tx_queue.lock, flags);
+	rfcomm_make_uih(skb, d->addr);
+	skb_queue_tail(&d->tx_queue, skb);
 
-	if (len > 0 && !test_bit(RFCOMM_TX_THROTTLED, &d->flags))
+	if (!test_bit(RFCOMM_TX_THROTTLED, &d->flags))
 		rfcomm_schedule();
 	return len;
 }
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 5938af3e9936..2c95bb58f901 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -575,20 +575,46 @@ static int rfcomm_sock_sendmsg(struct socket *sock, struct msghdr *msg,
 	lock_sock(sk);
 
 	sent = bt_sock_wait_ready(sk, msg->msg_flags);
+	if (sent)
+		goto done;
 
-	release_sock(sk);
+	while (len) {
+		size_t size = min_t(size_t, len, d->mtu);
+		int err;
 
-	if (sent)
-		return sent;
+		skb = sock_alloc_send_skb(sk, size + RFCOMM_SKB_RESERVE,
+				msg->msg_flags & MSG_DONTWAIT, &err);
+		if (!skb) {
+			if (sent == 0)
+				sent = err;
+			break;
+		}
+		skb_reserve(skb, RFCOMM_SKB_HEAD_RESERVE);
+
+		err = memcpy_from_msg(skb_put(skb, size), msg, size);
+		if (err) {
+			kfree_skb(skb);
+			if (sent == 0)
+				sent = err;
+			break;
+		}
+
+		skb->priority = sk->sk_priority;
+
+		err = rfcomm_dlc_send(d, skb);
+		if (err < 0) {
+			kfree_skb(skb);
+			if (sent == 0)
+				sent = err;
+			break;
+		}
 
-	skb = bt_skb_sendmmsg(sk, msg, len, d->mtu, RFCOMM_SKB_HEAD_RESERVE,
-			      RFCOMM_SKB_TAIL_RESERVE);
-	if (IS_ERR_OR_NULL(skb))
-		return PTR_ERR(skb);
+		sent += size;
+		len  -= size;
+	}
 
-	sent = rfcomm_dlc_send(d, skb);
-	if (sent < 0)
-		kfree_skb(skb);
+done:
+	release_sock(sk);
 
 	return sent;
 }
-- 
2.34.1

