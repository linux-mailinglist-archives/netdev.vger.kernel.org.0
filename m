Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60CEF480D3E
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 22:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237428AbhL1VP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 16:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236376AbhL1VP1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 16:15:27 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74116C061574;
        Tue, 28 Dec 2021 13:15:26 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id q16so40557879wrg.7;
        Tue, 28 Dec 2021 13:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uIrP2V3/ZBuZPe9ZMsaO5hiYD46qBHOPt+3lPFmmUuA=;
        b=pJCRkkW62ApgvhxiKl1PtR5fvAWmq2oDJ7s3aZ3BfcliOSzz1LpSSGGfXZayz+6Ba4
         za8f1nba4kJ5Y4F2LJiCKgx08rQa7qbOtwXyw+nxbMdzEEFh653P4PeJp0wZlKIQV0Kh
         pbqtj6/OQbmhHo4V/sYjxBfzwl64oUv8EXENbMD+PNxTLqOzW8GWuPb3acp5Z8XId57f
         TcsOZONriTFN1to2puCt+CASj4ryGwsuMAZn3oZiyNiod5xtzWWj+Y1kHOn3Xkcz4LaZ
         OePdjIL1oqUUyazRBKBqZOZE1xFl+xh65NV1bW2SRkTnSLgW/jO62BR9k/z4Dc+R1XH0
         rzpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uIrP2V3/ZBuZPe9ZMsaO5hiYD46qBHOPt+3lPFmmUuA=;
        b=p3KVn+knPBO2bJBwKGHSKIyY7IypJ4Bc1GXdUujOPt+GVrtpiNVGgtvJP1iowe0U2u
         WuQK//Gla/H1QXd5l2p4603w42WFDz8Nk7MccNIT7+d/zec9zAgQeV4KQqDW22Bn/kdA
         KeuMjHn3QBJ33neSK3j+FLnMobFThXNIfKYaQZL77x1pI0g+AyGzqYEdLwETkLooCdLS
         F6kqmJWl0bIvYjBDZee5eXwoln/i6DcdHreGPXTN/qcazShWt/q4dlVw4YeDi4/39pkT
         QNhIJ0nRV2jB+MIkGfuzDAUu0Lq5hC77TZRxHCKhG7E5txPzaWwk7h3qKW1sbMJHGFv5
         9THQ==
X-Gm-Message-State: AOAM531Y+T7NGGscOagQQOnHEUfpfVJvu9skmVjIEBsr5syUBy+mhzNB
        uJ6e8Ij0czKxJrKgOMsLyFFdt5vk7mk=
X-Google-Smtp-Source: ABdhPJwf8efFb+QBvAFvwEHTTSB1/UF4Hqx2PmMBX4ydD9WYY5ERIchkafwpkrBENp5q89Okd0Zung==
X-Received: by 2002:adf:ee0d:: with SMTP id y13mr18440905wrn.427.1640726124798;
        Tue, 28 Dec 2021 13:15:24 -0800 (PST)
Received: from localhost.localdomain (dynamic-2a01-0c23-c1d2-d400-f22f-74ff-fe21-0725.c23.pool.telefonica.de. [2a01:c23:c1d2:d400:f22f:74ff:fe21:725])
        by smtp.googlemail.com with ESMTPSA id o11sm21939036wmq.15.2021.12.28.13.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 13:15:24 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 7/9] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
Date:   Tue, 28 Dec 2021 22:14:59 +0100
Message-Id: <20211228211501.468981-8-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
References: <20211228211501.468981-1-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Upcoming SDIO support may sleep in the read/write handlers. Shrink the
RCU critical section so it only cover the ieee80211_find_sta() call and
finding the ic_vht_cap/vht_cap based on the found station. This moves
the chip's BFEE configuration outside the rcu_read_lock section and thus
prevent a "scheduling while atomic" issue when accessing the registers
using an SDIO card.

Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
---
v1 -> v2:
- shrink the critical section as suggested by Ping-Ke

 drivers/net/wireless/realtek/rtw88/bf.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/bf.c b/drivers/net/wireless/realtek/rtw88/bf.c
index df750b3a35e9..792eb9930269 100644
--- a/drivers/net/wireless/realtek/rtw88/bf.c
+++ b/drivers/net/wireless/realtek/rtw88/bf.c
@@ -49,19 +49,23 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 
 	sta = ieee80211_find_sta(vif, bssid);
 	if (!sta) {
+		rcu_read_unlock();
+
 		rtw_warn(rtwdev, "failed to find station entry for bss %pM\n",
 			 bssid);
-		goto out_unlock;
+		return;
 	}
 
 	ic_vht_cap = &hw->wiphy->bands[NL80211_BAND_5GHZ]->vht_cap;
 	vht_cap = &sta->vht_cap;
 
+	rcu_read_unlock();
+
 	if ((ic_vht_cap->cap & IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE) &&
 	    (vht_cap->cap & IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE)) {
 		if (bfinfo->bfer_mu_cnt >= chip->bfer_mu_max_num) {
 			rtw_dbg(rtwdev, RTW_DBG_BF, "mu bfer number over limit\n");
-			goto out_unlock;
+			return;
 		}
 
 		ether_addr_copy(bfee->mac_addr, bssid);
@@ -75,7 +79,7 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 		   (vht_cap->cap & IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE)) {
 		if (bfinfo->bfer_su_cnt >= chip->bfer_su_max_num) {
 			rtw_dbg(rtwdev, RTW_DBG_BF, "su bfer number over limit\n");
-			goto out_unlock;
+			return;
 		}
 
 		sound_dim = vht_cap->cap &
@@ -98,9 +102,6 @@ void rtw_bf_assoc(struct rtw_dev *rtwdev, struct ieee80211_vif *vif,
 
 		rtw_chip_config_bfee(rtwdev, rtwvif, bfee, true);
 	}
-
-out_unlock:
-	rcu_read_unlock();
 }
 
 void rtw_bf_init_bfer_entry_mu(struct rtw_dev *rtwdev,
-- 
2.34.1

