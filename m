Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81BF018A9D1
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 01:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727328AbgCSAa5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 20:30:57 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:39393 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726596AbgCSAa4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 20:30:56 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 1c9ba923;
        Thu, 19 Mar 2020 00:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=+zHFm0/F9vmAnsG2NXgZq9C8o
        wM=; b=2n4+462jz07TrTCTBndAM/7iZKDN/aUnfqKLemuRAJqfqRdRga20Ppq/U
        juyzRMdlJkkhHH6Lz/DRWJCrp1mzOApWchRbCN4PLTodY1sHelqcr/2nzQdIH+zO
        c8F+9//aDXX+BSYBzXbULM2foqSsT+m1DjCvewf1R8CORnpfx6TAx48EdHjhPSVg
        lPggvQXvNzc0SUwaqgRKndXacCLTWL9lgn/F3DPL0J06ZX7gHWPBGYXyLqRtp26P
        1PfSqYYo+UL8Fph1XgFhrqsM4b0vAhseBvcvz7QwFHdJQPbedn+g4sR+WY5wlxFB
        ++KzubKufAhiI7mhSQWlb+04xVRsg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 1cf06c71 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO);
        Thu, 19 Mar 2020 00:24:30 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 5/5] wireguard: noise: error out precomputed DH during handshake rather than config
Date:   Wed, 18 Mar 2020 18:30:47 -0600
Message-Id: <20200319003047.113501-6-Jason@zx2c4.com>
In-Reply-To: <20200319003047.113501-1-Jason@zx2c4.com>
References: <20200319003047.113501-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We precompute the static-static ECDH during configuration time, in order
to save an expensive computation later when receiving network packets.
However, not all ECDH computations yield a contributory result. Prior,
we were just not letting those peers be added to the interface. However,
this creates a strange inconsistency, since it was still possible to add
other weird points, like a valid public key plus a low-order point, and,
like points that result in zeros, a handshake would not complete. In
order to make the behavior more uniform and less surprising, simply
allow all peers to be added. Then, we'll error out later when doing the
crypto if there's an issue. This also adds more separation between the
crypto layer and the configuration layer.

Discussed-with: Mathias Hall-Andersen <mathias@hall-andersen.dk>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/netlink.c            |  8 +---
 drivers/net/wireguard/noise.c              | 55 ++++++++++++----------
 drivers/net/wireguard/noise.h              | 12 ++---
 drivers/net/wireguard/peer.c               |  7 +--
 tools/testing/selftests/wireguard/netns.sh | 15 ++++--
 5 files changed, 49 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netlink.c
index bda26405497c..802099c8828a 100644
--- a/drivers/net/wireguard/netlink.c
+++ b/drivers/net/wireguard/netlink.c
@@ -411,11 +411,7 @@ static int set_peer(struct wg_device *wg, struct nlattr **attrs)
 
 		peer = wg_peer_create(wg, public_key, preshared_key);
 		if (IS_ERR(peer)) {
-			/* Similar to the above, if the key is invalid, we skip
-			 * it without fanfare, so that services don't need to
-			 * worry about doing key validation themselves.
-			 */
-			ret = PTR_ERR(peer) == -EKEYREJECTED ? 0 : PTR_ERR(peer);
+			ret = PTR_ERR(peer);
 			peer = NULL;
 			goto out;
 		}
@@ -569,7 +565,7 @@ static int wg_set_device(struct sk_buff *skb, struct genl_info *info)
 							 private_key);
 		list_for_each_entry_safe(peer, temp, &wg->peer_list,
 					 peer_list) {
-			BUG_ON(!wg_noise_precompute_static_static(peer));
+			wg_noise_precompute_static_static(peer);
 			wg_noise_expire_current_peer_keypairs(peer);
 		}
 		wg_cookie_checker_precompute_device_keys(&wg->cookie_checker);
diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.c
index 919d9d866446..708dc61c974f 100644
--- a/drivers/net/wireguard/noise.c
+++ b/drivers/net/wireguard/noise.c
@@ -44,32 +44,23 @@ void __init wg_noise_init(void)
 }
 
 /* Must hold peer->handshake.static_identity->lock */
-bool wg_noise_precompute_static_static(struct wg_peer *peer)
+void wg_noise_precompute_static_static(struct wg_peer *peer)
 {
-	bool ret;
-
 	down_write(&peer->handshake.lock);
-	if (peer->handshake.static_identity->has_identity) {
-		ret = curve25519(
-			peer->handshake.precomputed_static_static,
+	if (!peer->handshake.static_identity->has_identity ||
+	    !curve25519(peer->handshake.precomputed_static_static,
 			peer->handshake.static_identity->static_private,
-			peer->handshake.remote_static);
-	} else {
-		u8 empty[NOISE_PUBLIC_KEY_LEN] = { 0 };
-
-		ret = curve25519(empty, empty, peer->handshake.remote_static);
+			peer->handshake.remote_static))
 		memset(peer->handshake.precomputed_static_static, 0,
 		       NOISE_PUBLIC_KEY_LEN);
-	}
 	up_write(&peer->handshake.lock);
-	return ret;
 }
 
-bool wg_noise_handshake_init(struct noise_handshake *handshake,
-			   struct noise_static_identity *static_identity,
-			   const u8 peer_public_key[NOISE_PUBLIC_KEY_LEN],
-			   const u8 peer_preshared_key[NOISE_SYMMETRIC_KEY_LEN],
-			   struct wg_peer *peer)
+void wg_noise_handshake_init(struct noise_handshake *handshake,
+			     struct noise_static_identity *static_identity,
+			     const u8 peer_public_key[NOISE_PUBLIC_KEY_LEN],
+			     const u8 peer_preshared_key[NOISE_SYMMETRIC_KEY_LEN],
+			     struct wg_peer *peer)
 {
 	memset(handshake, 0, sizeof(*handshake));
 	init_rwsem(&handshake->lock);
@@ -81,7 +72,7 @@ bool wg_noise_handshake_init(struct noise_handshake *handshake,
 		       NOISE_SYMMETRIC_KEY_LEN);
 	handshake->static_identity = static_identity;
 	handshake->state = HANDSHAKE_ZEROED;
-	return wg_noise_precompute_static_static(peer);
+	wg_noise_precompute_static_static(peer);
 }
 
 static void handshake_zero(struct noise_handshake *handshake)
@@ -403,6 +394,19 @@ static bool __must_check mix_dh(u8 chaining_key[NOISE_HASH_LEN],
 	return true;
 }
 
+static bool __must_check mix_precomputed_dh(u8 chaining_key[NOISE_HASH_LEN],
+					    u8 key[NOISE_SYMMETRIC_KEY_LEN],
+					    const u8 precomputed[NOISE_PUBLIC_KEY_LEN])
+{
+	static u8 zero_point[NOISE_PUBLIC_KEY_LEN];
+	if (unlikely(!crypto_memneq(precomputed, zero_point, NOISE_PUBLIC_KEY_LEN)))
+		return false;
+	kdf(chaining_key, key, NULL, precomputed, NOISE_HASH_LEN,
+	    NOISE_SYMMETRIC_KEY_LEN, 0, NOISE_PUBLIC_KEY_LEN,
+	    chaining_key);
+	return true;
+}
+
 static void mix_hash(u8 hash[NOISE_HASH_LEN], const u8 *src, size_t src_len)
 {
 	struct blake2s_state blake;
@@ -531,10 +535,9 @@ wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
 			NOISE_PUBLIC_KEY_LEN, key, handshake->hash);
 
 	/* ss */
-	kdf(handshake->chaining_key, key, NULL,
-	    handshake->precomputed_static_static, NOISE_HASH_LEN,
-	    NOISE_SYMMETRIC_KEY_LEN, 0, NOISE_PUBLIC_KEY_LEN,
-	    handshake->chaining_key);
+	if (!mix_precomputed_dh(handshake->chaining_key, key,
+				handshake->precomputed_static_static))
+		goto out;
 
 	/* {t} */
 	tai64n_now(timestamp);
@@ -595,9 +598,9 @@ wg_noise_handshake_consume_initiation(struct message_handshake_initiation *src,
 	handshake = &peer->handshake;
 
 	/* ss */
-	kdf(chaining_key, key, NULL, handshake->precomputed_static_static,
-	    NOISE_HASH_LEN, NOISE_SYMMETRIC_KEY_LEN, 0, NOISE_PUBLIC_KEY_LEN,
-	    chaining_key);
+	if (!mix_precomputed_dh(chaining_key, key,
+				handshake->precomputed_static_static))
+	    goto out;
 
 	/* {t} */
 	if (!message_decrypt(t, src->encrypted_timestamp,
diff --git a/drivers/net/wireguard/noise.h b/drivers/net/wireguard/noise.h
index 138a07bb817c..f532d59d3f19 100644
--- a/drivers/net/wireguard/noise.h
+++ b/drivers/net/wireguard/noise.h
@@ -94,11 +94,11 @@ struct noise_handshake {
 struct wg_device;
 
 void wg_noise_init(void);
-bool wg_noise_handshake_init(struct noise_handshake *handshake,
-			   struct noise_static_identity *static_identity,
-			   const u8 peer_public_key[NOISE_PUBLIC_KEY_LEN],
-			   const u8 peer_preshared_key[NOISE_SYMMETRIC_KEY_LEN],
-			   struct wg_peer *peer);
+void wg_noise_handshake_init(struct noise_handshake *handshake,
+			     struct noise_static_identity *static_identity,
+			     const u8 peer_public_key[NOISE_PUBLIC_KEY_LEN],
+			     const u8 peer_preshared_key[NOISE_SYMMETRIC_KEY_LEN],
+			     struct wg_peer *peer);
 void wg_noise_handshake_clear(struct noise_handshake *handshake);
 static inline void wg_noise_reset_last_sent_handshake(atomic64_t *handshake_ns)
 {
@@ -116,7 +116,7 @@ void wg_noise_expire_current_peer_keypairs(struct wg_peer *peer);
 void wg_noise_set_static_identity_private_key(
 	struct noise_static_identity *static_identity,
 	const u8 private_key[NOISE_PUBLIC_KEY_LEN]);
-bool wg_noise_precompute_static_static(struct wg_peer *peer);
+void wg_noise_precompute_static_static(struct wg_peer *peer);
 
 bool
 wg_noise_handshake_create_initiation(struct message_handshake_initiation *dst,
diff --git a/drivers/net/wireguard/peer.c b/drivers/net/wireguard/peer.c
index 071eedf33f5a..1d634bd3038f 100644
--- a/drivers/net/wireguard/peer.c
+++ b/drivers/net/wireguard/peer.c
@@ -34,11 +34,8 @@ struct wg_peer *wg_peer_create(struct wg_device *wg,
 		return ERR_PTR(ret);
 	peer->device = wg;
 
-	if (!wg_noise_handshake_init(&peer->handshake, &wg->static_identity,
-				     public_key, preshared_key, peer)) {
-		ret = -EKEYREJECTED;
-		goto err_1;
-	}
+	wg_noise_handshake_init(&peer->handshake, &wg->static_identity,
+				public_key, preshared_key, peer);
 	if (dst_cache_init(&peer->endpoint_cache, GFP_KERNEL))
 		goto err_1;
 	if (wg_packet_queue_init(&peer->tx_queue, wg_packet_tx_worker, false,
diff --git a/tools/testing/selftests/wireguard/netns.sh b/tools/testing/selftests/wireguard/netns.sh
index 138d46b3f330..936e1ca9410e 100755
--- a/tools/testing/selftests/wireguard/netns.sh
+++ b/tools/testing/selftests/wireguard/netns.sh
@@ -527,11 +527,16 @@ n0 wg set wg0 peer "$pub2" allowed-ips 0.0.0.0/0
 n0 wg set wg0 peer "$pub2" allowed-ips ::/0,1700::/111,5000::/4,e000::/37,9000::/75
 n0 wg set wg0 peer "$pub2" allowed-ips ::/0
 n0 wg set wg0 peer "$pub2" remove
-low_order_points=( AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA= AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA= 4Ot6fDtBuK4WVuP68Z/EatoJjeucMrH9hmIFFl9JuAA= X5yVvKNQjCSx0LFVnIPvWwREXMRYHI6G2CJO3dCfEVc= 7P///////////////////////////////////////38= 7f///////////////////////////////////////38= 7v///////////////////////////////////////38= )
-n0 wg set wg0 private-key /dev/null ${low_order_points[@]/#/peer }
-[[ -z $(n0 wg show wg0 peers) ]]
-n0 wg set wg0 private-key <(echo "$key1") ${low_order_points[@]/#/peer }
-[[ -z $(n0 wg show wg0 peers) ]]
+for low_order_point in AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA= AQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA= 4Ot6fDtBuK4WVuP68Z/EatoJjeucMrH9hmIFFl9JuAA= X5yVvKNQjCSx0LFVnIPvWwREXMRYHI6G2CJO3dCfEVc= 7P///////////////////////////////////////38= 7f///////////////////////////////////////38= 7v///////////////////////////////////////38=; do
+	n0 wg set wg0 peer "$low_order_point" persistent-keepalive 1 endpoint 127.0.0.1:1111
+done
+[[ -n $(n0 wg show wg0 peers) ]]
+exec 4< <(n0 ncat -l -u -p 1111)
+ncat_pid=$!
+waitncatudp $netns0 $ncat_pid
+ip0 link set wg0 up
+! read -r -n 1 -t 2 <&4 || false
+kill $ncat_pid
 ip0 link del wg0
 
 declare -A objects
-- 
2.25.1

