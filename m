Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFA5F65A2
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 04:09:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbfKJCov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 21:44:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727668AbfKJCou (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Nov 2019 21:44:50 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E1D4421655;
        Sun, 10 Nov 2019 02:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573353889;
        bh=yN32PYfjsyUrcNe1jxL8v16H/2fHGlbsjA34/dPKFko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2kEZbDvG2YsQ8CZNygGSJ5hIZ48/g7dQKZ+a+KBcIcQQT+kAsyXcL9cpeoJMrcro
         kn4IPu8u6IWfOUrUgt1NK5pp6OvVZITW7vomqSSwBDj2A0b97Fiqr6+kpxx3U7b96V
         L/GVqwupyx7+92cknUxTqVm6auZfGMMttc12d6vU=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 162/191] iwlwifi: pcie: read correct prph address for newer devices
Date:   Sat,  9 Nov 2019 21:39:44 -0500
Message-Id: <20191110024013.29782-162-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191110024013.29782-1-sashal@kernel.org>
References: <20191110024013.29782-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sara Sharon <sara.sharon@intel.com>

[ Upstream commit 84fb372c892e231e9a2ffdaa5c2df52d94aa536c ]

For newer devices we have higher range of periphery
addresses. Currently it is masked out, so we end up
reading another address.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 7d319b6863feb..954f932e9c88e 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -1830,18 +1830,30 @@ static u32 iwl_trans_pcie_read32(struct iwl_trans *trans, u32 ofs)
 	return readl(IWL_TRANS_GET_PCIE_TRANS(trans)->hw_base + ofs);
 }
 
+static u32 iwl_trans_pcie_prph_msk(struct iwl_trans *trans)
+{
+	if (trans->cfg->device_family >= IWL_DEVICE_FAMILY_22560)
+		return 0x00FFFFFF;
+	else
+		return 0x000FFFFF;
+}
+
 static u32 iwl_trans_pcie_read_prph(struct iwl_trans *trans, u32 reg)
 {
+	u32 mask = iwl_trans_pcie_prph_msk(trans);
+
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_RADDR,
-			       ((reg & 0x000FFFFF) | (3 << 24)));
+			       ((reg & mask) | (3 << 24)));
 	return iwl_trans_pcie_read32(trans, HBUS_TARG_PRPH_RDAT);
 }
 
 static void iwl_trans_pcie_write_prph(struct iwl_trans *trans, u32 addr,
 				      u32 val)
 {
+	u32 mask = iwl_trans_pcie_prph_msk(trans);
+
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WADDR,
-			       ((addr & 0x000FFFFF) | (3 << 24)));
+			       ((addr & mask) | (3 << 24)));
 	iwl_trans_pcie_write32(trans, HBUS_TARG_PRPH_WDAT, val);
 }
 
-- 
2.20.1

