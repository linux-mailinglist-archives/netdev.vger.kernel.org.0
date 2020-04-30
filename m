Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC7D11C03A6
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:12:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726421AbgD3RM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:12:26 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:65155
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725844AbgD3RMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:12:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eZaQ3D1ccpIwm/mNTK1KuQnm/H6ovaqD+6Xbn5+4OAYCFJd/XRkV1H4bEWDyn591vISnWPjbFufeA8gjoyiSRlEtt/TYisFAR/7eoDjzxuF7lP3iADw6YLofGIauQLqU3LgZUDeIqVXmsCuNJacqMS862ety9p8DSBFzEYevXG3oGjDlvIHhrfwqLltUkSyUZiBBqs8coL4RUqMwZqgF/aCNSREahi8gnP8w6ReZ26K1uUmr48K9sQvUhcyX1395Mqd5ruviPSrV1sBjsfsaPhNWJJFyIrxD6Z1JsK/KHX0fsGKNVIPO65/wan3nBxeJzmLxRKcXixneEZG3RDU12A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8JBGErz1D0kF8wqkmihDSJAZoYYVBQ/SdjjbSaD5Fs=;
 b=IZaKjF2iu1cY4/rXHySAdgjea1XZXzTyjebmdx9/YgfdK0/T1pW6yM9ETNlqEg1f2/SO6jWIneuyBHZvcsN5S0ct8l9kKlatQ/dOOsXgTUL5Z1YOodHBVKWYeFVyD+cmXTqDv0CBJuSNtQQjJLBbkUT3Gsh+1nZkbV/EG09uyEoAMNnOfVDal5XwEaffgf0TdHKicWbJYqzDn8Chtz3BokyjoTOu7ijTxWm11fuPhd5rN6SdzAFdudosKQMOXvARp/QNRbIbmo2itIqvTIEz3UxJk3U9uhNhTxQxpfEKBXobLie+0F8MaVALWyU2Y8vm9RP1EGnAFgDSi5pXpvUKMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8JBGErz1D0kF8wqkmihDSJAZoYYVBQ/SdjjbSaD5Fs=;
 b=pmGfeM+wLhauoRnHgA5uM6L8rH4GGOTl/vk7E6emGA8vQW/33zVfVIn4oPmSAbiVp+lJFgv2eq0yLFZYq5CswEBhvHOFLHEaVDODmDzECSx4azcNJutik56ioMSF85rrK+Zv0uuxW9NZencVVrWFY+JS+3X1Lv90kHuBsGElPCA=
Authentication-Results: secunet.com; dkim=none (message not signed)
 header.d=none;secunet.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR0501MB2655.eurprd05.prod.outlook.com
 (2603:10a6:800:a4::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Thu, 30 Apr
 2020 17:12:17 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e%3]) with mapi id 15.20.2958.020; Thu, 30 Apr 2020
 17:12:17 +0000
Subject: Re: [PATCH net-next v2 28/33] mlx5: rx queue setup time determine
 frame_sz for XDP
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
        Lorenzo Bianconi <lorenzo@kernel.org>,
        steffen.klassert@secunet.com
References: <158824557985.2172139.4173570969543904434.stgit@firesoul>
 <158824576377.2172139.12065840702900641458.stgit@firesoul>
 <a5be329e-39e3-fdfc-500d-383953546d40@mellanox.com>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <7e391f37-0db7-c034-cb97-2e8bf60fd33f@mellanox.com>
Date:   Thu, 30 Apr 2020 20:12:11 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <a5be329e-39e3-fdfc-500d-383953546d40@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::16) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.125.37.56) by AM0PR10CA0036.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 17:12:14 +0000
X-Originating-IP: [77.125.37.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b7f48ac4-2823-4b06-b380-08d7ed29a2a8
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2655:|VI1PR0501MB2655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB265581162139773BBD76B355AEAA0@VI1PR0501MB2655.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0389EDA07F
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(376002)(136003)(39860400002)(396003)(316002)(186003)(478600001)(7416002)(2616005)(956004)(31686004)(6666004)(2906002)(5660300002)(16576012)(54906003)(26005)(31696002)(4326008)(8936002)(86362001)(8676002)(6486002)(16526019)(53546011)(52116002)(36756003)(66476007)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZsRnLESng1hFhwUGXlX1qF5Qg0Oe83OWuvu+gho1SKPiuKaZ1wdA4QHb53C0CCuWbpgGsVfvKdCMToEbSNm4JDQerC4XBY2PLmiBhQXLGQcVKxn6SYB1PfNzgy1R5VAHxBSljDXXP18e9Gvun7NJXwz3KZ7Js5m0aEZuCeR1bEfWWbF7nuRmWeShY3x6RQndoL2YxFH0c2ByxuADER4ePqGwtCfRapr/GsycZ356iamKxSY6CzfQape6KWLC/FcsXl9d15ze20ZNMIJg8Zdi98CXVvizE05s+n5+Bzq860ILF59BzbUTkYJxRdNYUkyR3Ajxvh03Wqc0JRaqY0mFose+h/t7I/G47fojXOcEd91UzmMKo+h6ZoACWbG6lexCmiMyaZ5XKIAmAqj420QMfTTIB1ZTlZRlhviJWXXRyJyl8mNuZ2iZg3q3Dv3DRm5C
X-MS-Exchange-AntiSpam-MessageData: +FGZM71LtnjgTtHn2uFAQpqrvWr2uI8FmCj0W1XkyWoyJj7dgQmdTBI4ywiGTtQ8YqIzXChTH1foa3Ito+57LAJt57HBDOjRleIHtdC+ycOwdPApGPL+54ao96GtehZVBDMpGgVRNIvsU6WAvuRgUReOfJgGRFEI1d44jdOQBi8ptmXTfzLBvJy32KKYHKLwt2/EbgQ4tXOSzIqR1VAE475MvCpbWPBerwBtCnHjVY2VETRTesktddRRREhVCloUNCynbgwRMNH4aa0nfEw0RbDvojfBZRBYBp6YMEWEl2m5aYfMSbJe6YeVoTdmYZf5UNdJIiXuVQakrsA+2JRyq17YtPw/zlXp9vIq/NFqafovNbX9IdIBULBzbMbR38GxiM7p42Tblvq8XZEsjNBo8/NUW8h7xWA6exGe0t93Bjruy0YvtYMGGCpZa/qBOc2lml7u5Ujwo5hUzf0ghhB83iWWaVFNrnTDH1PQEHKCXTAPnNx2W5WBkZipbQ+v/wiE73gm63FlsXI0PChKFdMIqTO3GT3NG0ALT6XQlcbp5YURnsKgYTe9+P2w3CAnpyHxNc11SKpUUqpJ4FSBK6vhQPnEsuefyR+/KWMc9B5xT+p91VnSB/w/ERr+e6l9UwWjUKZXPlW9bg8pnGsuAL2BRnE9b91Ih/Ybc2G2HSYIGmiViLcjbMlzSrwY9VZRWsuiRHvrQTRetK3rXaY6h8Ohh+yy1WYCUoAZ4HqUHzh5azwo36uX/bxfowCQJZ1mhFiCQwvEx01Fki5J/ti+IdEQvSIETIITbiimholsS5FxJoY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b7f48ac4-2823-4b06-b380-08d7ed29a2a8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:12:17.6660
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yi9vaRokMBpkF7I/Fy6i0vso7Upgwp0fMtWMc8dAZyNFU5LwUtT+nzQKrqxAxYWYmTNBgvGXhF5Obn4A5xcYtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/30/2020 8:07 PM, Tariq Toukan wrote:
> 
> 
> On 4/30/2020 2:22 PM, Jesper Dangaard Brouer wrote:
>> The mlx5 driver have multiple memory models, which are also changed
>> according to whether a XDP bpf_prog is attached.
>>
>> The 'rx_striding_rq' setting is adjusted via ethtool priv-flags e.g.:
>>   # ethtool --set-priv-flags mlx5p2 rx_striding_rq off
>>
>> On the general case with 4K page_size and regular MTU packet, then
>> the frame_sz is 2048 and 4096 when XDP is enabled, in both modes.
>>
>> The info on the given frame size is stored differently depending on the
>> RQ-mode and encoded in a union in struct mlx5e_rq union wqe/mpwqe.
>> In rx striding mode rq->mpwqe.log_stride_sz is either 11 or 12, which
>> corresponds to 2048 or 4096 (MLX5_WQ_TYPE_LINKED_LIST_STRIDING_RQ).
>> In non-striding mode (MLX5_WQ_TYPE_CYCLIC) the frag_stride is stored
>> in rq->wqe.info.arr[0].frag_stride, for the first fragment, which is
>> what the XDP case cares about.
>>
>> To reduce effect on fast-path, this patch determine the frame_sz at
>> setup time, to avoid determining the memory model runtime. Variable
>> is named first_frame_sz to make it clear that this is only the frame
>> size of the first fragment.
>>
>> This mlx5 driver does a DMA-sync on XDP_TX action, but grow is safe
>> as it have done a DMA-map on the entire PAGE_SIZE. The driver also
>> already does a XDP length check against sq->hw_mtu on the possible
>> XDP xmit paths mlx5e_xmit_xdp_frame() + mlx5e_xmit_xdp_frame_mpwqe().
>>
>> V2: Fix that frag_size need to be recalc before creating SKB.
>>
>> Cc: Tariq Toukan <tariqt@mellanox.com>
>> Cc: Saeed Mahameed <saeedm@mellanox.com>
>> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> ---
>>   drivers/net/ethernet/mellanox/mlx5/core/en.h      |    1 +
>>   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c  |    1 +
>>   drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    6 ++++++
>>   drivers/net/ethernet/mellanox/mlx5/core/en_rx.c   |    2 ++
>>   4 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h 
>> b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> index 23701c0e36ec..ba6a0ee297c6 100644
>> --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> @@ -652,6 +652,7 @@ struct mlx5e_rq {
>>       struct {
>>           u16            umem_headroom;
>>           u16            headroom;
>> +        u32            first_frame_sz;

I also think that a better name would be: frame0_sz, or frag0_sz.

Thanks.
