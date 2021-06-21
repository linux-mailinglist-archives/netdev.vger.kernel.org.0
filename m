Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBBA73AF34A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhFUSAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 14:00:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232417AbhFUR6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:58:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4522B613C9;
        Mon, 21 Jun 2021 17:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624298027;
        bh=S8lnhKoDzKnQkrex/x7jAw10+QDYKi5xrVPjpAJ0z30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uu6oR3jpoC6PH2PanD4PhpapsBDj9viJRLNUTt4oYA2tQzUgmjFw7UvhZ8rqHlCtj
         FG8N6tkV3Th4HlFbjh8N3x+R/k8uGzITElmx3qydllFMYeV7CR19BmfiDQbYjEmQ+S
         0p7T5gXlPcvnSl+YzePUAu2gJv4H5M/204iirgI/0jQU008nIuSEGRt/xbjJpmOYPM
         PYIRoqF+wbJwqCRNPk+7RZKFwFG+m9z1XeDazUhL8HBH1cBF8dbPFp/EHgewP9Q+If
         yWmlUcxeo3BIv/iIEaxY6VAuzRrMjPyinVsaC0TzPGMS3tiBzdhJesqhqjsJmfM/Xp
         +Yci+CCf2T0ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 30/35] mac80211: reset profile_periodicity/ema_ap
Date:   Mon, 21 Jun 2021 13:52:55 -0400
Message-Id: <20210621175300.735437-30-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210621175300.735437-1-sashal@kernel.org>
References: <20210621175300.735437-1-sashal@kernel.org>
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
index 6d3220c66931..fbe26e912300 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4019,10 +4019,14 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
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
@@ -5749,12 +5753,16 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
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

