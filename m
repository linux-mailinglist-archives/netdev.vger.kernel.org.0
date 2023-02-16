Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722F5699523
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 14:06:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbjBPNGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 08:06:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbjBPNGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 08:06:22 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D71FBDCD;
        Thu, 16 Feb 2023 05:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676552781; x=1708088781;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BLkY0KeXWnKCGXhPmXTQUY3r+GbzDXgIEAcyxf0+k4E=;
  b=hEDzamr0ksG/D+kbPOcOK5QqRgqzd4wV7hfq0dnqnkeOzzgc14mDt5N9
   F/1kaiVZ/nv+1eYHEt84flFOTzfoUjP2eJwaYmPuR+AlHpI/FuRYKeqTK
   bZlBSPRcyFopRGt60ii/5s3fWq7J8W4l0Wqsj8K6tyKCLv4DV20fr2aFZ
   Bc/tEbJtNs3nwTi15wGBYuFsrE2h4b3XBfd+8OPkh+mVPginou5H54STt
   FPL2mrs4m3JowVNEHJ5wVWvoyo0V35qr5qqeFkxdNxVXXub6Cs5wm8EKz
   +J54c8EggDwKor9WIJHVSgMHvUcH1tcvohemRaV6SobFkGYtKn3GiMHI3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="331707605"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="331707605"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2023 05:06:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10623"; a="672145432"
X-IronPort-AV: E=Sophos;i="5.97,302,1669104000"; 
   d="scan'208";a="672145432"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga007.fm.intel.com with ESMTP; 16 Feb 2023 05:06:20 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 05:06:20 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 16 Feb 2023 05:06:19 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 16 Feb 2023 05:06:19 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 16 Feb 2023 05:06:18 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MHHAwvDRpF3nv5qyAqMALB177X4aDVWH6sZn7A9L4fy94yab2A0d7qucpPNkXmu82rzAIg8A8YclGwgnIfIGIYTr53f4yNHaKr5+sq3jSopgAYG77Is0FkhN5+t5SLErzEDBq+p+bjTe5Aisth3bSbW0Tc9zQRa89qR+OxoAxS9q++tau51VWdbgmgwcIN1/hV/Q9KSDbEIk2W5rodIwftDAddsq5FcBVpuWf3Ue31hXFY2O/xwhg5nyxFHliprEulfEVCJcU0sGw/pTna4GqCpg4HCXdQet67knffIocZbVuvDGwAWq6N+Ea1EKGKFfA8K4TGb3BXF/JLv/28eq0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0f/rAekPVj6CziZFBx0UAJLsMF++zPTrPBU7cnryVds=;
 b=Xo368W0zae/qq15yBMzXolLx5za/k1lmcF3Hmnqg96FhbPoWdo4PtmTEn5amAh+YdcLcKqGw1H+HeqikvCSZed2+NvQIpakqzhTY+kkiVm7Zv9gXhGAnBzy9NiNeQj2UdbHcz8v9pyC26iCFR9AoaO868S+UUyDXcT9vkVFQLk+nOElyPeDlPcPfZenCmUhmpF6WxG1Zc69w/u//E9gzHXQM/I+qtEGFQG4MHigy0U1tGyGFSdFrZnKGFiJqskF3OLFNt/LNqTvGRszi4PHmaIaK7VqAzEoSfnLNW8hnQy7kgmgKwO4LvdamJb8E+iHuOdr0h2UpzEJrYKSBIB9s/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by PH0PR11MB5612.namprd11.prod.outlook.com (2603:10b6:510:e7::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Thu, 16 Feb
 2023 13:06:16 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::3ff6:ca60:f9fe:6934%4]) with mapi id 15.20.6086.026; Thu, 16 Feb 2023
 13:06:16 +0000
Message-ID: <779078a5-a4c8-6f75-2063-912d02e47bc7@intel.com>
Date:   Thu, 16 Feb 2023 14:04:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v4] xsk: support use vaddr as ring
Content-Language: en-US
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
CC:     <netdev@vger.kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "Maciej Fijalkowski" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "John Fastabend" <john.fastabend@gmail.com>, <bpf@vger.kernel.org>
References: <20230216083047.93525-1-xuanzhuo@linux.alibaba.com>
From:   Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <20230216083047.93525-1-xuanzhuo@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0094.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a9::14) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|PH0PR11MB5612:EE_
X-MS-Office365-Filtering-Correlation-Id: b456e8c9-5693-4830-d8e6-08db101e962b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xV39J+rCyfPZt9CilLWDKJCaoiP8tkW0Wn6Jp8KZgoOfj9zw6lcZxHiB4VZdGuU5/9LxIJUdDaiy5Q89wDBksd1CILek96fexD8lBOqEZXLiBhj6dTnx9uGsCje3yLke/npeNEfihC80Q59FNvFE5tbRJzL+/HNZkCkjtcuGEb0nvjourXIp+qSRQjxo+u2RENHowOq/nF1wUG4AO1H/gFnF2llDOXl/SYRUBuBEwXym4RkSWst16sm7U6oGKuL+pnKAuoxkIQz8wHbQzzyi+9e8vZqUe7LLUabZ6KAWa6aLfnIJ3EluM26WQe4OLyYzfk5f4jnhURpPbqdxweozlDNbqVBSwHzWYJ5Icv4CgiaGoOMoN4pNIqFGubPyXXykp5ZAzU8bYjREA/vUQD2STY6Bk4Nb3m9QPoKicP7B7Vv399ViYbKuBWGbpYbMyJn8BAuh/QSyUqQkLhVcz6thhJow4E0c3SEdlmvBlND/sYXQG00AZbGnaGkOuEHQtZ5DAXntBK2Q66pf5cH9rNptlH9oWxPveYX5E5QTvC5fTRVIuLHofklctPV+hQB2T+5BzkJ/kfqsVooF2YXiSA45xPjREPv0NEGBylLPKtEUAck5Ho/L1GQ62Y4VQqdoNhcBUiwZ61xIUOrJzlTOwLG52dX70o+f0qDXJYtTa41zMM5NKwjEnWpWUCqCXXVJvH1M6abfZ+n535Lu7GUM5jglQWM78MKpq02F7MRjScEstOE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(396003)(376002)(39860400002)(136003)(366004)(451199018)(31686004)(54906003)(8936002)(6916009)(41300700001)(8676002)(66476007)(66556008)(316002)(66946007)(5660300002)(7416002)(4326008)(2906002)(478600001)(6486002)(6666004)(6512007)(6506007)(186003)(26005)(2616005)(36756003)(83380400001)(38100700002)(82960400001)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z0VHZUQ2UGdxQ0daNHBvb2thclJvZ3RmRWZJRWE2TDExdlJsakpZb0ZMMGlS?=
 =?utf-8?B?U3hOZE40TFVIM01nV1NRczNEOUxhZmZzNWNQYUpySTNxdHFwWkovdmRyL0FH?=
 =?utf-8?B?bGwrQjRqYWhoUWgxYlBwS0ZBTmc4NlNYdkZpZ0FVcHUwektBZVJOZVNyMXk4?=
 =?utf-8?B?TFF5UEFoc1ArMjUyVDJMQ1BHOWFpYUpkYUwySExrUHdrQ3ZtYWx4RnJzTmpi?=
 =?utf-8?B?WGtrd3N3NW1YUGU1djlQcm13YjZjUmRoUC81RWxNWGlydXFEeVJTY0VaOHFP?=
 =?utf-8?B?RVI2dklJZll3K3VFREM0QjhuSk5hazR5MkRmd0hBSGpPUWFrclRtNCtmZlJG?=
 =?utf-8?B?d0FSa3FqcjlEa3Y3eU9SQ0VYcGR3V0Jhd1NqY3h5N3FEV0pud3Q4R0lvWTBP?=
 =?utf-8?B?RERzNjVNOFVwRmN5anYrVy9sNk5LcFZzUVJKUjVuWW9FdHFNajNoczNQQjhD?=
 =?utf-8?B?RmJLR2JVRU1XbEFiM3dsUldybmJ2SDFJM0RETTdoMEsyYnBQYjBpeTVueGdy?=
 =?utf-8?B?MXVKRERaaTFRakZVY3poTmxZdFdSOWI0SjJ3WUdUZ1J5NVpCWWlPb2c2REJj?=
 =?utf-8?B?dW9yNnZYeno0TkFJcnJnbVBJcXdVZ2RydkhzSkM3Q0hVZDFPeDJEcGRtZVl3?=
 =?utf-8?B?cnBSalVtbjVvSUViOW9nNVoyVnN5UFZSaHdCUDBYWHBGdWE5aEJqSmVSTXpV?=
 =?utf-8?B?eml5RFhRdm1zMTN1M0VDNi9GUlMyclc3VnZZMVIyWFVtU0h4T2ZUdzk2QTJz?=
 =?utf-8?B?dWVEeVNIRmhyL1dWR0pBaFZFM1d6S3pZaGZncGVkNEx2TFd3djRMd3VPYTlY?=
 =?utf-8?B?WTU5YjZyT09QQmxoRWMzYTJjc0dWelRQUUVhU3A1b2JWU21aQjJtaUVGbjc3?=
 =?utf-8?B?RkhEWEtsWjZHbU5ObG1HZ2xDbkJFZUZTUHJuOUVrVHdXWEhTZFpoUW9JQWw2?=
 =?utf-8?B?aEVzUXR6SC9UWnJGYkwyb2g2VzZiSWNMZlVObFpmMVNyK3owenliRytZSHVZ?=
 =?utf-8?B?Y01teTdlczZJemJwNUpEVStsbDdnVmhraFdsbWpBYjZsTGVhRXFPYXpuWllJ?=
 =?utf-8?B?UUtJU09kNFF5cnJBZ3VjWm9HOFJLOUxPYis2eXR6NkFsM2s5Mko5RjBMUDZz?=
 =?utf-8?B?d2FNOWF1d2x1T0VyTVJPUGJDTWk5NVhCcnFKd25NeldESFFndDVaT3dISW5N?=
 =?utf-8?B?RUZLM2dEcFB4TmlFZG9yb3AxL2RIaE1YVGhTTjVXOERZUGR0bTdYTktvOW5a?=
 =?utf-8?B?Y3ZOOUZVbHI5d2tlMHVtcThkcjdXUStGMWZ3c05qejFoSXQ4TzAxUU96UmV2?=
 =?utf-8?B?M2JCV3NTUWFZWWNnRWFVS1NtbUtsRWdDdkUrQVFMcHI4QXM3WXo5dEhBNm5T?=
 =?utf-8?B?emNaU3IyOFZ6SFdvRW9vbUZ5bU1MaXJLUkNLZnRQOVBuL2lGRDRzRzNjb2RB?=
 =?utf-8?B?ZnJCWkU5NHNKZ3VoSWhiV0FDSmhQZHBFM3dQbkxqS1BBSkIxN1YyM21jZWlF?=
 =?utf-8?B?ajRoV0FiNDBpZ2VDUzJjUnJMdTNhZ21vdmo5SzJIekxaSXB3T3RiSkhkQk9C?=
 =?utf-8?B?UnVvTUxpa2NwTjcxSHVjaXFqR0tmWUcwWHJ3aHVtek1hbTg4MVZqdGVCT1Bt?=
 =?utf-8?B?Ym5vLzU4UnRCZWcvZEpLTGJzOHlTS3VWZEJyYy8ra0J0WjRSbUNDNmNJSUdN?=
 =?utf-8?B?K0lmMEtpSEk0R0NQUVB6aHNNeDBIblJqNERZdWdEZUIxdUIxcEpxbkFoM1FH?=
 =?utf-8?B?TjJSYm9wdklMRWxHNndld0UxMnplQVJWUUhKdXgvS1haVXNBQkVMSTdVVWhZ?=
 =?utf-8?B?c1BMUU00K1pTNlpHdi9uTDNJU3N5NWNlSkc4UDBTZ01Ic0xiQXFYZ1VNVVNM?=
 =?utf-8?B?cWtSaWJxWjNZcUw0SGtBV2R6YWNVZHJtN2d0ZU9ZdGRPZHVkdU9Jc1pPRW1U?=
 =?utf-8?B?aXRnWmo3V3Eyd3NTbXdUV3JtREZYTXdLNThWQXpIOWlqNEJoK0xDcnMyOWJw?=
 =?utf-8?B?RDVza2grb1ptN3VYeGF0SW1QZWZXQ29uSGdaYnczVEFBWkxuWkRjSUJzMVZE?=
 =?utf-8?B?RE1QdzZ3c1MwZWdnTUpQMkxwTTN0VUFpVE5vSXliTytvWG9pVjZ6RW05c2lu?=
 =?utf-8?B?YTdMblJ4NXVwNXhsUXFaUmpxL3hFRVE5WWJnQmx5T25paHpWYTZPb2cwWVNG?=
 =?utf-8?Q?GOwgzIeSa9SXPdKH7N5cjHs=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b456e8c9-5693-4830-d8e6-08db101e962b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2023 13:06:16.0076
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u354RT0yJdpu+BSErzJuQDiKxzipQq7HegYLT4R5/9nzbqspLlviRrLU2TyeOxM+8o2npoAbCfIy/i9MWrdcOj/8B17uovnOapKaZ8iXQw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5612
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Date: Thu, 16 Feb 2023 16:30:47 +0800

> When we try to start AF_XDP on some machines with long running time, due
> to the machine's memory fragmentation problem, there is no sufficient
> contiguous physical memory that will cause the start failure.
> 
> If the size of the queue is 8 * 1024, then the size of the desc[] is
> 8 * 1024 * 8 = 16 * PAGE, but we also add struct xdp_ring size, so it is
> 16page+. This is necessary to apply for a 4-order memory. If there are a
> lot of queues, it is difficult to these machine with long running time.
> 
> Here, that we actually waste 15 pages. 4-Order memory is 32 pages, but
> we only use 17 pages.
> 
> This patch replaces __get_free_pages() by vmalloc() to allocate memory
> to solve these problems.
> 
> Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
> Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> ---

[...]

> diff --git a/net/xdp/xsk_queue.h b/net/xdp/xsk_queue.h
> index c6fb6b763658..bfb2a7e50c26 100644
> --- a/net/xdp/xsk_queue.h
> +++ b/net/xdp/xsk_queue.h
> @@ -45,6 +45,7 @@ struct xsk_queue {
>  	struct xdp_ring *ring;
>  	u64 invalid_descs;
>  	u64 queue_empty_descs;
> +	size_t ring_vmalloc_size;

The name looks a bit long to me, but that might be just personal
preference. The code itself now looks good to me.

Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>

>  };
>  
>  /* The structure of the shared state of the rings are a simple

Next time pls make sure you added all of the reviewers to the Cc list
when sending a new revision. I noticed you posted v4 only by monitoring
the ML.

Thanks,
Olek
