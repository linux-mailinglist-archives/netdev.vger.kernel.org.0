Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4D469C565
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 07:40:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjBTGkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 01:40:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjBTGkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 01:40:33 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2112.outbound.protection.outlook.com [40.107.101.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 707DEEB6E;
        Sun, 19 Feb 2023 22:40:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UXd6kgQCYUpzRQne40EhhMRPRACOHqFmzxNmCPs1ET2PZmzLX8xv7C9a4H5MFjQg5lQjqqOo6MFl85NdaJF2HZw/99GXsCxkalLyd1Hs4MwzbhG1agpZiz7LPStQGeTph2uusG39WwiuFx0NkBH4BQYIsJnqz3ZbcehD8jKm2D75bB9OhQTA7cMFD6+1dTOVFglosV02QsC6KqMYmRVEsC0oBH9NP2H3CaaSpCAfX0zh8QtOHGBx5L92Z2AoneuzDhOQ5Y4yJdQQz9AqFDf09ynVgmuqyCloafvHnW7zx4NhAd8wPMZgnk5H6JjWL9spM0pVviGyWwyElnuaKudVAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1ktXR7hClx1UDvTm7nA+WnfkmCo7WGai43FOHtGYQ4Q=;
 b=L9/EYEklwluCOkct0I4qXveNQrbr+GA32W92gX1WRQS6VTUkXbR46CY1o6S8gEfuSjesndfQJFZcDdgUeJExiaoXja2itSpL+PZGsLVA/iS9AI963be47rSeqXkJp7LE/SwCTlDYKrZymsh/RWVSc68RjSQskkyJIcQwkGPHmnwsgZVL4IzyKmsp0xGHE8ubakLdemwGqsR5lDy5XhSy5zwPPijDWr2+3RRhetHjqT6pYHMwuW8OOIseDGMoEKPB436yvtMx24wAe+3PbUdlHLhUnzmV6wEaHvY08Y1Gpo03RsiPalwYfAnqVr1pZsSxlvOTL46KbNxgk/gXouh/bA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1ktXR7hClx1UDvTm7nA+WnfkmCo7WGai43FOHtGYQ4Q=;
 b=HMU4nl2PIg1/GDxl3pwX7tMFse3PCf95NAKJK5zLo4Gj7CXJERqEXR9CBH9FwX3fbKcbiDG+464Rpg2nw1HoPk7NGbU64qjQhpimPtUiDd+n3F+IMbyRfkGasIG2FL12gqKtyMcEXDzZpqYj038/CRl32fku3RqPa+xC2UT/yuc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4701.namprd13.prod.outlook.com (2603:10b6:5:3aa::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.20; Mon, 20 Feb
 2023 06:40:28 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.019; Mon, 20 Feb 2023
 06:40:28 +0000
Date:   Mon, 20 Feb 2023 07:40:20 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, roopa@nvidia.com,
        eng.alaamohamedsoliman.am@gmail.com, bigeasy@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gavi@nvidia.com, roid@nvidia.com, maord@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [PATCH net-next v3 2/5] vxlan: Expose helper vxlan_build_gbp_hdr
Message-ID: <Y/MV1JFn4NuptO9q@corigine.com>
References: <20230217033925.160195-1-gavinl@nvidia.com>
 <20230217033925.160195-3-gavinl@nvidia.com>
 <Y/KHWxQWqyFbmi9Y@corigine.com>
 <b0f07723-893a-5158-2a95-6570d3a0481c@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b0f07723-893a-5158-2a95-6570d3a0481c@nvidia.com>
X-ClientProxiedBy: AM0PR02CA0154.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4701:EE_
X-MS-Office365-Filtering-Correlation-Id: 322770d1-3ddc-4cad-ee83-08db130d5a94
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: klq4i7QcPi5fguRIKYh8rjDeAnwHRsx+MsuxodU97V4knNi6jG2wgsb0zQjHvom5ynAiq4KdWqOscxvojlbn0XxF6+JFBnq7LH6c6kr3ToHIkHwjBC3BP33rUkFMTg9nUq5YdAcKXRdREkVB5VMuR3DXrgqvl/14nsAoj94FoF0DvNsg9paVFfDvZbplZ+nkata5Eut49fUZxzBw617KRTR7n/Vk2x4/qciTNC/nR3zR/ft/4pH+n/o6xxdtaEqsbwYrZdnkXavqa20l9l2L73TsjaBC0GpgzpDwSL0qdb7woGb7UZjuIU2aG2eH7QMN9LxnQpm3r335KUCA7enjIZIavG/Exm+FNL511gjZVcHCmUcVgYoo4lATG2ozew8LIzxOekuTx3JLutzohOMDGhP4I1kJ/G7NvJ9xjYf7Yd1c63m+Fic/P/OHMCJpv42ciyLqyySSAMyKV7VzlE0d7YyBRj5xOsMELOKSqhOpQkH5+WhZu4Ga/U1LtncqvUj1pq6Yoy928Un7jT4yNbDAR1xu1xBqGmqEDbtVsp5P2BhT8E3I3q/cWiFqSDrmwWsBa7/2ND1P9gvhmovf6ouFNatPkalwevHAW29KG9BQgefTjhlUQKbLr3GdYu/PRJuHUXz3jc7fE9nN3qg5vDjXAChxW9DqpzPl8z/TAYxYpulRvd6YCoceJKYgWyBEALFj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(346002)(39840400004)(366004)(136003)(451199018)(8936002)(5660300002)(7416002)(2616005)(4326008)(6916009)(8676002)(66476007)(66946007)(86362001)(66556008)(36756003)(83380400001)(316002)(478600001)(6486002)(41300700001)(53546011)(186003)(6512007)(2906002)(6506007)(6666004)(44832011)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MW5sS0JnUXE1L3Z1MU9LeGlUQ2JPK2ladUg3eHkvNEJqTUpuUkoxUFU2cVdt?=
 =?utf-8?B?WEpITnFTT0ZIU28wcFdwdlkrR2wzZStidEQyZFdqTGtaSDVJcFk3MEJsYkEv?=
 =?utf-8?B?L0ZHNElrNWh5ZGw4dzNZcDJRK1hHNkRsWnYrdmgzdERJR2lrbERKVzlpS2FZ?=
 =?utf-8?B?TnJHakRHanlCeFJndFBnWE1IR2hqSjBLemhOUjZaUy9DdkQ1OUlmWjc5QXBx?=
 =?utf-8?B?UDZQdE9lcHZlV0txWE5ZQ2dVTzF0U0VLYTZ3Um5lWGFhQW9jMitGNFlCWXd3?=
 =?utf-8?B?VVB2cEhUdzI3TGMwbXRabDFkU1FsL0tKODJNVi84SmNtVldZN0pFRklGVith?=
 =?utf-8?B?QkthYmI0YkNPTHFCVU5WL2lCNmU5cUtIYjNVVHBDZVMxVSs5SHJxSFR4QUhm?=
 =?utf-8?B?bDFkSzhIZyt2eEhVRUlsYnprOHBDZkJvaHlrRFZnTGQxRGxlUGg2N1dzWFMv?=
 =?utf-8?B?a3g5endMdit3QjhGbWNzbXQ3ZmJEQnBJTnM2RXZtUGkxNUh4N1NRSGtyUDBX?=
 =?utf-8?B?WWExRGFKeSs1NkNTbm5QZS9XOXlmWkdOZ25qTG1HSVJDMWhGWGZIRUxaejhh?=
 =?utf-8?B?UE9YSGt5M0lJSGlwemttck4wTUhvVXkvRmFXVWhrL3QwczFwem9UVVBHUnpP?=
 =?utf-8?B?QVNGczF4V1NsRFRvU01NdXFhU0hDR21tZUxEZmZzSlN0MkNXbG1mQXZuTnFw?=
 =?utf-8?B?QU9HODhYNmJkMmsyOFVKenJ2VjRHNW5ESGZrUm1YemtSTzExUUQ1U1FudzhD?=
 =?utf-8?B?b3QybVdYN0JJRDZDa2Era3EvUms1VFVCVG16UjdJT2U1Y0ZuY21KaEZCOXUr?=
 =?utf-8?B?Zm5UYnNaTGUzOU9wRWkrWXdwdWQ3MXlFektGUDlscW43N3V3RUErQ2U4MTdQ?=
 =?utf-8?B?ZVJNU291TTgrbmNMbUR2RSt4ZjVhVkZUVzJXZFd1RUlMblpCSHlkNnZ5UHQ0?=
 =?utf-8?B?UXpUem5rM3plZXJjdUZMYUVlZkFUN1M4NEZIMnhYZm5CM3k4ckZNQk84aXZQ?=
 =?utf-8?B?N1FNNFdkbkNCZ0JHUmhlelZzSnJaSTFxcUswaEdlSDU5eXVvYkl1MXVjbmhm?=
 =?utf-8?B?V05IenF2YUlGWldhNmlSTEdYL1N0eTQxY05HaXFSUDQ1QzUrVE9MWmJNRmhD?=
 =?utf-8?B?ZC9kbkVoVk5BQUdSSnJ6b09CVytBY2t3anRuZUNwWERycE8rYk9PWTJzUU4v?=
 =?utf-8?B?dmJJbzJXcGU4QkE1NjZiZ2VWb0lXYTYwQkx6cnU3MlhCNWE0VXRnZmUyTlAz?=
 =?utf-8?B?czcwY0RuY3ZLL2U1S203S3lDRXN5dDFRTzdhajA4YWpiRzZoKzMrTlM1RFpY?=
 =?utf-8?B?bU5VTWdDRFowMDMraUI4bSt1YVh5QXhWUm5hWDMzNkFqRWVEODFIbis3UkZy?=
 =?utf-8?B?UXRrSkEwZ2pvcEdJUDhEakFzUHhzeU12SjBMY3NDZjhTandINGY1U2VUQ3VD?=
 =?utf-8?B?NTR3TXpmRXVrTWoxNUlCSXgzd0tzYWdTeGxUR0J4R1E2L2J6N0duYmIxb3dN?=
 =?utf-8?B?WlNHaDJOanVvSmc4cGUvV3BONGl2bjRzMWNaMzl2M25zcXZGcXowQnpvWXMv?=
 =?utf-8?B?Skt1Y2NoTzN2SHFLWHYzM1M4ekIxalVQN3BqRHhMa1BUcngvZW0zcEN4NkNH?=
 =?utf-8?B?dTMxaG56dyt5QjgxaGRRRS9XcXJVVkNIdlMxKzAyRm52Y01iY2VwV0g3R2pX?=
 =?utf-8?B?ZXVGR3lEeTdBdlNNd0V2ckN0cHFSSmRrbWFVSk1QZWI3ZTA3d0dyQmk4ZlM0?=
 =?utf-8?B?ZzNBZjhSbEtxaHYxbG1sMjVSQlJWTXl5cStvdVBpUVNLNGVHd0lkWVA5MVlo?=
 =?utf-8?B?M3dvcEVHdFNUdnVURTZVMzJmcWUrT3RadENVY0lJUGJ4M2JZcW1hTXlWeStp?=
 =?utf-8?B?SllaaGw3RGNkVkNoOHV6N3gydkZtYzlxVXhlNnZ6bm1NYm5oNEZlTzVRbll3?=
 =?utf-8?B?Wi9aNWx5YkVDZXRVQzViWFlkcWd2ZGQzb0tBemJZV1djYVFGMFNsYXJYNmhq?=
 =?utf-8?B?QTVWcE5waDdMZ3RzVkE3ME8wOWZ2b0F3LzBWQXdXVWI5ZklzVkF0RlZlZThH?=
 =?utf-8?B?YVhWMzZwZTRORUVudkhYcE1nWXFhMHhraVgyWC9IcTBUK1VKekl1cmlBOFFD?=
 =?utf-8?B?OWZ0cXVSekNoc0V1TE1pNXdzZ0VVL09hL1FxUWdzdXcyeDFNV28yTGxMWGZm?=
 =?utf-8?B?cUZqVFozT3dmWkNieURwUTg0eEM2Tm9UZC9Vb05FS3BIWVR2Uy92MHc2N1FC?=
 =?utf-8?B?UmRZanhNUjVvQ0FiUXhYcDBoOUVBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 322770d1-3ddc-4cad-ee83-08db130d5a94
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2023 06:40:28.1706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RkxOkvZQdIzdatsU4v5GleTxyrlC5GMk6Tcl+F32OfwPBTQc4BbiwIy60Bfoeu1lCw0u+oeHwScs70re/2WgP2C7vKN/k9nVwGe1OtJZPpQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4701
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 20, 2023 at 10:05:00AM +0800, Gavin Li wrote:
> 
> On 2/20/2023 4:32 AM, Simon Horman wrote:
> > External email: Use caution opening links or attachments
> > 
> > 
> > On Fri, Feb 17, 2023 at 05:39:22AM +0200, Gavin Li wrote:
> > > vxlan_build_gbp_hdr will be used by other modules to build gbp option in
> > > vxlan header according to gbp flags.
> > > 
> > > Signed-off-by: Gavin Li <gavinl@nvidia.com>
> > > Reviewed-by: Gavi Teitz <gavi@nvidia.com>
> > > Reviewed-by: Roi Dayan <roid@nvidia.com>
> > > Reviewed-by: Maor Dickman <maord@nvidia.com>
> > > Acked-by: Saeed Mahameed <saeedm@nvidia.com>
> > I do wonder if this needs to be a static inline function.
> > But nonetheless,
> 
> Will get "unused-function" from gcc without "inline"
> 
> ./include/net/vxlan.h:569:13: warning: ‘vxlan_build_gbp_hdr’ defined but not
> used [-Wunused-function]
>  static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, const struct
> vxlan_metadata *md)

Right. But what I was really wondering is if the definition
of the function could stay in drivers/net/vxlan/vxlan_core.c,
without being static. And have a declaration in include/net/vxlan.h

> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> > 
> > > ---
> > >   drivers/net/vxlan/vxlan_core.c | 19 -------------------
> > >   include/net/vxlan.h            | 19 +++++++++++++++++++
> > >   2 files changed, 19 insertions(+), 19 deletions(-)
> > > 
> > > diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
> > > index 86967277ab97..13faab36b3e1 100644
> > > --- a/drivers/net/vxlan/vxlan_core.c
> > > +++ b/drivers/net/vxlan/vxlan_core.c
> > > @@ -2140,25 +2140,6 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
> > >        return false;
> > >   }
> > > 
> > > -static void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, struct vxlan_metadata *md)
> > > -{
> > > -     struct vxlanhdr_gbp *gbp;
> > > -
> > > -     if (!md->gbp)
> > > -             return;
> > > -
> > > -     gbp = (struct vxlanhdr_gbp *)vxh;
> > > -     vxh->vx_flags |= VXLAN_HF_GBP;
> > > -
> > > -     if (md->gbp & VXLAN_GBP_DONT_LEARN)
> > > -             gbp->dont_learn = 1;
> > > -
> > > -     if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
> > > -             gbp->policy_applied = 1;
> > > -
> > > -     gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
> > > -}
> > > -
> > >   static int vxlan_build_gpe_hdr(struct vxlanhdr *vxh, __be16 protocol)
> > >   {
> > >        struct vxlanhdr_gpe *gpe = (struct vxlanhdr_gpe *)vxh;
> > > diff --git a/include/net/vxlan.h b/include/net/vxlan.h
> > > index bca5b01af247..b6d419fa7ab1 100644
> > > --- a/include/net/vxlan.h
> > > +++ b/include/net/vxlan.h
> > > @@ -566,4 +566,23 @@ static inline bool vxlan_fdb_nh_path_select(struct nexthop *nh,
> > >        return true;
> > >   }
> > > 
> > > +static inline void vxlan_build_gbp_hdr(struct vxlanhdr *vxh, const struct vxlan_metadata *md)
> > > +{
> > > +     struct vxlanhdr_gbp *gbp;
> > > +
> > > +     if (!md->gbp)
> > > +             return;
> > > +
> > > +     gbp = (struct vxlanhdr_gbp *)vxh;
> > > +     vxh->vx_flags |= VXLAN_HF_GBP;
> > > +
> > > +     if (md->gbp & VXLAN_GBP_DONT_LEARN)
> > > +             gbp->dont_learn = 1;
> > > +
> > > +     if (md->gbp & VXLAN_GBP_POLICY_APPLIED)
> > > +             gbp->policy_applied = 1;
> > > +
> > > +     gbp->policy_id = htons(md->gbp & VXLAN_GBP_ID_MASK);
> > > +}
> > > +
> > >   #endif
> > > --
> > > 2.31.1
> > > 
> 
