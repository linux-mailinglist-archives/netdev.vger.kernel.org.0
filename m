Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFA96D57AE
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 06:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjDDEtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 00:49:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjDDEs7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 00:48:59 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06762184;
        Mon,  3 Apr 2023 21:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680583739; x=1712119739;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=atNBv19nqFsJx7Jsp8sn5eYxALmhvo0gO3LFEzJDCZc=;
  b=CwSjBK9kndC7sAbzC2ywHWBHuaNPOfZ68OHIo/KllJXcSHL8zsvMjWC/
   /CwGyKg51GosfPwFKK4chEuoOZuLJFHxfWDc1MJeRfVurcjx1ed2zDFPm
   dBICDDJtzyjSjvopordrdEyfiS0Wyf7hflJNxhoIa3bxlxMK40QR0h4IO
   jjNICJSa4tbJKO4rTwIBxrjnsJmMiXpBKiobdnebvaq9LlbW9JEu8B6dz
   tOlR5Iao9OYoPfb2m5War6OSE3p6lFiALlrW0HHTpJtUR5GB5HpX7mUd5
   E3XMFjaz2aK/qOLdEecEa4lLRxuX21tHB29ihzYBUmAvdvCGCksN+hXOT
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="321742175"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="321742175"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Apr 2023 21:48:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10669"; a="775496240"
X-IronPort-AV: E=Sophos;i="5.98,316,1673942400"; 
   d="scan'208";a="775496240"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Apr 2023 21:48:54 -0700
From:   Song Yoong Siang <yoong.siang.song@intel.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Christian Marangi <ansuelsmth@gmail.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net 1/1] net: stmmac: Add queue reset into stmmac_xdp_open() function
Date:   Tue,  4 Apr 2023 12:48:23 +0800
Message-Id: <20230404044823.3226144-1-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.5 required=5.0 tests=AC_FROM_MANY_DOTS,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Queue reset was moved out from __init_dma_rx_desc_rings() and
__init_dma_tx_desc_rings() functions. Thus, the driver fails to transmit
and receive packet after XDP prog setup.

This commit adds the missing queue reset into stmmac_xdp_open() function.

Fixes: f9ec5723c3db ("net: ethernet: stmicro: stmmac: move queue reset to dedicated functions")
Cc: <stable@vger.kernel.org> # 6.0+
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3e5bbfe3c41b..e4c27eb17bd2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -6630,6 +6630,8 @@ int stmmac_xdp_open(struct net_device *dev)
 		goto init_error;
 	}
 
+	stmmac_reset_queues_param(priv);
+
 	/* DMA CSR Channel configuration */
 	for (chan = 0; chan < dma_csr_ch; chan++) {
 		stmmac_init_chan(priv, priv->ioaddr, priv->plat->dma_cfg, chan);
-- 
2.34.1

