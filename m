Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23A0E6DCA82
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 20:10:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230424AbjDJSKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 14:10:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230376AbjDJSKa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 14:10:30 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2111.outbound.protection.outlook.com [40.107.244.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D5F2D48
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 11:10:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SJP5gYE+WHkhiteTdWS0LMJkxjDEs8zPccRuJeKJFU67hsD4RA7T9oI8m7UHeztHvWqCIfgagr0e20m2DFbTupsk7sre/hnZsHYNSz4O61dYYOEcAp1PS0IaBPvJdafSMlJmPjE92zVK3/UfeeSXuV9bsbIv37o7Aa3Y7e6/7paxNZdkT0ijAi+Mqa29paEuBpNJskLsYoo3KKVcPVlEsvYp66WFWbqRTo5cSp0c1uHLTgvr4WJhkIygHoVoUfxuAfTtegq6exkwJyjTpxcSWMDRm+hMv/PibtSTjF8iMs2f+S5lrr3gCucBcSh2W69YyMcAsV0BS+h4ZaRUgAjXGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CEjzhQNF8pc+tgL1phwKdiCO90drBH5G4YlJmKM7AC0=;
 b=Qpduxlv9t041hdV0SwIDb81mBfhuWpSemk9J2l7Hl7THUpuU2x2PGiMt3I89qCHBfByet/zF7yWawtZD/NWjPfq3GNPS6bs678fD2K4ZhfS1swgZBuo3Omg1Sx5qTYR5mGD/fn62v4Z0R5xeOu7aRCMq/pkmItWh+ylNecc0i+3CNtL6JSYQPQ7h01nfmT8uUnAxWFeVDNMtyNExed+0Q9uvpnGgyIQo5xg3st3BQhQVOlAy0k1MV0rC9IKtw6C6k9Xn0F49tesdoXAkZMlN5b8LfXjJF9PZ/axTGGc/qy+zUTAquuBV/58mBzeUW7q1d0jUHU5PHumjR5NKNfdsRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CEjzhQNF8pc+tgL1phwKdiCO90drBH5G4YlJmKM7AC0=;
 b=fXZKl5EhG372qRuzAx767/+SYmA8zFX5xlQIMiQonX8GERdNhHHXsfCuIrjPLvy++tJCcelmWi7nlMF6h/SORluNVPCXMcTVfW//7EH+0hKUNrOq+tSzlaFS0qPQGvKs+zotCFnnjBKRPcwW6h4ZoR8jz3oHD4nlwPYS9skjBFU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5226.namprd13.prod.outlook.com (2603:10b6:208:345::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Mon, 10 Apr
 2023 18:10:22 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 18:10:22 +0000
Date:   Mon, 10 Apr 2023 20:10:14 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Raed Salem <raeds@nvidia.com>, Emeel Hakim <ehakim@nvidia.com>
Subject: Re: [PATCH net-next 09/10] net/mlx5e: Create IPsec table with tunnel
 support only when encap is disabled
Message-ID: <ZDRRBiT6umIH0rcR@corigine.com>
References: <cover.1681106636.git.leonro@nvidia.com>
 <ee971aa614d3264c9fe88eb77a6f61687a3ff363.1681106636.git.leonro@nvidia.com>
 <ZDQdNV+SRG6EVYlJ@corigine.com>
 <20230410164920.GU182481@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410164920.GU182481@unreal>
X-ClientProxiedBy: AS4P191CA0020.EURP191.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d9::8) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5226:EE_
X-MS-Office365-Filtering-Correlation-Id: cd173031-a239-4fef-cebf-08db39eed99d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1eXkjIp60DlGeWk3fYwIuUJVM1wlvGJrht4NNqcn6ftHSywdDhl1vZtKFPSSw+axcpHvbsBSNHB2Y5WIVYWkdFaBlxpKX680HwKV//grb+/LSwEYL/nwY/asEKmvFB4rnFpTDj6bnyBatifmNSJOSegM4fd1aAcfgBBHiI8W8NPRqLQl//NQ1lx43ZLIRyCaIp/wvHljXw3vOgp5EldwqIsC9uCR8U8jKWYVb8HMfsW3DhAuffPyIImhjGXh2nMYqmCo9hR1Mn65UJJumN4SPrPA6B+LMEFd9g94kzFnLyHUmo3Qvj8v+Mp/AI6iK+jOOS7q8yJD+1HViy+piOkfJyMoa4u9QtAxJQHFpGTDKvZhAN11wKui8G8/bKP8mTT40KfkXHVtoymrPLOYAjzc8zJMOJum11AOHfCIqbAAwc+VqfQepDmI0Jy+J/ZW/sEbuCVrwphrjByPgUDx/aH0mueU1lKf0paAqp/1yLYxJbzb/Ox2SNBTsAqhrsoYBMlUD5iWwDFV+vO0BR2DGC86p2qSz8g+W1xdgeHtESFgxdLTcxLD+TzrV2nzuqwCQ1KQ3GGnOjEJ4inuHPhfyYYka5Ojd2mr9YWxUQTOoAKjzpk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(396003)(136003)(39840400004)(346002)(451199021)(478600001)(86362001)(83380400001)(36756003)(38100700002)(2616005)(6486002)(6666004)(2906002)(316002)(6512007)(186003)(54906003)(44832011)(6506007)(7416002)(66476007)(8936002)(8676002)(6916009)(41300700001)(66556008)(5660300002)(66946007)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eQ1Nhqc+VLbqYMBsaZIoY2YJNk70Fp/YnInSOmLAmyR/kGUysN0avAR5VRrm?=
 =?us-ascii?Q?4Rkypv67qpv7nTwdJbNHXB7ynJuMyxYC+9gpRlzN6o1I9hIRQTaU0Rj1+H0M?=
 =?us-ascii?Q?7a9pIHjOSXkQnakSUKvwk5ek4xDR51XXNqbIUys6vSVqxCFzCdS6q8padZ3E?=
 =?us-ascii?Q?IF2LEykFTnUbB77UWhsTIq+xSjAtPCDfcVHIeHnTZyHVqu5WeVqQojVauDmv?=
 =?us-ascii?Q?9lwVjydIlTC41NeyyW20dJspCMGj862GK7c2rBezu8hppyd6OzcT0MLr1lHu?=
 =?us-ascii?Q?Xpn0t6aZsG5v5szMM6EZfqINDhyOLCJa+uQ1wSTYfjn4a7hR3XOBmIQgV4am?=
 =?us-ascii?Q?J6OdQfCW9rM+5tmYmlNoA0QcNsGJl3LiENu7fPT7RwaHkqyIyW/iPmqdTZi2?=
 =?us-ascii?Q?JqrgjMfWReMCxDgw7jYsBb6D3xTv+YVePGZzxdpH3d9GzkVFmOVx4ah9OL98?=
 =?us-ascii?Q?lyf2fz10KtDU4UCQ9p157FOym0jibvKmvPCc+vz/XNh3lyrpF2CnsNIx+JwE?=
 =?us-ascii?Q?4lauQVTZIFNb9E7nMRDPe48mx5lujMs2zYTgTWBnJsCOXUa4Z1yOcvIATYHr?=
 =?us-ascii?Q?5E/jv8vkxN3AJs1GDTYDBv+WUsm4pX2TT47zlRvdGTRE+0O18jMy77aLLKfV?=
 =?us-ascii?Q?QpaPxgEmsimvV+R9U6s94AiI+PkRdydgpCXGPvgjSzZ67cSAu37ERnj2HMoh?=
 =?us-ascii?Q?ZBWu5zTaMStxulHWZn18DyksbuXVmWVmKr9CVnnnGEIkRUZzrKXF8jeyV3lL?=
 =?us-ascii?Q?mYI2WZFT/UoKPfgIHccQZ47SrrfSs7meWVNgPbBWwf/UsYizWF2idjDKcyEM?=
 =?us-ascii?Q?wFYJO239NK8ugQYtutqjYXnVlLSDpVhG8vak4VUgmbDZXMmxLY60jXzGW5D9?=
 =?us-ascii?Q?bx4qRfe3c2AtyHJJAB8UlKk0lkYntbvkGAS8gpWQi9evz0GWJNlGz2TNX/vu?=
 =?us-ascii?Q?+MT7Om84085TZU7r+kMro3GWYmNQh8Aoe17LxvhpUsCqnD2nrV/pyPcmjgX3?=
 =?us-ascii?Q?Enw0mX6EJO0QjAN1aeWvVFPyHZt/mtCBmljtFArQhHeDOAgGIYmBMdHo5hHK?=
 =?us-ascii?Q?ParG6wzNRX6N7Z9rOMPgdOBtGQtdZQtlbR/Geq7bZDBgf4WqJ0UtvMtXbPk2?=
 =?us-ascii?Q?9xrlT45Zaid8PuclIdx7PVS8RQXsoqf27liu+sT5LETEVV9gmEN7jUQXpqbK?=
 =?us-ascii?Q?8XzvH+ML7VugKhv187BAInApDvqvKUs4UvMR9q97rTpkYqtXarHkeF180p0P?=
 =?us-ascii?Q?gBJ9Aybo/JP12F1Qx5flxazIn5FhJQNxqu5tlk1bScwqzWg/gt8YPfA6lfoy?=
 =?us-ascii?Q?cVhO55/lDtYcF33lkH5Vb4rqvoPcXB+g7RrSeXcKpO9BsaxwBR7d0CgjPLjX?=
 =?us-ascii?Q?bGf/WaYpUFaf7GWjh1+2KFAosGx0mUhtR48mMP/1cWaS5QC5GE5ybvGACAwN?=
 =?us-ascii?Q?XnNXcU8QX5c3Affq7lmkWKQsFnUEHK2HAQjuakLJhMxgEEFft0N8IIs+ia2s?=
 =?us-ascii?Q?PM2ECQx5/unsSq6FvFrDioC934BZZDvnmEy4kROQ2+9D4fwz/Plhj38HSD1m?=
 =?us-ascii?Q?1iOdMPeP/aImENbdUYkYJYIqJVIYAjw7UCvB4dBePvULA25t8pFDqDsoWqV5?=
 =?us-ascii?Q?HAO+B1X01bO1T1RKhjwM7c1+2bMNjp7ib6x16jOpLQ9SLN961ImBPJtkFUhB?=
 =?us-ascii?Q?2v5yeg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd173031-a239-4fef-cebf-08db39eed99d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 18:10:22.5279
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xOntVfWsbCNouUV9FaKGgAaCOcWAGcJLH21o1D57AoMZYsHgEKWSv6TqBoeChjoqfbiKC/GoLY9bmfsTZ1zhK+z0kTuNlN8AjPKQdTVKv5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5226
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 07:49:20PM +0300, Leon Romanovsky wrote:
> On Mon, Apr 10, 2023 at 04:29:09PM +0200, Simon Horman wrote:
> > On Mon, Apr 10, 2023 at 09:19:11AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Current hardware doesn't support double encapsulation which is
> > > happening when IPsec packet offload tunnel mode is configured
> > > together with eswitch encap option.
> > > 
> > > Any user attempt to add new SA/policy after he/she sets encap mode, will
> > > generate the following FW syndrome:
> > > 
> > >  mlx5_core 0000:08:00.0: mlx5_cmd_out_err:803:(pid 1904): CREATE_FLOW_TABLE(0x930) op_mod(0x0) failed,
> > >  status bad parameter(0x3), syndrome (0xa43321), err(-22)
> > > 
> > > Make sure that we block encap changes before creating flow steering tables.
> > > This is applicable only for packet offload in tunnel mode, while packet
> > > offload in transport mode and crypto offload, don't have such limitation
> > > as they don't perform encapsulation.
> > > 
> > > Reviewed-by: Raed Salem <raeds@nvidia.com>
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Hi Raed and Leon,
> > 
> > some minor feedback from me below.
> > 
> > > ---
> > >  .../mellanox/mlx5/core/en_accel/ipsec.c       |  7 ++++
> > >  .../mellanox/mlx5/core/en_accel/ipsec.h       |  1 +
> > >  .../mellanox/mlx5/core/en_accel/ipsec_fs.c    | 33 +++++++++++++++++--
> > >  3 files changed, 38 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > index b64281fd4142..e95004ac7a20 100644
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > @@ -668,6 +668,13 @@ static int mlx5e_xfrm_add_state(struct xfrm_state *x,
> > >  	if (err)
> > >  		goto err_hw_ctx;
> > >  
> > > +	if (x->props.mode == XFRM_MODE_TUNNEL &&
> > > +	    x->xso.type == XFRM_DEV_OFFLOAD_PACKET &&
> > > +	    !mlx5e_ipsec_fs_tunnel_enabled(sa_entry)) {
> > > +		NL_SET_ERR_MSG_MOD(extack, "Packet offload tunnel mode is disabled due to encap settings");
> > > +		goto err_add_rule;
> > 
> > The err_add_rule will return err.
> > But err is zero here.
> > Perhaps it should be set to an negative error code?
> 
> Thanks, I overlooked it.
> 
> > 
> > Flagged by Smatch as:
> > 
> > drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c:753 mlx5e_xfrm_free_state() error: we previously assumed 'sa_entry->work' could be null (see line 744)
> 
> I don't get such warnings from my CI, will try to understand why.
> 
> What are the command line arguments you use to run smatch?

Hi Leon,

I run Smatch like this:

.../smatch/smatch_scripts/kchecker \
	drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.o

> What is the version of smatch?

I see this with Smatch 1.73.


In writing this email, I noticed that Smatch seems to flag
a problem in net-next. Which seems to be a valid concern.

drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c:753 mlx5e_xfrm_free_state() error: we previously assumed 'sa_entry->work' could be null (see line 744)
