Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA073FD1A3
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 05:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241376AbhIADGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 23:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233556AbhIADGn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 23:06:43 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334AEC061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:05:47 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id j10-20020a17090a94ca00b00181f17b7ef7so3580252pjw.2
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=squareup.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=nyOJ9iZETVTEFk6iWhg2g1yikDtoNUIcwl8+erJ8BFY=;
        b=d1V6u3ysAEYUUAHURWSacyDQzOtUqDO+ucg+6rnhcJevnwInrzshAWGb/fRLWLMwla
         cuFmZBqSoqtR3njWqQ2qYCmhP3gd3jLtSBV4DjFpwkNu5EM4ZRupyrAVEWSw0KpM6qhv
         645zstCpXVFvmC3fyKt0XuANOdSmyUHDvepPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nyOJ9iZETVTEFk6iWhg2g1yikDtoNUIcwl8+erJ8BFY=;
        b=Whvmeff7uwue6+9MtgsA6R2GJph/EXO03siFSc33HMbNOO7aJvHPcqgSeUNfyd7cek
         wXCnsmvRBylVEAPhWPNP6WZt0Y5rQ5nm5fpouhhbTWS9qw3tEmRH6HuXtI+ml7SmBDe1
         n84KJSFqEqLB0hqpNMXuc2yXo47iFFXAmuYjjMpsdliXWG5F633HvrsOSq9jyUEOO2FE
         cz8g3qT8lzl5x9ikG4PbusF5YmOhO302Tyg3bIq3daYxllRXd/69fLwAEnBrUBdKb1qr
         44wJ6lov2a1MhqEiJWYQ9HAplRBMhVqx1NvZgni61XtWhzPoUvn/i5LlbZyjFP6Ox9L0
         bBbg==
X-Gm-Message-State: AOAM532dJPPtxUPRIHSJQhXbP6fGTpDb+/Ti+mIrALUSUkdqUxEqF7DF
        qAVxDkEBkkTrI7a0N5oQBDOntQ==
X-Google-Smtp-Source: ABdhPJwIDQ1redj58uqfaouUGUpSY5cLZfiK40nKf7S/m9qcC6EahuadQ5zCgv6Fu3HiSg47QDsp0Q==
X-Received: by 2002:a17:90a:5d12:: with SMTP id s18mr9226138pji.35.1630465546442;
        Tue, 31 Aug 2021 20:05:46 -0700 (PDT)
Received: from localhost (138-229-239-060.res.spectrum.com. [138.229.239.60])
        by smtp.gmail.com with ESMTPSA id 77sm10856219pfz.118.2021.08.31.20.05.44
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 31 Aug 2021 20:05:45 -0700 (PDT)
From:   Benjamin Li <benl@squareup.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Benjamin Li <benl@squareup.com>, stable@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] wcn36xx: handle connection loss indication
Date:   Tue, 31 Aug 2021 20:05:41 -0700
Message-Id: <20210901030542.17257-1-benl@squareup.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Firmware sends delete_sta_context_ind when it detects the AP has gone
away in STA mode. Right now the handler for that indication only handles
AP mode; fix it to also handle STA mode.

Cc: stable@vger.kernel.org
Fixes: 8def9ec46a5f ("wcn36xx: Enable firmware link monitoring")
Signed-off-by: Benjamin Li <benl@squareup.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 44 +++++++++++++++++++-------
 1 file changed, 33 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 57fa857b290b..f6bea896abe8 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2623,30 +2623,52 @@ static int wcn36xx_smd_delete_sta_context_ind(struct wcn36xx *wcn,
 					      size_t len)
 {
 	struct wcn36xx_hal_delete_sta_context_ind_msg *rsp = buf;
-	struct wcn36xx_vif *tmp;
+	struct wcn36xx_vif *vif_priv;
+	struct ieee80211_vif *vif;
+	struct ieee80211_bss_conf *bss_conf;
 	struct ieee80211_sta *sta;
+	bool found = false;
 
 	if (len != sizeof(*rsp)) {
 		wcn36xx_warn("Corrupted delete sta indication\n");
 		return -EIO;
 	}
 
-	wcn36xx_dbg(WCN36XX_DBG_HAL, "delete station indication %pM index %d\n",
-		    rsp->addr2, rsp->sta_id);
+	wcn36xx_dbg(WCN36XX_DBG_HAL,
+		    "delete station indication %pM index %d reason %d\n",
+		    rsp->addr2, rsp->sta_id, rsp->reason_code);
 
-	list_for_each_entry(tmp, &wcn->vif_list, list) {
+	list_for_each_entry(vif_priv, &wcn->vif_list, list) {
 		rcu_read_lock();
-		sta = ieee80211_find_sta(wcn36xx_priv_to_vif(tmp), rsp->addr2);
-		if (sta)
-			ieee80211_report_low_ack(sta, 0);
+		vif = wcn36xx_priv_to_vif(vif_priv);
+
+		if (vif->type == NL80211_IFTYPE_STATION) {
+			/* We could call ieee80211_find_sta too, but checking
+			 * bss_conf is clearer.
+			 */
+			bss_conf = &vif->bss_conf;
+			if (vif_priv->sta_assoc &&
+			    !memcmp(bss_conf->bssid, rsp->addr2, ETH_ALEN)) {
+				found = true;
+				wcn36xx_dbg(WCN36XX_DBG_HAL,
+					    "connection loss bss_index %d\n",
+					    vif_priv->bss_index);
+				ieee80211_connection_loss(vif);
+			}
+		} else {
+			sta = ieee80211_find_sta(vif, rsp->addr2);
+			if (sta) {
+				found = true;
+				ieee80211_report_low_ack(sta, 0);
+			}
+		}
+
 		rcu_read_unlock();
-		if (sta)
+		if (found)
 			return 0;
 	}
 
-	wcn36xx_warn("STA with addr %pM and index %d not found\n",
-		     rsp->addr2,
-		     rsp->sta_id);
+	wcn36xx_warn("BSS or STA with addr %pM not found\n", rsp->addr2);
 	return -ENOENT;
 }
 
-- 
2.17.1

