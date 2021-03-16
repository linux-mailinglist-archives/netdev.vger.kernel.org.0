Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B597633DD91
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 20:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhCPTbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 15:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237110AbhCPTbA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 15:31:00 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1CBC061756
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 12:30:59 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v14so16361984pgq.2
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 12:30:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pLdF7zoGUozqAe1+lMlJqQTbxjR6BOgEH8RjV/EprUs=;
        b=S9byXezpGreH4LtkD9u2ztQy1B8C65vjJLVCFOyWBRglz6j8bvwRfaqnDF29WvAy3q
         FRZxA2UFRBEZ2IDi5SIXjU1ZulqieQZDIBsglTXcYK/l7R2LO7f/sbUBtydFhnsavsMu
         RKScPGQrJ8kce0XWvyAsS9Xv4hCkT1IQNrz94=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pLdF7zoGUozqAe1+lMlJqQTbxjR6BOgEH8RjV/EprUs=;
        b=CzfBfJbLlEZ0xF5zYkLNlIqevuUKDyYwEXgvL8y2OKizTcMLagRp5lyA3ouOEQEctG
         Vg2hYyBTtJ5uauIIOt/xH4/Yo3dJyO02VUw89DSk3CmZ/ONj30LgHlNhk0N0jX4CrCb6
         KzVnr5YiE/qAE+6qrTDgpW+W1E/qIVMTTiOJSE38HV9eP54H4rnY01/p0thSne4BfNn0
         ErjDu7/kUoTHvNieNG35W+3CpzaqFFxkuvbFaowg+MrGLJjhaLSOFVMH79V2cU7vgF9O
         cQUq2qu7OzRPwUsWTDBh7PHLQfI0Giy73FPrkXTUL6r7TAflw8nOFlF1hIuTcOvnM8YO
         2fyw==
X-Gm-Message-State: AOAM533A9tIA2772G6ussWIyIGClrtpRg0K08sEIUEptM4of6KqiTsuY
        7z6r7g7xGvoGLe+QUv/y+Hb1/w==
X-Google-Smtp-Source: ABdhPJyEfD5qyUJpXMnmRwF8LdnvbWjp80VfMkefbF3lX/KgC03qypJ+fvZnPJ5Q4ek1QE9pAW0Wnw==
X-Received: by 2002:a05:6a00:1390:b029:20a:5a18:ad0f with SMTP id t16-20020a056a001390b029020a5a18ad0fmr886287pfg.66.1615923058874;
        Tue, 16 Mar 2021 12:30:58 -0700 (PDT)
Received: from kuabhs-cdev.c.googlers.com.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id d6sm17097605pfq.109.2021.03.16.12.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 12:30:58 -0700 (PDT)
From:   Abhishek Kumar <kuabhs@chromium.org>
To:     johannes@sipsolutions.net
Cc:     kuabhs@chromium.org, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        briannorris@chromium.org, linux-wireless@vger.kernel.org
Subject: [PATCH] net: wireless: search and hold bss in cfg80211_connect_done
Date:   Tue, 16 Mar 2021 19:29:58 +0000
Message-Id: <20210316192919.1.I26d48d8a4d06ef9bd2b57f857c58ae681cc33783@changeid>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If BSS instance is not provided in __cfg80211_connect_result then
a get bss is performed. This can return NULL if the BSS for the
given SSID is expired due to delayed scheduling of connect result event
in rdev->event_work. This can cause WARN_ON(!cr->bss) in
__cfg80211_connect_result to be triggered and cause cascading
failures. To mitigate this, initiate a get bss call in
cfg80211_connect_done itself and hold it to ensure that the BSS
instance does not get expired.

Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
---

 net/wireless/sme.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 07756ca5e3b5..52f65991accd 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -724,15 +724,8 @@ void __cfg80211_connect_result(struct net_device *dev,
 	}
 #endif
 
-	if (!cr->bss && (cr->status == WLAN_STATUS_SUCCESS)) {
+	if (cr->status == WLAN_STATUS_SUCCESS)
 		WARN_ON_ONCE(!wiphy_to_rdev(wdev->wiphy)->ops->connect);
-		cr->bss = cfg80211_get_bss(wdev->wiphy, NULL, cr->bssid,
-					   wdev->ssid, wdev->ssid_len,
-					   wdev->conn_bss_type,
-					   IEEE80211_PRIVACY_ANY);
-		if (cr->bss)
-			cfg80211_hold_bss(bss_from_pub(cr->bss));
-	}
 
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
@@ -882,6 +875,18 @@ void cfg80211_connect_done(struct net_device *dev,
 	ev->cr.fils.update_erp_next_seq_num = params->fils.update_erp_next_seq_num;
 	if (params->fils.update_erp_next_seq_num)
 		ev->cr.fils.erp_next_seq_num = params->fils.erp_next_seq_num;
+
+	/* Acquire and hold the bss if bss is not provided in argument.
+	 * This ensures that the BSS does not get expired if the schedule
+	 * of the rdev->event_work gets delayed.
+	 */
+	if (!params->bss && params->bssid)
+		params->bss = cfg80211_get_bss(wdev->wiphy, NULL,
+					       params->bssid,
+					       wdev->ssid, wdev->ssid_len,
+					       wdev->conn_bss_type,
+					       IEEE80211_PRIVACY_ANY);
+
 	if (params->bss)
 		cfg80211_hold_bss(bss_from_pub(params->bss));
 	ev->cr.bss = params->bss;
-- 
2.31.0.rc2.261.g7f71774620-goog

