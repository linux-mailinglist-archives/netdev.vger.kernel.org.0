Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A407845627D
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 19:37:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbhKRSkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 13:40:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233534AbhKRSkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 13:40:03 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2D4C06173E
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:37:03 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id r132so6173064pgr.9
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 10:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I6ekFruXY8lIGWMZf7qN4Eac7dnlFefcLU1TGeXa9yM=;
        b=gJLgEWs+Zlxn2gM0+aDb+bKNKLBRoNNPjxLi7lFzkT7wgTne7zM6N0Gjhq9+TS1Cwc
         v/rpdCxqwHu0Ag4RH7rvtlto8WZv97NSmelcmcJwcWOlDafFoUZgOarsrlyaZ93Suwqt
         9Htu7I3mRILBezuYT9HkfN02VUgJjGpOehSAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=I6ekFruXY8lIGWMZf7qN4Eac7dnlFefcLU1TGeXa9yM=;
        b=JYruC/hr2pTzEKUfa9qNb15XRsowFJi0B+2XWFQnHC4nM8ePk8a7NIbklbzxlLAWl8
         qXR40YJT39pceZeVI1qhUzV/dsjXu8Lk1B3pBLPQFrV+w3Bmr7am24p9K5VFPWbPw2FT
         MzmTSxQDVCoHDrSiMrxJxuEXSdINchQEVVSXHHu53BtpbcHxethV70jIA2bC9Jcy3O64
         3hURKcbor8I0LymzfWN2AXQ/oP/zgI6hUjzUy8J4GdNLvduNcj4NnPEWlX4aeeqRnWUO
         0Itdk9ju8oy+PpWDEuxkUXGOsOAqaYXjouLs86hAnOoTrRIC+cM1elvLBAdTgUj0rkhp
         2j6w==
X-Gm-Message-State: AOAM531igIW16z7nb0OSVX7kXIU9CmBbiZ6dR7R48JhIG7F5oTq2ASfD
        UDRvSISdAKBu1+ZBl+zuMo2dQg==
X-Google-Smtp-Source: ABdhPJzzX6LgYiNnK8E4rzvPKJ5+yOssBccHjMbdhcFJWJuCQVTJuj3TQkAK7c6s2XKuTy2yHjdOoQ==
X-Received: by 2002:a05:6a00:b8b:b0:481:16a1:abff with SMTP id g11-20020a056a000b8b00b0048116a1abffmr56701013pfj.77.1637260622973;
        Thu, 18 Nov 2021 10:37:02 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id k1sm351727pfu.31.2021.11.18.10.37.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 10:37:02 -0800 (PST)
From:   Kees Cook <keescook@chromium.org>
To:     Lennert Buytenhek <buytenh@wantstofly.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        wengjianfeng <wengjianfeng@yulong.com>,
        Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Arnd Bergmann <arnd@arndb.de>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Allen Pais <allen.lkml@gmail.com>,
        Zheyu Ma <zheyuma97@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] mwl8k: Use struct_group() for memcpy() region
Date:   Thu, 18 Nov 2021 10:37:00 -0800
Message-Id: <20211118183700.1282181-1-keescook@chromium.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1790; h=from:subject; bh=pzNRqDVpvV2z7OSqkh40SqtMHCZaHfw6BUnOrjqD3ok=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBhlp1MoXUKlRNJ2Va9QhfbHWCZM97MCpgyZRG7sa4a gcAMI0CJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCYZadTAAKCRCJcvTf3G3AJrEdD/ 9szoKPL4TNkI7MCnaUDs+vUC7t0ifVLSvFCwSas7OesnDVh2+0TcejTJ92CxnB35CT6uzlD+F1j2pW ugYEujJznsKTV/5RNeJyAyJURA3b/aN/VUEjiCvIYT30i9rcvOIsjYHL7KrPjdrNKviHXOU/3ba1yt LcmZjAmU+X/z2TAfERAYnfG14FsQ/w2fb7tjKU9cHlFNG8rHZ6ieLF86zb04ZQP2N0rHe8YC09D+Gb I++Vk4XnBIWArniQAY6CFCHqanT0vHPgY5LJV9561stIwp4IHTUpcdH/c3zW/G8hbuR4XRC3AHMxbg iIqR1E0N1vnKbuxnFMx+kEZKmyYm97ilZDTe1YqHKV419xakd7F+DPk/I2KrVXGq2SdzhfMmAm1v4/ 1Nevfj/bU29tfwKGP38DGlIaiwPD3oz1vo6Z3EyIJ2fnCIPcFLOC7t7MSYFX+BWe46Nc/U0UtOR60B Zq/ebv1TDelHv307coOwZXjpLUSDuATiTWc4HdIdEbEMUTK3Em5fxRBWYcHCYH9/iVrtBo+0o7nY4n ITWVCeY5Fxf/0NqVoeSZAgWYmxrvs49BTdOSwPJr9pdU1qqAO/++21Y66pvpqUmeI8qgPVRfcQisbk /IwsVCExARys8Nk0p0J+B8xi2/gf60f2UboM0YL3g+sz3n6F5sa6X5amp04w==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In preparation for FORTIFY_SOURCE performing compile-time and run-time
field bounds checking for memcpy(), memmove(), and memset(), avoid
intentionally writing across neighboring fields.

Use struct_group() in struct mwl8k_cmd_set_key around members
key_material, tkip_tx_mic_key, and tkip_rx_mic_key so they can be
referenced together. This will allow memcpy() and sizeof() to more easily
reason about sizes, improve readability, and avoid future warnings about
writing beyond the end of key_material.

"pahole" shows no size nor member offset changes to struct
mwl8k_cmd_set_key. "objdump -d" shows no object code changes.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/net/wireless/marvell/mwl8k.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 529e325498cd..90e881655fb2 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -4225,9 +4225,11 @@ struct mwl8k_cmd_set_key {
 	__le32 key_info;
 	__le32 key_id;
 	__le16 key_len;
-	__u8 key_material[MAX_ENCR_KEY_LENGTH];
-	__u8 tkip_tx_mic_key[MIC_KEY_LENGTH];
-	__u8 tkip_rx_mic_key[MIC_KEY_LENGTH];
+	struct {
+			__u8 key_material[MAX_ENCR_KEY_LENGTH];
+			__u8 tkip_tx_mic_key[MIC_KEY_LENGTH];
+			__u8 tkip_rx_mic_key[MIC_KEY_LENGTH];
+	} tkip;
 	__le16 tkip_rsc_low;
 	__le32 tkip_rsc_high;
 	__le16 tkip_tsc_low;
@@ -4375,7 +4377,7 @@ static int mwl8k_cmd_encryption_set_key(struct ieee80211_hw *hw,
 		goto done;
 	}
 
-	memcpy(cmd->key_material, key->key, keymlen);
+	memcpy(&cmd->tkip, key->key, keymlen);
 	cmd->action = cpu_to_le32(action);
 
 	rc = mwl8k_post_pervif_cmd(hw, vif, &cmd->header);
-- 
2.30.2

