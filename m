Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470503CC658
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 22:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236220AbhGQUoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 16:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235625AbhGQUoS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 16:44:18 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF85C061765;
        Sat, 17 Jul 2021 13:41:17 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id l6so7879182wmq.0;
        Sat, 17 Jul 2021 13:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x+Od9A6k+Mx3oOsy+sHLyJqYPR0woYwsH4hDTgPiCu4=;
        b=ixN4prt3eNJpDmPoxtWXzP5O/6zEOsVyObd2lNpRe21XGp2P2g9HFHzGghz2jAzQrD
         zAHG/n0DHWHi4u2hUTQorjYgtSCG8H8E0JMpt14c6NC6wt1gQLzwSp/nb/OqlTsycxlw
         ZOFOVH/zsuzdmu/M0U/EHzbi6eQJ/Yz4MR1XaW8qv9j2F8jjt3FlOqYHGSvpnReJwt8p
         BlfRGk+8fhjwmoVqfVpYhXWElJSkAaQdJLw/Y2SXiIiptUprqXLWK08tigzIokT3VUDU
         PJACRweHK4Q1KXbTW44ZLzKMgDX2l9QLRqw2e8hxUitft9lkRgEhNqjn4MoYhm3mSxQ2
         DHKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x+Od9A6k+Mx3oOsy+sHLyJqYPR0woYwsH4hDTgPiCu4=;
        b=gJp/zpdDxF9gR8zg4qfQtzYxbYUq7K1W8hrZ6XhzkCXNGsjr5b0xkTNbaM3TCAUxkm
         l/34m932nKVEK1CAiIXu59MciEgq2BMu0OdhUAWM+Y9Q4K8NWUQj2sf2UiuGNbZ5YMpd
         UoDUm1Z0SOsS45y0jEecPHcUTKxZm7y2sIKMKo2Dd4P6MwpMI+Wv74WGi3OjauvO5GqD
         7GqTGLCkLHpNZWTZEFzvOzLUcp4KkrBxrj1cBpayHNmt0aPlfgGBKoboWqPBnVGBX7vc
         NkoRLQCNGecUSjfq//MuPv8a/kmBCkOAMKl9v8AJDwgK1F4D4ULfv93dI39Jmucfhalq
         4w7A==
X-Gm-Message-State: AOAM530fUDNfsnPA2rERlxPxAdX5tgM9/P1NmpE5rc+lv25Ylgmi+a9Q
        WCw+75jide1CtgP5l6Vh/xdjUXEDalc=
X-Google-Smtp-Source: ABdhPJzueVEA9BIVnzs7TNWEnkDDpPoK5NYiOKp4BBh+CURWQw6f+dQ2x8Lp+wiXIMfRN4/1y6vjeQ==
X-Received: by 2002:a05:600c:214a:: with SMTP id v10mr22951878wml.17.1626554475512;
        Sat, 17 Jul 2021 13:41:15 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a01-0c22-7602-4e00-f22f-74ff-fe21-0725.c22.pool.telefonica.de. [2a01:c22:7602:4e00:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id n7sm14078357wmq.37.2021.07.17.13.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 13:41:15 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH RFC v1 5/7] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
Date:   Sat, 17 Jul 2021 22:40:55 +0200
Message-Id: <20210717204057.67495-6-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming SDIO support may sleep in the read/write handlers. Configure
the chip's BFEE configuration set from rtw_bf_assoc() outside the
rcu_read_lock section to prevent a "scheduling while atomic" issue.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
 drivers/net/wireless/realtek/rtw88/bf.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/bf.c b/drivers/net/wireless/realtek/rtw88/bf.c
index aff70e4ae028..06034d5d6f6c 100644
--- a/drivers/net/wireless/realtek/rtw88/bf.c
+++ b/drivers/net/wireless/realtek/rtw88/bf.c
@@ -39,6 +39,7 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 	struct ieee80211_sta_vht_cap *vht_cap;
 	struct ieee80211_sta_vht_cap *ic_vht_cap;
 	const u8 *bssid = bss_conf->bssid;
+	bool config_bfee = false;
 	u32 sound_dim;
 	u8 i;
 
@@ -70,7 +71,7 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 		bfee->aid = bss_conf->aid;
 		bfinfo->bfer_mu_cnt++;
 
-		rtw_chip_config_bfee(rtwdev, rtwvif, bfee, true);
+		config_bfee = true;
 	} else if ((ic_vht_cap->cap & IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE) &&
 		   (vht_cap->cap & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)) {
 		if (bfinfo->bfer_su_cnt >= chip->bfer_su_max_num) {
@@ -96,11 +97,14 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 			}
 		}
 
-		rtw_chip_config_bfee(rtwdev, rtwvif, bfee, true);
+		config_bfee = true;
 	}
 
 out_unlock:
 	rcu_read_unlock();
+
+	if (config_bfee)
+		rtw_chip_config_bfee(rtwdev, rtwvif, bfee, true);
 }
 
 void rtw_bf_init_bfer_entry_mu(struct rtw_dev *rtwdev,
-- 
2.32.0

