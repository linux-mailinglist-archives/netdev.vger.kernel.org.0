Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3137844A27C
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 02:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242910AbhKIBTD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 20:19:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243219AbhKIBPS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Nov 2021 20:15:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7BE1161A04;
        Tue,  9 Nov 2021 01:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419983;
        bh=P59xDehY1csqTbjGuBoZgfpEDc4AncfQwMj9FjfRqMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V88khiyibit2XPJEi82zWUcCc2TNn4kbYqME/13uMY2Mz/dMHtTjYmnAZHQYwE4cH
         UnSk6jwDF5JSUYEF68ReL4C8sXFCkG1EERFxNAsukLDuNsVaK38EgFH31agGSaE4sN
         KDxaBAhX195EXx1D4Yve2+awB06agsEuedzJWnDTQUi1urWoO6Deb2wHABGiVscUuJ
         08MLqZX4/+b2DT1zohyxiRSk7bvJTSuccU/n7XJvUu4nvNqCq5OMoMatuYSJQoTvau
         HZV7kUXkjlVH/HYEDzvd9hiu8qx/gGHvCMNi9lNcWyAwsYZRCS2JhxkDgjNm8Rrl8c
         HzMTuLWLH84Cg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org,
        miriam.rachel.korenblit@intel.com, mordechay.goodstein@intel.com,
        haim.dreyfuss@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 36/47] iwlwifi: mvm: disable RX-diversity in powersave
Date:   Mon,  8 Nov 2021 12:50:20 -0500
Message-Id: <20211108175031.1190422-36-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit e5322b9ab5f63536c41301150b7ce64605ce52cc ]

Just like we have default SMPS mode as dynamic in powersave,
we should not enable RX-diversity in powersave, to reduce
power consumption when connected to a non-MIMO AP.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211017113927.fc896bc5cdaa.I1d11da71b8a5cbe921a37058d5f578f1b14a2023@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 00712205c05f2..bc3f67e0bf334 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1018,6 +1018,9 @@ bool iwl_mvm_rx_diversity_allowed(struct iwl_mvm *mvm)
 
 	lockdep_assert_held(&mvm->mutex);
 
+	if (iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM)
+		return false;
+
 	if (num_of_ant(iwl_mvm_get_valid_rx_ant(mvm)) == 1)
 		return false;
 
-- 
2.33.0

