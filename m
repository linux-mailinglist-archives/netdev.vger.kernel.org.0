Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7835D6E5A1A
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 09:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230003AbjDRHJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 03:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjDRHJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 03:09:26 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2134.outbound.protection.outlook.com [40.107.223.134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750491BD8
        for <netdev@vger.kernel.org>; Tue, 18 Apr 2023 00:09:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRaKKPtbEQNXJy7iGgCMHRrjVFCujM0scHhwlh6oSclxJyypMQAKnapTJHHg9ZWoctTtO5RCC0JY8mkO8Psmmlnk0o1UO7q5vivkHj9I8gf60KfHHA6ibhRFkxLyf85l+K3ehxOIG9q4ZX7PnwayoLj17vbgzDaED8kL+NHy7xjyofsXRfcF3sBLlyoVU0U5YKipOuov8ERbB2/G9BeB5t76O7f/cvvqMZYkLTDWGyTLSaQ6jFwEaTxYrtvGv6TrCspqpK/gutI0BnCSzVZZRA3w6SFOAVJH6zOvUBzOpBEGjmrXGPWaR/Igc3AMQTVAqmk6W0XD09PGJ/uu/7O/Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IV9mD61M0TC2FPdqznKO6q2Q2vBaU97zsIbxLm4TJyY=;
 b=CQCqd5a53vjvCjeKv9ba8PgkXFg9lpNgQPkeOXus4ZZMufI+Vfv1syn7Ew6yO59JCK4owEWsNLyxm5dGt5onk09ZO/cXKaIHTKAMPUbe8Sip0KpU4hpb8XynkqW485Lkd7tRp8f34bysaIngnt10N/mOZNA2GMQjNN6GNFBmfsczNpBbxTrk3csGFco/FuNP68FApdWoBJMlbMSta93cqg+BTKx/Zq86/SpwVTIQC5f5+tiToh/WLT6RYksE1CfNs73Zc+4W+6gT2qm/ZzIOACdH95y6kMh1K12ofthrW0H7VBjss4109ZuFXqopvHulZ4fTv6iUJL8CeWiMzzPZ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IV9mD61M0TC2FPdqznKO6q2Q2vBaU97zsIbxLm4TJyY=;
 b=XV+tnIzxbDX0Vrh38vdbWM/nfCQjq74swRgABOWcZV7oYl0Js7ChfLdIoDYY/iLE5Mn+1oQZCT7ZHH4KofUFMbEhm5MPYUscRsUq3GwnvxqjMDrc1u2pBxFywNHlltkHs0XkzTK7zDJEfpTNniv299HgU9RClJv1EYF9U7deUD0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5505.namprd13.prod.outlook.com (2603:10b6:303:180::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.28; Tue, 18 Apr
 2023 07:09:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::89d1:63f2:2ed4:9169%5]) with mapi id 15.20.6298.045; Tue, 18 Apr 2023
 07:09:21 +0000
Date:   Tue, 18 Apr 2023 09:09:13 +0200
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
Subject: Re: [PATCH net-next v1 06/10] net/mlx5e: Support IPsec TX packet
 offload in tunnel mode
Message-ID: <ZD5CGQZQ2tWBeXQ1@corigine.com>
References: <cover.1681388425.git.leonro@nvidia.com>
 <bad0c22f37a3591aa1abed4d8a8e677b92e034f5.1681388425.git.leonro@nvidia.com>
 <ZD1Ia0ZB6mbZkQEC@corigine.com>
 <20230418064827.GA9740@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418064827.GA9740@unreal>
X-ClientProxiedBy: AM8P251CA0013.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5505:EE_
X-MS-Office365-Filtering-Correlation-Id: c8c78088-fb1e-4c19-dcc5-08db3fdbd52f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F6l8CVyYvzwSP7eNOUAb2l6M4BAzLD/bCwSgEwqFWlXThBQRzN1LoJirMCCWjyBVFUmzkDDNzbXH3GqvhDtOSR5BtrCGo7K29R9hYRG7Fm1YSobxj102nmWeS/GmcUX4NtDiGMJmYwySSSCkmWyNeB2bqgtZwtaADRpqawX97xskTH48HteMSw2AamOf5E3cmv/JPARq9DvdHYUP9WDv05R04B+aKXHybZVAQKl0AQk7DIWwvbHScMDNHHsxsoVpp+rQVkDgOjmv/J1c4Rljcp0jYszWYOjlNOXofZtbrJlEXt6QfwF6KnlriFJvKkXPjPci/o/ZMSPVaV9vFYJy33yvYB3UC36a0hbQ36vGtLuJX52XM9VwotbeLefgkKGFuRWJZSBJJ70uP8WlYIIQoW+J+Bdxma89R+hPu01IU8RKLzUzvzNOv/SS0GSEJrDUXdmQQsKyA9BGdxBaRQwUhqfk/E/E5Gw3VX8xsGgWyfMADlHHItQutlm/2XGmb4intAcfXZqzNP1WjvJwiR5YztbgST6+KqOlpdUYiVS1/sq9CatuDrNQXPRAyJXCstVn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(136003)(366004)(39840400004)(451199021)(7416002)(6512007)(478600001)(6506007)(36756003)(86362001)(4326008)(8676002)(5660300002)(6486002)(6666004)(41300700001)(8936002)(44832011)(316002)(66946007)(66476007)(66556008)(2906002)(54906003)(38100700002)(186003)(2616005)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RjAjOi35iSUSmmUqK+FWYxRZb5Pcm5aWnGYjeyORME4ZsNboOZeTtZH8rKJK?=
 =?us-ascii?Q?aDsdAE8THIJIFckIV05Zdcz+NfPId7+Kpii7SC+ALA06GSOx5G/2JAHGQfti?=
 =?us-ascii?Q?0nAPr+C8AW5m54k605riV7e09HMB0GRL0hBLHOk8SvBO4sA1IzlvctsR2wkZ?=
 =?us-ascii?Q?PLTOkEEKCNiYJ/yNfLsUmZ/LSGU8ovld2o8xCJdiEFcMKpnzUh89Ustb+TU6?=
 =?us-ascii?Q?cH2AH4Y1/FJdA9qAuL2O5Fm4nFiuHvfs3223w7q14RlZkxxZ+151okplaphA?=
 =?us-ascii?Q?E5RekHElExT66J0sqv4klEH+Bxe1+VQktGy+s6KYER1mdmqE3VTfu24HlZ4v?=
 =?us-ascii?Q?DKH3zLcdKdVtBqODWZJaM1YkQcf10Bfans7HsIAwGfMGNSkyK4Ab5KClbPxv?=
 =?us-ascii?Q?KsYQ2Y7rMl+zrrVuEf9l7pofScXD+m3ONs2K3c3BAfy4DytlZJYHVshOat7d?=
 =?us-ascii?Q?asmhOEjV8zq8HH83p3MCARW9mDGLXkyP5tAqBm8hoXEBQQtanwpQprXN+1zN?=
 =?us-ascii?Q?PxaqHMQoP5j3nMh6xwtH/ONHBP45SGJTZUCgPSC/yERgfSz513dqA6zT25Xd?=
 =?us-ascii?Q?IrMSpzZa1ZagwxTWvGE4ECKj9kvzR8TtWgBKpCNFwsABfmC3PozWe5neXQa6?=
 =?us-ascii?Q?9hkuTZh6eWHP/sCzm0wyR64BnpxeLEKjgK6rAvjmNLt4i/4cM3NQvE2x47/d?=
 =?us-ascii?Q?7J/aWvf2ELrls2YRSHyXDPnjXkAxQ0NCc+HHAP9lQoMbsS4WbLOwN4oucgQU?=
 =?us-ascii?Q?7ab18/ZOnP4g5WEFtnQp9ec/Tn173FWLJUKucIivqdGI0j1q4BMp0vIBkjvn?=
 =?us-ascii?Q?i5joek4ceV2rn5ASHL9aRymeHQIrA6Bfe9Ae5Xm6Albjh2h+tPZ+Ous8EwYX?=
 =?us-ascii?Q?ZjlKoFqh5DZqDOsuPuxtEBO1Oj8iJdYLCRgiyaJkmiF0unmZvx/9tANV/V2v?=
 =?us-ascii?Q?FFdLCyC0RAfkvXAfjzP5FNzDbeWcd9IsJHpiW3BwNBg2bGuYi1dix9m4sshd?=
 =?us-ascii?Q?LN9uMUZGf2L0bdolXZ3ZxnCdxb/gGeX6XM6QSzVN4PbpHxwR4s9Hymgas8w6?=
 =?us-ascii?Q?NR2LHgJfPjAVJfR7x+xtoftyxPLW6XYLMh4IFOyYf7f+pSSygYuQltbb1CDU?=
 =?us-ascii?Q?BoI+0vOVrkBHqQPWJIfd2ptJmoLZLgDroeFZxMhlhS65Nwkhezty7aWwNQWt?=
 =?us-ascii?Q?eJoW+V035vBDApdO1PCI3wDiywivzDTMjYsVRLyjoLg40CSqELLIrrMYx91Z?=
 =?us-ascii?Q?0sWoWMQnMWXCudzjvaZpFSz1LBBqcq5XWBT4ZQMGgGw6dK13YYNPipWbN34V?=
 =?us-ascii?Q?rMQfM/JcH3HIw8gDHkjR83Nwemo4eL4gjfRDDpfX2W0uJPrtADkK0tVZyp9C?=
 =?us-ascii?Q?f9TSh0Tw/qkrjD6pC5pjiuaSm+7PQyx0mX7jSXNL09SwYP1Ik9P0Nh8isFuR?=
 =?us-ascii?Q?eNbCpU2Q82y/YPt/K+VR1wu90W2MznVGTKTbHfX9n6GgsARxLKBfC7L2dENY?=
 =?us-ascii?Q?v8Qp2TDKJrHCCDj2gkiHsV0jrGY2Zlli4OkzFMTaNAHt4evSs9SBTkdzRKsD?=
 =?us-ascii?Q?864JVczjZeUZhAYALtOOU5nIT/qgaZ36j0S75EZvY44+MFAcqbsbi05eL/Yk?=
 =?us-ascii?Q?xKthpE9bRTQFiTNgiqk/oDcH3IYodizZOkOBp0NLEScrT1vNVJuHNvE7RRPS?=
 =?us-ascii?Q?N3VZoQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8c78088-fb1e-4c19-dcc5-08db3fdbd52f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 07:09:21.1882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ShYtwjQ4o5FQJCR9m5zkP22rVH++y+MFgSIWjkJOCe6nZ8FTFJlaCjI2E8jUPJda3fNB6p1TB08UOo3gc/6p09zQwzHzCHxXqUpQAD/i4T8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5505
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 09:48:27AM +0300, Leon Romanovsky wrote:
> On Mon, Apr 17, 2023 at 03:23:55PM +0200, Simon Horman wrote:
> > On Thu, Apr 13, 2023 at 03:29:24PM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro@nvidia.com>
> > > 
> > > Extend mlx5 driver with logic to support IPsec TX packet offload
> > > in tunnel mode.
> > > 
> > > Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> 
> <...>
> 
> > > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> > > @@ -271,6 +271,18 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
> > >  		neigh_ha_snapshot(addr, n, netdev);
> > >  		ether_addr_copy(attrs->smac, addr);
> > >  		break;
> > > +	case XFRM_DEV_OFFLOAD_OUT:
> > > +		ether_addr_copy(attrs->smac, addr);
> > > +		n = neigh_lookup(&arp_tbl, &attrs->daddr.a4, netdev);
> > > +		if (!n) {
> > > +			n = neigh_create(&arp_tbl, &attrs->daddr.a4, netdev);
> > > +			if (IS_ERR(n))
> > > +				return;
> > > +			neigh_event_send(n, NULL);
> > > +		}
> > > +		neigh_ha_snapshot(addr, n, netdev);
> > > +		ether_addr_copy(attrs->dmac, addr);
> > > +		break;
> > 
> > I see no problem with the above code.
> > However, it does seem very similar to the code for the previous case,
> > XFRM_DEV_OFFLOAD_IN. Perhaps this could be refactored somehow.
> 
> Yes, it can be refactored to something like this:

Thanks Leon,

this looks good to me.

> 
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> index 59b9927ac90f..55b38544422f 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
> @@ -252,6 +252,8 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
>  	struct net_device *netdev;
>  	struct neighbour *n;
>  	u8 addr[ETH_ALEN];
> +	const void *pkey;
> +	u8 *dst, *src;
>  
>  	if (attrs->mode != XFRM_MODE_TUNNEL ||
>  	    attrs->type != XFRM_DEV_OFFLOAD_PACKET)
> @@ -262,36 +264,31 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
>  	mlx5_query_mac_address(mdev, addr);
>  	switch (attrs->dir) {
>  	case XFRM_DEV_OFFLOAD_IN:
> -		ether_addr_copy(attrs->dmac, addr);
> -		n = neigh_lookup(&arp_tbl, &attrs->saddr.a4, netdev);
> -		if (!n) {
> -			n = neigh_create(&arp_tbl, &attrs->saddr.a4, netdev);
> -			if (IS_ERR(n))
> -				return;
> -			neigh_event_send(n, NULL);
> -			attrs->drop = true;
> -			break;
> -		}
> -		neigh_ha_snapshot(addr, n, netdev);
> -		ether_addr_copy(attrs->smac, addr);
> +		src = attrs->dmac;
> +		dst = attrs->smac;
> +		pkey = &attrs->saddr.a4;
>  		break;
>  	case XFRM_DEV_OFFLOAD_OUT:
> -		ether_addr_copy(attrs->smac, addr);
> -		n = neigh_lookup(&arp_tbl, &attrs->daddr.a4, netdev);
> -		if (!n) {
> -			n = neigh_create(&arp_tbl, &attrs->daddr.a4, netdev);
> -			if (IS_ERR(n))
> -				return;
> -			neigh_event_send(n, NULL);
> -			attrs->drop = true;
> -			break;
> -		}
> -		neigh_ha_snapshot(addr, n, netdev);
> -		ether_addr_copy(attrs->dmac, addr);
> +		src = attrs->smac;
> +		dst = attrs->dmac;
> +		pkey = &attrs->daddr.a4;
>  		break;
>  	default:
>  		return;
>  	}
> +
> +	ether_addr_copy(src, addr);
> +	n = neigh_lookup(&arp_tbl, pkey, netdev);
> +	if (!n) {
> +		n = neigh_create(&arp_tbl, pkey, netdev);
> +		if (IS_ERR(n))
> +			return;
> +		neigh_event_send(n, NULL);
> +		attrs->drop = true;
> +	} else {
> +		neigh_ha_snapshot(addr, n, netdev);
> +		ether_addr_copy(dst, addr);
> +	}
>  	neigh_release(n);
>  }
>  
> 
> Thanks
