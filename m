Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2476F3AA9D0
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 06:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhFQEQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 00:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbhFQEQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 00:16:42 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFA8C061767
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 21:14:34 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id q25so3926184pfh.7
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 21:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jv/UoXdCMo0JEqhR4JZpjm63vYe4PkZ/uNFos3Hcr5o=;
        b=A19U7TVRICNEpmChktJUVRK/HrEPvtIYtzN7xfKOeipvKpp+3im8EJ3IUK6Rq8EGKh
         Trp0H77LSIPjae5hVTja653G6JbAQ4yEa+Wze4xtfLuUgjsKEOqkRWrSIMNVVFBm3Ai8
         /pWkJZEd8WOCd6TG1w9thVrxS60K1k9cTv55Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Jv/UoXdCMo0JEqhR4JZpjm63vYe4PkZ/uNFos3Hcr5o=;
        b=a22BKjFfjKOFcADEbJQXYw0DT5LNj1jF+8GESqTTtomTumvnYEiZDRQ3tsXt4j+tn1
         IsEeN9OZD3MV0NOE3S2O7Z4djlAt9Qm6QmrD3DLJm82Pk0wbcFGS/JWFyJ+yFIksJJIm
         FcsHqGzItQAOQOrD8BtfAOtfKxPJeUXb4ZaEBA/sUQgZDDZSsbSU718wNueAN1LIRhqp
         KUz2AMs2bxVUPSNNgPI7Gq5L8YzHT178/nTkyDim236LvOX994tKl+yqHl92uUcZP/xs
         26GWBEQ9AwKRqVQScTBE11nSBkQdaxTzayQGzQ0Kj7nb010yEmbba1+3RjSQ4ZFBxZTX
         q2qA==
X-Gm-Message-State: AOAM532c7wdvNiM/M6nsctBkthpp5Zo3bsIvLK/2DAIdVIVx5W7Bjaie
        wRsnUDS433F0JJFC75/gLSTW7Q==
X-Google-Smtp-Source: ABdhPJw8tzkSj/rTqVQg03PC/E2Lugi3OxWCfRjtrX4eg6F5WqfQzvg5sKcxtCUCMbHJSeH4wxR/uQ==
X-Received: by 2002:a63:6884:: with SMTP id d126mr3113715pgc.368.1623903274133;
        Wed, 16 Jun 2021 21:14:34 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a25sm3473251pff.54.2021.06.16.21.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 21:14:33 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Kees Cook <keescook@chromium.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <allen.lkml@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        wengjianfeng <wengjianfeng@yulong.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: [PATCH v2] mwl8k: Avoid memcpy() over-reading of mcs.rx_mask
Date:   Wed, 16 Jun 2021 21:14:31 -0700
Message-Id: <20210617041431.2168953-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=b6df66ea320e2dd2f60b6aa198c92d8bf5668fd0; i=3LMRMQs/su+jg96J7A+W2izaO7vn5zDULMuljW/1kps=; m=oovpy32QOGm7F0CxLPSpC3hYkeAu+GX5CeuC6rbYRG0=; p=rNzffPVViPPasgNsA9kftAkj+3z+yfBDZn11q5PzClA=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDKzCcACgkQiXL039xtwCZW3hAAhyN bQVuYyNMdKH9LEZ4myTR8iuC9+GZl30h8ohltamC4kXQh/K/yjtqOGYQESCKYKuEZrnc6J2aCoYo0 HcW79pA7w1zWsXHX2yctOTFVNJ4JuAZB3n043WD2MfdkpIv6SE4B7eb0V5rSZIafL3reFm/eTQQkI p32VtKk/W7oiSmuU7ZeDMFjUfE+Hn9aVFJXvlw8MzDSOXL/syftnpzzuw8faYJnvKp4wowXmfszqH 4WdoHnt6QvpmRYCgBv9MuFY1USZp1Sv62fFPw9jJTozB97ALW83iqjjqug0n60ItP/DAQVCMKE86A N4yq4boVdQgbYO2P0ompG7Lm5GgX09P9vdx/aYotUD3srUQRMWH6vLRlZuqMsNSY7pHOCujgeYIWH xuathey5Ui74bk+dWEAJcxfgkYaQAo4dH/nWUBULfLS3rTRyctGxwDe/wukSxSqULgXm1uK6uzr3C bRWk5cNoEmKW6dBdLEYXjmnppbQxe5KL0u4AMqeKpoKh/kaIuFsroMoFvFH033DL4F3LH7Z5H38Uz YuIv9TZbZMUUtVMJMDtFP3/QMGpTDJpKx8mNjzROArMuT4JPLrjlNkWJHYuZAYsXzD+1SOZn2D09j 2hnLN4E6zKYo1n9az/q7mdEWRbt2/slqjQ7VmBrGPF4kp6Ow3ofaFXuEDwfT63+E=
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally reading across neighboring array fields. Use the
sub-structure address directly.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2: fix Subject for actual issue
v1: https://lore.kernel.org/lkml/20210616195242.1231287-1-keescook@chromium.org
---
 drivers/net/wireless/marvell/mwl8k.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 84b32a5f01ee..3bf6571f4149 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -4552,7 +4552,7 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
 	else
 		rates = sta->supp_rates[NL80211_BAND_5GHZ] << 5;
 	legacy_rate_mask_to_array(p->legacy_rates, rates);
-	memcpy(p->ht_rates, sta->ht_cap.mcs.rx_mask, 16);
+	memcpy(p->ht_rates, &sta->ht_cap.mcs, 16);
 	p->interop = 1;
 	p->amsdu_enabled = 0;
 
@@ -5034,7 +5034,7 @@ mwl8k_bss_info_changed_sta(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			ap_legacy_rates =
 				ap->supp_rates[NL80211_BAND_5GHZ] << 5;
 		}
-		memcpy(ap_mcs_rates, ap->ht_cap.mcs.rx_mask, 16);
+		memcpy(ap_mcs_rates, &ap->ht_cap.mcs, 16);
 
 		rcu_read_unlock();
 
-- 
2.25.1

