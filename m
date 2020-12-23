Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DB92E15C8
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 03:59:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731080AbgLWCxW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 21:53:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:50010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729256AbgLWCVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 21:21:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27AE22333F;
        Wed, 23 Dec 2020 02:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608690034;
        bh=YeXqw5xi1gALHucOZiATwzeu2KtvzLknT2hatzq7bZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TkHJZ8gxzlazvdp4BI+7vmN7wjbEsZrDT+bZfoUkPrtQJecMU7Zz9Keirgxul7D6H
         tROLPPeWCNPZAybz2Xh7JCgiqQdyWRYnHNQnMFN4JqfJONVe/So4BUsZd2vhYlBbAn
         p8dNybUauqy66yjomOyCIryf3OomNCPGs6WZYIe7bw3B9yKaXXCMBiZRVFfOTaGT+G
         aIJFWgGIKzSuPwFxtXpL4oiObmJ5mMttERJEWVS1/4bA8fgD8NzU3cb+Qe6L105tCf
         WL3fFXuqV7uAWAwvLSftq1CrODfoRtLbk7s80tCtcpdB2ZXknmMSwnmueH+QQ8Sb8m
         0vBzH2hCyldsA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 109/130] iwlwifi: mvm: fix 22000 series driver NMI
Date:   Tue, 22 Dec 2020 21:17:52 -0500
Message-Id: <20201223021813.2791612-109-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 9e8338ad17eb8976edd5d2def516e4b3346a4470 ]

For triggering an NMI in the firmware, we should only set BIT(24)
in the corresponding register, not the entire mask that's usable
by the driver.

This currently doesn't matter because the firmware only enables
BIT(24), but we'll start using BIT(25) for other purposes with an
upcoming API change.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20201209231352.2f982365d085.Id09daabfd331ba9e120abcbbedd2ad6448902ed0@changeid
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/intel/iwlwifi/iwl-io.c   | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-prph.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-io.c b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
index 1b7414bf7bef2..2144c1f745337 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-io.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-io.c
@@ -309,7 +309,7 @@ void iwl_force_nmi(struct iwl_trans *trans)
 			       DEVICE_SET_NMI_VAL_DRV);
 	else if (trans->trans_cfg->device_family < IWL_DEVICE_FAMILY_AX210)
 		iwl_write_umac_prph(trans, UREG_NIC_SET_NMI_DRIVER,
-				UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER_MSK);
+				UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER);
 	else
 		iwl_write_umac_prph(trans, UREG_DOORBELL_TO_ISR6,
 				    UREG_DOORBELL_TO_ISR6_NMI_BIT);
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
index 23c25a7665f27..80b3fca8f2328 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-prph.h
@@ -111,7 +111,7 @@
 #define DEVICE_SET_NMI_VAL_DRV BIT(7)
 /* Device NMI register and value for 9000 family and above hw's */
 #define UREG_NIC_SET_NMI_DRIVER 0x00a05c10
-#define UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER_MSK 0xff000000
+#define UREG_NIC_SET_NMI_DRIVER_NMI_FROM_DRIVER BIT(24)
 
 /* Shared registers (0x0..0x3ff, via target indirect or periphery */
 #define SHR_BASE	0x00a10000
-- 
2.27.0

