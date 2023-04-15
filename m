Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9AB16E2F5D
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 08:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbjDOGqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 02:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjDOGqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 02:46:17 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F045B8E;
        Fri, 14 Apr 2023 23:46:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681541161; x=1713077161;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rr53Ducgp0LeWa/C3dMJZpRzn/yRbmXHBfZUhtLC8nk=;
  b=L4diEDkCeLJCTIj9Cxqgjey0stOIAVZ/TdP9zYq8u0QIQKMzpxBIw5Lt
   A2yvPRFGX3aHL/hnUK13jcN2ez7TNW1WuzdZe+4oL78v2qHX+mfkYfQpQ
   3IcTMmGx79TIyQYbU0s0jwWn9najuWmkPGlQ6kIUxfhAQO2R4a3jUZVzt
   bbbAn5toxUFqNwhfS2xdZzUhafAb9ht0cJSZC2qV4StRRen3MpJNbIcF+
   qRfQzRsDDVOrL+oaGH8QC24lBSp5EvlX7e6RPLyEtj3yYtXkkltB04ljr
   E02MP0RS27GbkQiXdXjC6OJ8/fafyLXSDfXz1GJ32Xc9KvhaIZYTw4uQx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="343379312"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="343379312"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 23:46:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="754727565"
X-IronPort-AV: E=Sophos;i="5.99,199,1677571200"; 
   d="scan'208";a="754727565"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by fmsmga008.fm.intel.com with ESMTP; 14 Apr 2023 23:45:55 -0700
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
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, xdp-hints@xdp-project.net,
        Song Yoong Siang <yoong.siang.song@intel.com>
Subject: [PATCH net-next v6 3/3] net: stmmac: add Rx HWTS metadata to XDP ZC receive pkt
Date:   Sat, 15 Apr 2023 14:45:03 +0800
Message-Id: <20230415064503.3225835-4-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230415064503.3225835-1-yoong.siang.song@intel.com>
References: <20230415064503.3225835-1-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add receive hardware timestamp metadata support via kfunc to XDP Zero Copy
receive packets.

Signed-off-by: Song Yoong Siang <yoong.siang.song@intel.com>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 2bfcc5347d6a..c0e90fda572a 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -1614,6 +1614,12 @@ static int stmmac_alloc_rx_buffers_zc(struct stmmac_priv *priv,
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
@@ -4998,6 +5004,16 @@ static bool stmmac_rx_refill_zc(struct stmmac_priv *priv, u32 queue, u32 budget)
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
@@ -5027,6 +5043,7 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 	}
 	while (count < limit) {
 		struct stmmac_rx_buffer *buf;
+		struct stmmac_xdp_buff *ctx;
 		unsigned int buf1_len = 0;
 		struct dma_desc *np, *p;
 		int entry;
@@ -5112,6 +5129,11 @@ static int stmmac_rx_zc(struct stmmac_priv *priv, int limit, u32 queue)
 			goto read_again;
 		}
 
+		ctx = xsk_buff_to_stmmac_ctx(buf->xdp);
+		ctx->priv = priv;
+		ctx->desc = p;
+		ctx->ndesc = np;
+
 		/* XDP ZC Frame only support primary buffers for now */
 		buf1_len = stmmac_rx_buf1_len(priv, p, status, len);
 		len += buf1_len;
-- 
2.34.1

