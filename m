Return-Path: <netdev+bounces-1547-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EA036FE415
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:36:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3833B28159D
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 18:36:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D8216411;
	Wed, 10 May 2023 18:36:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F19B36F
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 18:36:30 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D4B3AA6
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 11:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683743788; x=1715279788;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=RNl2G+QMoVz6Pa6QDYbxwUfEEj5JzbmsmcLLSeF6HIg=;
  b=Dm8VsjndYZjLNoXU4ws1linus8JMlzpzMB4tLLIyLnlFAc1Dp+PXyB4P
   ZKb9uuAxLjOrPrUW9yOAe05DYhWTR3zWAjhuwdxuT7SFrDhKAVuuJf0qq
   VN/YBsnSWgO5zsoD4buEX8I9w9548z9Gxzykazqhfd/mtSK+lyES+t3UL
   Da/l9caT1UFJNb2VErD4rjcHCuVb23d6f9Cxz19o86B1BpEEM6Jrm/GcW
   oFf+j3mV9sWTgMvZ3QwXx8rGZClEVPuE17DqQ40GbWKghCW7g12oYE6M3
   RowtKIwYGoCBEOx8q7sPvTHFVv9PNp7Zg28uXMpknt0RVnjYqoezAn+aZ
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="353367630"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="353367630"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 May 2023 11:36:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10706"; a="769001889"
X-IronPort-AV: E=Sophos;i="5.99,265,1677571200"; 
   d="scan'208";a="769001889"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga004.fm.intel.com with ESMTP; 10 May 2023 11:36:27 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 11:36:26 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 10 May 2023 11:34:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 10 May 2023 11:34:27 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 10 May 2023 11:33:38 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nIzC0Q5LwApUE6xlYFIw7nyeUU4EJl0o0XZBlGlX4ARMPagAuJBPddZAHxStt5nA+Sx6tawenb8pRhOhvLb6ICl/53QQPr1Re/r/khvPYLvYEOmYlzCBXT16FjZIqd72GzAL7f0h0XZ/PiyBrFytUPyF4vOqvEfigysvqvGZwBj5sFoODErkIQbAB7MzI6HtT0Q5LuUNOjxDDm/vL4Hr8/2O+UrW43oP3PhpS537A1OG4QBRhy7ziBrrVM4/nlPKSqw5oKBDm/d1KHQ9fgqFgKaKdxuY8SUCaDBgUCGV1W/VzBe8+o3m22F//iBT5RI/vE1ysfDqcZEbBCk+PXllOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H6NYXzzat1DA75FCiuU5BI0UA6y3NoGRwWIuwaEJlxM=;
 b=WuY5iIA1Yj3oH+OblO3Q6kMbsJEI6MHEF4sXpH9hNUCqeUx1XAYxLPdd1QKwMklcyIXH6MQv0rL2j63pfqyvvetZ238LmHsFL4HwXRS7x5jSSASwUSehVy62ukgzccxByFlCioOVdnKevthqTDO/g6wbdpmUulLj1mgkAZu5eR9eeejdOG2md1iaGvJUjtDE/F8EOjUNLkuq6gFdQ8IczyOtK6YY+Juo5miENUBQ3vxJpm3VJTwqhQQYh41Y6wlEYuQDPKeogumht+rrWnlYbpXHpN/yGD9vo3NMY1gUdVyhjEhZ/UjxMMr9UJ7+PaXKJgvDDirEAZwiSFHCDKUn+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5370.namprd11.prod.outlook.com (2603:10b6:408:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.19; Wed, 10 May
 2023 18:33:36 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::27fc:4cc8:6fea:1584%5]) with mapi id 15.20.6387.018; Wed, 10 May 2023
 18:33:36 +0000
Message-ID: <85bdedf5-930d-c47c-fee0-bb4fee480e42@intel.com>
Date: Wed, 10 May 2023 11:33:33 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH net-next 6/8] ice: add individual interrupt allocation
Content-Language: en-US
To: Simon Horman <simon.horman@corigine.com>, Tony Nguyen
	<anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Piotr Raczynski
	<piotr.raczynski@intel.com>, Michal Swiatkowski
	<michal.swiatkowski@linux.intel.com>, Pucha Himasekhar Reddy
	<himasekharx.reddy.pucha@intel.com>
References: <20230509170048.2235678-1-anthony.l.nguyen@intel.com>
 <20230509170048.2235678-7-anthony.l.nguyen@intel.com>
 <ZFtb1Uyr2j+wEM+g@corigine.com>
From: Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <ZFtb1Uyr2j+wEM+g@corigine.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::38) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|BN9PR11MB5370:EE_
X-MS-Office365-Filtering-Correlation-Id: dcedeba6-0a8c-437b-ba48-08db51851121
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TuSuiZwrz1pUgLVzh3Jz2kxUdDBphCmo8uHEA0YKwLk20sRLmysWtDoJd02lonjpa5cy8y4lSWdGM+DmSZ8DRP2OjIZys+38lMT+Sa90uyLl+uaGHvi1P0anfEMeTBCDcUUDRcP2FV26HnYkZT4oMRl8LtVVLg6OHNaN2vEo32tzoWMaNTKfjV+5tqF4A5R8aygbbEuM/rmILBKbnoKBlAKaXOP+Xb2TTJnTHBM+IjOSIjhuyDsXupVKwEpgMvU5ytxALDfxBxSB1bN1czngTaHxPXW/j9PodrC8C6AR6XmkIZsSoxfyvmO/eK3TUmpSl/1Bi0rbhYspjldFapK+ezt7IzmNuJYGj6g6GftydBxfNYkE8+ZGMa8UNYCmO+JkrRpAf0j7bnTNBNA0qJ4EqYM/xU+mlOER9yGekkHGajet4bx1V6bLTTLlIJIB9DNXl/yGfxoMvSMmyIpq65ErctzexhchISY+cMKLuR4pkAyxHFjxAbuMxfgy3kEBZKurTJGkC9of+U+L546qbysTgOTGvrFWNt32X8GinG5pBsn1W1EInKCZhaR3QVqgOpPvSBG3KXatFvwiJXhu5T6aZQcGW0PmKk7whQa8TLZNR94q/KvfArYWuWFJf9YX7QFJGIpau25ceAoZpXI9GqtrcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(396003)(39860400002)(366004)(136003)(451199021)(6636002)(316002)(4326008)(66476007)(66946007)(66556008)(83380400001)(478600001)(54906003)(31686004)(82960400001)(110136005)(41300700001)(2616005)(38100700002)(8936002)(8676002)(26005)(53546011)(6506007)(6512007)(86362001)(186003)(36756003)(2906002)(5660300002)(31696002)(6486002)(6666004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OE9RN2huSFovSVZQb2NNZ0FhV1dXR2JkaWpoTWhMU1pLV2VlM1RsaFlmelcv?=
 =?utf-8?B?Ky94bnBIZ1NjeEU2VnJIMzEwRVdTaFpLeXZWRi9LZy9MT1Ezb2UvTHBZaHlq?=
 =?utf-8?B?bHdRcnZrTWVsamtzcDByUkRGYUJ0RW9KNlU3aEFxUDREL0xUc2ZkZFFBVkR0?=
 =?utf-8?B?RVFPVVFEOGxDS2ZkcHBHdmRjZStVOFdINGMwa1hqUEVJL2FlK0RIZHp2UVBk?=
 =?utf-8?B?Z0lrWEpnbUNQTGI1SjI3WnFGeTFVMm9nNUEvamNmcUdlRHNZNU9PcVhMcTFp?=
 =?utf-8?B?eWEwY3FXYTY1eGhKVmJYbENjdi8wTWdXTjBRaURLQjRxaC9kdnl0WGljR1N6?=
 =?utf-8?B?Qjk1TWpuYVZxbVBMSkxLblYzdWNjVEtzSnFzWWk0OEEvWG9vV2JVNGhpdWoy?=
 =?utf-8?B?T29URDEyeWQ1NE9makp3VDVvbEJ5NzBFZWZlVm5iT0llU2xvSm5hOWVqOVFJ?=
 =?utf-8?B?ZTZZTWRPZXBocWpvaExqNnN0NjBTanplZU1rVnRsQnhGaHFGOTVZWGs3YkM2?=
 =?utf-8?B?dzlKM3lNTzBkbnNhUHNFNzcyZkVEMEwrVDNyRjB0d2cvb1lRSWVkYzIzNnJ5?=
 =?utf-8?B?cjFvOVAwZHZ1ek5UcnNIN2lZUjhJNVp5WGdVbklkQkE4dm9hRHoyWXUwTUtT?=
 =?utf-8?B?OENWL0ZGbCs3YUkvdE5aWUV1RUFsVXZ5UitsQUpUOVZXK1J4M2NhenF6MVE1?=
 =?utf-8?B?cjJkY09pTXV2ZE5SdlZnMlZVL2FoUS9xTmxZQnh3aU84Tkg3d3p5a3VuNloz?=
 =?utf-8?B?ZGRqLzI3dGtqdEMycTU5cGl3Nk1LR1VZU0dmT0tVc2t5TDlidnk0L3R3cVlm?=
 =?utf-8?B?T21RQzlYakNOZEljNWt5Y0Y3cGdLUGRhdndzTDN5M1FUTG1pUGpRcDl5VzRj?=
 =?utf-8?B?L0U2ZXQrOUd3Q1B1V3VKM2I0SUZNS2VBdk9TVHNVZFdvZEQxYklhY2ZIdjhh?=
 =?utf-8?B?Z2FMUUpDb21RVTZhME43eWtvMnVSWXhoVTltYzhnYmxBdGhNRHBnc2tpeG9V?=
 =?utf-8?B?cFdTdzRrL2RwYXY1b3NSTlF5bnd3Umg0dnBFY0szQjFVcGZqQnFlQkgvTUNV?=
 =?utf-8?B?SFlPNVJwRXlZd3dmalRFdHpwU0pFN2MzQitHc0dPR3FONVJxdGp0K041cnBK?=
 =?utf-8?B?MWxMNkw3Lyt5NHF2bHJ6aU9pR0J4MGozSW0vbmg4VVZZZXR4WHhNUmZ4L0t0?=
 =?utf-8?B?TkwwaDdicExlajdjSHhjVmRXdHQwbWRxdTlLOGhrNU15RnJRdDA1czlFdXlN?=
 =?utf-8?B?elByWndHUFpEbkdJcVlqakJiS0NnWFNrQWEzd2dVSTU4aG11MEN1OVpnc1M3?=
 =?utf-8?B?cjZ2aTU3QXdEVnBMNExpU2FNRDVnZ0M4UENta3RlbzdseTNtUkdvMDVjemQr?=
 =?utf-8?B?NDVVKzV3SW13K2FnRmc1UEdHQUQ1K3dyaEVxSzN2b2Y1c29telM4YVI3OENL?=
 =?utf-8?B?ZlZrZE5yYkU5bW9uQ1Y0akIzYVB0UDc5eWxLdkRza2o3Z3hCQkU5dGZqZjBi?=
 =?utf-8?B?SmtmSmRneGZTdVZobURTaGFHdy85RWIxZHg1b0lQbkdrQmN4VktuSytkd09q?=
 =?utf-8?B?L1poZVR4dGgzaUVnSmpiRlk0OHh1R2h2cnppd2VjMnFyMGUzZVJlcFJ1bGd5?=
 =?utf-8?B?TnZrNkpXSXB4WU81dmZJRyszU2FJVWNuYnp1NjE3MlZHWjNnYlVCTlR4R1Yx?=
 =?utf-8?B?MWJEOWliTjdTeVFBTWNHbS9BdGxCTStSSmZidEhzWENlVlErZFBiSHFCSTZJ?=
 =?utf-8?B?TnFsVTk3c1RpK25tZ2Q2aS9zOTZoWU1sdWxQYUJqMzZIR3dDNFozelNaRTJo?=
 =?utf-8?B?ejE4VlNRaHg5czYrVVZpekgybUpub0dybnhNUVN1S1luTGQ1ZTY2djRzeVlI?=
 =?utf-8?B?NUlKeFJ5RzMvYm1oUmE2RmtnUjVQWHIyb1AyclRENlVOWFdBTklsWDBmaFRh?=
 =?utf-8?B?eEdiaHZaOWdNZXpHWGFWZ00vdVpQM2hmM0tjN1crUmNVaVZDZFdVbW1GWm5R?=
 =?utf-8?B?YnVEVTg2VWNCUHY3ZFBucGIyQ2ltWll0Q0x5M3dMQ2p2RUVOMDMxYUdxYVl4?=
 =?utf-8?B?QldyTWFUWi9GVks3WEp6ZDJEcC9IdjMvZnJ1dE52b3I2bjBMVlRtdDRLc0Ft?=
 =?utf-8?B?R05CR2kybEtQQzdKd2lXaXp6dGNhMXdJSXhIcTlKRjk4YWdqVmdxR254NTBC?=
 =?utf-8?B?WVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: dcedeba6-0a8c-437b-ba48-08db51851121
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 18:33:36.4353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4fQ6Rz6NuKN8pqpG7WxyIXGwQuoBKUBeo+s0E2gX8mUxmIBncHzuoV85imMD9n9S4HFlqZzZG+cLux85HqaKyT95L2wuFBxPBC0e3Hqem70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5370
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/10/2023 1:54 AM, Simon Horman wrote:
> On Tue, May 09, 2023 at 10:00:46AM -0700, Tony Nguyen wrote:
>> From: Piotr Raczynski <piotr.raczynski@intel.com>
>>
>> Currently interrupt allocations, depending on a feature are distributed
>> in batches. Also, after allocation there is a series of operations that
>> distributes per irq settings through that batch of interrupts.
>>
>> Although driver does not yet support dynamic interrupt allocation, keep
>> allocated interrupts in a pool and add allocation abstraction logic to
>> make code more flexible. Keep per interrupt information in the
>> ice_q_vector structure, which yields ice_vsi::base_vector redundant.
>> Also, as a result there are a few functions that can be removed.
>>
>> Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>> Reviewed-by: Simon Horman <simon.horman@corigine.com>
>> Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Contingent worker at Intel)
>> Signed-off-by: Piotr Raczynski <piotr.raczynski@intel.com>
>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> 
> ...
> 
>> diff --git a/drivers/net/ethernet/intel/ice/ice_base.c b/drivers/net/ethernet/intel/ice/ice_base.c
>> index 1911d644dfa8..7dd7a0f32471 100644
>> --- a/drivers/net/ethernet/intel/ice/ice_base.c
>> +++ b/drivers/net/ethernet/intel/ice/ice_base.c
>> @@ -105,8 +105,7 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
>>  	struct ice_q_vector *q_vector;
>>  
>>  	/* allocate q_vector */
>> -	q_vector = devm_kzalloc(ice_pf_to_dev(pf), sizeof(*q_vector),
>> -				GFP_KERNEL);
>> +	q_vector = kzalloc(sizeof(*q_vector), GFP_KERNEL);

Especially since we moved away from devm_kzalloc here so it won't
automatically get released at driver unload. (Which is fine, I think
we're slowly moving away from devm here because we didn't really commit
to using it properly and had devm_kfree a lot anyways...).

>>  	if (!q_vector)
>>  		return -ENOMEM;
>>  
>> @@ -118,9 +117,31 @@ static int ice_vsi_alloc_q_vector(struct ice_vsi *vsi, u16 v_idx)
>>  	q_vector->rx.itr_mode = ITR_DYNAMIC;
>>  	q_vector->tx.type = ICE_TX_CONTAINER;
>>  	q_vector->rx.type = ICE_RX_CONTAINER;
>> +	q_vector->irq.index = -ENOENT;
>>  
>> -	if (vsi->type == ICE_VSI_VF)
>> +	if (vsi->type == ICE_VSI_VF) {
>> +		q_vector->reg_idx = ice_calc_vf_reg_idx(vsi->vf, q_vector);
>>  		goto out;
>> +	} else if (vsi->type == ICE_VSI_CTRL && vsi->vf) {
>> +		struct ice_vsi *ctrl_vsi = ice_get_vf_ctrl_vsi(pf, vsi);
>> +
>> +		if (ctrl_vsi) {
>> +			if (unlikely(!ctrl_vsi->q_vectors))
>> +				return -ENOENT;
> 
> q_vector appears to be leaked here.

Yea that seems like a leak to me too. We allocate q_vector near the
start of the function then perform some lookup checks here per VSI type
to get the index. We wanted to obtain the irq value from the CTRL VSI. I
bet this case is very rare since it would be unlikely that we have a
ctrl_vsi pointer but do *not* have the q_vectors array setup yet.

Probably best if this was refactored a bit to have a cleanup exit label
so that it was more difficult to miss the cleanup.

> 
>> +			q_vector->irq = ctrl_vsi->q_vectors[0]->irq;
>> +			goto skip_alloc;
>> +		}
>> +	}
>> +
>> +	q_vector->irq = ice_alloc_irq(pf);
>> +	if (q_vector->irq.index < 0) {
>> +		kfree(q_vector);
>> +		return -ENOMEM;
>> +	}
>> +
>> +skip_alloc:
>> +	q_vector->reg_idx = q_vector->irq.index;
>> +
>>  	/* only set affinity_mask if the CPU is online */
>>  	if (cpu_online(v_idx))
>>  		cpumask_set_cpu(v_idx, &q_vector->affinity_mask);
> 
> ...

