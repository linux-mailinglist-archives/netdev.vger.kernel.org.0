Return-Path: <netdev+bounces-10434-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 111FC72E6EA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:20:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A0FC2811F3
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:20:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE8D33B8B2;
	Tue, 13 Jun 2023 15:20:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB29B34CED
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 15:20:36 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3412A10DA
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 08:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686669635; x=1718205635;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IgbmkfuwWR1kT4isqTWhqZXq0TDPxqSzQuKQ6BAj64o=;
  b=DltXcmKPEBiCH6MyX6IWXb/EtVS+7DJ5X7MLofNe394rLFQK9HjO0sku
   +fQt++hekyfjEB2K88/OQudWaNbzdAGn/IE+IpUILsZcATH+Quf978YDM
   ggT+zb1SCMuH1ozoAMT+FjHwVfYIoZD4bMQN4MyFgEw0P4S+AMTBVL3Pg
   wWHf29Wrf5XEm5dIDLfT3mPgZJFIo33YrNmOF+3nVc/dn49MNfi7KMqf8
   TUZCDnUEIdksFXq4IaFKRBa8QynWhWK7mowIVjB1DcBKo1FD6FCgi+j1X
   YjU+Bw47Mj1Mnzm3UpaYLxOiJDKpzO+xv5aGBt3ecd1tsfVVSjZBS/zg2
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="444735854"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="444735854"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 08:20:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="662047097"
X-IronPort-AV: E=Sophos;i="6.00,240,1681196400"; 
   d="scan'208";a="662047097"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 13 Jun 2023 08:20:34 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:20:33 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 08:20:33 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 08:20:33 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 08:20:33 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CVwH++wyDorcfXkkHjBaGi7I5RtAIuszgYI/n4HaVEi2F/god1wJ+YJxCzSxJ3rfff4JybQ+VEvdA0wtz79NhS996bOCIwiHjKlffQs7ChDQYJ/UlsfniZBG7Js3Qet2s5TY1jE71V7ENcSNyP7+/dbemC5d/oRwXgOHBkfFYCgeolixCR0Gq6FSs7qUjlL5aoZrVcxtJF3sj+KvhWHUR1irINNKta45O4rq79GBaU7RfOQqsASX/CyFsAWNre54ogInz1VnVejCJZB47ZPJ5eNR4IRDrDKRAXaejwQtdFp/SRsaUqJkm2Chw0EDJQ+XRZcY9anmAD6DWQihwIeqtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DHpcspzRTAJYhxdrjDD5ph3zN5+LnFWTe41y3+/lBAY=;
 b=nMs5yl5Y/ljsORPJO/Y9ANCZVxmjN0akMVq0ZBlCzrs4P12tfQVmEV66QHrFT9hWiIAqiqf72+lSog0sJcGAILCWtKgZUzqj7T9GUW9UA5HXmtAS0Sf7n5SNfIgj7Y0QOA8wb28zNNG7XjBjomF0SQBoY2WuHy5PUnXl483UYHGNTuk7xWb+zh94cooAHc6Y3cKlHN+Y/KgrG2XM1y5/QdSlsv24B5Vt5z4FuL9vgSUd8syCAFM6bAa74dc0XKe4u0+OGCPABJ9JhR/YyLzsAgR773i7NgYq+/NbpeEFZ1dw6YLJBXHRZy8E9rQzWh8LlfsuB19q070z61aC+d4ztg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SA1PR11MB6735.namprd11.prod.outlook.com (2603:10b6:806:25e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.39; Tue, 13 Jun 2023 15:20:31 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 15:20:31 +0000
Date: Tue, 13 Jun 2023 17:20:25 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
CC: <intel-wired-lan@lists.osuosl.org>, <netdev@vger.kernel.org>,
	<anthony.l.nguyen@intel.com>, <fred@cloudflare.com>,
	<magnus.karlsson@intel.com>
Subject: Re: [Intel-wired-lan] [PATCH iwl-next] ice: allow hot-swapping XDP
 programs
Message-ID: <ZIiJOVMs4qK+PDsp@boxer>
References: <20230613151005.337462-1-maciej.fijalkowski@intel.com>
 <9eee635f-0898-f9d3-f3ba-f6da662c90cc@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9eee635f-0898-f9d3-f3ba-f6da662c90cc@intel.com>
X-ClientProxiedBy: FR2P281CA0171.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:99::16) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SA1PR11MB6735:EE_
X-MS-Office365-Filtering-Correlation-Id: 150c0cc0-ce75-441e-9003-08db6c21b9e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G1wA3Hxq9nYBGNsIlvPZZzoIE7ZlhnSvOdcAiUBIXVveuMAGXo6bC7Ytrmg8TSFr0VVNe6RNacywjiZojpg6ATp4nL9A6Dr5rqOePsPg8gGvLYCQ4GPI7ZqdgvnqmFSQfXEEVQowJuLa4ElxBgIkaBh0qdZVpRIt913qAl6xOtZo2y0hiMp6rPADDfOJ1UTFhh92/E0crxYPm6k9oWL8Tw2RBdJNSIqpojRztdVv/CfUR5Q2rekQ10G1vg4iwbaxcBZNUxehkNMx32oLc73AjGijhVPb2HGAPQQPY1iKqJRhYRGDjTfexfJzzp1oCdqcsMVXP+3udUgTC7Ogq/de6MZuFwhyb6zoiP/8Yd60hMbvXdgk8Jy++nJZXnybB6EQ0D9S+iMJXNlpX52uyHJzzitJfvCqC3EkpyS8uBql1awu8rP271HlHq5TWyMqKI2Wmk/YqGP2KJOhKAzo0R5GO6Fy2iygYw+wM9UZaTJI/1TKa9nFHWR6EgQqjl4ns6FoZxPMGsfKPbkb1OLC+FAK4tCGgIXzqeXD2EmlYImoJqXMSVsJ6EdxHMD7p9tc3X6FosGw8Pxi44DhF4upLppD7PTPLrEluEc7/3yEWbLhSqvcvJCi7q4OAuIzQuBBHIRNNunlnGVtyaKb9zPGH7mYgqzXbqNPl2R+X6qW0fIdsCM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(346002)(39860400002)(376002)(366004)(136003)(396003)(451199021)(316002)(966005)(6486002)(41300700001)(33716001)(186003)(83380400001)(107886003)(86362001)(44832011)(26005)(6506007)(6512007)(2906002)(9686003)(82960400001)(38100700002)(5660300002)(8936002)(6862004)(8676002)(66946007)(478600001)(66556008)(66476007)(6636002)(6666004)(4326008)(67856001)(309714004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vJscERReCVn8Ubku7PHOzvpXqHk9AW/JV+58+st/3HzsaDteBJ6Mcu8BOJ5X?=
 =?us-ascii?Q?3nVb2TjaOpLcNFGaRcpC7u+Y/6oSMAXZVKE0+ibB/eQg7kQEnq/surCCIafC?=
 =?us-ascii?Q?VR7aOhi9CC0X1/69rPoZn/rfDrwUJkQwTw/D1Oegpo5MUOJ/YU0DUsd1NA/X?=
 =?us-ascii?Q?vn1XBqWiR/8R08eS1fgsIH05C7czdggsv5Ufx1kKZAm+X75m3EhGCdePDg83?=
 =?us-ascii?Q?Q8L6Mw8X5l7/96YxRSchZSvA++xvPx+233vInl8Femz2LDofdqe1nANOnbeG?=
 =?us-ascii?Q?jxDgdw8M6alrsQp638iMZz/bfggr6AWeDiXIXQsQU2imfYPG8/pAVPQJClsB?=
 =?us-ascii?Q?TVPuDWpaVSkImoGPOQAeAc8sg6QEM5xlW1L9M77AYuePC8xfTb72eIKjd4Gv?=
 =?us-ascii?Q?uJ2tOgeR1+AGdMQzniuRylq62r025IEEHRluW64ltn/8ta9a7LVPGFM86k3f?=
 =?us-ascii?Q?qMOtZ37M04GUvu0nKm4n8nyDCNOtseFY+kdBZIEi9mFwyPqiyxbvD6MzjOey?=
 =?us-ascii?Q?/EjDUEO/wqTZ9RwlbsBcroydpQMQ7m0dQZzBMwCh7T69HBD24Zm41INGxmTt?=
 =?us-ascii?Q?dPBmar30VcAswsJBYgJOs5NrL40VaMIyyqsTsjnkQFkAkraBRQLxOPSNN6Rs?=
 =?us-ascii?Q?rEXyFa/l50svkZ8zMVwdtemwp6WP/fwV3D+GKBHEwjvZehSsT2l6BSIHJBWi?=
 =?us-ascii?Q?qd+GukUnm2kjltppLO6r8M8A7eEWTT3supdQiG2IL4mNS7DCDFFkQYrUhvhR?=
 =?us-ascii?Q?87ax0Zb8+JtMPExELNKaFGzp6Q9AMbXILSOyeuWfnRQpR0+wLX+VNPANjxMu?=
 =?us-ascii?Q?ETMxOLk7OmPB2IN3UU8BuQXEtV1azeVctzJ5TMCRP+e0LjXrk6/5sgC0RIAB?=
 =?us-ascii?Q?D533aFtMNbAF/GhuEyPcdBJGOAEuVN9JfgNHhKMjF9kDBllZWiRTvLaqACAE?=
 =?us-ascii?Q?krkTX2Fwku5Ma6zDoXzUJDkloGO8+QR0vEdvv7XHEDlGcdKaHKuigW924e1c?=
 =?us-ascii?Q?cubVzEUxVlRb+IKuaq+w5xm8gaffK6qwD7Ka11pQ+lklrzFB0kK/IdOYzl7j?=
 =?us-ascii?Q?MVVAZQVgrE3Rnud6Qsjg8v+MfEuy5SpJHUSfZALx3VQ1ahKOet45MKgBVUCl?=
 =?us-ascii?Q?pqIfwf8ImiE2fqeckvh5LnS8k2tSGFxayfesMERF3RIEVKdMsDAqi66NWHbB?=
 =?us-ascii?Q?TSW9LutXPYUzqL6pBdkEU6yGqEWyf6J8Tn3oRrb7NqKX20eZzr4oo9UuFG/C?=
 =?us-ascii?Q?Y98nUzabotU0cYYtcYihY1/ODbA7PFbzGBFDtoSt96j8YoTO+wIBPf27Qtt8?=
 =?us-ascii?Q?eW/yDr1FmoJWCXVZVXk9qXOa+BYBXqAy58gdhucME40w18rxLS7H2EILJfOV?=
 =?us-ascii?Q?Ef4XAf2Hg6upBvrmSAh4rrLGdhU+tfVZVhmzgDPtUolsgBCvZkJp+bV0MDbC?=
 =?us-ascii?Q?TEHPsrUFUjeHI3jpMSfz3P5y28JqA+537E+GrtD8eCmNrrpFqRiQNUgx4Tcu?=
 =?us-ascii?Q?O9xcg6XJt0wExBh+mehpsYZ2OLiX8F3gau680DmazfpJd1ZVElnDZB0DY8eZ?=
 =?us-ascii?Q?E3owI445VrVsd82qeHwReMffMrZg/lNhVl2pAaEg0IaFstbXV72qXGqQWo7p?=
 =?us-ascii?Q?kA=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 150c0cc0-ce75-441e-9003-08db6c21b9e9
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 15:20:31.3304
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1FJmxQUHCyCNBmlhmkFgotcK38L9WppcCeVEhBh1vr/uLnokZV8L/JFx/yRrXhZmaYGpgoiaW/NDD7oCfEVaL3eKf0xaEj9XbBJ7Vaw+khU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6735
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 05:15:15PM +0200, Alexander Lobakin wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Date: Tue, 13 Jun 2023 17:10:05 +0200
> 
> > Currently ice driver's .ndo_bpf callback brings the interface down and
> > up independently of the presence of XDP resources. This is only needed
> > when either these resources have to be configured or removed. It means
> > that if one is switching XDP programs on-the-fly with running traffic,
> > packets will be dropped.
> > 
> > To avoid this, compare early on ice_xdp_setup_prog() state of incoming
> > bpf_prog pointer vs the bpf_prog pointer that is already assigned to
> > VSI. Do the swap in case VSI has bpf_prog and incoming one are non-NULL.
> > 
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> [0] :D
> 
> But if be serious, are you sure you won't have any pointer tears /
> partial reads/writes without such RCU protection as added in the
> linked commit ?

Since we removed rcu sections from driver sides and given an assumption
that local_bh_{dis,en}able() pair serves this purpose now i believe this
is safe. Are you aware of:

https://lore.kernel.org/bpf/20210624160609.292325-1-toke@redhat.com/

?

> 
> > ---
> >  drivers/net/ethernet/intel/ice/ice_main.c | 12 +++++-------
> >  1 file changed, 5 insertions(+), 7 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
> > index a1f7c8edc22f..8940ee505811 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -2922,6 +2922,11 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
> >  					   "MTU is too large for linear frames and XDP prog does not support frags");
> >  			return -EOPNOTSUPP;
> >  		}
> > +
> > +	/* hot swap progs and avoid toggling link */
> > +	if (ice_is_xdp_ena_vsi(vsi) == !!prog) {
> > +		ice_vsi_assign_bpf_prog(vsi, prog);
> > +		return 0;
> >  	}
> >  
> >  	/* need to stop netdev while setting up the program for Rx rings */
> > @@ -2956,13 +2961,6 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
> >  		xdp_ring_err = ice_realloc_zc_buf(vsi, false);
> >  		if (xdp_ring_err)
> >  			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Rx resources failed");
> > -	} else {
> > -		/* safe to call even when prog == vsi->xdp_prog as
> > -		 * dev_xdp_install in net/core/dev.c incremented prog's
> > -		 * refcount so corresponding bpf_prog_put won't cause
> > -		 * underflow
> > -		 */
> > -		ice_vsi_assign_bpf_prog(vsi, prog);
> >  	}
> >  
> >  	if (if_running)
> 
> [0]
> https://github.com/alobakin/linux/commit/5645adb0943dabeadfb9f6d00202c78fb9594fbe
> 
> Thanks,
> Olek

