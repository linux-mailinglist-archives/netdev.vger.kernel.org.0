Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D9D434DAA2
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhC2WXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:23:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:46580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231135AbhC2WWg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:22:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BC5E61999;
        Mon, 29 Mar 2021 22:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056555;
        bh=+EAdA/8I5+/z6wMH3rsiEpkHVN/+l0GcA0oJ/SB9EcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xns5WtKQlD4deGesGr6Do2a9kVifTVwD8FWlZS3k2qut7n+6so1S6TK5uznq4COev
         NL/k6CH8jcG1K7jd+cBYAInVp8NdIPEU6FME1o+48r9Ex/p/j5Xx96lnyNUomPdDGH
         bkuL9oQkH3kO6QzlN6TXg7Hk7qrL1c9UKw/gkCyygTNhOk7E8xi8cAAAdHdZkQSHLj
         f1tqb46lYxbdyVydKkpXNoh7nTzXQwMGyqbW1KzE6g6o1uJYBKvSqFNMAy94JXaIcp
         /NeMsPuOACXSYvVNJYPbNqxU9cgeO5PkFfi53bb/cEycmLdtbq+AspHDW+/EuL/Wn+
         W0CrVDDJr98MQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Phan <daniel.phan36@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 11/33] mac80211: Check crypto_aead_encrypt for errors
Date:   Mon, 29 Mar 2021 18:21:59 -0400
Message-Id: <20210329222222.2382987-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222222.2382987-1-sashal@kernel.org>
References: <20210329222222.2382987-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Daniel Phan <daniel.phan36@gmail.com>

[ Upstream commit 58d25626f6f0ea5bcec3c13387b9f835d188723d ]

crypto_aead_encrypt returns <0 on error, so if these calls are not checked,
execution may continue with failed encrypts.  It also seems that these two
crypto_aead_encrypt calls are the only instances in the codebase that are
not checked for errors.

Signed-off-by: Daniel Phan <daniel.phan36@gmail.com>
Link: https://lore.kernel.org/r/20210309204137.823268-1-daniel.phan36@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/aead_api.c | 5 +++--
 net/mac80211/aes_gmac.c | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/aead_api.c b/net/mac80211/aead_api.c
index d7b3d905d535..b00d6f5b33f4 100644
--- a/net/mac80211/aead_api.c
+++ b/net/mac80211/aead_api.c
@@ -23,6 +23,7 @@ int aead_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
 	struct aead_request *aead_req;
 	int reqsize = sizeof(*aead_req) + crypto_aead_reqsize(tfm);
 	u8 *__aad;
+	int ret;
 
 	aead_req = kzalloc(reqsize + aad_len, GFP_ATOMIC);
 	if (!aead_req)
@@ -40,10 +41,10 @@ int aead_encrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
 	aead_request_set_crypt(aead_req, sg, sg, data_len, b_0);
 	aead_request_set_ad(aead_req, sg[0].length);
 
-	crypto_aead_encrypt(aead_req);
+	ret = crypto_aead_encrypt(aead_req);
 	kfree_sensitive(aead_req);
 
-	return 0;
+	return ret;
 }
 
 int aead_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad, size_t aad_len,
diff --git a/net/mac80211/aes_gmac.c b/net/mac80211/aes_gmac.c
index 6f3b3a0cc10a..512cab073f2e 100644
--- a/net/mac80211/aes_gmac.c
+++ b/net/mac80211/aes_gmac.c
@@ -22,6 +22,7 @@ int ieee80211_aes_gmac(struct crypto_aead *tfm, const u8 *aad, u8 *nonce,
 	struct aead_request *aead_req;
 	int reqsize = sizeof(*aead_req) + crypto_aead_reqsize(tfm);
 	const __le16 *fc;
+	int ret;
 
 	if (data_len < GMAC_MIC_LEN)
 		return -EINVAL;
@@ -59,10 +60,10 @@ int ieee80211_aes_gmac(struct crypto_aead *tfm, const u8 *aad, u8 *nonce,
 	aead_request_set_crypt(aead_req, sg, sg, 0, iv);
 	aead_request_set_ad(aead_req, GMAC_AAD_LEN + data_len);
 
-	crypto_aead_encrypt(aead_req);
+	ret = crypto_aead_encrypt(aead_req);
 	kfree_sensitive(aead_req);
 
-	return 0;
+	return ret;
 }
 
 struct crypto_aead *ieee80211_aes_gmac_key_setup(const u8 key[],
-- 
2.30.1

