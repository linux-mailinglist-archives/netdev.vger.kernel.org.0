Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE391065DC
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727598AbfKVFuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:50:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727576AbfKVFuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:17 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 861BA2070A;
        Fri, 22 Nov 2019 05:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401816;
        bh=RuXCy8MiSHwkFqpJv3UmmnKuGufeTgueNF/f4E5Vf+I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wv1rCSupUyREA1pDs6ddxP6Sxu50hafGBrnj82/gW+zHAwiZEjo4EriuiDMOux4H5
         6+9bQZ22NeB6KN4xAof/A8If9ZDmi6SaQ5j4h27vuaqTeujlRT6yeMC8HMqcJ/vKLQ
         NlQmXctYUnd3K1S3hb/nUcpe7p+WEtLKpsfSHJGs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 060/219] iwlwifi: mvm: force TCM re-evaluation on TCM resume
Date:   Fri, 22 Nov 2019 00:46:32 -0500
Message-Id: <20191122054911.1750-53-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Avraham Stern <avraham.stern@intel.com>

[ Upstream commit 7bc2468277033e05401d5f8fd48a772f407338c2 ]

When traffic load is not low or low latency is active, TCM schedules
re-evaluation work so in case traffic stops TCM will detect that
traffic load has become low or that low latency is no longer active.
However, if TCM is paused when the re-evaluation work runs, it does
not re-evaluate and the re-evaluation work is no longer scheduled.
As a result, TCM will not indicate that low latency is no longer
active or that traffic load is low when traffic stops.

Fix this by forcing TCM re-evaluation when TCM is resumed in case
low latency is active or traffic load is not low.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/utils.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
index 6a5349401aa99..00712205c05f2 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/utils.c
@@ -1804,6 +1804,7 @@ void iwl_mvm_pause_tcm(struct iwl_mvm *mvm, bool with_cancel)
 void iwl_mvm_resume_tcm(struct iwl_mvm *mvm)
 {
 	int mac;
+	bool low_latency = false;
 
 	spin_lock_bh(&mvm->tcm.lock);
 	mvm->tcm.ts = jiffies;
@@ -1815,10 +1816,23 @@ void iwl_mvm_resume_tcm(struct iwl_mvm *mvm)
 		memset(&mdata->tx.pkts, 0, sizeof(mdata->tx.pkts));
 		memset(&mdata->rx.airtime, 0, sizeof(mdata->rx.airtime));
 		memset(&mdata->tx.airtime, 0, sizeof(mdata->tx.airtime));
+
+		if (mvm->tcm.result.low_latency[mac])
+			low_latency = true;
 	}
 	/* The TCM data needs to be reset before "paused" flag changes */
 	smp_mb();
 	mvm->tcm.paused = false;
+
+	/*
+	 * if the current load is not low or low latency is active, force
+	 * re-evaluation to cover the case of no traffic.
+	 */
+	if (mvm->tcm.result.global_load > IWL_MVM_TRAFFIC_LOW)
+		schedule_delayed_work(&mvm->tcm.work, MVM_TCM_PERIOD);
+	else if (low_latency)
+		schedule_delayed_work(&mvm->tcm.work, MVM_LL_PERIOD);
+
 	spin_unlock_bh(&mvm->tcm.lock);
 }
 
-- 
2.20.1

