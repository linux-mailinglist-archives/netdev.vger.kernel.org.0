Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25EB16DF0C5
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 11:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbjDLJn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 05:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbjDLJns (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 05:43:48 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF1278691;
        Wed, 12 Apr 2023 02:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681292616; x=1712828616;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mhGhk0aFNDU+nvi/Zr0WQsY6I/0lnGV4GKGpzNN0N7A=;
  b=BSyv0eOEt3UXL2jf3IBcc9FBTfPmmjHBAqOuptMPOHxhWNnDIp2NtxnW
   db7eNNM6PCOH+qhyAuaWJaY4ijjVtwlODFa+JnzFxnKwAitamWhTNS12Y
   QY7meXqSoJa1Yvtz0BKCsEAk/HVzpqk4Fz8yRnoA7DUrd7GVVWFaxoSBO
   mbRhoeEJaC271MpPNTeQSztZAOorXjeqfvYNsyR1ticWucFlpPdrImfON
   Ux5uWaazbC99GjMC57/N2sSpmBUhx6oJjB2DFoZWxQWZAmGjnD3h/LDaz
   YCHBtKUvmnAPeA9WoS9LCC6+9lgIJtaZLazPlAo21pyDsQ/OxAO1DHptm
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="346526426"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="346526426"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 02:43:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="682430956"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="682430956"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by orsmga007.jf.intel.com with ESMTP; 12 Apr 2023 02:43:30 -0700
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
        Stanislav Fomichev <sdf@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net-next v3 3/4] net: stmmac: add Rx HWTS metadata to XDP receive pkt
Date:   Wed, 12 Apr 2023 17:42:34 +0800
Message-Id: <20230412094235.589089-4-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230412094235.589089-1-yoong.siang.song@intel.com>
References: <20230412094235.589089-1-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add receive hardware timestamp metadata support via kfunc to XDP receive
packets.

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  3 +++
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 26 ++++++++++++++++++-
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index ac8ccf851708..826ac0ec88c6 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -94,6 +94,9 @@ struct stmmac_rx_buffer {
 
 struct stmmac_xdp_buff {
 	struct xdp_buff xdp;
+	struct stmmac_priv *priv;
+	struct dma_desc *p;
+	struct dma_desc *np;
 };
 
 struct stmmac_rx_queue {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f7bbdf04d20c..ed660927b628 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5315,10 +5315,15 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 			xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
 			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
-					 buf->page_offset, buf1_len, false);
+					 buf->page_offset, buf1_len, true);
 
 			pre_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
 				  buf->page_offset;
+
+			ctx.priv = priv;
+			ctx.p = p;
+			ctx.np = np;
+
 			skb = stmmac_xdp_run_prog(priv, &ctx.xdp);
 			/* Due xdp_adjust_tail: DMA sync for_device
 			 * cover max len CPU touch
@@ -7071,6 +7076,23 @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
 	}
 }
 
+static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *timestamp)
+{
+	const struct stmmac_xdp_buff *ctx = (void *)_ctx;
+
+	*timestamp = 0;
+	stmmac_get_rx_hwtstamp(ctx->priv, ctx->p, ctx->np, timestamp);
+
+	if (*timestamp)
+		return 0;
+
+	return -ENODATA;
+}
+
+static const struct xdp_metadata_ops stmmac_xdp_metadata_ops = {
+	.xmo_rx_timestamp		= stmmac_xdp_rx_timestamp,
+};
+
 /**
  * stmmac_dvr_probe
  * @device: device pointer
@@ -7178,6 +7200,8 @@ int stmmac_dvr_probe(struct device *device,
 
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
+	ndev->xdp_metadata_ops = &stmmac_xdp_metadata_ops;
+
 	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_RXCSUM;
 	ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-- 
2.34.1

