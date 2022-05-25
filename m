Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (unknown [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4780533BCD
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242916AbiEYLbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiEYLbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:31:33 -0400
Received: from smtp-relay-canonical-0.canonical.com (smtp-relay-canonical-0.canonical.com [185.125.188.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 777FD87210;
        Wed, 25 May 2022 04:31:32 -0700 (PDT)
Received: from HP-EliteBook-840-G7.. (1-171-87-66.dynamic-ip.hinet.net [1.171.87.66])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id C14113F1D5;
        Wed, 25 May 2022 11:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1653478291;
        bh=Lja71MctIRXwGgOSudtNTbu6Ufr7/x63mASCBfOq7z0=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=TyUv5eeB7SV23bnLRjArdv3s4sUp8YZEXbIYGY9G2Z8sXeIsOU99w1G+IzwYUlmyo
         OZlPIAZSvW68JWXD+UrvDlAJ8SOfmyXzLtcyvG1TYOvDI4kDU0ta6p1SbHc36gKCcr
         dswgD2GLlu4Xe286Psaa+1ZcyMOdz4AcI9AH1HxkFgU9G4o+oulZL5Ip3Me6snBO6N
         78c/Tuy5D9NhP/Pc9DU3ZR64Z/ouFxjDExyBYERab2TjAmAQvNztLQXijHTUC74IXZ
         mlELuzfUoQ775yvJsvP79IP7+8/auvU5HPLUUXPs77m6TFfSP0Z0s/ol/19i8aF7HX
         6pDimTGnS8sbQ==
From:   Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com
Cc:     mateusz.palczewski@intel.com,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Carolyn Wyborny <carolyn.wyborny@intel.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] igb: Make DMA faster when CPU is active on the PCIe link
Date:   Wed, 25 May 2022 19:31:13 +0800
Message-Id: <20220525113113.171746-2-kai.heng.feng@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220525113113.171746-1-kai.heng.feng@canonical.com>
References: <20220525113113.171746-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Intel I210 on some Intel Alder Lake platforms can only achieve ~750Mbps
Tx speed via iperf. The RR2DCDELAY shows around 0x2xxx DMA delay, which
will be significantly lower when 1) ASPM is disabled or 2) SoC package
c-state stays above PC3. When the RR2DCDELAY is around 0x1xxx the Tx
speed can reach to ~950Mbps.

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

Fixes: b6e0c419f040 ("igb: Move DMA Coalescing init code to separate function.")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 68be2976f539f..c0d93fd19c1ed 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -9898,11 +9898,10 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
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
 
@@ -9935,7 +9934,6 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
 			/* Disable BMC-to-OS Watchdog Enable */
 			if (hw->mac.type != e1000_i354)
 				reg &= ~E1000_DMACR_DC_BMC2OSW_EN;
-
 			wr32(E1000_DMACR, reg);
 
 			/* no lower threshold to disable
@@ -9952,12 +9950,12 @@ static void igb_init_dmac(struct igb_adapter *adapter, u32 pba)
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

