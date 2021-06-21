Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF9073AF2B9
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 19:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233101AbhFUR4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 13:56:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:39638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232341AbhFURzM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 13:55:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27CF861374;
        Mon, 21 Jun 2021 17:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624297970;
        bh=AITUTjLLUiwKxWCG0zkVTGC0b3FBPZ2goSXXBTpkhVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faCw9DquiMVDuSC5yqYx86ZZpMW3kcJDf0cE/+O3uPs2Z6IBesGqp8vr7EjpZtVkx
         A8MyB1nvVgsI6qLsqjBo38x0SrcfRxMPT2DgjKIZRBLlxbuVUtDDRGg8gJVBFIXIIE
         +2l5N1Rg2xEAM4oC93BipG7dRNXOBVenxn2ySQEdHUG655RPzmvaTEPAinU2ww73V/
         NBaM8C6wpPFCkWk2knkxwbcr5NgNghNqwzObl8v5nNjhS7cqeCr3Xm/xlHHBBnSE8e
         T/yitm+wUeF5r+Ixe05y3tgPcrShULEZe+xHvF7WYHxWRGDJoGa3v3WYny5Q7i/bta
         3YBqZG5iNy69A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 34/39] mac80211: handle various extensible elements correctly
Date:   Mon, 21 Jun 2021 13:51:50 -0400
Message-Id: <20210621175156.735062-34-sashal@kernel.org>
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

[ Upstream commit 652e8363bbc7d149fa194a5cbf30b1001c0274b0 ]

Various elements are parsed with a requirement to have an
exact size, when really we should only check that they have
the minimum size that we need. Check only that and therefore
ignore any additional data that they might carry.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210618133832.cd101f8040a4.Iadf0e9b37b100c6c6e79c7b298cc657c2be9151a@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/util.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index c0fa526a45b4..b18150d36cb2 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -955,7 +955,7 @@ static void ieee80211_parse_extension_element(u32 *crc,
 
 	switch (elem->data[0]) {
 	case WLAN_EID_EXT_HE_MU_EDCA:
-		if (len == sizeof(*elems->mu_edca_param_set)) {
+		if (len >= sizeof(*elems->mu_edca_param_set)) {
 			elems->mu_edca_param_set = data;
 			if (crc)
 				*crc = crc32_be(*crc, (void *)elem,
@@ -976,7 +976,7 @@ static void ieee80211_parse_extension_element(u32 *crc,
 		}
 		break;
 	case WLAN_EID_EXT_UORA:
-		if (len == 1)
+		if (len >= 1)
 			elems->uora_element = data;
 		break;
 	case WLAN_EID_EXT_MAX_CHANNEL_SWITCH_TIME:
@@ -984,7 +984,7 @@ static void ieee80211_parse_extension_element(u32 *crc,
 			elems->max_channel_switch_time = data;
 		break;
 	case WLAN_EID_EXT_MULTIPLE_BSSID_CONFIGURATION:
-		if (len == sizeof(*elems->mbssid_config_ie))
+		if (len >= sizeof(*elems->mbssid_config_ie))
 			elems->mbssid_config_ie = data;
 		break;
 	case WLAN_EID_EXT_HE_SPR:
@@ -993,7 +993,7 @@ static void ieee80211_parse_extension_element(u32 *crc,
 			elems->he_spr = data;
 		break;
 	case WLAN_EID_EXT_HE_6GHZ_CAPA:
-		if (len == sizeof(*elems->he_6ghz_capa))
+		if (len >= sizeof(*elems->he_6ghz_capa))
 			elems->he_6ghz_capa = data;
 		break;
 	}
@@ -1082,14 +1082,14 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 
 		switch (id) {
 		case WLAN_EID_LINK_ID:
-			if (elen + 2 != sizeof(struct ieee80211_tdls_lnkie)) {
+			if (elen + 2 < sizeof(struct ieee80211_tdls_lnkie)) {
 				elem_parse_failed = true;
 				break;
 			}
 			elems->lnk_id = (void *)(pos - 2);
 			break;
 		case WLAN_EID_CHAN_SWITCH_TIMING:
-			if (elen != sizeof(struct ieee80211_ch_switch_timing)) {
+			if (elen < sizeof(struct ieee80211_ch_switch_timing)) {
 				elem_parse_failed = true;
 				break;
 			}
@@ -1252,7 +1252,7 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			elems->sec_chan_offs = (void *)pos;
 			break;
 		case WLAN_EID_CHAN_SWITCH_PARAM:
-			if (elen !=
+			if (elen <
 			    sizeof(*elems->mesh_chansw_params_ie)) {
 				elem_parse_failed = true;
 				break;
@@ -1261,7 +1261,7 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			break;
 		case WLAN_EID_WIDE_BW_CHANNEL_SWITCH:
 			if (!action ||
-			    elen != sizeof(*elems->wide_bw_chansw_ie)) {
+			    elen < sizeof(*elems->wide_bw_chansw_ie)) {
 				elem_parse_failed = true;
 				break;
 			}
@@ -1280,7 +1280,7 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			ie = cfg80211_find_ie(WLAN_EID_WIDE_BW_CHANNEL_SWITCH,
 					      pos, elen);
 			if (ie) {
-				if (ie[1] == sizeof(*elems->wide_bw_chansw_ie))
+				if (ie[1] >= sizeof(*elems->wide_bw_chansw_ie))
 					elems->wide_bw_chansw_ie =
 						(void *)(ie + 2);
 				else
@@ -1324,7 +1324,7 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 			elems->cisco_dtpc_elem = pos;
 			break;
 		case WLAN_EID_ADDBA_EXT:
-			if (elen != sizeof(struct ieee80211_addba_ext_ie)) {
+			if (elen < sizeof(struct ieee80211_addba_ext_ie)) {
 				elem_parse_failed = true;
 				break;
 			}
@@ -1350,7 +1350,7 @@ _ieee802_11_parse_elems_crc(const u8 *start, size_t len, bool action,
 							  elem, elems);
 			break;
 		case WLAN_EID_S1G_CAPABILITIES:
-			if (elen == sizeof(*elems->s1g_capab))
+			if (elen >= sizeof(*elems->s1g_capab))
 				elems->s1g_capab = (void *)pos;
 			else
 				elem_parse_failed = true;
-- 
2.30.2

