Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDCAF18A44A
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 21:53:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgCRUx3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 16:53:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:52296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726894AbgCRUx0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:26 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36EC420724;
        Wed, 18 Mar 2020 20:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564805;
        bh=rRNLqGDe4Hh9VMNxMXiXDvn4zvX3xSXrJ2j8vKZEdL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vC4ytYBFLDVWKAqBMv1QVIPSr6hqii9qKgtApNOCWFaw+T7NxBLQcGf12oSwixEK1
         XquXGk4+woE8W7sf5NoKd8EiYnWF6xjOjcD7g2HTler+UxC+zjHCVqp3iRiq04B6Rd
         BthlzDu/w3U9Vt1sbPimLWfI2Bq4bAj+yFBI+If8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Moulding <dmoulding@me.com>, Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 03/84] iwlwifi: mvm: Do not require PHY_SKU NVM section for 3168 devices
Date:   Wed, 18 Mar 2020 16:52:00 -0400
Message-Id: <20200318205321.16066-3-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200318205321.16066-1-sashal@kernel.org>
References: <20200318205321.16066-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Moulding <dmoulding@me.com>

[ Upstream commit a9149d243f259ad8f02b1e23dfe8ba06128f15e1 ]

The logic for checking required NVM sections was recently fixed in
commit b3f20e098293 ("iwlwifi: mvm: fix NVM check for 3168
devices"). However, with that fixed the else is now taken for 3168
devices and within the else clause there is a mandatory check for the
PHY_SKU section. This causes the parsing to fail for 3168 devices.

The PHY_SKU section is really only mandatory for the IWL_NVM_EXT
layout (the phy_sku parameter of iwl_parse_nvm_data is only used when
the NVM type is IWL_NVM_EXT). So this changes the PHY_SKU section
check so that it's only mandatory for IWL_NVM_EXT.

Fixes: b3f20e098293 ("iwlwifi: mvm: fix NVM check for 3168 devices")
Signed-off-by: Dan Moulding <dmoulding@me.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
index 46128a2a9c6e1..e98ce380c7b91 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/nvm.c
@@ -308,7 +308,8 @@ iwl_parse_nvm_sections(struct iwl_mvm *mvm)
 		}
 
 		/* PHY_SKU section is mandatory in B0 */
-		if (!mvm->nvm_sections[NVM_SECTION_TYPE_PHY_SKU].data) {
+		if (mvm->trans->cfg->nvm_type == IWL_NVM_EXT &&
+		    !mvm->nvm_sections[NVM_SECTION_TYPE_PHY_SKU].data) {
 			IWL_ERR(mvm,
 				"Can't parse phy_sku in B0, empty sections\n");
 			return NULL;
-- 
2.20.1

