Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F2CC40547A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 15:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353323AbhIIM64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 08:58:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:40990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354503AbhIIMvK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 08:51:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9474A63237;
        Thu,  9 Sep 2021 11:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188634;
        bh=XxpWqRYLel/LG59Qm3NLQDHNtbTcwgshYBLulKw/lvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i45/0f+MzfjrcimtJoTA0j4C4KmBVWVnqRrE7mlCnp2JEKKb9yHQQ4jhWQYBAB+Ax
         loDU5NFa/VrMXJtGp5KL0NJieW3NW4CD5pCgMBqOl/o5igk0ULeVdRiRRxuMhHcZhh
         PYoQgR5p8YGqzUGvIq/DQScgDddsZPeEk3h8sd7NOdFCwLh7ftX1Ds7Fz9BxeTDV18
         N10MdbKO/zbzvU7Wk1/IAU7QvCKCu2Cm5tJy8D4FxIv5XGz350EyAKLrtptZWx0tjz
         A4V2Diy4CrEA6lrSNzEbrsis7yCDJUvpLOSLSa7YvJsHHZdd9CLdwGbPDIbKoCk2sX
         9zMMatNGYFarw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhang Qilong <zhangqilong3@huawei.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 100/109] iwlwifi: mvm: fix a memory leak in iwl_mvm_mac_ctxt_beacon_changed
Date:   Thu,  9 Sep 2021 07:54:57 -0400
Message-Id: <20210909115507.147917-100-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115507.147917-1-sashal@kernel.org>
References: <20210909115507.147917-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 0f5d44ac6e55551798dd3da0ff847c8df5990822 ]

If beacon_inject_active is true, we will return without freeing
beacon.  Fid that by freeing it before returning.

Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
[reworded the commit message]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20210802172232.d16206ca60fc.I9984a9b442c84814c307cee3213044e24d26f38a@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
index 9c417dd06291..7736621dca65 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac-ctxt.c
@@ -1043,8 +1043,10 @@ int iwl_mvm_mac_ctxt_beacon_changed(struct iwl_mvm *mvm,
 		return -ENOMEM;
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-	if (mvm->beacon_inject_active)
+	if (mvm->beacon_inject_active) {
+		dev_kfree_skb(beacon);
 		return -EBUSY;
+	}
 #endif
 
 	ret = iwl_mvm_mac_ctxt_send_beacon(mvm, vif, beacon);
-- 
2.30.2

