Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 928F66E4697
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 13:37:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjDQLhU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 07:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjDQLhT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 07:37:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2100.outbound.protection.outlook.com [40.107.93.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404C493C1;
        Mon, 17 Apr 2023 04:36:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hm3F88jytIOekDhLUqkfKOnmOBOsreNZ1X9yhIl2IwQNiboBwnW3pCVKl/GPI07pgVCh3biy/E2OyUqDwmFvYQPQzk+altmlUPbjla6YKrA55Bo6+IYvYZRo6IKkX4Z4jm2H8uFrCEzRNQ3qAa0fYiXqN0hOHN0h6eEk5r0S8Kbq0LADUm+JI3qKgo9EfEPsIXWeRhB2HDBrQ4FpZU5Nzfx81dLF2XuLBCcQsiy8+q5gBD9YSfvgLlX26uXhyw7jBqF6Ld0gUjrhSXECtstI+tWUqjar3YWPZVpe0gXLUS87mHc9KoOaxx9FAaapTbrSmnKBk4qpnPfGHVnhPE2LyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FlAROnkAYihJtb8qk3AteRDhqWNaWPyaxxryUDANZhI=;
 b=DE9jh16KYq9kRVbUO8smJRcRREPcOeYwaF7sMrT79ywBw1MxPIfmHGjIHmQhC4IJx9oJSiq0S5Iv3VfmoxO0edg0xCEuKasg3OdizxDEXEWAShTOu/ogAwiGJaPkuI+pxlVoIKvnhyJBpJhqnpVyC2nT2O1Ljmb3Sb3nNpxZuCM9+XgZeJgpoDfieKwCP3xllRH8UK3qDs/JR/xc07Rc+Rqz3CU0czluToi9w+i6tT70LIz8msmT6nzN62elzaLt6Z+8KrGaAfYMIkO/YTI/htGcnTpZrfG7+IRc3bi3FegRF4cdXZrIWr5d9w/eb+edKrSyLeJ1mE/f+0v7ykrMCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FlAROnkAYihJtb8qk3AteRDhqWNaWPyaxxryUDANZhI=;
 b=P01AlInQwYJHP20LhebJiH49r7llfhRBuagjivL1LUF6NjMi1lwavw1hZZgsBmJ3jeyW74f0UlsseFnIVTg36zqz9mhMIhBgWTZhTSJq4NGZKQlJxCJ64zxxsY9/dc9VkfyURJWgQh9gqh0yxc+p/ZtpSlAFKhsTy9q8tzR0Exc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB4431.namprd13.prod.outlook.com (2603:10b6:5:1bb::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Mon, 17 Apr
 2023 11:35:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 11:35:23 +0000
Date:   Mon, 17 Apr 2023 13:35:14 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org,
        Stanislav Fomichev <sdf@google.com>,
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
Message-ID: <ZD0u8i+SIr6IAQ7C@corigine.com>
References: <168098183268.96582.7852359418481981062.stgit@firesoul>
 <168098189656.96582.16141211495116669329.stgit@firesoul>
 <ZDQnFmZdESpF1BEz@corigine.com>
 <8cd2d200-09ec-57c2-0619-963dfe5efd58@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8cd2d200-09ec-57c2-0619-963dfe5efd58@redhat.com>
X-ClientProxiedBy: AM0PR01CA0123.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::28) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB4431:EE_
X-MS-Office365-Filtering-Correlation-Id: 486d9871-041d-42fe-435e-08db3f37d509
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y43xGCDqODxe8wWoUbXwToAejC9gA+Tekz0H9hHElVzioW1UGBLiCtmQdUVPjTZWg+qun8k65bHD+o6TYoogWbO7NC/J+5Nx5aXvEYO/r1jgB1woFe1PXNq0Ke9bDl81OIgW0FSW1jjSLpz4vHrgbW/bxNDuXX9xIy3j4RnWyldbaANzx3BcWUn8ZbQnLfyvOfBdvkZUH48VBmLesTj2he8H0ejI576QIINEfF/Ytiewpls9ZjqUmABMnkaexZZP74qGGCoZSESM2zhdETvA84RXKfl5klLmN4WowyC1GaQXnnMxxzaZHB8OX3RUN6X+GB2v3C6gHkhAj1yvHh85kTmlDD6QTlMRdoZlD/yh+uJwPQ25AiH/AWDIGHdEZ+lhFjgVitVdL8vcX8zXGjHu1DVBb/gof31JLvOW9Li0Z+totGQf5hrhA5PTSdzNvDkApEf/Xge+kV6NvAQqjkAlW34uIfhiyvf9MIOUX6F8q5OsAV3HeVPbAYFye3cDGTCkquNJOTO/0OPQWgoaazrmcKeS/8Tg1i/W5LUItQqIT+s57Wjqggtux+E2opaL8cXpTyopd79wk3nXmCbFTRkeCef1gXybiDLYBBlGuyU79ig=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(396003)(136003)(346002)(376002)(366004)(451199021)(7416002)(5660300002)(44832011)(2616005)(86362001)(83380400001)(966005)(66574015)(186003)(6506007)(6512007)(38100700002)(8676002)(8936002)(54906003)(478600001)(6666004)(6486002)(316002)(41300700001)(36756003)(66476007)(66556008)(4326008)(6916009)(66946007)(2906002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZDV3aU1kU0Zsb1NkdlVxaUFiM2tlaFBRWVJJR3owT3ZUV0lld3NmY1ZLRVRY?=
 =?utf-8?B?RUpvelhMWkMxaldHTmNJa0pxcnZMMjVGc2xRL3ZFNVZVWjB3QkJmdExkMTBY?=
 =?utf-8?B?RUE1V2lKeVZuNStxbm9IS3Z6ejF5YWNjdWhkWk1vMmlFOTN5M1R0MmViYXZu?=
 =?utf-8?B?YkxmZUw5ckpDSm1SaHlYU0Q4ZThhbGFCa0EydE5SaDkybUtoWk94YWZCeXlk?=
 =?utf-8?B?TDNGT2hJeEhadWF1aTdJck4xb1RHNFhUY29DL21melBPUjhaVFcvTXFtQm9E?=
 =?utf-8?B?VDM4VDhKSmJVMFVPVVRoT0hFb2pONDlhcU80NHRtZFBzYzE0bkdzMnJoeUpN?=
 =?utf-8?B?aDAxU2kzOHI0dy9PYUFCTUpDOFhUbUl5NHRwMUJPN1o3SWZzcHFLcG9LOXNZ?=
 =?utf-8?B?Um5OSlpkNWIxZFNURDJFRk9pQUZabUQySTBhcVkwUTMzbW9uQTBNb0FTdEZE?=
 =?utf-8?B?Rk5SQUZGR0FFNTFaOW9Wb0lMMThHalU0RVIrLzdGdHNveUZvOXhSRi9WM1JZ?=
 =?utf-8?B?OG9EMlZwbExsVXZJYmVIZXE3MkdrSlBtM0ZiN0cwRjVjYmNjQ3JzSXo4RGc3?=
 =?utf-8?B?L0dHeHdGZmhvU084Q3N3UEVBcFZ5V0N4dzhWM3pQR2FsZnkzamF6eXBjR054?=
 =?utf-8?B?ZlRhNXFjdHhOa25DZU5CZTdFRVNUMGdiekNWQ2dBaFpDeDlBcnJGaFkxbTVx?=
 =?utf-8?B?R3l5S2lqL0xvSWZyWjdwemlvNlpmZEd6Rzk5d2RjUHZvSzBGL2tDVDMvenVN?=
 =?utf-8?B?SUJGZjJ4M09aSEFkV0w3aTd2cWJBaEZIMW5TUlR1YnE0RWJCclJOaUNsd3Nz?=
 =?utf-8?B?eGswdG9xWStIaUVsSlhzUzloVm84dkJaS3JkbFBQbEtTSURWSUUrdjZUSllC?=
 =?utf-8?B?TEtBanlMc2duTzZtNnJHUEpvenZKekJ1K2twMVhhVXlVZG5tSXlBb1E3OTBB?=
 =?utf-8?B?MENZS1g5UkZXN3VlY2pzSHBQMU03L0V0RXl4OEtGK2QyNmhvSzR1bTdRbTVo?=
 =?utf-8?B?K29PTVpENW9lc2F1NHV4bHp0YWp1YU9WWWpXZUdzbnc5eHgvRktNV21LMjFo?=
 =?utf-8?B?RmszRW5PazZXdGhCS1FTTVgzblJPQlhscnY4c0F4dStFZmNxaDJkZkliek9X?=
 =?utf-8?B?aHV3UUN1bGtMdnJYZHF0dmU3ZVFOSEEvZ2hoZk1idnFYZjNmd0Q4eUJiRVpI?=
 =?utf-8?B?Ukx5RmZTeCsvWS9nNkt1dDFtMnc2UjN0cUY4c1NoL0IzY1hXbWgvNUo4QUQ5?=
 =?utf-8?B?UFFOdjQ4S2ZJeHVGREtRZWI2ZDc2YlBtNUh6cm1OSFVDcE5raVJLK3NHUllC?=
 =?utf-8?B?TllSN2F1Qy9pZGs0Sm5ZSkUwenhidTlTMlk5WXBCRHRna1BqTys4RTJ1bE0y?=
 =?utf-8?B?TnVKTkRkUXExNml5ZGVUUTdBaVlFRDJTUFMyUDVWKzVid2tFVEo2Lzg1TzNC?=
 =?utf-8?B?Wlh4ck4yS24vVWlEbzY3cCtaY1FGUFZBSGdNQnNPTGQvbDRxNVREekJDaUh1?=
 =?utf-8?B?T3Q5cnYrTitzL0hMVWt4a2tmczhoSVRpL2k1ZWJCWE1ZS2M0ODVDREhIekM3?=
 =?utf-8?B?a1k1R3ZlelpMdk5tUXVGNHV2KzNpdWE1NzFVSnRWU3R0dm55aXJXQm9UUmp1?=
 =?utf-8?B?TlVIMzkzQWZheEM4V2F5Z1RqMjVQekZrb1NXMWx1RDNabnlMUnh0SVQ3eSto?=
 =?utf-8?B?VTUwcXh2Q2oyQ3d1ZUp5eHNqZmhoR1VjR2Y5S2czdExtK3JNRVpMRmxLeC9E?=
 =?utf-8?B?cmd1a3QzdlgrVWozMTEzK3hpV09RZXRON3JPWXJnZ0lOUmg5OHFTRVVpT2Iv?=
 =?utf-8?B?N0s4S0Y0bzA4Wnp1eHdjbDFTaDY1K3hXNEI0dnJlZzU5NVZFMUlQMFVKM2lC?=
 =?utf-8?B?ZDdjL2VDQzhCby9uY3V3RHVLWTUvK3RDRHp2R1pWeHBSZ0liNEhhd2d6WDZL?=
 =?utf-8?B?WWhJVkhFRWQvUUZuZER5ZUE4ZzBXOGdHcjJOMlVwNlVHaTBhVkpLVk9qZjFL?=
 =?utf-8?B?OFI2dVJYaHpUZDNuNVo5STNrdXI1NG1WdG0wUTZSenlURStIMzArK2dqd2hr?=
 =?utf-8?B?bU1rbkhDUVdYVGR4T1ZDb3hDcTZlMitmWGtQT1ZsTFpPTWRqOEIxTjgwSVRr?=
 =?utf-8?B?RHBQdE56cXhIQStSMzkxaUJvWWcxT213TytuYWd2eUJWelFkc3ozb3l5RW8y?=
 =?utf-8?B?eUREQWNFRXlXQVMxWjV3U2luTzQrVUZXTGhOY2FRZTlOL3JTR0N0aHo1U0Z0?=
 =?utf-8?B?ZnhOSjJRZ1JoSFhzM2QzSk9jS2NRPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 486d9871-041d-42fe-435e-08db3f37d509
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 11:35:23.6190
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OZ6ydsV//ir72n2XxjIEDbtgY1udDM0OBPTmyrmC6/lxY7aTPtkcoDJL2bBIdZjhI2VhYbjlfcfWId7Vzad29B8+vocovzpcovWO6CeKzOw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB4431
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 01:31:18PM +0200, Jesper Dangaard Brouer wrote:
> [You don't often get email from jbrouer@redhat.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> On 10/04/2023 17.11, Simon Horman wrote:
> > On Sat, Apr 08, 2023 at 09:24:56PM +0200, Jesper Dangaard Brouer wrote:
> > > Update API for bpf_xdp_metadata_rx_hash() with arg for xdp rss hash type
> > > via mapping table.
> > > 
> > > The mlx5 hardware can also identify and RSS hash IPSEC.  This indicate
> > > hash includes SPI (Security Parameters Index) as part of IPSEC hash.
> > > 
> > > Extend xdp core enum xdp_rss_hash_type with IPSEC hash type.
> > > 
> > > Fixes: bc8d405b1ba9 ("net/mlx5e: Support RX XDP metadata")
> > > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> > > Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
> > > Acked-by: Stanislav Fomichev <sdf@google.com>
> > > ---
> > >   drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c |   60 ++++++++++++++++++++++
> > >   include/linux/mlx5/device.h                      |   14 ++++-
> > >   include/net/xdp.h                                |    2 +
> > >   3 files changed, 73 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > > index efe609f8e3aa..97ef1df94d50 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c
> > > @@ -34,6 +34,7 @@
> > >   #include <net/xdp_sock_drv.h>
> > >   #include "en/xdp.h"
> > >   #include "en/params.h"
> > > +#include <linux/bitfield.h>
> > > 
> > >   int mlx5e_xdp_max_mtu(struct mlx5e_params *params, struct mlx5e_xsk_param *xsk)
> > >   {
> > > @@ -169,15 +170,72 @@ static int mlx5e_xdp_rx_timestamp(const struct xdp_md *ctx, u64 *timestamp)
> > >      return 0;
> > >   }
> > > 
> > > +/* Mapping HW RSS Type bits CQE_RSS_HTYPE_IP + CQE_RSS_HTYPE_L4 into 4-bits*/
> > > +#define RSS_TYPE_MAX_TABLE  16 /* 4-bits max 16 entries */
> > > +#define RSS_L4              GENMASK(1, 0)
> > > +#define RSS_L3              GENMASK(3, 2) /* Same as CQE_RSS_HTYPE_IP */
> > > +
> > > +/* Valid combinations of CQE_RSS_HTYPE_IP + CQE_RSS_HTYPE_L4 sorted numerical */
> > > +enum mlx5_rss_hash_type {
> > > +    RSS_TYPE_NO_HASH        = (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IP_NONE) |
> > > +                               FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_NONE)),
> > > +    RSS_TYPE_L3_IPV4        = (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV4) |
> > > +                               FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_NONE)),
> > > +    RSS_TYPE_L4_IPV4_TCP    = (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV4) |
> > > +                               FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_TCP)),
> > > +    RSS_TYPE_L4_IPV4_UDP    = (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV4) |
> > > +                               FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_UDP)),
> > > +    RSS_TYPE_L4_IPV4_IPSEC  = (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV4) |
> > > +                               FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_IPSEC)),
> > > +    RSS_TYPE_L3_IPV6        = (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV6) |
> > > +                               FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_NONE)),
> > > +    RSS_TYPE_L4_IPV6_TCP    = (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV6) |
> > > +                               FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_TCP)),
> > > +    RSS_TYPE_L4_IPV6_UDP    = (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV6) |
> > > +                               FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_UDP)),
> > > +    RSS_TYPE_L4_IPV6_IPSEC  = (FIELD_PREP_CONST(RSS_L3, CQE_RSS_IPV6) |
> > > +                               FIELD_PREP_CONST(RSS_L4, CQE_RSS_L4_IPSEC)),
> > > +} mlx5_rss_hash_type;
> > 
> > Hi Jesper,
> > 
> > Sparse seems confused about 'mlx5_rss_hash_type' on the line above.
> > And I am too. Perhaps it can be removed?
> > 
> 
> Yes, it can be removed (in V8).
> 
> The reason/trick for doing this was to get compiler to create the enum
> symbol, which allowed me to inspect the type using pahole (see cmd
> below).  (This will also expose this to BTF, but it isn't actually
> useful to keep around for BTF, so I will remove it in V8.)

Thanks Jesper,

I didn't know that trick :)

> $ pahole -C mlx5_rss_hash_type
> drivers/net/ethernet/mellanox/mlx5/core/en/xdp.o
> enum mlx5_rss_hash_type {
>        RSS_TYPE_NO_HASH       = 0,
>        RSS_TYPE_L3_IPV4       = 4,
>        RSS_TYPE_L4_IPV4_TCP   = 5,
>        RSS_TYPE_L4_IPV4_UDP   = 6,
>        RSS_TYPE_L4_IPV4_IPSEC = 7,
>        RSS_TYPE_L3_IPV6       = 8,
>        RSS_TYPE_L4_IPV6_TCP   = 9,
>        RSS_TYPE_L4_IPV6_UDP   = 10,
>        RSS_TYPE_L4_IPV6_IPSEC = 11,
> };
> 
> This is practical to for reviewers to see if below code is correct:
> 
> > +/* Invalid combinations will simply return zero, allows no boundary
> checks */
> > +static const enum xdp_rss_hash_type
> mlx5_xdp_rss_type[RSS_TYPE_MAX_TABLE] = {
> > +    [RSS_TYPE_NO_HASH]       = XDP_RSS_TYPE_NONE,
> > +    [1]                      = XDP_RSS_TYPE_NONE, /* Implicit zero */
> > +    [2]                      = XDP_RSS_TYPE_NONE, /* Implicit zero */
> > +    [3]                      = XDP_RSS_TYPE_NONE, /* Implicit zero */
> > +    [RSS_TYPE_L3_IPV4]       = XDP_RSS_TYPE_L3_IPV4,
> > +    [RSS_TYPE_L4_IPV4_TCP]   = XDP_RSS_TYPE_L4_IPV4_TCP,
> > +    [RSS_TYPE_L4_IPV4_UDP]   = XDP_RSS_TYPE_L4_IPV4_UDP,
> > +    [RSS_TYPE_L4_IPV4_IPSEC] = XDP_RSS_TYPE_L4_IPV4_IPSEC,
> > +    [RSS_TYPE_L3_IPV6]       = XDP_RSS_TYPE_L3_IPV6,
> > +    [RSS_TYPE_L4_IPV6_TCP]   = XDP_RSS_TYPE_L4_IPV6_TCP,
> > +    [RSS_TYPE_L4_IPV6_UDP]   = XDP_RSS_TYPE_L4_IPV6_UDP,
> > +    [RSS_TYPE_L4_IPV6_IPSEC] = XDP_RSS_TYPE_L4_IPV6_IPSEC,
> > +    [12]                     = XDP_RSS_TYPE_NONE, /* Implicit zero */
> > +    [13]                     = XDP_RSS_TYPE_NONE, /* Implicit zero */
> > +    [14]                     = XDP_RSS_TYPE_NONE, /* Implicit zero */
> > +    [15]                     = XDP_RSS_TYPE_NONE, /* Implicit zero */
> > +};
> 
> > drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:198:3: warning: symbol 'mlx5_rss_hash_type' was not declared. Should it be static?
> > 
> > ...
> > 
> 
