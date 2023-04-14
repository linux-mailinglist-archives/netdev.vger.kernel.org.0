Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 215226E1BB3
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 07:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjDNF2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 01:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229753AbjDNF2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 01:28:10 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5A1DE4F;
        Thu, 13 Apr 2023 22:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681450078; x=1712986078;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iHZ3pySy0Mry1kT1bLKTKmQEXlQGTOhTLuIriclyu7A=;
  b=QQtxZ9nSlABzSOWVEG7fSMwQS7l7F58iiCykOFCxk2V3YPZE/DS54B8P
   D9ZMlHf0dFIW7wTa9Krk+TJmSfyLIzmVA+vCyOmKXU9iKFXiDwiUxWO/E
   qXx7MLxeZ6+Q2eFHRI+ii163ZzLKo9VZt6PiYV/D5bPhePofrHz7VAfST
   m0AcbGkGE9aT00PyduKc/BmTe0V9TleB8B6sHNoE2Ncdn1Ggaf9+2w/yi
   HjsFZWimwT0FC76M8VfGMWyzxOk4dLAXnbvliwHFIfCOkvxYF2fqHqPu1
   fYqkvQNoJ4SUc4fHgU28xX9rjgnk0DzgFijHRYL7lMreJklW+moLwPKsL
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="333152747"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="333152747"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Apr 2023 22:27:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="692234171"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="692234171"
Received: from p12ill20yoongsia.png.intel.com ([10.88.227.28])
  by fmsmga007.fm.intel.com with ESMTP; 13 Apr 2023 22:27:52 -0700
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
Subject: [PATCH net-next v5 3/3] net: stmmac: add Rx HWTS metadata to XDP ZC receive pkt
Date:   Fri, 14 Apr 2023 13:26:51 +0800
Message-Id: <20230414052651.1871424-4-yoong.siang.song@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230414052651.1871424-1-yoong.siang.song@intel.com>
References: <20230414052651.1871424-1-yoong.siang.song@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
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
index 74f78e5537a3..f3b8eae0846e 100644
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
+		ctx->p = p;
+		ctx->np = np;
+
 		/* XDP ZC Frame only support primary buffers for now */
 		buf1_len = stmmac_rx_buf1_len(priv, p, status, len);
 		len += buf1_len;
-- 
2.34.1

