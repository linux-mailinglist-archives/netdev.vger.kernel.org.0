Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4352713E939
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 18:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405233AbgAPRgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 12:36:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:51796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405211AbgAPRgv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 12:36:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59162246C5;
        Thu, 16 Jan 2020 17:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579196211;
        bh=LW2F/jHELeJRFD9QL7sp0B9QATRcwZeOVrASKbhON6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Im8+VoS+bdZ5csWX+o0KtkdzgegB0jr3fCQN3ScN5ancrjaPKeh1oIfDbERxlforz
         VHdfNK3NYtomdeaByE00NZOh4UEUhFfyUWaxWYihcLvLEV8H12Lptj025VORgqaFcU
         EAS1i1Kz+5GAhR5zV9wz5sf6wgTY2lMtnZxxogsk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Danny Alexander <danny.alexander@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 047/251] iwlwifi: mvm: fix A-MPDU reference assignment
Date:   Thu, 16 Jan 2020 12:33:16 -0500
Message-Id: <20200116173641.22137-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116173641.22137-1-sashal@kernel.org>
References: <20200116173641.22137-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 1f7698abedeeb3fef3cbcf78e16f925df675a179 ]

The current code assigns the reference, and then goes to increment
it if the toggle bit has changed. That way, we get

Toggle  0  0  0  0  1  1  1  1
ID      1  1  1  1  1  2  2  2

Fix that by assigning the post-toggle ID to get

Toggle  0  0  0  0  1  1  1  1
ID      1  1  1  1  2  2  2  2

Reported-by: Danny Alexander <danny.alexander@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Fixes: fbe4112791b8 ("iwlwifi: mvm: update mpdu metadata API")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
index c2bbc8c17beb..bc06d87a0106 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c
@@ -810,12 +810,12 @@ void iwl_mvm_rx_mpdu_mq(struct iwl_mvm *mvm, struct napi_struct *napi,
 		bool toggle_bit = phy_info & IWL_RX_MPDU_PHY_AMPDU_TOGGLE;
 
 		rx_status->flag |= RX_FLAG_AMPDU_DETAILS;
-		rx_status->ampdu_reference = mvm->ampdu_ref;
 		/* toggle is switched whenever new aggregation starts */
 		if (toggle_bit != mvm->ampdu_toggle) {
 			mvm->ampdu_ref++;
 			mvm->ampdu_toggle = toggle_bit;
 		}
+		rx_status->ampdu_reference = mvm->ampdu_ref;
 	}
 
 	rcu_read_lock();
-- 
2.20.1

