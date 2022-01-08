Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA9848802B
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 01:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiAHA4A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 19:56:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232160AbiAHAz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 19:55:56 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5044BC06173F;
        Fri,  7 Jan 2022 16:55:55 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id o3so14084335wrh.10;
        Fri, 07 Jan 2022 16:55:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vVOffY2SWc0pPnPvYF0rhrV08ycYCPvS3uYYaNs2rOM=;
        b=GitN+raFMLZ4Tdmi1VuHtCn80hz9objvZOmgb1YHrHOqHvhCKm55gz8anKhN8+z7eW
         l4C6mp9Syx5dGCBwIkbavPegNj9BC/XaUC3XUdgGhXz4EpwAJOnFHXRmHIrnl2fvhos1
         daRija6oS9X4/AT7W796O/NVDKVxmEYlQ/60yN7i7GZtOS5v5WN7HOoeVrL7mK93wTVa
         4RIgqzFkLgTh/9UEoWynxxrlaIs/9MHo8E8viEpjPoB0YN1q8bN4/awSHWAHPkvulGxy
         JssL7lWJGDtOcjt8Wj/CK7KLKipAmHYtO1CabFhJxQ+cU6A7yFn5xSvJ1kExSxqXyEHj
         4QvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vVOffY2SWc0pPnPvYF0rhrV08ycYCPvS3uYYaNs2rOM=;
        b=FVojN9JqbhmiKjDmjBPT/YFLb104aUSFR2myljG+KegWXKWMHxpn1btm1WIbAhdsx/
         s80pz5Kl1ANzGwX/nTrWL9jGtlfUuW2vXTUJM8ooRR4vbjhmD8eQX1k7vzN6NWHC4USq
         TiGKCoD9Cf92uI0jDP+/29kevBSo/nQIpkr8F7j6F3RSohyJgapJ827s9f9297A6fWoV
         mfmFuXGRYmox8kwRhm1xFTWa2kACdm+GHTxZuKeMJeVWLwDABBLLGE7L2JiTMw4CIGQ7
         2q03Q2w/MYbqPMRJOnNBuNNurlQyAx4rTuj+7AFOhkGdBoz58bWOlXZJ3h3tQ2AKu+f0
         1FAQ==
X-Gm-Message-State: AOAM531onv6mt0dHKUi29+CaiSGnIMFdyWaezDoYrUnvibevdltSKoLG
        UgW5bfAA+S+YfknWRErHXuUmEI6rTHo=
X-Google-Smtp-Source: ABdhPJzbs1bm4DSUTkPc1jHV2LpaQTR6BjpN5BxzV12x4GUUZGrezHkPio70qi666StxdmeIwLbNyg==
X-Received: by 2002:a5d:6943:: with SMTP id r3mr2966575wrw.364.1641603353802;
        Fri, 07 Jan 2022 16:55:53 -0800 (PST)
Received: from localhost.localdomain (dynamic-095-117-123-222.95.117.pool.telefonica.de. [95.117.123.222])
        by smtp.googlemail.com with ESMTPSA id z6sm77357wmp.9.2022.01.07.16.55.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 16:55:53 -0800 (PST)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     linux-wireless@vger.kernel.org
Cc:     tony0620emma@gmail.com, kvalo@codeaurora.org,
        johannes@sipsolutions.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Pkshih <pkshih@realtek.com>, Ed Swierk <eswierk@gh.st>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH v3 6/8] rtw88: Configure the registers from rtw_bf_assoc() outside the RCU lock
Date:   Sat,  8 Jan 2022 01:55:31 +0100
Message-Id: <20220108005533.947787-7-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
References: <20220108005533.947787-1-martin.blumenstingl@googlemail.com>
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
v2 -> v3:
- no changes

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

