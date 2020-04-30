Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5481C0399
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726544AbgD3RH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:07:56 -0400
Received: from mail-eopbgr60066.outbound.protection.outlook.com ([40.107.6.66]:41539
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726272AbgD3RH4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:07:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TkDbxgkkjLf9V92aLWy/+u8SunJP7qKd8DqrwSEBdjo/qmOOBcjyvXcKSEnaqMJ2XSwa2+0gUDovQU/pkbSonuHW1idi9oh5A3sFDoT31GOpz4VLAjiDBzwbM827G4On0VnmelgKMTO/F8EKjVoAIkiWt3IvmUAOb0yK8T5fJVyeNj5Co7dAML6qokQSZQgGkxaxH2Q9BJ8JvvcyQ4PLaE+08Iw9kJleA/8v7xwEqEvczAh4DvY9AWf1MlWn6poTK04vtnieuIxJMJ2tqvURXijj/NrbHesAzCC5X31jE2mu7TDpK5iTm00XnriBqHuX0zzrT/HbYVmUjVNzwdTxJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRN31g/1fXGehewBlu59N6tBu9nPC10evAzWvue5U1E=;
 b=C1Onxq/opmCr6E/+UAFM3Ho5XfEbzwCiytjzl6uL8ctP4bvxMigRNm3tTNLjt+8cSN5ITt9MrwNG5lVAGYkul5lbB56uAR2RG4b11Jl7SJQZPbZlOeL+W1CwSe1DHKpInD9pCSb9WBqWsEAqsTA4w4hJ/Gsy2iEUzEH8GUD6xR9yLH3utnYjwpSpkS3RdGLrhYFWrEcJ1mxT8IGH8t9gizWYbwLFAhZVB9YwpqMWg+BAKEFhEQxt0MyPuxdYfpZczBFU+7zM7H0Mn5vVx0a63qNIHh3Y/eAhnIecSUWotkjBPLuuSxcX311h3z88WhqDEHNNblKOHHI9PFjZo8vEAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gRN31g/1fXGehewBlu59N6tBu9nPC10evAzWvue5U1E=;
 b=s3Bc4DESQPV3ak8BT/twgiW9St3cD3bsdExhojqQPVRY7Fm7yyGZFRLTjkT6mJSIhtCjRYZFryGy0ww4rYTEhwObdfMGujiBUB4YX9UjzRBmCFEHNq5J/wNWtL+QCFPwFnJDSpr0mSpv3+MX7MmqhdS/MC7SNASdhEo5P/duIbw=
Authentication-Results: secunet.com; dkim=none (message not signed)
 header.d=none;secunet.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR0501MB2605.eurprd05.prod.outlook.com
 (2603:10a6:800:6b::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 17:07:50 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e%3]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 17:07:50 +0000
Subject: Re: [PATCH net-next v2 28/33] mlx5: rx queue setup time determine
 frame_sz for XDP
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>, netdev@vger.kernel.org,
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
        Lorenzo Bianconi <lorenzo@kernel.org>,
        steffen.klassert@secunet.com
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
 <158824576377.2172139.12065840702900641458.stgit@firesoul>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <a5be329e-39e3-fdfc-500d-383953546d40@mellanox.com>
Date:   Thu, 30 Apr 2020 20:07:43 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <158824576377.2172139.12065840702900641458.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0026.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::39) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.125.37.56) by AM0PR02CA0026.eurprd02.prod.outlook.com (2603:10a6:208:3e::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Thu, 30 Apr 2020 17:07:47 +0000
X-Originating-IP: [77.125.37.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 386ffc05-968c-4d49-7c53-08d7ed290322
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2605:|VI1PR0501MB2605:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2605E1E2943BF7B503D2E99EAEAA0@VI1PR0501MB2605.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d/e6TENH2RUT7tI7ssGm+OoricXP0Rrc6u4VkFd8wuCVlOdxVLQS8mEhHUuwClKiiQ7sxwyG+6g1d6qrpAst8hkbM+WXrtXIpnzbGRwNqvj2l9ERlbR67gVW1bB4h6fI3Xw2bJ+mW/5bNSQAk64FKBNEIwjVoq6cFIfaJS9mJMxRfX64coPRqcJCtffA5mqPIQgkn0nUCMvLkws5fdL1Mu16RI9uBIfgIQhnpPLP6D93nf0q3k45z8KHxFQtloe1AElmg9+iSe34FAEEJEwvORIxr8QYx1emSDlrGsR6UIf5WzVdXPi5R7cuq9rYMOt2cNhC+vUoCt6SQBCr/bYUUFMVvXgnNf6xxG83FLz4dHWWQsuW+/oGxu6LgmyEk/7DPWWrkHXWOdsifVtV8erom0S6armmzhbsbZjxSqkA+XcDdI1BXmWzcbmRldOkRB3oq9H6BZsmK7PeUOznqJwEScC7e56qUb80Mf+4BdYOxMF1c/TlBxrZ7EVEjd61svzs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(66476007)(8676002)(2616005)(52116002)(186003)(16526019)(5660300002)(86362001)(66556008)(7416002)(66946007)(26005)(53546011)(31696002)(956004)(31686004)(16576012)(36756003)(2906002)(54906003)(8936002)(6486002)(4326008)(498600001)(6666004)(6606295002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: tyN5kbTiylvFL1sHpevdwvbX4lDyQQ/sql5MhJ507gWb6za/IDCsg5BVP0mYHWdmKKFOYNV8tTTBSF+wUGEgigPnrYHBy5pRhzTdGjZ7j22RNd5J0BqY89SERNMblwQIPRNczq6X9Y6WpJXk414mOYRQCyhW/Im6IMNu7AkHUtEqjKjBiiuEIxSszL36s2Wou6W62KCelnHcic+MEoQsD82q079Rqq7z94nPfC5LuHBToU8ZT51NRnVJhOz+CI6iuhn0k162xaQEe/OfMuABTW+zj31Biam8CjJprX7YR8aqOlGBgDCeksHvIAKWGaKUuB//FVN9kTc64Ae9TqqVrQUNiwRkA+oUa1iP4f2hiG6OH1j+udJqqWpnabNtK8szf5HFvPdcNaPZg/7/sti+t2lRDATTHShCfQJiUhRWK7EYHCnA4JYs0Q8fKBiCdFnfTN0YGav9yUoHGG7qlcEvQR4Q6cYyemYKXU/Ti3AcG7cgAyt5K9wYsJ+pBP0PneeSR9M8j8BPhH3V2LhGKJM8AWE443+Oj7K9fyxAFmJuUzJvQ1B5GwxkN8FiMQS9K1edEfMKV5dytrBurYfhyIY4p4O66Kw/8GHkn5s0np8BZo0ZOTOwdd7P6QpjTBHhWxuL7b7k2UBAvhteNA5/moLRdalv49MgaVHh6xcwX1qZrLvk/NvqEef2jgiT0FCuPDFWMMl8QypC8cYEyqp+a+T0xwnUe3R0PGdB75wYXtRKonP7ZojjNyFCcSlXlDeEEch0++iW5zVzN/mAVp4/C3EZXmPhB/07JNmwfSRJFC/jMfM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 386ffc05-968c-4d49-7c53-08d7ed290322
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:07:50.1556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8jxAFxCXeip0KZvXjYr9GUZChSslceEN3rxenZQNKEVZVq3aEK68Hm3aa359gDIiYnmoba6O1f8SrlKJMOcLhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2605
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/2020 2:22 PM, Jesper Dangaard Brouer wrote:
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
> in rq->wqe.info.arr[0].frag_stride, for the first fragment, which is
> what the XDP case cares about.
> 
> To reduce effect on fast-path, this patch determine the frame_sz at
> setup time, to avoid determining the memory model runtime. Variable
> is named first_frame_sz to make it clear that this is only the frame
> size of the first fragment.
> 
> This mlx5 driver does a DMA-sync on XDP_TX action, but grow is safe
> as it have done a DMA-map on the entire PAGE_SIZE. The driver also
> already does a XDP length check against sq->hw_mtu on the possible
> XDP xmit paths mlx5e_xmit_xdp_frame() + mlx5e_xmit_xdp_frame_mpwqe().
> 
> V2: Fix that frag_size need to be recalc before creating SKB.
> 
> Cc: Tariq Toukan <tariqt@mellanox.com>
> Cc: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>   drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
>   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |    1 +
>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    6 ++++++
>   drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |    2 ++
>   4 files changed, 10 insertions(+)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> index 23701c0e36ec..ba6a0ee297c6 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
> @@ -652,6 +652,7 @@ struct mlx5e_rq {
>   	struct {
>   		u16            umem_headroom;
>   		u16            headroom;
> +		u32            first_frame_sz;
>   		u8             map_dir;   /* dma map direction */
>   	} buff;
>   
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index f049e0ac308a..b63abaf51253 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -137,6 +137,7 @@ bool mlx5e_xdp_handle(struct mlx5e_rq *rq, struct mlx5e_dma_info *di,
>   	if (xsk)
>   		xdp.handle = di->xsk.handle;
>   	xdp.rxq = &rq->xdp_rxq;
> +	xdp.frame_sz = rq->buff.first_frame_sz;
>   
>   	act = bpf_prog_run_xdp(prog, &xdp);
>   	if (xsk) {
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index 47396f1b02f4..1d04ed3feead 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -462,6 +462,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>   		rq->mpwqe.num_strides =
>   			BIT(mlx5e_mpwqe_get_log_num_strides(mdev, params, xsk));
>   
> +		rq->buff.first_frame_sz = (1 << rq->mpwqe.log_stride_sz);
> +
>   		err = mlx5e_create_rq_umr_mkey(mdev, rq);
>   		if (err)
>   			goto err_rq_wq_destroy;
> @@ -485,6 +487,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>   			num_xsk_frames = wq_sz << rq->wqe.info.log_num_frags;
>   
>   		rq->wqe.info = rqp->frags_info;
> +		rq->buff.first_frame_sz = rq->wqe.info.arr[0].frag_stride;
> +
>   		rq->wqe.frags =
>   			kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
>   					(wq_sz << rq->wqe.info.log_num_frags)),
> @@ -522,6 +526,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>   	}
>   
>   	if (xsk) {
> +		rq->buff.first_frame_sz = xsk_umem_xdp_frame_sz(umem);
> +
>   		err = mlx5e_xsk_resize_reuseq(umem, num_xsk_frames);
>   		if (unlikely(err)) {
>   			mlx5_core_err(mdev, "Unable to allocate the Reuse Ring for %u frames\n",
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> index e2beb89c1832..04671ed977a5 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
> @@ -1084,6 +1084,7 @@ mlx5e_skb_from_cqe_linear(struct mlx5e_rq *rq, struct mlx5_cqe64 *cqe,
>   	if (consumed)
>   		return NULL; /* page/packet was consumed by XDP */
>   
> +	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt);

This is a re-calculation of frag_size, using the exact same command used 
earlier in this function, but with a newer value of rx_headroom.
This wasn't part of the previous patchset. I understand the need.

However, this code repetition looks weird and non-optimal to me. I think 
we can come up with something better.

>   	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt);
>   	if (unlikely(!skb))
>   		return NULL;
> @@ -1385,6 +1386,7 @@ mlx5e_skb_from_cqe_mpwrq_linear(struct mlx5e_rq *rq, struct mlx5e_mpw_info *wi,
>   		return NULL; /* page/packet was consumed by XDP */
>   	}
>   
> +	frag_size = MLX5_SKB_FRAG_SZ(rx_headroom + cqe_bcnt32);

Same here.

>   	skb = mlx5e_build_linear_skb(rq, va, frag_size, rx_headroom, cqe_bcnt32);
>   	if (unlikely(!skb))
>   		return NULL;
> 
> 

My suggetion is:
Pass &frag_size to mlx5e_xdp_handle(), and update it within it, just 
next to the update of rx_headroom.
All the needed information is there: the new rx_headroom, and cqe_bcnt.

Thanks,
Tariq
