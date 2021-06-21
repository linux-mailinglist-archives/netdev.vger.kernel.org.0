Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C6673AF2B4
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbhFUR4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:56:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:39086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232340AbhFURzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C54C961289;
        Mon, 21 Jun 2021 17:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297969;
        bh=5kiAwe2sKo+HYspEPVNuKP3QHogOO1UsdneSrcR1T+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tPq0L0el3BOoRCQd6oI61+i5fnAdAsfggxu8R4Tr7EHZCLMbdy+IugITh+feWPuY4
         QmvwXup9vD7u8jxPD1kH9CdvO6roikGIwz0dNYBLSFVYRPxKDu2cf2kTmrlnLNYWRT
         F1+RGCjqtKUzIvs6ZLzq3mCoVB8HcC1PnvJlnROLhH867FSuAFkUTw+rckfy+Mso4E
         mQF31aAmfnSkbp9EhwQa24NR+6ctaaMzGYwm8Ow1GWBI1J7cZegoN38x6ZRc+prr4s
         CSA6F+UIByrHg3Fw3bmYN6L5v1TBEEllkxzdcnbvc+0ycd/pA9o58bq0yfAAk6N6h2
         Y9juYGtrleFOA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 33/39] mac80211: reset profile_periodicity/ema_ap
Date:   Mon, 21 Jun 2021 13:51:49 -0400
Message-Id: <20210621175156.735062-33-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175156.735062-1-sashal@kernel.org>
References: <20210621175156.735062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit bbc6f03ff26e7b71d6135a7b78ce40e7dee3d86a ]

Apparently we never clear these values, so they'll remain set
since the setting of them is conditional. Clear the values in
the relevant other cases.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618133832.316e32d136a9.I2a12e51814258e1e1b526103894f4b9f19a91c8d@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 0fe91dc9817e..437d88822d8f 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4062,10 +4062,14 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 		if (elems.mbssid_config_ie)
 			bss_conf->profile_periodicity =
 				elems.mbssid_config_ie->profile_periodicity;
+		else
+			bss_conf->profile_periodicity = 0;
 
 		if (elems.ext_capab_len >= 11 &&
 		    (elems.ext_capab[10] & WLAN_EXT_CAPA11_EMA_SUPPORT))
 			bss_conf->ema_ap = true;
+		else
+			bss_conf->ema_ap = false;
 
 		/* continue assoc process */
 		ifmgd->assoc_data->timeout = jiffies;
@@ -5802,12 +5806,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 					      beacon_ies->data, beacon_ies->len);
 		if (elem && elem->datalen >= 3)
 			sdata->vif.bss_conf.profile_periodicity = elem->data[2];
+		else
+			sdata->vif.bss_conf.profile_periodicity = 0;
 
 		elem = cfg80211_find_elem(WLAN_EID_EXT_CAPABILITY,
 					  beacon_ies->data, beacon_ies->len);
 		if (elem && elem->datalen >= 11 &&
 		    (elem->data[10] & WLAN_EXT_CAPA11_EMA_SUPPORT))
 			sdata->vif.bss_conf.ema_ap = true;
+		else
+			sdata->vif.bss_conf.ema_ap = false;
 	} else {
 		assoc_data->timeout = jiffies;
 		assoc_data->timeout_started = true;
-- 
2.30.2

