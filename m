Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61AF3CB672
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 12:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239048AbhGPK72 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 06:59:28 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:34371 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239464AbhGPK7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 06:59:13 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jiapeng.chong@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UfyITT._1626432970;
Received: from j63c13417.sqa.eu95.tbsite.net(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0UfyITT._1626432970)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 16 Jul 2021 18:56:16 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     luciano.coelho@intel.com
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Subject: [PATCH] iwlwifi: mvm: Fix missing error code in iwl_mvm_up()
Date:   Fri, 16 Jul 2021 18:56:08 +0800
Message-Id: <1626432968-122977-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The error code is missing in this code scenario, add the error code
'-EINVAL' to the return value 'ret'.

Eliminate the follow smatch warning:

drivers/net/wireless/intel/iwlwifi/mvm/fw.c:1465 iwl_mvm_up() warn:
missing error code 'ret'.

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index 38fd588..29bab53 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1461,8 +1461,10 @@ int iwl_mvm_up(struct iwl_mvm *mvm)
 	while (!sband && i < NUM_NL80211_BANDS)
 		sband = mvm->hw->wiphy->bands[i++];
 
-	if (WARN_ON_ONCE(!sband))
+	if (WARN_ON_ONCE(!sband)) {
+		ret = -EINVAL;
 		goto error;
+	}
 
 	chan = &sband->channels[0];
 
-- 
1.8.3.1

