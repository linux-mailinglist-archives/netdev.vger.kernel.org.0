Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B9530C4F3
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 17:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236089AbhBBQHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 11:07:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:38256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235152AbhBBPJo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:09:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5D6A64F61;
        Tue,  2 Feb 2021 15:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278393;
        bh=H+McNijkMR/bhxDtYibNQd0KYp1YtnL9gfDDcwOMDNk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WxYJg3fFDFV/+TGYoFDMc20aXJ8PbBcDtOST75fNlQ+z5EhqNVJSxoM1meTbRG5qZ
         BKVYmhxW2ZBrLgA/M/YxGQPP1Fr5R0cydvlv1+EfZe1n7FLQ+xp7N5vgqARXRunUEI
         eMZexZgzW02JxmXaY28LNAvyC3iE2wm3xg9qHQKVVaG2rhT2/zLGkANhUFDc/zSsXG
         9UiQxZfNbmW86nDd+KM1Gn+OKsGVu44EWEzSGy8isVuscyzHfoXE9vra/eY5Wvc/bV
         uF388cFNxOOh5VVY65Dah1eOgQDzMRHKvFDiO3Y82jex1sSRMkoHEBswANSeKcYXxJ
         /OoNSzF42nkaQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 13/25] iwlwifi: mvm: skip power command when unbinding vif during CSA
Date:   Tue,  2 Feb 2021 10:06:03 -0500
Message-Id: <20210202150615.1864175-13-sashal@kernel.org>
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
index b627e7da7ac9d..d42165559df6e 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -4249,6 +4249,9 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
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

