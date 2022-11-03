Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46AB56179BF
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 10:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiKCJWL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 05:22:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbiKCJV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 05:21:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BDBBF5BD
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 02:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667467206;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wbad5tDvhcv43HWv7jT8y7cJ3wMs2qgB8vEI3ZPussk=;
        b=jPf214wKfB75nrMT7uz51NOHSufSD8usc+xNkn7XXA4R2rKZkUAjv1cUDHi2ldkaXIBDoz
        My2O/vwIDrgXLx+KzA7BXdYiIvwEc/64XNNPXAs2uP02IO74FIt42qVIwGey0WBaFyv1+v
        8bDfLDssH2UmVnvnLW8CEqBvHaYq4uM=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-590-qgjQgPgyM2qhStrRVvFPcA-1; Thu, 03 Nov 2022 05:20:03 -0400
X-MC-Unique: qgjQgPgyM2qhStrRVvFPcA-1
Received: by mail-qv1-f69.google.com with SMTP id x2-20020a0cff22000000b004bb07bf7557so934556qvt.11
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 02:20:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wbad5tDvhcv43HWv7jT8y7cJ3wMs2qgB8vEI3ZPussk=;
        b=dc9BXkiFXDVPI4HgXrEHv3JFYCFzcI8W1bB1h1c1umguOdm3MwwIGtjfPl3ZsCFttM
         9eAUZa37NURcHSbnhmPqAGt8mW4fREPZxQYmOM36KU+JFCR9sDDKHb5tRbXHdIyjZyQJ
         9Co+7fgnofGcSY5BnsFUd3mo/jfmUuf80xOCG4s5zGQSxKJtCWOJRWZWaFad7u3xLaGk
         6fsG78EqqimZXiEE8/QNbSt1PLv3xgg3s3BNywA/ms3sR3bHs45b96wOGnA3yJIUafU9
         J/HBqaAZERhPqUcuAnnPCYw0pwlzOdGwdv+ZjVqK4ylPtaEKHna5joFG7PnUuDVdELFH
         SgqA==
X-Gm-Message-State: ACrzQf2XVNMMqQ1VALMeOs1TyDQT8nxfGsnsXq3aYgBU/TrMNEw1kY/Z
        Dbz/27DG0HoKkjZsJUIn+RIiskSJ7Mw9Hp0jBRpdhWfqXaHk9K4799yVdgZgzQ/3O0eiMMOcthQ
        9oJ6KoN800pNazEVJ
X-Received: by 2002:a05:622a:260d:b0:3a5:2545:38b with SMTP id ci13-20020a05622a260d00b003a52545038bmr17249331qtb.609.1667467203104;
        Thu, 03 Nov 2022 02:20:03 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6B1Ii3RI07fwLoqBnrK0tODg0oSZZJR4RZQZSy/p4D5L/8Mm66Xi7oMHXzSgOeWL3/AWFgaA==
X-Received: by 2002:a05:622a:260d:b0:3a5:2545:38b with SMTP id ci13-20020a05622a260d00b003a52545038bmr17249315qtb.609.1667467202788;
        Thu, 03 Nov 2022 02:20:02 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-100-54.dyn.eolo.it. [146.241.100.54])
        by smtp.gmail.com with ESMTPSA id h18-20020a05620a401200b006ee8874f5fasm391544qko.53.2022.11.03.02.19.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 02:20:01 -0700 (PDT)
Message-ID: <4968ca694f800ad4cd5bc0659a13b82758a01b27.camel@redhat.com>
Subject: Re: [PATCH v3 1/1] net: fec: add initial XDP support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Shenwei Wang <shenwei.wang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        imx@lists.linux.dev, kernel test robot <lkp@intel.com>
Date:   Thu, 03 Nov 2022 10:19:58 +0100
In-Reply-To: <20221031185350.2045675-1-shenwei.wang@nxp.com>
References: <20221031185350.2045675-1-shenwei.wang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-10-31 at 13:53 -0500, Shenwei Wang wrote:
> This patch adds the initial XDP support to Freescale driver. It supports
> XDP_PASS, XDP_DROP and XDP_REDIRECT actions. Upcoming patches will add
> support for XDP_TX and Zero Copy features.
> 
> As the patch is rather large, the part of codes to collect the
> statistics is separated and will prepare a dedicated patch for that
> part.
> 
> I just tested with the application of xdpsock.
>   -- Native here means running command of "xdpsock -i eth0"
>   -- SKB-Mode means running command of "xdpsock -S -i eth0"
> 
> The following are the testing result relating to XDP mode:
> 
> root@imx8qxpc0mek:~/bpf# ./xdpsock -i eth0
>  sock0@eth0:0 rxdrop xdp-drv
>                    pps            pkts           1.00
> rx                 371347         2717794
> tx                 0              0
> 
> root@imx8qxpc0mek:~/bpf# ./xdpsock -S -i eth0
>  sock0@eth0:0 rxdrop xdp-skb
>                    pps            pkts           1.00
> rx                 202229         404528
> tx                 0              0
> 
> root@imx8qxpc0mek:~/bpf# ./xdp2 eth0
> proto 0:     496708 pkt/s
> proto 0:     505469 pkt/s
> proto 0:     505283 pkt/s
> proto 0:     505443 pkt/s
> proto 0:     505465 pkt/s
> 
> root@imx8qxpc0mek:~/bpf# ./xdp2 -S eth0
> proto 0:          0 pkt/s
> proto 17:     118778 pkt/s
> proto 17:     118989 pkt/s
> proto 0:          1 pkt/s
> proto 17:     118987 pkt/s
> proto 0:          0 pkt/s
> proto 17:     118943 pkt/s
> proto 17:     118976 pkt/s
> proto 0:          1 pkt/s
> proto 17:     119006 pkt/s
> proto 0:          0 pkt/s
> proto 17:     119071 pkt/s
> proto 17:     119092 pkt/s
> 
> Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
> Reported-by: kernel test robot <lkp@intel.com>
> ---
>  changes in V3:
>  - remove the codes to update the RX ring size to avoid potential risk.
>  - update the testing data based on the new implementation.
> 
>  changes in V2:
>  - Get rid of the expensive fec_net_close/open function calls during
>    XDP/Normal Mode switch.
>  - Update the testing data on i.mx8qxp mek board.
>  - fix the compile issue reported by kernel_test_robot
> 
>  drivers/net/ethernet/freescale/fec.h      |   4 +-
>  drivers/net/ethernet/freescale/fec_main.c | 224 +++++++++++++++++++++-
>  2 files changed, 226 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/fec.h b/drivers/net/ethernet/freescale/fec.h
> index 476e3863a310..61e847b18343 100644
> --- a/drivers/net/ethernet/freescale/fec.h
> +++ b/drivers/net/ethernet/freescale/fec.h
> @@ -348,7 +348,6 @@ struct bufdesc_ex {
>   */
> 
>  #define FEC_ENET_XDP_HEADROOM	(XDP_PACKET_HEADROOM)
> -
>  #define FEC_ENET_RX_PAGES	256
>  #define FEC_ENET_RX_FRSIZE	(PAGE_SIZE - FEC_ENET_XDP_HEADROOM \
>  		- SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))
> @@ -663,6 +662,9 @@ struct fec_enet_private {
> 
>  	struct imx_sc_ipc *ipc_handle;
> 
> +	/* XDP BPF Program */
> +	struct bpf_prog *xdp_prog;
> +
>  	u64 ethtool_stats[];
>  };
> 
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 6986b74fb8af..6b062a0663f4 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -89,6 +89,11 @@ static const u16 fec_enet_vlan_pri_to_queue[8] = {0, 0, 1, 1, 1, 2, 2, 2};
>  #define FEC_ENET_OPD_V	0xFFF0
>  #define FEC_MDIO_PM_TIMEOUT  100 /* ms */
> 
> +#define FEC_ENET_XDP_PASS          0
> +#define FEC_ENET_XDP_CONSUMED      BIT(0)
> +#define FEC_ENET_XDP_TX            BIT(1)
> +#define FEC_ENET_XDP_REDIR         BIT(2)
> +
>  struct fec_devinfo {
>  	u32 quirks;
>  };
> @@ -418,13 +423,14 @@ static int
>  fec_enet_create_page_pool(struct fec_enet_private *fep,
>  			  struct fec_enet_priv_rx_q *rxq, int size)
>  {
> +	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
>  	struct page_pool_params pp_params = {
>  		.order = 0,
>  		.flags = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV,
>  		.pool_size = size,
>  		.nid = dev_to_node(&fep->pdev->dev),
>  		.dev = &fep->pdev->dev,
> -		.dma_dir = DMA_FROM_DEVICE,
> +		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
>  		.offset = FEC_ENET_XDP_HEADROOM,
>  		.max_len = FEC_ENET_RX_FRSIZE,
>  	};
> @@ -1499,6 +1505,59 @@ static void fec_enet_update_cbd(struct fec_enet_priv_rx_q *rxq,
>  	bdp->cbd_bufaddr = cpu_to_fec32(phys_addr);
>  }
> 
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
> +		ret = FEC_ENET_XDP_PASS;
> +		break;
> +
> +	case XDP_REDIRECT:
> +		err = xdp_do_redirect(fep->netdev, xdp, prog);
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
> +	case XDP_TX:
> +		bpf_warn_invalid_xdp_action(fep->netdev, prog, act);
> +		fallthrough;
> +
> +	case XDP_ABORTED:
> +		fallthrough;    /* handle aborts by dropping packet */
> +
> +	case XDP_DROP:
> +		ret = FEC_ENET_XDP_CONSUMED;
> +		page = virt_to_head_page(xdp->data);
> +		page_pool_put_page(rxq->page_pool, page, sync, true);
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
>  /* During a receive, the bd_rx.cur points to the current incoming buffer.
>   * When we update through the ring, if the next incoming buffer has
>   * not been given to the system, we just set the empty indicator,
> @@ -1520,6 +1579,9 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>  	u16	vlan_tag;
>  	int	index = 0;
>  	bool	need_swap = fep->quirks & FEC_QUIRK_SWAP_FRAME;
> +	struct bpf_prog *xdp_prog = READ_ONCE(fep->xdp_prog);
> +	u32 ret, xdp_result = FEC_ENET_XDP_PASS;
> +	struct xdp_buff xdp;
>  	struct page *page;
> 
>  #ifdef CONFIG_M532x
> @@ -1531,6 +1593,7 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>  	 * These get messed up if we get called due to a busy condition.
>  	 */
>  	bdp = rxq->bd.cur;
> +	xdp_init_buff(&xdp, PAGE_SIZE, &rxq->xdp_rxq);
> 
>  	while (!((status = fec16_to_cpu(bdp->cbd_sc)) & BD_ENET_RX_EMPTY)) {
> 
> @@ -1580,6 +1643,17 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>  		prefetch(page_address(page));
>  		fec_enet_update_cbd(rxq, bdp, index);
> 
> +		if (xdp_prog) {
> +			xdp_buff_clear_frags_flag(&xdp);
> +			xdp_prepare_buff(&xdp, page_address(page),
> +					 FEC_ENET_XDP_HEADROOM, pkt_len, false);
> +
> +			ret = fec_enet_run_xdp(fep, xdp_prog, &xdp, rxq, index);
> +			xdp_result |= ret;
> +			if (ret != FEC_ENET_XDP_PASS)
> +				goto rx_processing_done;
> +		}
> +
>  		/* The packet length includes FCS, but we don't want to
>  		 * include that when passing upstream as it messes up
>  		 * bridging applications.
> @@ -1675,6 +1749,10 @@ fec_enet_rx_queue(struct net_device *ndev, int budget, u16 queue_id)
>  		writel(0, rxq->bd.reg_desc_active);
>  	}
>  	rxq->bd.cur = bdp;
> +
> +	if (xdp_result & FEC_ENET_XDP_REDIR)
> +		xdp_do_flush_map();
> +
>  	return pkt_received;
>  }
> 
> @@ -3476,6 +3554,148 @@ static u16 fec_enet_select_queue(struct net_device *ndev, struct sk_buff *skb,
>  	return fec_enet_vlan_pri_to_queue[vlan_tag >> 13];
>  }
> 
> +static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf *bpf)
> +{
> +	struct fec_enet_private *fep = netdev_priv(dev);
> +	bool is_run = netif_running(dev);
> +	struct bpf_prog *old_prog;
> +
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		if (is_run) {
> +			napi_disable(&fep->napi);
> +			netif_tx_disable(dev);
> +		}
> +
> +		old_prog = xchg(&fep->xdp_prog, bpf->prog);
> +		fec_restart(dev);
> +
> +		if (is_run) {
> +			napi_enable(&fep->napi);
> +			netif_tx_start_all_queues(dev);
> +		}
> +
> +		if (old_prog)
> +			bpf_prog_put(old_prog);
> +
> +		return 0;
> +
> +	case XDP_SETUP_XSK_POOL:
> +		return -EOPNOTSUPP;
> +
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
> +static int
> +fec_enet_xdp_get_tx_queue(struct fec_enet_private *fep, int cpu)
> +{
> +	int index = cpu;
> +
> +	if (unlikely(index < 0))
> +		index = 0;
> +
> +	while (index >= fep->num_tx_queues)
> +		index -= fep->num_tx_queues;

Not a big deal, but I think kind of optimizations are not worthy and
potentially dangerous since late '90 ;)

You could consider switching to a simpler '%', but IMHO it's not
blocking.


Cheers,

Paolo

