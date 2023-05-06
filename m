Return-Path: <netdev+bounces-671-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 746406F8E0F
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 04:35:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BE741C21B12
	for <lists+netdev@lfdr.de>; Sat,  6 May 2023 02:35:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14097EC2;
	Sat,  6 May 2023 02:35:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39EB7E;
	Sat,  6 May 2023 02:35:40 +0000 (UTC)
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5380561B0;
	Fri,  5 May 2023 19:35:38 -0700 (PDT)
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046056;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VhrT5Eo_1683340534;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0VhrT5Eo_1683340534)
          by smtp.aliyun-inc.com;
          Sat, 06 May 2023 10:35:34 +0800
Message-ID: <1683340417.612963-3-xuanzhuo@linux.alibaba.com>
Subject: Re: [PATCH net v3] virtio_net: Fix error unwinding of XDP initialization
Date: Sat, 6 May 2023 10:33:37 +0800
From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To: Feng Liu <feliu@nvidia.com>
Cc: Jason Wang <jasowang@redhat.com>,
 "Michael S . Tsirkin" <mst@redhat.com>,
 Simon Horman <simon.horman@corigine.com>,
 Bodong Wang <bodong@nvidia.com>,
 Feng Liu <feliu@nvidia.com>,
 William Tu <witu@nvidia.com>,
 Parav Pandit <parav@nvidia.com>,
 <virtualization@lists.linux-foundation.org>,
 <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>,
 <bpf@vger.kernel.org>
References: <20230503003525.48590-1-feliu@nvidia.com>
In-Reply-To: <20230503003525.48590-1-feliu@nvidia.com>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>

On Tue, 2 May 2023 20:35:25 -0400, Feng Liu <feliu@nvidia.com> wrote:
> When initializing XDP in virtnet_open(), some rq xdp initialization
> may hit an error causing net device open failed. However, previous
> rqs have already initialized XDP and enabled NAPI, which is not the
> expected behavior. Need to roll back the previous rq initialization
> to avoid leaks in error unwinding of init code.
>
> Also extract a helper function of disable queue pairs, and use newly
> introduced helper function in error unwinding and virtnet_close;
>
> Issue: 3383038
> Fixes: 754b8a21a96d ("virtio_net: setup xdp_rxq_info")
> Signed-off-by: Feng Liu <feliu@nvidia.com>
> Reviewed-by: William Tu <witu@nvidia.com>
> Reviewed-by: Parav Pandit <parav@nvidia.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Michael S. Tsirkin <mst@redhat.com>
> Change-Id: Ib4c6a97cb7b837cfa484c593dd43a435c47ea68f
> ---
>  drivers/net/virtio_net.c | 30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 8d8038538fc4..3737cf120cb7 100644
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
> @@ -1883,20 +1890,26 @@ static int virtnet_open(struct net_device *dev)
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
> +err_xdp_reg_mem_model:
> +	xdp_rxq_info_unreg(&vi->rq[i].xdp_rxq);
> +err_xdp_info_reg:
> +	for (i = i - 1; i >= 0; i--)
> +		virtnet_disable_qp(vi, i);


I would to know should we handle for these:

	disable_delayed_refill(vi);
	cancel_delayed_work_sync(&vi->refill);


Maybe we should call virtnet_close() with "i" directly.

Thanks.


> +
> +	return err;
>  }
>
>  static int virtnet_poll_tx(struct napi_struct *napi, int budget)
> @@ -2305,11 +2318,8 @@ static int virtnet_close(struct net_device *dev)
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
>

