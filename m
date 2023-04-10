Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402D46DC5A2
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 12:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjDJKLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 06:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjDJKLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 06:11:37 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8A659E3;
        Mon, 10 Apr 2023 03:11:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681121477; x=1712657477;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Bc+nspG2xkjaRPTpa9y3nJcvI9rS5o1YkarF2xS12Dk=;
  b=IFcOeWPXAPUs9y/KbdCM6kQRjvxEbiYmDylNZnCaMygB7NnqBr7NGEzA
   oOGzrESufaveYVnJzNUi9g/FESgUrmeqiS9TTkWQnBeMfkjY7/wG5LjXJ
   4D8+seLZatIV53IXEaSzTQkO3vnonyE5zQkT3ZpC3dE2li3SQeCAnLQtI
   jeWidoji5f/ZrLVwN4eqT800QaJcU7zZ51dE2EYPJHH0NYrpp4V+Bgjy2
   Rz0oDPZUDD31pscJ7LtRGHj6B68M87O/GpHeF2NSrLjPASwpnjWCiQrrN
   6lXeRRpn+vJqLYHyBcFkCzyG2ffgJFCSgX/zUJcAUI2pp/gxRpTlQrqhQ
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="340815413"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="340815413"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2023 03:11:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10675"; a="752716209"
X-IronPort-AV: E=Sophos;i="5.98,333,1673942400"; 
   d="scan'208";a="752716209"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by fmsmga008.fm.intel.com with ESMTP; 10 Apr 2023 03:11:00 -0700
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
Subject: [PATCH net-next 4/4] net: stmmac: add Rx HWTS metadata to XDP ZC receive pkt
Date:   Mon, 10 Apr 2023 18:09:39 +0800
Message-Id: <20230410100939.331833-5-yoong.siang.song@intel.com>
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

Add receive hardware timestamp metadata support via kfunc to XDP Zero Copy
receive packets.

Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 29 +++++++++++++++++--
 1 file changed, 26 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index ca183fbfde85..a4545e9eb8fd 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1611,6 +1611,12 @@ static int stmmac_alloc_rx_buffers_zc(struct stmmac_priv *priv,
 	struct stmmac_rx_queue *rx_q = &dma_conf->rx_queue[queue];
 	int i;
 
+	/* struct stmmac_xdp_buff is using cb field (maximum size of 24 bytes)
+	 * in struct xdp_buff_xsk to stash driver specific information. Thus,
+	 * use this macro to make sure no size violations.
+	 */
+	XSK_CHECK_PRIV_TYPE(struct stmmac_xdp_buff);
+
 	for (i = 0; i < dma_conf->dma_rx_size; i++) {
 		struct stmmac_rx_buffer *buf;
 		dma_addr_t dma_addr;
@@ -4903,7 +4909,7 @@ static struct sk_buff *stmmac_construct_skb_zc(struct stmmac_channel *ch,
 
 static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 				   struct dma_desc *p, struct dma_desc *np,
-				   struct xdp_buff *xdp)
+				   struct xdp_buff *xdp, ktime_t rx_hwts)
 {
 	struct stmmac_channel *ch = &priv->channel[queue];
 	struct skb_shared_hwtstamps *shhwtstamp = NULL;
@@ -4921,7 +4927,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 
 	shhwtstamp = skb_hwtstamps(skb);
 	memset(shhwtstamp, 0, sizeof(struct skb_shared_hwtstamps));
-	stmmac_get_rx_hwtstamp(priv, p, np, &shhwtstamp->hwtstamp);
+	shhwtstamp->hwtstamp = rx_hwts;
 
 	stmmac_rx_vlan(priv->dev, skb);
 	skb->protocol = eth_type_trans(skb, priv->dev);
@@ -4999,6 +5005,16 @@ static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
 	return ret;
 }
 
+static struct stmmac_xdp_buff *xsk_buff_to_stmmac_ctx(struct xdp_buff *xdp)
+{
+	/* In XDP zero copy data path, xdp field in struct xdp_buff_xsk is used
+	 * to represent incoming packet, whereas cb field in the same structure
+	 * is used to store driver specific info. Thus, struct stmmac_xdp_buff
+	 * is laid on top of xdp and cb fields of struct xdp_buff_xsk.
+	 */
+	return (struct stmmac_xdp_buff *)xdp;
+}
+
 static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 {
 	struct stmmac_rx_queue *rx_q = &priv->dma_conf.rx_queue[queue];
@@ -5028,8 +5044,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 	}
 	while (count < limit) {
 		struct stmmac_rx_buffer *buf;
+		struct stmmac_xdp_buff *ctx;
 		unsigned int buf1_len = 0;
 		struct dma_desc *np, *p;
+		ktime_t rx_hwts = 0;
 		int entry;
 		int res;
 
@@ -5113,6 +5131,10 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			goto read_again;
 		}
 
+		stmmac_get_rx_hwtstamp(priv, p, np, &rx_hwts);
+		ctx = xsk_buff_to_stmmac_ctx(buf->xdp);
+		ctx->rx_hwts = rx_hwts;
+
 		/* XDP ZC Frame only support primary buffers for now */
 		buf1_len = stmmac_rx_buf1_len(priv, p, status, len);
 		len += buf1_len;
@@ -5132,7 +5154,8 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 
 		switch (res) {
 		case STMMAC_XDP_PASS:
-			stmmac_dispatch_skb_zc(priv, queue, p, np, buf->xdp);
+			stmmac_dispatch_skb_zc(priv, queue, p, np, buf->xdp,
+					       rx_hwts);
 			xsk_buff_free(buf->xdp);
 			break;
 		case STMMAC_XDP_CONSUMED:
-- 
2.34.1

