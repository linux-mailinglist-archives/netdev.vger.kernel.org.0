Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 007B45EC3C2
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 15:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiI0NJ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 09:09:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232440AbiI0NJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 09:09:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5157713CCB
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 06:09:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664284156;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w4dZ9lUcwQ3cEIIHpuzIEszZNR3T217M7xhZ5OeaVJQ=;
        b=DIyRIfOLU4O/74iQrmqqoLTWa7ZF2Q0PJRw7ufvIf2Jq+ovki4jbjG+hW7P6L7PIA9T+xX
        ZBBNHxXgxUw0GFbx1ZNEw6gmt+RUoSS5YWcTDMvBYdxclBFmFJpJguPsGg3ROvK3r/HBW5
        KAg5OFjtlDa87vs/W+fCEDtl5apE0bo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-frEAnJ7qPZC8pna-ms5UAw-1; Tue, 27 Sep 2022 09:09:13 -0400
X-MC-Unique: frEAnJ7qPZC8pna-ms5UAw-1
Received: by mail-wr1-f71.google.com with SMTP id s5-20020adfa285000000b0022ad5c2771cso2141501wra.18
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 06:09:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=w4dZ9lUcwQ3cEIIHpuzIEszZNR3T217M7xhZ5OeaVJQ=;
        b=i85bCJ5OCI/SLN3vbcdksgJ+VBCQK55N3TJOKZ0unFR65/CCgBQi8pftt8c3MqJUwy
         Yx2iMdTNmDwcZrLKn9nbv9nlD5JXozturs2zw3rn2009OyJS+/xLui84sv7RNiCpY1Kw
         dAnbW5zOSAiaTMblaUeGrYkYghu5KstnKaA/mX0gTGsGhsPsKwn4tctJeQcP3KLZ2SML
         HFEIdgps4TuFolwpEeJGrhY3tarl7P6LDgR+xgKPQqpOuyXiT8r4F/g74/E4648kosy0
         ydCVfrL1O/ScnNlS2J3ZhriONADOMXm5nRQv3KuZmtx4Zq7Mh1bDE4nrydNXH9UuhBrf
         0DIw==
X-Gm-Message-State: ACrzQf0V6zhwkLeGFDVoAQyfNlbY6HGvE86ckt7YvlfrcGFKp+3h167d
        /DmFxzhKVV/phrCmhbwazAP/RyA2K4o+TB73fvJXZ+xYstP9/V9FvT4UtFoUtdXpG/PSATgIl+C
        V+rkFCSISpIX3V+T5
X-Received: by 2002:a05:600c:34d2:b0:3b4:a617:f3b9 with SMTP id d18-20020a05600c34d200b003b4a617f3b9mr2592204wmq.204.1664284151651;
        Tue, 27 Sep 2022 06:09:11 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4ooxDIs2gLpoGsP+4tNvZZMWJpuWpwwkJid9/t+rDeMP8QgCpom4f9ZPuRG6IDNus6L9DMEw==
X-Received: by 2002:a05:600c:34d2:b0:3b4:a617:f3b9 with SMTP id d18-20020a05600c34d200b003b4a617f3b9mr2592156wmq.204.1664284151111;
        Tue, 27 Sep 2022 06:09:11 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-40.dyn.eolo.it. [146.241.104.40])
        by smtp.gmail.com with ESMTPSA id x14-20020adfec0e000000b0022a297950cesm1841106wrn.23.2022.09.27.06.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 06:09:10 -0700 (PDT)
Message-ID: <a3b05ee228164ad8479b823ffcb6d908e9c65d4a.camel@redhat.com>
Subject: Re: [PATCH net-next v2 10/12] net: dpaa2-eth: AF_XDP RX zero copy
 support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
Date:   Tue, 27 Sep 2022 15:09:09 +0200
In-Reply-To: <20220923154556.721511-11-ioana.ciornei@nxp.com>
References: <20220923154556.721511-1-ioana.ciornei@nxp.com>
         <20220923154556.721511-11-ioana.ciornei@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-09-23 at 18:45 +0300, Ioana Ciornei wrote:
> From: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
> 
> This patch adds the support for receiving packets via the AF_XDP
> zero-copy mechanism in the dpaa2-eth driver. The support is available
> only on the LX2160A SoC and variants because we are relying on the HW
> capability to associate a buffer pool to a specific queue (QDBIN), only
> available on newer WRIOP versions.
> 
> On the control path, the dpaa2_xsk_enable_pool() function is responsible
> to allocate a buffer pool (BP), setup this new BP to be used only on the
> requested queue and change the consume function to point to the XSK ZC
> one.
> We are forced to call dev_close() in order to change the queue to buffer
> pool association (dpaa2_xsk_set_bp_per_qdbin) . This also works in our
> favor since at dev_close() the buffer pools will be drained and at the
> later dev_open() call they will be again seeded, this time with buffers
> allocated from the XSK pool if needed.
> 
> On the data path, a new software annotation type is defined to be used
> only for the XSK scenarios. This will enable us to pass keep necessary
> information about a packet buffer between the moment in which it was
> seeded and when it's received by the driver. In the XSK case, we are
> keeping the associated xdp_buff.
> Depending on the action returned by the BPF program, we will do the
> following:
>  - XDP_PASS: copy the contents of the packet into a brand new skb,
>    recycle the initial buffer.
>  - XDP_TX: just enqueue the same frame descriptor back into the Tx path,
>    the buffer will get automatically released into the initial BP.
>  - XDP_REDIRECT: call xdp_do_redirect() and exit.
> 
> Signed-off-by: Robert-Ionut Alexa <robert-ionut.alexa@nxp.com>
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - none
> 
>  MAINTAINERS                                   |   1 +
>  drivers/net/ethernet/freescale/dpaa2/Makefile |   2 +-
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  | 131 ++++---
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.h  |  36 +-
>  .../net/ethernet/freescale/dpaa2/dpaa2-xsk.c  | 327 ++++++++++++++++++
>  5 files changed, 452 insertions(+), 45 deletions(-)
>  create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1415a1498d68..004411566f48 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6290,6 +6290,7 @@ F:	drivers/net/ethernet/freescale/dpaa2/Kconfig
>  F:	drivers/net/ethernet/freescale/dpaa2/Makefile
>  F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-eth*
>  F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-mac*
> +F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk*
>  F:	drivers/net/ethernet/freescale/dpaa2/dpkg.h
>  F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
>  F:	drivers/net/ethernet/freescale/dpaa2/dpni*
> diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
> index 3d9842af7f10..1b05ba8d1cbf 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/Makefile
> +++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
> @@ -7,7 +7,7 @@ obj-$(CONFIG_FSL_DPAA2_ETH)		+= fsl-dpaa2-eth.o
>  obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+= fsl-dpaa2-ptp.o
>  obj-$(CONFIG_FSL_DPAA2_SWITCH)		+= fsl-dpaa2-switch.o
>  
> -fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o dpaa2-eth-devlink.o
> +fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o dpaa2-mac.o dpmac.o dpaa2-eth-devlink.o dpaa2-xsk.o
>  fsl-dpaa2-eth-${CONFIG_FSL_DPAA2_ETH_DCB} += dpaa2-eth-dcb.o
>  fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
>  fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index d786740d1bdd..1e94506bf9e6 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -19,6 +19,7 @@
>  #include <net/pkt_cls.h>
>  #include <net/sock.h>
>  #include <net/tso.h>
> +#include <net/xdp_sock_drv.h>
>  
>  #include "dpaa2-eth.h"
>  
> @@ -104,8 +105,8 @@ static void dpaa2_ptp_onestep_reg_update_method(struct dpaa2_eth_priv *priv)
>  	priv->dpaa2_set_onestep_params_cb = dpaa2_update_ptp_onestep_direct;
>  }
>  
> -static void *dpaa2_iova_to_virt(struct iommu_domain *domain,
> -				dma_addr_t iova_addr)
> +void *dpaa2_iova_to_virt(struct iommu_domain *domain,
> +			 dma_addr_t iova_addr)
>  {
>  	phys_addr_t phys_addr;
>  
> @@ -279,23 +280,33 @@ static struct sk_buff *dpaa2_eth_build_frag_skb(struct dpaa2_eth_priv *priv,
>   * be released in the pool
>   */
>  static void dpaa2_eth_free_bufs(struct dpaa2_eth_priv *priv, u64 *buf_array,
> -				int count)
> +				int count, bool xsk_zc)
>  {
>  	struct device *dev = priv->net_dev->dev.parent;
> +	struct dpaa2_eth_swa *swa;
> +	struct xdp_buff *xdp_buff;
>  	void *vaddr;
>  	int i;
>  
>  	for (i = 0; i < count; i++) {
>  		vaddr = dpaa2_iova_to_virt(priv->iommu_domain, buf_array[i]);
> -		dma_unmap_page(dev, buf_array[i], priv->rx_buf_size,
> -			       DMA_BIDIRECTIONAL);
> -		free_pages((unsigned long)vaddr, 0);
> +
> +		if (!xsk_zc) {
> +			dma_unmap_page(dev, buf_array[i], priv->rx_buf_size,
> +				       DMA_BIDIRECTIONAL);
> +			free_pages((unsigned long)vaddr, 0);
> +		} else {
> +			swa = (struct dpaa2_eth_swa *)
> +				(vaddr + DPAA2_ETH_RX_HWA_SIZE);
> +			xdp_buff = swa->xsk.xdp_buff;
> +			xsk_buff_free(xdp_buff);
> +		}
>  	}
>  }
>  
> -static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
> -				  struct dpaa2_eth_channel *ch,
> -				  dma_addr_t addr)
> +void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
> +			   struct dpaa2_eth_channel *ch,
> +			   dma_addr_t addr)
>  {
>  	int retries = 0;
>  	int err;
> @@ -313,7 +324,8 @@ static void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
>  	}
>  
>  	if (err) {
> -		dpaa2_eth_free_bufs(priv, ch->recycled_bufs, ch->recycled_bufs_cnt);
> +		dpaa2_eth_free_bufs(priv, ch->recycled_bufs,
> +				    ch->recycled_bufs_cnt, ch->xsk_zc);
>  		ch->buf_count -= ch->recycled_bufs_cnt;
>  	}
>  
> @@ -377,10 +389,10 @@ static void dpaa2_eth_xdp_tx_flush(struct dpaa2_eth_priv *priv,
>  	fq->xdp_tx_fds.num = 0;
>  }
>  
> -static void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
> -				  struct dpaa2_eth_channel *ch,
> -				  struct dpaa2_fd *fd,
> -				  void *buf_start, u16 queue_id)
> +void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
> +			   struct dpaa2_eth_channel *ch,
> +			   struct dpaa2_fd *fd,
> +			   void *buf_start, u16 queue_id)
>  {
>  	struct dpaa2_faead *faead;
>  	struct dpaa2_fd *dest_fd;
> @@ -1652,37 +1664,63 @@ static int dpaa2_eth_set_tx_csum(struct dpaa2_eth_priv *priv, bool enable)
>  static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
>  			      struct dpaa2_eth_channel *ch)
>  {
> +	struct xdp_buff *xdp_buffs[DPAA2_ETH_BUFS_PER_CMD];
>  	struct device *dev = priv->net_dev->dev.parent;
>  	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
> +	struct dpaa2_eth_swa *swa;
>  	struct page *page;
>  	dma_addr_t addr;
>  	int retries = 0;
> -	int i, err;
> -
> -	for (i = 0; i < DPAA2_ETH_BUFS_PER_CMD; i++) {
> -		/* Allocate buffer visible to WRIOP + skb shared info +
> -		 * alignment padding
> -		 */
> -		/* allocate one page for each Rx buffer. WRIOP sees
> -		 * the entire page except for a tailroom reserved for
> -		 * skb shared info
> +	int i = 0, err;
> +	u32 batch;
> +
> +	/* Allocate buffers visible to WRIOP */
> +	if (!ch->xsk_zc) {
> +		for (i = 0; i < DPAA2_ETH_BUFS_PER_CMD; i++) {
> +			/* Also allocate skb shared info and alignment padding.
> +			 * There is one page for each Rx buffer. WRIOP sees
> +			 * the entire page except for a tailroom reserved for
> +			 * skb shared info
> +			 */
> +			page = dev_alloc_pages(0);
> +			if (!page)
> +				goto err_alloc;
> +
> +			addr = dma_map_page(dev, page, 0, priv->rx_buf_size,
> +					    DMA_BIDIRECTIONAL);
> +			if (unlikely(dma_mapping_error(dev, addr)))
> +				goto err_map;
> +
> +			buf_array[i] = addr;
> +
> +			/* tracing point */
> +			trace_dpaa2_eth_buf_seed(priv->net_dev,
> +						 page_address(page),
> +						 DPAA2_ETH_RX_BUF_RAW_SIZE,
> +						 addr, priv->rx_buf_size,
> +						 ch->bp->bpid);
> +		}
> +	} else if (xsk_buff_can_alloc(ch->xsk_pool, DPAA2_ETH_BUFS_PER_CMD)) {
> +		/* Allocate XSK buffers for AF_XDP fast path in batches
> +		 * of DPAA2_ETH_BUFS_PER_CMD. Bail out if the UMEM cannot
> +		 * provide enough buffers at the moment
>  		 */
> -		page = dev_alloc_pages(0);
> -		if (!page)
> +		batch = xsk_buff_alloc_batch(ch->xsk_pool, xdp_buffs,
> +					     DPAA2_ETH_BUFS_PER_CMD);
> +		if (!batch)
>  			goto err_alloc;
>  
> -		addr = dma_map_page(dev, page, 0, priv->rx_buf_size,
> -				    DMA_BIDIRECTIONAL);
> -		if (unlikely(dma_mapping_error(dev, addr)))
> -			goto err_map;
> +		for (i = 0; i < batch; i++) {
> +			swa = (struct dpaa2_eth_swa *)(xdp_buffs[i]->data_hard_start +
> +						       DPAA2_ETH_RX_HWA_SIZE);
> +			swa->xsk.xdp_buff = xdp_buffs[i];
>  
> -		buf_array[i] = addr;
> +			addr = xsk_buff_xdp_get_frame_dma(xdp_buffs[i]);
> +			if (unlikely(dma_mapping_error(dev, addr)))
> +				goto err_map;
>  
> -		/* tracing point */
> -		trace_dpaa2_eth_buf_seed(priv->net_dev, page_address(page),
> -					 DPAA2_ETH_RX_BUF_RAW_SIZE,
> -					 addr, priv->rx_buf_size,
> -					 ch->bp->bpid);
> +			buf_array[i] = addr;
> +		}
>  	}
>  
>  release_bufs:
> @@ -1698,14 +1736,19 @@ static int dpaa2_eth_add_bufs(struct dpaa2_eth_priv *priv,
>  	 * not much else we can do about it
>  	 */
>  	if (err) {
> -		dpaa2_eth_free_bufs(priv, buf_array, i);
> +		dpaa2_eth_free_bufs(priv, buf_array, i, ch->xsk_zc);
>  		return 0;
>  	}
>  
>  	return i;
>  
>  err_map:
> -	__free_pages(page, 0);
> +	if (!ch->xsk_zc) {
> +		__free_pages(page, 0);
> +	} else {
> +		for (; i < batch; i++)
> +			xsk_buff_free(xdp_buffs[i]);
> +	}
>  err_alloc:
>  	/* If we managed to allocate at least some buffers,
>  	 * release them to hardware
> @@ -1764,8 +1807,13 @@ static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int bpid,
>  				 int count)
>  {
>  	u64 buf_array[DPAA2_ETH_BUFS_PER_CMD];
> +	bool xsk_zc = false;
>  	int retries = 0;
> -	int ret;
> +	int i, ret;
> +
> +	for (i = 0; i < priv->num_channels; i++)
> +		if (priv->channel[i]->bp->bpid == bpid)
> +			xsk_zc = priv->channel[i]->xsk_zc;
>  
>  	do {
>  		ret = dpaa2_io_service_acquire(NULL, bpid, buf_array, count);
> @@ -1776,7 +1824,7 @@ static void dpaa2_eth_drain_bufs(struct dpaa2_eth_priv *priv, int bpid,
>  			netdev_err(priv->net_dev, "dpaa2_io_service_acquire() failed\n");
>  			return;
>  		}
> -		dpaa2_eth_free_bufs(priv, buf_array, ret);
> +		dpaa2_eth_free_bufs(priv, buf_array, ret, xsk_zc);
>  		retries = 0;
>  	} while (ret);
>  }
> @@ -2694,6 +2742,8 @@ static int dpaa2_eth_xdp(struct net_device *dev, struct netdev_bpf *xdp)
>  	switch (xdp->command) {
>  	case XDP_SETUP_PROG:
>  		return dpaa2_eth_setup_xdp(dev, xdp->prog);
> +	case XDP_SETUP_XSK_POOL:
> +		return dpaa2_xsk_setup_pool(dev, xdp->xsk.pool, xdp->xsk.queue_id);
>  	default:
>  		return -EINVAL;
>  	}
> @@ -2924,6 +2974,7 @@ static const struct net_device_ops dpaa2_eth_ops = {
>  	.ndo_change_mtu = dpaa2_eth_change_mtu,
>  	.ndo_bpf = dpaa2_eth_xdp,
>  	.ndo_xdp_xmit = dpaa2_eth_xdp_xmit,
> +	.ndo_xsk_wakeup = dpaa2_xsk_wakeup,
>  	.ndo_setup_tc = dpaa2_eth_setup_tc,
>  	.ndo_vlan_rx_add_vid = dpaa2_eth_rx_add_vid,
>  	.ndo_vlan_rx_kill_vid = dpaa2_eth_rx_kill_vid
> @@ -4246,8 +4297,8 @@ static int dpaa2_eth_bind_dpni(struct dpaa2_eth_priv *priv)
>  {
>  	struct dpaa2_eth_bp *bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
>  	struct net_device *net_dev = priv->net_dev;
> +	struct dpni_pools_cfg pools_params = { 0 };
>  	struct device *dev = net_dev->dev.parent;
> -	struct dpni_pools_cfg pools_params;
>  	struct dpni_error_cfg err_cfg;
>  	int err = 0;
>  	int i;
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> index 3c4fc46b1324..38f67b98865f 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.h
> @@ -130,6 +130,7 @@ enum dpaa2_eth_swa_type {
>  	DPAA2_ETH_SWA_SINGLE,
>  	DPAA2_ETH_SWA_SG,
>  	DPAA2_ETH_SWA_XDP,
> +	DPAA2_ETH_SWA_XSK,
>  	DPAA2_ETH_SWA_SW_TSO,
>  };
>  
> @@ -151,6 +152,9 @@ struct dpaa2_eth_swa {
>  			int dma_size;
>  			struct xdp_frame *xdpf;
>  		} xdp;
> +		struct {
> +			struct xdp_buff *xdp_buff;
> +		} xsk;
>  		struct {
>  			struct sk_buff *skb;
>  			int num_sg;
> @@ -429,12 +433,19 @@ enum dpaa2_eth_fq_type {
>  };
>  
>  struct dpaa2_eth_priv;
> +struct dpaa2_eth_channel;
> +struct dpaa2_eth_fq;
>  
>  struct dpaa2_eth_xdp_fds {
>  	struct dpaa2_fd fds[DEV_MAP_BULK_SIZE];
>  	ssize_t num;
>  };
>  
> +typedef void dpaa2_eth_consume_cb_t(struct dpaa2_eth_priv *priv,
> +				    struct dpaa2_eth_channel *ch,
> +				    const struct dpaa2_fd *fd,
> +				    struct dpaa2_eth_fq *fq);
> +
>  struct dpaa2_eth_fq {
>  	u32 fqid;
>  	u32 tx_qdbin;
> @@ -447,10 +458,7 @@ struct dpaa2_eth_fq {
>  	struct dpaa2_eth_channel *channel;
>  	enum dpaa2_eth_fq_type type;
>  
> -	void (*consume)(struct dpaa2_eth_priv *priv,
> -			struct dpaa2_eth_channel *ch,
> -			const struct dpaa2_fd *fd,
> -			struct dpaa2_eth_fq *fq);
> +	dpaa2_eth_consume_cb_t *consume;
>  	struct dpaa2_eth_fq_stats stats;
>  
>  	struct dpaa2_eth_xdp_fds xdp_redirect_fds;
> @@ -486,6 +494,8 @@ struct dpaa2_eth_channel {
>  	u64 recycled_bufs[DPAA2_ETH_BUFS_PER_CMD];
>  	int recycled_bufs_cnt;
>  
> +	bool xsk_zc;
> +	struct xsk_buff_pool *xsk_pool;
>  	struct dpaa2_eth_bp *bp;
>  };
>  
> @@ -808,4 +818,22 @@ void dpaa2_eth_rx(struct dpaa2_eth_priv *priv,
>  		  struct dpaa2_eth_channel *ch,
>  		  const struct dpaa2_fd *fd,
>  		  struct dpaa2_eth_fq *fq);
> +
> +struct dpaa2_eth_bp *dpaa2_eth_allocate_dpbp(struct dpaa2_eth_priv *priv);
> +void dpaa2_eth_free_dpbp(struct dpaa2_eth_priv *priv,
> +			 struct dpaa2_eth_bp *bp);
> +
> +void *dpaa2_iova_to_virt(struct iommu_domain *domain, dma_addr_t iova_addr);
> +void dpaa2_eth_recycle_buf(struct dpaa2_eth_priv *priv,
> +			   struct dpaa2_eth_channel *ch,
> +			   dma_addr_t addr);
> +
> +void dpaa2_eth_xdp_enqueue(struct dpaa2_eth_priv *priv,
> +			   struct dpaa2_eth_channel *ch,
> +			   struct dpaa2_fd *fd,
> +			   void *buf_start, u16 queue_id);
> +
> +int dpaa2_xsk_wakeup(struct net_device *dev, u32 qid, u32 flags);
> +int dpaa2_xsk_setup_pool(struct net_device *dev, struct xsk_buff_pool *pool, u16 qid);
> +
>  #endif	/* __DPAA2_H */
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
> new file mode 100644
> index 000000000000..2df7bffec5a7
> --- /dev/null
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-xsk.c
> @@ -0,0 +1,327 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +/* Copyright 2022 NXP
> + */
> +#include <linux/filter.h>
> +#include <linux/compiler.h>
> +#include <linux/bpf_trace.h>
> +#include <net/xdp.h>
> +#include <net/xdp_sock_drv.h>
> +
> +#include "dpaa2-eth.h"
> +
> +static void dpaa2_eth_setup_consume_func(struct dpaa2_eth_priv *priv,
> +					 struct dpaa2_eth_channel *ch,
> +					 enum dpaa2_eth_fq_type type,
> +					 dpaa2_eth_consume_cb_t *consume)
> +{
> +	struct dpaa2_eth_fq *fq;
> +	int i;
> +
> +	for (i = 0; i < priv->num_fqs; i++) {
> +		fq = &priv->fq[i];
> +
> +		if (fq->type != type)
> +			continue;
> +		if (fq->channel != ch)
> +			continue;
> +
> +		fq->consume = consume;
> +	}
> +}
> +
> +static u32 dpaa2_xsk_run_xdp(struct dpaa2_eth_priv *priv,
> +			     struct dpaa2_eth_channel *ch,
> +			     struct dpaa2_eth_fq *rx_fq,
> +			     struct dpaa2_fd *fd, void *vaddr)
> +{
> +	dma_addr_t addr = dpaa2_fd_get_addr(fd);
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff *xdp_buff;
> +	struct dpaa2_eth_swa *swa;
> +	u32 xdp_act = XDP_PASS;
> +	int err;
> +
> +	xdp_prog = READ_ONCE(ch->xdp.prog);
> +	if (!xdp_prog)
> +		goto out;
> +
> +	swa = (struct dpaa2_eth_swa *)(vaddr + DPAA2_ETH_RX_HWA_SIZE +
> +				       ch->xsk_pool->umem->headroom);
> +	xdp_buff = swa->xsk.xdp_buff;
> +
> +	xdp_buff->data_hard_start = vaddr;
> +	xdp_buff->data = vaddr + dpaa2_fd_get_offset(fd);
> +	xdp_buff->data_end = xdp_buff->data + dpaa2_fd_get_len(fd);
> +	xdp_set_data_meta_invalid(xdp_buff);
> +	xdp_buff->rxq = &ch->xdp_rxq;
> +
> +	xsk_buff_dma_sync_for_cpu(xdp_buff, ch->xsk_pool);
> +	xdp_act = bpf_prog_run_xdp(xdp_prog, xdp_buff);
> +
> +	/* xdp.data pointer may have changed */
> +	dpaa2_fd_set_offset(fd, xdp_buff->data - vaddr);
> +	dpaa2_fd_set_len(fd, xdp_buff->data_end - xdp_buff->data);
> +
> +	if (likely(xdp_act == XDP_REDIRECT)) {
> +		err = xdp_do_redirect(priv->net_dev, xdp_buff, xdp_prog);
> +		if (unlikely(err)) {
> +			ch->stats.xdp_drop++;
> +			dpaa2_eth_recycle_buf(priv, ch, addr);
> +		} else {
> +			ch->buf_count--;
> +			ch->stats.xdp_redirect++;
> +		}
> +
> +		goto xdp_redir;
> +	}
> +
> +	switch (xdp_act) {
> +	case XDP_PASS:
> +		break;
> +	case XDP_TX:
> +		dpaa2_eth_xdp_enqueue(priv, ch, fd, vaddr, rx_fq->flowid);
> +		break;
> +	default:
> +		bpf_warn_invalid_xdp_action(priv->net_dev, xdp_prog, xdp_act);
> +		fallthrough;
> +	case XDP_ABORTED:
> +		trace_xdp_exception(priv->net_dev, xdp_prog, xdp_act);
> +		fallthrough;
> +	case XDP_DROP:
> +		dpaa2_eth_recycle_buf(priv, ch, addr);
> +		ch->stats.xdp_drop++;
> +		break;
> +	}
> +
> +xdp_redir:
> +	ch->xdp.res |= xdp_act;
> +out:
> +	return xdp_act;
> +}
> +
> +/* Rx frame processing routine for the AF_XDP fast path */
> +static void dpaa2_xsk_rx(struct dpaa2_eth_priv *priv,
> +			 struct dpaa2_eth_channel *ch,
> +			 const struct dpaa2_fd *fd,
> +			 struct dpaa2_eth_fq *fq)
> +{
> +	dma_addr_t addr = dpaa2_fd_get_addr(fd);
> +	u8 fd_format = dpaa2_fd_get_format(fd);
> +	struct rtnl_link_stats64 *percpu_stats;
> +	u32 fd_length = dpaa2_fd_get_len(fd);
> +	struct sk_buff *skb;
> +	void *vaddr;
> +	u32 xdp_act;
> +
> +	vaddr = dpaa2_iova_to_virt(priv->iommu_domain, addr);
> +	percpu_stats = this_cpu_ptr(priv->percpu_stats);
> +
> +	if (fd_format != dpaa2_fd_single) {
> +		WARN_ON(priv->xdp_prog);
> +		/* AF_XDP doesn't support any other formats */
> +		goto err_frame_format;
> +	}
> +
> +	xdp_act = dpaa2_xsk_run_xdp(priv, ch, fq, (struct dpaa2_fd *)fd, vaddr);
> +	if (xdp_act != XDP_PASS) {
> +		percpu_stats->rx_packets++;
> +		percpu_stats->rx_bytes += dpaa2_fd_get_len(fd);
> +		return;
> +	}
> +
> +	/* Build skb */
> +	skb = dpaa2_eth_alloc_skb(priv, ch, fd, fd_length, vaddr);
> +	if (!skb)
> +		/* Nothing else we can do, recycle the buffer and
> +		 * drop the frame.
> +		 */
> +		goto err_alloc_skb;
> +
> +	/* Send the skb to the Linux networking stack */
> +	dpaa2_eth_receive_skb(priv, ch, fd, vaddr, fq, percpu_stats, skb);
> +
> +	return;
> +
> +err_alloc_skb:
> +	dpaa2_eth_recycle_buf(priv, ch, addr);
> +err_frame_format:
> +	percpu_stats->rx_dropped++;
> +}
> +
> +static void dpaa2_xsk_set_bp_per_qdbin(struct dpaa2_eth_priv *priv,
> +				       struct dpni_pools_cfg *pools_params)
> +{
> +	int curr_bp = 0, i, j;
> +
> +	pools_params->pool_options = DPNI_POOL_ASSOC_QDBIN;
> +	for (i = 0; i < priv->num_bps; i++) {
> +		for (j = 0; j < priv->num_channels; j++)
> +			if (priv->bp[i] == priv->channel[j]->bp)
> +				pools_params->pools[curr_bp].priority_mask |= (1 << j);
> +		if (!pools_params->pools[curr_bp].priority_mask)
> +			continue;
> +
> +		pools_params->pools[curr_bp].dpbp_id = priv->bp[i]->bpid;
> +		pools_params->pools[curr_bp].buffer_size = priv->rx_buf_size;
> +		pools_params->pools[curr_bp++].backup_pool = 0;
> +	}
> +	pools_params->num_dpbp = curr_bp;
> +}
> +
> +static int dpaa2_xsk_disable_pool(struct net_device *dev, u16 qid)
> +{
> +	struct xsk_buff_pool *pool = xsk_get_pool_from_qid(dev, qid);
> +	struct dpaa2_eth_priv *priv = netdev_priv(dev);
> +	struct dpni_pools_cfg pools_params = { 0 };
> +	struct dpaa2_eth_channel *ch;
> +	int err;
> +	bool up;
> +
> +	ch = priv->channel[qid];
> +	if (!ch->xsk_pool)
> +		return -EINVAL;
> +
> +	up = netif_running(dev);
> +	if (up)
> +		dev_close(dev);
> +
> +	xsk_pool_dma_unmap(pool, 0);
> +	err = xdp_rxq_info_reg_mem_model(&ch->xdp_rxq,
> +					 MEM_TYPE_PAGE_ORDER0, NULL);
> +	if (err)
> +		netdev_err(dev, "xsk_rxq_info_reg_mem_model() failed (err = %d)\n",
> +			   err);
> +
> +	dpaa2_eth_free_dpbp(priv, ch->bp);
> +
> +	ch->xsk_zc = false;
> +	ch->xsk_pool = NULL;
> +	ch->bp = priv->bp[DPAA2_ETH_DEFAULT_BP_IDX];
> +
> +	dpaa2_eth_setup_consume_func(priv, ch, DPAA2_RX_FQ, dpaa2_eth_rx);
> +
> +	dpaa2_xsk_set_bp_per_qdbin(priv, &pools_params);
> +	err = dpni_set_pools(priv->mc_io, 0, priv->mc_token, &pools_params);
> +	if (err)
> +		netdev_err(dev, "dpni_set_pools() failed\n");
> +
> +	if (up) {
> +		err = dev_open(dev, NULL);
> +		if (err)
> +			return err;

Same problem of patch 7/12, it's better to avoid the device changing
status for this kind of operations - even on unlikely error paths.

Thanks,

Paolo

