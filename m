Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DE021210A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 12:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728586AbgGBKWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 06:22:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:59820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728379AbgGBKU2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 06:20:28 -0400
Received: from e123331-lin.nice.arm.com (lfbn-nic-1-188-42.w2-15.abo.wanadoo.fr [2.15.37.42])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C61120747;
        Thu,  2 Jul 2020 10:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593685227;
        bh=K/YKWmFmMxrknHU9GpBAMuzcSIeTYnk+XWbWEpLs/+M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ffi+t5z0X97+zWS7W130a3OgzDDu34UJR1ix9sN4yi86JLWskkFzoFRKgfcZx9tSZ
         ZGWNlIpieN0GLFF3Vfj5KKTRIq2nlEx/KjGrALWlKziECLTMtlxLDar+FqBwL92MzG
         w/+6JsJFxna0mSJHhaZZbc4lTXj/rf6oftUGt7Io=
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-kernel@vger.kernel.org
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Eric Biggers <ebiggers@google.com>,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-nfs@vger.kernel.org
Subject: [RFC PATCH 2/7] staging/rtl8192u: switch to RC4 library interface
Date:   Thu,  2 Jul 2020 12:19:42 +0200
Message-Id: <20200702101947.682-3-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200702101947.682-1-ardb@kernel.org>
References: <20200702101947.682-1-ardb@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Switch to the ARC4 library interface, to remove the pointless
dependency on the skcipher API, from which we will hopefully be
able to drop ecb(arc4) skcipher support.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 drivers/staging/rtl8192u/Kconfig                          |  1 +
 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c | 82 ++++----------------
 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c  | 64 +++------------
 3 files changed, 27 insertions(+), 120 deletions(-)

diff --git a/drivers/staging/rtl8192u/Kconfig b/drivers/staging/rtl8192u/Kconfig
index 1edca5c304fb..ef883d462d3d 100644
--- a/drivers/staging/rtl8192u/Kconfig
+++ b/drivers/staging/rtl8192u/Kconfig
@@ -8,3 +8,4 @@ config RTL8192U
 	select CRYPTO
 	select CRYPTO_AES
 	select CRYPTO_CCM
+	select CRYPTO_LIB_ARC4
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
index ffe624ed0c0c..a315133c20db 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2003-2004, Jouni Malinen <jkmaline@cc.hut.fi>
  */
 
+#include <linux/fips.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -17,9 +18,7 @@
 
 #include "ieee80211.h"
 
-#include <crypto/hash.h>
-#include <crypto/skcipher.h>
-	#include <linux/scatterlist.h>
+#include <crypto/arc4.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
@@ -49,9 +48,9 @@ struct ieee80211_tkip_data {
 
 	int key_idx;
 
-	struct crypto_sync_skcipher *rx_tfm_arc4;
+	struct arc4_ctx rx_ctx_arc4;
+	struct arc4_ctx tx_ctx_arc4;
 	struct crypto_shash *rx_tfm_michael;
-	struct crypto_sync_skcipher *tx_tfm_arc4;
 	struct crypto_shash *tx_tfm_michael;
 
 	/* scratch buffers for virt_to_page() (crypto API) */
@@ -62,19 +61,14 @@ static void *ieee80211_tkip_init(int key_idx)
 {
 	struct ieee80211_tkip_data *priv;
 
+	if (fips_enabled)
+		return NULL;
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		goto fail;
 	priv->key_idx = key_idx;
 
-	priv->tx_tfm_arc4 = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
-	if (IS_ERR(priv->tx_tfm_arc4)) {
-		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
-				"crypto API arc4\n");
-		priv->tx_tfm_arc4 = NULL;
-		goto fail;
-	}
-
 	priv->tx_tfm_michael = crypto_alloc_shash("michael_mic", 0, 0);
 	if (IS_ERR(priv->tx_tfm_michael)) {
 		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
@@ -83,14 +77,6 @@ static void *ieee80211_tkip_init(int key_idx)
 		goto fail;
 	}
 
-	priv->rx_tfm_arc4 = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
-	if (IS_ERR(priv->rx_tfm_arc4)) {
-		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
-				"crypto API arc4\n");
-		priv->rx_tfm_arc4 = NULL;
-		goto fail;
-	}
-
 	priv->rx_tfm_michael = crypto_alloc_shash("michael_mic", 0, 0);
 	if (IS_ERR(priv->rx_tfm_michael)) {
 		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
@@ -104,9 +90,7 @@ static void *ieee80211_tkip_init(int key_idx)
 fail:
 	if (priv) {
 		crypto_free_shash(priv->tx_tfm_michael);
-		crypto_free_sync_skcipher(priv->tx_tfm_arc4);
 		crypto_free_shash(priv->rx_tfm_michael);
-		crypto_free_sync_skcipher(priv->rx_tfm_arc4);
 		kfree(priv);
 	}
 
@@ -120,11 +104,9 @@ static void ieee80211_tkip_deinit(void *priv)
 
 	if (_priv) {
 		crypto_free_shash(_priv->tx_tfm_michael);
-		crypto_free_sync_skcipher(_priv->tx_tfm_arc4);
 		crypto_free_shash(_priv->rx_tfm_michael);
-		crypto_free_sync_skcipher(_priv->rx_tfm_arc4);
 	}
-	kfree(priv);
+	kzfree(priv);
 }
 
 
@@ -290,10 +272,8 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u8 *pos;
 	struct rtl_80211_hdr_4addr *hdr;
 	struct cb_desc *tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
-	int ret = 0;
 	u8 rc4key[16],  *icv;
 	u32 crc;
-	struct scatterlist sg;
 
 	if (skb_headroom(skb) < 8 || skb_tailroom(skb) < 4 ||
 	    skb->len < hdr_len)
@@ -334,21 +314,15 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	*pos++ = (tkey->tx_iv32 >> 24) & 0xff;
 
 	if (!tcb_desc->bHwSec) {
-		SYNC_SKCIPHER_REQUEST_ON_STACK(req, tkey->tx_tfm_arc4);
-
 		icv = skb_put(skb, 4);
 		crc = ~crc32_le(~0, pos, len);
 		icv[0] = crc;
 		icv[1] = crc >> 8;
 		icv[2] = crc >> 16;
 		icv[3] = crc >> 24;
-		crypto_sync_skcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
-		sg_init_one(&sg, pos, len + 4);
-		skcipher_request_set_sync_tfm(req, tkey->tx_tfm_arc4);
-		skcipher_request_set_callback(req, 0, NULL, NULL);
-		skcipher_request_set_crypt(req, &sg, &sg, len + 4, NULL);
-		ret = crypto_skcipher_encrypt(req);
-		skcipher_request_zero(req);
+
+		arc4_setkey(&tkey->tx_ctx_arc4, rc4key, 16);
+		arc4_crypt(&tkey->tx_ctx_arc4, pos, pos, len + 4);
 	}
 
 	tkey->tx_iv16++;
@@ -357,12 +331,7 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		tkey->tx_iv32++;
 	}
 
-	if (!tcb_desc->bHwSec)
-		return ret;
-	else
-		return 0;
-
-
+	return 0;
 }
 
 static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
@@ -376,9 +345,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u8 rc4key[16];
 	u8 icv[4];
 	u32 crc;
-	struct scatterlist sg;
 	int plen;
-	int err;
 
 	if (skb->len < hdr_len + 8 + 4)
 		return -1;
@@ -412,8 +379,6 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	pos += 8;
 
 	if (!tcb_desc->bHwSec) {
-		SYNC_SKCIPHER_REQUEST_ON_STACK(req, tkey->rx_tfm_arc4);
-
 		if (iv32 < tkey->rx_iv32 ||
 		(iv32 == tkey->rx_iv32 && iv16 <= tkey->rx_iv16)) {
 			if (net_ratelimit()) {
@@ -434,23 +399,8 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 		plen = skb->len - hdr_len - 12;
 
-		crypto_sync_skcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
-		sg_init_one(&sg, pos, plen + 4);
-
-		skcipher_request_set_sync_tfm(req, tkey->rx_tfm_arc4);
-		skcipher_request_set_callback(req, 0, NULL, NULL);
-		skcipher_request_set_crypt(req, &sg, &sg, plen + 4, NULL);
-
-		err = crypto_skcipher_decrypt(req);
-		skcipher_request_zero(req);
-		if (err) {
-			if (net_ratelimit()) {
-				netdev_dbg(skb->dev, "TKIP: failed to decrypt "
-						"received packet from %pM\n",
-						hdr->addr2);
-			}
-			return -7;
-		}
+		arc4_setkey(&tkey->rx_ctx_arc4, rc4key, 16);
+		arc4_crypt(&tkey->rx_ctx_arc4, pos, pos, plen + 4);
 
 		crc = ~crc32_le(~0, pos, plen);
 		icv[0] = crc;
@@ -655,17 +605,13 @@ static int ieee80211_tkip_set_key(void *key, int len, u8 *seq, void *priv)
 	struct ieee80211_tkip_data *tkey = priv;
 	int keyidx;
 	struct crypto_shash *tfm = tkey->tx_tfm_michael;
-	struct crypto_sync_skcipher *tfm2 = tkey->tx_tfm_arc4;
 	struct crypto_shash *tfm3 = tkey->rx_tfm_michael;
-	struct crypto_sync_skcipher *tfm4 = tkey->rx_tfm_arc4;
 
 	keyidx = tkey->key_idx;
 	memset(tkey, 0, sizeof(*tkey));
 	tkey->key_idx = keyidx;
 	tkey->tx_tfm_michael = tfm;
-	tkey->tx_tfm_arc4 = tfm2;
 	tkey->rx_tfm_michael = tfm3;
-	tkey->rx_tfm_arc4 = tfm4;
 
 	if (len == TKIP_KEY_LEN) {
 		memcpy(tkey->key, key, TKIP_KEY_LEN);
diff --git a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
index 26482c3dcd1c..1c56e2d03aae 100644
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2002-2004, Jouni Malinen <jkmaline@cc.hut.fi>
  */
 
+#include <linux/fips.h>
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/slab.h>
@@ -14,8 +15,7 @@
 
 #include "ieee80211.h"
 
-#include <crypto/skcipher.h>
-#include <linux/scatterlist.h>
+#include <crypto/arc4.h>
 #include <linux/crc32.h>
 
 MODULE_AUTHOR("Jouni Malinen");
@@ -28,8 +28,8 @@ struct prism2_wep_data {
 	u8 key[WEP_KEY_LEN + 1];
 	u8 key_len;
 	u8 key_idx;
-	struct crypto_sync_skcipher *tx_tfm;
-	struct crypto_sync_skcipher *rx_tfm;
+	struct arc4_ctx rx_ctx_arc4;
+	struct arc4_ctx tx_ctx_arc4;
 };
 
 
@@ -37,39 +37,24 @@ static void *prism2_wep_init(int keyidx)
 {
 	struct prism2_wep_data *priv;
 
+	if (fips_enabled)
+		return NULL;
+
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return NULL;
 	priv->key_idx = keyidx;
 
-	priv->tx_tfm = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
-	if (IS_ERR(priv->tx_tfm))
-		goto free_priv;
-	priv->rx_tfm = crypto_alloc_sync_skcipher("ecb(arc4)", 0, 0);
-	if (IS_ERR(priv->rx_tfm))
-		goto free_tx;
-
 	/* start WEP IV from a random value */
 	get_random_bytes(&priv->iv, 4);
 
 	return priv;
-free_tx:
-	crypto_free_sync_skcipher(priv->tx_tfm);
-free_priv:
-	kfree(priv);
-	return NULL;
 }
 
 
 static void prism2_wep_deinit(void *priv)
 {
-	struct prism2_wep_data *_priv = priv;
-
-	if (_priv) {
-		crypto_free_sync_skcipher(_priv->tx_tfm);
-		crypto_free_sync_skcipher(_priv->rx_tfm);
-	}
-	kfree(priv);
+	kzfree(priv);
 }
 
 /* Perform WEP encryption on given skb that has at least 4 bytes of headroom
@@ -87,8 +72,6 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	struct cb_desc *tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u32 crc;
 	u8 *icv;
-	struct scatterlist sg;
-	int err;
 
 	if (skb_headroom(skb) < 4 || skb_tailroom(skb) < 4 ||
 	    skb->len < hdr_len)
@@ -124,8 +107,6 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	memcpy(key + 3, wep->key, wep->key_len);
 
 	if (!tcb_desc->bHwSec) {
-		SYNC_SKCIPHER_REQUEST_ON_STACK(req, wep->tx_tfm);
-
 		/* Append little-endian CRC32 and encrypt it to produce ICV */
 		crc = ~crc32_le(~0, pos, len);
 		icv = skb_put(skb, 4);
@@ -134,16 +115,8 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 		icv[2] = crc >> 16;
 		icv[3] = crc >> 24;
 
-		crypto_sync_skcipher_setkey(wep->tx_tfm, key, klen);
-		sg_init_one(&sg, pos, len + 4);
-
-		skcipher_request_set_sync_tfm(req, wep->tx_tfm);
-		skcipher_request_set_callback(req, 0, NULL, NULL);
-		skcipher_request_set_crypt(req, &sg, &sg, len + 4, NULL);
-
-		err = crypto_skcipher_encrypt(req);
-		skcipher_request_zero(req);
-		return err;
+		arc4_setkey(&wep->tx_ctx_arc4, key, klen);
+		arc4_crypt(&wep->tx_ctx_arc4, pos, pos, len + 4);
 	}
 
 	return 0;
@@ -166,8 +139,6 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	struct cb_desc *tcb_desc = (struct cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 	u32 crc;
 	u8 icv[4];
-	struct scatterlist sg;
-	int err;
 
 	if (skb->len < hdr_len + 8)
 		return -1;
@@ -189,19 +160,8 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	plen = skb->len - hdr_len - 8;
 
 	if (!tcb_desc->bHwSec) {
-		SYNC_SKCIPHER_REQUEST_ON_STACK(req, wep->rx_tfm);
-
-		crypto_sync_skcipher_setkey(wep->rx_tfm, key, klen);
-		sg_init_one(&sg, pos, plen + 4);
-
-		skcipher_request_set_sync_tfm(req, wep->rx_tfm);
-		skcipher_request_set_callback(req, 0, NULL, NULL);
-		skcipher_request_set_crypt(req, &sg, &sg, plen + 4, NULL);
-
-		err = crypto_skcipher_decrypt(req);
-		skcipher_request_zero(req);
-		if (err)
-			return -7;
+		arc4_setkey(&wep->rx_ctx_arc4, key, klen);
+		arc4_crypt(&wep->rx_ctx_arc4, pos, pos, plen + 4);
 
 		crc = ~crc32_le(~0, pos, plen);
 		icv[0] = crc;
-- 
2.17.1

