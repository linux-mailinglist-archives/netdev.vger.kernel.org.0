Return-Path: <netdev+bounces-10674-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA96A72FBB6
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:52:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85C8E281297
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:52:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B9C96AA3;
	Wed, 14 Jun 2023 10:52:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DEE1FD3
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:52:33 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E023DE41;
	Wed, 14 Jun 2023 03:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686739951; x=1718275951;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=tU5Ml/Gy4a1atNhA7JZ2Py/a85nvlVDvSswSDnZcLa8=;
  b=GACvE5VDDkam1ZlSpei+BXwVLx2M51JnK2xJAZh8OELxEOQqlWm72wNg
   LRO4Tk4Mk8qTel3A6aiqFIp6mGZZSD5msS81ZWkLreKRwvwxkoY1ZQH/3
   zJOoBzp7XhQJVbvHKH543ahkBuYI2WcO7nxYEY5fBr3HmpJNMOVNxeH9j
   XYyXsDhWwZMNeofNW/zjzK8d/N+T4T4ftbbztRYWp9De0qx530yPODxgq
   CPOMOGcdq4aELmalTfkiS1ykkrLJ3IQhbkeM1f5SObC4gfXyhalDSSor5
   xarbQOyXdG6ZI9QpgZt6/SuBbZx+kyklRWxNLLeLqYTwPZfXEIaG+2aVm
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="356073270"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="356073270"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 03:52:31 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10740"; a="745035400"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="745035400"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga001.jf.intel.com with ESMTP; 14 Jun 2023 03:52:30 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 03:52:30 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 03:52:29 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 03:52:29 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.106)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 03:52:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AtGmjLre4UrP+VfzIb8cjmnDSY0QEW0+UaNqnCo0Rb0ARbYaxN2L4Hs9qA/316V9ch4owZaPlxCvAYA68taP4VaCfTihoP6SMsBs12o8nBl0TpyS0o19KmRgloqRljqrEs+PHvsrAKGtu1ZWGwNoRm9Sf+ffvLgbx9gQ7T+PwtI8XVlzcJ7QoQbApwYfAH9p95PgV4KtU1bLI8qNxnE/fJ+JzEoJhYSrxG5iHtE6astEbWxGZS6Z0UXV3zmbW/1TKsmw/O/w6UmzgklVMd5oeLzdUpWtwrCukiZ1USXIpYZ4xGwaeEBnQCSfHnmi9QVnbdSupYeBWXMCeCzGCPtmYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3O5CVs/8IepF3+ng37dH/pceLHaaMl+OFlzwVdmPtwI=;
 b=E48b2mrrPxTcCJtYaXFUcPDaUbSnZDm8geCp0ARCkM2ZGBBBYcbFNUx6OBzuUZkjZs4brok8brEQkgoEDYnCTH296LwsFjs/jtoco3laUFccmI+Za8tSI0UVJq/JmGQt8bAMwxGfAJHVH0eo85BMldxpqd4zYb4aNv/t1SlD1aAxspQlBzKDQVcAN6WVG2MJmzANCMNMyHk6LCLd+cb734adaY6EW8cAtITzGrWShYIFItgCXb/IU1f0pX5yjfy0yxbt4JmXoNPo/INBkgg9FIWotb24YFzJvDdcb/a6W7v+7hJS4YQgS1JxTNZNLm5SSCvw/Ji6Sx254AFAln1IIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by BN9PR11MB5451.namprd11.prod.outlook.com (2603:10b6:408:100::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 10:52:23 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::82b6:7b9d:96ce:9325%6]) with mapi id 15.20.6455.030; Wed, 14 Jun 2023
 10:52:23 +0000
Message-ID: <16cc3a9d-bd05-5a9f-cb2e-7c6790ebd9fe@intel.com>
Date: Wed, 14 Jun 2023 12:52:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.1
Subject: Re: [PATCH net-next v4 1/5] page_pool: frag API support for 32-bit
 arch with 64-bit DMA
Content-Language: en-US
To: Yunsheng Lin <linyunsheng@huawei.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Lorenzo Bianconi
	<lorenzo@kernel.org>, Alexander Duyck <alexander.duyck@gmail.com>, "Saeed
 Mahameed" <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "Eric
 Dumazet" <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>, <linux-rdma@vger.kernel.org>
References: <20230612130256.4572-1-linyunsheng@huawei.com>
 <20230612130256.4572-2-linyunsheng@huawei.com>
 <483d7a70-3377-a241-4554-212662ee3930@intel.com>
 <6db097ba-c3fe-6e45-3c39-c21b4d9e16ef@huawei.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <6db097ba-c3fe-6e45-3c39-c21b4d9e16ef@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0015.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::27) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|BN9PR11MB5451:EE_
X-MS-Office365-Filtering-Correlation-Id: 89b51d36-41ec-4bf8-f3cc-08db6cc56ee5
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yw+F58YCiUlxIY68jIRkEDrhfb0I37sa4B8LmZcRDikmOs5qmWMy8FxPlYm8ZtwzdoKpRjeU9NJ14JbDeE7P7WSSQA0lvg3iRZcrfwRij7zEgdfc2A6q8nRVtX/N75GfjfrbZh7kV8qPL6nXSibQ/0NryhsMTlGVk71s0szVxyxQHUtFy2Q4sVi1HFWKQQcn0Obe7ffGmHbRzTLsCc9/F+y/gTLYGHFUuPLYAvsbC6Z90DxSEVa29CVSsD+bAjWMCQyG0EOoh9A5Ta85x+Uje69HrrCUPLbAEbuNolHEpbsHiy5E4GzmaK6i61mXUpDAOSf6NMucD/KqqP/I2kBsZqYpTCtP0jji6yWGWBID1/dcyZDEjZH3UTJodvvMccDn5CJCBz+ZWE6aKkRGAhxzFi+WZGnO85UytOpnjJunkJztw6+4mLFObDG1h3K1bpl38Y0HAOYS8r1odvOwSMbM/P0vU9UAxj2BL3kjddGg7eEgRDRq9B85tHk+9VbUemb3S6x0aAvPYpysXnWkZE/WxzTfxeXHK7kB3nNwpHi8bJ0fcyq92u7hKe4H7dY/bMQqFgf4bw3nIsb/jYCiDvGUwAt0zUGXjCDFT754fR4NtifDeObzkzxD6THJW5ZSBWB5O6/useDXXbJlFxAN8bhofA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199021)(5660300002)(186003)(6506007)(2906002)(31686004)(2616005)(7416002)(41300700001)(6512007)(8936002)(26005)(8676002)(6486002)(316002)(31696002)(54906003)(53546011)(6666004)(82960400001)(36756003)(478600001)(38100700002)(86362001)(4326008)(66476007)(66556008)(66946007)(6916009)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?d1BXelJJU0JIRnhmZWlSU3JiNTdhbWRveHBsbm8xM2xmQ1BJcUx2UmtoaE8z?=
 =?utf-8?B?RkNTYzBMbksyS3Z6OTNKVjNjcFZWL0lwT2RVMEZLQTB2UGpaUVRWSXdsaEcv?=
 =?utf-8?B?SkdvYzFLZ1M0UDVvaFFxNzVSTWZlY3NIRExnckYzYU9LUEo3YzU5dThxSnZU?=
 =?utf-8?B?c1RFVkMzNGVadXpuQUxWanV6V0RjdWJudkFIakxEeUFuWE9YQUJkZFFsaE9N?=
 =?utf-8?B?aTZzUlRnU2lYbElQTDZ3SWcrR1RxWUJVUDNjdE94QW9qbk56ZXVLSWMrWVNr?=
 =?utf-8?B?WHNjVS9IR2NCMDVnYkNhYVlvT0t4cXpLZTNWMzZlckxrc09ieXNBV3FsY3d6?=
 =?utf-8?B?OWlEWTI4STdSOERLOUFEdG9qWHlhUzZtcWNqQ0MxNG1zZkk2alBZZ3JsTkJN?=
 =?utf-8?B?V3NQSEVrcXhLT1RVQnhlcXZyVlR4bGI0ZE5meWpkc0U0NG52cVJFY3dxbGpY?=
 =?utf-8?B?OWlubHpjSG96UFBsQUI2aitZY2NoQkxLQVN5L1FSVGRkMksvbEZhT0pxWGhi?=
 =?utf-8?B?bmpNT0xGcXpxSW1xL1pJWVkxMTBQb2poQkVtdkFYM0lvSWZkMUJvVnVKU1Q1?=
 =?utf-8?B?NXErOXFpa01nd2duV3lpRG5FaVF1eGZtMVAzSFpEMUhQOTdGTm81Z2VBbHEr?=
 =?utf-8?B?R1gyQVZqK0ZCYUl5ZmpKVzZnTjlmMVJmT3lCbktEVitvc2ZGelp2Z0xmaUNj?=
 =?utf-8?B?R2VMRnJjTnNRaGliemtqMitra0NpVFVEQmxPOVRQOWloc1JzV3N0TG5YUCtt?=
 =?utf-8?B?dDQrWVVNRy9xMlBuTXpoZThQeEFBdjJSeFZsU2VkUjBOaFlXemlGT2VCTzY2?=
 =?utf-8?B?YnhPT2Z2YkpRR2dpaXBmRUdFN3NQZTNPRjNNYm5QQnF6a1pUTmlLWkNhakcy?=
 =?utf-8?B?Umd5bnAzaStVRmdleWNYKzcxelpCUHd5cmlPZi9qK0lUb0hReXJ0ZkNTd2dB?=
 =?utf-8?B?ZEhtWjIrTlJ0MVl5QVNYK21IVXlEbmJhWitwTTBab0didGJ0a0haT1ZVMlB4?=
 =?utf-8?B?RGxUb2ZJS0hYVzJQazdVN1ZISjNSTlhVdEtSckdGc3VneFRzYUQvRExHWmNN?=
 =?utf-8?B?UkxqdXJ1aTVIVTZLK3VYZlNCVGdja3RJNzBvTklqUHRTbmdXcHBpSk85Z3l1?=
 =?utf-8?B?UEk4bEtKekpBVjNQSm9NNkFZOStsVnVVRlZBR2UwcncxbW9KL1JtT2gvdy9n?=
 =?utf-8?B?Ni8rSWhTQXgrYVZ6UnNZcFJSdEVNMFJVRHVBMWlQQkxhU0REd0ZuWk40d1Yy?=
 =?utf-8?B?Z05LUjRmWU5vb09FUk4rSE5yNm9lSVhHZVJPNUVqMFFJbEVtdkJCU3hPa1VV?=
 =?utf-8?B?RFJ3UW92VFMrSElmR0x0dEpGRTFNcktVNmxwdFJiTXJjZi9odUQ1T1dHKzlz?=
 =?utf-8?B?dEszYVBXTEFmWFFCZ251eVhDdloyeXR3clA4UDN4OW1IdEQ5Q2hyMHF2QjNa?=
 =?utf-8?B?U0N0M3RWcHJrQTM4Z25xYW56eFlodW9CTnJOdEJoQmlCd0V3K0VZUmxZeFdi?=
 =?utf-8?B?em8xbk1hYXdDb3pGWTdiRUFFbTcwYm1SaXNETWJ3NzBlWlQzY2pqbCtzK2dl?=
 =?utf-8?B?Z2dCcUFZcFY0Q2pHcUxnVFZ1S2Z5eFRncGd5V3N6NU1zY3FTcWM2MkVlNmtP?=
 =?utf-8?B?SEZQQ2syOXNXSkFMeDJpKzFiYTFSTEIyUHJXSmJ4dkRnRk1FYWxSNDZMS2h5?=
 =?utf-8?B?bXVFQWZWMVlBNUNIb0ZneGs0N1hkaUkxK202bmNYTzBpQmZKakNhdEpkcVd2?=
 =?utf-8?B?RDRLaTl6WHZoK1hqbHZCdHRPUWFKcGFCZU10Sk4xNy9WNzFLREg1QXNHUkVr?=
 =?utf-8?B?V0pVKzk2SmJKdW5pVGdBMlZ5T3FEVmJZbXRFd2Q0b3BTNU1ZQmhxSFcyeWZ1?=
 =?utf-8?B?TjFCaHRwRUNDUkFmajR5WGhUcElOL3Myb0dEN2E2Y3VJZzFiQjF2NlZvK1Zp?=
 =?utf-8?B?K1lpeERtQ0JXdGNRODA3UU5SeUJsaWs0NFZVV0toSjNpenFiUlJGYkljUnVl?=
 =?utf-8?B?bEdGaS8zZkN6d1liczBoc0VnSVk1MTIzTkFFZFdFakdFT3NOemxFNXF0S2pr?=
 =?utf-8?B?Q21aei95SzBKMWY0azM1TnBmK2syQXpDNTVYOWI2Y1djZ2tWbU52VmNoNjEz?=
 =?utf-8?B?ci9oUDNqQm05VVVZSjlsZ3hjWGNFbTBka0FYZUMzV1ZGMTMvODNNQTF5K0Q4?=
 =?utf-8?B?QkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 89b51d36-41ec-4bf8-f3cc-08db6cc56ee5
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 10:52:23.2821
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8REjiwermznB4OTeeAJx1imTQhVTsr/swCqCbcyHDBtyV5eCmpY2Ms1EybNwj/lxIINIb31KDGhz+VTBMSeVhFIcpIWFkByKtRYLssSMoQI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5451
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Wed, 14 Jun 2023 11:36:28 +0800

> On 2023/6/13 21:30, Alexander Lobakin wrote:
>> From: Yunsheng Lin <linyunsheng@huawei.com>
>> Date: Mon, 12 Jun 2023 21:02:52 +0800

[...]

>> I addressed this in my series, which I hope will land soon after yours
>> (sending new revision in 24-48 hours), so you can leave it as it is. Or
>> otherwise you can pick my solution (or come up with your own :D).
> 
> Do you mean by removing "#include <linux/dma-direction.h>" as dma-mapping.h
> has included dma-direction.h?

By "I addressed" I meant that I dropped including page_pool.h from
skbuff.h, as I also had to include dma-mapping.h to page_pool.h and this
implied that half of the kernel started including dma-mapping.h as well
for no profit.

> But I am not sure if there is any hard rule about not explicitly including
> a .h which is implicitly included. What if the dma-mapping.h is changed to not
> include dma-direction.h anymore?

No hard rule, but I don't see a reason for redundant includes. I usually
try to keep include lists as small as possible.

> 
> Anyway, it seems it is unlikely to not include dma-direction.h in dma-mapping.h,
> Will remove the "#include <linux/dma-direction.h>" if there is another version
> needed for this patchset:)
> 
>>
>>>  
>>>  #define PP_FLAG_DMA_MAP		BIT(0) /* Should page_pool do the DMA
Thanks,
Olek

