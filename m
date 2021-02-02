Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB84530C386
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:21:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbhBBPUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:20:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235359AbhBBPQz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:16:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D49DE64FAF;
        Tue,  2 Feb 2021 15:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278474;
        bh=vwY4oJVsAOPWacoX4pBi7QpzcbEii844hqLpg8lt2B0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A/Z4vTsE12uOH5V2rS4tuSjzT20++Izh39aDkSrBtYdmDomrS8wzg1pzjHo7DH3PI
         VlENevyxj9FNQnvJVz5+FOZY2yZRlygHhW9F66tW2M2plmb34n+zDy/z26C3ZWuVeQ
         EGEBd4BiNsQ44qva56B1wGf5tLcPT/jmYKX8ihBm1nTsAuuVP0gP7qr3BFDpUYyxCv
         Ga+LWb594TrwsFGgifvXD3c+H2DR1qH7Ke4JbUXduii1M5qf2fzQtjUWmo87i5l/4o
         rxnSUbr1UpeIYVpYjUeNYnYoXZhVVcgcgn0flJimUVXjIDBuG+aaYU9ry8Xx9L8N5X
         aH6FX39k86Fsw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 3/5] iwlwifi: mvm: guard against device removal in reprobe
Date:   Tue,  2 Feb 2021 10:07:48 -0500
Message-Id: <20210202150750.1864953-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150750.1864953-1-sashal@kernel.org>
References: <20210202150750.1864953-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 7a21b1d4a728a483f07c638ccd8610d4b4f12684 ]

If we get into a problem severe enough to attempt a reprobe,
we schedule a worker to do that. However, if the problem gets
more severe and the device is actually destroyed before this
worker has a chance to run, we use a free device. Bump up the
reference count of the device until the worker runs to avoid
this situation.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210122144849.871f0892e4b2.I94819e11afd68d875f3e242b98bef724b8236f1e@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/iwlwifi/mvm/ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 13c97f665ba88..bb81261de45fa 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -909,6 +909,7 @@ static void iwl_mvm_reprobe_wk(struct work_struct *wk)
 	reprobe = container_of(wk, struct iwl_mvm_reprobe, work);
 	if (device_reprobe(reprobe->dev))
 		dev_err(reprobe->dev, "reprobe failed!\n");
+	put_device(reprobe->dev);
 	kfree(reprobe);
 	module_put(THIS_MODULE);
 }
@@ -991,7 +992,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 			module_put(THIS_MODULE);
 			return;
 		}
-		reprobe->dev = mvm->trans->dev;
+		reprobe->dev = get_device(mvm->trans->dev);
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
 	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR) {
-- 
2.27.0

