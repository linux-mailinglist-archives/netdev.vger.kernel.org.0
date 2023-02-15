Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9BDD697EA8
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 15:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjBOOp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 09:45:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229871AbjBOOp6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 09:45:58 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A66D839B9C
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 06:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676472357; x=1708008357;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=xZ/9dHHKG379DrI1wRdoFIb4hjFAxTArfX064joFhbU=;
  b=OM2zkXlToq1OmL9neifxkRWh9D3e5izwRjQwGkH+jtDN97uW5UdGQMwr
   QKbimupCwcu1hJW+X712oApi/+p5D/Zq2DBDAR4aBB8DsSJfO9nCDwfB9
   xbcT5z/OElQ9PhRWL787XNrNBUDkD0cioGSkhC///2lrJxAA1FCvO9SY4
   iu38x6n5WIRiKbU+FUbIvqfxLaV4zhagFfxxlnwSnB5fjIhtH0+ETqLn8
   cCe/3h3lV6Mbtux8MImZa1BFYJoQpLqZ9jtmCw5hnYf1CkboRoNfTV9v4
   0CVWuydaUmYdOUUkfGhr16RLH7OQU9IsYH3XpqtU7vPqMQK9El27+xiME
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="393844168"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="393844168"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 06:45:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="669633710"
X-IronPort-AV: E=Sophos;i="5.97,299,1669104000"; 
   d="scan'208";a="669633710"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga002.jf.intel.com with ESMTP; 15 Feb 2023 06:45:52 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 06:45:52 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 06:45:51 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 06:45:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 06:45:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MX+6SmEBWfH//7/rUa3eKmJgcDWUndiiEvolZ4yT/bTjvJLrqMzw65MbNdmMs9vndIh56x3GJAzUY0HWFGKxiEeKEwEZMDdFXSjyzQPi/SMC2pvS2+vk+Ib6U1FG7CpQCfjk5UUm1EbSVzKergjnuXcNk9OgntkyZvTLEUVFSGgJQa9wT51ufZz4Q0zZfSmSrsYgbkbkIAfMi8IoT7GILVR5TFu56hLF2VPVIFEp0J4ggqGLZbnQu7u9oR83BUSRkfMZA0gmEShlvDlvvrXvhdxLj+YAVkGPTR7a+LbYIejqsnyFTR0hIQKUinB9VV7GXet0N0YZN0NJ5hPNA3Dc7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uDcn3zWPIp4eknSFhFTkT36h3F8yTIBFggC2fHdgy9s=;
 b=E+4EMS6nkfolx+JqQRm/CAAFjnZF8Ae6F5S0kK9v4PoOMLh5CRfwh3i/PzGJTeJ5XUJ8gXkR5YCOIHTixjHbWaLnERm0g4XT8XuXuSaiEGxVJ2vnZRaU/ayeCrzPaswMsxPv6NLvRXI5iS3VGWMSdywveUGWg8Hf8zrARycIeErw/bUV7p2jollOM40tLD5+3e6tfS8WODnSrEL/NpBGWEfm/dJ1sIA5DhcEt0YVixIz5NrqcuJroYYlwSh+GeBVbhd+LZTpJ6kZq+vH7hjm8x/JqwagnyVBcPEX9AgvnvB7bYLnXQ6+tJdas9hrp/114wXeG0ttEhCrJ1wutvVX6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB5471.namprd11.prod.outlook.com (2603:10b6:5:39d::10)
 by CY8PR11MB7242.namprd11.prod.outlook.com (2603:10b6:930:95::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Wed, 15 Feb
 2023 14:45:49 +0000
Received: from DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9]) by DM4PR11MB5471.namprd11.prod.outlook.com
 ([fe80::b7b7:8e90:2dcd:b8e9%8]) with mapi id 15.20.6086.026; Wed, 15 Feb 2023
 14:45:49 +0000
Date:   Wed, 15 Feb 2023 15:27:35 +0100
From:   Larysa Zaremba <larysa.zaremba@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
CC:     <netdev@vger.kernel.org>, <lorenzo.bianconi@redhat.com>,
        <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <ioana.ciornei@nxp.com>,
        <vladimir.oltean@nxp.com>, <robert-ionut.alexa@nxp.com>,
        <radu-andrei.bulie@nxp.com>
Subject: Re: [PATCH net-next] net: dpaa2-eth: do not always set xsk support
 in xdp_features flag
Message-ID: <Y+zr1+AKhdkVxb/i@lincoln>
References: <3dba6ea42dc343a9f2d7d1a6a6a6c173235e1ebf.1676471386.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <3dba6ea42dc343a9f2d7d1a6a6a6c173235e1ebf.1676471386.git.lorenzo@kernel.org>
X-ClientProxiedBy: FR2P281CA0111.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::15) To DM4PR11MB5471.namprd11.prod.outlook.com
 (2603:10b6:5:39d::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB5471:EE_|CY8PR11MB7242:EE_
X-MS-Office365-Filtering-Correlation-Id: 06efc9f9-f0b2-4adf-9f5c-08db0f635423
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yP4uGSS3DaHP0uiagTwZoYiSr43ZAvV621mqsMHXmsGFtqUIfkLT6Cj4nEbA4B0DvPzw+k8CAFosF/P4M3xbMgBFEkdi+1bZqbAKaZXwYBgL87PbWx5iVjgs5KVgfKyisHl4oUru32ttFo/XpKZ/nNTyvVJn+hKmOw9mA4T8rCMLdjhH4UkFWCfMWZfoYp+errzpPLvyBjEh+Ezn53/mUahu+4UHzb1D2Wv+xGtJz9I7XlUz9THaHnaQksXOd0jKvkpnV/8L16y7lya97CwZSk6B+GB71HaF5aRHIui4htEIQdThMWo7PElqi7jpQWUrnUcwLbampmxrX/1FNDQLKWB1UHiOvBeH4Z9EHUDVe1rB2x++LGdIBRP91mX1xgd1NVr20ByYVC8wea5Oyc9R6XkLjudHmyG1fXjED7WZ6pBXaAgz8RcYOuKjXbp6KNLtfnbWmWe/XlBtaDOECgCUeWzoFUfOictEYLXGz6fY0jDOYeGHr0a2MjBxBxGm23HClubENef5GUy+D4tLXv4VOAiDEzbdTguzr58WrL7F6XxWseUyxJ0Mquxk3WDbeSzKIrb6VYNCBK0EjQqe4JndGWvlMQNqgG42pRlhrGcY+/TcAL+bbIjt0N61MXjYDmG/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB5471.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(346002)(376002)(396003)(136003)(366004)(39860400002)(451199018)(7416002)(44832011)(2906002)(5660300002)(83380400001)(186003)(26005)(66556008)(9686003)(33716001)(4326008)(6916009)(38100700002)(8676002)(82960400001)(316002)(66946007)(66476007)(41300700001)(478600001)(6666004)(86362001)(6512007)(6506007)(8936002)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YqIGJzMEzlEGdmIYzwp39T1oPBTeX7nlwMDJq2vERcgwkjYmgSABPS975TJ8?=
 =?us-ascii?Q?Dcb+ctK3gbDvDrDwe70o2srHf5g1KOmopUR1G5enXOxykGPi9BEz/KBIxjh6?=
 =?us-ascii?Q?kmVYyd1++lwSJaHMYc15BIIMDx4C5SxjvUkxDEqgDgaMP7AKurcHoIqD5NkI?=
 =?us-ascii?Q?C03H+41+XXR813YWw8mgDpGGYp+q7Y3RRjbx8TvqBJVd0G9NZOIs720pvDJI?=
 =?us-ascii?Q?X1Ece4+CL7yzonDP0dZ2WjHYWJb7QATToVnxolCrFW6vONkeRv+M/mKOod7O?=
 =?us-ascii?Q?k+27Aj0xR9mgWmQ044jUNJdfr782b0k5k1JqzTM0HEMPhpLIDOQJ7qomHEtn?=
 =?us-ascii?Q?RFJlpQON/19qtY1k+sKnJZI5uVcyIjzjzP9UpKt7LO6mdcc9PKTrME/XLgwN?=
 =?us-ascii?Q?qhVsZ/ykAp2IdfTblAB939mR7RP7e79ch2rid0NTH7vV07osUmB2DPLY+iHX?=
 =?us-ascii?Q?AePS7T7li/AI2jINw/jNAHBRRbTbo/U6NjznCNhd8oyCP/g3NBHVPgwvN3LS?=
 =?us-ascii?Q?wdbkcEugKvFDdoKtuyCZm5px6z01oP7wW/l5mJ77BkYHF7ttoAZejtRDnfBT?=
 =?us-ascii?Q?sqX4/y4ksukgr0nskL4qylrHlfriIpg6LkUV70aR+VOEykRge52K8bDr7rKC?=
 =?us-ascii?Q?C3Bekdrkvqhmw1Z90Jp93CRgI6G/qdQDzmkVysxsGrIfdNiW8sAKQlo5KLsV?=
 =?us-ascii?Q?EJ/a3IjvL1I0emwhJ6tWis8e0XG83uu4pWFX66yTiWDzpxpQVb5TDuA40lyz?=
 =?us-ascii?Q?t9YylvKmhaR6ouqCNBoc94lf0UJuJCSUR7oqYRRiT8Klq5fysE0LIQwxE97k?=
 =?us-ascii?Q?GlTFdq0uvw0IUb4+u8BbcKsqNqmWMIGpxKfEPiDuvd2FZDi1h1Gzk1NumC1x?=
 =?us-ascii?Q?62rrhh8IrHP/2kVt43yDWrfAYnNyIYN7O9KythZnITm4nXc6y9+Em13cAATn?=
 =?us-ascii?Q?t819tc1ZH8dx7rSYSj7MsDVuqAJtayQG6cmCW7ae26zat27rZIB0MbbBxl0o?=
 =?us-ascii?Q?aQHJEKZH2Al8wCu1p436HH7SyXU+kNVP80YSY41AQph+VbTfBxuARjDgVr0S?=
 =?us-ascii?Q?mefkkhJZP1np9slUuMzTeHp6woYka43jZG42YCvaqhhykhs6fuIpFD4ZTxbs?=
 =?us-ascii?Q?z5y4ydBLYNa2+1AAJZLfpnDpP/eNFtIT3q2R1ygddds0B+avTM6Y6DCf/D0J?=
 =?us-ascii?Q?8fjNwCKDK0s2644j3IsQPgdecKeAv6X4u7mzB/rysnp8nBxg72C0ty1aZHWT?=
 =?us-ascii?Q?Dr2zGNRulyeCkcLDquskao+KfUkhEMOT3Vr3fWBkd0zo7r2bA1K4ctH4XgyK?=
 =?us-ascii?Q?JvsWMBn9akcP0efbu/HIXivp293CZoaNDyPmFgKexYAlqKWd4mf6iUEdjTRD?=
 =?us-ascii?Q?ZqI9xc5yJU25cXkmx9ceD6EKLehssU8L62j5PV5gwBZRkZ0AOiw2sl01ckmR?=
 =?us-ascii?Q?HVlWNL31H0dLkXameRx1/w3/bTRI23D9IR6qm8CLfpJmZCBcV6VtDVZ5Y5qt?=
 =?us-ascii?Q?NwND3eJk2lJN02F+87aeeHwhd9u52kKBD1+oCB35R0NevfF1ZW9HjSVTGGKy?=
 =?us-ascii?Q?iENRUpIzK4lhdOlwwKfo8H/FNDYnszhuE4oXa1j9l7/2urKoSY1jicMUqkcu?=
 =?us-ascii?Q?9w=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 06efc9f9-f0b2-4adf-9f5c-08db0f635423
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB5471.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 14:45:49.2262
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hgJra15TiR9Wz972zppsrxq0ookBMRCesG/ta/4DJsjsU07fBMp/t96h3/8FAaXZ0lUnHaffhpO7RFHM/AgtCs9nwoVyVaSAVQiZcSxfHdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7242
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 15, 2023 at 03:32:57PM +0100, Lorenzo Bianconi wrote:
> Do not always add NETDEV_XDP_ACT_XSK_ZEROCOPY bit in xdp_features flag
> but check if the NIC really supports it.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>

> 
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> index 746ccfde7255..a62cffaf6ff1 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c
> @@ -4598,8 +4598,10 @@ static int dpaa2_eth_netdev_init(struct net_device *net_dev)
>  	net_dev->hw_features = net_dev->features;
>  	net_dev->xdp_features = NETDEV_XDP_ACT_BASIC |
>  				NETDEV_XDP_ACT_REDIRECT |
> -				NETDEV_XDP_ACT_XSK_ZEROCOPY |
>  				NETDEV_XDP_ACT_NDO_XMIT;
> +	if (priv->dpni_attrs.wriop_version >= DPAA2_WRIOP_VERSION(3, 0, 0) &&
> +	    priv->dpni_attrs.num_queues <= 8)
> +		net_dev->xdp_features |= NETDEV_XDP_ACT_XSK_ZEROCOPY;
>  
>  	if (priv->dpni_attrs.vlan_filter_entries)
>  		net_dev->hw_features |= NETIF_F_HW_VLAN_CTAG_FILTER;
> -- 
> 2.39.1
> 
