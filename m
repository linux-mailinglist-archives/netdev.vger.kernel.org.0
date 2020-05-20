Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78EE61DA973
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 06:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgETEtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 00:49:42 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:35181 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726309AbgETEtk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 May 2020 00:49:40 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2524ed96;
        Wed, 20 May 2020 04:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=8o5YgewLAIoWYCaX57OVtYe4b
        ko=; b=p4FkhH35hwNpnO2mwr1vLKNEg//LC6wIVVcLYaLSNdghN3InIIypOhB5L
        xK4NC08ugAL6ZVhcP9XamITyn++G6Wjt+6Wt5CSEvMoRPfNqsDn0UrY7oRJR+O08
        7UftFh/FgVY7O0HNY+5dT6y5UeylkN1zoWLV3zzaZWZuaJ30K7np/5yAHednx/Pq
        7j70IJ/wlnV/1MJ5IYA5hQgX7WM4q7EA9BksWuct7oidfJVKElJ1tAnbPoaIbmKl
        XXc0grBOVEQ9jyLBHPhqcB3upP3Hn5MEbwlhPOV3n5gJVrt+Cui+0fHt1pUtTR3e
        H9aXoD8fRIVmxInId/kh4OFXVJ6ZA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 47856adc (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 20 May 2020 04:35:11 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 2/4] wireguard: noise: read preshared key while taking lock
Date:   Tue, 19 May 2020 22:49:28 -0600
Message-Id: <20200520044930.8131-3-Jason@zx2c4.com>
In-Reply-To: <20200520044930.8131-1-Jason@zx2c4.com>
References: <20200520044930.8131-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Prior we read the preshared key after dropping the handshake lock, which
isn't an actual crypto issue if it races, but it's still not quite
correct. So copy that part of the state into a temporary like we do with
the rest of the handshake state variables. Then we can release the lock,
operate on the temporary, and zero it out at the end of the function. In
performance tests, the impact of this was entirely unnoticable, probably
because those bytes are coming from the same cacheline as other things
that are being copied out in the same manner.

Reported-by: Matt Dunwoodie <ncon@noconroy.net>
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/noise.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index 708dc61c974f..07eb438a6dee 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -715,6 +715,7 @@ wg_noise_handshake_consume_response(struct message_handshake_response *src,
 	u8 e[NOISE_PUBLIC_KEY_LEN];
 	u8 ephemeral_private[NOISE_PUBLIC_KEY_LEN];
 	u8 static_private[NOISE_PUBLIC_KEY_LEN];
+	u8 preshared_key[NOISE_SYMMETRIC_KEY_LEN];
 
 	down_read(&wg->static_identity.lock);
 
@@ -733,6 +734,8 @@ wg_noise_handshake_consume_response(struct message_handshake_response *src,
 	memcpy(chaining_key, handshake->chaining_key, NOISE_HASH_LEN);
 	memcpy(ephemeral_private, handshake->ephemeral_private,
 	       NOISE_PUBLIC_KEY_LEN);
+	memcpy(preshared_key, handshake->preshared_key,
+	       NOISE_SYMMETRIC_KEY_LEN);
 	up_read(&handshake->lock);
 
 	if (state != HANDSHAKE_CREATED_INITIATION)
@@ -750,7 +753,7 @@ wg_noise_handshake_consume_response(struct message_handshake_response *src,
 		goto fail;
 
 	/* psk */
-	mix_psk(chaining_key, hash, key, handshake->preshared_key);
+	mix_psk(chaining_key, hash, key, preshared_key);
 
 	/* {} */
 	if (!message_decrypt(NULL, src->encrypted_nothing,
@@ -783,6 +786,7 @@ wg_noise_handshake_consume_response(struct message_handshake_response *src,
 	memzero_explicit(chaining_key, NOISE_HASH_LEN);
 	memzero_explicit(ephemeral_private, NOISE_PUBLIC_KEY_LEN);
 	memzero_explicit(static_private, NOISE_PUBLIC_KEY_LEN);
+	memzero_explicit(preshared_key, NOISE_SYMMETRIC_KEY_LEN);
 	up_read(&wg->static_identity.lock);
 	return ret_peer;
 }
-- 
2.26.2

