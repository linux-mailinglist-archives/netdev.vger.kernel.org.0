Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C811243C366
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 08:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240186AbhJ0HBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 03:01:11 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:58640 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231776AbhJ0HBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 03:01:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=cuibixuan@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0Utr.qNe_1635317920;
Received: from VM20210331-25.tbsite.net(mailfrom:cuibixuan@linux.alibaba.com fp:SMTPD_---0Utr.qNe_1635317920)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 14:58:44 +0800
From:   Bixuan Cui <cuibixuan@linux.alibaba.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kvalo@codeaurora.org, luciano.coelho@intel.com,
        davem@davemloft.net, kuba@kernel.org, gregory.greenman@intel.com,
        weiyongjun1@huawei.com
Subject: [PATCH -next] iwlwifi: mvm: rfi: use kmemdup() to replace kzalloc + memcpy
Date:   Wed, 27 Oct 2021 14:58:40 +0800
Message-Id: <1635317920-84725-1-git-send-email-cuibixuan@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix memdup.cocci warning:
./drivers/net/wireless/intel/iwlwifi/mvm/rfi.c:110:8-15: WARNING
opportunity for kmemdup

Signed-off-by: Bixuan Cui <cuibixuan@linux.alibaba.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rfi.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
index 4434421..1954b4c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rfi.c
@@ -107,12 +107,10 @@ struct iwl_rfi_freq_table_resp_cmd *iwl_rfi_get_freq_table(struct iwl_mvm *mvm)
 	if (WARN_ON_ONCE(iwl_rx_packet_payload_len(cmd.resp_pkt) != resp_size))
 		return ERR_PTR(-EIO);
 
-	resp = kzalloc(resp_size, GFP_KERNEL);
+	resp = kmemdup(cmd.resp_pkt->data, resp_size, GFP_KERNEL);
 	if (!resp)
 		return ERR_PTR(-ENOMEM);
 
-	memcpy(resp, cmd.resp_pkt->data, resp_size);
-
 	iwl_free_resp(&cmd);
 	return resp;
 }
-- 
1.8.3.1

