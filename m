Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE1C555686
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbfFYSAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:00:04 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40677 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732638AbfFYSAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:00:02 -0400
Received: by mail-lj1-f193.google.com with SMTP id a21so17164035ljh.7
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 10:59:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=1vn3So6QWrUyKa05+VTqdCOimBtaYdSWE5kaxEuJFc0=;
        b=F1RcONoNYhD1uUg1PWnGkq6+GLbJl9yeppcM7BreXX6P6MMFs4pu3TilJvQK+02X14
         nRs7B0RHOCQ3qy/YTINookKSeqPAcmBfpIsebWByZkV5VTqWBzjSnSAtCl5Ulkrwp8i9
         9ro7MIf2NyOj3Ds9v6a4nJRZPaR3yNSyZOu5uU2W6nroyvr2P14wTM/B4LOlPnm6l8ne
         I7z8VQhW9SyQI08AqlPgNt2mQLqjcJT2zHTePZH2U8vR7bZeImWX40S92sy2L1cupqv7
         n0UMqsK9oygmvkJXy1drNbt/a/6OEEkba4b1fZJmFu/i+nwSXUw5Bt2yJF+Aoit1YX02
         DzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=1vn3So6QWrUyKa05+VTqdCOimBtaYdSWE5kaxEuJFc0=;
        b=HAk33gcq9awpjHbQrGHus06UQ/SHoiunjVSMF+DaHay6Fi+GATky7SB/rwfpZFgMIg
         XAbeOi+ocbX7t2n8vUYvJDpNrvCX762sWTk2VVG8ZlHnPzRg6Ch9YyplPAC3rP4jNc/f
         IoKs+7sevYShGx2nsm/3sH521T29uXqImMBaYd92y236tUxoYeRW1FaHFyi4CQHmy/PU
         /LW2hBsG6HH1tCzwn96anf6+idoIwvwSe6vcJouoh98mfoh/PoyJ4S03XRABfdu2MpRF
         Dn3HYL4fommCERejYVl9YEYiStT3aFrxC0PYeUjZQrnqeua13hQyPFL1EXImDF1P2ejy
         cB5g==
X-Gm-Message-State: APjAAAUSsQnKKTOYZ3T3QIGv39vFQMAuyohMlBbe9VCxFI6mhLlwzNF7
        ERhXKbTsCPgk3QIWaPLQNHugJA==
X-Google-Smtp-Source: APXvYqylY2tXOeKBKskHpFqp+p+KmxnVkkuimo7N863CrUTfTVNOO0W2CUGPXbFsaqt3+kNLg+3Fmw==
X-Received: by 2002:a2e:95d5:: with SMTP id y21mr67643907ljh.84.1561485597245;
        Tue, 25 Jun 2019 10:59:57 -0700 (PDT)
Received: from localhost.localdomain (59-201-94-178.pool.ukrtel.net. [178.94.201.59])
        by smtp.gmail.com with ESMTPSA id g76sm2367597lje.43.2019.06.25.10.59.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 10:59:56 -0700 (PDT)
From:   Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
To:     davem@davemloft.net, grygorii.strashko@ti.com, hawk@kernel.org,
        brouer@redhat.com, saeedm@mellanox.com, leon@kernel.org
Cc:     ast@kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, xdp-newbies@vger.kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        daniel@iogearbox.net, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Subject: [PATCH v4 net-next 4/4] net: ethernet: ti: cpsw: add XDP support
Date:   Tue, 25 Jun 2019 20:59:48 +0300
Message-Id: <20190625175948.24771-5-ivan.khoronzhuk@linaro.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
References: <20190625175948.24771-1-ivan.khoronzhuk@linaro.org>
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
easily. Aslo, each rx queue have own page pools, but common for both
netdevs.

XDP prog is common for all channels till appropriate changes are added
in XDP infrastructure. Also, once page_pool recycling becomes part of
skb netstack some simplifications can be added, like removing  marked
with comments.

Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
---
 drivers/net/ethernet/ti/Kconfig        |   1 +
 drivers/net/ethernet/ti/cpsw.c         | 521 ++++++++++++++++++++++---
 drivers/net/ethernet/ti/cpsw_ethtool.c |  23 +-
 drivers/net/ethernet/ti/cpsw_priv.h    |   7 +
 4 files changed, 489 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
index a800d3417411..834afca3a019 100644
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
index 726925df8d97..b3c526b3a1c7 100644
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
+		xdp_return_frame(xdpf);
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
 
@@ -401,24 +450,249 @@ static void cpsw_rx_vlan_encap(struct sk_buff *skb)
 	}
 }
 
+static int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf,
+			     struct page *page)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct cpsw_meta_xdp *xmeta;
+	struct cpdma_chan *txch;
+	dma_addr_t dma;
+	int ret, port;
+
+	xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
+	xmeta->ndev = priv->ndev;
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
+		ret = cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf),
+					xdpf->data, xdpf->len, port);
+	}
+
+	if (ret)
+		xdp_return_frame_rx_napi(xdpf);
+
+	return ret;
+}
+
+static int cpsw_run_xdp(struct cpsw_priv *priv, int ch, struct xdp_buff *xdp,
+			struct page *page)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
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
+	page_pool_recycle_direct(cpsw->page_pool[ch], page);
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
+static struct page_pool *cpsw_create_page_pool(struct cpsw_common *cpsw,
+					       int size)
+{
+	struct page_pool_params pp_params;
+	struct page_pool *pool;
+
+	pp_params.order = 0;
+	pp_params.flags = PP_FLAG_DMA_MAP;
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
+static int cpsw_ndev_create_xdp_rxq(struct cpsw_priv *priv, int ch)
+{
+	struct cpsw_common *cpsw = priv->cpsw;
+	struct xdp_rxq_info *rxq;
+	struct page_pool *pool;
+	int ret;
+
+	pool = cpsw->page_pool[ch];
+	rxq = &priv->xdp_rxq[ch];
+
+	ret = xdp_rxq_info_reg(rxq, priv->ndev, ch);
+	if (ret)
+		return ret;
+
+	ret = xdp_rxq_info_reg_mem_model(rxq, MEM_TYPE_PAGE_POOL, pool);
+	if (ret)
+		xdp_rxq_info_unreg(rxq);
+
+	return ret;
+}
+
+static void cpsw_ndev_destroy_xdp_rxq(struct cpsw_priv *priv, int ch)
+{
+	struct xdp_rxq_info *rxq = &priv->xdp_rxq[ch];
+
+	if (!xdp_rxq_info_is_reg(rxq))
+		return;
+
+	xdp_rxq_info_unreg(rxq);
+}
+
+static int cpsw_create_rx_pool(struct cpsw_common *cpsw, int ch)
+{
+	struct page_pool *pool;
+	int ret = 0, pool_size;
+
+	pool_size = cpdma_chan_get_rx_buf_num(cpsw->rxv[ch].ch);
+	pool = cpsw_create_page_pool(cpsw, pool_size);
+	if (IS_ERR(pool))
+		ret = PTR_ERR(pool);
+	else
+		cpsw->page_pool[ch] = pool;
+
+	return ret;
+}
+
+void cpsw_destroy_rx_pools(struct cpsw_common *cpsw)
+{
+	struct net_device *ndev;
+	int i, ch;
+
+	for (ch = 0; ch < cpsw->rx_ch_num; ch++) {
+		if (!cpsw->page_pool[ch])
+			continue;
+
+		for (i = 0; i < cpsw->data.slaves; i++) {
+			ndev = cpsw->slaves[i].ndev;
+			if (!ndev)
+				continue;
+
+			cpsw_ndev_destroy_xdp_rxq(netdev_priv(ndev), ch);
+		}
+
+		page_pool_free(cpsw->page_pool[ch]);
+		cpsw->page_pool[ch] = NULL;
+	}
+}
+
+int cpsw_create_rx_pools(struct cpsw_common *cpsw)
+{
+	struct net_device *ndev;
+	int i, ch, ret;
+
+	for (ch = 0; ch < cpsw->rx_ch_num; ch++) {
+		ret = cpsw_create_rx_pool(cpsw, ch);
+		if (ret)
+			goto err_cleanup;
+
+		/* using same page pool is allowed as no running rx handlers
+		 * simultaneously for both ndevs
+		 */
+		for (i = 0; i < cpsw->data.slaves; i++) {
+			ndev = cpsw->slaves[i].ndev;
+			if (!ndev)
+				continue;
+
+			ret = cpsw_ndev_create_xdp_rxq(netdev_priv(ndev), ch);
+			if (ret)
+				goto err_cleanup;
+		}
+	}
+
+	return 0;
+
+err_cleanup:
+	cpsw_destroy_rx_pools(cpsw);
+
+	return ret;
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
+	int			headroom = CPSW_HEADROOM;
+	struct net_device	*ndev = xmeta->ndev;
+	int			res = 0;
 	struct cpsw_priv	*priv;
+	struct page_pool	*pool;
+	struct sk_buff		*skb;
+	struct xdp_buff		xdp;
+	dma_addr_t		dma;
 
-	if (cpsw->data.dual_emac) {
+	if (cpsw->data.dual_emac && status >= 0) {
 		port = CPDMA_RX_SOURCE_PORT(status);
-		if (port) {
+		if (port)
 			ndev = cpsw->slaves[--port].ndev;
-			skb->dev = ndev;
-		}
 	}
 
+	priv = netdev_priv(ndev);
+	pool = cpsw->page_pool[ch];
 	if (unlikely(status < 0) || unlikely(!netif_running(ndev))) {
 		/* In dual emac mode check for all interfaces */
 		if (cpsw->data.dual_emac && cpsw->usage_count &&
@@ -427,46 +701,94 @@ static int cpsw_rx_handler(void *token, int len, int status)
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
+	new_page = page_pool_dev_alloc_pages(pool);
+	if (unlikely(!new_page)) {
+		new_page = page;
+		ndev->stats.rx_dropped++;
+		goto requeue;
+	}
+
+	if (priv->xdp_prog) {
+		if (status & CPDMA_RX_VLAN_ENCAP) {
+			xdp.data = pa + CPSW_HEADROOM +
+				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
+			xdp.data_end = xdp.data + len -
+				       CPSW_RX_VLAN_ENCAP_HDR_SIZE;
+		} else {
+			xdp.data = pa + CPSW_HEADROOM;
+			xdp.data_end = xdp.data + len;
+		}
+
+		xdp_set_data_meta_invalid(&xdp);
+
+		xdp.data_hard_start = pa;
+		xdp.rxq = &priv->xdp_rxq[ch];
+
+		ret = cpsw_run_xdp(priv, ch, &xdp, page);
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
+
+		/* XDP prog can modify vlan tag, so can't use encap header */
+		status &= ~CPDMA_RX_VLAN_ENCAP;
+	}
+
+	/* pass skb to netstack if no XDP prog or returned XDP_PASS */
+	skb = build_skb(pa, cpsw_rxbuf_total_len(pkt_size));
+	if (!skb) {
 		ndev->stats.rx_dropped++;
-		new_skb = skb;
+		page_pool_recycle_direct(pool, page);
+		goto requeue;
 	}
 
+	skb_reserve(skb, headroom);
+	skb_put(skb, len);
+	skb->dev = ndev;
+	if (status & CPDMA_RX_VLAN_ENCAP)
+		cpsw_rx_vlan_encap(skb);
+	if (priv->rx_ts_enabled)
+		cpts_rx_timestamp(cpsw->cpts, skb);
+	skb->protocol = eth_type_trans(skb, ndev);
+
+	/* unmap page as no netstack skb page recycling */
+	page_pool_release_page(pool, page);
+	netif_receive_skb(skb);
+
+	ndev->stats.rx_bytes += len;
+	ndev->stats.rx_packets++;
+
 requeue:
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
 	if (ret < 0) {
 		WARN_ON(ret == -ENOMEM);
-		dev_kfree_skb_any(new_skb);
+		page_pool_recycle_direct(pool, new_page);
 	}
 
-	return 0;
+	return res;
 }
 
 void cpsw_split_res(struct cpsw_common *cpsw)
@@ -641,8 +963,8 @@ static int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
 static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
 {
 	u32			ch_map;
-	int			num_rx, cur_budget, ch;
 	struct cpsw_common	*cpsw = napi_to_cpsw(napi_rx);
+	int			num_rx, cur_budget, ch, res;
 	struct cpsw_vector	*rxv;
 
 	/* process every unprocessed channel */
@@ -657,8 +979,12 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
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
@@ -674,10 +1000,15 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
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
@@ -1039,33 +1370,39 @@ static void cpsw_init_host_port(struct cpsw_priv *priv)
 int cpsw_fill_rx_channels(struct cpsw_priv *priv)
 {
 	struct cpsw_common *cpsw = priv->cpsw;
-	struct sk_buff *skb;
+	struct cpsw_meta_xdp *xmeta;
+	struct page_pool *pool;
+	struct page *page;
 	int ch_buf_num;
 	int ch, i, ret;
+	dma_addr_t dma;
 
 	for (ch = 0; ch < cpsw->rx_ch_num; ch++) {
+		pool = cpsw->page_pool[ch];
 		ch_buf_num = cpdma_chan_get_rx_buf_num(cpsw->rxv[ch].ch);
 		for (i = 0; i < ch_buf_num; i++) {
-			skb = __netdev_alloc_skb_ip_align(priv->ndev,
-							  cpsw->rx_packet_max,
-							  GFP_KERNEL);
-			if (!skb) {
-				cpsw_err(priv, ifup, "cannot allocate skb\n");
+			page = page_pool_dev_alloc_pages(pool);
+			if (!page) {
+				cpsw_err(priv, ifup, "allocate rx page err\n");
 				return -ENOMEM;
 			}
 
-			skb_set_queue_mapping(skb, ch);
-			ret = cpdma_chan_idle_submit(cpsw->rxv[ch].ch, skb,
-						     skb->data,
-						     skb_tailroom(skb), 0);
+			xmeta = page_address(page) + CPSW_XMETA_OFFSET;
+			xmeta->ndev = priv->ndev;
+			xmeta->ch = ch;
+
+			dma = page_pool_get_dma_addr(page) + CPSW_HEADROOM;
+			ret = cpdma_chan_idle_submit_mapped(cpsw->rxv[ch].ch,
+							    page, dma,
+							    cpsw->rx_packet_max,
+							    0);
 			if (ret < 0) {
 				cpsw_err(priv, ifup,
-					 "cannot submit skb to channel %d rx, error %d\n",
+					 "cannot submit page to channel %d rx, error %d\n",
 					 ch, ret);
-				kfree_skb(skb);
+				page_pool_recycle_direct(pool, page);
 				return ret;
 			}
-			kmemleak_not_leak(skb);
 		}
 
 		cpsw_info(priv, ifup, "ch %d rx, submitted %d descriptors\n",
@@ -1401,6 +1738,10 @@ static int cpsw_ndo_open(struct net_device *ndev)
 			enable_irq(cpsw->irqs_table[0]);
 		}
 
+		ret = cpsw_create_rx_pools(cpsw);
+		if (ret < 0)
+			goto err_cleanup;
+
 		ret = cpsw_fill_rx_channels(priv);
 		if (ret < 0)
 			goto err_cleanup;
@@ -1429,9 +1770,10 @@ static int cpsw_ndo_open(struct net_device *ndev)
 err_cleanup:
 	if (!cpsw->usage_count) {
 		cpdma_ctlr_stop(cpsw->dma);
-		for_each_slave(priv, cpsw_slave_stop, cpsw);
+		cpsw_destroy_rx_pools(cpsw);
 	}
 
+	for_each_slave(priv, cpsw_slave_stop, cpsw);
 	pm_runtime_put_sync(cpsw->dev);
 	netif_carrier_off(priv->ndev);
 	return ret;
@@ -1454,6 +1796,7 @@ static int cpsw_ndo_stop(struct net_device *ndev)
 		cpsw_intr_disable(cpsw);
 		cpdma_ctlr_stop(cpsw->dma);
 		cpsw_ale_stop(cpsw->ale);
+		cpsw_destroy_rx_pools(cpsw);
 	}
 	for_each_slave(priv, cpsw_slave_stop, cpsw);
 
@@ -2011,6 +2354,64 @@ static int cpsw_ndo_setup_tc(struct net_device *ndev, enum tc_setup_type type,
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
@@ -2039,6 +2440,8 @@ static const struct net_device_ops cpsw_netdev_ops = {
 	.ndo_vlan_rx_add_vid	= cpsw_ndo_vlan_rx_add_vid,
 	.ndo_vlan_rx_kill_vid	= cpsw_ndo_vlan_rx_kill_vid,
 	.ndo_setup_tc           = cpsw_ndo_setup_tc,
+	.ndo_bpf		= cpsw_ndo_bpf,
+	.ndo_xdp_xmit		= cpsw_ndo_xdp_xmit,
 };
 
 static void cpsw_get_drvinfo(struct net_device *ndev,
diff --git a/drivers/net/ethernet/ti/cpsw_ethtool.c b/drivers/net/ethernet/ti/cpsw_ethtool.c
index 7c19eebbabcc..d2007f5f988e 100644
--- a/drivers/net/ethernet/ti/cpsw_ethtool.c
+++ b/drivers/net/ethernet/ti/cpsw_ethtool.c
@@ -585,7 +585,7 @@ int cpsw_set_channels_common(struct net_device *ndev,
 	struct cpsw_priv *priv = netdev_priv(ndev);
 	struct cpsw_common *cpsw = priv->cpsw;
 	struct net_device *sl_ndev;
-	int i, ret;
+	int i, new_pools, ret;
 
 	ret = cpsw_check_ch_settings(cpsw, chs);
 	if (ret < 0)
@@ -593,6 +593,10 @@ int cpsw_set_channels_common(struct net_device *ndev,
 
 	cpsw_suspend_data_pass(ndev);
 
+	new_pools = (chs->rx_count != cpsw->rx_ch_num) && cpsw->usage_count;
+	if (new_pools)
+		cpsw_destroy_rx_pools(cpsw);
+
 	ret = cpsw_update_channels_res(priv, chs->rx_count, 1, rx_handler);
 	if (ret)
 		goto err;
@@ -623,6 +627,12 @@ int cpsw_set_channels_common(struct net_device *ndev,
 	if (cpsw->usage_count)
 		cpsw_split_res(cpsw);
 
+	if (new_pools) {
+		ret = cpsw_create_rx_pools(cpsw);
+		if (ret)
+			goto err;
+	}
+
 	ret = cpsw_resume_data_pass(ndev);
 	if (!ret)
 		return 0;
@@ -648,8 +658,7 @@ void cpsw_get_ringparam(struct net_device *ndev,
 int cpsw_set_ringparam(struct net_device *ndev,
 		       struct ethtool_ringparam *ering)
 {
-	struct cpsw_priv *priv = netdev_priv(ndev);
-	struct cpsw_common *cpsw = priv->cpsw;
+	struct cpsw_common *cpsw = ndev_to_cpsw(ndev);
 	int ret;
 
 	/* ignore ering->tx_pending - only rx_pending adjustment is supported */
@@ -664,15 +673,21 @@ int cpsw_set_ringparam(struct net_device *ndev,
 
 	cpsw_suspend_data_pass(ndev);
 
+	cpsw_destroy_rx_pools(cpsw);
+
 	cpdma_set_num_rx_descs(cpsw->dma, ering->rx_pending);
 
 	if (cpsw->usage_count)
 		cpdma_chan_split_pool(cpsw->dma);
 
+	ret = cpsw_create_rx_pools(cpsw);
+	if (ret)
+		goto err;
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
index 2ecb3af59fe9..8eeda3456f37 100644
--- a/drivers/net/ethernet/ti/cpsw_priv.h
+++ b/drivers/net/ethernet/ti/cpsw_priv.h
@@ -346,6 +346,7 @@ struct cpsw_common {
 	int				rx_ch_num, tx_ch_num;
 	int				speed;
 	int				usage_count;
+	struct page_pool		*page_pool[CPSW_MAX_QUEUES];
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
@@ -391,6 +396,8 @@ int cpsw_fill_rx_channels(struct cpsw_priv *priv);
 void cpsw_intr_enable(struct cpsw_common *cpsw);
 void cpsw_intr_disable(struct cpsw_common *cpsw);
 int cpsw_tx_handler(void *token, int len, int status);
+int cpsw_create_rx_pools(struct cpsw_common *cpsw);
+void cpsw_destroy_rx_pools(struct cpsw_common *cpsw);
 
 /* ethtool */
 u32 cpsw_get_msglevel(struct net_device *ndev);
-- 
2.17.1

