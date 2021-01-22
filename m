Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99547300694
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbhAVPF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728594AbhAVPEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:04:51 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D57C061797
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 07:04:05 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id l12so5396595wry.2
        for <netdev@vger.kernel.org>; Fri, 22 Jan 2021 07:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=LELvUx+pYWTbfwYeHU46iSK2p88mAn31NLcNatv3O1g=;
        b=bD8nLp3/2VZ667guywwlsnODSj+AVYFRBhR5xPBkwiEg1LhFj5PidhXYwab9EJwErR
         pqNopIKT8waKjb+XkVZImu0PHOYCgoIToWsWPUZ3u3DBm+0ucsmWIrHCcGaPUwv1pp1g
         qE+d5vQtSY/fJZP6ivJ3kQgb6sTOCut4E1NqXsYZd1J688ljexMKdmo7pScbT5YYk1OQ
         DlwQNUUaCQ8DbyPqUMG8eIiX+9T9gCpneXVJ0bftXQGflDYcyurFg1vfFbSUDzz9T7Dq
         9D9c0LumJpQEVBxnZFTsNtMMZCyges0uqOTWxzFZSdA4SQLzptwKcqPlh5dOKmIdIq08
         453A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=LELvUx+pYWTbfwYeHU46iSK2p88mAn31NLcNatv3O1g=;
        b=HlwPGYdvcma5F8lO9NkegIpgUe+bqhgU7h0LhE2g8jkzJof8abpmXwpkKtiRRh9s8b
         NB3qQ2BgqiWC4gUXG7/gtwoGhfzeTTBik/THnpm0NvqCKfdwk2ASvumqdB/8/8LEMDng
         Bewzi7sCHvwe6fQSD3HvMn9xksH24/cppyt8C0FNLqH179LW8md/qCuTAoYRjIYXslAl
         2RS68VVr5o6k8mxfYbkHsP89G5EPeSoIoWKLA5tTZwz+oaQj23JogKFOWFdRLqDJuIwi
         3LBIRnDyYlVDgt0259IcGlI/VnyzUXIjgiUuoNWHnUQCtQzorw0QTnqk6vHMi4E8i1n9
         Ulog==
X-Gm-Message-State: AOAM531WsSabwlgAgTltQuKdQecUHylV8W/A5Ww4hZ+JzMfhvisFIr7V
        d2I6Wp08jpHDvDC9WsgThu8d3w==
X-Google-Smtp-Source: ABdhPJy1LCN9RztA0+aV/Xnz956mSfJWfgp82pWHgSir4uzZz3sw17ObkZV5mucew9y4RPP0AiN1Bw==
X-Received: by 2002:adf:df12:: with SMTP id y18mr4958864wrl.141.1611327844156;
        Fri, 22 Jan 2021 07:04:04 -0800 (PST)
Received: from localhost.localdomain ([88.122.66.28])
        by smtp.gmail.com with ESMTPSA id m82sm12074422wmf.29.2021.01.22.07.04.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Jan 2021 07:04:03 -0800 (PST)
From:   Loic Poulain <loic.poulain@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Loic Poulain <loic.poulain@linaro.org>
Subject: [PATCH] wcn36xx: del BA session on TX stop
Date:   Fri, 22 Jan 2021 16:11:44 +0100
Message-Id: <1611328304-1010-1-git-send-email-loic.poulain@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Deleting BA session was not correcly performed, causing communication
issues with APs that dynamically stop/start new BA sessions.

Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
---
 drivers/net/wireless/ath/wcn36xx/main.c | 3 ++-
 drivers/net/wireless/ath/wcn36xx/smd.c  | 4 ++--
 drivers/net/wireless/ath/wcn36xx/smd.h  | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/main.c b/drivers/net/wireless/ath/wcn36xx/main.c
index 5867bd9..afb4877 100644
--- a/drivers/net/wireless/ath/wcn36xx/main.c
+++ b/drivers/net/wireless/ath/wcn36xx/main.c
@@ -1140,7 +1140,7 @@ static int wcn36xx_ampdu_action(struct ieee80211_hw *hw,
 				       session);
 		break;
 	case IEEE80211_AMPDU_RX_STOP:
-		wcn36xx_smd_del_ba(wcn, tid, get_sta_index(vif, sta_priv));
+		wcn36xx_smd_del_ba(wcn, tid, 0, get_sta_index(vif, sta_priv));
 		break;
 	case IEEE80211_AMPDU_TX_START:
 		spin_lock_bh(&sta_priv->ampdu_lock);
@@ -1164,6 +1164,7 @@ static int wcn36xx_ampdu_action(struct ieee80211_hw *hw,
 		sta_priv->ampdu_state[tid] = WCN36XX_AMPDU_NONE;
 		spin_unlock_bh(&sta_priv->ampdu_lock);
 
+		wcn36xx_smd_del_ba(wcn, tid, 1, get_sta_index(vif, sta_priv));
 		ieee80211_stop_tx_ba_cb_irqsafe(vif, sta->addr, tid);
 		break;
 	default:
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 5445277..941fed0 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -2467,7 +2467,7 @@ int wcn36xx_smd_add_ba(struct wcn36xx *wcn, u8 session_id)
 	return ret;
 }
 
-int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 sta_index)
+int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 direction, u8 sta_index)
 {
 	struct wcn36xx_hal_del_ba_req_msg msg_body;
 	int ret;
@@ -2477,7 +2477,7 @@ int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 sta_index)
 
 	msg_body.sta_index = sta_index;
 	msg_body.tid = tid;
-	msg_body.direction = 0;
+	msg_body.direction = direction;
 	PREPARE_HAL_BUF(wcn->hal_buf, msg_body);
 
 	ret = wcn36xx_smd_send_and_wait(wcn, msg_body.header.len);
diff --git a/drivers/net/wireless/ath/wcn36xx/smd.h b/drivers/net/wireless/ath/wcn36xx/smd.h
index b1d8083..4628605 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.h
+++ b/drivers/net/wireless/ath/wcn36xx/smd.h
@@ -135,7 +135,7 @@ int wcn36xx_smd_add_ba_session(struct wcn36xx *wcn,
 		u8 direction,
 		u8 sta_index);
 int wcn36xx_smd_add_ba(struct wcn36xx *wcn, u8 session_id);
-int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 sta_index);
+int wcn36xx_smd_del_ba(struct wcn36xx *wcn, u16 tid, u8 direction, u8 sta_index);
 int wcn36xx_smd_trigger_ba(struct wcn36xx *wcn, u8 sta_index, u16 tid, u8 session_id);
 
 int wcn36xx_smd_update_cfg(struct wcn36xx *wcn, u32 cfg_id, u32 value);
-- 
2.7.4

