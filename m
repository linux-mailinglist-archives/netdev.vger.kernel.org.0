Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 120B630C34E
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:15:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbhBBPOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:14:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235185AbhBBPL4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:11:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69B3064F6F;
        Tue,  2 Feb 2021 15:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278401;
        bh=4Be4D8RHPbYDxfx9vGtIsxWrZ/BotuY5XFCfmyr6muc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cvwe/3t9lNqg2HOfFfzJh/kAAS4sqjx6iFa1oOWW14ZfZUlPrVc2KhLVUmMp8Z6Qs
         gN6CowkA2VwUWafZs99BrHXpz5aMtzSL77J1xR5EopZjHv2lU4fYHm8sLRDN88zRgH
         Hme/RBvuYXE2ffuf0PzYf7QP/tRxKbJANuy5ILuBs1pQ9qdvnRvj4YhHgcBd5KsFQr
         /aJdEWr2g5nFgTCcG8SuzOmNJH4X1ksRaqH2XOUVQpA/jDcfobIu8S9EK7y3MMy3eH
         FJ0jEJd3JRM7gnh1RC/GHZc2/FB/SSeDJlOHybiFfU5X0xVjZ3QnQ4YRr8IGn+zhDL
         pSIIJ6Pbh5TOg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 19/25] iwlwifi: mvm: guard against device removal in reprobe
Date:   Tue,  2 Feb 2021 10:06:09 -0500
Message-Id: <20210202150615.1864175-19-sashal@kernel.org>
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
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
index cea8e397fe0f2..cb83490f1016f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/ops.c
@@ -1249,6 +1249,7 @@ static void iwl_mvm_reprobe_wk(struct work_struct *wk)
 	reprobe = container_of(wk, struct iwl_mvm_reprobe, work);
 	if (device_reprobe(reprobe->dev))
 		dev_err(reprobe->dev, "reprobe failed!\n");
+	put_device(reprobe->dev);
 	kfree(reprobe);
 	module_put(THIS_MODULE);
 }
@@ -1299,7 +1300,7 @@ void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 			module_put(THIS_MODULE);
 			return;
 		}
-		reprobe->dev = mvm->trans->dev;
+		reprobe->dev = get_device(mvm->trans->dev);
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
 	} else if (test_bit(IWL_MVM_STATUS_HW_RESTART_REQUESTED,
-- 
2.27.0

