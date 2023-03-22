Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 744FC6C527E
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 18:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbjCVRdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 13:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCVRdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 13:33:44 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C079A2197A
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 10:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679506422; x=1711042422;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iV8NBjgD8gUOuHMXg9ZSbkIqtu8JgYLUmVMhsk1w8ck=;
  b=XjyOzN1xASYxAOs6G+vMx1N6wxUje3D91Ciqe7EekTJae7FuODQRHrBo
   BDwaiyh7iPjpVif+mYHP/eZC0nVkKVepp/NVmYljJXgvuvlClxjLDkwN5
   5oof+gE8tLY1ssITXJ1k0ONrtDjil7DSFCzpF575dc+xogD5av6kjQ4M6
   hgV7u7EugoIK7fe1HWFVyz9+LfPUnuUwZYrAHqnVdhddM0T189HzUA5ld
   YYzZZqap0Ad4xAIV8nqSmWOscvnuH7Vr3P88jW4ZkvzNe8J+IYakPk+e7
   Vol8AGS3+BSG0t2sBf4OJKu6LNewTpMvV16CQURQn3mTBNV3CaJNWPmr/
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="339320948"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="339320948"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 10:33:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10657"; a="1011458281"
X-IronPort-AV: E=Sophos;i="5.98,282,1673942400"; 
   d="scan'208";a="1011458281"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 22 Mar 2023 10:33:39 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 10:33:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 22 Mar 2023 10:33:37 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 22 Mar 2023 10:33:37 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 22 Mar 2023 10:33:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f62Wu0A9kyoCKk16RPCWj9FkSO41Prnnj0Ha6V6wRs+uJh2AHXDzBxlpqbmKb/b31u4w7y9Xu7NJl+PHhD7R79eS91i/V2VVmSbZA5NML2AyLcy0BeTmztOQkHxDGAKUVNEwB2XfvRahE7SFChfoVwSHsSs9blGvUZA9YvSR/NEd8iA6+N710PtPiRYX2ECPAsS2ph5x0tAYqTqTYZH2OCd5I/euVJMoRcIBKrlHuLIIZZTYcsvLKmc37oPgXTVlnySBo1KPYgV1JZmLNS0PySuWFNx3+iwhEZwHp1vbVBaNxwzSQwf3Md1h6txyJJWPg+AlXpItzfO4SmVKFMning==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aXS5wAs4nydufTsnTSXL4EdswUdGKFC0PrIr1WnJhLw=;
 b=BcbUeljxzb54zsUxKKyPb16ktI9inXwiN0lE2qVhZutCyiMF22jZ+aIPDQ1Ta18uur0aaIbxu2P+a/cOxKSokzsV+8M25OQiNTIEB+icwBa9mKu/zCtDzeRUebrCI3PQhn06L5TsDdOCYgd8drCkYUZDueuSe9usqo4vGeRiIRUjukp/Pk8aO+md63Aw3QlH9fMnD4SiNUpNizSLU6W/U0gc7pJZNzsHqy+ZAE4XZipEIOzJVpZzOqxlXZVt8O4m2KrRqg/FzGV3zohzihbXTiiLz45gK7jTa9aO0Ia8OieDowTbvSLSszrtxzheUl6MW2rb+vj9o3ZxZGkvf+RdjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from PH0PR11MB5095.namprd11.prod.outlook.com (2603:10b6:510:3b::14)
 by SA1PR11MB7112.namprd11.prod.outlook.com (2603:10b6:806:2b7::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 17:33:33 +0000
Received: from PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::9612:ae25:42a4:cfd6]) by PH0PR11MB5095.namprd11.prod.outlook.com
 ([fe80::9612:ae25:42a4:cfd6%9]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 17:33:33 +0000
Message-ID: <ec5c3cf4-49b6-32fc-d7cb-06410d6497da@intel.com>
Date:   Wed, 22 Mar 2023 10:33:31 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 0/8] ice: support dynamic interrupt allocation
To:     Piotr Raczynski <piotr.raczynski@intel.com>,
        <intel-wired-lan@lists.osuosl.org>
CC:     <netdev@vger.kernel.org>, <michal.swiatkowski@intel.com>,
        <shiraz.saleem@intel.com>, <sridhar.samudrala@intel.com>,
        <jesse.brandeburg@intel.com>, <aleksander.lobakin@intel.com>,
        <lukasz.czapnik@intel.com>
References: <20230322162530.3317238-1-piotr.raczynski@intel.com>
Content-Language: en-US
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230322162530.3317238-1-piotr.raczynski@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR04CA0005.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::15) To PH0PR11MB5095.namprd11.prod.outlook.com
 (2603:10b6:510:3b::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB5095:EE_|SA1PR11MB7112:EE_
X-MS-Office365-Filtering-Correlation-Id: d4266012-875f-42dd-4bbb-08db2afb8f10
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bl4jUXy7EV0HoZ6xMbiPhHXCyjYTw9oIsoPEagagcGlxhjGxfTXNbKSw10xwJULEWEqXP1Kic4vtZ0O4Yj8++vEdu0ccC3ekzxwTAN3C12UNej6XV2cJ8Cf4+Yn/7TAxSUpBTX50TZHMw6YFpoHMFnTssL4QY22rDaiDCNl9UCEZo/PdjTHVUY5ik4Mb2dTtxSWpdvnxRJsRSFCLGI2EUNYBeTaiM+bqm+a0Idp6cR46QNcPZ5mprxasbOee8gW4/TrpAXUaPiwb0du/7BIzhy8/Pv6WLTILB7DMsVD5OBTp/JRFCri4RnYc4uY4Q5RAZ60z8KYRrQUJbNP3kkaLPU/9bHyqDY+Y/heFEjwGyNniWT4LBHGC8w8v0hHpwBxBLT/SM/wiBFCKV6tXPnLYNQiAZhxV4+CM5LCV8yy5DtdYs1BEAZNckup41GKBbzgX40bPMKTlRxLokSE0N+MEYv92c/IhctG2A7fXSETjidkzjs51Gc/x+qtSG8o83YraVlLaCSkxWjgZyjHgLdTR8omHJDxQWpM6HFsj0zRGzzY/tBFrJtf7vGFem2ilb7uxIC0JX6w1OA0do5ZUfts0l6wQoCDchyfO7Udk4h/d5c+Ld+U49oYJ27hKyfOYWM7ipHEqavXA6U/gxraoJv+gl06WH+8Uh7D3y0xhBMcSWxx1ktSSd3eLMMFmja2WuiuJny9vUdqif/tEecdr6y30mamLYZ43is9SbSRf+eY7Mps=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(346002)(136003)(396003)(451199018)(38100700002)(31696002)(66476007)(316002)(66946007)(8676002)(4326008)(83380400001)(36756003)(66556008)(8936002)(5660300002)(41300700001)(2906002)(478600001)(82960400001)(86362001)(2616005)(31686004)(6506007)(6512007)(53546011)(186003)(26005)(107886003)(66899018)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?L3BEeUcvbW9SZzN3YUgrMmY4aGtlcm1Ybmx1dDhUT2I3alA5Y1FvbDFHWVAy?=
 =?utf-8?B?SFJJRzdCYS8yUnFWbnZGdGx1RkJpRXI5NkFzVDQ1SHZoNGxXbGtGZkpmSWZP?=
 =?utf-8?B?bENYOGppMjdRanhHVG8yRG9UNURwSzRreWJQSGgvTkRNWnUxaFhUanhVWmZi?=
 =?utf-8?B?Y1huL0ZnRzFUTE5Ec1NKejBsaG1yY0dOcm8renVPc2M4WEFWR1dhRHBWQUpY?=
 =?utf-8?B?bzlkVFVWbm1yTXZvZFJUZkpvWWxORlVCYnlZL3gzMWZwTE9nMWc1NFdNcW1Q?=
 =?utf-8?B?WG9ES1kyREdBSkE3dHMxM1pCUnpKS1BDMkJaQ0l2TVloaVV6L0NqSnYyc0Ny?=
 =?utf-8?B?MXJrc3FOU0tRUFI1TUQxVW4zejFPbnY1eGtKdy9vOFJ5WjVoZDhMUGQxWkFO?=
 =?utf-8?B?YkZ4N2xUem9PNG9VbnhDYUJ0cTNCZEpZWkoxVis3WU42Y0U0TXByaVBVT0h0?=
 =?utf-8?B?d3RMYktmSUlCMUNYanE5QjNUVjlkYVNpdEZ3MXNQRjQybG1DbTdSM3lpWXFX?=
 =?utf-8?B?UDJkZDREQVBvMmtBZUJZSWhBaDZOOXQ1aUp4S1JhUFZYRlZaWDJ4UEw2ZHhS?=
 =?utf-8?B?YnI3eVVCMDVONjNSQUlIWUU0cFYyOXZJSnk4QlFINDVpa292T3N3bUI1aDRJ?=
 =?utf-8?B?VzErN0JxV1RBbVNYZkRXMm9OaHNIQm5FNHQvdU1Vdk45eHA3dVJDSjZ6K2Ez?=
 =?utf-8?B?VUpYNDJaUm5NNkYvcGRqUytQVTBXVTVyN2hpaWRmTUM0cWlvaklVclBIS09Z?=
 =?utf-8?B?Z2cvZUU5RU9TRGNwMjFJU3liMEtiT2Y3NWVneC9wNlhCalh3cUxFU2N4RVBq?=
 =?utf-8?B?YnJhdHMxZk9Zb0JhdGY1aWdobzNadkoxbCtmak9sM2NKWEpnS1YxS0U1MFp1?=
 =?utf-8?B?U3I4a2tZWnFGU1o3RXNYWTFROFdoeHJpTFU4TVpvaGxjU3VDdTFUUURsU2NV?=
 =?utf-8?B?eGsrQ0VUQnJ6T3hBMU15T1lmbVBiZVVDL0ZRdG1aSWYyYkdCL2Q4MWVadmYx?=
 =?utf-8?B?ZEtQcFNET0VPY2pZdzlaWHM1UUFHcUFUUXVKak45MVk4RzJqUTNPUU13MjM0?=
 =?utf-8?B?WFM3UHAvckJxUVliV0I1ekwvMXNSeXpMK1pISjZIbkpVUm01M2U5UkQwOXYw?=
 =?utf-8?B?S0ZDTlE0ODhtUFZYTkZCZlpHN0ZZaDlwckhIREY1MlRTdDQwcVVoSmFMQmhE?=
 =?utf-8?B?c3o0SlZCK05FR3FZYnN2WC9MR00yWW1zVUpIaHY3WjlmS0VJS3dNWGxzYVVx?=
 =?utf-8?B?c1BWNXJYRjVVSkZkM0RtNTc1RzU0cU9SeG9jUVgreFVIWGRRZUhuUURLc2hV?=
 =?utf-8?B?OWdBVnNOMEN6eFY1YzkweUpJL05nczQvNFpxb1Q2WWdzN2JmSi9xdGdmL3Zk?=
 =?utf-8?B?dVpFa3hLVFN6WWJPR3UrRzhEdm5ieEt1SFNRZldGRUo0VEtBQzRiMUFvM3NL?=
 =?utf-8?B?a1R1TTNwRkRIVHlJc2d1dmd2bTF2elZHeWtiWGdQdFlVZjIrM3BHcHRBSXVG?=
 =?utf-8?B?eTNETGtiSVdnVGo2aWxQeG94WTk3eVBnd20wL0F0YlhkYjgwcDRGbEhIY0Rt?=
 =?utf-8?B?dC9vdjh4c0d5QVpCTUxlbG0yaEk1eitXemlKcWZteTdCSGJVc1NvYVlxMkts?=
 =?utf-8?B?NFVYdWU5cDFibXJDbDNzYmJKUGpYN3NhS0xtNkt5N0d6VVhVQWJ2T2JXQkMr?=
 =?utf-8?B?YUtrOVE1cHhWMWZZeDhRcWpaeWVYYUtnTDJNcGY4T0ZId2FqOExmdUZkbkUy?=
 =?utf-8?B?a2xpODQyRUVzVm83ZUU1N0hjZkpobnlKT3I5cDNBeXhRNXpVRWN0aDdLRDli?=
 =?utf-8?B?R1AwMnE0aitlZTV0Z2dURldCVGI4b0VqRnFOeHZxZjZJcDdKNjk1TDRMZGJa?=
 =?utf-8?B?NG11VWhwYndrbE9RNE1KUHFrdUZJaHZWSTdmSE56V0tWT3owVnE5R2JOS2Rr?=
 =?utf-8?B?NXhya1F6ZEJXNkJWL09keCs0ME1CSENaNG9kVVhZcmZFNUlNbEZ6ZE1KRlBk?=
 =?utf-8?B?bWxVM0xQNlZXUCs3dnh3bnhSZ3p4RTVwMkxPb1RYUjM2aUlYTG5peGFQeVVC?=
 =?utf-8?B?akFYbHN4dWlPUStaMWU0bmRNVTNqNk1UbDB0QXRZUGRqMFhtb1NyRm12SmZ3?=
 =?utf-8?B?eVhBYVZxU05BK0x2ZW5XRHN3clZwaHJmbndMZzdTYjlMSTRjdkc5OGk0UzNF?=
 =?utf-8?B?MWc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d4266012-875f-42dd-4bbb-08db2afb8f10
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 17:33:33.0455
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WNpBBSmcQiQbo+Nosd6NdsGF17xayIggqgteVAJCz+5LNnm5xiU5Ve/b9dfA8RVfm2goc0JUE7bpXNT930gL56c7vrEbuPVO0BBbHr+3D9c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB7112
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/22/2023 9:25 AM, Piotr Raczynski wrote:
> This patchset reimplements MSIX interrupt allocation logic to allow dynamic
> interrupt allocation after MSIX has been initially enabled. This allows
> current and future features to allocate and free interrupts as needed and
> will help to drastically decrease number of initially preallocated
> interrupts (even down to the API hard limit of 1). Although this patchset
> does not change behavior in terms of actual number of allocated interrupts
> during probe, it will be subject to change.
> 
> First few patches prepares to introduce dynamic allocation by moving
> interrupt allocation code to separate file and update allocation API used
> in the driver to the currently preferred one.
> 
> Due to the current contract between ice and irdma driver which is directly
> accessing msix entries allocated by ice driver, even after moving away from
> older pci_enable_msix_range function, still keep msix_entries array for
> irdma use.
> 
> Next patches refactors and removes redundant code from SRIOV related logic
> as it also make it easier to move away from static allocation scheme.
> 
> Last patches actually enables dynamic allocation of MSIX interrupts. First,
> introduce functions to allocate and free interrupts individually. This sets
> ground for the rest of the changes even if that patch still allocates the
> interrupts from the preallocated pool. Since this patch starts to keep
> interrupt details in ice_q_vector structure we can get rid of functions
> that calculates base vector number and register offset for the interrupt
> as it is equal to the interrupt index. Only keep separate register offset
> functions for the VF VSIs.
> 
> Next, replace homegrown interrupt tracker with much simpler xarray based
> approach. As new API always allocate interrupts one by one, also track
> interrupts in the same manner.
> 
> Lastly, extend the interrupt tracker to deal both with preallocated and
> dynamically allocated vectors and use pci_msix_alloc_irq_at and
> pci_msix_free_irq functions. Since not all architecture supports dynamic
> allocation, check it before trying to allocate a new interrupt.
> 
> As previously mentioned, this patchset does not change number of initially
> allocated interrupts during init phase but now it can and will likely be
> changed.
> 
> Patch 1-3 -> move code around and use newer API
> Patch 4-5 -> refactor and remove redundant SRIOV code
> Patch 6   -> allocate every interrupt individually
> Patch 7   -> replace homegrown interrupt tracker with xarray
> Patch 8   -> allow dynamic interrupt allocation
> 
> Change history:
> v1 -> v2:
> - ice: refactor VF control VSI interrupt handling
>   - move ice_get_vf_ctrl_vsi to ice_lib.c (ice_vf_lib.c depends on
>     CONFIG_PCI_IOV)
> 

The other option would have been to make ice_vf_lib.h have a no-op
function that always returned NULL, since we generally would know that
there are no VF ctrl VSI if CONFIG_PCI_IOV is disabled.

But I'm ok with it being in ice_lib.c too.

Thanks,
Jake
