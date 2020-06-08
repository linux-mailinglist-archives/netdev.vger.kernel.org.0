Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05A781F2C8F
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 02:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732017AbgFIAZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 20:25:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:38394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730380AbgFHXQ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Jun 2020 19:16:59 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1073E20842;
        Mon,  8 Jun 2020 23:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658218;
        bh=KHmf4DzzWCF9mPRA9Ix69YMow6JAZbDZxzC58wlWWx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BR7co9c1xH4K1OUMBqq1ea7iVVCeiSmn8zKU5t6bl4JD/fgVONwKH8xIC8kOMM5W5
         gkKL4lg5EM55DjlrwmKj64jHZInUTrmnislQ6w7+Shu4FYBDgQaFxJvnH3xJ7gNBt3
         MAh4nJzKxfVwtFtYYLPLkC+fP9C7NtbtOLJdTFtA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Matt Dunwoodie <ncon@noconroy.net>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.6 234/606] wireguard: noise: read preshared key while taking lock
Date:   Mon,  8 Jun 2020 19:05:59 -0400
Message-Id: <20200608231211.3363633-234-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

[ Upstream commit bc67d371256f5c47d824e2eec51e46c8d62d022e ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
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
2.25.1

