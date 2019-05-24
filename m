Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1A929D78
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391637AbfEXRuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:50:16 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:49186 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390929AbfEXRuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 13:50:15 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x4OHnoWs089077;
        Fri, 24 May 2019 12:49:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1558720190;
        bh=2cTisi/y0uKwKNufdSECX78KXEoYdqF9x4ODZtNjdnM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Ryas6VNYKiESU86SdE2JUfo9djDdKEEQkqf4k9+1Hj0Uwt/vIFH0IgWMqdODOUHku
         LLnBdwXl9ZbhVrld5UbEP07YEDbyIoKr2capZHcELInbnVK39zj8vbupEAMmiEolQI
         jarq7RNJzY9yfqTw5yEvQCPiPLbMjcK6CpFBMWcU=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x4OHno6X037326
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 24 May 2019 12:49:50 -0500
Received: from DLEE107.ent.ti.com (157.170.170.37) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 24
 May 2019 12:49:50 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE107.ent.ti.com
 (157.170.170.37) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 24 May 2019 12:49:50 -0500
Received: from [10.250.96.121] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id x4OHnk3U118139;
        Fri, 24 May 2019 12:49:46 -0500
Subject: Re: [PATCH net-next 3/3] net: ethernet: ti: cpsw: add XDP support
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>, <hawk@kernel.org>,
        <davem@davemloft.net>
CC:     <ast@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <xdp-newbies@vger.kernel.org>,
        <ilias.apalodimas@linaro.org>, <netdev@vger.kernel.org>,
        <daniel@iogearbox.net>, <jakub.kicinski@netronome.com>,
        <john.fastabend@gmail.com>
References: <20190523182035.9283-1-ivan.khoronzhuk@linaro.org>
 <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
From:   grygorii <grygorii.strashko@ti.com>
Message-ID: <6a88616b-9a49-77c3-577e-40670f62f953@ti.com>
Date:   Fri, 24 May 2019 20:49:38 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190523182035.9283-4-ivan.khoronzhuk@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ivan,

On 23/05/2019 21:20, Ivan Khoronzhuk wrote:
> Add XDP support based on rx page_pool allocator, one frame per page.
> Page pool allocator is used with assumption that only one rx_handler
> is running simultaneously. DMA map/unmap is reused from page pool
> despite there is no need to map whole page.
> 
> Due to specific of cpsw, the same TX/RX handler can be used by 2
> network devices, so special fields in buffer are added to identify
> an interface the frame is destined to. Thus XDP works for both
> interfaces, that allows to test xdp redirect between two interfaces
> easily.
> 
> XDP prog is common for all channels till appropriate changes are added
> in XDP infrastructure.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>   drivers/net/ethernet/ti/Kconfig        |   1 +
>   drivers/net/ethernet/ti/cpsw.c         | 555 ++++++++++++++++++++++---
>   drivers/net/ethernet/ti/cpsw_ethtool.c |  53 +++
>   drivers/net/ethernet/ti/cpsw_priv.h    |   7 +
>   4 files changed, 554 insertions(+), 62 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> index bd05a977ee7e..3cb8c5214835 100644
> --- a/drivers/net/ethernet/ti/Kconfig
> +++ b/drivers/net/ethernet/ti/Kconfig
> @@ -50,6 +50,7 @@ config TI_CPSW
>   	depends on ARCH_DAVINCI || ARCH_OMAP2PLUS || COMPILE_TEST
>   	select TI_DAVINCI_MDIO
>   	select MFD_SYSCON
> +	select PAGE_POOL
>   	select REGMAP
>   	---help---
>   	  This driver supports TI's CPSW Ethernet Switch.
> diff --git a/drivers/net/ethernet/ti/cpsw.c b/drivers/net/ethernet/ti/cpsw.c
> index 87a600aeee4a..274e6b64ea9e 100644
> --- a/drivers/net/ethernet/ti/cpsw.c
> +++ b/drivers/net/ethernet/ti/cpsw.c
> @@ -31,6 +31,10 @@
>   #include <linux/if_vlan.h>
>   #include <linux/kmemleak.h>
>   #include <linux/sys_soc.h>
> +#include <net/page_pool.h>
> +#include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
> +#include <linux/filter.h>
>   
>   #include <linux/pinctrl/consumer.h>
>   #include <net/pkt_cls.h>
> @@ -60,6 +64,10 @@ static int descs_pool_size = CPSW_CPDMA_DESCS_POOL_SIZE_DEFAULT;
>   module_param(descs_pool_size, int, 0444);
>   MODULE_PARM_DESC(descs_pool_size, "Number of CPDMA CPPI descriptors in pool");
>   
> +/* The buf includes headroom compatible with both skb and xdpf */
> +#define CPSW_HEADROOM_NA (max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + NET_IP_ALIGN)
> +#define CPSW_HEADROOM  ALIGN(CPSW_HEADROOM_NA, sizeof(long))
> +
>   #define for_each_slave(priv, func, arg...)				\
>   	do {								\
>   		struct cpsw_slave *slave;				\
> @@ -74,6 +82,8 @@ MODULE_PARM_DESC(descs_pool_size, "Number of CPDMA CPPI descriptors in pool");
>   				(func)(slave++, ##arg);			\
>   	} while (0)
>   
> +#define CPSW_XMETA_OFFSET	ALIGN(sizeof(struct xdp_frame), sizeof(long))
> +
>   static int cpsw_ndo_vlan_rx_add_vid(struct net_device *ndev,
>   				    __be16 proto, u16 vid);
>   
> @@ -337,24 +347,58 @@ void cpsw_intr_disable(struct cpsw_common *cpsw)
>   	return;
>   }

[..]

>   
> +static int cpsw_xdp_tx_frame_mapped(struct cpsw_priv *priv,
> +				    struct xdp_frame *xdpf, struct page *page)
> +{
> +	struct cpsw_common *cpsw = priv->cpsw;
> +	struct cpsw_meta_xdp *xmeta;
> +	struct netdev_queue *txq;
> +	struct cpdma_chan *txch;
> +	dma_addr_t dma;
> +	int ret;
> +
> +	xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
> +	xmeta->ch = 0;
> +
> +	txch = cpsw->txv[0].ch;
> +	dma = (xdpf->data - (void *)xdpf) + page->dma_addr;
> +	ret = cpdma_chan_submit_mapped(txch, cpsw_xdpf_to_handle(xdpf), dma,
> +				       xdpf->len,
> +				       priv->emac_port + cpsw->data.dual_emac);
> +	if (ret) {
> +		xdp_return_frame_rx_napi(xdpf);
> +		goto stop;
> +	}
> +
> +	/* no tx desc - stop sending us tx frames */
> +	if (unlikely(!cpdma_check_free_tx_desc(txch)))
> +		goto stop;
> +
> +	return ret;
> +stop:
> +	txq = netdev_get_tx_queue(priv->ndev, 0);
> +	netif_tx_stop_queue(txq);
> +
> +	/* Barrier, so that stop_queue visible to other cpus */
> +	smp_mb__after_atomic();
> +
> +	if (cpdma_check_free_tx_desc(txch))
> +		netif_tx_wake_queue(txq);
> +
> +	return ret;
> +}
> +
> +static int cpsw_xdp_tx_frame(struct cpsw_priv *priv, struct xdp_frame *xdpf)
> +{
> +	struct cpsw_common *cpsw = priv->cpsw;
> +	struct cpsw_meta_xdp *xmeta;
> +	struct netdev_queue *txq;
> +	struct cpdma_chan *txch;
> +	int ret;
> +
> +	xmeta = (void *)xdpf + CPSW_XMETA_OFFSET;
> +	if (sizeof(*xmeta) > xdpf->headroom)
> +		return -EINVAL;
> +
> +	xmeta->ndev = priv->ndev;
> +	xmeta->ch = 0;
> +
> +	txch = cpsw->txv[0].ch;
> +	ret = cpdma_chan_submit(txch, cpsw_xdpf_to_handle(xdpf), xdpf->data,
> +				xdpf->len,
> +				priv->emac_port + cpsw->data.dual_emac);
> +	if (ret) {
> +		xdp_return_frame_rx_napi(xdpf);
> +		goto stop;
> +	}
> +
> +	/* no tx desc - stop sending us tx frames */
> +	if (unlikely(!cpdma_check_free_tx_desc(txch)))
> +		goto stop;
> +
> +	return ret;
> +stop:
> +	txq = netdev_get_tx_queue(priv->ndev, 0);
> +	netif_tx_stop_queue(txq);
> +
> +	/* Barrier, so that stop_queue visible to other cpus */
> +	smp_mb__after_atomic();
> +
> +	if (cpdma_check_free_tx_desc(txch))
> +		netif_tx_wake_queue(txq);
> +
> +	return ret;
> +}

Above 2 functions are mostly identical - could you do smth. with it?

> +
> +static int cpsw_run_xdp(struct cpsw_priv *priv, struct cpsw_vector *rxv,
> +			struct xdp_buff *xdp, struct page *page)
> +{
> +	struct net_device *ndev = priv->ndev;
> +	struct xdp_frame *xdpf;
> +	struct bpf_prog *prog;
> +	int ret = 1;
> +	u32 act;
> +
> +	rcu_read_lock();
> +
> +	prog = READ_ONCE(priv->xdp_prog);
> +	if (!prog) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_PASS:
> +		ret = 0;
> +		break;
> +	case XDP_TX:
> +		xdpf = convert_to_xdp_frame(xdp);
> +		if (unlikely(!xdpf))
> +			xdp_return_buff(xdp);
> +		else
> +			cpsw_xdp_tx_frame_mapped(priv, xdpf, page);
> +		break;
> +	case XDP_REDIRECT:
> +		if (xdp_do_redirect(ndev, xdp, prog))
> +			xdp_return_buff(xdp);
> +		else
> +			ret = 2;

could we avoid using consts as return values?
may be some informative defines/enum?

> +		break;
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +		/* fall through */
> +	case XDP_ABORTED:
> +		trace_xdp_exception(ndev, prog, act);
> +		/* fall through -- handle aborts by dropping packet */
> +	case XDP_DROP:
> +		xdp_return_buff(xdp);
> +		break;
> +	}
> +out:
> +	rcu_read_unlock();
> +	return ret;
> +}
> +
> +static unsigned int cpsw_rxbuf_total_len(unsigned int len)
> +{
> +	len += CPSW_HEADROOM;
> +	len += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
> +	return SKB_DATA_ALIGN(len);
> +}
> +
> +struct page_pool *cpsw_create_rx_pool(struct cpsw_common *cpsw)
> +{
> +	struct page_pool_params pp_params = { 0 };
> +	struct page_pool *pool;
> +
> +	pp_params.order = 0;
> +	pp_params.flags = PP_FLAG_DMA_MAP;
> +
> +	/* set it to number of RX descriptors, but can be more */
> +	pp_params.pool_size = cpdma_get_num_rx_descs(cpsw->dma);
> +	pp_params.nid = NUMA_NO_NODE;
> +	pp_params.dma_dir = DMA_BIDIRECTIONAL;
> +	pp_params.dev = cpsw->dev;
> +
> +	pool = page_pool_create(&pp_params);
> +	if (IS_ERR(pool))
> +		dev_err(cpsw->dev, "cannot create rx page pool\n");
> +
> +	return pool;
> +}
> +
> +static struct page *cpsw_alloc_page(struct cpsw_common *cpsw)
> +{
> +	struct page_pool *pool = cpsw->rx_page_pool;
> +	struct page *page, *prev_page = NULL;
> +	int try = pool->p.pool_size << 2;
> +	int start_free = 0, ret;
> +
> +	do {
> +		page = page_pool_dev_alloc_pages(pool);
> +		if (!page)
> +			return NULL;
> +
> +		/* if netstack has page_pool recycling remove the rest */
> +		if (page_ref_count(page) == 1)
> +			break;
> +
> +		/* start free pages in use, shouldn't happen */
> +		if (prev_page == page || start_free) {
> +			/* dma unmap/puts page if rfcnt != 1 */
> +			page_pool_recycle_direct(pool, page);
> +			start_free = 1;
> +			continue;
> +		}
> +
> +		/* if refcnt > 1, page has been holding by netstack, it's pity,
> +		 * so put it to the ring to be consumed later when fast cash is
> +		 * empty. If ring is full then free page by recycling as above.
> +		 */
> +		ret = ptr_ring_produce(&pool->ring, page);
> +		if (ret) {
> +			page_pool_recycle_direct(pool, page);
> +			continue;
> +		}
> +
> +		if (!prev_page)
> +			prev_page = page;
> +	} while (try--);
> +
> +	return page;
> +}
> +
>   static int cpsw_rx_handler(void *token, int len, int status)
>   {
> -	struct cpdma_chan	*ch;
> -	struct sk_buff		*skb = token;
> -	struct sk_buff		*new_skb;
> -	struct net_device	*ndev = skb->dev;
> -	int			ret = 0, port;
> -	struct cpsw_common	*cpsw = ndev_to_cpsw(ndev);
> +	struct page		*new_page, *page = token;
> +	void			*pa = page_address(page);
> +	struct cpsw_meta_xdp	*xmeta = pa + CPSW_XMETA_OFFSET;
> +	struct cpsw_common	*cpsw = ndev_to_cpsw(xmeta->ndev);
> +	int			pkt_size = cpsw->rx_packet_max;
> +	int			ret = 0, port, ch = xmeta->ch;
> +	struct page_pool	*pool = cpsw->rx_page_pool;
> +	int			headroom = CPSW_HEADROOM;
> +	struct net_device	*ndev = xmeta->ndev;
> +	int			flush = 0;
>   	struct cpsw_priv	*priv;
> +	struct sk_buff		*skb;
> +	struct xdp_buff		xdp;
> +	dma_addr_t		dma;
>   
>   	if (cpsw->data.dual_emac) {
>   		port = CPDMA_RX_SOURCE_PORT(status);
> -		if (port) {
> +		if (port)
>   			ndev = cpsw->slaves[--port].ndev;
> -			skb->dev = ndev;
> -		}
>   	}
>   
>   	if (unlikely(status < 0) || unlikely(!netif_running(ndev))) {
> @@ -429,47 +680,101 @@ static int cpsw_rx_handler(void *token, int len, int status)
>   			 * in reducing of the number of rx descriptor in
>   			 * DMA engine, requeue skb back to cpdma.
>   			 */
> -			new_skb = skb;
> +			new_page = page;
>   			goto requeue;
>   		}
>   
>   		/* the interface is going down, skbs are purged */
> -		dev_kfree_skb_any(skb);
> +		page_pool_recycle_direct(pool, page);
>   		return 0;
>   	}
>   
> -	new_skb = netdev_alloc_skb_ip_align(ndev, cpsw->rx_packet_max);
> -	if (new_skb) {
> -		skb_copy_queue_mapping(new_skb, skb);
> -		skb_put(skb, len);
> -		if (status & CPDMA_RX_VLAN_ENCAP)
> -			cpsw_rx_vlan_encap(skb);
> -		priv = netdev_priv(ndev);
> -		if (priv->rx_ts_enabled)
> -			cpts_rx_timestamp(cpsw->cpts, skb);
> -		skb->protocol = eth_type_trans(skb, ndev);
> -		netif_receive_skb(skb);
> -		ndev->stats.rx_bytes += len;
> -		ndev->stats.rx_packets++;
> -		kmemleak_not_leak(new_skb);
> -	} else {
> +	new_page = cpsw_alloc_page(cpsw);
> +	if (unlikely(!new_page)) {
> +		new_page = page;
>   		ndev->stats.rx_dropped++;
> -		new_skb = skb;
> +		goto requeue;
>   	}
>   
> +	priv = netdev_priv(ndev);
> +	if (priv->xdp_prog) {
> +		if (status & CPDMA_RX_VLAN_ENCAP) {
> +			xdp.data = (void *)pa + CPSW_HEADROOM +
> +				   CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> +			xdp.data_end = xdp.data + len -
> +				       CPSW_RX_VLAN_ENCAP_HDR_SIZE;
> +		} else {
> +			xdp.data = (void *)pa + CPSW_HEADROOM;
> +			xdp.data_end = xdp.data + len;
> +		}
> +
> +		xdp_set_data_meta_invalid(&xdp);
> +
> +		xdp.data_hard_start = pa;
> +		xdp.rxq = &priv->xdp_rxq[ch];
> +
> +		ret = cpsw_run_xdp(priv, &cpsw->rxv[ch], &xdp, page);
> +		if (ret) {
> +			if (ret == 2)
> +				flush = 1;

const?

> +
> +			goto requeue;
> +		}
> +
> +		/* XDP prog might have changed packet data and boundaries */
> +		len = xdp.data_end - xdp.data;
> +		headroom = xdp.data - xdp.data_hard_start;
> +	}
> +
> +	/* Build skb and pass it to netstack if XDP off or XDP prog
> +	 * returned XDP_PASS
> +	 */
> +	skb = build_skb(pa, cpsw_rxbuf_total_len(pkt_size));
> +	if (!skb) {
> +		ndev->stats.rx_dropped++;
> +		page_pool_recycle_direct(pool, page);
> +		goto requeue;
> +	}
> +
> +	skb_reserve(skb, headroom);
> +	skb_put(skb, len);
> +	skb->dev = ndev;
> +	if (status & CPDMA_RX_VLAN_ENCAP)
> +		cpsw_rx_vlan_encap(skb);
> +	if (priv->rx_ts_enabled)
> +		cpts_rx_timestamp(cpsw->cpts, skb);
> +	skb->protocol = eth_type_trans(skb, ndev);
> +
> +	/* recycle page before increasing refcounter, it allows to hold page in
> +	 * page pool cache improving allocation time, see cpsw_alloc_page().
> +	 */
> +	page_pool_recycle_direct(pool, page);
> +
> +	/* remove once ordinary netstack has page_pool recycling */
> +	page_ref_inc(page);
> +
> +	netif_receive_skb(skb);
> +
> +	ndev->stats.rx_bytes += len;
> +	ndev->stats.rx_packets++;
> +
>   requeue:
>   	if (netif_dormant(ndev)) {
> -		dev_kfree_skb_any(new_skb);
> -		return 0;
> +		page_pool_recycle_direct(pool, new_page);
> +		return flush;
>   	}
>   
> -	ch = cpsw->rxv[skb_get_queue_mapping(new_skb)].ch;
> -	ret = cpdma_chan_submit(ch, new_skb, new_skb->data,
> -				skb_tailroom(new_skb), 0);
> +	xmeta = page_address(new_page) + CPSW_XMETA_OFFSET;
> +	xmeta->ndev = ndev;
> +	xmeta->ch = ch;
> +
> +	dma = new_page->dma_addr + CPSW_HEADROOM;
> +	ret = cpdma_chan_submit_mapped(cpsw->rxv[ch].ch, new_page, dma,
> +				       pkt_size, 0);
>   	if (WARN_ON(ret < 0))
> -		dev_kfree_skb_any(new_skb);
> +		page_pool_recycle_direct(pool, new_page);
>   
> -	return 0;
> +	return flush;
>   }
>   
>   void cpsw_split_res(struct cpsw_common *cpsw)
> @@ -644,7 +949,7 @@ static int cpsw_tx_poll(struct napi_struct *napi_tx, int budget)
>   static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
>   {
>   	u32			ch_map;
> -	int			num_rx, cur_budget, ch;
> +	int			num_rx, cur_budget, ch, flush;
>   	struct cpsw_common	*cpsw = napi_to_cpsw(napi_rx);
>   	struct cpsw_vector	*rxv;
>   
> @@ -660,8 +965,12 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
>   		else
>   			cur_budget = rxv->budget;
>   
> -		cpdma_chan_process(rxv->ch, &cur_budget);
> +		flush = cpdma_chan_process(rxv->ch, &cur_budget);
>   		num_rx += cur_budget;
> +
> +		if (flush)
> +			xdp_do_flush_map();

const?

> +
>   		if (num_rx >= budget)
>   			break;
>   	}
> @@ -677,10 +986,15 @@ static int cpsw_rx_mq_poll(struct napi_struct *napi_rx, int budget)
>   static int cpsw_rx_poll(struct napi_struct *napi_rx, int budget)

Thank you

-- 
Best regards,
grygorii
