Return-Path: <netdev+bounces-11522-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A28873373A
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 19:13:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CA7BC2817B9
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 17:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26FCC1ACD2;
	Fri, 16 Jun 2023 17:13:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110B91ACAC
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 17:13:41 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D1526B3
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686935619; x=1718471619;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rmHTC3OONcY1N1JPPPbxr5RH2dC5HUTNQfXwsB8DZAE=;
  b=X4mcBU93b4fQ2ZD0OBOQi+aATSR3rK3QxXRyIymb2cevHTXGG20WOeZE
   V0xiud8PQnNPBUGvIdl+p32jhvnPtK1/N38DlwmrzVQspYx3dRZnb+V05
   uAFPV9uJpqFvJPSug9kqRDidwJ6uiPCfspW0lRm1CJq4RVyA9lLAY559Q
   BM/pNmsgHaDThlYGevd/4MdCaq1BZlnqPf7rEEWBhjpY7vzT4LTiyVvxw
   Q4ylaeoUktYdab13LdRLlMnhtmC3Jq6LupX0oFdhcXsKpsSm4h5ZMfD/A
   s4Sfm1TXAK+zt+u/EfmKpMc2H0YCn8u8EIa+/vHCGAb9EWzJ3ugUm7Lx3
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="339597267"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="339597267"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 10:13:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="707160938"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="707160938"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 16 Jun 2023 10:13:31 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 10:13:28 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 16 Jun 2023 10:13:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 16 Jun 2023 10:13:28 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 16 Jun 2023 10:13:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HIfijQT7X12DwCeC4+P4K5rlyiLWNebhtJh6sIK0PZmkoSO4HsM74lx3C00BRe+R0PLJ2IwFFOlSW5Qz7SNLLqR7XX3I3P4XFZERMGfgzZQltbuCT+IETtKS9A3NYimpsVFcAuUwBsl9ANxgcqEkcxjOhE0u8hwqYgtHfpUrjh7EorPBQbLoiz+IlK6ZgtKfFJyixZltItPq5FQ/KeahL8jzs2ffUnjRDc599Ez2FFqCT30c6SG723FELv/JeMsj/+cbfvIyWhqR9TXb04kkWAYO0cB3ehVJax7LeuADxv/oiwz1u9dJ43aBzoveFgIcbbOIePu2O+QnizeoFubYow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oZVhy214el8D+Ih3zAquI5zyvt3ZzrlG0pSMFvyMBKA=;
 b=B2ZJJ3fVdSu2Dleq/FHZnVKMot2siYsGPX+mdoKj0PAuqEJv7h1POl4hhR0FgWhHjhbcLgdkqolafYchmPubc+r9Ehing7aCY5UEP+SEnHRtLmafErUJhmQ4x6XbUHf+y7e99BxevhwYW73FUavRzwMnHtEv9oZhdzWaHv59ZNbESqAfqlQ5U82xj6g25hs+V2v6x23QGevUpMUzlSIX02nYa2jU7YMfIEb/VwkbWws+L/KWNlyesur9e4L03Sjunbyv/FcjoCUCaFgP0u8DRJN/7oCBt+WTDMWxgl/DzWooiP+VgcQqLWkDnMd5TgcaLMu2qnTdTtwYuN5SGWvWaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by IA0PR11MB8353.namprd11.prod.outlook.com (2603:10b6:208:489::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Fri, 16 Jun
 2023 17:13:26 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6500.029; Fri, 16 Jun 2023
 17:13:26 +0000
Message-ID: <16233103-84d8-bcaf-ac74-355ccf3d5820@intel.com>
Date: Fri, 16 Jun 2023 10:13:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 2/3] iavf: fix err handling for MAC replace
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>, "Fijalkowski, Maciej"
	<maciej.fijalkowski@intel.com>
CC: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>, "Romanowski,
 Rafal" <rafal.romanowski@intel.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "Gardocki, PiotrX" <piotrx.gardocki@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-3-anthony.l.nguyen@intel.com> <ZH40yOEyy4DLkOYt@boxer>
 <29e3a779-2051-d4bd-08fc-2835b05de55c@intel.com>
 <e5f6407e-e19b-636a-a90b-3d1d6f7beca0@intel.com>
 <DM4PR11MB6117A7B1423198E6478E4FDA8253A@DM4PR11MB6117.namprd11.prod.outlook.com>
 <d5b2b152-4325-a32d-3daf-e4629ad4818d@intel.com>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <d5b2b152-4325-a32d-3daf-e4629ad4818d@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0234.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::29) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|IA0PR11MB8353:EE_
X-MS-Office365-Filtering-Correlation-Id: b36f76cd-8e85-4018-9007-08db6e8cff45
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l4R8a0Ym6qdrvG4k26oadI35GtEmGaJTODzY8RiBKsDt61i3g0GgFz0MfCi+jZV4etL/gyR+Tk2sEWu5g9TmgKuGlDsn25QbmAsufCQOOuXzbMraYLLtK/C8xY3Loj/BYzYry52a3GfS8dWVPvgYQ4DCMWZvDcLA5+rr/oKOQMnX79cKD7qMYxv69pBfTh7jzz222r1+adkBG7r53g4TEvRbbJ4uF/1GnBhESi1wtbYYHynCTn1KxeIr//5zdcRyVN89/tg/fR7NsHj2iwaCPOM11ADnOHz2YGBiSsnuSGhNT1Cciu8bC0jwcWAd9ZEiazyxPXCbbTnVeIcOaQlg5tmGmSwugOGrWp7EG0LmSuG5LMcI8LuOaAmzn+oP9pSeS93lXjbuzjM6HpV3McWkeXx9I1dSpwepuh1wQ5N+wnmMMvWvWLs2jiwZHFEh0eVfqbmvpOBDG2dlGNnHsu1hywNsQNJNwGnIOOsEn+22FqoD9Q1rY5J+50LZApja5J4Nv8KcWe0hK7V+htcJuACJO/aZ1Jr1IJjHVz5pARkErMIQxGQLZ0c4NpkI5ZvvUpuj1EcVAGbwSSXCAyP3XZReAUt6kvLNAmJNX4FarsdIgs7LaqnqtAS40bsJzEWlZK3EySP+OgdWNXTcgYlWfNxSkQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(346002)(39860400002)(366004)(376002)(451199021)(6512007)(4326008)(2906002)(8676002)(4744005)(5660300002)(31686004)(66946007)(66476007)(66556008)(110136005)(54906003)(6486002)(6666004)(8936002)(966005)(26005)(6506007)(186003)(316002)(53546011)(41300700001)(6636002)(82960400001)(31696002)(2616005)(478600001)(36756003)(86362001)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L2JmenNUanhuZHNnUVdodjFLWGduSnhtQU13RGRLTUVnejFNUi9oNmZHVkhO?=
 =?utf-8?B?M2ZaNXdza3VPRDgyZ2Qzd1R4UHFqcnU0K2NuOW85cXMzdEx2dWU3U2dOS1dy?=
 =?utf-8?B?TFh6OEJaaUVpVWRUVmlNUldmNUZYb2lvSUVLQ1hDYTl4TkZYazdvWkdFbkRZ?=
 =?utf-8?B?SGMrQzAwWXV1OGxOUnhrbU9wVllBTjIwQ2F0VkpVZHNremJwTlZjNnlSSXFG?=
 =?utf-8?B?eU5MT2dQekwrOW5EWDRxZFl5NGM2UzhTUkVwYmNBK3RBenN4WkhWSmxrUEpt?=
 =?utf-8?B?VGxGQnUzMmxhaTZWUTQzeVd0eUxsalNnSVRHNVBzWnZGdGdJZHRRSkRZYndt?=
 =?utf-8?B?eDRoQUtGY1EzRnZONHJ5bXQwV0NHeXkzeW9zaFNDaTZmRXF2ajNMUm1VQ1F5?=
 =?utf-8?B?N1hPYkJyK2hramtoTkZxc1A4azlxR29DMXJVTkZDblI4WFRBamk2KytxdEZI?=
 =?utf-8?B?WDJpaEp3Z0NuT2pQbXlVckFsUjA3VzI1cVZCV2pLOXFtUHBXSjlSanYxWjFl?=
 =?utf-8?B?YzlDSUJRVjBiVnU0U1lZeTVUTUxwRklTd0NNLzg3SzgwcU0vY0xWVWFNNE9N?=
 =?utf-8?B?M09WVUJ6MVdOZFVob09aM0xxc1VVV1lsQnBodE4xTDRrNVI0M2xSS0taL2Ny?=
 =?utf-8?B?bDZLZHYvY1p0OHJ6WDdFbEU0VXo1MXpZa1ZIOEp2ekZtbUU4UUNTdlFSZDV1?=
 =?utf-8?B?ZHMyS04rdGw2YUZGSUQzMUV0NXNnYS84cmIvZ05JamVQY3g2NTEyT0lzQTEr?=
 =?utf-8?B?V2JmajFNU0NORnlXQ3FtSE8rRWRFVlNLdDNXV0tiTkV5VXI2M09YaFhJWFRn?=
 =?utf-8?B?Q3BGTDRnT0RMY3IzMkpoczg1STFueHQ2RkJMS3FjRXpoZDdoZ3hmdDUzQ25F?=
 =?utf-8?B?Q1N0a0lVQkJFMkE4Sk0xTlBDV2RzMWhMcnlKQ1FyZVNnVVhkWHVWb3JYWWk2?=
 =?utf-8?B?YmxoT3JESmFGcGZtMEpqNzlnRjRMZmQ1anBuTW11ODZxdCtmK3VKQnNzZCsr?=
 =?utf-8?B?V3REZlN4MHZhS0ptTVFaSUNtYnFHU01TRjl4VTJvc2xTL3d3bjMxVG9XaWh4?=
 =?utf-8?B?eFAvaXhjbjNsVGR2cXRiN3lvVFd1aTBMa2NzOHhOZDZIVk1YVjFwOXZYWktQ?=
 =?utf-8?B?dVBhNktKb01MVW1UOXR2Z1FTaStmZHphU0NpeDh1Q3ViSmV4bngyTWthd3A2?=
 =?utf-8?B?S1FNelhmR2pydi9qMEdMcE8yRHhSYVFIUjYxU0hNTGtidU5QeE1pRWE0bjla?=
 =?utf-8?B?UVZ1eUx4U09wd3hxaWNoeS9YUFBaYndIZ1ZpNFVqN3RqK0MwMzBXeXVTWTJC?=
 =?utf-8?B?VXNiQXFFZmx5WWgvb0FsTzdFQ2hZVGZQSTNMQUpieHczZXMrRnR4WXVmZk12?=
 =?utf-8?B?clVoSlRoSHp0cURRdTdsTWk2MXM3ZHI4a1YvdjdabVhNSlQ0YmRVV2dIY2tK?=
 =?utf-8?B?T05OM1gzODZZV0Eyam9VSU1kbTdYLzQ5SjJQdDloZGtRYmNpam5FWmhnU0xr?=
 =?utf-8?B?MC9wYVoyWEJHc1MyM1h0RmtMaVJpNEo0VmFPRUVuNUdDVjlGeVFzMDNGVjQz?=
 =?utf-8?B?c2dMSFZoUTEralpDeEJ6Um1NNVc0QjhSaXlMMjVwMjg2TEIrbHpkN0F1bXRz?=
 =?utf-8?B?MldiQURGNG1TUmR5VkwySjNFaFY3SUF2cTZPTktKTWxDbVF2andBbE1mN3NW?=
 =?utf-8?B?RXBtbThzb09QKzVXalREUDlERzBNdFpBbGhBd1B0RmI2SFh4QzRRZ2dERlRE?=
 =?utf-8?B?QzdmcnNwZXdBdU00QnB1WWlydVhGUHBBV25XRE4wMEpGZ01rcjB1blNhejVh?=
 =?utf-8?B?Y1ZjZGpSaS84SEdVZndDSlJvUUFXejVJazVBU2U3di9pRFVLVXJ4NS9SYjRu?=
 =?utf-8?B?WjFRUzVyY0doVm50UDZDZDUwYWJ6YTl3L0taaVN2TmdWUW94c0FUTVV2R0U1?=
 =?utf-8?B?dUJyNU56ZzBFWk5oWmVHRE9nTm1FTzd2TkZTd3dDQzNyMXlubVFpYUlOUVVK?=
 =?utf-8?B?RUNrbkJnV2RVWVZKS3Bka1VqZXBIaGRnakd3ZEV2d0drdGlHK2VSbDNVMUMr?=
 =?utf-8?B?WGZ2dStBQm5reVJpRU9WN3Y2ZEx5N3VuSVZrMmZKM3NkNFpJN2JqcVpxZ1B2?=
 =?utf-8?B?RjBRYkJ4NUJlWnllR1k5S1BRMG1qQ1hNb0lrTGphTVBzOXNFL1pOZGZKZHFp?=
 =?utf-8?B?RGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b36f76cd-8e85-4018-9007-08db6e8cff45
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 17:13:26.3240
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eBxz51sbfvbLboWZ20BO1D7d+Voj9ta77jHjdmx+eJVVJQd8fG4MpOyyoVzQ/5oEghXSyWAxo36eCiPn3/0SXqk2zIDqN/RZg35ThHDgkJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB8353
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/16/2023 12:09 AM, Przemek Kitszel wrote:
> Final version of Piotr's patch [1] has been merged into net-next,
> so @Tony, you could re-apply this patch (Subject line here) of mine to 
> your queue.

Please re-send the patch; it'll work better that way.

Thanks,
Tony

> [1] 
> https://lore.kernel.org/netdev/20230614145302.902301-2-piotrx.gardocki@intel.com/

