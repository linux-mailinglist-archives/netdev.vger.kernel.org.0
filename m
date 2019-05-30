Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E1A301C4
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 20:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726893AbfE3SVD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 14:21:03 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:33500 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfE3SVD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 14:21:03 -0400
Received: by mail-lf1-f65.google.com with SMTP id y17so5804017lfe.0
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 11:21:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=OkjGaEezUcQHsPgRSjppw0xXAMAfa6mWOcTKq++3vcA=;
        b=R8GtLY+mtgFLC+KUWPfw4x09obXlWwNIG9h2mVlNbxfhWYgXiu0p7Em1h2NRwVHZZl
         Hv5ugm0sW8me9xmIw6UekbDdWkuKjVQvLp3u7fKTzncXHdxiX1P7lDZ+sgFNQ5sid+18
         S92U1ywV39YLF2+c8a3LLXTywRH+cjcwHdjTvLv7dzNngxV9sXMnNrqUnI30/aV9wCc3
         V2+Li6GKt0kvOF/LmT1JswwN2u7O8/pPTOAe3/5p9W8NVUQc8NXNzchVLKw6RFP6XLsA
         to7FYjhDqD/vuVv9gR1vZP1FLG7M5mgmI+ekCwZ9lIKUrezieN1U2u+nN5D89T05br4M
         yVew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=OkjGaEezUcQHsPgRSjppw0xXAMAfa6mWOcTKq++3vcA=;
        b=d/lQpkeZcA7Bot4GRg40lqeaQ9l9PxptO2ohyuOap3U3Tq8awVQTv4gjfaSTB5PVzw
         otJQBcpPpA/uBuUUpDYJJ4mwtZGtbGLvFW5CRHYLn06DMgmAhXWsqxTEtyvHLNWyYse8
         8KtE71UviKbE+FIOB6L0TKBnpDhQLtrSJTyDSN1V1X0ndqwUNZvj3i36mTKPKim2eefv
         WOBx5+r2NRJV4/9Jwjy+3rhiBqB7NSzmQvZ5XqKwhSgCiA3CEUwZKdDek+4yyTEYaVxU
         YTXczL6C8emHcu63C2TpD8u/LYE+nSRGaDi0+b8t5NH/M4I12FBALSmUJ/jWby9TOWPM
         3qlg==
X-Gm-Message-State: APjAAAVCgzRCNNphtiPQOJgSoBpxwV91lKvP4hUcTWS7B7Gvle5KnLwM
        KqnCirzoBRVbIEghr/qtYSi05A==
X-Google-Smtp-Source: APXvYqxlGLRL8Jw25/ozZ9/SKjd8pPoixAYn+ft73B+O4L4ZlILUjazGvSqAoKaRp9ARWzIwwiOzrA==
X-Received: by 2002:a19:5515:: with SMTP id n21mr2820213lfe.26.1559240458998;
        Thu, 30 May 2019 11:20:58 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id v7sm388946lfe.11.2019.05.30.11.20.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 11:20:58 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     grygorii.strashko@ti.com, hawk@kernel.org, davem@davemloft.net
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v2 net-next 7/7] net: ethernet: ti: cpsw: add XDP support
Date:   Thu, 30 May 2019 21:20:39 +0300
Message-Id: <20190530182039.4945-8-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
References: <20190530182039.4945-1-ivan.khoronzhuk@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add XDP support based on rx page_pool allocator, one frame per page.
Page pool allocator is used with assumption that only one rx_handler
is running simultaneously. DMA map/unmap is reused from page pool
despite there is no need to map whole page.

Due to specific of cpsw, the same TX/RX handler can be used by 2
network devices, so special fields in buffer are added to identify
an interface the frame is destined to. Thus XDP works for both
interfaces, that allows to test xdp redirect between two interfaces
easily.

XDP prog is common for all channels till appropriate changes are added
in XDP infrastructure. Also, once page_pool recycling becomes part of
skb netstack some simplifications can be added marked with comments.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/Kconfig        |   1 +
 drivers/net/ethernet/ti/cpsw.c         | 506 ++++++++++++++++++++++---
 drivers/net/ethernet/ti/cpsw_ethtool.c |  94 ++++-
 drivers/net/ethernet/ti/cpsw_priv.h    |  10 +
 4 files changed, 548 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index bd05a977ee7e..3cb8c5214835 100644
--- a/drivers/net/ethernet/ti/Kconfig
+++ b/drivers/net/ethernet/ti/Kconfig
@@ -50,6 +50,7 @@ config TI_CPSW
 	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
 	select TI_DAVINCI_MDIO
 	select MFD_SYSCON
+	select PAGE_POOL
 	select REGMAP
 	---help---
 	  This driver supports TI's CPSW Ethernet Switch.
diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
index d89ad428315c..6eb7bde9409b 100644
--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -31,6 +31,10 @@
 #include <linux/if_vlan.h>
 #include <linux/kmemleak.h>
 #include <linux/sys_soc.h>
+#include <net/page_pool.h>
+#include <linux/bpf.h>
+#include <linux/bpf_trace.h>
+#include <linux/filter.h>
 
 #include <linux/pinctrl/consumer.h>
 #include <net/pkt_cls.h>
@@ -60,6 +64,10 @@ static int descs_pool_size = CPSW_CPDMA_DESCS_POOL_SIZE_DEFAULT;
 module_param(descs_pool_size, int, 0444);
 MODULE_PARM_DESC(descs_pool_size, "Number of CPDMA CPPI descriptors in pool");
 
+/* The buf includes headroom compatible with both skb and xdpf */
+#define CPSW_HEADROOM_NA (max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + NET_IP_ALIGN)
+#define CPSW_HEADROOM  ALIGN(CPSW_HEADROOM_NA, sizeof(long))
+
 #define for_each_slave(priv, func, arg...)				\
 	do {								\
 		struct cpsw_slave *slave;				\
@@ -74,6 +82,13 @@ MODULE_PARM_DESC(descs_pool_size, "Number of CPDMA CPPI descriptors in pool");
 				(func)(slave++, ##arg);			\
 	} while (0)
 
+#define CPSW_XMETA_OFFSET	ALIGN(sizeof(struct xdp_frame), sizeof(long))
+
+#define CPSW_XDP_CONSUMED		1
+#define CPSW_XDP_CONSUMED_FLUSH		2
+#define CPSW_XDP_PASS			0
+#define CPSW_FLUSH_XDP_MAP		1
+
 static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
 				    __be16 proto, u16 vid);
 
@@ -337,24 +352,58 @@ void cpsw_intr_disable(struct cpsw_common *cpsw)
 	return;
 }
 
+static int cpsw_is_xdpf_handle(void *handle)
+{
+	return (unsigned long)handle & BIT(0);
+}
+
+static void *cpsw_xdpf_to_handle(struct xdp_frame *xdpf)
+{
+	return (void *)((unsigned long)xdpf | BIT(0));
+}
+
+static struct xdp_frame *cpsw_handle_to_xdpf(void *handle)
+{
+	return (struct xdp_frame *)((unsigned long)handle & ~BIT(0));
+}
+
+struct __aligned(sizeof(long)) cpsw_meta_xdp {
+	struct net_device *ndev;
+	int ch;
+};
+
 int cpsw_tx_handler(void *token, int len, int status)
 {
+	struct cpsw_meta_xdp	*xmeta;
+	struct xdp_frame	*xdpf;
+	struct net_device	*ndev;
 	struct netdev_queue	*txq;
-	struct sk_buff		*skb = token;
-	struct net_device	*ndev = skb->dev;
-	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
+	struct sk_buff		*skb;
+	int			ch;
+
+	if (cpsw_is_xdpf_handle(token)) {
+		xdpf = cpsw_handle_to_xdpf(token);
+		xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
+		ndev = xmeta->ndev;
+		ch = xmeta->ch;
+		xdp_return_frame_rx_napi(xdpf);
+	} else {
+		skb = token;
+		ndev = skb->dev;
+		ch = skb_get_queue_mapping(skb);
+		cpts_tx_timestamp(ndev_to_cpsw(ndev)->cpts, skb);
+		dev_kfree_skb_any(skb);
+	}
 
 	/* Check whether the queue is stopped due to stalled tx dma, if the
 	 * queue is stopped then start the queue as we have free desc for tx
 	 */
-	txq = netdev_get_tx_queue(ndev, skb_get_queue_mapping(skb));
+	txq = netdev_get_tx_queue(ndev, ch);
 	if (unlikely(netif_tx_queue_stopped(txq)))
 		netif_tx_wake_queue(txq);
 
-	cpts_tx_timestamp(cpsw->cpts, skb);
 	ndev->stats.tx_packets++;
 	ndev->stats.tx_bytes += len;
-	dev_kfree_skb_any(skb);
 	return 0;
 }
 
@@ -401,22 +450,220 @@ static void cpsw_rx_vlan_encap(struct sk_buff *skb)
 	}
 }
 
+static int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
+			     struct page *page)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct cpsw_meta_xdp *xmeta;
+	struct netdev_queue *txq;
+	struct cpdma_chan *txch;
+	dma_addr_t dma;
+	int ret, port;
+
+	xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
+	xmeta->ch = 0;
+	txch = cpsw->txv[0].ch;
+
+	port = priv->emac_port + cpsw->data.dual_emac;
+	if (page) {
+		dma = page_pool_get_dma_addr(page);
+		dma += xdpf->data - (void *)xdpf;
+		ret = cpdma_chan_submit_mapped(txch, cpsw_xdpf_to_handle(xdpf),
+					       dma, xdpf->len, port);
+	} else {
+		if (sizeof(*xmeta) > xdpf->headroom) {
+			xdp_return_frame_rx_napi(xdpf);
+			return -EINVAL;
+		}
+
+		xmeta->ndev = priv->ndev;
+		ret = cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf),
+					xdpf->data, xdpf->len, port);
+	}
+
+	if (ret) {
+		xdp_return_frame_rx_napi(xdpf);
+		goto stop;
+	}
+
+	/* no tx desc - stop sending us tx frames */
+	if (unlikely(!cpdma_check_free_tx_desc(txch)))
+		goto stop;
+
+	return ret;
+stop:
+	txq = netdev_get_tx_queue(priv->ndev, 0);
+	netif_tx_stop_queue(txq);
+
+	/* Barrier, so that stop_queue visible to other cpus */
+	smp_mb__after_atomic();
+
+	if (cpdma_check_free_tx_desc(txch))
+		netif_tx_wake_queue(txq);
+
+	return ret;
+}
+
+static int cpsw_run_xdp(struct cpsw_priv *priv, struct cpsw_vector *rxv,
+			struct xdp_buff *xdp, struct page *page)
+{
+	struct net_device *ndev = priv->ndev;
+	int ret = CPSW_XDP_CONSUMED;
+	struct xdp_frame *xdpf;
+	struct bpf_prog *prog;
+	u32 act;
+
+	rcu_read_lock();
+
+	prog = READ_ONCE(priv->xdp_prog);
+	if (!prog) {
+		ret = CPSW_XDP_PASS;
+		goto out;
+	}
+
+	act = bpf_prog_run_xdp(prog, xdp);
+	switch (act) {
+	case XDP_PASS:
+		ret = CPSW_XDP_PASS;
+		break;
+	case XDP_TX:
+		xdpf = convert_to_xdp_frame(xdp);
+		if (unlikely(!xdpf))
+			goto drop;
+
+		cpsw_xdp_tx_frame(priv, xdpf, page);
+		break;
+	case XDP_REDIRECT:
+		if (xdp_do_redirect(ndev, xdp, prog))
+			goto drop;
+
+		ret = CPSW_XDP_CONSUMED_FLUSH;
+		break;
+	default:
+		bpf_warn_invalid_xdp_action(act);
+		/* fall through */
+	case XDP_ABORTED:
+		trace_xdp_exception(ndev, prog, act);
+		/* fall through -- handle aborts by dropping packet */
+	case XDP_DROP:
+		goto drop;
+	}
+out:
+	rcu_read_unlock();
+	return ret;
+drop:
+	rcu_read_unlock();
+	page_pool_recycle_direct(priv->cpsw->page_pool, page);
+	return ret;
+}
+
+static unsigned int cpsw_rxbuf_total_len(unsigned int len)
+{
+	len += CPSW_HEADROOM;
+	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
+	return SKB_DATA_ALIGN(len);
+}
+
+void cpsw_xdp_unreg_rxqs(struct cpsw_priv *priv)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	int i;
+
+	for (i = 0; i < cpsw->rx_ch_num; i++)
+		xdp_rxq_info_unreg(&priv->xdp_rxq[i]);
+}
+
+int cpsw_xdp_reg_rxq(struct cpsw_priv *priv, int ch)
+{
+	struct xdp_rxq_info *xdp_rxq = &priv->xdp_rxq[ch];
+	struct cpsw_common *cpsw = priv->cpsw;
+	int ret;
+
+	ret = xdp_rxq_info_reg(xdp_rxq, priv->ndev, ch);
+	if (ret)
+		goto err_cleanup;
+
+	ret = xdp_rxq_info_reg_mem_model(xdp_rxq, MEM_TYPE_PAGE_POOL,
+					 cpsw->page_pool);
+	if (ret)
+		goto err_cleanup;
+
+	return 0;
+
+err_cleanup:
+	if (xdp_rxq_info_is_reg(xdp_rxq))
+		xdp_rxq_info_unreg(xdp_rxq);
+
+	return ret;
+}
+
+int cpsw_xdp_reg_rxqs(struct cpsw_priv *priv)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct xdp_rxq_info *xdp_rxq;
+	int i, ret;
+
+	for (i = 0; i < cpsw->rx_ch_num; i++) {
+		ret = cpsw_xdp_reg_rxq(priv, i);
+		if (ret)
+			goto err_cleanup;
+	}
+
+	return 0;
+
+err_cleanup:
+	while (i--) {
+		xdp_rxq = &priv->xdp_rxq[i];
+		if (xdp_rxq_info_is_reg(xdp_rxq))
+			xdp_rxq_info_unreg(xdp_rxq);
+	}
+
+	return ret;
+}
+
+struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw, int size)
+{
+	struct page_pool_params pp_params = { 0 };
+	struct page_pool *pool;
+
+	pp_params.order = 0;
+	pp_params.flags = PP_FLAG_DMA_MAP;
+
+	/* set it to number of RX descriptors, but can be more */
+	pp_params.pool_size = size;
+	pp_params.nid = NUMA_NO_NODE;
+	pp_params.dma_dir = DMA_BIDIRECTIONAL;
+	pp_params.dev = cpsw->dev;
+
+	pool = page_pool_create(&pp_params);
+	if (IS_ERR(pool))
+		dev_err(cpsw->dev, "cannot create rx page pool\n");
+
+	return pool;
+}
+
 static int cpsw_rx_handler(void *token, int len, int status)
 {
-	struct cpdma_chan	*ch;
-	struct sk_buff		*skb = token;
-	struct sk_buff		*new_skb;
-	struct net_device	*ndev = skb->dev;
-	int			ret = 0, port;
-	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
+	struct page		*new_page, *page = token;
+	void			*pa = page_address(page);
+	struct cpsw_meta_xdp	*xmeta = pa + CPSW_XMETA_OFFSET;
+	struct cpsw_common	*cpsw = ndev_to_cpsw(xmeta->ndev);
+	int			pkt_size = cpsw->rx_packet_max;
+	int			ret = 0, port, ch = xmeta->ch;
+	struct page_pool	*pool = cpsw->page_pool;
+	int			headroom = CPSW_HEADROOM;
+	struct net_device	*ndev = xmeta->ndev;
+	int			res = 0;
 	struct cpsw_priv	*priv;
+	struct sk_buff		*skb;
+	struct xdp_buff		xdp;
+	dma_addr_t		dma;
 
 	if (cpsw->data.dual_emac) {
 		port = CPDMA_RX_SOURCE_PORT(status);
-		if (port) {
+		if (port)
 			ndev = cpsw->slaves[--port].ndev;
-			skb->dev = ndev;
-		}
 	}
 
 	if (unlikely(status < 0) || unlikely(!netif_running(ndev))) {
@@ -427,49 +674,97 @@ static int cpsw_rx_handler(void *token, int len, int status)
 			 * is already down and the other interface is up
 			 * and running, instead of freeing which results
 			 * in reducing of the number of rx descriptor in
-			 * DMA engine, requeue skb back to cpdma.
+			 * DMA engine, requeue page back to cpdma.
 			 */
-			new_skb = skb;
+			new_page = page;
 			goto requeue;
 		}
 
-		/* the interface is going down, skbs are purged */
-		dev_kfree_skb_any(skb);
+		/* the interface is going down, pages are purged */
+		page_pool_recycle_direct(pool, page);
 		return 0;
 	}
 
-	new_skb = netdev_alloc_skb_ip_align(ndev, cpsw->rx_packet_max);
-	if (new_skb) {
-		skb_copy_queue_mapping(new_skb, skb);
-		skb_put(skb, len);
-		if (status & CPDMA_RX_VLAN_ENCAP)
-			cpsw_rx_vlan_encap(skb);
-		priv = netdev_priv(ndev);
-		if (priv->rx_ts_enabled)
-			cpts_rx_timestamp(cpsw->cpts, skb);
-		skb->protocol = eth_type_trans(skb, ndev);
-		netif_receive_skb(skb);
-		ndev->stats.rx_bytes += len;
-		ndev->stats.rx_packets++;
-		kmemleak_not_leak(new_skb);
-	} else {
+	new_page = page_pool_dev_alloc_pages(cpsw->page_pool);
+	if (unlikely(!new_page)) {
+		new_page = page;
 		ndev->stats.rx_dropped++;
-		new_skb = skb;
+		goto requeue;
 	}
 
+	priv = netdev_priv(ndev);
+	if (priv->xdp_prog) {
+		if (status & CPDMA_RX_VLAN_ENCAP) {
+			xdp.data = (void *)pa + CPSW_HEADROOM +
+				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
+			xdp.data_end = xdp.data + len -
+				       CPSW_RX_VLAN_ENCAP_HDR_SIZE;
+		} else {
+			xdp.data = (void *)pa + CPSW_HEADROOM;
+			xdp.data_end = xdp.data + len;
+		}
+
+		xdp_set_data_meta_invalid(&xdp);
+
+		xdp.data_hard_start = pa;
+		xdp.rxq = &priv->xdp_rxq[ch];
+
+		ret = cpsw_run_xdp(priv, &cpsw->rxv[ch], &xdp, page);
+		if (ret != CPSW_XDP_PASS) {
+			if (ret == CPSW_XDP_CONSUMED_FLUSH)
+				res = CPSW_FLUSH_XDP_MAP;
+
+			goto requeue;
+		}
+
+		/* XDP prog might have changed packet data and boundaries */
+		len = xdp.data_end - xdp.data;
+		headroom = xdp.data - xdp.data_hard_start;
+	}
+
+	/* Build skb and pass it to netstack if XDP off or XDP prog
+	 * returned XDP_PASS
+	 */
+	skb = build_skb(pa, cpsw_rxbuf_total_len(pkt_size));
+	if (!skb) {
+		ndev->stats.rx_dropped++;
+		page_pool_recycle_direct(pool, page);
+		goto requeue;
+	}
+
+	skb_reserve(skb, headroom);
+	skb_put(skb, len);
+	skb->dev = ndev;
+	if (status & CPDMA_RX_VLAN_ENCAP)
+		cpsw_rx_vlan_encap(skb);
+	if (priv->rx_ts_enabled)
+		cpts_rx_timestamp(cpsw->cpts, skb);
+	skb->protocol = eth_type_trans(skb, ndev);
+
+	/* unmap page as no skb page recycling */
+	page_pool_unmap_page(pool, page);
+	netif_receive_skb(skb);
+
+	ndev->stats.rx_bytes += len;
+	ndev->stats.rx_packets++;
+
 requeue:
 	if (netif_dormant(ndev)) {
-		dev_kfree_skb_any(new_skb);
-		return 0;
+		page_pool_recycle_direct(pool, new_page);
+		return res;
 	}
 
-	ch = cpsw->rxv[skb_get_queue_mapping(new_skb)].ch;
-	ret = cpdma_chan_submit(ch, new_skb, new_skb->data,
-				skb_tailroom(new_skb), 0);
+	xmeta = page_address(new_page) + CPSW_XMETA_OFFSET;
+	xmeta->ndev = ndev;
+	xmeta->ch = ch;
+
+	dma = page_pool_get_dma_addr(new_page) + CPSW_HEADROOM;
+	ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
+				       pkt_size, 0);
 	if (WARN_ON(ret < 0))
-		dev_kfree_skb_any(new_skb);
+		page_pool_recycle_direct(pool, new_page);
 
-	return 0;
+	return res;
 }
 
 void cpsw_split_res(struct cpsw_common *cpsw)
@@ -644,8 +939,8 @@ static int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
 static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 {
 	u32			ch_map;
-	int			num_rx, cur_budget, ch;
 	struct cpsw_common	*cpsw = napi_to_cpsw(napi_rx);
+	int			num_rx, cur_budget, ch, res;
 	struct cpsw_vector	*rxv;
 
 	/* process every unprocessed channel */
@@ -660,8 +955,12 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 		else
 			cur_budget = rxv->budget;
 
-		cpdma_chan_process(rxv->ch, &cur_budget);
+		res = cpdma_chan_process(rxv->ch, &cur_budget);
 		num_rx += cur_budget;
+
+		if (res & CPSW_FLUSH_XDP_MAP)
+			xdp_do_flush_map();
+
 		if (num_rx >= budget)
 			break;
 	}
@@ -677,10 +976,15 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 static int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)
 {
 	struct cpsw_common *cpsw = napi_to_cpsw(napi_rx);
-	int num_rx;
+	struct cpsw_vector *rxv;
+	int num_rx, res;
 
 	num_rx = budget;
-	cpdma_chan_process(cpsw->rxv[0].ch, &num_rx);
+	rxv = &cpsw->rxv[0];
+	res = cpdma_chan_process(rxv->ch, &num_rx);
+	if (res & CPSW_FLUSH_XDP_MAP)
+		xdp_do_flush_map();
+
 	if (num_rx < budget) {
 		napi_complete_done(napi_rx, num_rx);
 		writel(0xff, &cpsw->wr_regs->rx_en);
@@ -1042,33 +1346,36 @@ static void cpsw_init_host_port(struct cpsw_priv *priv)
 int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
-	struct sk_buff *skb;
+	struct cpsw_meta_xdp *xmeta;
+	struct page *page;
 	int ch_buf_num;
 	int ch, i, ret;
+	dma_addr_t dma;
 
 	for (ch = 0; ch < cpsw->rx_ch_num; ch++) {
 		ch_buf_num = cpdma_chan_get_rx_buf_num(cpsw->rxv[ch].ch);
 		for (i = 0; i < ch_buf_num; i++) {
-			skb = __netdev_alloc_skb_ip_align(priv->ndev,
-							  cpsw->rx_packet_max,
-							  GFP_KERNEL);
-			if (!skb) {
-				cpsw_err(priv, ifup, "cannot allocate skb\n");
+			page = page_pool_dev_alloc_pages(cpsw->page_pool);
+			if (!page) {
+				cpsw_err(priv, ifup, "allocate rx page err\n");
 				return -ENOMEM;
 			}
 
-			skb_set_queue_mapping(skb, ch);
-			ret = cpdma_chan_submit(cpsw->rxv[ch].ch, skb,
-						skb->data, skb_tailroom(skb),
-						0);
+			xmeta = page_address(page) + CPSW_XMETA_OFFSET;
+			xmeta->ndev = priv->ndev;
+			xmeta->ch = ch;
+
+			dma = page_pool_get_dma_addr(page) + CPSW_HEADROOM;
+			ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, page,
+						       dma, cpsw->rx_packet_max,
+						       0);
 			if (ret < 0) {
 				cpsw_err(priv, ifup,
-					 "cannot submit skb to channel %d rx, error %d\n",
+					 "cannot submit page to channel %d rx, error %d\n",
 					 ch, ret);
-				kfree_skb(skb);
+				page_pool_recycle_direct(cpsw->page_pool, page);
 				return ret;
 			}
-			kmemleak_not_leak(skb);
 		}
 
 		cpsw_info(priv, ifup, "ch %d rx, submitted %d descriptors\n",
@@ -1338,7 +1645,7 @@ static int cpsw_ndo_open(struct net_device *ndev)
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
-	int ret;
+	int ret, pool_size;
 	u32 reg;
 
 	ret = pm_runtime_get_sync(cpsw->dev);
@@ -1404,6 +1711,14 @@ static int cpsw_ndo_open(struct net_device *ndev)
 			enable_irq(cpsw->irqs_table[0]);
 		}
 
+		pool_size = cpdma_get_num_rx_descs(cpsw->dma);
+		cpsw->page_pool = cpsw_create_page_pool(cpsw, pool_size);
+		if (IS_ERR(cpsw->page_pool)) {
+			ret = PTR_ERR(cpsw->page_pool);
+			cpsw->page_pool = NULL;
+			goto err_cleanup;
+		}
+
 		ret = cpsw_fill_rx_channels(priv);
 		if (ret < 0)
 			goto err_cleanup;
@@ -1423,6 +1738,10 @@ static int cpsw_ndo_open(struct net_device *ndev)
 		cpsw_set_coalesce(ndev, &coal);
 	}
 
+	ret = cpsw_xdp_reg_rxqs(priv);
+	if (ret)
+		goto err_cleanup;
+
 	cpdma_ctlr_start(cpsw->dma);
 	cpsw_intr_enable(cpsw);
 	cpsw->usage_count++;
@@ -1432,9 +1751,11 @@ static int cpsw_ndo_open(struct net_device *ndev)
 err_cleanup:
 	if (!cpsw->usage_count) {
 		cpdma_ctlr_stop(cpsw->dma);
-		for_each_slave(priv, cpsw_slave_stop, cpsw);
+		if (cpsw->page_pool)
+			page_pool_destroy(cpsw->page_pool);
 	}
 
+	for_each_slave(priv, cpsw_slave_stop, cpsw);
 	pm_runtime_put_sync(cpsw->dev);
 	netif_carrier_off(priv->ndev);
 	return ret;
@@ -1457,12 +1778,15 @@ static int cpsw_ndo_stop(struct net_device *ndev)
 		cpsw_intr_disable(cpsw);
 		cpdma_ctlr_stop(cpsw->dma);
 		cpsw_ale_stop(cpsw->ale);
+		page_pool_destroy(cpsw->page_pool);
 	}
 	for_each_slave(priv, cpsw_slave_stop, cpsw);
 
 	if (cpsw_need_resplit(cpsw))
 		cpsw_split_res(cpsw);
 
+	cpsw_xdp_unreg_rxqs(priv);
+
 	cpsw->usage_count--;
 	pm_runtime_put_sync(cpsw->dev);
 	return 0;
@@ -2014,6 +2338,64 @@ static int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
 	}
 }
 
+static int cpsw_xdp_prog_setup(struct cpsw_priv *priv, struct netdev_bpf *bpf)
+{
+	struct bpf_prog *prog = bpf->prog;
+
+	if (!priv->xdpi.prog && !prog)
+		return 0;
+
+	if (!xdp_attachment_flags_ok(&priv->xdpi, bpf))
+		return -EBUSY;
+
+	WRITE_ONCE(priv->xdp_prog, prog);
+
+	xdp_attachment_setup(&priv->xdpi, bpf);
+
+	return 0;
+}
+
+static int cpsw_ndo_bpf(struct net_device *ndev, struct netdev_bpf *bpf)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+
+	switch (bpf->command) {
+	case XDP_SETUP_PROG:
+		return cpsw_xdp_prog_setup(priv, bpf);
+
+	case XDP_QUERY_PROG:
+		return xdp_attachment_query(&priv->xdpi, bpf);
+
+	default:
+		return -EINVAL;
+	}
+}
+
+static int cpsw_ndo_xdp_xmit(struct net_device *ndev, int n,
+			     struct xdp_frame **frames, u32 flags)
+{
+	struct cpsw_priv *priv = netdev_priv(ndev);
+	struct xdp_frame *xdpf;
+	int i, drops = 0;
+
+	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
+		return -EINVAL;
+
+	for (i = 0; i < n; i++) {
+		xdpf = frames[i];
+		if (xdpf->len < CPSW_MIN_PACKET_SIZE) {
+			xdp_return_frame_rx_napi(xdpf);
+			drops++;
+			continue;
+		}
+
+		if (cpsw_xdp_tx_frame(priv, xdpf, NULL))
+			drops++;
+	}
+
+	return n - drops;
+}
+
 #ifdef CONFIG_NET_POLL_CONTROLLER
 static void cpsw_ndo_poll_controller(struct net_device *ndev)
 {
@@ -2042,6 +2424,8 @@ static const struct net_device_ops cpsw_netdev_ops = {
 	.ndo_vlan_rx_add_vid	= cpsw_ndo_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= cpsw_ndo_vlan_rx_kill_vid,
 	.ndo_setup_tc           = cpsw_ndo_setup_tc,
+	.ndo_bpf		= cpsw_ndo_bpf,
+	.ndo_xdp_xmit		= cpsw_ndo_xdp_xmit,
 };
 
 static void cpsw_get_drvinfo(struct net_device *ndev,
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index 1a7c4818c890..45028088b070 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -14,6 +14,7 @@
 #include <linux/phy.h>
 #include <linux/pm_runtime.h>
 #include <linux/skbuff.h>
+#include <net/page_pool.h>
 
 #include "cpsw.h"
 #include "cpts.h"
@@ -534,6 +535,59 @@ static int cpsw_check_ch_settings(struct cpsw_common *cpsw,
 	return 0;
 }
 
+void cpsw_xdp_rxq_unreg(struct cpsw_common *cpsw, int ch)
+{
+	struct net_device *ndev;
+	struct cpsw_priv *priv;
+	int i;
+
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		ndev = cpsw->slaves[i].ndev;
+		if (!(ndev && netif_running(ndev)))
+			continue;
+
+		priv = netdev_priv(ndev);
+		xdp_rxq_info_unreg(&priv->xdp_rxq[ch]);
+	}
+}
+
+static int cpsw_xdp_sl_reg_rxq(struct cpsw_common *cpsw, int ch)
+{
+	struct net_device *ndev;
+	struct cpsw_priv *priv;
+	int i, ret;
+
+	/* As channels are common for both ports sharing same queues, xdp_rxq
+	 * information also becomes shared and used by every packet on this
+	 * channel. But each xdp_rxq holds link on netdev, which by the theory
+	 * can have different memory model and so, network device must hold it's
+	 * own set of rxq and thus both netdevs should be prepared
+	 */
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		ndev = cpsw->slaves[i].ndev;
+		if (!(ndev && netif_running(ndev)))
+			continue;
+
+		ret = cpsw_xdp_reg_rxq(netdev_priv(ndev), ch);
+		if (ret)
+			goto err_cleanup;
+	}
+
+	return 0;
+
+err_cleanup:
+	while (i--) {
+		ndev = cpsw->slaves[i].ndev;
+		if (!(ndev && netif_running(ndev)))
+			continue;
+
+		priv = netdev_priv(ndev);
+		xdp_rxq_info_unreg(&priv->xdp_rxq[ch]);
+	}
+
+	return ret;
+}
+
 static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx,
 				    cpdma_handler_fn rx_handler)
 {
@@ -565,6 +619,11 @@ static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx,
 		if (!vec[*ch].ch)
 			return -EINVAL;
 
+		if (rx && cpsw_xdp_sl_reg_rxq(cpsw, *ch)) {
+			cpdma_chan_destroy(vec[*ch].ch);
+			return -EINVAL;
+		}
+
 		cpsw_info(priv, ifup, "created new %d %s channel\n", *ch,
 			  (rx ? "rx" : "tx"));
 		(*ch)++;
@@ -573,6 +632,9 @@ static int cpsw_update_channels_res(struct cpsw_priv *priv, int ch_num, int rx,
 	while (*ch > ch_num) {
 		(*ch)--;
 
+		if (rx)
+			cpsw_xdp_rxq_unreg(cpsw, *ch);
+
 		ret = cpdma_chan_destroy(vec[*ch].ch);
 		if (ret)
 			return ret;
@@ -656,7 +718,8 @@ int cpsw_set_ringparam(struct net_device *ndev,
 {
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
-	int ret;
+	struct page_pool *pool;
+	int ret, i;
 
 	/* ignore ering->tx_pending - only rx_pending adjustment is supported */
 
@@ -668,6 +731,10 @@ int cpsw_set_ringparam(struct net_device *ndev,
 	if (ering->rx_pending == cpdma_get_num_rx_descs(cpsw->dma))
 		return 0;
 
+	pool = cpsw_create_page_pool(cpsw, ering->rx_pending);
+	if (IS_ERR(pool))
+		return PTR_ERR(pool);
+
 	cpsw_suspend_data_pass(ndev);
 
 	cpdma_set_num_rx_descs(cpsw->dma, ering->rx_pending);
@@ -675,10 +742,33 @@ int cpsw_set_ringparam(struct net_device *ndev,
 	if (cpsw->usage_count)
 		cpdma_chan_split_pool(cpsw->dma);
 
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		struct net_device *ndev = cpsw->slaves[i].ndev;
+
+		if (!(ndev && netif_running(ndev)))
+			continue;
+
+		cpsw_xdp_unreg_rxqs(netdev_priv(ndev));
+	}
+
+	page_pool_destroy(cpsw->page_pool);
+	cpsw->page_pool = pool;
+
+	for (i = 0; i < cpsw->data.slaves; i++) {
+		struct net_device *ndev = cpsw->slaves[i].ndev;
+
+		if (!(ndev && netif_running(ndev)))
+			continue;
+
+		ret = cpsw_xdp_reg_rxqs(netdev_priv(ndev));
+		if (ret)
+			goto err;
+	}
+
 	ret = cpsw_resume_data_pass(ndev);
 	if (!ret)
 		return 0;
-
+err:
 	dev_err(cpsw->dev, "cannot set ring params, closing device\n");
 	dev_close(ndev);
 	return ret;
diff --git a/drivers/net/ethernet/ti/cpsw_priv.h b/drivers/net/ethernet/ti/cpsw_priv.h
index 2ecb3af59fe9..e59a54ee7540 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -346,6 +346,7 @@ struct cpsw_common {
 	int				rx_ch_num, tx_ch_num;
 	int				speed;
 	int				usage_count;
+	struct page_pool		*page_pool;
 };
 
 struct cpsw_priv {
@@ -360,6 +361,10 @@ struct cpsw_priv {
 	int				shp_cfg_speed;
 	int				tx_ts_enabled;
 	int				rx_ts_enabled;
+	struct bpf_prog			*xdp_prog;
+	struct xdp_rxq_info		xdp_rxq[CPSW_MAX_QUEUES];
+	struct xdp_attachment_info	xdpi;
+
 	u32 emac_port;
 	struct cpsw_common *cpsw;
 };
@@ -391,6 +396,11 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv);
 void cpsw_intr_enable(struct cpsw_common *cpsw);
 void cpsw_intr_disable(struct cpsw_common *cpsw);
 int cpsw_tx_handler(void *token, int len, int status);
+void cpsw_xdp_rxq_unreg(struct cpsw_common *cpsw, int ch);
+struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw, int size);
+int cpsw_xdp_reg_rxq(struct cpsw_priv *priv, int ch);
+int cpsw_xdp_reg_rxqs(struct cpsw_priv *priv);
+void cpsw_xdp_unreg_rxqs(struct cpsw_priv *priv);
 
 /* ethtool */
 u32 cpsw_get_msglevel(struct net_device *ndev);
-- 
2.17.1

