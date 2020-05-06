Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6491F1C7C80
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:33:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729962AbgEFVdb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:33:31 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:53575 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729152AbgEFVd1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 17:33:27 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 009af1fd;
        Wed, 6 May 2020 21:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=iKaIY/IfgB+5XH5ZbMMcDObHv
        hc=; b=lacZfV2bP5Hv2l9t4Z0D5x+8oUs+uHtosILJsV3+1DXmj43ZQOZn8MYu9
        56c9qBxHSKJ98b+/VGFmPZ9BM/uExi6F+iUQkymg1cR86rILAuXDHBbQ0UF2f8zE
        d7rTykxxOLOrJ5iFJ8dklRBUJcVj2obQXv6DZdsjLa0x33rulMZ7jwKdGUKVQZ8b
        ZtVUtuaJAlx+ZsNQJcJ2hu8SnmHuu6hIpkEfrTMWrQyAvAGtqCD0zuntzZ6jaWhc
        qT8klRKLzTN9FrrNzQ0ZWl7HwSoqe0VwwP/UmcwAHeqa0oxbnIsjhoa9ybFsMLd1
        2ihKzq59qBrWu4JCegQ30ahJtoNbQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 70d827dd (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 6 May 2020 21:20:41 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH net 5/5] wireguard: send/receive: use explicit unlikely branch instead of implicit coalescing
Date:   Wed,  6 May 2020 15:33:06 -0600
Message-Id: <20200506213306.1344212-6-Jason@zx2c4.com>
In-Reply-To: <20200506213306.1344212-1-Jason@zx2c4.com>
References: <20200506213306.1344212-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's very unlikely that send will become true. It's nearly always false
between 0 and 120 seconds of a session, and in most cases becomes true
only between 120 and 121 seconds before becoming false again. So,
unlikely(send) is clearly the right option here.

What happened before was that we had this complex boolean expression
with multiple likely and unlikely clauses nested. Since this is
evaluated left-to-right anyway, the whole thing got converted to
unlikely. So, we can clean this up to better represent what's going on.

The generated code is the same.

Suggested-by: Sultan Alsawaf <sultan@kerneltoast.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/receive.c | 13 ++++++-------
 drivers/net/wireguard/send.c    | 15 ++++++---------
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireguard/receive.c b/drivers/net/wireguard/receive.c
index 2566e13a292d..3bb5b9ae7cd1 100644
--- a/drivers/net/wireguard/receive.c
+++ b/drivers/net/wireguard/receive.c
@@ -226,21 +226,20 @@ void wg_packet_handshake_receive_worker(struct work_struct *work)
 static void keep_key_fresh(struct wg_peer *peer)
 {
 	struct noise_keypair *keypair;
-	bool send = false;
+	bool send;
 
 	if (peer->sent_lastminute_handshake)
 		return;
 
 	rcu_read_lock_bh();
 	keypair = rcu_dereference_bh(peer->keypairs.current_keypair);
-	if (likely(keypair && READ_ONCE(keypair->sending.is_valid)) &&
-	    keypair->i_am_the_initiator &&
-	    unlikely(wg_birthdate_has_expired(keypair->sending.birthdate,
-			REJECT_AFTER_TIME - KEEPALIVE_TIMEOUT - REKEY_TIMEOUT)))
-		send = true;
+	send = keypair && READ_ONCE(keypair->sending.is_valid) &&
+	       keypair->i_am_the_initiator &&
+	       wg_birthdate_has_expired(keypair->sending.birthdate,
+			REJECT_AFTER_TIME - KEEPALIVE_TIMEOUT - REKEY_TIMEOUT);
 	rcu_read_unlock_bh();
 
-	if (send) {
+	if (unlikely(send)) {
 		peer->sent_lastminute_handshake = true;
 		wg_packet_send_queued_handshake_initiation(peer, false);
 	}
diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index dc3079e17c7f..6687db699803 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -124,20 +124,17 @@ void wg_packet_send_handshake_cookie(struct wg_device *wg,
 static void keep_key_fresh(struct wg_peer *peer)
 {
 	struct noise_keypair *keypair;
-	bool send = false;
+	bool send;
 
 	rcu_read_lock_bh();
 	keypair = rcu_dereference_bh(peer->keypairs.current_keypair);
-	if (likely(keypair && READ_ONCE(keypair->sending.is_valid)) &&
-	    (unlikely(atomic64_read(&keypair->sending.counter.counter) >
-		      REKEY_AFTER_MESSAGES) ||
-	     (keypair->i_am_the_initiator &&
-	      unlikely(wg_birthdate_has_expired(keypair->sending.birthdate,
-						REKEY_AFTER_TIME)))))
-		send = true;
+	send = keypair && READ_ONCE(keypair->sending.is_valid) &&
+	       (atomic64_read(&keypair->sending.counter.counter) > REKEY_AFTER_MESSAGES ||
+		(keypair->i_am_the_initiator &&
+		 wg_birthdate_has_expired(keypair->sending.birthdate, REKEY_AFTER_TIME)));
 	rcu_read_unlock_bh();
 
-	if (send)
+	if (unlikely(send))
 		wg_packet_send_queued_handshake_initiation(peer, false);
 }
 
-- 
2.26.2

