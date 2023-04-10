Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61BF96DC8DE
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 18:00:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230162AbjDJP7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 11:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbjDJP7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 11:59:00 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DAACE63;
        Mon, 10 Apr 2023 08:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681142325; x=1712678325;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=epNmJmT4mdsPOw/HzfxOribgjhbn4L4BH4c8uTIvlqY=;
  b=gc2pOgbNhpTR+cAfeCCZM3x5stRMceQ9GDHo5K0y4IOOIkfVTPzgVV+1
   Z3dTxq/+9GY6ssEFP5YKZKaypWITa3oPSOAAtyOVFrnPNkfhz5KM/Mek1
   iYxHvdLS2D9dwxZ7WPuqJDiGJVFnNZEA0j/xZ2vVKC4vZOnT1/PeVl4TF
   W39dW3nxV3vQdEGLS4waFPr9PqMYeAnIYdg49ejrWjzAExusXMY8p2Vxj
   VYMb33EWSni34x9SmLZGF8ebr8RuAgpzX+7eaqPfqTKFpw2UKQE6LSGGp
   Zqc54Oxi1cyn/qc7eRzW8zFCTf2QzanqIH+7tkILjtNPJ8d76OXym2+3q
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="343391789"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="343391789"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 08:58:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10676"; a="777601767"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="777601767"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by FMSMGA003.fm.intel.com with ESMTP; 10 Apr 2023 08:58:12 -0700
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
Subject: [PATCH net-next v2 3/4] net: stmmac: add Rx HWTS metadata to XDP receive pkt
Date:   Mon, 10 Apr 2023 23:57:21 +0800
Message-Id: <20230410155722.335908-4-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410155722.335908-1-yoong.siang.song@intel.com>
References: <20230410155722.335908-1-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add receive hardware timestamp metadata support via kfunc to XDP receive
packets.

Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac.h  |  1 +
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 24 +++++++++++++++++--
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac.h b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
index ac8ccf851708..760445275da8 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac.h
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac.h
@@ -94,6 +94,7 @@ struct stmmac_rx_buffer {
 
 struct stmmac_xdp_buff {
 	struct xdp_buff xdp;
+	ktime_t rx_hwts;
 };
 
 struct stmmac_rx_queue {
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f7bbdf04d20c..7f1c0c36de8c 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5307,6 +5307,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 			}
 		}
 
+		stmmac_get_rx_hwtstamp(priv, p, np, &ctx.rx_hwts);
+
 		if (!skb) {
 			unsigned int pre_len, sync_len;
 
@@ -5315,7 +5317,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 			xdp_init_buff(&ctx.xdp, buf_sz, &rx_q->xdp_rxq);
 			xdp_prepare_buff(&ctx.xdp, page_address(buf->page),
-					 buf->page_offset, buf1_len, false);
+					 buf->page_offset, buf1_len, true);
 
 			pre_len = ctx.xdp.data_end - ctx.xdp.data_hard_start -
 				  buf->page_offset;
@@ -5411,7 +5413,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		shhwtstamp = skb_hwtstamps(skb);
 		memset(shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
-		stmmac_get_rx_hwtstamp(priv, p, np, &shhwtstamp->hwtstamp);
+		shhwtstamp->hwtstamp = ctx.rx_hwts;
 
 		stmmac_rx_vlan(priv->dev, skb);
 		skb->protocol = eth_type_trans(skb, priv->dev);
@@ -7071,6 +7073,22 @@ void stmmac_fpe_handshake(struct stmmac_priv *priv, bool enable)
 	}
 }
 
+static int stmmac_xdp_rx_timestamp(const struct xdp_md *_ctx, u64 *timestamp)
+{
+	const struct stmmac_xdp_buff *ctx = (void *)_ctx;
+
+	if (ctx->rx_hwts) {
+		*timestamp = ctx->rx_hwts;
+		return 0;
+	}
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
@@ -7178,6 +7196,8 @@ int stmmac_dvr_probe(struct device *device,
 
 	ndev->netdev_ops = &stmmac_netdev_ops;
 
+	ndev->xdp_metadata_ops = &stmmac_xdp_metadata_ops;
+
 	ndev->hw_features = NETIF_F_SG | NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM |
 			    NETIF_F_RXCSUM;
 	ndev->xdp_features = NETDEV_XDP_ACT_BASIC | NETDEV_XDP_ACT_REDIRECT |
-- 
2.34.1

