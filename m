Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 189AB32722F
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 13:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhB1MR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 07:17:28 -0500
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:62818 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbhB1MR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 07:17:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1614514646; x=1646050646;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=+lCsR1Cpr636yBERgHfZqF60fw5sauAUtHSBuNEDgtM=;
  b=b3Ao1Zh86loJv1XhymgNHyRpmF6RXUbBRrLiePzvlUmp2ix6YjsKOuNY
   g8ggX6Nuw34ylaH0bIOmQh9+bb/w9fHT4rqNfF8csQUt2Q9FkerccJ1GH
   9tb+TpOkqij6evZrY8zA0gxlPr3VA/trXUluovy7Kn8Rnf2KwHpeXvNIF
   o=;
X-IronPort-AV: E=Sophos;i="5.81,213,1610409600"; 
   d="scan'208";a="91756580"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 28 Feb 2021 12:16:15 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-579b7f5b.us-west-2.amazon.com (Postfix) with ESMTPS id 8A449A2022;
        Sun, 28 Feb 2021 12:16:13 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.161.244) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 28 Feb 2021 12:16:00 +0000
References: <d0c326f95b2d0325f63e4040c1530bf6d09dc4d4.1614422144.git.lorenzo@kernel.org>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <ast@kernel.org>,
        <daniel@iogearbox.net>, <brouer@redhat.com>, <toke@redhat.com>,
        <freysteinn.alfredsson@kau.se>, <lorenzo.bianconi@redhat.com>,
        <john.fastabend@gmail.com>, <jasowang@redhat.com>,
        <mst@redhat.com>, <thomas.petazzoni@bootlin.com>,
        <mw@semihalf.com>, <linux@armlinux.org.uk>,
        <ilias.apalodimas@linaro.org>, <netanel@amazon.com>,
        <akiyano@amazon.com>, <michael.chan@broadcom.com>,
        <madalin.bucur@nxp.com>, <ioana.ciornei@nxp.com>,
        <jesse.brandeburg@intel.com>, <anthony.l.nguyen@intel.com>,
        <saeedm@nvidia.com>, <grygorii.strashko@ti.com>,
        <ecree.xilinx@gmail.com>
Subject: Re: [PATCH v2 bpf-next] bpf: devmap: move drop error path to devmap
 for XDP_REDIRECT
In-Reply-To: <d0c326f95b2d0325f63e4040c1530bf6d09dc4d4.1614422144.git.lorenzo@kernel.org>
Date:   Sun, 28 Feb 2021 14:15:29 +0200
Message-ID: <pj41zly2f8wfq6.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.244]
X-ClientProxiedBy: EX13D50UWA003.ant.amazon.com (10.43.163.56) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Lorenzo Bianconi <lorenzo@kernel.org> writes:

> ...
> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c 
> b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> index 102f2c91fdb8..7ad0557dedbd 100644
> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
> ...
> 
> @@ -339,8 +337,8 @@ static int ena_xdp_xmit(struct net_device 
> *dev, int n,
>  			struct xdp_frame **frames, u32 flags)
>  {
>  	struct ena_adapter *adapter = netdev_priv(dev);
> -	int qid, i, err, drops = 0;
>  	struct ena_ring *xdp_ring;
> +	int qid, i, nxmit = 0;
>  
>  	if (unlikely(flags & ~XDP_XMIT_FLAGS_MASK))
>  		return -EINVAL;
> @@ -360,12 +358,12 @@ static int ena_xdp_xmit(struct net_device 
> *dev, int n,
>  	spin_lock(&xdp_ring->xdp_tx_lock);
>  
>  	for (i = 0; i < n; i++) {
> -		err = ena_xdp_xmit_frame(xdp_ring, dev, frames[i], 
> 0);
>  		/* The descriptor is freed by ena_xdp_xmit_frame 
>  in case
>  		 * of an error.
>  		 */

Thanks a lot for the patch. It's a good idea. Do you mind removing 
the comment here as well ? ena_xdp_xmit_frame() no longer frees 
the frame in case of an error after this patch.

> -		if (err)
> -			drops++;
> +		if (ena_xdp_xmit_frame(xdp_ring, dev, frames[i], 
> 0))
> +			break;
> +		nxmit++;
>  	}
>  
>  	/* Ring doorbell to make device aware of the packets */
> @@ -378,7 +376,7 @@ static int ena_xdp_xmit(struct net_device 
> *dev, int n,
>  	spin_unlock(&xdp_ring->xdp_tx_lock);
>  
>  	/* Return number of packets sent */
> -	return n - drops;
> +	return nxmit;
>  }
> ...
> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
> index 85d9d1b72a33..9f158b3862df 100644
> --- a/kernel/bpf/devmap.c
> +++ b/kernel/bpf/devmap.c
> @@ -344,29 +344,26 @@ static void bq_xmit_all(struct 
> xdp_dev_bulk_queue *bq, u32 flags)
>  
>  	sent = dev->netdev_ops->ndo_xdp_xmit(dev, bq->count, 
>  bq->q, flags);
>  	if (sent < 0) {
> +		/* If ndo_xdp_xmit fails with an errno, no frames 
> have
> +		 * been xmit'ed.
> +		 */
>  		err = sent;
>  		sent = 0;
> -		goto error;
>  	}
> +
>  	drops = bq->count - sent;
> -out:
> -	bq->count = 0;
> +	if (unlikely(drops > 0)) {
> +		/* If not all frames have been transmitted, it is 
> our
> +		 * responsibility to free them
> +		 */
> +		for (i = sent; i < bq->count; i++)
> +			xdp_return_frame_rx_napi(bq->q[i]);
> +	}

Wouldn't the logic above be the same even w/o the 'if' condition ?

>  
> +	bq->count = 0;
>  	trace_xdp_devmap_xmit(bq->dev_rx, dev, sent, drops, err);
>  	bq->dev_rx = NULL;
>  	__list_del_clearprev(&bq->flush_node);
> -	return;
> -error:
> -	/* If ndo_xdp_xmit fails with an errno, no frames have 
> been
> -	 * xmit'ed and it's our responsibility to them free all.
> -	 */
> -	for (i = 0; i < bq->count; i++) {
> -		struct xdp_frame *xdpf = bq->q[i];
> -
> -		xdp_return_frame_rx_napi(xdpf);
> -		drops++;
> -	}
> -	goto out;
>  }
>  
>  /* __dev_flush is called from xdp_do_flush() which _must_ be 
>  signaled

Thanks, Shay
