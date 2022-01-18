Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3FBB4919C3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240902AbiARCz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:55:58 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35356 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344765AbiARCnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:43:42 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 22F02612E8;
        Tue, 18 Jan 2022 02:43:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67338C36AEF;
        Tue, 18 Jan 2022 02:43:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473819;
        bh=Rcuhfr3EhMSupVSrIEOucmPjHZuZ3iXMiHbm6mHJ26g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fEVZk/Ti2K0VaehFjMhMc7WO3rkfw2KtdT+W1AMVkFV5HgWOb4fCWlCunhhESgA0a
         qxIRaCiGGZ3blR/Q6OiyFE/HNoUi9Ey7gLkvYkCrGOQsVmfXUXOfphN7Zxz8sz5f4v
         0oqFkpa1BDcep/KAt/ha6HPOx8GqS6790+S1cNAThGFXPMMZQ5LidrwmM1zKQfL5TE
         sfxV0MwyqSCsAlhN7C5wE4fObZj/SuprPhpAg91SDY8DWVNYVmQ7gUA4dghsHhy7FB
         WORBXW+ORcec2KK66ZSGxUhCNU3kCVi3WvaeRee0QqV98liAXMqJdD8p6k/+QLc1Lv
         KoHQ/mokXOR8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 085/116] ath11k: Fix napi related hang
Date:   Mon, 17 Jan 2022 21:39:36 -0500
Message-Id: <20220118024007.1950576-85-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118024007.1950576-1-sashal@kernel.org>
References: <20220118024007.1950576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>

[ Upstream commit d943fdad7589653065be0e20aadc6dff37725ed4 ]

Similar to the same bug in ath10k, a napi disable w/out it being enabled
will hang forever.  I believe I saw this while trying rmmod after driver
had some failure on startup.  Fix it by keeping state on whether napi is
enabled or not.

And, remove un-used napi pointer in ath11k driver base struct.

Signed-off-by: Ben Greear <greearb@candelatech.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://lore.kernel.org/r/20200903195254.29379-1-greearb@candelatech.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/ahb.c  | 12 +++++++++---
 drivers/net/wireless/ath/ath11k/core.h |  2 +-
 drivers/net/wireless/ath/ath11k/pci.c  | 12 +++++++++---
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 430723c64adce..a17d10f5e355a 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -175,8 +175,11 @@ static void __ath11k_ahb_ext_irq_disable(struct ath11k_base *ab)
 
 		ath11k_ahb_ext_grp_disable(irq_grp);
 
-		napi_synchronize(&irq_grp->napi);
-		napi_disable(&irq_grp->napi);
+		if (irq_grp->napi_enabled) {
+			napi_synchronize(&irq_grp->napi);
+			napi_disable(&irq_grp->napi);
+			irq_grp->napi_enabled = false;
+		}
 	}
 }
 
@@ -300,7 +303,10 @@ static void ath11k_ahb_ext_irq_enable(struct ath11k_base *ab)
 	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		napi_enable(&irq_grp->napi);
+		if (!irq_grp->napi_enabled) {
+			napi_enable(&irq_grp->napi);
+			irq_grp->napi_enabled = true;
+		}
 		ath11k_ahb_ext_grp_enable(irq_grp);
 	}
 }
diff --git a/drivers/net/wireless/ath/ath11k/core.h b/drivers/net/wireless/ath/ath11k/core.h
index c8e36251068c9..d2f2898d17b49 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -124,6 +124,7 @@ struct ath11k_ext_irq_grp {
 	u32 num_irq;
 	u32 grp_id;
 	u64 timestamp;
+	bool napi_enabled;
 	struct napi_struct napi;
 	struct net_device napi_ndev;
 };
@@ -687,7 +688,6 @@ struct ath11k_base {
 	u32 wlan_init_status;
 	int irq_num[ATH11K_IRQ_NUM_MAX];
 	struct ath11k_ext_irq_grp ext_irq_grp[ATH11K_EXT_IRQ_GRP_NUM_MAX];
-	struct napi_struct *napi;
 	struct ath11k_targ_cap target_caps;
 	u32 ext_service_bitmap[WMI_SERVICE_EXT_BM_SIZE];
 	bool pdevs_macaddr_valid;
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index d7eb6b7160bb4..105e344240c10 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -416,8 +416,11 @@ static void __ath11k_pci_ext_irq_disable(struct ath11k_base *sc)
 
 		ath11k_pci_ext_grp_disable(irq_grp);
 
-		napi_synchronize(&irq_grp->napi);
-		napi_disable(&irq_grp->napi);
+		if (irq_grp->napi_enabled) {
+			napi_synchronize(&irq_grp->napi);
+			napi_disable(&irq_grp->napi);
+			irq_grp->napi_enabled = false;
+		}
 	}
 }
 
@@ -436,7 +439,10 @@ static void ath11k_pci_ext_irq_enable(struct ath11k_base *ab)
 	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		napi_enable(&irq_grp->napi);
+		if (!irq_grp->napi_enabled) {
+			napi_enable(&irq_grp->napi);
+			irq_grp->napi_enabled = true;
+		}
 		ath11k_pci_ext_grp_enable(irq_grp);
 	}
 }
-- 
2.34.1

