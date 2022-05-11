Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8306952331F
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 14:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242359AbiEKM3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 08:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237854AbiEKM3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 08:29:12 -0400
Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 667081FD843;
        Wed, 11 May 2022 05:29:11 -0700 (PDT)
Received: from localhost.localdomain (unknown [10.101.196.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 908F44151F;
        Wed, 11 May 2022 12:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1652272150;
        bh=RvRGkbmZwsRxXLTPfCg6GAIzFml3B5IBzVyodoZxRPM=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=CIVeKnEBZvBtlQK7YFRYChmtSflJc+taUo5CkdUoDIrMySSjaOq5hcSq4ZPwANPjB
         AF+JgQCEVLMX8d0UtT4XL8caObBTCBQqYCsUwKpsXM4JoXFrWY7tvELe0cAGb9j6Fm
         OOyJ0OhjCB59X/S/PFeIWDCYjOo7DizbRLza76FUZYv9i7JoZxp0YhL1KccvIWGGM5
         lowfpiR/D7RqVczva4hZ5FN4kEFyzVFwlJABJJ2ZR6vNLEP/ebjX7N1bri5JmPrRLe
         s2RELGwMK77FZnQNjTXPYc57Nz05UGJTDQwSgsc0j8GdddTUPKOH6vNmRwi8RCClwL
         YB6NzKQEweRxQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] igb: Make DMA faster when CPU is active on the PCIe link
Date:   Wed, 11 May 2022 20:28:05 +0800
Message-Id: <20220511122806.2146847-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220511122806.2146847-1-kai.heng.feng@canonical.com>
References: <20220511122806.2146847-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We found Intel I210 can only achieve ~750Mbps Tx speed on some
platforms. The RR2DCDELAY shows around 0x2xxx DMA delay, which will be
significantly lower when 1) ASPM is disabled or 2) SoC package c-state
stays above PC3. When the RR2DCDELAY is around 0x1xxx the Tx speed can
reach to ~950Mbps.

According to the I210 datasheet "8.26.1 PCIe Misc. Register - PCIEMISC",
"DMA Idle Indication" doesn't seem to tie to DMA coalesce anymore, so
set it to 1b for "DMA is considered idle when there is no Rx or Tx AND
when there are no TLPs indicating that CPU is active detected on the
PCIe link (such as the host executes CSR or Configuration register read
or write operation)" and performing Tx should also fall under "active
CPU on PCIe link" case.

In addition to that, commit b6e0c419f040 ("igb: Move DMA Coalescing init
code to separate function.") seems to wrongly changed from enabling
E1000_PCIEMISC_LX_DECISION to disabling it, also fix that.

Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 34b33b21e0dcd..eca797dded429 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -9897,11 +9897,10 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 	struct e1000_hw *hw = &adapter->hw;
 	u32 dmac_thr;
 	u16 hwm;
+	u32 reg;
 
 	if (hw->mac.type > e1000_82580) {
 		if (adapter->flags & IGB_FLAG_DMAC) {
-			u32 reg;
-
 			/* force threshold to 0. */
 			wr32(E1000_DMCTXTH, 0);
 
@@ -9934,7 +9933,6 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			/* Disable BMC-to-OS Watchdog Enable */
 			if (hw->mac.type != e1000_i354)
 				reg &= ~E1000_DMACR_DC_BMC2OSW_EN;
-
 			wr32(E1000_DMACR, reg);
 
 			/* no lower threshold to disable
@@ -9951,12 +9949,12 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			 */
 			wr32(E1000_DMCTXTH, (IGB_MIN_TXPBSIZE -
 			     (IGB_TX_BUF_4096 + adapter->max_frame_size)) >> 6);
+		}
 
-			/* make low power state decision controlled
-			 * by DMA coal
-			 */
+		if (hw->mac.type >= e1000_i210 ||
+		    (adapter->flags & IGB_FLAG_DMAC)) {
 			reg = rd32(E1000_PCIEMISC);
-			reg &= ~E1000_PCIEMISC_LX_DECISION;
+			reg |= E1000_PCIEMISC_LX_DECISION;
 			wr32(E1000_PCIEMISC, reg);
 		} /* endif adapter->dmac is not disabled */
 	} else if (hw->mac.type == e1000_82580) {
-- 
2.34.1

