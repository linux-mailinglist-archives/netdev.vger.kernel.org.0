Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF0456D8CDE
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 03:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbjDFBku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 21:40:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233074AbjDFBkt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 21:40:49 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92EDA7EEF;
        Wed,  5 Apr 2023 18:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680745240; x=1712281240;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DCavWhtg2E8IoulfYWNZX/tJY4eyp3ElFmAFgZG+SzY=;
  b=aQGJUMOm4ftVKlRmYsGKQlAvPcHfc3tnXIx3gQaS8WeHNO2XUBdM7Aqx
   u565iabHtw7cwOGCiPNvjIFap/JuA8DXHIDkjHajubhTGk0hQQATbG6j/
   b+fPgVgqY2sNUfW9YX+NBqVki/cb07cTki40K7yHGUK7xjYSnWB+m9vwz
   TeDJbaco/xExYgNKKcBAuvFlhXXasVAro/KkA8Rz56dyf0wJN1sghbGFb
   NUmnyG9ym9kK9hUDZ101WBGyjAK30U/mC6Xjsp1RuMZC4hVLvDi3/HqLm
   cr5X8hneRtl50rOPih59gqfjkOD2h6eesie1U8FJvFo29j0VkipnvIb/Z
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="322262722"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="322262722"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Apr 2023 18:40:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10671"; a="810817453"
X-IronPort-AV: E=Sophos;i="5.98,322,1673942400"; 
   d="scan'208";a="810817453"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by orsmga004.jf.intel.com with ESMTP; 05 Apr 2023 18:40:34 -0700
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
        Christian Marangi <ansuelsmth@gmail.com>,
        Alexander Duyck <alexanderduyck@fb.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net v2 1/1] net: stmmac: Add queue reset into stmmac_xdp_open() function
Date:   Thu,  6 Apr 2023 09:40:04 +0800
Message-Id: <20230406014004.3726672-1-yoong.siang.song@intel.com>
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

v2: Add reviewed-by tag

Fixes: f9ec5723c3db ("net: ethernet: stmicro: stmmac: move queue reset to dedicated functions")
Cc: <stable@vger.kernel.org> # 6.0+
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
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

