Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4899E30C413
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 16:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235562AbhBBPka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Feb 2021 10:40:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:39462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235269AbhBBPOv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Feb 2021 10:14:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A397364FA2;
        Tue,  2 Feb 2021 15:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278454;
        bh=joKYNFrfxTJaTY/td3Bgwgy7/4s/D9KzIQu/cAYX05w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wry5aANPidZILEhKoxb2BIurX7TtgC+mXKW0UBJEuTXcX2Zx2AqEhM9+GsN64mxbt
         oll8KCqE/aRc/j7QPpzreOJThoLjntpeepHDplBUTnObzBQ55RzVpszFfAh3xTYY4S
         2TxVlR9hFG5dKL7Vp91cKD1EypE7oEPckbFs2EEBhqTe0PkKfdO4ssWLiB2yzpG2x8
         GAusHBc52E8qFHVmgigVkExB5UG4wHHpXeiAbRFKqDN8rdTp5HdfvbbAwfv4PtUQI3
         t5F8CJiWe3kQDiZ12WIU/g0beY4egL0zu8zEHCpjJG1eh7I6EtEdfN2iDG8kH1u51s
         DsxxhvCYxz/fg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 3/7] iwlwifi: mvm: take mutex for calling iwl_mvm_get_sync_time()
Date:   Tue,  2 Feb 2021 10:07:25 -0500
Message-Id: <20210202150730.1864745-3-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150730.1864745-1-sashal@kernel.org>
References: <20210202150730.1864745-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 5c56d862c749669d45c256f581eac4244be00d4d ]

We need to take the mutex to call iwl_mvm_get_sync_time(), do it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20210115130252.4bb5ccf881a6.I62973cbb081e80aa5b0447a5c3b9c3251a65cf6b@changeid
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
index 71a01df96f8b0..6db51abb8f4a3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -518,7 +518,10 @@ static ssize_t iwl_dbgfs_os_device_timediff_read(struct file *file,
 	const size_t bufsz = sizeof(buf);
 	int pos = 0;
 
+	mutex_lock(&mvm->mutex);
 	iwl_mvm_get_sync_time(mvm, &curr_gp2, &curr_os);
+	mutex_unlock(&mvm->mutex);
+
 	do_div(curr_os, NSEC_PER_USEC);
 	diff = curr_os - curr_gp2;
 	pos += scnprintf(buf + pos, bufsz - pos, "diff=%lld\n", diff);
-- 
2.27.0

