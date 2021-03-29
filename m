Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF8634DA64
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 00:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbhC2WWe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 18:22:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:45898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231929AbhC2WVw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 18:21:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BAFF461985;
        Mon, 29 Mar 2021 22:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617056511;
        bh=+EAdA/8I5+/z6wMH3rsiEpkHVN/+l0GcA0oJ/SB9EcI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMMRrVad+ic8AnCVtA/x3RTDd09cVzA/f+AAFa3QyhTwwHgHumksiwd+TbohhXq1i
         Lyz1vgs0hcvUCMntGCqbIi4rqTt75k+dtCEfacL+bhFXNCKeJr3VL0UYkUGUe5fly8
         TCEoqorkSGgWplcmL48MJQx4o3miGGLyatHlTX1jlQuKe6KDWghmoELhONdeDVsnbY
         xgs9/apZ+P9HOaAVPN1KNvm6nj6ERuIXf80KtjOLxNC7QbWmb+dsbUMTznkSBHSLyd
         0XIMyeE/5iL1TzXD6TBeGT8RpCmjsbH5gkm4QspBowNU/2cD5Luxbzi9/vdrdS2o5Q
         6583XuKbZDOfA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Phan <daniel.phan36@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 14/38] mac80211: Check crypto_aead_encrypt for errors
Date:   Mon, 29 Mar 2021 18:21:09 -0400
Message-Id: <20210329222133.2382393-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329222133.2382393-1-sashal@kernel.org>
References: <20210329222133.2382393-1-sashal@kernel.org>
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

