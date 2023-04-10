Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEB2F6DC594
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 12:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjDJKKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 06:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjDJKKi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 06:10:38 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51905FC4;
        Mon, 10 Apr 2023 03:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681121434; x=1712657434;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M9jRW3+HhGvO5QbLOE/WrixZZSlVBopsf2U3mliQfB8=;
  b=FK/7OlFVAXDJ6dhrwo4xVczezqRsLQ4f9GAEKeEp5kF4rjE4RXWQPP4x
   g/ck1w7PTKLXGZig2tiUtgUJm5yfWaJ9Nt4+XmxwfKP5UkoqdisL4qTE9
   KjgSAJFVx3BNGU9QMM51YEHsOBIX9DzErdb0ZXI2vlEmemvrXEya+JR1i
   PnLFw9EQr3ZljQpoiC76LuLQCGvkKj5Wa7wFfpf2Umm1OTJg63Aie0WAv
   VcjSSOcGPH5vduIqh7GhVer1Qn9JcPhSZvVbHcmp4nBK2JBrYIjimKMi2
   SaiDAynMoj95DzBVz7JmTp0DN3HmSGMCTKSSNLBZF835Brg5tWqoTyFnW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="340815314"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="340815314"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 03:10:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="752716095"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="752716095"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by fmsmga008.fm.intel.com with ESMTP; 10 Apr 2023 03:10:28 -0700
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
Subject: [PATCH net-next 1/4] net: stmmac: restructure Rx hardware timestamping function
Date:   Mon, 10 Apr 2023 18:09:36 +0800
Message-Id: <20230410100939.331833-2-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230410100939.331833-1-yoong.siang.song@intel.com>
References: <20230410100939.331833-1-yoong.siang.song@intel.com>
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

From: Ong Boon Leong <boon.leong.ong@intel.com>

Rearrange the function of getting Rx hardware timestamp for skb so
that it can be reused for XDP later.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 04fbb7770618..2cc6237a9c28 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -570,15 +570,14 @@ static void stmmac_get_tx_hwtstamp(struct stmmac_priv *priv,
  * @priv: driver private structure
  * @p : descriptor pointer
  * @np : next descriptor pointer
- * @skb : the socket buffer
+ * @hwtstamp : hardware timestamp
  * Description :
  * This function will read received packet's timestamp from the descriptor
  * and pass it to stack. It also perform some sanity checks.
  */
 static void stmmac_get_rx_hwtstamp(struct stmmac_priv *priv, struct dma_desc *p,
-				   struct dma_desc *np, struct sk_buff *skb)
+				   struct dma_desc *np, ktime_t *hwtstamp)
 {
-	struct skb_shared_hwtstamps *shhwtstamp = NULL;
 	struct dma_desc *desc = p;
 	u64 ns = 0;
 
@@ -595,9 +594,7 @@ static void stmmac_get_rx_hwtstamp(struct stmmac_priv *priv, struct dma_desc *p,
 		ns -= priv->plat->cdc_error_adj;
 
 		netdev_dbg(priv->dev, "get valid RX hw timestamp %llu\n", ns);
-		shhwtstamp = skb_hwtstamps(skb);
-		memset(shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
-		shhwtstamp->hwtstamp = ns_to_ktime(ns);
+		*hwtstamp = ns_to_ktime(ns);
 	} else  {
 		netdev_dbg(priv->dev, "cannot get RX hw timestamp\n");
 	}
@@ -4909,6 +4906,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 				   struct xdp_buff *xdp)
 {
 	struct stmmac_channel *ch = &priv->channel[queue];
+	struct skb_shared_hwtstamps *shhwtstamp = NULL;
 	unsigned int len = xdp->data_end - xdp->data;
 	enum pkt_hash_types hash_type;
 	int coe = priv->hw->rx_csum;
@@ -4921,7 +4919,10 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 		return;
 	}
 
-	stmmac_get_rx_hwtstamp(priv, p, np, skb);
+	shhwtstamp = skb_hwtstamps(skb);
+	memset(shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
+	stmmac_get_rx_hwtstamp(priv, p, np, &shhwtstamp->hwtstamp);
+
 	stmmac_rx_vlan(priv->dev, skb);
 	skb->protocol = eth_type_trans(skb, priv->dev);
 
@@ -5213,6 +5214,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 				    rx_q->dma_rx_phy, desc_size);
 	}
 	while (count < limit) {
+		struct skb_shared_hwtstamps *shhwtstamp = NULL;
 		unsigned int buf1_len = 0, buf2_len = 0;
 		enum pkt_hash_types hash_type;
 		struct stmmac_rx_buffer *buf;
@@ -5407,7 +5409,10 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 
 		/* Got entire packet into SKB. Finish it. */
 
-		stmmac_get_rx_hwtstamp(priv, p, np, skb);
+		shhwtstamp = skb_hwtstamps(skb);
+		memset(shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
+		stmmac_get_rx_hwtstamp(priv, p, np, &shhwtstamp->hwtstamp);
+
 		stmmac_rx_vlan(priv->dev, skb);
 		skb->protocol = eth_type_trans(skb, priv->dev);
 
-- 
2.34.1

