Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BAF16475BD
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 19:45:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbiLHSpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 13:45:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbiLHSpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 13:45:31 -0500
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B62E8425A;
        Thu,  8 Dec 2022 10:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670525130; x=1702061130;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=E1Cph4P7kbYjv1zN7qwxZ4XAr2o3KSaZLk8ojybtGTY=;
  b=HZIeaK2GX7PvQcrEeP85gFiWtRcoJwh0Nh2PZaAEY6OQ7HWUSSZdheBm
   BMoEBS2N4UobxDlicpxzZa/yIv0zY/Bbd/LWfHdrwso1FXsZP0FHzQn34
   7Q6qiofxBDo/H+bfeCNd3X019yXPJa65kjbNp36KMoM4lRcPep/bsH/x2
   8WFUBVUl4hrqgULAQglSKdRhHQ7KiEuB40bxcPWEsRw4U/BMj6IylZNqD
   u+Tj4dMQ1abFKbK/xMSBaBjizjwkvUgRxXUThoe4cJe8modmozLXz+eub
   5ewN8gXhG99/nrrXSDCHRSHhF2cjeRqiFQ1wUZhVcmRZsNYuwrN5up2wv
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="344302738"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="344302738"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 10:45:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="892349136"
X-IronPort-AV: E=Sophos;i="5.96,227,1665471600"; 
   d="scan'208";a="892349136"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 08 Dec 2022 10:45:26 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 10:45:26 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 8 Dec 2022 10:45:25 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 8 Dec 2022 10:45:25 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Thu, 8 Dec 2022 10:45:24 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+pidFwF9QShIc88s+QBhBHSVSqGls2PfDO6/U5JLghOoHtrNmQ9pb6II/MQL2SANnPUZIV/79agyWoCaEsLfgExLh5xOU9TvKInVFIGEmbij1BMO8dR2kumc61QjK7yfwM76gLvVIGFfE+lMK1r9UnOtuNhXZbNlr5HPioabGqdAsw7DfRFNf5J5EGcLX8SEewOMmZYFoVq8ogHVTQhsNzZ1DDLze3XZ+b/7KKhtrka7zaM+6nnNKTGdDMkJHYujUvZ/Jxnv0Xw+amj6OAhxXl05KWfOXtMQ2fldh5Uj4T8xOKJmhUEdFkgnTe3ND61pX1OOVZjsZEeBwV1U9rBZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2y88U+N1FQjqftmhvgxDLXMMidCT1xjLu1lZWpcLw24=;
 b=FYhyR1bumGcGzh4fXYJOfr3y/vXSVX+KmM7PzXQgrm6MjRyGaYFBnan3lFwK99E+YL3g592APcibJ/ZpKjVUmedF0z3gZqvBkPAY0j185iQF+/Neb59ErsMnCBlLdKcDIc+bcBJojRfhW9p21pwv4gFMpbwF9UwlRE4RG8MJNZ/uPhhtIVefGoV3J86bPe01d8nXxFAUTF1jnHo4VTN4iDUxd+GEqMEqDNGP4BcFNmHLVH/QEhewRluQ4stQ6NYjILsCekeQ+0CkDlZ5+PcaeIY9qmQZhyWTBs6HUsDUet7Uqr1Bpe1jjbuTJZnUKewSxFoIRICL9IVtTIY9yU+Vrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA3PR11MB7626.namprd11.prod.outlook.com (2603:10b6:806:307::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 18:45:22 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3862:3b51:be36:e6f3%5]) with mapi id 15.20.5880.016; Thu, 8 Dec 2022
 18:45:22 +0000
Message-ID: <4ba59b52-7549-aa9f-5fac-22ea42190727@intel.com>
Date:   Thu, 8 Dec 2022 10:45:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 0/5] cpumask: improve on cpumask_local_spread()
 locality
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>, <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Barry Song <baohua@kernel.org>,
        "Ben Segall" <bsegall@google.com>,
        haniel Bristot de Oliveira <bristot@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        "Gal Pressman" <gal@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        "Leon Romanovsky" <leonro@nvidia.com>,
        Mel Gorman <mgorman@suse.de>,
        "Peter Zijlstra" <peterz@infradead.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Saeed Mahameed <saeedm@nvidia.com>,
        "Steven Rostedt" <rostedt@goodmis.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Tariq Toukan" <ttoukan.linux@gmail.com>,
        Tony Luck <tony.luck@intel.com>,
        "Valentin Schneider" <vschneid@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>
CC:     <linux-crypto@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-rdma@vger.kernel.org>
References: <20221208183101.1162006-1-yury.norov@gmail.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20221208183101.1162006-1-yury.norov@gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0359.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::34) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA3PR11MB7626:EE_
X-MS-Office365-Filtering-Correlation-Id: e1ca654a-01f8-4e93-4da7-08dad94c5be6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ceed+DGDTsQxchThLhLsdS0M8QCJEhi63zkf4v5djyeYAhMnjOKqhtPaTVAawOXMAKrhAkEaOAAAM63B43eOQKT49S6/EziLqKJkq/9zBDl21aH9g7Zhdftda6FTaamGoHWq2BxQ8TheHH5QfJAKJNKxejSwyVvD+5Xc3oleV3Fl2L73xgn9upo7jUTEDyVgJJSzWyMQ/tIiWjiUqs0Crp6xheVa6Sq7eiipM7cI2ZUT9nemhlaRqwZ1OdwAGCv7t740sYPc2/g9cCRrIuJoFr+Cu69Gy0luteleAkyDu4eSF6f/77Wu/09KIKqflivsuWDzLo6IE5U00D3V07IetQ9or8BH9KADhWoGKQSa2zTJTwIBshd6TKJdTHYL7DNV2MulUxjYGjC0Ca15YfNi9S8KOCQcilscEg5LOgIUS1NoWUrMEodUk3Pa3InKpwYnhOiQxtqEwp0J6H/9KriDJoD10quwYwMNu2HXaHXt8chHKmcnm5WG1m5jrNY/MK3IiTAcDEvoHucm896KV07LfD3WCsmewU4bkm+Lhh5CT+U4ScaS8etC6q7ALcFMXbJO/Z1Uwo2VaIkGrWU3CF75kfRTgmIQ53fIdZJfsJdEW1TB06EKlHDTdJ/iGhE9u0YIG8VcwBp8FAKZ16VUg35fsSyhxV59zF54e3L2tQKDcAJxgecjrWENGVbmmWuXefKU0wHXEaLy2DAmdnVFvXwnc7Qz4R5iTKbo77UiguWjmMJzVumJcuoFQgN+9M7r5u0OPAO9JmGZVhZeoBRgnMf+RHRAXSrnYPrVTUfD+ph4QL0UBDAX8+PBQhq5IIok3Zj/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(39860400002)(136003)(376002)(451199015)(66476007)(6666004)(186003)(41300700001)(8676002)(66946007)(4326008)(2906002)(66556008)(53546011)(82960400001)(478600001)(38100700002)(966005)(6486002)(921005)(36756003)(6506007)(2616005)(7416002)(8936002)(31696002)(316002)(5660300002)(31686004)(6512007)(110136005)(26005)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eDJnWGQzZWdNakpWRWRPb2JBQzZPOEpwZVladXdBWUlDandCaW9qTVl6elQx?=
 =?utf-8?B?VlZjRk1IZk9oejl0NjErczI2ZENEUU5kc28vd3NSUWJmZ0J0cTBOZm5CZ0J3?=
 =?utf-8?B?aUdabUtJZWhaQzRiZHJsZFZDY3NabWxpQVdmZkVpd0VMVXN0Ym95aWF1NjFM?=
 =?utf-8?B?ZDZNelNQbDJOQS9ITE4xajZyaUdOZVZKWTRoQUdjcEJPZlZkSzJoUUJpYm1T?=
 =?utf-8?B?bk56ZWNqSWJpVlpOQlRYdHZMZkJTOHZXM0R5Mk9PcG80VG1pQmRqbkZpRlVD?=
 =?utf-8?B?WWdSNVViQWljWnllcXNGc2VWODNVYzlXL2h2VVdRVGFzeXN4RUtmY0NyUG5l?=
 =?utf-8?B?b0NTOXU3a1N0NkV4K05UKzFTS3hQM0hxcUhibi9DZEFJQmZkQzFLQUlDR3VS?=
 =?utf-8?B?bEJpR05FV2xCYnV5a3BlUElxRDh5V09lc21BU3R6VUdicVFsSHpZdWwvdVVi?=
 =?utf-8?B?UGRmL21rK0Q4bmQyQmxkYmhrMkZ6WTNtQXVINkcrMUZsRGdwbkYvRWhEcjAv?=
 =?utf-8?B?ZUxJbFMwYUVQNkp0MHlEaWU0eFpJeUhkSVZEMWdEZ0V2bDIyL0MzN0EwRCtn?=
 =?utf-8?B?cmFlY1lvb08yY1hjVUs4WGdMUVR0aUhoYnU4T2dqYjVmTjRkb3IvWEZlM2gw?=
 =?utf-8?B?UFc4eFpUS1hzSVBNamF3TjBxQ1N2T3VDR3pPbU42L0x3LzhXeW9TL21jTjI5?=
 =?utf-8?B?Y20vVHlXWTFVTDZuTU9TSEJaS0pvK0xKeWZtdGVGSUlCZnF0VDRMTWJrWG5k?=
 =?utf-8?B?UE53MU5TbnBWOTBTazV6NCtHblRLeFdFMzBRdmtpSE53eDMzdUZKd1dXcE9a?=
 =?utf-8?B?YVFMNmsvalZvNFBtL3k0U2dWVC90eDF0SnU2bzJMTGhMcXBJNHo3REJ4V0Np?=
 =?utf-8?B?bkFQYTJUMVcrMkZZTUYwSHVNV2ppZG95dXpGUDZyNzJPbGsrOW5HMkxvR2hS?=
 =?utf-8?B?WGVrc3Q0QldDQjUvRDk4OE5IOWF0dThLMFBWbzN3ZE95VmM5U1RqVlFnK0F0?=
 =?utf-8?B?ZUNwSEFOYWhXUjFIVEx3UjcxWkVTWHBoc0FWUGJjd3JzSVhMRzVkVHY5b1RP?=
 =?utf-8?B?cWpCTUFUYURsczY0VUFuY3Z4VzluTDhPUjUrQXFSVUxKcVFlRHZmRXR5dFFw?=
 =?utf-8?B?S3RxL0V3dnhjZVp6M0hvYmZqOFRwZnZHTURqZ1FKVU05MjVHWUl6UnlGeVF2?=
 =?utf-8?B?ODFkZnduZVlkRkRlU2FwV1A2UzJiTEtFM3RKOEd4VGg2N3B2VHNRaUdFQnYx?=
 =?utf-8?B?d2JXMzVnNDNWOXRPbUU3TUVpSStMc1NJYVFNeFhUdnJvSlJsME9ORTN0SERa?=
 =?utf-8?B?VCtiaWc3ZG5qYjBUQnpJUS9QdHNXVnRmT1lVVEd3Vk81MDJXN2I5OGpVL3Y0?=
 =?utf-8?B?d2k0ZnlLM1llOExrYm54aDJMZTVVU1B1cWkrU2ZTdGhvc25vSHNzYjg5Qllq?=
 =?utf-8?B?ZHdBa1VXVlZmSUxFQzdTb2padSt2R01WeDFTRnR0a2hlZ0pOY3l6OElLSm1F?=
 =?utf-8?B?Vy9rSUpSUk9xaHdPNVcxRitTZ0RwdU5ETGFmbCtvWldERlVSTTFYOWgrYVZO?=
 =?utf-8?B?c3hmRlJWaVd2dGpZQ0pINCtvbHU4SEZmOE9HOWI1aHF4MUZvTWJORHFnT0li?=
 =?utf-8?B?Snk4NUJSR1pqVzBXeXltUzdZU3AwRlM3VWRrcVg4Mms2WERtV0JLeElkUVZa?=
 =?utf-8?B?d1ZPejhzZ2JHSjhvamt2QmJ1OXpHdnhidkpFNk9DeWxvN0hiSTA4Zk9nSTBM?=
 =?utf-8?B?M1Fpc0JmVllsQjJLTSs1Z1BGeThxRFVmdXhib2FscXVGOE5Lc2ZIdXJmRnRr?=
 =?utf-8?B?ZzdQNG4vVVo3dGpkZlVnMHNWOEMwYm9COWNqaC9Hc2tRd2RaZkFUM3FEcGo1?=
 =?utf-8?B?eitHUFdzNHBZdWtsZ0ROZjZNeGs3eU9KVkpmOEk4emUzVUlCeFpHRUE0VHdK?=
 =?utf-8?B?RU5BdFBBMERCN2U4dUdZYnpGblRZaG51QlA2ZkQwNk5TL0pST25Eb0hGRmdl?=
 =?utf-8?B?d0plUHR6TVU3eGl6MXNKSXBDRE0vNGorM2tlQk56bnpnc1MxOEx1YUQxU0Zl?=
 =?utf-8?B?RjZZeUd0V0lPYUttNHdsMjVYeDhjayt5Rko4TWxyaDduWDlvdGNUYnBzZFdC?=
 =?utf-8?B?T0J5VHdqS1dmTjRQSGlqWEFZc1BJdVhRbDk1QW9ydlozamtWRXozWWZXbTBa?=
 =?utf-8?B?dkE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: e1ca654a-01f8-4e93-4da7-08dad94c5be6
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 18:45:21.9367
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OqGT5+p0Zoforh/QLI6fCuor7VWfjVBb056b/NPn4mE6nfXm0tEB1mLTpJFTI9ln4Diar7hu/PaBMj4t9YxcMUm39WTX4fh6zXZmOlA1T3Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7626
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/8/2022 10:30 AM, Yury Norov wrote:
> cpumask_local_spread() currently checks local node for presence of i'th
> CPU, and then if it finds nothing makes a flat search among all non-local
> CPUs. We can do it better by checking CPUs per NUMA hops.
> 
> This series is inspired by Tariq Toukan and Valentin Schneider's
> "net/mlx5e: Improve remote NUMA preferences used for the IRQ affinity
> hints"
> 
> https://patchwork.kernel.org/project/netdevbpf/patch/20220728191203.4055-3-tariqt@nvidia.com/
> 
> According to their measurements, for mlx5e:
> 
>          Bottleneck in RX side is released, reached linerate (~1.8x speedup).
>          ~30% less cpu util on TX.
> 
> This patch makes cpumask_local_spread() traversing CPUs based on NUMA
> distance, just as well, and I expect comparable improvement for its
> users, as in case of mlx5e.
> 
> I tested new behavior on my VM with the following NUMA configuration:
> 
> root@debian:~# numactl -H
> available: 4 nodes (0-3)
> node 0 cpus: 0 1 2 3
> node 0 size: 3869 MB
> node 0 free: 3740 MB
> node 1 cpus: 4 5
> node 1 size: 1969 MB
> node 1 free: 1937 MB
> node 2 cpus: 6 7
> node 2 size: 1967 MB
> node 2 free: 1873 MB
> node 3 cpus: 8 9 10 11 12 13 14 15
> node 3 size: 7842 MB
> node 3 free: 7723 MB
> node distances:
> node   0   1   2   3
>    0:  10  50  30  70
>    1:  50  10  70  30
>    2:  30  70  10  50
>    3:  70  30  50  10
> 
> And the cpumask_local_spread() for each node and offset traversing looks
> like this:
> 
> node 0:   0   1   2   3   6   7   4   5   8   9  10  11  12  13  14  15
> node 1:   4   5   8   9  10  11  12  13  14  15   0   1   2   3   6   7
> node 2:   6   7   0   1   2   3   8   9  10  11  12  13  14  15   4   5
> node 3:   8   9  10  11  12  13  14  15   4   5   6   7   0   1   2   3
> 
> v1: https://lore.kernel.org/lkml/20221111040027.621646-5-yury.norov@gmail.com/T/
> v2: https://lore.kernel.org/all/20221112190946.728270-3-yury.norov@gmail.com/T/
> v3:
>   - fix typo in find_nth_and_andnot_bit();
>   - add 5th patch that simplifies cpumask_local_spread();
>   - address various coding style nits.
> 

The whole series look reasonable to me!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

