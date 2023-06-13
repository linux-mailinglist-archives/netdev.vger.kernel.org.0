Return-Path: <netdev+bounces-10385-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B59472E3CA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 15:11:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AC9D128122F
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 13:11:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1662F2721B;
	Tue, 13 Jun 2023 13:11:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0258012B77
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 13:11:09 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87099127
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 06:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686661868; x=1718197868;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=IT/PxfKgVCdkUdkjLaGS6xYe0g4pIc56do9ToaJTKE8=;
  b=a2fFK/jjh0AuF0lt/Cx8i2+aEsmzvhzeRAR41ahu5+F9oq+6P0AUV99e
   pIoarRCGAN+kVdXZYI3M2Ro5aK/RcgAkBpTTpLIkRdN7jU/M9EpYd1KCB
   Hblj3DI9aQXRVBckPL3E3tLVKL8Z1DTHtsJfUvU3mXEO55OxL4qj1rxWY
   xR2UPXi/OndvxG0SlzLoe9YZgqvu5N2bsqsvOmJOJS84A3CTCQ5w95+M8
   55eauP3cWhxCxc8x2VsTc5C6Pb+aIojCJ8BuoS9QFxVWkZyKuW2TSLDmW
   vJ7OIxa5wJvahLSrtw6xTaLkzcP0CI0xXIwNsD63BD2y010PRbqRHg7IU
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="355820413"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="355820413"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 06:11:07 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="662003531"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="662003531"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga003.jf.intel.com with ESMTP; 13 Jun 2023 06:11:06 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 06:11:06 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 06:11:05 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 06:11:05 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 06:11:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3f8rtq8i4uBDUI+TY364ePU7Hco9dh8F1GJ4j2yJKXiGlsKvcsdTCjjuVKjrgH3rXaBxXZtI219oodWJXB+q5Vigx9tNSXDGoxme1ruavXgYdPp6EOv55uvLqjNxqO9xaehtpbhAxJ2Zd4NoVe6cOZDfqHuUU1xvd1npQz0Tp9iQCb+36wm1qdMviIBURaT95F6OTtrzH7T5xOZ+0mKalnCMS0HC8nwki2EDdU1XXTF4DG4/0MPEHbm9qtAuJybqJiexvbjYAWcvJM75PVBsxg3QD4whp0rKTXqSiSlD/n5IZdYhPgQJuJO8cDVynKAUdQdEBBZx7zs8hn6uwZECg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJQHuf8nQeVO+J/qkXV+5Telna0qw913b2Yd8RuID/k=;
 b=ABzYmi0MvE1ZPrzS2S8sWUIXltqydarBmpME5hgtjk2G6zUpanUthkwmIVBe/rQFlCxSOJlM7HL4DsK6cUcjfhncBIDdPytR7iQtquHGe8XjoSvP5HsUmOKPKak0nDOp+JRilwC2TsX20zllsajevvzfUO4ys87ZTiEvKX2yTtZhW9/88ESsHTDXf5KEcNYHjlycNRoHMDfk07rT4IUI9NdIiE/EWSfZSzcBFNgm6psSKaEs3YT05CAnPBdbaQWEd0QJVEnBw0RGVRl45SIx7G4hjpBl/Bi2ajoXo0SsVv1k+ra5amXy92gePY404P1Ro4GkUz00QHUpjfDrN7nPvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 CH0PR11MB5563.namprd11.prod.outlook.com (2603:10b6:610:d6::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6477.29; Tue, 13 Jun 2023 13:11:03 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 13:11:03 +0000
Date: Tue, 13 Jun 2023 15:10:56 +0200
From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To: Piotr Gardocki <piotrx.gardocki@intel.com>
CC: <netdev@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
	<przemyslaw.kitszel@intel.com>, <michal.swiatkowski@linux.intel.com>,
	<pmenzel@molgen.mpg.de>, <kuba@kernel.org>, <anthony.l.nguyen@intel.com>,
	<simon.horman@corigine.com>, <aleksander.lobakin@intel.com>
Subject: Re: [PATCH net-next v2 1/3] net: add check for current MAC address
 in dev_set_mac_address
Message-ID: <ZIhq4Mb7+jGxIdAn@boxer>
References: <20230613122420.855486-1-piotrx.gardocki@intel.com>
 <20230613122420.855486-2-piotrx.gardocki@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230613122420.855486-2-piotrx.gardocki@intel.com>
X-ClientProxiedBy: FR2P281CA0100.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:9c::14) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|CH0PR11MB5563:EE_
X-MS-Office365-Filtering-Correlation-Id: b59ad8d0-9d9b-4686-5373-08db6c0fa389
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rGkKR2w0Kt75L7vN4yj6K7/CznCsk1fZtKxoZcYFmu8dn/b9Vj9EiSye0cfGe3FczzHrFMvFuc4mFaREJ+mbt6rmPxaW5+5z7U0UhEUQ/pKeRFYHEX/F9OspMYikL6pviOI935nWXwr1ks40d49AvFvpZJahJRtUv/r3o+NpqqXwaNfzjMgAbuNSCJFjLKF8rVqpiduWJZ17M+VD7U84Vp7S5uY6cUxGjZTyja1cJazuCE4n63Nb4kpz5s2TpbGCMtVkuGuE07iWI/Fi5vdncwQ2Z9487StdwUvThlZyu259xY5tJdPxOGib61a3vlgGaDc1IAEb8ORtZgF7EAcXCw2wZtRiTNX4dEUs7K08G9pBhirhqc3BWtak/eShzoEUqN5+A9qtq5zzV3jAqQ3Oe9mYjEfksc7353z58iTB6EeD73rmWmsRo0/YeOVKvZzo4IakliN/H4VP7dcojSPDvJx63gAKDbLsZaVSRgk45c8yUgu0D+iw5vn6Vu8gl2bU7YIfTExNfiBBvbWpKkL+P7SI5s8uBXSohtQEE+6z5uyMutLviubj8iELws/spqi5HDpvJRqfcw6X0Mn+DBGYy2w5P8fMY/XrV96rJGUmIOU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(39860400002)(366004)(376002)(396003)(346002)(136003)(451199021)(83380400001)(82960400001)(86362001)(38100700002)(33716001)(478600001)(4326008)(44832011)(6666004)(6486002)(8936002)(6862004)(2906002)(8676002)(5660300002)(66476007)(66556008)(66946007)(41300700001)(6636002)(316002)(186003)(6506007)(6512007)(9686003)(26005)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fe6g1Tf3OmwsNCNT2Oenkj74fNOYyZ0dYhXlssiK3stF7vp/2kwGLHWwnzzw?=
 =?us-ascii?Q?U728j8gHxKZfWcYu9n1X8QB/T7/nWY+abCw4d1NKfkYbSrEBZYTBqYDqyrwY?=
 =?us-ascii?Q?IZqPdKuB8ljZbNpYL0q43sZ+qMGEUelcb+fTjjtDjUPIR2KCRGVgYzzS+dXf?=
 =?us-ascii?Q?VutDgjbTjZwIU5oiTTymEKXTpu0lMGnuYmV9UYz20YPowkHC9JOXTEOPqVvh?=
 =?us-ascii?Q?JgAmzAXPWp//VMkj0vi4kq+MEVVCRwAxPGlKhh/+yGhc/nqBVdg1SERkBWNw?=
 =?us-ascii?Q?jeqlgcneTgXlZvbdESSngP72Pt3Uh/TG2Fn/nFuwol7jP0m2h2by0rCM3ovJ?=
 =?us-ascii?Q?qRpH2ZTX4xr/3R+Y6rDzgf/4684dhxOX5M9Bk6HOF9nIVsFKz+IOf7oaU4rw?=
 =?us-ascii?Q?20cE2HhMY47vpvu1vrZRPndsNmrNaZDWjuGR4GPbyUz2MbvtrIzaoiUyAjXa?=
 =?us-ascii?Q?DqfvuOkbXtS50mpa7GPeBeVKMlE2CsFTBqUhoPGfqYF4UD51dZ4OATDi7nA/?=
 =?us-ascii?Q?GKVWhZknc0H7bOTFQGIjwdZ82XvhXrRPOnHCYHDFR9G1qyt+eOqR04psY81p?=
 =?us-ascii?Q?/GylwIp6BXxhfh/LcweWQBNE+cxSXkHOKMRiFi8+nF28UsBoJfkrt33Ugs0c?=
 =?us-ascii?Q?oM9KMEqDM3ITCwBlZl/QturT+W3lIsw2fraD3Gt9ZYg0jy/fwy7ec2CLkm4M?=
 =?us-ascii?Q?obQfOglqJDWGcfsCi2ltanTFLxsZR2LL2Wq9LL/81I9dgNdRHhlT2TO+wPN3?=
 =?us-ascii?Q?cNf17RS4K9bp0vYkXSUWeMWJAK7wGjhZ+01k+S7YIHDbRZh94jnbK2NaUsxV?=
 =?us-ascii?Q?zNAnc3/8x/g0pSo6QZedW4oI7drWGKW4cpzPnHcCRuXoVMO2YdP03jvbtzQm?=
 =?us-ascii?Q?J4EIqbz3lhbrlf5Hsm16EsB0IbDh6CZufCsRNzjz1C3/f15rPM20+jQN6MWl?=
 =?us-ascii?Q?wfv3Hq+E569tDOxj16KdDu0AY/n+ueqOHZzXClAd7ofjzyC32CoI/0x/x55r?=
 =?us-ascii?Q?9KodsO1haVrylHL2wMGff0TnItcjHB0roZzh0z2To6mgCFif6+HGv/uMH0gn?=
 =?us-ascii?Q?54pfcQtf2CSMn/eZuPtGz2H1rpwTdyjkcW4c+QnfI1IseVq1DRPbk6CnLnUr?=
 =?us-ascii?Q?T5EY9aRx4AxlTUVz1IY3BwDPVHIYEIje7bCULvkX0/e+3ZECxtc0bJuDyX00?=
 =?us-ascii?Q?gXeo6dfQyxiyZ9Tno9pDWL1KsIhuhLAEQ2CogLodWlYvOsq4LxRjUlL0Te4V?=
 =?us-ascii?Q?dY8BzQh7AAZx5OeVjTdMiYDKgYu4WnJe3rKDUyx+jzY3QBQI3LQvCrOu9AoU?=
 =?us-ascii?Q?Rsxwe3WS038z6x3IKlqKRzZe9yupmAm8//WQel75LtAcfNipsUCR8E6jf32/?=
 =?us-ascii?Q?3DiFJOhCWM1Aoiqgiypl8nT+hWsfK7403pigxE6qSLaAzUHL1wTWN4eMBwRC?=
 =?us-ascii?Q?1ySvt+vJllRHwh65EtZzTKDWyOX365hb2rVZRiyj3v+Up4P0z9hD6iXOr01I?=
 =?us-ascii?Q?Dezd7vUIEJfgmgU257lvXEpgbqIHpBA23rAOLbGcZpQxH/Ng6VPT0mqTLLrF?=
 =?us-ascii?Q?ap1hVZu1e3HyX6DD9bzS8bqoS38PyJLEc9/WiSScJoQ7WhW8oB4lhIB1IkTF?=
 =?us-ascii?Q?2A=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b59ad8d0-9d9b-4686-5373-08db6c0fa389
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 13:11:02.8459
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IB5YAEacW5CxbVuanQh8dOyMfQq2nIdbg7dmF1QLy23SiACNi7XrdTqDwTjWVN11ZF7BUwnAQkMTnhiAzftdb9j1jAgJFZQXGpxeuVDtuYc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5563
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 02:24:18PM +0200, Piotr Gardocki wrote:
> In some cases it is possible for kernel to come with request
> to change primary MAC address to the address that is already
> set on the given interface.
> 
> This patch adds proper check to return fast from the function
> in these cases.

Please use imperative mood here - "add proper check..."

> 
> An example of such case is adding an interface to bonding
> channel in balance-alb mode:
> modprobe bonding mode=balance-alb miimon=100 max_bonds=1
> ip link set bond0 up
> ifenslave bond0 <eth>
> 
> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>

I'll let Kuba ack it.

> ---
>  net/core/dev.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/net/core/dev.c b/net/core/dev.c
> index c2456b3667fe..8f1c49ab17df 100644
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -8754,6 +8754,8 @@ int dev_set_mac_address(struct net_device *dev, struct sockaddr *sa,
>  		return -EINVAL;
>  	if (!netif_device_present(dev))
>  		return -ENODEV;
> +	if (!memcmp(dev->dev_addr, sa->sa_data, dev->addr_len))
> +		return 0;
>  	err = dev_pre_changeaddr_notify(dev, sa->sa_data, extack);
>  	if (err)
>  		return err;
> -- 
> 2.34.1
> 

