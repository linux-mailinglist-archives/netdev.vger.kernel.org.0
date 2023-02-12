Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC7D6936E2
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 11:47:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBLKrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 05:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBLKrG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 05:47:06 -0500
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ED421258E;
        Sun, 12 Feb 2023 02:47:04 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id h7so1113488pfc.11;
        Sun, 12 Feb 2023 02:47:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=tDo5pgx/OfvXIokYR8JQqZEUKv5D/UwKCkaA+DYOBog=;
        b=P46EK8t3TRWQ0oqsTFAnlB66JzxAdZtEOJRi6MXPmaau62zvRq0hdoJcH6qFPEkhKS
         sFgbw+5ARSbuZfR9ciwf2s9U8T+YYn+rXhA6TRk8salILbsFiU35QdPW8mx4ksEDpr4e
         Qr0fHOkckhEhYdHTmTalSa66+CxnKa+wL/4yyPkXYJaUw1nRLvgrPWyn6G+c1fY0wkwJ
         l7QvPbvAANVxDZT9OKPxVgySBDoCQ7dtEFhcm506acytzmQ4ajxb9gAD3oehUJvYUfel
         +10tBKY09FJKljH/WhZTG0DGHTcE1CJQ3e7s0uUXBVjrdQDXJoYSnjvQYMAeeIufqltt
         PmiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tDo5pgx/OfvXIokYR8JQqZEUKv5D/UwKCkaA+DYOBog=;
        b=4M6s09awaiqf217cF910e1H91x1ICoz5vfJVl1H5u6L1eGmrqrdlayF5IbTbdiLKvP
         B9I3HuUQdHQ7720pWh0hhFUFXultMiVI7qsxpOAT7E3gwhZ/odlcNU9aGX2tyRKLIEKV
         J2LpNZovbPg+21C5KCnCd353PcynXvUPu7utHRAocS/EJtY6PQPtB5ufVRXnteJb4CYv
         wshW0/r79MQ5J5sEThKqHX85N9XBHWyjpvqYCRJKfZRnswpEhY0iz1cfsgCxBnkOXqev
         G0+axF6/iYMvIAdVFmk5LPvVnEHJWR1f1O4M+ME2d+r2I+80JiHIPNNM5NqYZgZ3qY/C
         to2g==
X-Gm-Message-State: AO0yUKXoAjWXsJ8Sfrq2yoCroIJEccWHzIw5SgZjMov6RKVRlHS/vadQ
        MHpCvsIWDu0Lu9x/6wXkm/XkEPetqkFk3LWgNBxl
X-Google-Smtp-Source: AK7set/hqBZemug4Uo1kJje10GaWLuP5/qC79UN+vkvo2IqmEfMgX/OISQVTIX05xBYSS2J2OnRW/g==
X-Received: by 2002:a62:485:0:b0:5a8:52d5:3bc6 with SMTP id 127-20020a620485000000b005a852d53bc6mr9100259pfe.26.1676198824027;
        Sun, 12 Feb 2023 02:47:04 -0800 (PST)
Received: from 8888.icu ([165.154.226.86])
        by smtp.googlemail.com with ESMTPSA id m26-20020aa78a1a000000b0058dbd7a5e0esm5969512pfa.89.2023.02.12.02.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 02:47:03 -0800 (PST)
From:   Lu jicong <jiconglu58@gmail.com>
To:     pkshih@realtek.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lu jicong <jiconglu58@gmail.com>
Subject: [PATCH] rtlwifi: reduce duplicate decision
Date:   Sun, 12 Feb 2023 10:46:40 +0000
Message-Id: <20230212104640.2018995-1-jiconglu58@gmail.com>
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

This return can go in previous decision.

Signed-off-by: Lu jicong <jiconglu58@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/efuse.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/efuse.c b/drivers/net/wireless/realtek/rtlwifi/efuse.c
index 2e945554ed6d..70c4e22fc426 100644
--- a/drivers/net/wireless/realtek/rtlwifi/efuse.c
+++ b/drivers/net/wireless/realtek/rtlwifi/efuse.c
@@ -1243,14 +1243,12 @@ int rtl_get_hwinfo(struct ieee80211_hw *hw, struct rtl_priv *rtlpriv,
 		rtl_dbg(rtlpriv, COMP_ERR, DBG_WARNING,
 			"EEPROM ID(%#x) is invalid!!\n", eeprom_id);
 		rtlefuse->autoload_failflag = true;
+		return 1;
 	} else {
 		rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD, "Autoload OK\n");
 		rtlefuse->autoload_failflag = false;
 	}
 
-	if (rtlefuse->autoload_failflag)
-		return 1;
-
 	rtlefuse->eeprom_vid = *(u16 *)&hwinfo[params[1]];
 	rtlefuse->eeprom_did = *(u16 *)&hwinfo[params[2]];
 	rtlefuse->eeprom_svid = *(u16 *)&hwinfo[params[3]];
-- 
2.30.2

