Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42544592DF
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240161AbhKVQWw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:22:52 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:42230
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232643AbhKVQWv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:22:51 -0500
Received: from HP-EliteBook-840-G7.. (1-171-213-156.dynamic-ip.hinet.net [1.171.213.156])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 0B3C34019C;
        Mon, 22 Nov 2021 16:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1637597983;
        bh=kQIunFclls2DTqedr2lGZECG1ePbf8SzkRz3Fmwtfks=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=MiKUKAt7ISqfEM4c2v7wqi2Kq2gNewEFbb2hs+1amq5lUXYNv3UzKNAvpx9/I7onY
         5giZs1j7YE7LL9FlQasa4QoDlXSTSzCycINK1Ww0pFSKrKS5s3MW7i1O6WrO8B26Bm
         5ZQulySnlzT6rqpp9CX6KtqHlYkjfcr458IQzzcKJQD0tyZ4fYIJ+QjZ12xLRff73C
         x1Hzmb4gwusLzs24BiGzl3P3KmDIMd0nCBpMXTdDUqxw+3UfjtTIoAdT1VGVH+8KwB
         vPMfL+ghWW//r5geSrG/UhSrUaAabSEv5qlc2EiZicblO081RpsRdWJiUNR8AhqV3V
         utGRxQmfTtHRA==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     sasha.neftin@intel.com, acelan.kao@canonical.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Revert "e1000e: Add polling mechanism to indicate CSME DPG exit"
Date:   Tue, 23 Nov 2021 00:19:26 +0800
Message-Id: <20211122161927.874291-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211122161927.874291-1-kai.heng.feng@canonical.com>
References: <20211122161927.874291-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit ef407b86d3cc7ab7ad37658c1c7a094cb8f3b6b4.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=214821
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/e1000e/ich8lan.h |  1 -
 drivers/net/ethernet/intel/e1000e/netdev.c  | 24 ---------------------
 drivers/net/ethernet/intel/e1000e/regs.h    |  1 -
 3 files changed, 26 deletions(-)

diff --git a/drivers/net/ethernet/intel/e1000e/ich8lan.h b/drivers/net/ethernet/intel/e1000e/ich8lan.h
index 2504b11c3169f..1dfa1d28dae64 100644
--- a/drivers/net/ethernet/intel/e1000e/ich8lan.h
+++ b/drivers/net/ethernet/intel/e1000e/ich8lan.h
@@ -41,7 +41,6 @@
 #define E1000_FWSM_WLOCK_MAC_MASK	0x0380
 #define E1000_FWSM_WLOCK_MAC_SHIFT	7
 #define E1000_FWSM_ULP_CFG_DONE		0x00000400	/* Low power cfg done */
-#define E1000_EXFWSM_DPG_EXIT_DONE	0x00000001
 
 /* Shared Receive Address Registers */
 #define E1000_SHRAL_PCH_LPT(_i)		(0x05408 + ((_i) * 8))
diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
index e16b7c0d98089..242314809e59c 100644
--- a/drivers/net/ethernet/intel/e1000e/netdev.c
+++ b/drivers/net/ethernet/intel/e1000e/netdev.c
@@ -6483,10 +6483,8 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
 static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 {
 	struct e1000_hw *hw = &adapter->hw;
-	bool firmware_bug = false;
 	u32 mac_data;
 	u16 phy_data;
-	u32 i = 0;
 
 	if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID) {
 		/* Request ME unconfigure the device from S0ix */
@@ -6494,28 +6492,6 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
 		mac_data &= ~E1000_H2ME_START_DPG;
 		mac_data |= E1000_H2ME_EXIT_DPG;
 		ew32(H2ME, mac_data);
-
-		/* Poll up to 2.5 seconds for ME to unconfigure DPG.
-		 * If this takes more than 1 second, show a warning indicating a
-		 * firmware bug
-		 */
-		while (!(er32(EXFWSM) & E1000_EXFWSM_DPG_EXIT_DONE)) {
-			if (i > 100 && !firmware_bug)
-				firmware_bug = true;
-
-			if (i++ == 250) {
-				e_dbg("Timeout (firmware bug): %d msec\n",
-				      i * 10);
-				break;
-			}
-
-			usleep_range(10000, 11000);
-		}
-		if (firmware_bug)
-			e_warn("DPG_EXIT_DONE took %d msec. This is a firmware bug\n",
-			       i * 10);
-		else
-			e_dbg("DPG_EXIT_DONE cleared after %d msec\n", i * 10);
 	} else {
 		/* Request driver unconfigure the device from S0ix */
 
diff --git a/drivers/net/ethernet/intel/e1000e/regs.h b/drivers/net/ethernet/intel/e1000e/regs.h
index 6c0cd8cab3ef2..8165ba2619a4d 100644
--- a/drivers/net/ethernet/intel/e1000e/regs.h
+++ b/drivers/net/ethernet/intel/e1000e/regs.h
@@ -213,7 +213,6 @@
 #define E1000_FACTPS	0x05B30	/* Function Active and Power State to MNG */
 #define E1000_SWSM	0x05B50	/* SW Semaphore */
 #define E1000_FWSM	0x05B54	/* FW Semaphore */
-#define E1000_EXFWSM	0x05B58	/* Extended FW Semaphore */
 /* Driver-only SW semaphore (not used by BOOT agents) */
 #define E1000_SWSM2	0x05B58
 #define E1000_FFLT_DBG	0x05F04	/* Debug Register */
-- 
2.32.0

