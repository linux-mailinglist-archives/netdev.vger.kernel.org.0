Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC7E33104D
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 15:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbhCHODM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 09:03:12 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229737AbhCHOCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 09:02:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1615212162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+CqKVSQcPNifcZ1AAYlE/XMm/4je6cU2lsCCrjyWtUc=;
        b=BqpHrgvoLHBDiUTrtCcIA5ArVlyugruDsxeC0Zw2iUSVdQYicbjZw1FWUOuhABZ+KfDF6e
        RIEMMLNXwCcw1XWQP0AU2BGZxoMzfJJk493VDVa2+1qzFSkokiZj4/TlgQNlBewJQza0TL
        V0dZFJaTPLFrhLM9hPHjZze50A+2/bc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-578-KcCwKM5_NBuphUzPVUupoQ-1; Mon, 08 Mar 2021 09:02:38 -0500
X-MC-Unique: KcCwKM5_NBuphUzPVUupoQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 446501923763;
        Mon,  8 Mar 2021 14:02:35 +0000 (UTC)
Received: from carbon (unknown [10.36.110.10])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B9A9F5C27C;
        Mon,  8 Mar 2021 14:02:12 +0000 (UTC)
Date:   Mon, 8 Mar 2021 15:02:11 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        toke@redhat.com, freysteinn.alfredsson@kau.se,
        lorenzo.bianconi@redhat.com, john.fastabend@gmail.com,
        jasowang@redhat.com, mst@redhat.com, thomas.petazzoni@bootlin.com,
        mw@semihalf.com, linux@armlinux.org.uk,
        ilias.apalodimas@linaro.org, netanel@amazon.com,
        akiyano@amazon.com, michael.chan@broadcom.com,
        madalin.bucur@nxp.com, ioana.ciornei@nxp.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        saeedm@nvidia.com, grygorii.strashko@ti.com,
        ecree.xilinx@gmail.com, maciej.fijalkowski@intel.com,
        brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
Message-ID: <20210308150211.1fffca3f@carbon>
In-Reply-To: <ed670de24f951cfd77590decf0229a0ad7fd12f6.1615201152.git.lorenzo@kernel.org>
References: <ed670de24f951cfd77590decf0229a0ad7fd12f6.1615201152.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  8 Mar 2021 12:06:58 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> We want to change the current ndo_xdp_xmit drop semantics because
> it will allow us to implement better queue overflow handling.
> This is working towards the larger goal of a XDP TX queue-hook.
> Move XDP_REDIRECT error path handling from each XDP ethernet driver to
> devmap code. According to the new APIs, the driver running the
> ndo_xdp_xmit pointer, will break tx loop whenever the hw reports a tx
> error and it will just return to devmap caller the number of successfully
> transmitted frames. It will be devmap responsability to free dropped
> frames.
> Move each XDP ndo_xdp_xmit capable driver to the new APIs:
> - veth
> - virtio-net
> - mvneta
> - mvpp2
> - socionext
> - amazon ena
> - bnxt
> - freescale (dpaa2, dpaa)
> - xen-frontend
> - qede
> - ice
> - igb
> - ixgbe
> - i40e
> - mlx5
> - ti (cpsw, cpsw-new)
> - tun
> - sfc
> 
> Acked-by: Edward Cree <ecree.xilinx@gmail.com>
> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> More details about the new ndo_xdp_xmit design can be found here [0].
> 
> [0] https://github.com/xdp-project/xdp-project/blob/master/areas/core/redesign01_ndo_xdp_xmit.org
> 
> Changes since v2:
> - drop wrong comment in ena driver
> - simplify drop condition using unlikey in the for condition of devmap code
> - rebase on top of bpf-next
> - collect acked-by/reviewed-by
> 
> Changes since v1:
> - rebase on top of bpf-next
> - add driver maintainers in cc
> - add Edward's ack
> ---
>  drivers/net/ethernet/amazon/ena/ena_netdev.c  | 21 ++++++-------
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 20 +++++--------
>  .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 12 ++++----
>  .../net/ethernet/freescale/dpaa2/dpaa2-eth.c  |  2 --
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c   | 15 +++++-----
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 15 +++++-----
>  drivers/net/ethernet/intel/igb/igb_main.c     | 11 ++++---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 11 ++++---
>  drivers/net/ethernet/marvell/mvneta.c         | 13 ++++----
>  .../net/ethernet/marvell/mvpp2/mvpp2_main.c   | 13 ++++----
>  .../net/ethernet/mellanox/mlx5/core/en/xdp.c  | 15 ++++------
>  drivers/net/ethernet/qlogic/qede/qede_fp.c    | 19 +++++-------
>  drivers/net/ethernet/sfc/tx.c                 | 15 +---------
>  drivers/net/ethernet/socionext/netsec.c       | 16 +++++-----
>  drivers/net/ethernet/ti/cpsw.c                | 14 ++++-----
>  drivers/net/ethernet/ti/cpsw_new.c            | 14 ++++-----
>  drivers/net/ethernet/ti/cpsw_priv.c           | 11 +++----
>  drivers/net/tun.c                             | 15 ++++++----
>  drivers/net/veth.c                            | 28 +++++++++--------
>  drivers/net/virtio_net.c                      | 25 ++++++++--------
>  drivers/net/xen-netfront.c                    | 18 +++++------
>  kernel/bpf/devmap.c                           | 30 ++++++++-----------
>  22 files changed, 153 insertions(+), 200 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acking core changes to bpf/devmap.c (kept below).
I've only skimmed the driver changes.

> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 85d9d1b72a33..d6330bbe1209 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -330,7 +330,7 @@ bool dev_map_can_have_prog(struct bpf_map *map)
>  static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  {
>  	struct net_device *dev = bq->dev;
> -	int sent = 0, drops = 0, err = 0;
> +	int sent = 0, err = 0;
>  	int i;
>  
>  	if (unlikely(!bq->count))
> @@ -344,29 +344,23 @@ static void bq_xmit_all(struct xdp_dev_bulk_queue *bq, u32 flags)
>  
>  	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, bq->q, flags);
>  	if (sent < 0) {
> +		/* If ndo_xdp_xmit fails with an errno, no frames have
> +		 * been xmit'ed.
> +		 */
>  		err = sent;
>  		sent = 0;
> -		goto error;
>  	}
> -	drops = bq->count - sent;
> -out:
> -	bq->count = 0;
>  
> -	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
> -	bq->dev_rx = NULL;
> -	__list_del_clearprev(&bq->flush_node);
> -	return;
> -error:
> -	/* If ndo_xdp_xmit fails with an errno, no frames have been
> -	 * xmit'ed and it's our responsibility to them free all.
> +	/* If not all frames have been transmitted, it is our
> +	 * responsibility to free them
>  	 */
> -	for (i = 0; i < bq->count; i++) {
> -		struct xdp_frame *xdpf = bq->q[i];
> +	for (i = sent; unlikely(i < bq->count); i++)
> +		xdp_return_frame_rx_napi(bq->q[i]);
>  
> -		xdp_return_frame_rx_napi(xdpf);
> -		drops++;
> -	}
> -	goto out;
> +	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, bq->count - sent, err);
> +	bq->dev_rx = NULL;
> +	bq->count = 0;
> +	__list_del_clearprev(&bq->flush_node);
>  }
>  
>  /* __dev_flush is called from xdp_do_flush() which _must_ be signaled



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

