Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB9DD30C4B8
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:01:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhBBQAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:00:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:38256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235200AbhBBPMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 07AB064F7D;
        Tue,  2 Feb 2021 15:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278415;
        bh=QzJeBS0buSUYwMAuGzi1I4Qv2WP5kLvvJR19riZnNOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ONrmQutLajUyO7onyFaQ7p+3nAxS9Rero5yGTGFwgM+VgqRdSiT7qaVTZW2umfZ09
         DSqNVk0QO3r5QFku+hdq+ELlfJAbsE1KFDOiAzQMe7MlPH7Gv6wfGsz7U3uWKs0nUn
         YKWJWHlb0xTGocpvs+af8JdgfelfaQvkxNqmnnhLDTAeZXHC/gDOykylKH4rLgjXdR
         ETHr1Gte/DjP+3VG10zJKxjMSXi8b22dcv+UgAIpx5zbnU1uWorM0Mli8IyGu3FIB/
         Kl2iBAD2Fq0Y7mxxtXViBlYpadvq2RlsDYJ82rbSqEhqm/JGPa07LePSa5LVABBJtF
         20InjMxE/nKlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shay Bar <shay.bar@celeno.com>,
        Aviad Brikman <aviad.brikman@celeno.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 03/17] mac80211: 160MHz with extended NSS BW in CSA
Date:   Tue,  2 Feb 2021 10:06:37 -0500
Message-Id: <20210202150651.1864426-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150651.1864426-1-sashal@kernel.org>
References: <20210202150651.1864426-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shay Bar <shay.bar@celeno.com>

[ Upstream commit dcf3c8fb32ddbfa3b8227db38aa6746405bd4527 ]

Upon receiving CSA with 160MHz extended NSS BW from associated AP,
STA should set the HT operation_mode based on new_center_freq_seg1
because it is later used as ccfs2 in ieee80211_chandef_vht_oper().

Signed-off-by: Aviad Brikman <aviad.brikman@celeno.com>
Signed-off-by: Shay Bar <shay.bar@celeno.com>
Link: https://lore.kernel.org/r/20201222064714.24888-1-shay.bar@celeno.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/spectmgmt.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index 5fe2b645912f6..132f8423addaa 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -132,16 +132,20 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (wide_bw_chansw_ie) {
+		u8 new_seg1 = wide_bw_chansw_ie->new_center_freq_seg1;
 		struct ieee80211_vht_operation vht_oper = {
 			.chan_width =
 				wide_bw_chansw_ie->new_channel_width,
 			.center_freq_seg0_idx =
 				wide_bw_chansw_ie->new_center_freq_seg0,
-			.center_freq_seg1_idx =
-				wide_bw_chansw_ie->new_center_freq_seg1,
+			.center_freq_seg1_idx = new_seg1,
 			/* .basic_mcs_set doesn't matter */
 		};
-		struct ieee80211_ht_operation ht_oper = {};
+		struct ieee80211_ht_operation ht_oper = {
+			.operation_mode =
+				cpu_to_le16(new_seg1 <<
+					    IEEE80211_HT_OP_MODE_CCFS2_SHIFT),
+		};
 
 		/* default, for the case of IEEE80211_VHT_CHANWIDTH_USE_HT,
 		 * to the previously parsed chandef
-- 
2.27.0

