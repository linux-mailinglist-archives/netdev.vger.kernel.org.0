Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA66D1A2259
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 14:52:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgDHMwd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 08:52:33 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55696 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgDHMwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 08:52:32 -0400
Received: by mail-wm1-f65.google.com with SMTP id e26so5008239wmk.5;
        Wed, 08 Apr 2020 05:52:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PRlNq3O9W+GEwtabsaaMxRmUroj5R+XwzTWTNPXlfCo=;
        b=VbFD0EakQduZjyk4Mc83IwSULk8BvmPoX1U/0xqLZcgQz+8o/NdUizxw0gGrhIaER+
         SlrPhrJPm6s4hWUoRz9x+ll9BcOr/8Qrc8XL5jpy+6uheEQs8lRs5sRfJdmsKG2CLnu9
         nugyWitwSxiqIHUQhFFQk2MNd286nSpleRDHdvXzH6hZLaUhqtOYgJKM1aDr0BS058Nu
         9nVcPATHSPVz8/gLvMuFDGVpDtELkq/cuzW6h+vntR6HrjlHVzd4mgscoyh/5LHigKER
         kP+bkwFDkrwTxtd6rg+/dhCQWJiBO/Ost9Sxj+xNCjridis7w+KlnjL6PEipx9XUEL2y
         GvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PRlNq3O9W+GEwtabsaaMxRmUroj5R+XwzTWTNPXlfCo=;
        b=Col2kkQ10Lo0DtMIgPf8PODSYfZjXiecX5cgK7TXjZD4THeEC88HA+xa4bo6Oezifu
         5W/2HwNdLGYv72NWB+RYCX0pk1ueGlKr7Sib0QwMBm7lRHeSqnW0FL5AfInB5Acz5CNc
         69T4r/rHRBBSLy1NRC6UB7lX+tJYZ/56xykFkbflXF/TcO5+INtLS1AW6Lyy09n+KHPs
         l7voTSZN7RkfJ4jV4LtH3lPuvt5uArw99srtwd4l0sYxnX5UDmQ1qwK3kVA2jRcb0GXT
         miMO0YIkG452PBhBi8+9gCJApX3wduv3zj0PYdIM7ed/cv8p4FceMybUxMAbTrdx/I9t
         CqtQ==
X-Gm-Message-State: AGi0PuYii7HyOm8k4FXR/QlwoxowznQZKR1Zk06W7TK+k8rKw9JoFNXu
        qP8XlAy6v2gMzjA6yikPoxo=
X-Google-Smtp-Source: APiQypJyqODhZugk+RjnZF788y5qewSDMXeGiX9+L6tQptz3udJX3UlBVokDWTtq29187ahleBYSpA==
X-Received: by 2002:a1c:2b06:: with SMTP id r6mr4814872wmr.25.1586350350133;
        Wed, 08 Apr 2020 05:52:30 -0700 (PDT)
Received: from [192.168.1.110] ([77.125.109.57])
        by smtp.gmail.com with ESMTPSA id c20sm7199742wmd.36.2020.04.08.05.52.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Apr 2020 05:52:29 -0700 (PDT)
Subject: Re: [PATCH RFC v2 17/33] mlx5: rx queue setup time determine frame_sz
 for XDP
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
 <158634672069.707275.13343795980982759611.stgit@firesoul>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
Message-ID: <44441c56-c096-0dd3-9dc0-57f98065e44d@gmail.com>
Date:   Wed, 8 Apr 2020 15:52:26 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <158634672069.707275.13343795980982759611.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper,

Thanks for your patch.
Please see feedback below.

On 4/8/2020 2:52 PM, Jesper Dangaard Brouer wrote:
> The mlx5 driver have multiple memory models, which are also changed
> according to whether a XDP bpf_prog is attached.
> 
> The 'rx_striding_rq' setting is adjusted via ethtool priv-flags e.g.:
>   # ethtool --set-priv-flags mlx5p2 rx_striding_rq off
> 
> On the general case with 4K page_size and regular MTU packet, then
> the frame_sz is 2048 and 4096 when XDP is enabled, in both modes.
> 
> The info on the given frame size is stored differently depending on the
> RQ-mode and encoded in a union in struct mlx5e_rq union wqe/mpwqe.
> In rx striding mode rq->mpwqe.log_stride_sz is either 11 or 12, which
> corresponds to 2048 or 4096 (MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ).
> In non-striding mode (MLX5_WQ_TYPE_CYCLIC) the frag_stride is stored
> in rq->wqe.info.arr[0].frag_stride.

Just to clarify, the above description is true as long as we're in the 
Linear SKB memory scheme, this holds when:
1) MTU + headroom + tailroom < PAGE_SIZE, and
2) HW LRO is OFF.

Otherwise, mpwqe.log_stride_sz can be smaller, and frag_stride of 
wqe_info can vary from one index to another.

> 
> To reduce effect on fast-path, this patch determine the frame_sz at
> setup time, to avoid determining the memory model runtime.
> 
> Cc: Tariq Toukan <tariqt@mellanox.com>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
>   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |    1 +
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    4 ++++
>   3 files changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index 12a61bf82c14..1f280fc142ca 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -651,6 +651,7 @@ struct mlx5e_rq {
>   	struct {
>   		u16            umem_headroom;
>   		u16            headroom;
> +		u32            frame_sz;
>   		u8             map_dir;   /* dma map direction */
>   	} buff;
>   
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index f049e0ac308a..de4ad2c9f49a 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -137,6 +137,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
>   	if (xsk)
>   		xdp.handle = di->xsk.handle;
>   	xdp.rxq = &rq->xdp_rxq;
> +	xdp.frame_sz = rq->buff.frame_sz;
>   
>   	act = bpf_prog_run_xdp(prog, &xdp);
>   	if (xsk) {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index dd7f338425eb..b9595315c45b 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -462,6 +462,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>   		rq->mpwqe.num_strides =
>   			BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
>   
> +		rq->buff.frame_sz = (1 << rq->mpwqe.log_stride_sz);
> +

This is always correct.

>   		err = mlx5e_create_rq_umr_mkey(mdev, rq);
>   		if (err)
>   			goto err_rq_wq_destroy;
> @@ -485,6 +487,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>   			num_xsk_frames = wq_sz << rq->wqe.info.log_num_frags;
>   
>   		rq->wqe.info = rqp->frags_info;
> +		rq->buff.frame_sz = rq->wqe.info.arr[0].frag_stride;
> +

This is not always correct.
Size of the last frag for a large MTU might be a full page.
See:
https://elixir.bootlin.com/linux/latest/source/drivers/net/ethernet/mellanox/mlx5/core/en_main.c#L2097

However, you won't try to use this value at all in the non-linear SKB 
flow, as it's not compatible with XDP.

Anyway, I prefer this value to be always true. No matter if it's really 
used or not.
Probably rename the field name to indicate this?
Something like: single_frame_sz / first_frame_sz ?

>   		rq->wqe.frags =
>   			kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
>   					(wq_sz << rq->wqe.info.log_num_frags)),
> 
> 

Thanks,
Tariq
