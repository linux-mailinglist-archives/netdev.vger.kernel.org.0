Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223AA658A05
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 08:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiL2HjL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 02:39:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbiL2HjA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 02:39:00 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E154BCA0;
        Wed, 28 Dec 2022 23:38:59 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id d10so11893559pgm.13;
        Wed, 28 Dec 2022 23:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=FQszMWeXFPAfmDJi4sx+8Hf/q+9+cLOONIJyAQ7Rc8E=;
        b=V2xfjPRuzPwskYbvlUUr5aTd84JZ1LVV8WNm9c/hLcgcMTOQqDEmf8KlhkO8wRck8q
         AwhjEutQlv3Uu+uLoV8+F2CdXQxG1aEqg+4tFI5ne2UxiLYPyrKfZGG5Z0Fejw6sUE/c
         1z5m3FS2I7M027yFST77lTeTNNUJe3Eu/Lwly2fDXd9jbZzdr+k11oMRATpYktv22ZlK
         RUOoDlclkWU+nzDMp1a0cGTBV0krvCVw+oTF7F5E+LGQ5PKbIxA7GqZ5b9l60E4TwNHD
         9WDAQxQXQ4vCXENwZ+smJsrRNNjosZCCnaqalIobNRcricZjpcMiFcxNAMwokSJfySjD
         oKBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FQszMWeXFPAfmDJi4sx+8Hf/q+9+cLOONIJyAQ7Rc8E=;
        b=EXW/y3gVy4wQYo59zG0V0PWw9RyFWJBwHNaWkZGNNohy+deHYkpdTKUWPw8ecoEQWb
         XP4osVbdV6J/i5k7gtopbdAKIPHuOcXSWrftMhkHpZQsHA1QEo5aPQkNuZlVZCrxN+r2
         Bm/fWNl6LzprRM2LM/LD21qV+lOsj01SiIXbJSix4XMwlwyAhk0CoJ1n7k7+ihALYbdz
         nu2SQxpqrkog2H3P3vQidB+g7iyb0X2mmwor0NL69B+YTDiG5hh2C/axMiER7gMlY0oM
         Yfy2MDDVc81UvonJumG2HZEaNGKEz5/p/rtJuSTrkI6lB+n7O3Qs0x2HoSdbycLiajor
         7nog==
X-Gm-Message-State: AFqh2krpbCUONH+Dp2MweduH+5s1uwlAx62w2zsT6KYjQTXUdOqyJkjM
        hKpwgYXTVmuGGMh6hvgLuz0=
X-Google-Smtp-Source: AMrXdXvPDVBuXn3kzD5VMsb/0gEzdxL2d7QvYlr8LvCQGlr86hiYvkno2m/X49UBYdfgCoiuK7KsTA==
X-Received: by 2002:aa7:8502:0:b0:576:a500:2c7c with SMTP id v2-20020aa78502000000b00576a5002c7cmr45101601pfn.27.1672299538685;
        Wed, 28 Dec 2022 23:38:58 -0800 (PST)
Received: from localhost.localdomain ([202.120.234.246])
        by smtp.googlemail.com with ESMTPSA id y17-20020a626411000000b00575b6d7c458sm11401168pfb.21.2022.12.28.23.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Dec 2022 23:38:58 -0800 (PST)
From:   Miaoqian Lin <linmq006@gmail.com>
To:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     linmq006@gmail.com
Subject: [PATCH] wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup
Date:   Thu, 29 Dec 2022 11:38:48 +0400
Message-Id: <20221229073849.1388315-1-linmq006@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

crypto_alloc_shash() allocates resources, which should be released by
crypto_free_shash(). When ath11k_peer_find() fails, there has memory
leak. Move crypto_alloc_shash() after ath11k_peer_find() to fix this.

Fixes: 243874c64c81 ("ath11k: handle RX fragments")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
---
 drivers/net/wireless/ath/ath11k/dp_rx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index c5a4c34d7749..1297caa2b09a 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -3116,10 +3116,6 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
 	struct dp_rx_tid *rx_tid;
 	int i;
 
-	tfm = crypto_alloc_shash("michael_mic", 0, 0);
-	if (IS_ERR(tfm))
-		return PTR_ERR(tfm);
-
 	spin_lock_bh(&ab->base_lock);
 
 	peer = ath11k_peer_find(ab, vdev_id, peer_mac);
@@ -3129,6 +3125,10 @@ int ath11k_peer_rx_frag_setup(struct ath11k *ar, const u8 *peer_mac, int vdev_id
 		return -ENOENT;
 	}
 
+	tfm = crypto_alloc_shash("michael_mic", 0, 0);
+	if (IS_ERR(tfm))
+		return PTR_ERR(tfm);
+
 	for (i = 0; i <= IEEE80211_NUM_TIDS; i++) {
 		rx_tid = &peer->rx_tid[i];
 		rx_tid->ab = ab;
-- 
2.25.1

