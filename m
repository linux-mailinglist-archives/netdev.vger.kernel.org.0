Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D8BF4A7E
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 13:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391941AbfKHMJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 07:09:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:52950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388327AbfKHLkE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 06:40:04 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D08220869;
        Fri,  8 Nov 2019 11:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213203;
        bh=S4hGAQcWq3BmNUikVDjThFlx+Q15Rqc902O6gvM3WAA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qq88hRicGKqQOitO6zQ/IJuQ/JIEtFMuzR9gVvlhgZWD5dbCPxJXjuQDnxprADI11
         ncdFnuUeeoziRrmoQacQxClKZGuI3eWCfxYP1oCM/9lGu7dNBbhQveEP5bPOJVcurM
         kZtIH+VmiTTs3RNkBVkXlo4qT8XYQsVDnci3WYhk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naftali Goldstein <naftali.goldstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 086/205] mac80211: fix saving a few HE values
Date:   Fri,  8 Nov 2019 06:35:53 -0500
Message-Id: <20191108113752.12502-86-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Naftali Goldstein <naftali.goldstein@intel.com>

[ Upstream commit 77cbbc35a49b75969d98edce9400beb21720aa39 ]

After masking the he_oper_params, to get the requested values as
integers one must rshift and not lshift.  Fix that by using the
le32_get_bits() macro.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Signed-off-by: Naftali Goldstein <naftali.goldstein@intel.com>
[converted to use le32_get_bits()]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/mlme.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 5c9dcafbc3424..b0667467337d4 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3255,19 +3255,16 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 	}
 
 	if (bss_conf->he_support) {
-		u32 he_oper_params =
-			le32_to_cpu(elems.he_operation->he_oper_params);
+		bss_conf->bss_color =
+			le32_get_bits(elems.he_operation->he_oper_params,
+				      IEEE80211_HE_OPERATION_BSS_COLOR_MASK);
 
-		bss_conf->bss_color = he_oper_params &
-				      IEEE80211_HE_OPERATION_BSS_COLOR_MASK;
 		bss_conf->htc_trig_based_pkt_ext =
-			(he_oper_params &
-			 IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK) <<
-			IEEE80211_HE_OPERATION_DFLT_PE_DURATION_OFFSET;
+			le32_get_bits(elems.he_operation->he_oper_params,
+			      IEEE80211_HE_OPERATION_DFLT_PE_DURATION_MASK);
 		bss_conf->frame_time_rts_th =
-			(he_oper_params &
-			 IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK) <<
-			IEEE80211_HE_OPERATION_RTS_THRESHOLD_OFFSET;
+			le32_get_bits(elems.he_operation->he_oper_params,
+			      IEEE80211_HE_OPERATION_RTS_THRESHOLD_MASK);
 
 		bss_conf->multi_sta_back_32bit =
 			sta->sta.he_cap.he_cap_elem.mac_cap_info[2] &
-- 
2.20.1

