Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9C9333027
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 21:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhCIUnB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 15:43:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhCIUmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 15:42:31 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 752BFC06174A;
        Tue,  9 Mar 2021 12:42:31 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id p21so9607431pgl.12;
        Tue, 09 Mar 2021 12:42:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F6H1eLaGJlqQ66tBpb5I9uNj9GMESOoJy7m0GH1JP58=;
        b=HU3izlQAk8Mt6/FCeP8tXvAj4M+vWcnDiOFwwiJ6y6zFRu1CwFcqogAzDOLCwTjCEL
         qAXZV+VH/9XjnGRjPstDE7SJn9Bq8zB98UNwP2rapNDbbwN3werptIlYRxYS3utLPE8m
         GydBXNhKDLdtz2oF9t85xMM6gScMocSS7SFcC3w47DDRdAipUUNuTnRKyJxSvX8RPTmL
         2yrrBMOHkzompBJ7NE1phX8f3qKmyHcV3i+PWHXyxa7ZkWbEy3x6WXZvp9h1QrzrSz2n
         ky6yWI96REKN7irWvjsWjZAxaFNWSKb6+3cjWTDE1zWB/F0MuWfBhAOFTDNmquULAGpZ
         1ApA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=F6H1eLaGJlqQ66tBpb5I9uNj9GMESOoJy7m0GH1JP58=;
        b=RVXMMOE4nguA09Rm79aR59oMBTbftYngUEtbzHNiHlTNd0hMDZ76Zl3d7OIu20zmPt
         4DKKTwMxE5cU+DoQU3chk/Xay99haZl6xx5l0Lm37rDWn6XgU27yZGGst4vdowGHuK2K
         5pBhuRfktn653oIQS/wQU6groUVxUuz1JI+wtwCKeBsrSftDXFd8Xk12r4Bqkdtj/X88
         fVvDcbex2Al19w9n+kU2fgh83/AlPqkKrmOypYiHZ1NOxKXvVOSFGXY9rglqnn3VUJQF
         D/msdRLLH4NQI4+Ll7knk/Eke9fuTblQ396EpZMBvDJwmv22kIg5mlZq130lvYQL7M83
         7mow==
X-Gm-Message-State: AOAM531Djxatntfgzvj30qZJ3ssLPnNt4V2NF0lVNrLU++vHK9riVzG5
        JNmqDCLQ7BipsVOaWAapVtGg0q8dLouKMxX0
X-Google-Smtp-Source: ABdhPJyVs9xS1EYgSQPTuVJ1Eflsd1/06bOMzFrw2XXmi2tQtDVl+TncNGcEp6MAi0oeoeb6qg954w==
X-Received: by 2002:a65:4344:: with SMTP id k4mr3119724pgq.48.1615322551060;
        Tue, 09 Mar 2021 12:42:31 -0800 (PST)
Received: from panda-xps.hsd1.ca.comcast.net ([98.37.48.39])
        by smtp.googlemail.com with ESMTPSA id j3sm13298098pgk.24.2021.03.09.12.42.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 12:42:30 -0800 (PST)
From:   Daniel Phan <daniel.phan36@gmail.com>
X-Google-Original-From: Daniel Phan
Cc:     daniel.phan36@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] mac80211: Check crypto_aead_encrypt for errors
Date:   Tue,  9 Mar 2021 12:41:36 -0800
Message-Id: <20210309204137.823268-1-daniel.phan36@gmail.com>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: panda <daniel.phan36@gmail.com>

crypto_aead_encrypt returns <0 on error, so if these calls are not checked,
execution may continue with failed encrypts.  It also seems that these two
crypto_aead_encrypt calls are the only instances in the codebase that are
not checked for errors.

Signed-off-by: Daniel Phan <daniel.phan36@gmail.com>
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

