Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53AB76E023E
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 01:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjDLXGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 19:06:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbjDLXGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 19:06:15 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDAC430C4;
        Wed, 12 Apr 2023 16:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681340775; x=1712876775;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=UiJ3IAJfZ0GmylAQDH3vkY+1ju5cB1Zdr5QtEU/0BWM=;
  b=HWhh0Y4nJs1vnuCs86XsZ7wblNw/yDl//VDtOmavQZxlBXshgkKCxVJM
   /McKqgh1P+TdlCOriQrqqmgZaArRiSz28rb4nRM5Yv47NBGN5Db7LM2mz
   zH3I6g29IC1YVi61FcRoNFXiJKRjmKEdjpmKmBFbEQO7EymDbegch4rw0
   LDF4QtVMClhkib0GqYBiTa+vfFEh2auC2TwrNiWOw8BQJUAbpkEbDYZZx
   ul5kuXRwjEwOH4dhQSqfguAYrOhdkkTaY7eKSq5GS1mLS0W9jsssEGedm
   hJH5c2m5htJxBJirMcwBpKyliFMch97RjFpxzb2fsL0GUVpNJ5nmBI9lD
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="371892846"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="371892846"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 16:06:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10678"; a="935301584"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="935301584"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 12 Apr 2023 16:06:12 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:06:10 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 12 Apr 2023 16:06:09 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 12 Apr 2023 16:06:09 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 12 Apr 2023 16:06:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Otq5jPLfNU60XfQusqCZjmKpliE0HshQ3p/n2k+/AJ/BlkySq2R71vozU/nYRJu+FT4f+BmVIoCHvKVf/GhJHaLAg8QWg9gH/8rDQmnL5Su7G/8laC3xwmMinqvmbYeSho7t4NX8DGFBeMx4/nH8kIGzO5Ilii5joOQkgxfGcC/UQdo6lDxzo/Cxrw5uvShkQtw+D1+QZS23jUNKh2parPWkm/9hd0u9Lytr8K0G9FcjwGtSilWuam3Rxg3QAl4x6xts8JUEaKWJAltvrjHzIwUnXkR/zHllQA4GPtndtwPMmaywWkbts9+SZCxGoEHf7WMsyrGRzSd7PNq8hWA0hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ed/SHrhJ9q0scC+3Hd5MxomgD4ljYQmrHTtT0QnGcC8=;
 b=iiExfMkOrpLXdiZyj2hv9cZvYKs8EInGi+IiyuWjCRDsthzVcAafhWOC2LR2u7/XD5BaQ+vMBbb55EmIi4bYfgyLNgbUsITxDZS3XVVvi+4F8bfedntl0dykxhqirrKrd/uJb0gZt/BrS7FWe734yjusOBue66RRz2bFV7MfZ5EIs3/BRyvgomWMcVjbOQscSSQfSGkhwc88c2sgvAW4D02LLbYLA0O1oj2jhOYrKH4li6LiVT4eMARqevqRUJJCISQ/D/Fbqg+f++lzOlTNPfErdd9HWjnsn7mxhCeoC0/Py/kvDOnfKNG+lOcK/wXJJ0zbrOEmrrUGCovOLed0Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS7PR11MB5968.namprd11.prod.outlook.com (2603:10b6:8:73::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.30; Wed, 12 Apr 2023 23:06:04 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::6222:859a:41a7:e55b%2]) with mapi id 15.20.6298.030; Wed, 12 Apr 2023
 23:06:04 +0000
Message-ID: <f7038215-f821-0f44-436a-192058683fa5@intel.com>
Date:   Wed, 12 Apr 2023 16:06:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [net-next Patch v7 1/6] sch_htb: Allow HTB priority parameter in
 offload mode
Content-Language: en-US
To:     Hariprasad Kelam <hkelam@marvell.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <naveenm@marvell.com>, <edumazet@google.com>, <pabeni@redhat.com>,
        <jhs@mojatatu.com>, <xiyou.wangcong@gmail.com>, <jiri@resnulli.us>,
        <maxtram95@gmail.com>, <corbet@lwn.net>
References: <20230410072910.5632-1-hkelam@marvell.com>
 <20230410072910.5632-2-hkelam@marvell.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230410072910.5632-2-hkelam@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR16CA0003.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS7PR11MB5968:EE_
X-MS-Office365-Filtering-Correlation-Id: 7312c20f-8be1-4998-5b6e-08db3baa7d46
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 84rrhcsf/o117x5tnvSAqRHJYH16OkVBDT21gcsZmH1+k3T2/XgTLC2Kb+25pzq1T3JDrqia+cemUoNcpx7oJezT2lGK/a+huSmai8IGJhfXOoxzkuRoEj7mTjJqSDR/OEke/L8ijv9BwLrvSyfonDgNAI6QWkFhTOUbYlIQr7Zo8GjEHpz5o9WFfr+VRQMP6spgQJukqn9bJ4McRORXOZhc/lB9zpFrigtjSZ69exSCLrYM1ht0UIJpdJ2W036tU3Zx4EK8In8EeAABaovNl7q5jh400igVLIuCprW1t5ZYYeIJUhq1gg4AzGC7HI/EcPCPTmfbgu/tdKs2FIAdLsRW7WflaRC3iYdxSPx4ap5arl8TMmud4ZoJrjnasSwnc56B1DiWpcwcxK/816ITS51udoU8zuVSLeqJZDXtcWpHbGuTI1FijJZ8PESrb2O0aP6lBYY4tDxYnncc5jdjrVCNGuYG8i4k6gtClKT0nieZxUqBYxc8nuGBe9Uhhky/t3t4yLdo/ig6EptFoW6YSUW5epOG0fGsuhBo9TTGMocd/dVmahqkW02F/aywRZozrvtE+S2WJ8NqwfWLmlk4RHeH3g3LJDFZEHnkuTUgie/gSq0NDk5/EBhgyF4HWgdxzwlsyxcXKooSbEihPKmjGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(136003)(366004)(346002)(396003)(451199021)(2616005)(7416002)(82960400001)(41300700001)(5660300002)(4744005)(2906002)(31686004)(38100700002)(8936002)(8676002)(186003)(53546011)(6506007)(6512007)(26005)(6486002)(36756003)(66476007)(4326008)(66556008)(86362001)(66946007)(31696002)(316002)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmN3RnZROWoxU2NEZVh1dW1YSDdUcTlqLzA5dEV0dlp6aDJIUmNRRFFIUFMw?=
 =?utf-8?B?OEJmOGV0MVdhaCtBLzdGTTdob1VuaThjVDZOVThDekVrQlpoZk0yNkdmYkVF?=
 =?utf-8?B?dm1CellaUzBFU2lmU2VVRG11MTNuSk13WUpyTjB4N2JZdHNsaDBPaVo3R0pz?=
 =?utf-8?B?M0VodmZTVGl4VlpPNjNPeThDZk0yeHoyd3R4MUJSVVpFNnVxNitudnArV21n?=
 =?utf-8?B?VXRuTVR5UkltYkJRei9ONzlteHV3ZElqOTBFM3poamw1WDNnNmRoMWZXWU5O?=
 =?utf-8?B?aUd4aTEzTDA4VWRkbTlsYzZZUGlEOC9hUTl3T01rTVV0TkYxNkt2Q3ErblA0?=
 =?utf-8?B?K0llU1ZIbEQyTnlLU2hYUkI1UDc4eWxGRXBNbkVFTWtlTERFbW92OXJqazBz?=
 =?utf-8?B?Ny9tbTFBazNpdS9YaGkvcWszUTVRNTdTbVowTHVwMGxpanpJR2ZteFFWbzJO?=
 =?utf-8?B?cWN5V1Y4RTNyaFJqWUgrSkJrTFNYaTFPUnNVVXJpUkxRaGdSTmpSNTZINVUw?=
 =?utf-8?B?Wmtmb29oUGV6YjVVQ3c1VXNMWGpQSklYeTdOYU4wQUQvOEFqMDZLU3RydzdT?=
 =?utf-8?B?Z3F6eEVFUWdpUDM2QjVvR09iUnE0Q3pCTnozTktlbEc0UFo5NlNXTFB2SS9w?=
 =?utf-8?B?akdLQkFDWjlXUU1nZ1Z1cm55NGR4MDBvUHJzV3RSV3NJTXo3UmphMVRIc2pW?=
 =?utf-8?B?ditSMk4xZmFOVGsydHNSelQwT3VzZUp2Z2ZIazFxS2JhZzBLL1B0bmppN3BL?=
 =?utf-8?B?NU91eHRaaWRGS2dsQ2l4MHlCaXAzR0V2L2k1dUp6aDdOUmE5dk1YT0hlblB1?=
 =?utf-8?B?ZTBpQ1VSVWZVbTNlTWNUZFlFYWN1SzNIYVZvRHdnZkRHZW9lRkNMWWZsYWZj?=
 =?utf-8?B?VUFjYUdiVWZHbFQrM3lLSmwwYjh1L0FtTXRVNTJacTdCM2xOVUlTclZSODM4?=
 =?utf-8?B?dnhVb2w4NjRWbGRmY3BNTlIrWUZBWFQ3dkUrTXdwellUMlpnK3psUndSU3VO?=
 =?utf-8?B?NTJ3dHZmZFRoUzIrZkNJYkdQTkpxVG4rRFcycXdLRS9nd3M2d0hZMWY5dHlU?=
 =?utf-8?B?Nkk5N01kM0cyOHVOcjNLRTNJVUE4V1IrRHQ3dXlJei9pWEx2dGtDS3RCYlRy?=
 =?utf-8?B?L3AzdEZGcHAwbTdKM0hsS2RnMi9pbkx3NkhHN0hvbjd6bk5oOE04TFdpemlE?=
 =?utf-8?B?aTgvMjl2ZndmQVB1RW13cEJPWTRNOUp4K0Exczg4THhEZkVQT0E1UmtrMWF1?=
 =?utf-8?B?SXlrMjZVN2N6MGthK0FzVCsvaEJBSWpMV3dkbTd5N3ZEK2dZbEpKeXBWZDZN?=
 =?utf-8?B?eFpIL0xEb3NDUEExajFsVi93NFhrZEoxVjJjdVlLbENmbCt0aEZjQUFDeEpk?=
 =?utf-8?B?QS8weEZTazJlUjAxOEg4ZDlMZ09zN1FVZEJhbmViMkJFTGYwck1pK2pLS00w?=
 =?utf-8?B?bFc4N2lDY0U4UEtLWVhNZDlXZmovdWdXWktvYUdPc1llWXBrN2dtVzZDRXVh?=
 =?utf-8?B?bUJSWEczbm9wN1pKQTQ0UzZOMGx6VG8yUlFFa3hXaTE2ZjVNSnE1eVFNVkpK?=
 =?utf-8?B?b0lwUklqUkZrVWlqdklMNXkvTW4zRDMvS2pXZGdOQ0R4UTg3NTNHNjBIOGpy?=
 =?utf-8?B?aG1zWEd1TDcvTlhxV2VwR2JCL1dxNnRrNHBLYTZKUDdFb0xZSSsrbHlMN2pw?=
 =?utf-8?B?ZWZINy9TYnp0YjFQY1FHSGRkTXRtb1g5K2VDT3VvMU9nVjRGVE9tVEJzaEVM?=
 =?utf-8?B?RHF3WG9ONUt6WG1oNy9wQzhNVDk3V1o5RXBLdUE2VVJRbGNreU52dG42aXQx?=
 =?utf-8?B?YmNXZzF2Zk40UGI5OGY5dm1kVXA2NDIyZWRTUU1HUzBLSTJka3lhcW1CV2Va?=
 =?utf-8?B?MXdKMVFtdmRqZGo1bWhFLzdsZ3d5aEdIU1orazhtVGVOZVcycU1Qd1FWeEgw?=
 =?utf-8?B?bVRJWm5UN25ROG9jVXBjSnBUSlF5K1NVbnd1dzUvdUhEWWVmQzJrMWxGRURG?=
 =?utf-8?B?cHBLdUhiaG9mOHV3dFU1VEJuYkhYQjU3bFc3Y1czUk84QlNHY1dXZ0pOekpi?=
 =?utf-8?B?WGZ4bmRjbDY5bzBWSzZBNzJQamtaS21PTmhnbVdZY3drYXpjcWh3cjBaYzRn?=
 =?utf-8?B?eVFpb21RbDZSakcrVGwrRzgvNHg5S2RIa0ZpZ05CWDNlekRjT3lSYzhWcUxn?=
 =?utf-8?B?V0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 7312c20f-8be1-4998-5b6e-08db3baa7d46
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2023 23:06:03.7574
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hrnNLuBLXAOKD2d5IMK6KY63xUItfd6jsLKig8khEegCVNAXr6brNnBA3NEjoVlyWoDSJb6KW6apNG7r1SRvQL5pABJIW1rgxlkSN1fa5vU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB5968
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/10/2023 12:29 AM, Hariprasad Kelam wrote:
> From: Naveen Mamindlapalli <naveenm@marvell.com>
> 
> The current implementation of HTB offload returns the EINVAL error
> for unsupported parameters like prio and quantum. This patch removes
> the error returning checks for 'prio' parameter and populates its
> value to tc_htb_qopt_offload structure such that driver can use the
> same.
> 
> Add prio parameter check in mlx5 driver, as mlx5 devices are not capable
> of supporting the prio parameter when htb offload is used. Report error
> if prio parameter is set to a non-default value.
> 
> Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
> Co-developed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
> Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
> Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
