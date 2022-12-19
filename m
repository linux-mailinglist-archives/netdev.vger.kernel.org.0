Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6445C651192
	for <lists+netdev@lfdr.de>; Mon, 19 Dec 2022 19:14:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbiLSSOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Dec 2022 13:14:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiLSSOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Dec 2022 13:14:50 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6904CD68;
        Mon, 19 Dec 2022 10:14:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671473687; x=1703009687;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=hJlLzmI4sOpFeX5oMxdeYh8NCImuW7B7M2cY7fJdl9w=;
  b=bIQNQvu/JKYz2o2sYCBvK5YhPSRZhtns+r9p5PjCMbjbKUnVEkGsV8vk
   qlRhrdfiJtvItm58MGQdEtJ/zkShOUZYTt37DUMAhHM/68hp6IeeQoDjV
   YcNu/Gjyp0gRqSOmjkDWZv9ck3ZOH0wi5qOclgb4YopLcVAT/3QGzvF5l
   tbnCvRXdytxt3tlGLZxE9+qReR0OqDl+1rUZ0UR+It/GiIqw89+6yiK4g
   wUhFK4doPyWDMJnydZgjAMEOO3dauqHh2lAKyViVtN03DWEZxoJuNS+14
   8E0Q/JLHJNLZ1Jg/YbFeA8y1beQh9Fw4rdohixsF0fXMZ7FwR9z+QwFie
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="319465118"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="319465118"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Dec 2022 10:14:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10566"; a="896118612"
X-IronPort-AV: E=Sophos;i="5.96,257,1665471600"; 
   d="scan'208";a="896118612"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga006.fm.intel.com with ESMTP; 19 Dec 2022 10:14:39 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 10:14:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 19 Dec 2022 10:14:38 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 19 Dec 2022 10:14:38 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 19 Dec 2022 10:14:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LSzvH3nGt42yxwx9Mde6RnAQoLV08WmS20jssX4Udlz46O8mc4ryCnjqJh5GHd9gdAi+3xPWuDw5Cf0x2jTk2wUdlmaGqoQjWo6+wGpP3om30ugiz8enyiIqVr9kzTzCpD/4undABylmwk2TngitWb3qiBNzTqWaNwaQi+bV+TdH4htCv2LCd2agV0CukNuClHXcqnOwlMIH5w5cqXBTL4cMPZkESL9zHK60/KIjPOmr7p3UNcfzqu/o8PrYzviPsFt3x+R+DiPazgDYSgKlO1ghVORED61l42LCo9kco/bxZGdKmVMXfwBEQKBgpKlSbUoEPKYy7M4/a3r8P7/v/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9Q/tqw2eSgljA3ld+EpiX2xB1FgrjcbBkqquGtP4FKA=;
 b=GXjUfPn4ZqB0tYxHKgNco8jR7YMuU+YSQ1YspkP81W1eA1Txu7s077ZaJiEEctNgeNYBUQlKJTEiXfqmQtdCxnn35PTEIC25h0cTPQV5yt8G3mGO+RIh00hWCvpOy9zMe1CUnmbCz9lfNf/0xUvKsevrI+t/oWvfXnKT9FXWJ12mXSWmCEJjSVQHi16XoFgau0uKEIRSX3zrYVH8VFjRmmdCI73IG5QFkSQ1zFPHVPeof2AQtfbK8Zxk3NwukaO8aeOD4R4oiegwGenhXjG1e1yMfyQTc+XpygPZm7LQ2TqeuzPRozL/EnO76D3JzTWPaxlT/72VCwyAz0BXnhJxgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by CH3PR11MB7347.namprd11.prod.outlook.com (2603:10b6:610:14f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Mon, 19 Dec
 2022 18:14:34 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::f5ad:b66f:d549:520d%7]) with mapi id 15.20.5924.016; Mon, 19 Dec 2022
 18:14:34 +0000
Message-ID: <c0bcce98-0ebe-6187-cf57-01b4727e656f@intel.com>
Date:   Mon, 19 Dec 2022 10:14:31 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net 1/3] Documentation: devlink: add missing toc entry for
 etas_es58x devlink doc
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-can@vger.kernel.org>, <kernel@pengutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kernel test robot <lkp@intel.com>
References: <20221219155210.1143439-1-mkl@pengutronix.de>
 <20221219155210.1143439-2-mkl@pengutronix.de>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221219155210.1143439-2-mkl@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:a03:80::33) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|CH3PR11MB7347:EE_
X-MS-Office365-Filtering-Correlation-Id: d261109f-7ce5-4630-35d8-08dae1ece1a4
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DgQuXQ/7wl1mtsatEWlBe+NbiXIBgCTLWdaUobCZJy9wpEqAsDrWU1wM0iE9GZ+agOYx0bizINJH3gY6SYV5oxMV4l7CmmSKnisgoBVuxEZxJ0cVve4P60txeHtdfxPDhaM4f7bzWH4BeFAyCkUHEQFpMcBhWqYxiq4L+YnPtcZEq6lLhfS/vduM6TEiIGzanLzp3xGUiv2cYQ9wauCSfdSZ70S9lhIYGv5vB7OsTGGWsTe2wYVK342vh6GilLWpveakhxG3zXiY3clZd47lA1JFBKL9ruMD2uZ6hqjWJR0DmNLkAjaIwGnaGlTGQMHh/e5u61jLThKr67dbXBZJY1uJxsjvQsaBkEM6jXRsYJewXhEZCeJdBWvPosJBvy6tih5zq29qKvfn1MwcV3Ngj06qAlvm8A8C4J3QtmcgxhU6OW1R8cx1kPfwHrYkSV+MCHcQWQFDtqgZSjERnDsTkLVYCL/AC20YcYDVVNsMaM+w5DZaSI3kjL5qkoXltMLhG7D4CxLmFv46bW0qZb5ceuEvO/ycA9IvQ98CeTC/bMb6kTgIIcOhzeJ1FwOMcsps8eISkN6sgIhymDiHNFb0Gi970eVq/iMY6NP3roElWDNOSeAcjVH9QGy1G9R1A/YKN5Mt5vnLqdpoItCL3rKw48/mUqM2gw4nUQEsD7CZqXskC2760f0Q+rXg27VKR2LIKJGu5cRMS7+NwHFjU9fdlwIkuTBBvJYgbvQKaoImWM9ttnC3GnUcnINvXfRxGz6IEv31pYk/H+k2vL+Sq2RCtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199015)(6666004)(107886003)(478600001)(966005)(6486002)(31686004)(6506007)(66476007)(6512007)(26005)(66556008)(186003)(66946007)(31696002)(86362001)(316002)(2616005)(54906003)(36756003)(41300700001)(4326008)(8936002)(8676002)(5660300002)(2906002)(82960400001)(53546011)(38100700002)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekd6NGxqVHZZbWkvZGxJZG1teDQ2c3dWRkVmNitsbFhudGdPMWJiNCs0Rmtz?=
 =?utf-8?B?VHhPWFcramFkYjdiQTREUVdxV2psOE9iU0hvVVh5TkdaeEZrdWtLNnJ1enBx?=
 =?utf-8?B?SmUwTTVqN21UaG5HVnIrdCtkY01qQVkzVlNKSElnTStnalpWaUdoam5GZTdQ?=
 =?utf-8?B?WU0vYzhhZTJmWDdqWWc4Q3dFREF0V0dsVmVWUjJ2QkY3ZnJEcXlyVlAwSGd4?=
 =?utf-8?B?RjNSS2VrUXZSa3ZxcVd1cS91YUJQakJkU3d1V2ZqL1dod3JBekliOXdOQmpD?=
 =?utf-8?B?eGF2d05XdVByVmJmMUtIbVREdXpTa2R5MW1OOFFySVRGcUNXNWRyR0lxQlZY?=
 =?utf-8?B?NXpGKzFoTzNaMHVMUXpUbnlPMkVjNFNvMGtsYWpVbzErV0gwZmsxK0ZwdWRG?=
 =?utf-8?B?cEpPa2ZYUFh1S096RGJVcitEK2xFYkdQN0tsZEFkVU5JMloyRE0waDdLUHBO?=
 =?utf-8?B?ZkU4TXdiZmREdHYxVDF6Q1U5SnN6VDBkZG9VZWdheExUK1N5dThCaUd1REVR?=
 =?utf-8?B?a2kvLzBSc0svcEhvTDVmcWtDQnJZT2Z1OXY1elpxeVNvWnozNkZkRUEyZG1V?=
 =?utf-8?B?RW9Rb3crRmNVN0ltWWR2b3lOSXBwSFBvWnNRSFIzcDJYZEpVNXZ0aWhpVnVH?=
 =?utf-8?B?dzhrbXFweUkrR1hIb1NFM2tOaUdoS2NCcVVoSEtGWFd6M1UxOEwyUXR2dVEx?=
 =?utf-8?B?TTBxL3ZHUGVueDVheFV0VENBNG84Q3lHYTY3c0NQRjZXMUNLTU9tVnlFOGZC?=
 =?utf-8?B?WXlCMnVNSmNaNzRSZ1E3YndzbFJON3ZWR2pxWStYRW4rbjluN1U5QjJNWk5k?=
 =?utf-8?B?SjJ4d0g2bkFLWlZTaVYxOVlxYU5aQU16RXhLRVkySkl3VHQvRG1VU2hheVho?=
 =?utf-8?B?aTNnT1VDT3hvSm5SRStCeTZKNzJxME9HOEFGb3ZJQXhXa0FraGdUZjdydi9X?=
 =?utf-8?B?OVVkeUt5S0FsSURyMTdUcUxlVVRVNm5zbVY0L3h3MnRrZWx2cEdXWnpONlJv?=
 =?utf-8?B?OUh2b0NldEdsTmhlSHZlUHp0eWZqOUhEWFJINCt3clUzdkJxSVowYThKK2hQ?=
 =?utf-8?B?UHJHampYNy91OHBNVjlpVEk0eU5Kci9zOWVCdStYbTB2bWdTY1UxUk5FVEJE?=
 =?utf-8?B?Wkl3YWtYYVhPZDNrdTJqcjljek8rZHRwUkp6by94S3I1dzNOVFo0emFpeCt0?=
 =?utf-8?B?NVVMNEFQWTQ0YVhhZ0NkamZNMWVXL0dJZE1qbXh0Vk9zYlF6R3EyWGxQQ0Zt?=
 =?utf-8?B?MnFock9xbW1xQkZiZnJKR2FMVzhwVFdYUzhvaHVMV0c3RlAxRkJSd2c4bUNC?=
 =?utf-8?B?cXo4c3dmR2todDQxREJoYnBRcUlTWENVbll4MXBUMmFSNmJ3czZxcTBYVDFK?=
 =?utf-8?B?UFdoZ1YyaEZ5NTl3SEd2d1lmek02YnVralh3emg2WkFHbzd1T25WVU5ndEdV?=
 =?utf-8?B?anlpN0h2K0F2b2NEQWZxNFR4TTdEckRlZ00rYnkxVXRLaHVmUnhxaVNFVnlK?=
 =?utf-8?B?NTZ2dlJIUWdxdVN0eDN2WituNzlYUWgxZWMveEpZUHR3cjVMdGp5bXhRSjdW?=
 =?utf-8?B?R3ZKU1NnL0lTRC9BVGc0R0RnZW1UbEhjWlE4bGY4dlNkaDJvQkhyYVR6a09D?=
 =?utf-8?B?TWcwQXdCUDh6Q29CcGVQV0JXeklLa1RIRkVYM2VNclY3Q2NQRUxPQ1dIeGgx?=
 =?utf-8?B?NUszTTVCS2dPYnRNWDd6bUxtM3J2R3hIRmlTZXdEYjZ3YmdwVkxUZDJneDRa?=
 =?utf-8?B?UE9SSVZvTjRvd3JJa0tGVVdSbno0amxCc0sybGV1NVk4WE9Kd1FNcGZmSDlk?=
 =?utf-8?B?K3NRQkF5QjgrSnpGN0FINFlrMkl0T3hNeHdyZDFEUlBaN01RR2FMeEFUMjF5?=
 =?utf-8?B?V0JUdkJVcnFLWFJUY0M5emxsN1dUVnBIRkJnRzYyNnpKWXJCZ3RZLy9qbkgy?=
 =?utf-8?B?WVlDN01FOTl4bUZWSlRHTHQwNitkWThJQTgza1pFQkN4VWduYWdKSStFeGZB?=
 =?utf-8?B?UFNscmdHSTlYcDQvZDJpcGNzV2JEMkRjZWVmem83cDBwZUNtb0d2eG1KamR0?=
 =?utf-8?B?ek9OTzRCb2FRbDJ2L21DdUdXaHpveWJCR2YvUDR3cENRbkxseDRmRnlLdGVY?=
 =?utf-8?B?bFFSSEEzOVZSZkVLazNneERuZjFDYzVBMW1vUUt4ZHhaekhkbUxmem9rdDJ4?=
 =?utf-8?B?MUE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: d261109f-7ce5-4630-35d8-08dae1ece1a4
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Dec 2022 18:14:34.1919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/dZOhauzOG/A8px/nDECoQUhetO761qbOdTKgxRQH8bovODPQz2HS3lryuxt8HJ6Jl0n28tF/2D1DlMH90m0V93x/QNAfGOdZF9/+wfsG4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7347
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/19/2022 7:52 AM, Marc Kleine-Budde wrote:
> From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> 
> toc entry is missing for etas_es58x devlink doc and triggers this warning:
> 
>   Documentation/networking/devlink/etas_es58x.rst: WARNING: document isn't included in any toctree
> 
> Add the missing toc entry.
> 
> Fixes: 9f63f96aac92 ("Documentation: devlink: add devlink documentation for the etas_es58x driver")
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> Link: https://lore.kernel.org/all/20221213051136.721887-1-mailhol.vincent@wanadoo.fr
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> ---

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

>  Documentation/networking/devlink/index.rst | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
> index 4b653d040627..fee4d3968309 100644
> --- a/Documentation/networking/devlink/index.rst
> +++ b/Documentation/networking/devlink/index.rst
> @@ -50,6 +50,7 @@ parameters, info versions, and other features it supports.
>     :maxdepth: 1
>  
>     bnxt
> +   etas_es58x
>     hns3
>     ionic
>     ice
> 
> base-commit: 2856a62762c8409e360d4fd452194c8e57ba1058
