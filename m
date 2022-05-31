Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB53538A0A
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 04:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243661AbiEaCyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 22:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232746AbiEaCyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 22:54:10 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 710E88CCFB;
        Mon, 30 May 2022 19:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653965649; x=1685501649;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xShwcBv2sRwVhimzWAxcZ92MBKRwnzhim/YMvrCQgug=;
  b=SreQLANwSkLlNrh/2gOkLtBwXmAZCdu/cVcaQdJxnMAQzoassdfMkuJ4
   BWV/77HBX1Ymhf/unvYvKLur/ooUz7DVHcw+UzzbcO+zrPVxGtzrJhMGt
   6KqAj4cxfMP+RNoJnWMWrv/kAhGpuEmVNosm6x7BDK+xQCz0q33eBQ21G
   QdLpCwN6l3rNqdOxn8Ri9t6eMH232b125FaLa+Fr4RLeQlNT1LyNi8FtG
   Xxo3xcWtyhDxWdNjBfrKbmepkcE7GWx0SwIVNy1UIz3ot27AO0WK1Li3V
   c6tK7/H9LpopgPUi8vWEGFH7xw4TZyqDtmiwUveH6ff/F8yblZiHAmdYV
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="335777171"
X-IronPort-AV: E=Sophos;i="5.91,263,1647327600"; 
   d="scan'208";a="335777171"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 19:54:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,263,1647327600"; 
   d="scan'208";a="580888938"
Received: from pglc00495.png.intel.com ([10.221.239.178])
  by fmsmga007.fm.intel.com with ESMTP; 30 May 2022 19:54:06 -0700
From:   "Tham, Mun Yew" <mun.yew.tham@intel.com>
To:     Joyce Ooi <joyce.ooi@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tham@vger.kernel.org, Mun Yew <mun.yew.tham@intel.com>
Subject: [PATCH] net: eth: altera: set rx and tx ring size before init_dma call
Date:   Tue, 31 May 2022 10:51:17 +0800
Message-Id: <20220531025117.13822-1-mun.yew.tham@intel.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is more appropriate to set the rx and tx ring size before calling
the init function for the dma.

Signed-off-by: Tham, Mun Yew <mun.yew.tham@intel.com>
---
 drivers/net/ethernet/altera/altera_tse_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/altera/altera_tse_main.c b/drivers/net/ethernet/altera/altera_tse_main.c
index 1c00d719e5d7..ebfddad05e7e 100644
--- a/drivers/net/ethernet/altera/altera_tse_main.c
+++ b/drivers/net/ethernet/altera/altera_tse_main.c
@@ -1152,6 +1152,10 @@ static int tse_open(struct net_device *dev)
 	int i;
 	unsigned long int flags;
 
+	/* set tx and rx ring size */
+	priv->rx_ring_size = dma_rx_num;
+	priv->tx_ring_size = dma_tx_num;
+
 	/* Reset and configure TSE MAC and probe associated PHY */
 	ret = priv->dmaops->init_dma(priv);
 	if (ret != 0) {
@@ -1194,8 +1198,6 @@ static int tse_open(struct net_device *dev)
 	priv->dmaops->reset_dma(priv);
 
 	/* Create and initialize the TX/RX descriptors chains. */
-	priv->rx_ring_size = dma_rx_num;
-	priv->tx_ring_size = dma_tx_num;
 	ret = alloc_init_skbufs(priv);
 	if (ret) {
 		netdev_err(dev, "DMA descriptors initialization failed\n");
-- 
2.26.2

