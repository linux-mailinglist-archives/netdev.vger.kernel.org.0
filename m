Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76F221A31BE
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 11:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726597AbgDIJ2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 05:28:14 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:30305
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725783AbgDIJ2O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 05:28:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6tvC4XJbQIp65ZBceS1UxET9fL2iMOH0C5SBBN7S1zUzdXsW03JaimYRc94ZHFPIn2zZkjSc22w3bt7N8AuRYFEM6KmpIIlCtAHwj7lI+yG4dIXFO6P8RPUdP8r2K9LSRj40doUn8d0U47ihJzOrXVMVWwNObkZJLa8URdXeyH6XLFifsFcrDa8TZkaqwmhjbQao4W21qOYmdGjrrgVdOfsq9C1fUI2j72xYrYwp6fD73p7iZN82mCw2fFou8fSPIALPZMryxL0cQrVR2Sfat/LzR3v3PTBE9Q82B+1kFEHgToZP8KrYI/oBLq7W3eC2+Mdpp/EDQkJMpCb3DbmWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ka3MCJ0Q8ghwC8mc8Mv8xVAlzkJPJey/LE650jXsW2A=;
 b=Dm+4T42dufRMMQzkbvM410ai4NzRS2TbjWTS8CPeoj0j8RYeHY9pS/yiv81zQOnWrSEj0OrKN+Cu9j0E5TqpONHRBpuyt7QH8ke3duP/cOtT5ZjKFulB1ZcCMMriuGvKfc07PAhIEGiwJzEbPPvN58mB5M29D9lpkoL3ASWRiP7muux7XYarPf3zyjU5Y9OD9gxQgYM/G7LRH4KRM6zOVHH0VDBPb8Ce//IM6/6hsliX6e4zDqptofkqTmt05/d/9IVWFrSRCdryt87MpMG5RmaOWcmMrRpJQUZTVUMeZSKIwKljdpzqWJaWceZGOKjMeml+CpbRbgp32tEQTN6h6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ka3MCJ0Q8ghwC8mc8Mv8xVAlzkJPJey/LE650jXsW2A=;
 b=LcJxi6WBfOXabyYBTGrQIOPVwvA19SHwJG1tBPou+Rhj8b+of+m3CWd+q0pJ7f9ZrRM5ZmL8kGWTkuop8Ps2MQoaL+QqjN1jyHDKBdOyhKztMVnieMCaYmNSH4ocTfbItbGhwGCUttS5DQK69ixFwPc+XdaGV7aTwAcEzH1whFs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=maximmi@mellanox.com; 
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com (2603:10a6:3:6c::17)
 by HE1PR0501MB2265.eurprd05.prod.outlook.com (2603:10a6:3:27::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.15; Thu, 9 Apr
 2020 09:28:10 +0000
Received: from HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc]) by HE1PR0501MB2570.eurprd05.prod.outlook.com
 ([fe80::60c4:f0b4:dc7b:c7fc%10]) with mapi id 15.20.2878.021; Thu, 9 Apr 2020
 09:28:10 +0000
Subject: Re: [PATCH RFC v2 17/33] mlx5: rx queue setup time determine frame_sz
 for XDP
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
        Lorenzo Bianconi <lorenzo@kernel.org>
References: <158634658714.707275.7903484085370879864.stgit@firesoul>
 <158634672069.707275.13343795980982759611.stgit@firesoul>
From:   Maxim Mikityanskiy <maximmi@mellanox.com>
Message-ID: <d6027a51-af77-d7a0-3b08-4b9aa36294dd@mellanox.com>
Date:   Thu, 9 Apr 2020 12:28:05 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <158634672069.707275.13343795980982759611.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::27) To HE1PR0501MB2570.eurprd05.prod.outlook.com
 (2603:10a6:3:6c::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.57.1.235] (159.224.90.213) by FR2P281CA0017.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:a::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.16 via Frontend Transport; Thu, 9 Apr 2020 09:28:08 +0000
X-Originating-IP: [159.224.90.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fcf467b2-5ca0-4c06-b470-08d7dc685167
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2265:|HE1PR0501MB2265:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB2265AED11CFD7671193ADF90D1C10@HE1PR0501MB2265.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0368E78B5B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0501MB2570.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(366004)(136003)(376002)(346002)(39860400002)(316002)(5660300002)(6486002)(2906002)(16576012)(55236004)(7416002)(36756003)(8936002)(81156014)(66476007)(6666004)(66556008)(53546011)(66946007)(31686004)(52116002)(54906003)(478600001)(4326008)(86362001)(186003)(26005)(956004)(8676002)(31696002)(16526019)(81166007)(2616005)(6606295002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mNTRAJKiYFNEP7Wo5Vx2aNWwY/7wSuxX6n2JcxhqqqOpO0EXi8y7y8KQ9pS7LCYKvhU9mPx9VC63yWe0/G8vSeP0b0WlvN4QVEUlx6dN6gW7yfRnyytI6lg+yUAglmWmNS5SY2HqmBilijkesbAxMt0eaQBvudIjmyDNC8u7xnTVU/L2TV7TTwNzKXNYAoEnyuvvOQhDhTIM1nmNWjNAF3lNqzbIp2k3EqBp93TasSgcsX9J8Z15bkxmq3VBREumGIVCx9AN5QI1JqyUBNCYewoKkioVhBuV53Q7HIKbALmNjUA+pYBkZ6FyWyqZzQYhSiZn2P9kcBFBVgQd83M+dU9PbrneB7XLIhujWvdnRWPOqYlLmj7nwM+Bce1aIbyy9lZ6RmgwiiBSA31jnAWdY8miFq0oAmJTPLqSYUyxjr12OeabMCrOSOmqYp//ThluefCDZEpF183vVQrsqot8k3yhvzgvvjuM89aZKq3PKlEN4VTDIrrShA2acmYt1DF0
X-MS-Exchange-AntiSpam-MessageData: foojCpKRIxAL2PBspFtowRd6K2pFHzQGXlgJ3j5DPaFe3v61CRlv17oYdHUCbTkX7Y6SvVonDJatC/rz1drNZ/undPsoI/KvVjUWwIOntMWBdd+btqZ8TaE48vaMrSB+s4Q7VOErJ/sXV2kMMFdRuw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcf467b2-5ca0-4c06-b470-08d7dc685167
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Apr 2020 09:28:09.9083
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4oOkV9TMDngV4WCQYmMOR9FgU97HX+LtfPc4m8h32Rw8idhajQmHRzOznWFiKmCsTHlL9CzqgxN4Pgjc0aFceA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2265
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-04-08 14:52, Jesper Dangaard Brouer wrote:
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

I think it won't be correct from AF_XDP perspective in case unaligned 
chunks are in use. As I see by the patches for Intel's drivers, 
xdp.frame_sz is set to chunk_size_nohr + headroom, which is not always a 
power of two.

Moreover, it won't be correct for standard (aligned to a power of two) 
chunks either, because mlx5e_rx_get_linear_frag_sz always rounds up to 
PAGE_SIZE in case of XDP (this usage of striding RQ is somewhat hackish 
when it comes to AF_XDP), so we will end up with frame_sz == PAGE_SIZE.

So, I think we just need to use `xsk->chunk_size` here for frame_sz. The 
same for non-striding RQ.

> +
>   		err = mlx5e_create_rq_umr_mkey(mdev, rq);
>   		if (err)
>   			goto err_rq_wq_destroy;
> @@ -485,6 +487,8 @@ static int mlx5e_alloc_rq(struct mlx5e_channel *c,
>   			num_xsk_frames = wq_sz << rq->wqe.info.log_num_frags;
>   
>   		rq->wqe.info = rqp->frags_info;
> +		rq->buff.frame_sz = rq->wqe.info.arr[0].frag_stride;
> +
>   		rq->wqe.frags =
>   			kvzalloc_node(array_size(sizeof(*rq->wqe.frags),
>   					(wq_sz << rq->wqe.info.log_num_frags)),
> 
> 

