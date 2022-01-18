Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB1DF4919DD
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 03:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352048AbiARC4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 21:56:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344608AbiARCq6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 21:46:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04F0C06127B;
        Mon, 17 Jan 2022 18:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57706B81232;
        Tue, 18 Jan 2022 02:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C28C36B04;
        Tue, 18 Jan 2022 02:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473521;
        bh=k1sPTXp/OUsKfF7bCMnLd5fIDVSHA+u/eKcXEsG0V5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHxgp+HPWrblSg3RVCi5LgTzR1IdgRLKWEJ4BOCeZJB6GTQbRCfiBSqda48Q/7q2V
         Efb/Ml375lZWDC/tl7rgOnEyDhbjX7yOq1utoUvJgggvPT8QBYPjeG4Y4ynQLQ2/4O
         8SJYvinJER3rPbM+dwlFE0+3jJM0GhO/1TxU/zbvxDphp2isA0gxeYTELC+70jduuZ
         a8Z/GjZsLHMtZ08TaSJnn4SZho3ICmFo7Hf2itnu3aDGUFxn/3br19jpV9iSwyDUsE
         889uHFEFEZwo2Wftdv4/N8mqT0Kim6TzqJasKVgDw+i7ZVxLkxsYbQM1YJdbxH1nRV
         ibIbsubMgP0ig==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ben Greear <greearb@candelatech.com>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Sasha Levin <sashal@kernel.org>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 146/188] ath11k: Fix napi related hang
Date:   Mon, 17 Jan 2022 21:31:10 -0500
Message-Id: <20220118023152.1948105-146-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index 8c9c781afc3e5..b9939057b7baf 100644
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
index 018fb2385f2a3..10d2436f553f6 100644
--- a/drivers/net/wireless/ath/ath11k/core.h
+++ b/drivers/net/wireless/ath/ath11k/core.h
@@ -132,6 +132,7 @@ struct ath11k_ext_irq_grp {
 	u32 num_irq;
 	u32 grp_id;
 	u64 timestamp;
+	bool napi_enabled;
 	struct napi_struct napi;
 	struct net_device napi_ndev;
 };
@@ -701,7 +702,6 @@ struct ath11k_base {
 	u32 wlan_init_status;
 	int irq_num[ATH11K_IRQ_NUM_MAX];
 	struct ath11k_ext_irq_grp ext_irq_grp[ATH11K_EXT_IRQ_GRP_NUM_MAX];
-	struct napi_struct *napi;
 	struct ath11k_targ_cap target_caps;
 	u32 ext_service_bitmap[WMI_SERVICE_EXT_BM_SIZE];
 	bool pdevs_macaddr_valid;
diff --git a/drivers/net/wireless/ath/ath11k/pci.c b/drivers/net/wireless/ath/ath11k/pci.c
index 5abb38cc3b55f..81d0eaa13adeb 100644
--- a/drivers/net/wireless/ath/ath11k/pci.c
+++ b/drivers/net/wireless/ath/ath11k/pci.c
@@ -632,8 +632,11 @@ static void __ath11k_pci_ext_irq_disable(struct ath11k_base *sc)
 
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
 
@@ -652,7 +655,10 @@ static void ath11k_pci_ext_irq_enable(struct ath11k_base *ab)
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

