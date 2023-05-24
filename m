Return-Path: <netdev+bounces-5144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA78570FCB2
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 19:33:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 724111C20D1B
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B02831C772;
	Wed, 24 May 2023 17:32:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB721C771
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 17:32:53 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553E712E
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 10:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684949572; x=1716485572;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gh+qvOPkCnFLq5OYjrKuNAL8fwpX0MtIC4ZvUXxhLiw=;
  b=TvAWApnNv9Pdlx16uGbjrz1x2RKL1SoUB6vfAVdESwA9pl7DNoK6KgyD
   vY3CAUMsdySQmuFESZdgpsJY/3aMe5DNwq3PVjndqJEOF45asdG0ANGVy
   Zkwh5XP8W4hYczcN/UQq+vtdI9CbNwx5EV7hH/tRZ9usSTYXwN9qqZQYz
   6A1FlRoU7z8bP54wG2C8hL9t23tDTGoIhjVin2G6qlGsZ+dxYdCjbUGRq
   +OeYjscA5HVRq3pA4HCSXgrrW5uupk2HgBgufRLQFo0GymZqMbyfSLB7o
   C8u1YBJdM5ZM4pMMQEczDYi6KoelLLhim1aPmn1EzQVWhlWYjowjYJuKu
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="439996817"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="439996817"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2023 10:32:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10720"; a="681976599"
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="681976599"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga006.jf.intel.com with ESMTP; 24 May 2023 10:32:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 24 May 2023 10:32:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 24 May 2023 10:32:23 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 24 May 2023 10:32:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIbaXLE3d4P86DzN+0zf9qMQYxDlM3kjC+P8srkj7HlhLpvFIy0rryu1tMrWcoBOL9n+b0JxI1hiMGECnuVcRaHoVAqg23WcN4QtYO4UTneZRW2al/Bag19UcN1mZbiG3WxDBTspt+1EGmEO98/9C1NA9ehX+F/ezTJROFaL7HlIGpiEtYYTm/4hSHIjP2RhAb3KVLq5aCibyxocbtTYX8/xt2R80BteYi9Jm0WaijNsxX7XUw2DmxhhkvInGucxRwSqgkiQVcOtz4LyucxNMxCvWvyGvZ0GsSrznMmmwu9iNcrckoZl939nLzMIkILlF0qZQmbgG4cHacWNAKltBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KHByZrnV6qtK3uT3roCCne4N62AFVkNR8Q6BK5Bjuxw=;
 b=XiX0aED52CXs49QJeXZhastE2IrTXeBKO9Yz+znxYX1YRUgpUtXuJOkxCAA8owR5pGi8K2RUKY1roVWs2BP1KL9uIHJ/Jjt9x/bMLcW/je1/3B0QcVr5wyFgR0qNK6ZRDJJpFqnMCOZsQH29KUqekd9sDJigbD/ggT96iwbqz5Ay7v/zFAUZ1Y2Ck917tLDdJUBwG+bAEzGWvN2kwHOaKVuSJtFC8U51GF6UZTZq0Ksmd2ImeGNjG5efWyNpOaJeXxm4Mtp9i0FON4M1XbbdJIBmlrkWoZettDxBsqNERYOLE2FfwFWQ08dm7ipwACDRxsQkBfDRDjwZZPrhOHG/fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by BL1PR11MB5368.namprd11.prod.outlook.com (2603:10b6:208:311::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Wed, 24 May
 2023 17:32:15 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::57f1:e14c:754d:bb00]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::57f1:e14c:754d:bb00%5]) with mapi id 15.20.6433.015; Wed, 24 May 2023
 17:32:15 +0000
Message-ID: <954bed91-6a6e-64c5-e2bc-529d5aced28a@intel.com>
Date: Wed, 24 May 2023 10:32:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.1
Subject: Re: [patch net-next 05/15] devlink: move port_split/unsplit() ops
 into devlink_port_ops
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>, <netdev@vger.kernel.org>
CC: <kuba@kernel.org>, <pabeni@redhat.com>, <davem@davemloft.net>,
	<edumazet@google.com>, <leon@kernel.org>, <saeedm@nvidia.com>,
	<moshe@nvidia.com>, <anthony.l.nguyen@intel.com>, <tariqt@nvidia.com>,
	<idosch@nvidia.com>, <petrm@nvidia.com>, <simon.horman@corigine.com>,
	<ecree.xilinx@gmail.com>, <habetsm.xilinx@gmail.com>,
	<michal.wilczynski@intel.com>, <jacob.e.keller@intel.com>
References: <20230524121836.2070879-1-jiri@resnulli.us>
 <20230524121836.2070879-6-jiri@resnulli.us>
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230524121836.2070879-6-jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY3PR03CA0013.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::18) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|BL1PR11MB5368:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b61f5f3-7b12-4329-b7b0-08db5c7cd0eb
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jITwOJ+UzoKj1x1QF9V0jgydg8efQEmW6+rBsCizv4qt1Qs+mEm8Z2F864Dl6bQsUo6vlWaHPcKW0fdauEqvv0pr8d2Ml0i9EZZYeTM8JPVS/4vQgluFWiP+f9YdGWvBv5pk6KEPk1rDA2RFu+ounGPfGhXZ5HZvPJy3BOL7a2CsiBKLNJchi6kPrA7/10lXAzsCJT6CLKdFafwXFmEjVVTpT/aIEBcwiQKuxjCqq6DR98wQW5iM5m/IUimHZqCtCCMwme4X2wJZgfnK/riRnmWRf9zaXd2acOql/d/V/BAWO0HpHENEKFjImTuONnCsGzx9zFwTgOO0mMDsyZ43fFkg8kGacXgeMP3Q0s8rTJcV16atjweXN0Z2PaR116v6CNvxhFyCHwCeQVSdXLQ8Xc9VT+DeEd3B/GIX1p0xatr1J5Le8vLJ/9UW62QphAqgye5BdfL1PsHydjpTbTYvsJMmK5K6sA8eugSVJG7otl0+g7HQ2unlHW//pTeTTcNXo4ux/wnevtmClba5JdNLn1Z/FHKilcogKp4GCsQaFakR9Q89VIh/t/uOKIFzjK/siUXofLmmSwG6rHvQAouRP/viJu5agP0A2xLJB36YWYaKD4GEJDcRvQh7VovmgiE8dW/P0ovAtLuRkbTIw7Sl7w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(376002)(366004)(396003)(39860400002)(451199021)(6666004)(66946007)(66556008)(4326008)(82960400001)(38100700002)(66476007)(478600001)(316002)(41300700001)(31686004)(6486002)(86362001)(31696002)(5660300002)(8936002)(8676002)(44832011)(7416002)(107886003)(26005)(6512007)(6506007)(53546011)(2906002)(4744005)(186003)(36756003)(83380400001)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RFRIaHlVNE81cjRsb1Zzcm1FOGdIZEJMVkk0eUJPTE9MeHp3ZEltNjQrSFY3?=
 =?utf-8?B?QlF3bURsUUhRcGo3c001akhvcTdvbXBRVmlvS1pPdEtUTUVQdUJib0pHdFov?=
 =?utf-8?B?NWNNb2dSMmlKdVhXUkU4NU5nM3dGUDM4bjYwY0RtdXZvcWtmWUNYMTJhTnd2?=
 =?utf-8?B?S3JqQ0pNS1pQMDlSZGoxZHp1bGdwbjZTMC96MXRJY3RlOStrcGx3OXVMcXhF?=
 =?utf-8?B?MS9kOEt2anc4bTBkamlSaXlXQ3ZUSTd2WldOak03UTUyK2hFUThtQ1U5em0z?=
 =?utf-8?B?R3RFZ2lwNHRRWUFWS2lSOG93MUVxU3RSQjdWc3hSeVoyM2Z1OGdwdktWeTVt?=
 =?utf-8?B?R0F0V3JZdjN5TnJDaDg1QUsrZVhZbWhCWk16ZnBCZDI2RjU3N1kvTXF0NDNN?=
 =?utf-8?B?eElRYXVpLzJIMkk3MStyMkFZZjluS290UmVaLzErbWpTc2pvZXZ4Y2FIT2hN?=
 =?utf-8?B?bmZ0bkVDbDAwOG9FcE1wdGJlSWlPdG5VRDEyUElsUXUwZWNZS2tjcDNKNmZr?=
 =?utf-8?B?d1VncnU5RFVpcnhURFQxdUdNQzFsZkQ3R294TVpzTklyc0pMRHVzemY4dXBX?=
 =?utf-8?B?d1BkWmtnZU53d0dKSUtNb0JISGc2YkRoZVN2eVN0MmVkTktER0ZoMk9EcGVm?=
 =?utf-8?B?V2pjZDFDWmVaeFJMZXVkYzBCcXNsalJJc1ltZXVMT2ZyanpFS3FXZjhqSFNt?=
 =?utf-8?B?dEhGWlpxVHdkQ1FpRFJoRnlTUkdZVVZJb0NFdnV2dS9odnBNMnJvU2JwTS95?=
 =?utf-8?B?a0pGUURvMEJORy82TjhReWl6VDFtV3I4Q1JnYStOaVlLb092NzU0Q1FCZjJ3?=
 =?utf-8?B?QnJkZDhSYThtUm1LTllGdkUwcEhjeVBaK244UUNwNHl4Q0Q4Tm1rc2tRNE1J?=
 =?utf-8?B?OUY1MWwvOXBYRm02bmQxZVpOU1pMVDM1SWZBOG5hOWl1TTUxNm1BSno2eU5D?=
 =?utf-8?B?RUdtN3dncHQvUnlWRGNidmdCbjEwZS8zK3Z5YmVPMEJXT25zNFFESFZ6dVJV?=
 =?utf-8?B?QW9CdE9kdVVZVFN0Z0JXdXBIdDJzazZkNkpFdnd0c3Y5QXFaNkZJTVdjT1hx?=
 =?utf-8?B?bGx4bDB3eWtpYjRFZTJYeWV4Nlc4TVNSeFdrRWhRdkZmRE9uNVF6N1V6eWV4?=
 =?utf-8?B?SVhRa0RLbHRCbkNDQTllM0xuOXJHSXYrRXhBYnVZU0l1bXVFOE9PM0tpK2t3?=
 =?utf-8?B?QXJ1MXhFQXFGYXErRGs1V0xKdWUrUGlpV2sxTUZINnh0OWRsK0RzWmNyZlYy?=
 =?utf-8?B?MWFQSzd6UUcwallNUXZseGZrV0hBRjJtek95M3BJMHhWLzZLRG5ybVA4VTVj?=
 =?utf-8?B?QzNUVW1Xd01pekU3RzRUNmxnNzBnQS9xM2NhK3ZZcktCVmxCZ0Rjdzl5Y1hT?=
 =?utf-8?B?Q0MzOXdXRmZJTGlDOVBrbWx4eFppUUt3U0tHd2NHckhDd3JFYWdwOEVSL21P?=
 =?utf-8?B?SGRYSGxrbCtWekMxeXpsbVNFV213NVE1Qk1YYWNHWmlIK1U0bmRtV2hSMkQz?=
 =?utf-8?B?WmZWUVc2YktBaFdmaC9yNVRlOTgrMWtha0M5UnB1blFHQjFRV2JlUmM4TUtW?=
 =?utf-8?B?TmZzMVN6ZnA5aC91ajBBLzE3eUFPamI0aWRmWlowVHMwT3dSK1grMEI1L1VP?=
 =?utf-8?B?dTNvQ09BZTZ0K1lrL3VJcytYVHBwbHY0ekg0K3V0elQ4a05vVmtoNUsyeUFz?=
 =?utf-8?B?RjJIOHJ1V2FIQ2RicjRZcWQvR0w1SUN3NkhCNlpUY3BhQmRkODU2V25zelo3?=
 =?utf-8?B?WHVQODd2bjI4ZCtva2ZDeVlUZnVxTUZOM0pKNzAyb0ZVb0ZFVWlkUllVdHZP?=
 =?utf-8?B?V1VhNWM5TUYyd0cwQ3I5dFprYS9ITmtPTDdQNHJ5S28rK0dOOG9SSWkxZ1Rv?=
 =?utf-8?B?eExHbzc2amtLYXNMOFBNa2lrUStoNktuT0ZreTYzdFNDZkgrVVZ5anlsMFZp?=
 =?utf-8?B?MzliOTZ6OWlMdC9NdXNDQys4dmtjcjc1NjNva284dEFjNW5BdUN2Vi9lN3pa?=
 =?utf-8?B?b0tZemNmbksrOFpwQzJtTGtiaW90NldNQkgrZklsVzhuRjlYVC9OMS9JV1Jo?=
 =?utf-8?B?RmY2cXpHdUI2VmxOc0ViT1c4R0R4cFJXeHhxKzBSVnAwVEttd3E3eHQzUlJ2?=
 =?utf-8?B?c084MTdyTFpaNEgwbU4rTTVKSUh1b0FwRDg1Y25JbHBYL0pINnZaVEtBcHhV?=
 =?utf-8?B?ZWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b61f5f3-7b12-4329-b7b0-08db5c7cd0eb
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2023 17:32:15.5615
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n/1TsWc7Isnbcr3C1A2/ettAltns8S98nnLtxi1d9TUg+FjIiVfwFrxwcxkHqeta53XMBkkNq+wxg6ojQiqpWyCD36kds9UVXabxEamdZPQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR11MB5368
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/24/2023 5:18 AM, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Move port_split/unsplit() from devlink_ops into newly introduced
> devlink_port_ops.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_devlink.c     |  4 ++--
>  drivers/net/ethernet/mellanox/mlxsw/core.c       |  4 ++--
>  drivers/net/ethernet/netronome/nfp/nfp_devlink.c |  4 ++--
>  include/net/devlink.h                            | 11 +++++++----
>  net/devlink/leftover.c                           | 10 +++++-----
>  5 files changed, 18 insertions(+), 15 deletions(-)

For the ice driver changes (and topically reviewed the other drivers in
this patch)

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>



