Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93D416F49C0
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 20:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbjEBSdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 14:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233608AbjEBSdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 14:33:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 127FB1988
        for <netdev@vger.kernel.org>; Tue,  2 May 2023 11:32:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683052377;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NhpWzKFV6WuY3k3TP6SkZOGPmg0MohvKMd0v7Ellcl4=;
        b=bxII1+xIDkhN7AHPiEouol7Vuol2WFtGFRssT/gDL+p9fjLm4CcRRYUhyV1Oq0ky4V9zjO
        9IVcYGRG9hcGUZluaU8kCn/3iA/3gv1g/V9o/s59r5kJ3j2lUmUYpX42ukJu4JUoIAI5vw
        dDt19eb/65GnmMwqNqxoI8EI9EhSIZ0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-HRTaGkx4Mo66aLTr2rNMHg-1; Tue, 02 May 2023 14:32:53 -0400
X-MC-Unique: HRTaGkx4Mo66aLTr2rNMHg-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f16ef3be6eso25352625e9.3
        for <netdev@vger.kernel.org>; Tue, 02 May 2023 11:32:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683052372; x=1685644372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NhpWzKFV6WuY3k3TP6SkZOGPmg0MohvKMd0v7Ellcl4=;
        b=EYN59fhd6glRKpi7kLM0/lK4Nh6CsbP77D/iivAfiuEur1qhEzj1nfKJZwLqLU3QIA
         aL7Fhu/x3czxmDpaOf+ZMcTTgRg78PRJo6GyJr7f0xfCDtLCninTV2PKr/nE0Gc14c25
         vhRR03jgQ+3pgbuibHHRV/xZ8d4UEkD4wEKjLkJwNgTpBTPqhCvxsdR3vsOwPzJk7NfJ
         EiYJMihNhOozzKYP/X6Se3yaE+0SBsxOyedNn7l8ktRovP4pxhUniRPTM+fS7gHJCUgn
         TccthXlOP+H+VrMmkmoCwBAzDy2FzOCx+eOOM+qr6Y9G4eqCVCrdNpPc2WI43vX5TSOP
         n7MA==
X-Gm-Message-State: AC+VfDxxbRtwDDvO5Vw3bNsLV1NqouSjyJrwCXWOeqLVuXgGVBrUyRHr
        PoIH0F6LBlavqCQg/jjRH/JEp8HNeJGx+F0nYtoQ3HrthcLst5slUCTRKUNseOKTaCiCiQTlcDZ
        E3NuZX3I6U9gV68g4
X-Received: by 2002:adf:e38b:0:b0:2dc:cad4:87b9 with SMTP id e11-20020adfe38b000000b002dccad487b9mr11784988wrm.68.1683052372746;
        Tue, 02 May 2023 11:32:52 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7NTwwDePG2g45V+TgxsNxz1VA7838wfE2TMtMS4WPnQUULqKPl7ToB/3+9718Vn306lnc9dA==
X-Received: by 2002:adf:e38b:0:b0:2dc:cad4:87b9 with SMTP id e11-20020adfe38b000000b002dccad487b9mr11784980wrm.68.1683052372419;
        Tue, 02 May 2023 11:32:52 -0700 (PDT)
Received: from redhat.com ([2.52.10.43])
        by smtp.gmail.com with ESMTPSA id i11-20020adfe48b000000b002c3f81c51b6sm31546095wrm.90.2023.05.02.11.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 May 2023 11:32:51 -0700 (PDT)
Date:   Tue, 2 May 2023 14:32:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Feng Liu <feliu@nvidia.com>
Cc:     virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
        Simon Horman <simon.horman@corigine.com>,
        William Tu <witu@nvidia.com>, Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net v2] virtio_net: Fix error unwinding of XDP
 initialization
Message-ID: <20230502143148-mutt-send-email-mst@kernel.org>
References: <20230502174134.32276-1-feliu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230502174134.32276-1-feliu@nvidia.com>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 02, 2023 at 01:41:34PM -0400, Feng Liu wrote:
> When initializing XDP in virtnet_open(), some rq xdp initialization
> may hit an error causing net device open failed. However, previous
> rqs have already initialized XDP and enabled NAPI, which is not the
> expected behavior. Need to roll back the previous rq initialization
> to avoid leaks in error unwinding of init code.
> 
> Also extract a helper function of disable queue pairs, and use newly
> introduced helper function in error unwinding and virtnet_close;
> 
> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: William Tu <witu@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> ---
>  drivers/net/virtio_net.c | 31 +++++++++++++++++++++----------
>  1 file changed, 21 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8d8038538fc4..5cd78e154d14 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1868,6 +1868,13 @@ static int virtnet_poll(struct napi_struct *napi, int budget)
>  	return received;
>  }
>  
> +static void virtnet_disable_qp(struct virtnet_info *vi, int qp_index)
> +{
> +	virtnet_napi_tx_disable(&vi->sq[qp_index].napi);
> +	napi_disable(&vi->rq[qp_index].napi);
> +	xdp_rxq_info_unreg(&vi->rq[qp_index].xdp_rxq);
> +}
> +
>  static int virtnet_open(struct net_device *dev)
>  {
>  	struct virtnet_info *vi = netdev_priv(dev);
> @@ -1883,20 +1890,27 @@ static int virtnet_open(struct net_device *dev)
>  
>  		err = xdp_rxq_info_reg(&vi->rq[i].xdp_rxq, dev, i, vi->rq[i].napi.napi_id);
>  		if (err < 0)
> -			return err;
> +			goto err_xdp_info_reg;
>  
>  		err = xdp_rxq_info_reg_mem_model(&vi->rq[i].xdp_rxq,
>  						 MEM_TYPE_PAGE_SHARED, NULL);
> -		if (err < 0) {
> -			xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> -			return err;
> -		}
> +		if (err < 0)
> +			goto err_xdp_reg_mem_model;
>  
>  		virtnet_napi_enable(vi->rq[i].vq, &vi->rq[i].napi);
>  		virtnet_napi_tx_enable(vi, vi->sq[i].vq, &vi->sq[i].napi);
>  	}
>  
>  	return 0;
> +
> +	/* error unwinding of xdp init */

btw we don't really need this comment - it's how all
error handling is done anyways.
if you need to roll v3, you can drop it.

> +err_xdp_reg_mem_model:
> +	xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> +err_xdp_info_reg:
> +	for (i = i - 1; i >= 0; i--)
> +		virtnet_disable_qp(vi, i);
> +
> +	return err;
>  }
>  
>  static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> @@ -2305,11 +2319,8 @@ static int virtnet_close(struct net_device *dev)
>  	/* Make sure refill_work doesn't re-enable napi! */
>  	cancel_delayed_work_sync(&vi->refill);
>  
> -	for (i = 0; i < vi->max_queue_pairs; i++) {
> -		virtnet_napi_tx_disable(&vi->sq[i].napi);
> -		napi_disable(&vi->rq[i].napi);
> -		xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> -	}
> +	for (i = 0; i < vi->max_queue_pairs; i++)
> +		virtnet_disable_qp(vi, i);
>  
>  	return 0;
>  }
> -- 
> 2.37.1 (Apple Git-137.1)

