Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E83BA1065DE
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 07:28:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727617AbfKVFuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 00:50:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727602AbfKVFuT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Nov 2019 00:50:19 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C926320748;
        Fri, 22 Nov 2019 05:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401818;
        bh=YxOwail4Tn4iKsO6SwLLJfbsBO8zDbkTETDTiTByHgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RFeu8rFHfcXcHUekn54E6G3YOKi1nFC18WjaeikesjR9pZetuI7Z2VaI7vBQJlynQ
         QFHuJLJzUWeNjqRRBXQqjC094X+t2RqTOahCYmwAb9vW9V/uKDF2I/gDBHzaFaGB/J
         KxyuHExEOTY2vY+rZ22NxE5F6pvmE06HgZfMPiLk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 062/219] iwlwifi: pcie: set cmd_len in the correct place
Date:   Fri, 22 Nov 2019 00:46:34 -0500
Message-Id: <20191122054911.1750-55-sashal@kernel.org>
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

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 956343a61226e1af3d146386f70a059feb567d0c ]

command len is set too early in the code, since when building
AMSDU, the size changes. This causes the byte count table to
have the wrong size.

Fixes: a0ec0169b7a9 ("iwlwifi: support new tx api")
Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/intel/iwlwifi/pcie/tx-gen2.c | 24 +++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
index b99f33ff91230..a9e42f0437ccb 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c
@@ -555,18 +555,6 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 
 	spin_lock(&txq->lock);
 
-	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
-		struct iwl_tx_cmd_gen3 *tx_cmd_gen3 =
-			(void *)dev_cmd->payload;
-
-		cmd_len = le16_to_cpu(tx_cmd_gen3->len);
-	} else {
-		struct iwl_tx_cmd_gen2 *tx_cmd_gen2 =
-			(void *)dev_cmd->payload;
-
-		cmd_len = le16_to_cpu(tx_cmd_gen2->len);
-	}
-
 	if (iwl_queue_space(trans, txq) < txq->high_mark) {
 		iwl_stop_queue(trans, txq);
 
@@ -604,6 +592,18 @@ int iwl_trans_pcie_gen2_tx(struct iwl_trans *trans, struct sk_buff *skb,
 		return -1;
 	}
 
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560) {
+		struct iwl_tx_cmd_gen3 *tx_cmd_gen3 =
+			(void *)dev_cmd->payload;
+
+		cmd_len = le16_to_cpu(tx_cmd_gen3->len);
+	} else {
+		struct iwl_tx_cmd_gen2 *tx_cmd_gen2 =
+			(void *)dev_cmd->payload;
+
+		cmd_len = le16_to_cpu(tx_cmd_gen2->len);
+	}
+
 	/* Set up entry for this TFD in Tx byte-count array */
 	iwl_pcie_gen2_update_byte_tbl(trans_pcie, txq, cmd_len,
 				      iwl_pcie_gen2_get_num_tbs(trans, tfd));
-- 
2.20.1

