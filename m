Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1F71CC752
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 08:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgEJGby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 02:31:54 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:4267
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726080AbgEJGby (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 02:31:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i1BFWs5wTKZ+/3lK/fShTIMOhEpXFXbUcmCwzxgnf/ac+jeYnaRWEB+WygrS1uTV4tsfA6H4xpwAYoYbOy4MJlzBX9jbNqqO5ju4X91E09K8LAXIVa3YHSgblLnriidLgLCyhArsu+gtQAKbEMMdpcI4u44dJYFk4xxnouoL4SwU5dY3fTMmel6UKFKKxhGH/sBDUVSwwN4SrrnbuDQo5Sprfay+NkzEnrl4p4BQQTe6fRqmPHJx6ykDTLuafH8ofP8beNfef3IJwwdY2fiqU4MzgIEPCIE0qOgqc3ILl4JZKvhnXWG5MENijWYhhg6qvhjVSfSGN4Xb2UrTrsA2ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FujBc0qRAIlYZaGuEeOtghYQn7BwXEzAqR3BwCirnJw=;
 b=gMmaMXRON1D8pOY5Sc7S0t0iXpcZ08MH0SNeQpsstmXFWmmxKtprXAJTIJ4DqnVgiN2+VFl39VvySGIrjdpsaRx7drNM9QQIUDvClqzOh7QS5RbtEhK714tpJkj47Jkca4K4aLIqcwYvka7bim8eNSY0a4GD3+UInB6TDotJ2ovlzkpBtmc5Nb1b5WaNvcMlGMIpU/3RN35WsTWJK8bohzl4fU+3Mg39fmDV7Tvy2z4aoqz/mx8s9sldbH1iABPRDtBb/tRZjY8RteoWF78GobH6TK8HNdw0+EEL6PrwU3h1RtzTwMcwsM9uEznHGo7hb/wt0QZ4v3I/hH+WjPnCyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FujBc0qRAIlYZaGuEeOtghYQn7BwXEzAqR3BwCirnJw=;
 b=c+X8S8o3byTQ83/fbmTY8MaRc+S1mtuLJRWiLmTlDsNejkwYIFLl61eBJxiAXIqJ6LumwHdWhO4Y/guROF4RaM9UdQJQawsjB1eKTldS+4XpMEgFK5CyToP27L1vgn0f2NyhPdbKq+24tEyhCy2cpgp5dXkhqSCF321/K99vdjc=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20) by VI1PR0501MB2624.eurprd05.prod.outlook.com
 (2603:10a6:800:9f::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Sun, 10 May
 2020 06:31:49 +0000
Received: from VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e]) by VI1PR0501MB2205.eurprd05.prod.outlook.com
 ([fe80::71d3:d6cf:eb7e:6a0e%3]) with mapi id 15.20.2979.033; Sun, 10 May 2020
 06:31:49 +0000
Subject: Re: [PATCH net-next v3 28/33] mlx5: rx queue setup time determine
 frame_sz for XDP
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
References: <158893607924.2321140.16117992313983615627.stgit@firesoul>
 <158893626831.2321140.8243471055668639661.stgit@firesoul>
From:   Tariq Toukan <tariqt@mellanox.com>
Message-ID: <b6d91551-76c9-7fe1-2bd7-a80a519cb4dd@mellanox.com>
Date:   Sun, 10 May 2020 09:31:41 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
In-Reply-To: <158893626831.2321140.8243471055668639661.stgit@firesoul>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM3PR03CA0065.eurprd03.prod.outlook.com
 (2603:10a6:207:5::23) To VI1PR0501MB2205.eurprd05.prod.outlook.com
 (2603:10a6:800:2a::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.110] (77.125.37.56) by AM3PR03CA0065.eurprd03.prod.outlook.com (2603:10a6:207:5::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.27 via Frontend Transport; Sun, 10 May 2020 06:31:47 +0000
X-Originating-IP: [77.125.37.56]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9f7fd38f-7d19-4829-3599-08d7f4abd1cb
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2624:|VI1PR0501MB2624:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2624161D3778E9F3BC23B32CAEA00@VI1PR0501MB2624.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 039975700A
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PdQ0+kBFDSMZZ/kjzhCgwKoVYSUDIjtrmE/WaLtB3a61wKUThRvOikB8qUzBBq9yHCEfoT1UcAaQIIIlE3fI7bBNB3NRxqz2FJ09kgeLlfBnCDRs8W1L/imc1izZw6er8qlHraitdLscLe8ChJvYvyxbQZDFnl760Q4w7QJibXZqtv/my0SRK+5jaUgDL1AJOaa10lNdumWtA9Y6ksOhu2/t+YYpKbGXy/I7GZ72cFeS4i+NL1yFWgSODRYalY7kvKmCa9JkGr9HPhc3Fa3Ebx01UXssiLeDQF1LYfNZu5jgsRLiKj6K7Uir0thaha4wCyhp2CUECCsqBGm1iwuLm1F8jSUtv/k9aR0rWjMH2fJNKeLCYqdxAVSeqYT1Pw+CX9+RTNSA4oVzSRdQp+mjFjm5MbXDJgtZb8k+otHxfl6dxNSJKBsyqLix9P8TmK1Ei3T46bGijowIUiO86qHW9X2EnIDGB64qcHJsYDdktWlw7Wg7DT/+JuF19JFvF6MlwzI42mCDkXu/jmp4sVUTVRtSEtjNtzJhdZOWc1t55cxAW/MwdCnhexIPBpcPW30o
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2205.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(346002)(39850400004)(376002)(396003)(33430700001)(66476007)(66556008)(5660300002)(107886003)(6666004)(4326008)(36756003)(54906003)(6486002)(8936002)(8676002)(16576012)(478600001)(66946007)(316002)(2906002)(2616005)(956004)(31696002)(53546011)(186003)(7416002)(16526019)(33440700001)(31686004)(52116002)(86362001)(26005)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: dnHy1AMlzBQxH5YKD9ntO5ZFkQg5rqT1FxnMB1CR4/fKL+7j/b/FU/pQsT+o14fROfm2XTKnDVWfPs3Ff5Makt3CH4j/7b8NHibRSUYYcxnYvCy69Ko//zrPnJeuuFg7Ofri0TQoX9DbX+6kg3444F6YKanxUQyMAVFs6fL8YkYH0AlLrkg4xGnEVQWEKlYd/a+S4WbTbTSE1X2uYVvoBUYpooF4cOqHCmqE37PK+2ah59/hCPVNIpRzxWRMLN9nSSBYaKeHW4jhLuitOM10rejv2MIOBEsvwM11RQubHzsQpO0jGf4TPmQFkTBsSic/yqg7rYJKHB6eLEbiLV96AE0epbkwiZSvP6eOX6wIqfE1r8GiqPpD6hLxCiAmkqB+W5v/fIToDCNdXGtLQgKDGTYEwGyvp5Ath+zjSMMitX8S+P8bUUrAmA2geg9byYjnZiI9f1b0CIc+IFL6kNxwPpcl71ZaFnaBRsWy5lAMXlE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9f7fd38f-7d19-4829-3599-08d7f4abd1cb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2020 06:31:49.5453
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CPYPN9Op1ssXfXYf5kzHEQI1llg71nE6HAFTdgciHJi1qIy4LWXkjUKkG8+1ElUds9wZUhtPy1+oaq3bwy43SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2624
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/8/2020 2:11 PM, Jesper Dangaard Brouer wrote:
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

Thanks Jesper.
Acked-by: Tariq Toukan <tariqt@mellanox.com>
