Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507BC6743F8
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 22:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjASVJm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 16:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbjASVJQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 16:09:16 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815419F3B4;
        Thu, 19 Jan 2023 13:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674162136; x=1705698136;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FF1FngTsxXLxRJaIWGfLc8X8uBHUK5zXK4uhRzBi68Q=;
  b=Q+XT2V/Ewr03MBqKzeiZD/PcAwEW9m4geCj05haegtGzMgC0DBHJOHod
   QueDZvboA4KuwbEc+Y0IE9wOHP6WOtqOOhvzGD3Rh0MMlYaszu715ebJl
   4/t3tsqfX1y5X4DPlDWAcRuUeJyr9YNwV0scy51fgRiQWInm3/yjO5wZy
   vmDNF2bp5SQVNfsgJndqjs9i6mSkVwLVIXTU7K8+p0gV1ens3k2G/kDQx
   1fHSGFiFL3jKG1y/cEFcWJdg6mIK+SflBxBRBlUUeT90k06BoA3f051bO
   49HQrF+ttzJvZgT/1eBvgbgK1CzLm4icr6tgs1yWY+LHNZeiIWFuMuvdx
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="389940078"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="389940078"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2023 13:02:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10595"; a="768379050"
X-IronPort-AV: E=Sophos;i="5.97,230,1669104000"; 
   d="scan'208";a="768379050"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 19 Jan 2023 13:02:15 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 13:02:15 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 19 Jan 2023 13:02:14 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 19 Jan 2023 13:02:14 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 19 Jan 2023 13:02:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hpemmfgINjYluntkaoWOn9DTFV1CAW0KIBG9bBPlwZBcm5FcBnSDj8C4Aq3zozg0TddJg4wPpuoMVsqaT23sFJMrosTkU83o+7/eOMYl5SvMovww9CIEL6Tr/aQC7nUmBwEape1gqJlmiFCKH6KAphgo9rp0cFpQ1d+par602LcFe+1N/TTNBzaNyccC5F4ZYobuUqnh4pMlJ8uABroQcVb+St1OkkqepTRUyAk/3WU2GTkaQ2v70RMP2qhWM9qIIWLh6E9VN5ZWzyNnFiyL1TzcV7AY2ncVf0RlPq9uCz4T3IaQ4IyFzMxUKOLcN5CgjmPzdXMsO+NySEpD32o7cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gnaw6C7ftkj+HyfCFM7kni6SFUs5iXeLbpyYs9GLu+0=;
 b=EtujsSIpWHh+soW9cBEqWMNRf1WKk3xtJY44tQsWTnZ7GfravXBoISlYx/fLDKfuFkQHNyQIdtH3jWfcdOI9l0Q+GpqR8873lFKVvZdqlkdgMR9y2eamx7s8SsAdTj3jUhMJPI3tX+yV+M73ibiicEiXnnu7an0tca4JjNzoZTv0Q1wLYQtbMXo+weq1NBj9y+O+RseTCq6D+1kfSUZvcXRv18eln0XUoCGFDR19LbsV6ORN90Dz4GN1QzUJ1kM3EA253kgqhsHbUOSRzJEY3YRaGBmVFslQAtlTZUCAVLfwWv3dVdLoep30zJ44nYO7OD1vrbRoAmRh1QI+pPEWRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by IA1PR11MB7824.namprd11.prod.outlook.com (2603:10b6:208:3f9::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.23; Thu, 19 Jan
 2023 21:02:12 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::c743:ed9a:85d0:262e%5]) with mapi id 15.20.6002.026; Thu, 19 Jan 2023
 21:02:12 +0000
Message-ID: <8756fac7-6107-57d3-c2fe-309dd8d3cf0a@intel.com>
Date:   Thu, 19 Jan 2023 13:02:10 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net] net: fec: Use page_pool_put_full_page when freeing rx
 buffers
Content-Language: en-US
To:     <wei.fang@nxp.com>, <shenwei.wang@nxp.com>,
        <xiaoning.wang@nxp.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>
CC:     <linux-imx@nxp.com>, <linux-kernel@vger.kernel.org>
References: <20230119043747.943452-1-wei.fang@nxp.com>
From:   Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230119043747.943452-1-wei.fang@nxp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MW4P220CA0024.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::29) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|IA1PR11MB7824:EE_
X-MS-Office365-Filtering-Correlation-Id: 1e79fe0a-26b3-4a53-4340-08dafa606fc5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dAUyQhz6Q5tB4KavPlu6tCGjRfr+A6WRLZjU7JIgbAtoYyl9D3hm2c28p5OEsBBo3amvmieWUHoHDNs9EblzSNpRN41/j5KTIkNqnlZNtiH8TVWpg4/QmiNFnF+Rboip7gbaG101+69k/VCcZxslUNL7cBuaqPPEEjsF4x+p+nOdkJ6qKwwcw40glrKyyzOs7VTsCM7mNLDg1SV3WVApnqmmfRSGGUFfaE2DwG5tOBYof2RBMrEPDfqhBP3O3LbUzO3JbnqhsQ4AVpO95O4GzzjB0frl02KHOXUmFDC6cm8JImTOsaq8zAh8EyHXovHHza3JjMK+2W733+izjEMEoD6A7IAuDiysGjAIBmoP7psdpPUf9DmOIhXSrXLXn/r/jfils1gMFZxoGxC0+dUuBdvJM2YkGKxL49IfDg+vHrRbdvL1ZtWKQnwg7l2zNUla2dk0O5Z3tNEM3sJKV/dbbXulL1JDoG2qwy/k5qE5yo/uDimTraJCsxclDWO+bmD34/YiHvkFBFkoryO2Da7a0LWd+jdqAUAjHxrAsALIjPM/6eIdvMP+LC5ovaebqpcr8xGwLMF3wOmKWmD1V3YCRxNUIi+EY8T29k3T5Yy+9uDdqXfn2AfW8SSU/yLVDc8v+fqhgoRmxLdTkI5KnyHk8aGvINpEMhlOcnIUR0pOi3km5iTsq98Djh9kSLXoSkOW5yqnpqNz9DrOgkWzF9H4fDxHr69VnG8upDKbGS0+2eA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(39860400002)(346002)(366004)(136003)(396003)(451199015)(38100700002)(86362001)(2906002)(82960400001)(31696002)(31686004)(5660300002)(2616005)(316002)(41300700001)(36756003)(66476007)(66946007)(26005)(8676002)(4744005)(6506007)(66556008)(6512007)(53546011)(7416002)(44832011)(186003)(8936002)(6486002)(4326008)(478600001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QnhQMFZnR0kzbEtZQzQyUk9SQjNkdWc1dmwvM21QMlNoSWNPUnV5dzYrVnJa?=
 =?utf-8?B?MjhiSUFMZk5CNkc1Y2N6YXlSYWRkRWR4RXhzSU1KMWZRTGIrTWk3OFZvMjNN?=
 =?utf-8?B?RldYY29uRFVjL0VPQ2RKZzVDSVZlY3Y0M3hJam5nbUFWL3ZFaXpZSWhLOGpo?=
 =?utf-8?B?R1hsb2x2aFNqR0pJY2c2RE9UcWZWemQ1aGd6ZkNzc3NsMjFjRmZpM0xBT0dX?=
 =?utf-8?B?YVZMQXlNQTYxcW5lOFBXTjZGOTdGbkZDNlZsSDdGMDlva3AyYnVJaHYwYnh6?=
 =?utf-8?B?c2U3RE9NL1dMaGRCY2ZpbW9nTnlMamIxMFBmcStxdkM0VlVZTC9wWDl5V1Ix?=
 =?utf-8?B?UXFUaVBkMjVsb0c1YkhrUTVKaEtnRWVRYmhFM05vYmdwRjdVNlp4RDZ2dHo5?=
 =?utf-8?B?a0h3L1hoeFdHM1ZZa0NkQ0hVelJTMktZUVZoRGRzU2ZCdkp1QUg5WTJkSm00?=
 =?utf-8?B?YzE4MkNuOEdzTEhKb1h4eG9qMEZ4Q3ZzbEZscC85MmwwaGVvdGpOWEpKcHl5?=
 =?utf-8?B?ZmdMSU9uR2luclBZWjE5TU42WHMrQitjbWdGTXp5aTNLM3E3cTROUk0reUEv?=
 =?utf-8?B?bTJqNS9mZjc5RkNRYzNVbGpmdzY0aDlpLzBsM0RUR2VNUlRiM3pLcUV4N0I2?=
 =?utf-8?B?UzlHL0JaTDRNcXhoRTl3b0hLTCtjelVjSWllSGJlNUJodW1XdVV1ZXdvN0tH?=
 =?utf-8?B?TEVsekt2dTA3ZVhjZk1zTjVJQWNBa25hWG5jVTRCQnB4UTFaaGpjU3ZGeGdX?=
 =?utf-8?B?Rm5VY1NLNWpZWFpNR3R1WkQxWVBGM0gwUEVtVWRZQWhEd2hYUWp4Q0thcXY5?=
 =?utf-8?B?eE1DTFBPZTBNenNhSy95c1FtVUNrUEJKUFdxZ2sxTFppMms5ajdnWC9BNlVq?=
 =?utf-8?B?SHJ6TlpZL1FFNE9ETHRHcTJZWmJEQlp6bWYvZ3M4TkdUaS9DSE9kYWV4bkpy?=
 =?utf-8?B?Z204WTJSMWxIalJFa1Eyb3pQUlRROHJLREFWMktMYnh3ZlJhS1doV2NOUkY3?=
 =?utf-8?B?VkVwMFlSVG82N2doRzdPLzYwU1ZvRDJ5KzNZMURLaWs2cXhDTGZjNjZoZ09W?=
 =?utf-8?B?Z0t1REhtVTFmUm8wcGZ6UVNaMlJrOGltcC9ZakNmQS9WRDBvRWtka01ORk44?=
 =?utf-8?B?RExLZlVxN2VGSjFXMFd4aVFjbEQ1aDFKQVZmcjVzUzJXOFhRSTZoQXVoYjVZ?=
 =?utf-8?B?TVNBR2VnVnF5ZFlsY01NSmFnd2hYd0Vnd3FRMC93aTh2Y0p6S0ZiRUtUNkJI?=
 =?utf-8?B?Z21uc0VTclErSkNmYlppa3UrVnNkT3dMQ2V6RGtCL0FxQlRoclZJcFR6SUp5?=
 =?utf-8?B?bHFQdGRKSDZVV0wzdGt2WUcyelNlMFFlN083N0JOaXN1cWt6Wm84b1ppaENG?=
 =?utf-8?B?TC9PUXB0ZDI1UytZZlROSGUwWkRaNlpmU0N4VVp4cCtlN2M4OVR0ZkZVU21E?=
 =?utf-8?B?SlV3ZlMrbTNhS2R1TXpCeElGS3E2ellwTk5jdVRIRFRlYktFWnN2V1lwWTZM?=
 =?utf-8?B?Z3p0S3EwWVpyQ3NVTVVmeVZKZkx3YithcXo1MFdVYW02NzVCdGxWQkcySG9F?=
 =?utf-8?B?K0tzaEpldWoyVEt4dzE0VGlaTU1WTEtyL0JrcmlvR2UwQ0NyY2hhMmh2c3Jr?=
 =?utf-8?B?WHFTazNoZ3hiYTRIY0pyVTVrZSt6dWR4TEdoSnFLZ2drK3ZvVEpienFOQnRu?=
 =?utf-8?B?ajZydGhoK1RqWjZ2N3czMTNIU0IvUFJwdk1FZWZQRHdDb3o4OS9YNUJYSFpq?=
 =?utf-8?B?QXJJN2xFV1llVzhHSG9CSjc3QnRyL3FwUTJ5MldxU3FQRVMrMmNaMzY4TDhT?=
 =?utf-8?B?Y3JGTElBd2diMzVkTGZ5L2FHWE5BSTNubFFUSmhXbTN0cGJGRStybWppdjhD?=
 =?utf-8?B?UVBURnVwODZud1I4T3JFcWZSRWdnTlBTNTJEVy8rS0dMZzZ0LzhQK3YrWmhF?=
 =?utf-8?B?VmErV2dhT3JZWURVZStreW5LZmZaRS8yekdkZmxETWpoRHhGWGROQ0swUEEz?=
 =?utf-8?B?TW94c0wwMjJzOXhrZUpEVTRoT2FSb2FqZ0luQytJamRCb09kSFRKOG9GN05i?=
 =?utf-8?B?RFpSVk92ZVJJVUJuampZVXRGa0Q2WmxpRk9HTVlUa3pEQ1pQMFhiNThRREo0?=
 =?utf-8?B?MDBjSlpMbUkyeFlIMklLNWloMW85b1lpQmdrTVBtSExMYlFnU3pOYXNPL0Yx?=
 =?utf-8?B?SlE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e79fe0a-26b3-4a53-4340-08dafa606fc5
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jan 2023 21:02:12.6755
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 51p77ZHhcfGC2oo1bpD2fohNNvyWrgYO+X79bn8zROBiw1ub/JPAHV/ZIUf6S08hQHqdku3KdoWbGw6kcfB+fotwxRDBVGkO9tJQ4Fvsomo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7824
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/2023 8:37 PM, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The page_pool_release_page was used when freeing rx buffers, and this
> function just unmaps the page (if mapped) and does not recycle the page.
> So after hundreds of down/up the eth0, the system will out of memory.
> For more details, please refer to the following reproduce steps and
> bug logs. To solve this issue and refer to the doc of page pool, the
> page_pool_put_full_page should be used to replace page_pool_release_page.
> Because this API will try to recycle the page if the page refcnt equal to
> 1. After testing 20000 times, the issue can not be reproduced anymore
> (about testing 391 times the issue will occur on i.MX8MN-EVK before).

I had a look over other users in the kernel and it seems this bug hasn't 
propagated anywhere that I see.

Thanks, for the fix, seems good to me.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>

