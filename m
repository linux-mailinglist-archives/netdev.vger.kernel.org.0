Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 047005EF348
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 12:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235303AbiI2KSB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 06:18:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235419AbiI2KRi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 06:17:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE134F6F7C
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664446601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=I49cF9sfbxNgGCeAY0uIcK3yeSiGnK00QABITkag+hY=;
        b=Xly8wuoXkZV0gqPQyuk4XMGkIEL6mVOOV70YOcH/jmk14jbmweXXJnbuKEcBzAWLnCw1Lo
        UnXx0Tc/7xu7qE/xO24B5B9zlTyD0H681f/OdjmFdFp4wBVhh31kbw3jsTaS9E2+3Fn6aG
        RVocK9iYrHaTkTnVK4gdWVfkR6e2bss=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-538-Q0mMzFHsPrODHREM5_qQwA-1; Thu, 29 Sep 2022 06:16:40 -0400
X-MC-Unique: Q0mMzFHsPrODHREM5_qQwA-1
Received: by mail-ed1-f69.google.com with SMTP id h13-20020a056402280d00b004581108ba90so942650ede.2
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 03:16:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date;
        bh=I49cF9sfbxNgGCeAY0uIcK3yeSiGnK00QABITkag+hY=;
        b=nvKGyiTetzIGixkRgZ4KvloD1HjrpuMj1ALh8HKo8O+aYqFffMfqLJrbLcW0PYgbLr
         cXEfR3JIjiKTYUJWs/NV580j++gud05T4Ni8ayVtJeXLKXTzqiaFPAyEhLuVYEBO5IA6
         4xOiszNgETVowBaZWYFInikQnxkP0AdctFhmJLaf6Fvy7+ocxsDEKCE/Eoyw+6UhK+VC
         7QGQMmJGjAFSwJbG1F2uSsm0tj3an4yW6WUHHaifTbTSF0QfRFeMUYB3qeSRusuiQ5Pr
         EZ60Lhtsu5Ibw9SZWBjjZJz9Nh8gsR71zoqChFt/4wXElA3iSY6fRgtKs8vwYiAW1+GD
         vgQw==
X-Gm-Message-State: ACrzQf2t2yWqhtvV2sQmNQdsHDPBfAk9cU7mnVr8Z3saCxt2yVOs2XbQ
        RxjyJ+4OO44ac+Zlululssay3ca3on3Waxx9JohU8Ih2NyaDWCrxQR8O8lChabQCSmz7YOo4Gem
        tj1x31xZ+UzaigvJ4
X-Received: by 2002:a05:6402:1d48:b0:458:f29:798 with SMTP id dz8-20020a0564021d4800b004580f290798mr2584163edb.414.1664446598783;
        Thu, 29 Sep 2022 03:16:38 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM762CNe0AvrD0AO+UmU8OF8GzMBFMqFMvDaTEz9DThG2UtyooTJnbMOFXkYvIB6rEwZsmjHig==
X-Received: by 2002:a05:6402:1d48:b0:458:f29:798 with SMTP id dz8-20020a0564021d4800b004580f290798mr2584138edb.414.1664446598503;
        Thu, 29 Sep 2022 03:16:38 -0700 (PDT)
Received: from [192.168.41.81] (83-90-141-187-cable.dk.customer.tdc.net. [83.90.141.187])
        by smtp.gmail.com with ESMTPSA id 6-20020a508e06000000b004574f4326b8sm5285304edw.30.2022.09.29.03.16.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 03:16:37 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <1898c50e-1bad-1143-17d9-d093b2d2674a@redhat.com>
Date:   Thu, 29 Sep 2022 12:16:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Cc:     brouer@redhat.com, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev
Subject: Re: [PATCH 1/1] net: fec: add initial XDP support
Content-Language: en-US
To:     Shenwei Wang <shenwei.wang@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
In-Reply-To: <20220928152509.141490-1-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28/09/2022 17.25, Shenwei Wang wrote:
> This patch adds the initial XDP support to Freescale driver. It supports
> XDP_PASS, XDP_DROP and XDP_REDIRECT actions. Upcoming patches will add
> support for XDP_TX and Zero Copy features.
> 
> This patch also optimizes the RX buffers by using the page pool, which
> uses one frame per page for easy management. In the future, it can be
> further improved to use two frames per page.
> 
> This patch has been tested with the sample apps of "xdpsock" and "xdp2" in
> samples/bpf directory for both SKB and Native (XDP) mode. The following
> are the testing result comparing with the XDP skb-mode.
> 
>   # xdpsock -i eth0
>   sock0@eth0:0 rxdrop xdp-drv
>                     pps            pkts           1.00
>   rx                 198798         1040011
>   tx                 0              0
> 
>   # xdpsock -S -i eth0         // skb-mode
>   sock0@eth0:0 rxdrop xdp-skb
>                      pps            pkts           1.00
>   rx                 95638          717251
>   tx                 0              0
> 
>   # xdp2 eth0
>   proto 0:     475362 pkt/s
>   proto 0:     475549 pkt/s
>   proto 0:     475480 pkt/s
>   proto 0:     143258 pkt/s
> 
>   # xdp2 -S eth0    // skb-mode
>   proto 17:      56468 pkt/s
>   proto 17:      71999 pkt/s
>   proto 17:      72000 pkt/s
>   proto 17:      71988 pkt/s
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> ---
>   drivers/net/ethernet/freescale/fec.h      |  34 +-
>   drivers/net/ethernet/freescale/fec_main.c | 414 +++++++++++++++++++---
>   2 files changed, 393 insertions(+), 55 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index b0100fe3c9e4..f7531503aa95 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -346,8 +346,10 @@ struct bufdesc_ex {
>    * the skbuffer directly.
>    */
>   
> +#define FEC_ENET_XDP_HEADROOM	(512) /* XDP_PACKET_HEADROOM + NET_IP_ALIGN) */

Why the large headroom?

> +
>   #define FEC_ENET_RX_PAGES	256
> -#define FEC_ENET_RX_FRSIZE	2048
> +#define FEC_ENET_RX_FRSIZE	(PAGE_SIZE - FEC_ENET_XDP_HEADROOM)

This FEC_ENET_RX_FRSIZE is likely wrong, because you also need to
reserve 320 bytes at the end for struct skb_shared_info.
(320 calculated as SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))

>   #define FEC_ENET_RX_FRPPG	(PAGE_SIZE / FEC_ENET_RX_FRSIZE)
>   #define RX_RING_SIZE		(FEC_ENET_RX_FRPPG * FEC_ENET_RX_PAGES)
>   #define FEC_ENET_TX_FRSIZE	2048
> @@ -517,6 +519,22 @@ struct bufdesc_prop {
[...]

> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 59921218a8a4..2e30182ed770 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -66,6 +66,8 @@
>   #include <linux/mfd/syscon.h>
>   #include <linux/regmap.h>
>   #include <soc/imx/cpuidle.h>
> +#include <linux/filter.h>
> +#include <linux/bpf.h>
>   
>   #include <asm/cacheflush.h>
>   
> @@ -87,6 +89,11 @@ static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
>   #define FEC_ENET_OPD_V	0xFFF0
>   #define FEC_MDIO_PM_TIMEOUT  100 /* ms */
>   
> +#define FEC_ENET_XDP_PASS          0
> +#define FEC_ENET_XDP_CONSUMED      BIT(0)
> +#define FEC_ENET_XDP_TX            BIT(1)
> +#define FEC_ENET_XDP_REDIR         BIT(2)
> +
>   struct fec_devinfo {
>   	u32 quirks;
>   };
> @@ -422,6 +429,49 @@ fec_enet_clear_csum(struct sk_buff *skb, struct net_device *ndev)
>   	return 0;
>   }
>   
> +static int
> +fec_enet_create_page_pool(struct fec_enet_private *fep,
> +			  struct fec_enet_priv_rx_q *rxq, int size)
> +{
> +	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
> +	struct page_pool_params pp_params = {
> +		.order = 0,
> +		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
> +		.pool_size = size,
> +		.nid = dev_to_node(&fep->pdev->dev),
> +		.dev = &fep->pdev->dev,
> +		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
> +		.offset = FEC_ENET_XDP_HEADROOM,
> +		.max_len = FEC_ENET_RX_FRSIZE,

XDP BPF-prog cannot access last 320 bytes, so FEC_ENET_RX_FRSIZE is 
wrong here.

> +	};
> +	int err;
> +
> +	rxq->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(rxq->page_pool)) {
> +		err = PTR_ERR(rxq->page_pool);
> +		rxq->page_pool = NULL;
> +		return err;
> +	}
> +
> +	err = xdp_rxq_info_reg(&rxq->xdp_rxq, fep->netdev, rxq->id, 0);
> +	if (err < 0)
> +		goto err_free_pp;
> +
> +	err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					 rxq->page_pool);
> +	if (err)
> +		goto err_unregister_rxq;
> +
> +	return 0;
> +
> +err_unregister_rxq:
> +	xdp_rxq_info_unreg(&rxq->xdp_rxq);
> +err_free_pp:
> +	page_pool_destroy(rxq->page_pool);
> +	rxq->page_pool = NULL;
> +	return err;
> +}
> +
>   static struct bufdesc *
>   fec_enet_txq_submit_frag_skb(struct fec_enet_priv_tx_q *txq,
>   			     struct sk_buff *skb,
> @@ -1285,7 +1335,6 @@ fec_stop(struct net_device *ndev)
>   	}
>   }
>   
> -
>   static void
>   fec_timeout(struct net_device *ndev, unsigned int txqueue)
>   {
> @@ -1450,7 +1499,7 @@ static void fec_enet_tx(struct net_device *ndev)
>   		fec_enet_tx_queue(ndev, i);
>   }
>   
> -static int
> +static int __maybe_unused
>   fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff *skb)
>   {
>   	struct  fec_enet_private *fep = netdev_priv(ndev);
> @@ -1470,8 +1519,9 @@ fec_enet_new_rxbdp(struct net_device *ndev, struct bufdesc *bdp, struct sk_buff
>   	return 0;
>   }
>   
> -static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
> -			       struct bufdesc *bdp, u32 length, bool swap)
> +static bool __maybe_unused
> +fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
> +		   struct bufdesc *bdp, u32 length, bool swap)
>   {
>   	struct  fec_enet_private *fep = netdev_priv(ndev);
>   	struct sk_buff *new_skb;
> @@ -1496,6 +1546,78 @@ static bool fec_enet_copybreak(struct net_device *ndev, struct sk_buff **skb,
>   	return true;
>   }
>   
> +static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
> +				struct bufdesc *bdp, int index)
> +{
> +	struct page *new_page;
> +	dma_addr_t phys_addr;
> +
> +	new_page = page_pool_dev_alloc_pages(rxq->page_pool);
> +	WARN_ON(!new_page);
> +	rxq->rx_skb_info[index].page = new_page;
> +
> +	rxq->rx_skb_info[index].offset = FEC_ENET_XDP_HEADROOM;
> +	phys_addr = page_pool_get_dma_addr(new_page) + FEC_ENET_XDP_HEADROOM;
> +	bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
> +}
> +
> +static u32
> +fec_enet_run_xdp(struct fec_enet_private *fep, struct bpf_prog *prog,
> +		 struct xdp_buff *xdp, struct fec_enet_priv_rx_q *rxq, int index)
> +{
> +	unsigned int sync, len = xdp->data_end - xdp->data;
> +	u32 ret = FEC_ENET_XDP_PASS;
> +	struct page *page;
> +	int err;
> +	u32 act;
> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +
> +	/* Due xdp_adjust_tail: DMA sync for_device cover max len CPU touch */
> +	sync = xdp->data_end - xdp->data_hard_start - FEC_ENET_XDP_HEADROOM;
> +	sync = max(sync, len);
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		rxq->stats.xdp_pass++;
> +		ret = FEC_ENET_XDP_PASS;
> +		break;
> +
> +	case XDP_TX:
> +		rxq->stats.xdp_tx++;
> +		bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
> +		fallthrough;

This fallthrough looks wrong. The next xdp_do_redirect() call will
pickup left-overs in per CPU bpf_redirect_info.

> +
> +	case XDP_REDIRECT:
> +		err = xdp_do_redirect(fep->netdev, xdp, prog);
> +		rxq->stats.xdp_redirect++;
> +		if (!err) {
> +			ret = FEC_ENET_XDP_REDIR;
> +		} else {
> +			ret = FEC_ENET_XDP_CONSUMED;
> +			page = virt_to_head_page(xdp->data);
> +			page_pool_put_page(rxq->page_pool, page, sync, true);
> +		}
> +		break;
> +
> +	default:
> +		bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
> +		fallthrough;
> +
> +	case XDP_ABORTED:
> +		fallthrough;    /* handle aborts by dropping packet */
> +
> +	case XDP_DROP:
> +		rxq->stats.xdp_drop++;
> +		ret = FEC_ENET_XDP_CONSUMED;
> +		page = virt_to_head_page(xdp->data);
> +		page_pool_put_page(rxq->page_pool, page, sync, true);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>   /* During a receive, the bd_rx.cur points to the current incoming buffer.
>    * When we update through the ring, if the next incoming buffer has
>    * not been given to the system, we just set the empty indicator,
> @@ -1508,7 +1630,6 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>   	struct fec_enet_priv_rx_q *rxq;
>   	struct bufdesc *bdp;
>   	unsigned short status;
> -	struct  sk_buff *skb_new = NULL;
>   	struct  sk_buff *skb;
>   	ushort	pkt_len;
>   	__u8 *data;
> @@ -1517,8 +1638,12 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>   	bool	vlan_packet_rcvd = false;
>   	u16	vlan_tag;
>   	int	index = 0;
> -	bool	is_copybreak;
>   	bool	need_swap = fep->quirks & FEC_QUIRK_SWAP_FRAME;
> +	struct page *page;
> +	struct xdp_buff xdp;
> +	u32 ret, xdp_result = FEC_ENET_XDP_PASS;
> +
> +	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
>   
>   #ifdef CONFIG_M532x
>   	flush_cache_all();
> @@ -1529,6 +1654,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>   	 * These get messed up if we get called due to a busy condition.
>   	 */
>   	bdp = rxq->bd.cur;
> +	xdp_init_buff(&xdp, PAGE_SIZE, &rxq->xdp_rxq);
>   
>   	while (!((status = fec16_to_cpu(bdp->cbd_sc)) & BD_ENET_RX_EMPTY)) {
>   
> @@ -1570,31 +1696,37 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>   		ndev->stats.rx_bytes += pkt_len;
>   
>   		index = fec_enet_get_bd_index(bdp, &rxq->bd);
> -		skb = rxq->rx_skbuff[index];
> +		page = rxq->rx_skb_info[index].page;
> +
> +		dma_sync_single_for_cpu(&fep->pdev->dev,
> +					fec32_to_cpu(bdp->cbd_bufaddr),
> +					pkt_len,
> +					DMA_FROM_DEVICE);
> +
> +		prefetch(page_address(page));
> +		fec_enet_update_cbd(rxq, bdp, index);
> +
> +		if (xdp_prog) {
> +			xdp_prepare_buff(&xdp, page_address(page),
> +					 FEC_ENET_XDP_HEADROOM, pkt_len, false);
> +
> +			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq, index);
> +			xdp_result |= ret;
> +			if (ret != FEC_ENET_XDP_PASS)
> +				goto rx_processing_done;
> +		}
>   
>   		/* The packet length includes FCS, but we don't want to
>   		 * include that when passing upstream as it messes up
>   		 * bridging applications.
>   		 */
> -		is_copybreak = fec_enet_copybreak(ndev, &skb, bdp, pkt_len - 4,
> -						  need_swap);
> -		if (!is_copybreak) {
> -			skb_new = netdev_alloc_skb(ndev, FEC_ENET_RX_FRSIZE);
> -			if (unlikely(!skb_new)) {
> -				ndev->stats.rx_dropped++;
> -				goto rx_processing_done;
> -			}
> -			dma_unmap_single(&fep->pdev->dev,
> -					 fec32_to_cpu(bdp->cbd_bufaddr),
> -					 FEC_ENET_RX_FRSIZE - fep->rx_align,
> -					 DMA_FROM_DEVICE);
> -		}
> -
> -		prefetch(skb->data - NET_IP_ALIGN);
> +		skb = build_skb(page_address(page), FEC_ENET_RX_FRSIZE);

This looks wrong, I think FEC_ENET_RX_FRSIZE should be replaced by 
PAGE_SIZE.
As build_skb() does:

  size -= SKB_DATA_ALIGN(sizeof(struct skb_shared_info));

> +		skb_reserve(skb, FEC_ENET_XDP_HEADROOM);

The skb_reserve looks correct.

>   		skb_put(skb, pkt_len - 4);
>   		data = skb->data;
> +		page_pool_release_page(rxq->page_pool, page);

Today page_pool have SKB recycle support (you might have looked at
drivers that didn't utilize this yet), thus you don't need to release
the page (page_pool_release_page) here.  Instead you could simply mark
the SKB for recycling, unless driver does some page refcnt tricks I
didn't notice.

  skb_mark_for_recycle(skb);


> -		if (!is_copybreak && need_swap)
> +		if (need_swap)
>   			swap_buffer(data, pkt_len);
>   
>   #if !defined(CONFIG_M5272)
> @@ -1649,16 +1781,6 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
[...]

