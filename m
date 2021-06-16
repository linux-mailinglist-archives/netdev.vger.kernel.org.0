Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF9AF3AA4B3
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233065AbhFPTy7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:54:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233034AbhFPTy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 15:54:57 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B452BC061767
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:52:50 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id a127so3045176pfa.10
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 12:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iu3sTRI4Ga1ervnK5tO7EMOoHzHR4xBz1C8JdNaGCVA=;
        b=HKyp4hdkNn98jyZjO/itFbTsAjuWDCJ9LdrFsnrFjPIE9O4IcaTsxVXtZQlIo0dLQ/
         cnYhJ5liNvDhcDw++oRT6Ryh/xwhamlDfmw0KAuUbL99m94k7DFRvP3qF0ipaNmMCUeD
         Bk17lIf7tMXZtYDe+4DTcsoZ6VQUi7LPkD6UM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=iu3sTRI4Ga1ervnK5tO7EMOoHzHR4xBz1C8JdNaGCVA=;
        b=gIFuw5BYEB1um4rLUNCtgP9MJP6zR0TaHizNphBSBSbJliqhBenRFoDqRDMEtXaUCg
         S3igxoqM6qGGF2qMdKOdUhr/IbJB8FnWIbKXnlYaWgcgZV2pBTN3uxfJ2lzp8Za0CAKy
         +NdojSmABgujqMw4MK0Vnweoh5/avQ3GHC5W5Q7FMSFlu9Oj4KG6rkJ0bU0RRByXu/kl
         SQmyycTtX5/ev+mXtlBUH51ErsVwrXNb7teunewYI1oIqjU9tFnoHzoFClH7r9Sgf3Qn
         ZgYnorOknjZr9SaI2OLFdbycNen28JbIL8x93iRVpq5l43h8NKMAbqM2yolvuTSkuRLI
         x6uA==
X-Gm-Message-State: AOAM532iQYOCKW7875iuYD+uYRfs+TwMf5Q5WrRbMp/kjxzXibla4ciW
        IgJtHA28MKB3T9Zn0K5DrVE7UA==
X-Google-Smtp-Source: ABdhPJyadA6K+Ch6Os/HN+T0haAfJUcovLTu6Izm91kzA5n2FE4i73pC6hOVv0wKBr8z4HI9aM1eKQ==
X-Received: by 2002:a05:6a00:b4f:b029:2e9:f6a8:46db with SMTP id p15-20020a056a000b4fb02902e9f6a846dbmr1423427pfo.26.1623873170165;
        Wed, 16 Jun 2021 12:52:50 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id p17sm6355426pjg.54.2021.06.16.12.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:52:49 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     netdev@vger.kernel.org
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
        linux-hardening@vger.kernel.org
Subject: [PATCH] mwl8k: Avoid memcpy() over-reading of ETH_SS_STATS
Date:   Wed, 16 Jun 2021 12:52:42 -0700
Message-Id: <20210616195242.1231287-1-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Patch-Hashes: v=1; h=sha256; g=b6df66ea320e2dd2f60b6aa198c92d8bf5668fd0; i=fgwr8Ir/RkDxDn1oBpfFAI0X5hxNqb8r0Q6WOlTVTWU=; m=oovpy32QOGm7F0CxLPSpC3hYkeAu+GX5CeuC6rbYRG0=; p=rNzffPVViPPasgNsA9kftAkj+3z+yfBDZn11q5PzClA=
X-Patch-Sig: m=pgp; i=keescook@chromium.org; s=0x0x8972F4DFDC6DC026; b=iQIzBAABCgAdFiEEpcP2jyKd1g9yPm4TiXL039xtwCYFAmDKVokACgkQiXL039xtwCYNRQ//Xds gObSVssEMFebWQY591nCjSvczCvbAxMhxFeUowBL+EmYCR4DnyKWS8Krfdiu251zp3xD+JDcwgC/Z 9vttzBL2ENgbAlPYgR0O1UuwWJ4z9Fl0VZGmRLlBbby/rg2mgfTJWTpp2zkrfxPL6q/YPwcgnUc0j q13dtiAcgzFC4iKqwEdKH/Jx5QFtXrSY3cefkWQyOa7vPYOfWXowV6Q67Ft6bf0LjKFSKZ/9Xje7R Cs7MALDWp5dF4OsJBiWI2KTF1azyN6HE14WW89jqBmxXHvRB8e1n7xqZvb6RwLuVnjVkwWau3LJHZ xzOIfpAd80Wk7qL46BF1szFIUO7igL8BCFU6wluUlio7hDxIzqifpbey0ZUukj30Rj8/dGSIGBiLf RAbM9LQr00fg30YQEnkMiFhV2ZFd+oVbutFX+7ANK5ZsMARomhQagbImPsFMBMe84yrVboiilW4+E qKo0mIJJCnFw+AGiDKb1pcNl4gjdUgreLkIBUpXz9kUJSdnNpNOlwQ0oSuUjy/ld+A2r5ZH251Jjo uGg7zdSPCWgCXVLadKFO/cdYympUc++xzZIPM6aH1+ZblzxJ+stFKqiyEwEy5tUuo2O0PfWeWf180 wPO4kMuZN1gvZq4oeEH8lsx80PlXSrXVnTeNmHxIzhM0XnWE0jOVxOITfmRL1UeY=
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

