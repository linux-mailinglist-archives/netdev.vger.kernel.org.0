Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E075C1A01F5
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 02:01:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbgDGABJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 20:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:33566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726591AbgDGABI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 20:01:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 446E920801;
        Tue,  7 Apr 2020 00:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586217668;
        bh=LsGwzhl9mRdO++Z0F9wZmxu6Hs4Hb4HS+22XNh9FSkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lsqP/RvTQBtS6YlzkFUo1LgejTVHCxHUMhP24aYs7p/Ko8w8IN9WD22xCrpH534PO
         S+W0q5EQicVv0yduBoRk8pSusVwvsc66qlpFR8k2JQkW4eCZ5+i931h6EBI2bBeosW
         a3cMKuOnQ2hundR4U2Uisqq04tpcLYS4UK/pqv7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 07/35] iwlwifi: consider HE capability when setting LDPC
Date:   Mon,  6 Apr 2020 20:00:29 -0400
Message-Id: <20200407000058.16423-7-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200407000058.16423-1-sashal@kernel.org>
References: <20200407000058.16423-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mordechay Goodstein <mordechay.goodstein@intel.com>

[ Upstream commit cb377dfda1755b3bc01436755d866c8e5336a762 ]

The AP may set the LDPC capability only in HE (IEEE80211_HE_PHY_CAP1),
but we were checking it only in the HT capabilities.

If we don't use this capability when required, the DSP gets the wrong
configuration in HE and doesn't work properly.

Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
Fixes: befebbb30af0 ("iwlwifi: rs: consider LDPC capability in case of HE")
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20200306151128.492d167c1a25.I1ad1353dbbf6c99ae57814be750f41a1c9f7f4ac@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
index e2cf9e015ef8c..80ef238a84884 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c
@@ -147,7 +147,11 @@ static u16 rs_fw_get_config_flags(struct iwl_mvm *mvm,
 	     (vht_ena && (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC))))
 		flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
 
-	/* consider our LDPC support in case of HE */
+	/* consider LDPC support in case of HE */
+	if (he_cap->has_he && (he_cap->he_cap_elem.phy_cap_info[1] &
+	    IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD))
+		flags |= IWL_TLC_MNG_CFG_FLAGS_LDPC_MSK;
+
 	if (sband->iftype_data && sband->iftype_data->he_cap.has_he &&
 	    !(sband->iftype_data->he_cap.he_cap_elem.phy_cap_info[1] &
 	     IEEE80211_HE_PHY_CAP1_LDPC_CODING_IN_PAYLOAD))
-- 
2.20.1

