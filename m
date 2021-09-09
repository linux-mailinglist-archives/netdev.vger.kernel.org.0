Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3C340505D
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 14:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347671AbhIIM13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:27:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350425AbhIIMWN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:22:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5CE661AE1;
        Thu,  9 Sep 2021 11:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188255;
        bh=6r3e4fFI0L1s1Y97K3IG8jSgzDA1fv8BgWIJ2Yf6GyE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fUj5yCf5xoKpzViWVF/3U/vghmb8+OHU7tA8KE17pBgKrw+uwtHRQgqgM47xiYeSf
         GB0q8O/0TJhkUV7lvDRO5nEWxYAPsAt7Fz0pKgGDAm91wpxNv+08lF4WfT4EMXQSP2
         msg7K4kgFvGiudTu/BjaK2Yx9aHILy1h+6Rn2UDjG/tZzPCeFCXc4Dv94QJ1UAcneN
         XOh/zS8mJR8sXx+b0I0c8VxN1POx0AC4/OebEFEPTQxOIER3lOyFxOHc/tzCGiy+yM
         wDbmZfTkwKzLxZ8zTQV8bX8/4c3DxDFCowIGs2fSvAgss3uym1u4SCQWX0swTa9mHy
         zIfA+vgjXEOtA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 202/219] iwlwifi: mvm: Do not use full SSIDs in 6GHz scan
Date:   Thu,  9 Sep 2021 07:46:18 -0400
Message-Id: <20210909114635.143983-202-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit deedf9b97cd4ef45da476c9bdd2a5f3276053956 ]

The scan request processing populated the direct SSIDs
in the FW scan request command also for 6GHz scan, which is not
needed and might result in unexpected behavior.

Fix the code to add the direct SSIDs only in case the scan
is not a 6GHz scan.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802170640.f465937c7bbf.Ic11a1659ddda850c3ec1b1afbe9e2b9577ac1800@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index 5a0696c44f6d..3627de2af344 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -2368,14 +2368,17 @@ static int iwl_mvm_scan_umac_v14(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	if (ret)
 		return ret;
 
-	iwl_mvm_scan_umac_fill_probe_p_v4(params, &scan_p->probe_params,
-					  &bitmap_ssid);
 	if (!params->scan_6ghz) {
+		iwl_mvm_scan_umac_fill_probe_p_v4(params, &scan_p->probe_params,
+					  &bitmap_ssid);
 		iwl_mvm_scan_umac_fill_ch_p_v6(mvm, params, vif,
-					       &scan_p->channel_params, bitmap_ssid);
+				       &scan_p->channel_params, bitmap_ssid);
 
 		return 0;
+	} else {
+		pb->preq = params->preq;
 	}
+
 	cp->flags = iwl_mvm_scan_umac_chan_flags_v2(mvm, params, vif);
 	cp->n_aps_override[0] = IWL_SCAN_ADWELL_N_APS_GO_FRIENDLY;
 	cp->n_aps_override[1] = IWL_SCAN_ADWELL_N_APS_SOCIAL_CHS;
-- 
2.30.2

