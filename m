Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDC76F3BF
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 16:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbfGUOsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 10:48:55 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54086 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726449AbfGUOsz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jul 2019 10:48:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=J/lEMsHQ7ImV6Cxnm+DXxiA1Z0NWPu44s7c4Kl2f44w=; b=PUxWYkXls+Ed+OrTVeDg0b2WJg
        f4yoPIa2oq/Q9kDMUCiWAToBW7wXjjxUrt5ZfSbKNiC6wEGG0U+JyvQsqKZi+Ncppa61WKBpdRxl/
        4/NBKmhNMl3/LNCMxGZMQGoeVuNPxtwCzm5QAIJJNKWobbb80b8GzXikIMZbXM21styo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hpD8r-0006IP-9Q; Sun, 21 Jul 2019 16:48:49 +0200
Date:   Sun, 21 Jul 2019 16:48:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Zhu Yanjun <yanjun.zhu@oracle.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCHv2 2/2] forcedeth: disable recv cache by default
Message-ID: <20190721144849.GC22996@lunn.ch>
References: <1563713633-25528-1-git-send-email-yanjun.zhu@oracle.com>
 <1563713633-25528-3-git-send-email-yanjun.zhu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1563713633-25528-3-git-send-email-yanjun.zhu@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 21, 2019 at 08:53:53AM -0400, Zhu Yanjun wrote:
> The recv cache is to allocate 125MiB memory to reserve for NIC.
> In the past time, this recv cache works very well. When the memory
> is not enough, this recv cache reserves memory for NIC.
> And the communications through this NIC is not affected by the
> memory shortage. And the performance of NIC is better because of
> this recv cache.
> But this recv cache reserves 125MiB memory for one NIC port. Normally
> there are 2 NIC ports in one card. So in a host, there are about 250
> MiB memory reserved for NIC ports. To a host on which communications
> are not mandatory, it is not necessary to reserve memory.
> So this recv cache is disabled by default.
> 
> CC: Joe Jin <joe.jin@oracle.com>
> CC: Junxiao Bi <junxiao.bi@oracle.com>
> Tested-by: Nan san <nan.1986san@gmail.com>
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
>  drivers/net/ethernet/nvidia/Kconfig     | 11 ++++++++
>  drivers/net/ethernet/nvidia/Makefile    |  1 +
>  drivers/net/ethernet/nvidia/forcedeth.c | 46 ++++++++++++++++++++++++++-------
>  3 files changed, 48 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/nvidia/Kconfig b/drivers/net/ethernet/nvidia/Kconfig
> index faacbd1..9a9f42a 100644
> --- a/drivers/net/ethernet/nvidia/Kconfig
> +++ b/drivers/net/ethernet/nvidia/Kconfig
> @@ -26,4 +26,15 @@ config FORCEDETH
>  	  To compile this driver as a module, choose M here. The module
>  	  will be called forcedeth.
>  
> +config	FORCEDETH_RECV_CACHE
> +	bool "nForce Ethernet recv cache support"
> +	depends on FORCEDETH
> +	default n
> +	---help---
> +	  The recv cache can make nic work steadily when the system memory is
> +	  not enough. And it can also enhance nic performance. But to a host
> +	  on which the communications are not mandatory, it is not necessary
> +	  to reserve 125MiB memory for NIC.
> +	  So recv cache is disabled by default.
> +
>  endif # NET_VENDOR_NVIDIA
> diff --git a/drivers/net/ethernet/nvidia/Makefile b/drivers/net/ethernet/nvidia/Makefile
> index 8935699..40c055e 100644
> --- a/drivers/net/ethernet/nvidia/Makefile
> +++ b/drivers/net/ethernet/nvidia/Makefile
> @@ -4,3 +4,4 @@
>  #
>  
>  obj-$(CONFIG_FORCEDETH) += forcedeth.o
> +ccflags-$(CONFIG_FORCEDETH_RECV_CACHE)	:=	-DFORCEDETH_RECV_CACHE
> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
> index f8e766f..deda276 100644
> --- a/drivers/net/ethernet/nvidia/forcedeth.c
> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
> @@ -674,10 +674,12 @@ struct nv_ethtool_stats {
>  	u64 tx_broadcast;
>  };
>  
> +#ifdef FORCEDETH_RECV_CACHE
>  /* 1000Mb is 125M bytes, 125 * 1024 * 1024 bytes
>   * The length of recv cache is 125M / skb_length
>   */
>  #define RECV_CACHE_LIST_LENGTH		(125 * 1024 * 1024 / np->rx_buf_sz)
> +#endif
>  
>  #define NV_DEV_STATISTICS_V3_COUNT (sizeof(struct nv_ethtool_stats)/sizeof(u64))
>  #define NV_DEV_STATISTICS_V2_COUNT (NV_DEV_STATISTICS_V3_COUNT - 3)
> @@ -850,10 +852,12 @@ struct fe_priv {
>  	char name_tx[IFNAMSIZ + 3];       /* -tx    */
>  	char name_other[IFNAMSIZ + 6];    /* -other */
>  
> +#ifdef FORCEDETH_RECV_CACHE
>  	/* This is to schedule work */
>  	struct delayed_work     recv_cache_work;
>  	/* This list is to store skb queue for recv */
>  	struct sk_buff_head recv_list;
> +#endif
>  };
>  
>  /*
> @@ -1814,8 +1818,12 @@ static int nv_alloc_rx(struct net_device *dev)
>  		less_rx = np->last_rx.orig;
>  
>  	while (np->put_rx.orig != less_rx) {
> +#ifdef FORCEDETH_RECV_CACHE
>  		struct sk_buff *skb = skb_dequeue(&np->recv_list);
> -
> +#else
> +		struct sk_buff *skb = netdev_alloc_skb(np->dev,
> +					 np->rx_buf_sz + NV_RX_ALLOC_PAD);
> +#endif
>  		if (likely(skb)) {
>  			np->put_rx_ctx->skb = skb;
>  			np->put_rx_ctx->dma = dma_map_single(&np->pci_dev->dev,
> @@ -1840,15 +1848,15 @@ static int nv_alloc_rx(struct net_device *dev)
>  			u64_stats_update_begin(&np->swstats_rx_syncp);
>  			np->stat_rx_dropped++;
>  			u64_stats_update_end(&np->swstats_rx_syncp);
> -
> +#ifdef FORCEDETH_RECV_CACHE
>  			schedule_delayed_work(&np->recv_cache_work, 0);
> -
> +#endif

All these #ifdef are pretty ugly. It also makes for easy to break code
since most of the time this option will not be enabled. Please
refactor the code so that is uses

if (IS_ENABLED(FORCEDETH_RECV_CACHE))

so that the compiler at least compiles the code every time, and then
optimizing it out.

	   Andrew
