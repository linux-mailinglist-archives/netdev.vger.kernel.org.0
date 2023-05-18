Return-Path: <netdev+bounces-3649-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F9987082B0
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 15:30:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 41A0B1C2102D
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 13:30:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62ACE23C97;
	Thu, 18 May 2023 13:30:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E19023C7E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 13:30:41 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F11EC;
	Thu, 18 May 2023 06:30:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684416638; x=1715952638;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+CgTbzqp2m+hL5TppH9kvdipYyOI+zr9WduBDzAK06I=;
  b=WDvuSPo+GryKDN1VUZN5bQFrE+5fB3A3dcyvOiDTLzuvrlO+o13XEp7W
   ++Q7MMxZmIX+o7BmVdFxliXjigAmZM0g+WgLI/E5Fk/MqxxqsOtf5j8Zy
   NPbfIWy9jJs7syK/HZ6YOWQ0WBoY4a0xq7ys+E6tRidBZkAbi+4lwH/Cp
   ZD9jyJl+mjN6tkFTqXF633kOTYmWbLavGPACxO8RbpBn0BBv6GjjY5Cb1
   VMl3INs1B9oDZAApdoEc4LLRhoZhTmjjSDDEFPN2mxg2ZfjXCk6Stz8oL
   nt+gZp+P6rNfLFJO0huTmuOoicDG5q49R5xdQQbClxxsGeWmteS+/XghJ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="352080419"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="352080419"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2023 06:30:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10714"; a="876424862"
X-IronPort-AV: E=Sophos;i="5.99,285,1677571200"; 
   d="scan'208";a="876424862"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 18 May 2023 06:30:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 06:30:37 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 18 May 2023 06:30:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 18 May 2023 06:30:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 18 May 2023 06:30:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FrEB+c6/ReiH/Z9nFXm+g2fEpoqMshh1/kYE0TtKWpWVij2FBU3mursfZRtVdzWhRVoqgmQ8Wr9vTt9Hv3IHSLTNu5E0Bmrum+1d91+jEcvbTO7nWbcGDqC9M0NEtpIaZUvl+DS6j9DGFuKv7up0deKiDDrxT+/RfJO8FieBC0ZW65ELEjFQyOiEvPKpPkUz+FbPgJM0ds/RV6ID+VBF645IyVek40/s/CyoHlokDVWnQIFMzMils4h71rN4Drw+6rutPk0UwmHhrY8xuTS9gSzE7TeGFqYKnVCkG4wm5P3o5R13SDfND0qUMnZOVVYC4i3esZyH1aG7SVCa7Mn42A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=os1ZzCcTPV8Gxs1XsmrYLz6vXlvC2ATSNX8YO6MEZkk=;
 b=BAtdBUmIYAh6lN4Y93a1QfL4oxfYXNN2aOqDoLOHV93+bYgtuv8PMEDWC4fNgZcSeZ5F8Ev5JXW78zskIJ9u70kBdkVwyxKt+T9D40XRETzqYcyh4J5/466Y5cfM9l0Wbb+bxKPLwsGb1LhZ0YVdv3wHUh6EnXSM4Nc8MLJfBXkvkWfC0MPH1jwai3fU2k5KjMUo6JuhEOuT7XhXk2OlhvtHYHfYe5Ooz/8WXrHkKVAnedAHoIOBYk09xCUGTEP0y1DPmGwUqC/TIMYvrJbnBKyT9eWPnBRMxtU9eJTTtEvFkZy2sHxLOR9vRWFqpw2OJT2KyZWTDaxkNmq0CphVaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
 by SJ0PR11MB5037.namprd11.prod.outlook.com (2603:10b6:a03:2ac::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.17; Thu, 18 May
 2023 13:30:34 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::64d9:76b5:5b43:1590%2]) with mapi id 15.20.6411.019; Thu, 18 May 2023
 13:30:34 +0000
Message-ID: <7d484879-e256-fb06-45cd-1b61a429e6c2@intel.com>
Date: Thu, 18 May 2023 15:29:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net-next 06/11] net: page_pool: avoid calling no-op
 externals when possible
Content-Language: en-US
To: Yunsheng Lin <linyunsheng@huawei.com>
CC: Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, "Maciej
 Fijalkowski" <maciej.fijalkowski@intel.com>, Magnus Karlsson
	<magnus.karlsson@intel.com>, Michal Kubiak <michal.kubiak@intel.com>, "Larysa
 Zaremba" <larysa.zaremba@intel.com>, Jesper Dangaard Brouer
	<hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>, "Christoph
 Hellwig" <hch@lst.de>, <netdev@vger.kernel.org>,
	<intel-wired-lan@lists.osuosl.org>, <linux-kernel@vger.kernel.org>
References: <20230516161841.37138-1-aleksander.lobakin@intel.com>
 <20230516161841.37138-7-aleksander.lobakin@intel.com>
 <20230517210804.7de610bd@kernel.org>
 <b84ad4ef-a996-4fd7-dc90-3b44f7acaf39@huawei.com>
From: Alexander Lobakin <aleksander.lobakin@intel.com>
In-Reply-To: <b84ad4ef-a996-4fd7-dc90-3b44f7acaf39@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::9) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR11MB3625:EE_|SJ0PR11MB5037:EE_
X-MS-Office365-Filtering-Correlation-Id: 6974fba8-be66-499e-183d-08db57a40eea
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3+il2G0s2olW9UFEpJdW81/KBim+cAxYvUh8mg7k3IxbSPMW62dlX7tPKxYRmND4Amu/dPyTVuZNo10uKlhOszYmTzT+eBN0YYISKs+esVEEpNPLgawPwVMvexrY7bXa0eb0YWg86jp0pK+S8oU/ZsW/DFc502FdnUXk/tvyvcjy9NDnlMxN+dNgmITyxrX8+FbY5SXPmD/Oy/pisjO0sDKLgIr+fvl9p+11WvDQzeBYoyqYBtomUL5av4eEh5ii1Vx3kNg0i7UlWWSLPGmg27zcBi6dovT/R6HU2lmH2rrTb0c78GFgO68Q/SJ9cQO7Rr8eL6nTGtzcKHUBglnHsJbiQ1K0p47KUOnOjXik29JDZUFZjQ487uim+tF4/onypgACO0A9bzXdPncSqYTrRwxR5m8eUw4Vz3fGfSKC7sqcsb1bad7h7pTzqvKccxnG8lcbKEt7aFUaY3IIzpQsP/Lciot/xKg9dsh2HKOC0nwqU4ubzP57DsU9sF0npGk7riqa11lBUfCPoCP4s44g/tp5XJZpDp2YTHZj80CNlm6KiwMeUcl+DhUBbjQMWzrZJ0xVw/Fy3Ek4Xe0vVIkth3I6/qgzqgOdHYEKg/B2bKzhnJXps1SbeqblNA74+fm8WYGFSoXtOcMObaPlw1f5Yw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3625.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(396003)(376002)(136003)(366004)(346002)(451199021)(38100700002)(186003)(2616005)(54906003)(478600001)(6486002)(6512007)(6506007)(26005)(53546011)(2906002)(8676002)(36756003)(5660300002)(6916009)(8936002)(82960400001)(7416002)(41300700001)(66556008)(66476007)(66946007)(31696002)(86362001)(4326008)(316002)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THBuWnM5L3FWNy92ZUVOWWJvM1Y2WHhJMVVDMHNNV0dsRWx0Tk12Qi9nV05r?=
 =?utf-8?B?T3p0VHU0WWtWQjhvakxLWjZ5V2N4OTBtWWR0ZFM2MUdza1FPcUU4MVFUYUJ4?=
 =?utf-8?B?Sm9xTXJ3NGFGL2xJaHBiajRqWVZDSkorSHUvdkdQMlhMdFo5YlUzR3ZyY2xK?=
 =?utf-8?B?QmM3NTNGamh0Z3RjNm9KcXgyYmpmeVNDaTJjbU51aE8xcjFYdHptaWdhTC84?=
 =?utf-8?B?T1NWOGlUNzlsVHBuKzhVVlpmai93TDh4TlhQMDFTcENtVUNNUUN2VkNsQ01n?=
 =?utf-8?B?Z056NFhJM3h3NnVVY1lscHVMTWVRaXR5dWkzNjlPZ1VUQzhuMzgwWHVPVkdG?=
 =?utf-8?B?L0hIRGUvR20zM3RML2d0TEIybEJvTVJMN1JrMVRyd2ZHNFhkQnVQVzJ3UFp3?=
 =?utf-8?B?dTdqVWdVeVozZ0FNbWJEc25vVmVKbGpzN1VkNHBMaVJjUjg3ZjFNNEdrWWx6?=
 =?utf-8?B?Sk15VnU4MGRBeFp6OExwUW1WWTVmU2M1K0IrdjBrM0tIc2QrdlNNa0JmcTJt?=
 =?utf-8?B?Q3pWRTBmU1kvTnhVL3lWY1hTT2U2czNyRXZNOTJ6b1dEdmtxdFJEb1VPSkxm?=
 =?utf-8?B?UGw1SzNRN1BrcjBxL0s5Mms2Q01xdFluUWNscmIzaGtMSTU2RnZZZVNEQ0FT?=
 =?utf-8?B?RlJQcGN4b3B2eXNQd0NsblZTV3loZkVxdlJiQmpFNWRSbjg2SVJRYU1wWTNS?=
 =?utf-8?B?ek9RdGlrN0RqRHQvWnMwVHlLS3JCWHF1Wmp3QmI3alIza1diV2dxYkN5bGdL?=
 =?utf-8?B?VjZQVWRoQk91Rkpxd1Q4VVhuMk8wMnFDSGlVUW0rK29GWFVhUkRXUlQxZ3hW?=
 =?utf-8?B?NWZtNFp6UmlBYklYNzc2VUJLeisranN5RnViWUp2UUR2bDc3bm5uM3piSUdl?=
 =?utf-8?B?ZTZkaklVMDdNMVN1aFpHQTA0SEV3aHROaTJ6dy8yOE9RQTV4MnhWcGRmRW9x?=
 =?utf-8?B?TkhCYW1FTkFkVHFZKy9ZT0ovSEo3RzQxZy9pcDVjZkVnbVdiOFNXRHBqcjVX?=
 =?utf-8?B?L2YvYWZuTE9GUVNaWXBwLytHTS81RjE3ZHdHUmpQUmpMMzkvWjE2U3lOSzAy?=
 =?utf-8?B?Vm1xTUhzVmovR2Q0NkV6Z29sOWk1S2Rwbm93dXVjMXVGdXJORDNicUpweS9E?=
 =?utf-8?B?cHlLeVhvK053K1N3Nnh2MFNsYUNwTytzRHhldFhxWDhnMUp0SlJ5SWhFbElB?=
 =?utf-8?B?UG5SbUl1V3BuZTZTcXNhTEluUS8xRGJYMGoyUERDM1lLZC9XYlByZkdteURs?=
 =?utf-8?B?ZzFWa3dIQzNLSjJPd1ZqcmRyZEV5U2xWakd3b1E2MUQxYmFVcEV3SHBnOThm?=
 =?utf-8?B?eTB0ankxUUh6dklIbHROS29zcGpsNTZnQjVET2s3Uk1sN2hSOXRhSkRBZnZr?=
 =?utf-8?B?SlNsencxZUlaY3cvWXdYTjhnTmtNK2VlRGZLUEZUTDgzN0gxdDZUZDRxYW5T?=
 =?utf-8?B?OFc1WCsrT0hZandvSjRQVkVaWGZZOGlYODE5WUp3VkNSbmQzSmhHR2NDMk9H?=
 =?utf-8?B?bWpJb0xxK3U5U2hGMEduU0l3eWdGb1VPczdPWklmTzcreXJNWnFxOWEzL2R6?=
 =?utf-8?B?WmV1ZE0yOUN5YVVvaitrT3NLQWo2SDMrZzUwNG4yazR6d2FoVXZmU3BLaHZL?=
 =?utf-8?B?d3MyQ01aZG5IekN3YTFCanoyQWdBM21VdkNvb2wrMDZxenl2TjZVYnhmNEJ3?=
 =?utf-8?B?K29vSHpXWnBtZWRCSWZkMFVVLzF0WGtWaHlGMVRvYnhiL2toMmh0NnRKTkJI?=
 =?utf-8?B?eldkc3JCNTcvOWJOTWd5dzN1ajRxVkdjWWVJL2IrMWw2VEJJWmhnTWNDdHkw?=
 =?utf-8?B?Y1R1dU8wc3JrbEJiNERvNko3UW0walROTnRDQVJteGVWVUo1R0UzeXEvRzlV?=
 =?utf-8?B?eVRQRGtpandtNiszWXE5b3Byd2FUNlV3WllxZURscEJuVGRoaFNJenFrbDdp?=
 =?utf-8?B?QjQyYVNUWDh2YXVrVHhNcWdZNmNOb21ObUhXRHFFcmJhMllhWmUveFl2RXJJ?=
 =?utf-8?B?eDZ0bndxUk4yU2JCKzVkZUJoL3ZYUllsdENpM2Y2VlUwR3dBamJNQVM5M1Zl?=
 =?utf-8?B?c29UVll3RVNZdXVpTlB5VFZXOEV2aXpsS0Y3L0YxOXpQbDZnNHRmZndCS0hM?=
 =?utf-8?B?b2h3WXdrUmpRc1V0Q2hqY0wvN05sV2tjMlRwZDhaYTJPcFVnTUhZNExZcElq?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 6974fba8-be66-499e-183d-08db57a40eea
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3625.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 May 2023 13:30:34.3686
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XJHNheMwF+VsV0bO1OBOFiy9vZbOEUDSi4WXrjrIzWwORMHdXP9uRUqAaxoLvYqdlPJ+lIxCg9SC3EV/YLTqDvkldroAlS8t91yzwVCtoqs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5037
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Yunsheng Lin <linyunsheng@huawei.com>
Date: Thu, 18 May 2023 12:54:37 +0800

> On 2023/5/18 12:08, Jakub Kicinski wrote:
>> On Tue, 16 May 2023 18:18:36 +0200 Alexander Lobakin wrote:
>>> +		/* Try to avoid calling no-op syncs */
>>> +		pool->p.flags |= PP_FLAG_DMA_MAYBE_SYNC;
>>> +		pool->p.flags &= ~PP_FLAG_DMA_SYNC_DEV;
>>>  	}
>>>  
>>>  	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
>>> @@ -323,6 +327,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>>>  
>>>  	page_pool_set_dma_addr(page, dma);
>>>  
>>> +	if ((pool->p.flags & PP_FLAG_DMA_MAYBE_SYNC) &&
>>> +	    dma_need_sync(pool->p.dev, dma)) {
>>> +		pool->p.flags |= PP_FLAG_DMA_SYNC_DEV;
>>> +		pool->p.flags &= ~PP_FLAG_DMA_MAYBE_SYNC;
>>> +	}
>>
>> is it just me or does it feel cleaner to allocate a page at init,
>> and throw it into the cache, rather than adding a condition to a
>> fast(ish) path?
> 
> Is dma_need_sync() not reliable until a dma map is called?
> Is there any reason why not just clear PP_FLAG_DMA_SYNC_DEV if
> dma_need_sync() is false without introducing the PP_FLAG_DMA_MAYBE_SYNC
> flag?

We can't just clear the flag, because some drivers don't want PP to
synchronize DMA. Without a new flag, we can't distinguish those two.
Example:

1) Driver doesn't set DMA_SYNC_DEV
2) We check for dma_need_sync() and it returns true
3) As a result, we set DMA_SYNC_DEV, although driver does that on its
   own

Thanks,
Olek

