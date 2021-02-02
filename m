Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 846A930C53C
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236155AbhBBQQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:16:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:35006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235023AbhBBPHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:07:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 656AF64ED7;
        Tue,  2 Feb 2021 15:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278383;
        bh=AY0jQNyvDyQq9Y0URkEU5m67QyTIMYz4QpKVrUqnIKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqAJuRwNsdvjftYUMuYOvlPK1ePuZgD0+5LrZdM5B0NlwfdIFdTC+V8mZi0HKkAvn
         9fRWyO1p+/RHFRy62QwS1zviwVqAjkeABATliQzU4PeYXFbots2ztxN8oufI7Y+WLV
         Oa0YTitFEFvcWbKOo1hVScJV+IjaZH2jEerv98hPispXlObqogy/dRQY5uxRVzYPEX
         NPDW8k6vFnBIcFP5wpsf67wPRGG2hiSX+GrxNmKYebjQb8RlEiOJ6ZHj/raUCl0tsq
         G6smR5VBtQMRmi9KRvB0dNjDoWCwy/kqXEEQBopTtgOuzTuVr0NnmYNwBrjZQIVoqx
         pyp9n/umLhPGw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shay Bar <shay.bar@celeno.com>,
        Aviad Brikman <aviad.brikman@celeno.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/25] mac80211: 160MHz with extended NSS BW in CSA
Date:   Tue,  2 Feb 2021 10:05:55 -0500
Message-Id: <20210202150615.1864175-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150615.1864175-1-sashal@kernel.org>
References: <20210202150615.1864175-1-sashal@kernel.org>
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
index ae1cb2c687224..76747bfdaddd0 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -133,16 +133,20 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
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

