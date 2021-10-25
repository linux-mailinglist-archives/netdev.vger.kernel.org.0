Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B4A439A90
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:31:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhJYPeS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:34:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230348AbhJYPeS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 11:34:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 628A360295;
        Mon, 25 Oct 2021 15:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635175915;
        bh=aO+p16sWYpfdYtZYGMflFOezVT89Z6b7ixa45AGyx3Y=;
        h=Date:From:To:Cc:Subject:From;
        b=ltzR+KffawqNSry1xhl57OY0JNqI8w7W3IbsQp/+8HC/t2ddU24zeFvlmgm2qv9He
         9l10Cml2Bi8jbRZjje9xGGqf2FGNUbXR2V6Jjh4wu+tx9F2JT9lWptCEQqfJ7H54Im
         YXeH1CdWMs7SSQCfSdDxGOIoWJ6uUS4NiXS5cSXY=
Date:   Mon, 25 Oct 2021 17:31:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     netdev@vger.kernel.org
Cc:     Jon Maloy <jmaloy@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tuong Lien <tuong.t.lien@dektech.com.au>,
        Max VA <maxv@sentinelone.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: [PATCH] tipc: fix size validations for the MSG_CRYPTO type
Message-ID: <YXbN6S9KPq8S5N0v@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Developer-Signature: v=1; a=openpgp-sha256; l=2710;
 i=gregkh@linuxfoundation.org; h=from:subject;
 bh=EIqXsI2RuxANBiB6WwsvXe3b/T4ofXGdCmz/CyT7O2g=;
 b=owGbwMvMwCRo6H6F97bub03G02pJDIllZ0Vn5b3kqZA/1mR8+i2bau/f2MmZztfWC3P2LNiSasxS
 FiPVEcvCIMjEICumyPJlG8/R/RWHFL0MbU/DzGFlAhnCwMUpABMxkGCYnxz+cPPKiFyduyZ+77yWn+
 ONl5U8zTC//OKFG+8uz3yRe8z/tPG3V78PK84VAwA=
X-Developer-Key: i=gregkh@linuxfoundation.org; a=openpgp;
 fpr=F4B60CC5BF78C2214A313DCB3147D40DDB2DFB29
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Max VA <maxv@sentinelone.com>

The function tipc_crypto_key_rcv is used to parse MSG_CRYPTO messages
to receive keys from other nodes in the cluster in order to decrypt any
further messages from them.
This patch verifies that any supplied sizes in the message body are
valid for the received message.

Fixes: 1ef6f7c9390f ("tipc: add automatic session key exchange")
Signed-off-by: Max VA <maxv@sentinelone.com>
Acked-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/crypto.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

Max's email system doesn't seem to be able to send non-attachment
patches out, so I'm forwarding this on for him.  It's already acked by
one of the tipc maintainers.

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index c9391d38de85..dc60c32bb70d 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -2285,43 +2285,53 @@ static bool tipc_crypto_key_rcv(struct tipc_crypto *rx, struct tipc_msg *hdr)
 	u16 key_gen = msg_key_gen(hdr);
 	u16 size = msg_data_sz(hdr);
 	u8 *data = msg_data(hdr);
+	unsigned int keylen;
+
+	/* Verify whether the size can exist in the packet */
+	if (unlikely(size < sizeof(struct tipc_aead_key) + TIPC_AEAD_KEYLEN_MIN)) {
+		pr_debug("%s: message data size is too small\n", rx->name);
+		goto exit;
+	}
+
+	keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
+
+	/* Verify the supplied size values */
+	if (unlikely(size != keylen + sizeof(struct tipc_aead_key) ||
+		     keylen > TIPC_AEAD_KEY_SIZE_MAX)) {
+		pr_debug("%s: invalid MSG_CRYPTO key size\n", rx->name);
+		goto exit;
+	}
 
 	spin_lock(&rx->lock);
 	if (unlikely(rx->skey || (key_gen == rx->key_gen && rx->key.keys))) {
 		pr_err("%s: key existed <%p>, gen %d vs %d\n", rx->name,
 		       rx->skey, key_gen, rx->key_gen);
-		goto exit;
+		goto exit_unlock;
 	}
 
 	/* Allocate memory for the key */
 	skey = kmalloc(size, GFP_ATOMIC);
 	if (unlikely(!skey)) {
 		pr_err("%s: unable to allocate memory for skey\n", rx->name);
-		goto exit;
+		goto exit_unlock;
 	}
 
 	/* Copy key from msg data */
-	skey->keylen = ntohl(*((__be32 *)(data + TIPC_AEAD_ALG_NAME)));
+	skey->keylen = keylen;
 	memcpy(skey->alg_name, data, TIPC_AEAD_ALG_NAME);
 	memcpy(skey->key, data + TIPC_AEAD_ALG_NAME + sizeof(__be32),
 	       skey->keylen);
 
-	/* Sanity check */
-	if (unlikely(size != tipc_aead_key_size(skey))) {
-		kfree(skey);
-		skey = NULL;
-		goto exit;
-	}
-
 	rx->key_gen = key_gen;
 	rx->skey_mode = msg_key_mode(hdr);
 	rx->skey = skey;
 	rx->nokey = 0;
 	mb(); /* for nokey flag */
 
-exit:
+exit_unlock:
 	spin_unlock(&rx->lock);
 
+exit:
 	/* Schedule the key attaching on this crypto */
 	if (likely(skey && queue_delayed_work(tx->wq, &rx->work, 0)))
 		return true;
-- 
2.33.1

