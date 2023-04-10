Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FDD6DC83A
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 17:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229936AbjDJPLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 11:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbjDJPLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 11:11:37 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2123.outbound.protection.outlook.com [40.107.244.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A5B45274;
        Mon, 10 Apr 2023 08:11:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k9O4P71yjEbMTnG17i8H9lYvcTYm0NG9fMCVfj1KinCsalhBiBBnTg1MN/1550kNSMmiIXCEVCUwLfyeRERUPIP8w2Xnzz58LIMb+G+9Y8sbF+E6kXhveBE/XXFJjWNMEHHN5v09rFsIekJ6OJl762vroOelbuGKRZmneEqYM6owmiAWR6e0I9KDQeAYWXGY9+ZLbcBeaKR5ySvUlPEMjWIkhEL8wlc+777k2P2N2j5WvcaoNqAN9TRFG1EuXGMq5C0G4aGmCAelkwt/HLXDhKlkZj6kl/YaQpgqqthUPMXQzPQzG5EHSmPv+/Y4wg7XwNXaJKQz/v22hkd7kx9yiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tM5LC/InXP9K3q9n9kTbZbZOYBJKBKmQTSqUkMH6RNc=;
 b=fbpJ3kOIqUDDjhqBoAr89hMYW+5rtb3mLoPAMbZ7hNhJ6N2SZVMsIa8DXIqgZXxJrqV7JtpgoB9QSaO+eyIcKmM2hc9MsifpLQkizJZH+RiNNc2GWAGBRz6Ope24TXWzraXqSHx7vR/TdUftV60eGeT0jAMpRavr0gYX6dJwD+15ySjCBzuS7OO+3R8JzmnFaAgSbyLsOrk7kbfY871d8E5ISHC0y06/CJ6v3KzehzdlpeVLPGc65xLmDIKCqfSaQLbv5fGEyt5V56OV0lf+4e8ryDbevgqG8eYdYEe/x9Hqdh4CcWGzWyIz+yUNoYA3kR4Exmzw4bTslshZf7T7mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tM5LC/InXP9K3q9n9kTbZbZOYBJKBKmQTSqUkMH6RNc=;
 b=Kk7c+mfcrmMHeN3H0IBaQ38GO7l50pnJFdfemysjcb7oZdVClct1efT2fPE65DznBBd8mEhb1LTDqmgcmqOni3jbWPzXcp8JzIHQpvJ81dzIXxFtbQoogoK+qFZBF7fz5Pnd7cc7mK4/tdoJiEIQJrmPwqusfbX+cETNo3aVkho=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5418.namprd13.prod.outlook.com (2603:10b6:806:231::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 15:11:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 15:11:28 +0000
Date:   Mon, 10 Apr 2023 17:11:18 +0200
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
Subject: Re: [PATCH bpf V7 4/7] mlx5: bpf_xdp_metadata_rx_hash add xdp rss
 hash type
Message-ID: <ZDQnFmZdESpF1BEz@corigine.com>
References: <168098183268.96582.7852359418481981062.stgit@firesoul>
 <168098189656.96582.16141211495116669329.stgit@firesoul>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <168098189656.96582.16141211495116669329.stgit@firesoul>
X-ClientProxiedBy: AS4P192CA0007.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::19) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5418:EE_
X-MS-Office365-Filtering-Correlation-Id: 62b44a2d-743a-46bf-1254-08db39d5db91
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RunBres9gOxjj913NA+uhG4cr0VmWjeTQBVUhoRAb/o5CKyWohJ/XdQFm+RgY7jCJbtC6cu0BVMNQc0rxKfGOiWV5kuk1WnphafxwDSMSDfku/Ucf0mC5r/JrLmeE/Nf7PnZV1N8dP695t6BroNWBhgHcjojSO+UnpSy88I3WuB3uyirTGvYTkKS4CqEH3irG+PGlQqXQkJmPorIgcTRyvwk5C42AxygQL47QBtibB//Pm+OHpfrK90GpJ+GmiEC2Yjun2eWDUBM1SUM4D7sCqf0HIOZciF+ByxPklrfYdWdVgsGqRkQerIaGTxQnBVIroGGB/clGMSDLm40CwBiCom4AUWigW3mdxBqlIar1zXeNTOIiOXdzhXlNQlQgMZmOgLLoTeH1ZfxhK6d8hDADfuz+4SMNxPxgdqtxvlIFMJEDueisGPtsSDgjxi1n4ef5p8ugQlqyaSJB6095WJrt6mR9TZm4PsRrPNaMCzdDmjENXt1jAJ3jQZeZqgCzFteKD8xKxtE0vY5XI3dMG2oNTVnNIPX8d3ECbV0GvmPIQA4JewB3+ieJBvJIzEOtP9L
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(366004)(136003)(376002)(39840400004)(451199021)(478600001)(316002)(54906003)(6512007)(6506007)(186003)(6486002)(6666004)(2906002)(44832011)(66556008)(4326008)(66946007)(41300700001)(8936002)(6916009)(7416002)(5660300002)(66476007)(8676002)(38100700002)(86362001)(66574015)(36756003)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjRpdE1kRElXZkVkRXMzS0kvai9NaTZEcm1xUTRCeVNVdXN2MEx2dzQ0Yk5q?=
 =?utf-8?B?S0FDMzR0TXBER3FlNU1EZjZ5Z3pPbmxVQjZVYmRUL1g4VFFrZzlmT1dtcm9Z?=
 =?utf-8?B?NzN6L3hOKzBVRGQwK2RRTGVqcnQzdzhtQ1dST3hFMDU1MlE1cHJhOG9ScVF4?=
 =?utf-8?B?T3MrQXVWT20zTG5qcDRHYXpqcFFGajRpa0VCUlRiTEV6S1ZxQ3Zna3BBZnd4?=
 =?utf-8?B?NjF5dlBQU3NOWXp2dDBCeHM5ME00NXU4ZitLMW1wRUwvMk44ankwZ0diLzJl?=
 =?utf-8?B?dmVVWFdkYVcwQ2xDQmkrenFJaVVXMUEwWUpIbVIvUXN1aWgxazVtNmxrSkhP?=
 =?utf-8?B?ZWI3WEl2Mkp6K1ZHS1Q5L0wrWlhUMUh0NjRXeTRSZkR1VER4cldYUEM4Lyt0?=
 =?utf-8?B?R1dqVXVnZHpJdWxWL1RMN3c5V1E3dndzR2tybDRyU3dLcVQ2SjBpTmtGUmZk?=
 =?utf-8?B?NU9lTlFqd0F5SGlXbHN2VHBHWkNKMDZPd3ltd00zUWJSNEM1Qy9tejFLNUlF?=
 =?utf-8?B?bFJwRVdhVGR1M1YrdGdMRGZiYzROVWNIUG00cWQ3RkFQR0Jub0dvK2dGbFAv?=
 =?utf-8?B?ejFPcng0ODk1NzRNdnlhM09JY1BjYnB2TEVQSHVFVmYyaEs0dyt3RWo0cHBB?=
 =?utf-8?B?Q0VmK3Nadlh4ODJ4d2ZFczNaQncyMW1UYnhzV3VocFpqRld3UTZmbnJZaHIw?=
 =?utf-8?B?S1JmSDIwMFlOT0ZUUGYwRmdBYll3anJHSCs2WTl0UXlRWEJPcXU2L1cvKzdZ?=
 =?utf-8?B?OEF6YlN6a0ZEeE85M05lSmVLY3FQTy9EZzdXa0JPSXVtR3crcm1oQlh2dk41?=
 =?utf-8?B?MllhMmhCdTc5cXZwb0lnQnFDVFNEQmF5SVVWK0U5aEF1WUdUNXoyUytBK01n?=
 =?utf-8?B?bGpEZDg4RlV3b2VmZ3Yya2ZrNHlpTVlVaThyUzRQR252eHh0YkVIRStta3lo?=
 =?utf-8?B?Vk5LMUYrZndDRmJzNnZtVGxFMU0yWG4zMmtKTFRmNkIyZ0FSZHR1MkUwdjJU?=
 =?utf-8?B?eElrcjlsUnlhcWVTRlVUdW11c1g4R2RMb2VKWXFQR1ptZlF4UDBzMys2T255?=
 =?utf-8?B?UVNxMGJPcUJER1dlb3RnZ0I0YngwM0FVaS9LMTc4eFlIUktYMUpqTG1NOTBr?=
 =?utf-8?B?VWNQOEEvNVplVHJwVDRDSm54Szd2eEo3L2JpbHY1d0MwUmtVQzhZZ3hBOUNm?=
 =?utf-8?B?bk5MU2lJQTVVL1hXemRCVXdxbzlWSStEOUdLTUpCRXBSTnFQVEVzalc0UkhI?=
 =?utf-8?B?ZmNCRFdyblRlRHNrWEZwdHp2WjhUQi92cXloVE85eU5iZVJVTEpVVFZDeUR2?=
 =?utf-8?B?TGdoUDFtZ2xSdDlPSmRkNVM5a1dSZkhXRGwvZG5rcWdiVXdTZlMrMGNtak0z?=
 =?utf-8?B?dWU4Q0F4U1hGSGtWZ0lQcGJjY292TFAvZDRub3Z3SWl6MUV5MERxK3lNdlc3?=
 =?utf-8?B?VlpKcW9Zc3pBY0p1WGFlaC9pOEc2RUw0VFVNS3JSK3lsVFFXV1ZPZldTaU04?=
 =?utf-8?B?b1NCOFVkZmNsaDdoWFJmMktSRmx6RTM1RGlpdHgzd3h4NGRzb1BOSFdwWFpv?=
 =?utf-8?B?MmtkNGo3R2RyY2VTb01mNnVTQXNGdVRzRThDaVZPQnJYYTNMaENmZ2VpbTBY?=
 =?utf-8?B?Rmludk9TM0RrbGpjM3ZkazZ2blN6N0dqZE9QUFBkcUxlNmVkWnllTytZbnhE?=
 =?utf-8?B?em53MkN0TXlMcU9pbUE3dGJoYzAzWU8zcHp0MEZmUXN4Yy9IbUhCSDdJeEk3?=
 =?utf-8?B?dGlMYzNDWkRrc0gyZG9rY2lOYnJvWFBpSTBzZU5jbXI5Z3ZVOS96WXZMZ0pG?=
 =?utf-8?B?Mk1HZ3FVc3BKYVJLbWd1RlJWL3BBYmxBT29Tb3dSK0p0NExnekljVGY0V0gw?=
 =?utf-8?B?WlBXdlVhSlJiQlRMaUtOZk5jM1NFWVI5bFBkdXRNb2VVTDZtVC9uZ2ZPTENQ?=
 =?utf-8?B?eFFadWp4bkNzczVpaUxmQjU0clN5KzhxTW1VSWhWQlBhRjhBeEZWYjg3WWNy?=
 =?utf-8?B?WmcxZGg1RGl1WlFDdzJnekFaSnVzaVJMbjFVLzF6Q2ljZndhQlJYRTgwd1NJ?=
 =?utf-8?B?aFlOOEQzcU56N0JBRlljWHdPN2c4cTE2dWR6Mk92ajEyYVVWVTJ5eWlwUVB2?=
 =?utf-8?B?djhQdWQ4Mjh5MHg1cWpjeURaUHlqa0UyVXdMQ1JmYXNvM3lEWjJPTnlraEhv?=
 =?utf-8?B?bytKbkU3bzhKTUI2VU9KclhHUkkvNXkrdzNzNEJwekVGa1NlNkkvcGQ3RkM3?=
 =?utf-8?B?bDV5TFF3N2dobjhBNmJyNFp2NzJRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b44a2d-743a-46bf-1254-08db39d5db91
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 15:11:27.9706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7534XWCX7KJ8U8QB5ReIs8PGQBeIvPRCGjSQLqL+33AV1ZVWSvGBeXxytp3phitit0hcjNUVoNdJwHiPpBBYOTCbK2xQExnf/Aw78xS8k20=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5418
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 08, 2023 at 09:24:56PM +0200, Jesper Dangaard Brouer wrote:
> Update API for bpf_xdp_metadata_rx_hash() with arg for xdp rss hash type
> via mapping table.
> 
> The mlx5 hardware can also identify and RSS hash IPSEC.  This indicate
> hash includes SPI (Security Parameters Index) as part of IPSEC hash.
> 
> Extend xdp core enum xdp_rss_hash_type with IPSEC hash type.
> 
> Fixes: bc8d405b1ba9 ("net/mlx5e: Support RX XDP metadata")
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> Acked-by: Stanislav Fomichev <sdf@google.com>
> ---
>  drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |   60 ++++++++++++++++++++++
>  include/linux/mlx5/device.h                      |   14 ++++-
>  include/net/xdp.h                                |    2 +
>  3 files changed, 73 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> index efe609f8e3aa..97ef1df94d50 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> @@ -34,6 +34,7 @@
>  #include <net/xdp_sock_drv.h>
>  #include "en/xdp.h"
>  #include "en/params.h"
> +#include <linux/bitfield.h>
>  
>  int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
>  {
> @@ -169,15 +170,72 @@ static int mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
>  	return 0;
>  }
>  
> +/* Mapping HW RSS Type bits CQE_RSS_HTYPE_IP + CQE_RSS_HTYPE_L4 into 4-bits*/
> +#define RSS_TYPE_MAX_TABLE	16 /* 4-bits max 16 entries */
> +#define RSS_L4		GENMASK(1, 0)
> +#define RSS_L3		GENMASK(3, 2) /* Same as CQE_RSS_HTYPE_IP */
> +
> +/* Valid combinations of CQE_RSS_HTYPE_IP + CQE_RSS_HTYPE_L4 sorted numerical */
> +enum mlx5_rss_hash_type {
> +	RSS_TYPE_NO_HASH	= (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IP_NONE) |
> +				   FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_NONE)),
> +	RSS_TYPE_L3_IPV4	= (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV4) |
> +				   FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_NONE)),
> +	RSS_TYPE_L4_IPV4_TCP	= (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV4) |
> +				   FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_TCP)),
> +	RSS_TYPE_L4_IPV4_UDP	= (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV4) |
> +				   FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_UDP)),
> +	RSS_TYPE_L4_IPV4_IPSEC	= (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV4) |
> +				   FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_IPSEC)),
> +	RSS_TYPE_L3_IPV6	= (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV6) |
> +				   FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_NONE)),
> +	RSS_TYPE_L4_IPV6_TCP	= (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV6) |
> +				   FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_TCP)),
> +	RSS_TYPE_L4_IPV6_UDP	= (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV6) |
> +				   FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_UDP)),
> +	RSS_TYPE_L4_IPV6_IPSEC	= (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV6) |
> +				   FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_IPSEC)),
> +} mlx5_rss_hash_type;

Hi Jesper,

Sparse seems confused about 'mlx5_rss_hash_type' on the line above.
And I am too. Perhaps it can be removed?

drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:198:3: warning: symbol 'mlx5_rss_hash_type' was not declared. Should it be static?

...
