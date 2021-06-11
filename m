Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 364DC3A3E6B
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 10:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhFKI74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 04:59:56 -0400
Received: from mga18.intel.com ([134.134.136.126]:26241 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231400AbhFKI7y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Jun 2021 04:59:54 -0400
IronPort-SDR: ynfCKEroylfuj3xLxWO/YFtcEg+KJNMJfqIzXhbSxii1uVNCwcwRAkWOKOb8l2lwvhHJY4HM4/
 qyteXpHfIzlg==
X-IronPort-AV: E=McAfee;i="6200,9189,10011"; a="192802163"
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="192802163"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2021 01:57:56 -0700
IronPort-SDR: npVUMD7Ug39OKV8mQBP2p8S6y05DhCrJgUGROtC6C9qLuGKTFN6wPgCeFaoHpm+9HeH+9XzICC
 TkH6Yq+ddVOA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,265,1616482800"; 
   d="scan'208";a="620329231"
Received: from linux.intel.com ([10.54.29.200])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2021 01:57:56 -0700
Received: from glass.png.intel.com (glass.png.intel.com [10.158.65.69])
        by linux.intel.com (Postfix) with ESMTP id E705B5807AA;
        Fri, 11 Jun 2021 01:57:53 -0700 (PDT)
From:   Wong Vee Khee <vee.khee.wong@linux.intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v1 1/1] net: stmmac: Fix potential integer overflow
Date:   Fri, 11 Jun 2021 17:02:38 +0800
Message-Id: <20210611090238.1157557-1-vee.khee.wong@linux.intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The commit d96febedfde2 ("net: stmmac: arrange Tx tail pointer update
to stmmac_flush_tx_descriptors") introduced the following coverity
warning:-

  1. Unintentional integer overflow (OVERFLOW_BEFORE_WIDEN)
     overflow_before_widen: Potentially overflowing expression
     'tx_q->cur_tx * desc_size' with type 'unsigned int' (32 bits,
     unsigned) is evaluated using 32-bit arithmetic, and then used in a
     context that expects an expression of type dma_addr_t (64 bits,
     unsigned).

Fixed this by assigning tx_tail_addr to dma_addr_t type, as dma_addr_t
datatype is decided by CONFIG_ARCH_DMA_ADDR_T_64_BIT.

Fixes: d96febedfde2 ("net: stmmac: arrange Tx tail pointer update to stmmac_flush_tx_descriptors")
Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index fd7212afc543..6655cb8e24cf 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -75,7 +75,7 @@ struct stmmac_tx_queue {
 	unsigned int cur_tx;
 	unsigned int dirty_tx;
 	dma_addr_t dma_tx_phy;
-	u32 tx_tail_addr;
+	dma_addr_t tx_tail_addr;
 	u32 mss;
 };
 
-- 
2.25.1

