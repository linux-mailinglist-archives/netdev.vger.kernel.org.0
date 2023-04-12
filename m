Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D02BF6DF0BA
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 11:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231615AbjDLJn3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 05:43:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231452AbjDLJn2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 05:43:28 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54A8269F;
        Wed, 12 Apr 2023 02:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681292601; x=1712828601;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=M9jRW3+HhGvO5QbLOE/WrixZZSlVBopsf2U3mliQfB8=;
  b=mZmuqB3/4pXj0z9JgTjoljXrrWzUkiKI3K7QhvU9w5fgGxytbB/zGBv2
   YiN2+x50xz24/O3H15kvuIo16rvL4G+b0DwUPwV+9G40OPjA5qi1umg9k
   YfVjmUugvRbipHEYEHVGrVyahiZsst1J4sOvjhFfJng7XPrDFYzeN2aaL
   56GIIoVK9qASIGBm4kHf6Av6Zj8i43kdIE/dUt6+TEMeGTOzGHLfqLqZ9
   q7ey6Sw+MxK1OldNrSFg9IIXwi4mh0Y7o57S9IRf8v6Lq+iIMx0QZ/+VE
   iD1f2REn6UB87FXMsWreZ0CX2CaEawwZ2pEwJWcEm8yPIunTlK/V2rx3s
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="346526354"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="346526354"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 02:43:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="682430920"
X-IronPort-AV: E=Sophos;i="5.98,338,1673942400"; 
   d="scan'208";a="682430920"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by orsmga007.jf.intel.com with ESMTP; 12 Apr 2023 02:43:15 -0700
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
Subject: [PATCH net-next v3 1/4] net: stmmac: restructure Rx hardware timestamping function
Date:   Wed, 12 Apr 2023 17:42:32 +0800
Message-Id: <20230412094235.589089-2-yoong.siang.song@intel.com>
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

