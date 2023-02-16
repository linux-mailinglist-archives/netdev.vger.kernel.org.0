Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15846997B1
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 15:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbjBPOm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 09:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjBPOm0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 09:42:26 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691B24D624;
        Thu, 16 Feb 2023 06:42:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676558545; x=1708094545;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=E763QYx1e00ckH5JbQpIiZZm8Tqm9zM6gDIVMl2enKI=;
  b=PfwiFhKH1+0+1MVwFrRb60QDjEq/P7cmaQZ2pU1Nd8ZvvfNM72xNJzy+
   RU9i7Lz2fexYbaixkR1pn935M2Y5e8buW6wQnPZTUpeMbg9XzOhMw+1bB
   ELkm7cmLuI7kuEvGtTldx4RBQqjDskfvqEgftsFWfGOLK0eJ35T+5jK6n
   8iWqONCq+hPa1DsnzJBR7lKxbJmILTXPjaLZoMyOfsToUCwM6WOmW0Fa1
   MmuvQa5sbC6XuushlzJbFv7mIi1j7irQDHRpiwC11wdzzLNO3fJnGWopB
   CX5lxmLBFlR+hrjPdv1/CQ4WI9l8szVAeGYpigwczuZGAIDAQf2zSZP77
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="331727567"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="331727567"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 06:42:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="999056689"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="999056689"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 16 Feb 2023 06:42:25 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:42:24 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 06:42:24 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 06:42:24 -0800
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.47) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 06:42:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AHW2c2nOQ28PxQef3OrmGTMCHQCqfBZKpJE8Cvjy3pRcVk2pkwyisJ31OPN+vMcbHp0OppHQGGMxy6Dw7wSBT3hltBVgiisipImllgHn7ZcBSYJBTpl+VffmtZjO+1wHP5z1oZ0+BJ7W9YfenaIkVxIxnC4Ul4YQBJCUgWjJAz/TY6GxzPZiAzm2HFhFuM7VymlAvd7RgO701cmtfRgiUxh/YQjCvDMCIL6fDo4ZKsL4RjYDoBMGM8sJb2QeuAppn7MqgV5QRhDYTrwuaAaSVkFLa19/2bv/BCI8/Q5rg5G0vSqx2V3yKDigQ7Z+RRoSlxk8iQ7Y8XzY745EY9NbGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4dgfqt084mMF9lj6dEfiKFKUaoT89Z++rELU8cmjbM=;
 b=V8vyo/ei9n+cX/kiPjE/XsFyv54honTi8fq8m7d9CpRO869gDETPuLtJvI8TuVIlJ2l0gP095LRTKOqeHg3ao5N8QHMJtayR2c1GUHUOq0LEEzK2r3vkKbeUJulp9F6HacRq2owm12CnfbDF4PaysAsSKUr71z1/dyPSnr0/01bazPu50QZGbpMMIhfgcBCCc3k/3zvtJdUcvuQeRKcIJgatB3ZiGgwAdLbI1gtTI8/CWqm+FMBP7XU3MJcpO76dZ5rtlnBPEXmWSoMOEuNXwFdzy90etmFyISjV+I3Rt2F3I3S5cH++eEP+MyKkyTo41Ba/ldux584v+s9wwKcSSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 SJ0PR11MB5181.namprd11.prod.outlook.com (2603:10b6:a03:2de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 14:42:22 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::39d8:836d:fe2c:146%6]) with mapi id 15.20.5986.019; Thu, 16 Feb 2023
 14:42:22 +0000
Date:   Thu, 16 Feb 2023 15:42:09 +0100
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     Tirthendu Sarkar <tirthendu.sarkar@intel.com>
CC:     <intel-wired-lan@lists.osuosl.org>, <jesse.brandeburg@intel.com>,
        <anthony.l.nguyen@intel.com>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, <magnus.karlsson@intel.com>
Subject: Re: [PATCH intel-next v5 6/8] i40e: introduce next_to_process to
 i40e_ring
Message-ID: <Y+5AwZ5TE3OXQT+f@boxer>
References: <20230216140043.109345-1-tirthendu.sarkar@intel.com>
 <20230216140043.109345-7-tirthendu.sarkar@intel.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20230216140043.109345-7-tirthendu.sarkar@intel.com>
X-ClientProxiedBy: DB7PR02CA0018.eurprd02.prod.outlook.com
 (2603:10a6:10:52::31) To DM4PR11MB6117.namprd11.prod.outlook.com
 (2603:10b6:8:b3::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR11MB6117:EE_|SJ0PR11MB5181:EE_
X-MS-Office365-Filtering-Correlation-Id: 8a25eedc-1df6-462e-96ad-08db102c02ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YUVUTDX0XOBjyUmn4K0nCaTKqWHA3B4QX54OC9mTG59YP0gTUhX65Jnt/msFRBqF3l6BGhYX920UgvOPKqf6KOpfjRoUxvTK/FRDtTMSg9I15rtv4nhPvAI5EKa9UvhqWQrJJNkj3HFOstKp25RD4aHp3KoFfIOIc1QuCZWirk8srQbQhXhy0nOy7tegcWP1lj18/hTvx0GCOzAI3Q39U9rXHeoCxRayCTHEEn+AzHG/RL0a2CzMWDj79GsTfwhsb5NUs3aM1pw1vqEf6YllMHLwM6lEc0dMoAQX0all/R4t54eOtAzWc0/D90MORw6cU52EKWlKyYDWSjiz1H3sO5MqhKrpAt8iGI36s/lVnu22cftnZbLNTHt48gc8fbGx+tiW7ZPlFiH/1MHHcxjhCiR5DA3lCZBdbjH9yTXM++u63K9QWds3jZLHDTqlAk0iDQP6x8vsGb2JU/BEcL5LsCwmo/uZ1CBYrmooCbTm+n9s+azXEUSWLoGs+jhCUgMSa/rQIQt64Rgd8asyBhbUr6+pVU8ycWlhSm7EyNvl9NBXe44vXIw6+2Un+HueA0C4ZGg6gBB/PINQKT3jIW+FAvv2WDI/NeRIeTBe3s0YRNcCZZuJX1Gh1i0dL2tThy7rKOqBVHM3eOSQS0LVqm2uig==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(7916004)(136003)(346002)(39860400002)(366004)(396003)(376002)(451199018)(6636002)(83380400001)(478600001)(6486002)(6506007)(6666004)(6512007)(186003)(26005)(107886003)(9686003)(44832011)(41300700001)(38100700002)(82960400001)(5660300002)(86362001)(6862004)(8936002)(33716001)(316002)(66556008)(66946007)(2906002)(4326008)(8676002)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n4t/Ca9qH/dSsCKfhhAhDsS7vtUudjFGGadPPYvKQwQip8NUgsphQLFl3iTq?=
 =?us-ascii?Q?/yTtxsSnnhokLEB1ShUVr6lx23qXe6tA5H22wVbOxkNsR7Qr2C8M9ZlfcXzc?=
 =?us-ascii?Q?Rfio+o85r+AgbO0cW+JcBQB5cqZMiZJG8pVK0RysHcEcrYFUO1K9J7XsUdMs?=
 =?us-ascii?Q?rzOjX5eHbNiWT7zLe2QR4UsYI+LBYu6CXrlwyk5J85i2pPaJvrB2M1UDYTNU?=
 =?us-ascii?Q?AkXYHy8aPxMKaBYVTvgHGO9Q0+Plbv47/jRXAl1Fn4R+XIKnG9Ek/sJEVJ6S?=
 =?us-ascii?Q?VYyEn7o2RzNWjEJ5ockNms6Rvx1zQbyjny3DiVDDWR4kCITO0eDqq27STmHo?=
 =?us-ascii?Q?Ef4iRBJ9IVxQhTBbpbOIw+k1DLpwaMgGuiUR+qNzD0TCQTZK0DKMWKCqdVZP?=
 =?us-ascii?Q?OMHbchjxJxsiN0Fj2U4n+0z4xxx9U9ukoP1JyQpzjZcG3f1SA1f9iOzAZK37?=
 =?us-ascii?Q?lReHC4XqAf167+UU14ewRptss4Ta74hnawkZXtcbpH0JDS5wnEQfZSMahpt5?=
 =?us-ascii?Q?oKXkJ6aa3trpZB9vBU3Xjey5f6u9r/EeABNVOScMvNTgWh7sFbfqcTcssvR/?=
 =?us-ascii?Q?0oASlan3Yy3zry61O4MfJ3uzupmtqxcGRpxAv42kOn+Hczz4X7aImQt99AAu?=
 =?us-ascii?Q?oZYOZzGB5Z72U6eZALzPK8dR8IY4Wjacp4qla8NdLkTC2SAEsrIaJ7PnByuW?=
 =?us-ascii?Q?A6OjoeW+QaVnm64rO+j0ULM9WhU0FowsnFi3RQuoYJ3Jab5yAkTv3x5yETVH?=
 =?us-ascii?Q?J+zCWvMZGO2wm68vpYnQqqKsLGZyWYLUKM8CaZ1NII9qtRcjKcOAMnmrM34u?=
 =?us-ascii?Q?1CAWcqf17xS0N9kPxMJZGQyEjtxOy7LlOiCvankj1KvBVdG4gsG9ldg43q9h?=
 =?us-ascii?Q?0diExBY0L1z7A4tRio7nGQTubX3jJKbQaKRSinWG4VqdwfIulWQ4fUuC9ni7?=
 =?us-ascii?Q?/Sfrt6d+m4p2FBekKUbYoFd+UzHMj3P1G6WZCa4BY3tu4dLzclDwUn4gOuFu?=
 =?us-ascii?Q?B/xb9CRAXBAioPci6dZVNG3Eu/p6I2FfEOc1UN/mfZJU2w1D6szvWH8UzqTM?=
 =?us-ascii?Q?tI86gLSa6SVH6KYmgZtDJMcktPTHClI32p4fB6URTzHumQEo13NNWKgnlGsH?=
 =?us-ascii?Q?+67cmxBxbdiWJJs00HGbU9TXYfXmKVZNOtNuNgbq9qHXEhTf44tG3Pkn3hXI?=
 =?us-ascii?Q?6SYEzbgFB20DQtM4Sl5MKysL2HKV1mSryLIPOADd9hKTdxRyAF5ZU5vojW/G?=
 =?us-ascii?Q?Il7n1uKsCmhHNNJM3tnPiZqjjQSjP4ACIUS3N0mSBHKHlTP8hB03ejHLvXV2?=
 =?us-ascii?Q?i9trDa2XGSasadx32cF28jPk9tS5nGWxoKriQd3bMOomLPDDq9gAIz50ue7I?=
 =?us-ascii?Q?W6NVYwueGPvUn8Qe+3VkBRG0m3Zm3nstIH4ei0hwnQlH80lAGbKpRuF6PIZg?=
 =?us-ascii?Q?wvPy/DCPCNc2xLa9xDx+vHkuxbwC3SDb+qgK1UDaEa9sKlcsmX2qA/AO3ify?=
 =?us-ascii?Q?kk972QgQWtDiitkvlb89UJLt26LSCcyPPocON9XGUSiFOZEe0expleFTW2yk?=
 =?us-ascii?Q?ooJHFzlLvNOt9OwNu/YSAnh4rFDApp/zCjELPSOzPAvOU8t8ww4NPquj/9hH?=
 =?us-ascii?Q?eZwoKKdhmGPjIL2ryvyAFxA=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a25eedc-1df6-462e-96ad-08db102c02ec
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 14:42:21.8440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WJ64VpZzX1g8rizlHI8yyEFmP7v+/IpBL5ncUh/XNIGePfIjRBAkMAq2AUyAt6pAwBYBjGd9nciaao/gHjooszLY41c0t7318OdPZnQtbL0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5181
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 16, 2023 at 07:30:41PM +0530, Tirthendu Sarkar wrote:
> Add a new field called next_to_process in the i40e_ring that is
> advanced for every buffer and change the semantics of next_to_clean to
> point to the first buffer of a packet. Driver will use next_to_process
> in the same way next_to_clean was used previously.
> 
> For the non multi-buffer case, next_to_process and next_to_clean will
> always be the same since each packet consists of a single buffer.
> 
> Signed-off-by: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 26 ++++++++++++---------
>  drivers/net/ethernet/intel/i40e/i40e_txrx.h |  4 ++++
>  2 files changed, 19 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.c b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> index 01340f620d96..94c50fa223bd 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.c
> @@ -1524,6 +1524,7 @@ void i40e_clean_rx_ring(struct i40e_ring *rx_ring)
>  
>  	rx_ring->next_to_alloc = 0;
>  	rx_ring->next_to_clean = 0;
> +	rx_ring->next_to_process = 0;
>  	rx_ring->next_to_use = 0;
>  }
>  
> @@ -1576,6 +1577,7 @@ int i40e_setup_rx_descriptors(struct i40e_ring *rx_ring)
>  
>  	rx_ring->next_to_alloc = 0;
>  	rx_ring->next_to_clean = 0;
> +	rx_ring->next_to_process = 0;
>  	rx_ring->next_to_use = 0;
>  
>  	/* XDP RX-queue info only needed for RX rings exposed to XDP */
> @@ -2076,7 +2078,7 @@ static struct i40e_rx_buffer *i40e_get_rx_buffer(struct i40e_ring *rx_ring,
>  {
>  	struct i40e_rx_buffer *rx_buffer;
>  
> -	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
> +	rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_process);
>  	rx_buffer->page_count =
>  #if (PAGE_SIZE < 8192)
>  		page_count(rx_buffer->page);
> @@ -2375,16 +2377,16 @@ void i40e_finalize_xdp_rx(struct i40e_ring *rx_ring, unsigned int xdp_res)
>  }
>  
>  /**
> - * i40e_inc_ntc: Advance the next_to_clean index
> + * i40e_inc_ntp: Advance the next_to_process index
>   * @rx_ring: Rx ring
>   **/
> -static void i40e_inc_ntc(struct i40e_ring *rx_ring)
> +static void i40e_inc_ntp(struct i40e_ring *rx_ring)
>  {
> -	u32 ntc = rx_ring->next_to_clean + 1;
> +	u32 ntp = rx_ring->next_to_process + 1;
>  
> -	ntc = (ntc < rx_ring->count) ? ntc : 0;
> -	rx_ring->next_to_clean = ntc;
> -	prefetch(I40E_RX_DESC(rx_ring, ntc));
> +	ntp = (ntp < rx_ring->count) ? ntp : 0;
> +	rx_ring->next_to_process = ntp;
> +	prefetch(I40E_RX_DESC(rx_ring, ntp));
>  }
>  
>  /**
> @@ -2421,6 +2423,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
>  	xdp_prog = READ_ONCE(rx_ring->xdp_prog);
>  
>  	while (likely(total_rx_packets < (unsigned int)budget)) {
> +		u16 ntp = rx_ring->next_to_process;

u32

>  		struct i40e_rx_buffer *rx_buffer;
>  		union i40e_rx_desc *rx_desc;
>  		unsigned int size;
> @@ -2433,7 +2436,7 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
>  			cleaned_count = 0;
>  		}
>  
> -		rx_desc = I40E_RX_DESC(rx_ring, rx_ring->next_to_clean);
> +		rx_desc = I40E_RX_DESC(rx_ring, ntp);
>  
>  		/* status_error_len will always be zero for unused descriptors
>  		 * because it's cleared in cleanup, and overlaps with hdr_addr
> @@ -2452,8 +2455,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
>  			i40e_clean_programming_status(rx_ring,
>  						      rx_desc->raw.qword[0],
>  						      qword);
> -			rx_buffer = i40e_rx_bi(rx_ring, rx_ring->next_to_clean);
> -			i40e_inc_ntc(rx_ring);
> +			rx_buffer = i40e_rx_bi(rx_ring, ntp);
> +			i40e_inc_ntp(rx_ring);
>  			i40e_reuse_rx_page(rx_ring, rx_buffer);
>  			cleaned_count++;
>  			continue;
> @@ -2509,7 +2512,8 @@ static int i40e_clean_rx_irq(struct i40e_ring *rx_ring, int budget,
>  		i40e_put_rx_buffer(rx_ring, rx_buffer);
>  		cleaned_count++;
>  
> -		i40e_inc_ntc(rx_ring);
> +		i40e_inc_ntp(rx_ring);
> +		rx_ring->next_to_clean = rx_ring->next_to_process;
>  		if (i40e_is_non_eop(rx_ring, rx_desc))
>  			continue;
>  
> diff --git a/drivers/net/ethernet/intel/i40e/i40e_txrx.h b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> index 3e2935365104..6e0fd73367df 100644
> --- a/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> +++ b/drivers/net/ethernet/intel/i40e/i40e_txrx.h
> @@ -338,6 +338,10 @@ struct i40e_ring {
>  	u8 dcb_tc;			/* Traffic class of ring */
>  	u8 __iomem *tail;
>  
> +	/* Next descriptor to be processed; next_to_clean is updated only on
> +	 * processing EOP descriptor
> +	 */
> +	u16 next_to_process;
>  	/* high bit set means dynamic, use accessor routines to read/write.
>  	 * hardware only supports 2us resolution for the ITR registers.
>  	 * these values always store the USER setting, and must be converted
> -- 
> 2.34.1
> 
