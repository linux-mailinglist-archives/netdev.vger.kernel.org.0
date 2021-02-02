Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30FF930C47E
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:55:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235844AbhBBPxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:53:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:39460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235019AbhBBPM2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CAFDC64F87;
        Tue,  2 Feb 2021 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278421;
        bh=FCPfVnRG2CO+xF685n4LNuumA9F5bRF7rvJBReS7buY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uOK3CcDA42LBBmhoTX36Zn6rPC6gfYnMJztPb8izS2WEfsrW1pQxSMnh/B7cZVq9o
         7TQppx9g4G+z5PzDk+gtFFY5qrjW4hMwWjbyrrG6xQ5GblAc3vbBPPBRm1sxt+aT0N
         GfLcxngYRx9Iz8tfS3maakj2HA4vT4CKxfmcFt/T0Ud5NTGSuGg3Dx2Tct1Qbx1eyC
         bASWeVug4WUmSaKn5E0p+uES3/UhBcSflLr1tyt/TByyfs40PYUzGc593MXCGGKaqC
         8KAnfMWZqNWOXRkzwMeb3sdymVkr34ie6FgdR+QP0MJl6u8WfbS1CrlICMUh01Kysj
         /cnHLmtR+f8LA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 08/17] iwlwifi: mvm: skip power command when unbinding vif during CSA
Date:   Tue,  2 Feb 2021 10:06:42 -0500
Message-Id: <20210202150651.1864426-8-sashal@kernel.org>
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

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit bf544e9aa570034e094a8a40d5f9e1e2c4916d18 ]

In the new CSA flow, we remain associated during CSA, but
still do a unbind-bind to the vif. However, sending the power
command right after when vif is unbound but still associated
causes FW to assert (0x3400) since it cannot tell the LMAC id.

Just skip this command, we will send it again in a bit, when
assigning the new context.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.64a2254ac5c3.Iaa3a9050bf3d7c9cd5beaf561e932e6defc12ec3@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index daae86cd61140..fc6430edd1107 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4169,6 +4169,9 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
 out:
+	if (fw_has_capa(&mvm->fw->ucode_capa, IWL_UCODE_TLV_CAPA_CHANNEL_SWITCH_CMD) &&
+	    switching_chanctx)
+		return;
 	mvmvif->phy_ctxt = NULL;
 	iwl_mvm_power_update_mac(mvm);
 }
-- 
2.27.0

