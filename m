Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709036DC829
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 17:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbjDJPES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 11:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbjDJPER (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 11:04:17 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2094.outbound.protection.outlook.com [40.107.94.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BD5D4ED7;
        Mon, 10 Apr 2023 08:04:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E/XQK7ETXfCqMpM8Z+FnrCIfHLWdKFnMfrXefP7Jg+7eSnxufU5I3dSZ4sPAlFww+l1Llxu8CVmuL9i24KXaAf6PAMc8X4LDDKPYWVy0LvE1mI9XwpVwqvMtrghkQh41jmP0qcxeBR2l63kbT1Jl7Qe4nlglCnPD/tkNAjc4xGr/mo7xsmEIZWxvLxjUKmM+L3DNOaRVtA+jzkXMjG1ig+rQT8R3h8dkYwZQRfhuevSqeJ3x9OM1KGPhdBF00QM+5FkrVX8ppo4z1RDGVMg3yodinIIAATJ5yJd0/8/KvyxcI3dIfw6bTK4bfIY1TjC2rQBMUd0F8inMCJG2L/sx4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JAGIl7nvNPVcGySoLYXf4St2BcnSUJWpQjhtmJqkrQM=;
 b=RQ3I6Hw2Dk/DV3xgHW2Em+AsT65UQgv5MdA0Y+H+fDEmZbJHi/R4pqkDTMfc8hLBuzsBmgv/1NrPHRL0vVJJ7lkpC6MaaecGng0okRKBD1uX5wWdJwdsg1vTMSN76prG8n6VdUPyIrmzAh6Gj87y0JHZPlp6HnlRmiWVWu4IWySkCmdhQ/LWy6zTp+B+wZP6FxmtcXAIllOhvzwXAxRO03xpFieKxDmhHOEZHTcPR88+fy5jHZIz9xeGA4vj5DRXjVtVAS/ZNNnGQNhZA2PaDjBDxx70Xba3VtA1DNIO1Z8wu7gBGaswz5lrjtn3f1wot8OrsQLXugByf24yxd54Lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JAGIl7nvNPVcGySoLYXf4St2BcnSUJWpQjhtmJqkrQM=;
 b=Aw63wT2keQMeMGi1Rv9fR+5W6BkExhJt+s1tuK5sexTtjiM0HT4qEt4byOtpjz49P1ydIbjnJRoIFPE2AlgEE3BU+WeGabinvdRweesxMrDWtoxDHrHW478Jk02Hyd8E9w8w0utpC3e1ff2S+Jei8TC3tvdQ/MiptHpWff42+zA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL0PR13MB4465.namprd13.prod.outlook.com (2603:10b6:208:1ca::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 15:04:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 15:04:11 +0000
Date:   Mon, 10 Apr 2023 17:04:02 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, Stanislav Fomichev <sdf@google.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH bpf V7 3/7] xdp: rss hash types representation
Message-ID: <ZDQlYqwmyG4Y73Vb@corigine.com>
References: <168098183268.96582.7852359418481981062.stgit@firesoul>
 <168098189148.96582.2939096178283411428.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <168098189148.96582.2939096178283411428.stgit@firesoul>
X-ClientProxiedBy: AS4P191CA0005.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d5::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL0PR13MB4465:EE_
X-MS-Office365-Filtering-Correlation-Id: de47092a-93f3-40f4-d405-08db39d4d734
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVtNoev8Bo4d0GkFT5DRw4jjkmYh8VWMGwbL8dGfB3ipaZt6EGRBc01nIjP+g5b4S8hGeXCftDESBz16uHNopWx6qIlOT7p0AxVKTKXrjl8wQv8+cZySYF5d0izuYV3+gVLmS/svnOZLJ75sDVkzlj8MMmL1ZfF+0n2yoEhrjnapqz/Xwsxl5AvbgaoDLGwY6rsJwpL076lBExj78lQhBayDnXsnzdzulq2N/x3b+k3y7ov9VgnH9bGh+pM7oAUuJ7yKYFYw+n8SAHb5djhcXinbmEVAxfwEVG16KSrJlfl7Ed2aENT5efZQUadTAjS2TJRTPFFj1yPzFITv2X5zuKxlg+D2FxaGpZE+VKcUG6IgaxHygT3EIYphcGD6QBYBsdMRLKv/cGPNs/BJBPvUS4d0IGDbSsl3E6pvCqbPlZgPOUwIUiRkwiJsy5BuATGWeygB2cpOIzqKXR5KMMiN0vSA1muJJm/xK6qD+WK/FlSpyGUuJIGPz4QfmP6nI3Y8iTk0rt4pteWRyIARaVSOK91wBxBG7hajxgYTJ2tjEPhjS5Q/jaoNBUvJkt7yebcN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(39830400003)(136003)(366004)(346002)(376002)(451199021)(478600001)(316002)(54906003)(6512007)(6506007)(186003)(6486002)(6666004)(2906002)(44832011)(66556008)(4326008)(66946007)(41300700001)(8936002)(6916009)(7416002)(5660300002)(66476007)(8676002)(38100700002)(86362001)(66574015)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OW90ZFlwa0pJNHN3NEtPOGU4dWRIY0tsV2RVMmZpcHpwMXYzYUZya1BacHdR?=
 =?utf-8?B?YU5zVHBYcXE2NnZwb01OTC9qdEpUNngzeXVRRzErc3dtd0U5YS9qdlFkUjV2?=
 =?utf-8?B?M2pOa3hueFpzbnJPeWxTR1Bod2drYndxWExpaDRQYU0vVkM4VzlhaVBSdmhZ?=
 =?utf-8?B?T1JjUDFjaWJBMlJhem00YnZhOU1lWG9tNmJvWUZVZHRhdkxJNzcwRjg2bFRk?=
 =?utf-8?B?NDBKb2xZZVVKc3lVaUxhaXpmdGlmZGRneUFzK0w3cUJHYWVpQ05TZ1MzSnVN?=
 =?utf-8?B?R3l3TTdHQzByQ0dZVmFnRVBrc1VLR3NXemU0ZHZWL1p4NjkyczhXbXpKVE91?=
 =?utf-8?B?Rk1LTEtHWHhLQkdsNEZsK1ZyRFdKZ0I1aUtSMHhQM2w0MHU1SmJ2ajNyTGMz?=
 =?utf-8?B?Qk5jWGtXTHNmQUx5RklCclVsNGV4eitTMWR3SkpQMFZqUlU0SWhWY24rd21G?=
 =?utf-8?B?MFpzRjB5U0dBZ3hKRHRDQ3BwVEYxcHFSRGdWSG5iQm9PbnpJSFJBaHEwV3F3?=
 =?utf-8?B?ZU9sVUxJSjAxSnA5bnE5aEJQUk43NzRwQkFMV2wzZWRzUy9udmR2UzBYSHBr?=
 =?utf-8?B?T0tDUzNPazBLaXoyYy9scm1iV1cxR29FYm81SzJ6dU5uRi9rc3JqT2NGdm5q?=
 =?utf-8?B?MWxyVDM4M2d4Tzkrc2tLNDVFZzFHQ055NVpuSHRVeWV5R2NZVFJBLytDTGY4?=
 =?utf-8?B?NmRFeGtvNHFaS2ptK2FOOVJlRDV0ejJVMFZrbXI5NEJvd1lqTUNoQ1FoVnhZ?=
 =?utf-8?B?eWdIN200VGRERG1rUmR2eUh4MEhtdGNkNE0rYWsrazRoMHVMQzF3U3NRTDRI?=
 =?utf-8?B?V29XL1o1MjFtSEdSdXJHck54NDhodU4zR3UvSFh4RHZBMVJDRGhtczB5MmdD?=
 =?utf-8?B?OGFpU05xZUtQRjNIYWF4V2ZjMzFGb3llUVZIbzkweE53MHNHNjdIWkdqRUk5?=
 =?utf-8?B?SFIwS29PMkpxcHF5L0doUlVsd3NZZ0ZxK210MWFyK3Q1ZWFzOEkzWXBVajBl?=
 =?utf-8?B?OFIvMjdQWlhuMzVFMzgybVFDMElXTHRDUFphRzZUa2UxZG9QT2w2K3hKTjlH?=
 =?utf-8?B?YWhmTzUyNmpQRCtmcFpLUHZBK0NwNk9GTWhLcFJrbTBiTkR1V2lXWkI3VHpl?=
 =?utf-8?B?cTBXMlpoeExLaHg5NFZYSjV0K3ZXa09TZ3QxNmQwcGZ3VGVWOEZ4Q09YMFU4?=
 =?utf-8?B?V2xYS010ZFhQT1ZhTEU4eVpxUlRJRjNzd2ErTkc4NHFobk9OUWpkVXBRNG5R?=
 =?utf-8?B?WjN2Q2lCSmltL2xEbnJSVnNzaGtzQys3RmpWclJwV0VMSFNaemFCQlBLdVhX?=
 =?utf-8?B?ZVBWVkZxSDZDTzRWRDdiRS8rOHZBQ0sxSk5hL2s4eHk2c0NhY28vQklLQXRR?=
 =?utf-8?B?a01LTDVhZTJNRW5KUkxINi94c1FwaEhQbmpVN3kvODl5czVNdnIxUnhyWWVQ?=
 =?utf-8?B?azNqTHFWY2FPYVNQbjU2R1F0dENsY0NYVXlzYW9RajcrMFRyLzgvWnU0WDZu?=
 =?utf-8?B?cGxLU2FTcFRDU1o3YUNYYU9WQm4zL3dTclNDazNET0RSNFR2d3pwMTc4Ujl4?=
 =?utf-8?B?Z2RLNU5NY0ZEM1RPaTVOWWR6R09Rek9SdlV0U1VpQUxwYkhOT3BJb3ZOcEtt?=
 =?utf-8?B?bGd6cWhmMkpyVUtMMHdCSFk0L3RUajN5ODRIUVlhRWUvUVUrallrS3BNZnJh?=
 =?utf-8?B?OUthc05DM0QrK3JscVV6M2lzc0tNeXY0U2xCSWpXNi9DS1cvVENjRDFmWU9H?=
 =?utf-8?B?NHFJdlNBOUN4aXFkNFY0S0dTSm9oeENYdmVic3IzVDUvMVNrMjN1VnhPSWda?=
 =?utf-8?B?UG1CZHU2dFRsM3RGNHRUU0FOanhzdHlaeUY5OTRUQWkzOFBBMUlFWTlhNkg3?=
 =?utf-8?B?SGh3WUZkSWZOUjJoSHNVZGVTVHBWT3RGQXc2ZENMVTNoNGRBLzNMbFhCK3FL?=
 =?utf-8?B?ZUY4eFZkdER3K0RzcUR4Y2xGKzhNcnF3bnVqNGtveTA5L2RKZGM2RWxtNTMy?=
 =?utf-8?B?b1g4QmhFaUhrc1JJa3dvdmpjeXZoaGJCSzM1S2FKVno0V0xEZU5xdjFpUExJ?=
 =?utf-8?B?ajdiOC9ObmVCZXVLVmZXVWcrVWc4dHJWTnIvWkk5TUZJd3RtU3l2Mjhoc3g0?=
 =?utf-8?B?ZG1VMkR1K3p1VGZnSk15d0t0YXVUUzJpL3pDckt6dmVJdG9QZjFxdk52cFJp?=
 =?utf-8?B?b3R2MXkzYy9FRXRVMlNnaWkvRm9kVFhmdjY3T2hXNXl1YlFmVUhzRGNqVDJs?=
 =?utf-8?B?QW1XNUwvbzlHVVdwMXZjVkdrNDhRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de47092a-93f3-40f4-d405-08db39d4d734
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 15:04:11.1360
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PmGUtmvQ9wCtYQJ0ahe0YRLC1nli70LY+IASYpY3ZMa0/VwJ0VXC6Fh41UYNHYo6MZIiWwEgF9M2eq3Au1Bdatt5upgManNeyyKZpKmV9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR13MB4465
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 09:24:51PM +0200, Jesper Dangaard Brouer wrote:
> The RSS hash type specifies what portion of packet data NIC hardware used
> when calculating RSS hash value. The RSS types are focused on Internet
> traffic protocols at OSI layers L3 and L4. L2 (e.g. ARP) often get hash
> value zero and no RSS type. For L3 focused on IPv4 vs. IPv6, and L4
> primarily TCP vs UDP, but some hardware supports SCTP.
> 
> Hardware RSS types are differently encoded for each hardware NIC. Most
> hardware represent RSS hash type as a number. Determining L3 vs L4 often
> requires a mapping table as there often isn't a pattern or sorting
> according to ISO layer.
> 
> The patch introduce a XDP RSS hash type (enum xdp_rss_hash_type) that
> contain combinations to be used by drivers, which gets build up with bits
> from enum xdp_rss_type_bits. Both enum xdp_rss_type_bits and
> xdp_rss_hash_type get exposed to BPF via BTF, and it is up to the
> BPF-programmer to match using these defines.
> 
> This proposal change the kfunc API bpf_xdp_metadata_rx_hash() adding
> a pointer value argument for provide the RSS hash type.
> 
> Change function signature for all xmo_rx_hash calls in drivers to make it
> compile. The RSS type implementations for each driver comes as separate
> patches.
> 
> Fixes: 3d76a4d3d4e5 ("bpf: XDP metadata RX kfuncs")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Stanislav Fomichev <sdf@google.com>
> ---
>  drivers/net/ethernet/mellanox/mlx4/en_rx.c       |    3 +
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |    3 +
>  drivers/net/veth.c                               |    3 +
>  include/linux/netdevice.h                        |    3 +
>  include/net/xdp.h                                |   45 ++++++++++++++++++++++
>  net/core/xdp.c                                   |   10 ++++-
>  6 files changed, 62 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> index 4b5e459b6d49..73d10aa4c503 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
> @@ -681,7 +681,8 @@ int mlx4_en_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>  	return 0;
>  }
>  
> -int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash)
> +int mlx4_en_xdp_rx_hash(const struct xdp_md *ctx, u32 *hash,
> +			enum xdp_rss_hash_type *rss_type)
>  {
>  	struct mlx4_en_xdp_buff *_ctx = (void *)ctx;
>  

Hi Jesper,

I think you also need to update the declaration of mlx4_en_xdp_rx_hash()
in mlx4_en.h.

...
