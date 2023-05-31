Return-Path: <netdev+bounces-6894-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 75D57718975
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30733280D38
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:34:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 757A0182B5;
	Wed, 31 May 2023 18:34:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6275C2578
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:34:32 +0000 (UTC)
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD27998
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:34:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685558070; x=1717094070;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KlQsCyJKeMxeVMrqHvoJe9YW7iuvhXGVhf7g5viiaow=;
  b=gRsOTICxsKVnQDUSwIUsDvsT8FwodbtsJWNXv06UVgGsypwIuqE6IZhk
   luohlyY1DKIAl/MskK6xPoICnldl/dA91sN1UNnOcTMwSRvqddmioQe4K
   oswkgYHDPEYX5iZ2n7vjNe58dB2n73h2bi40kj9ZLq0pvQ7kx4ZGKnwd/
   V0r4AOL0mjrXkw7dWEW5gYeoo6qILVlcqZsidLLW73VCoy9O5n4vap73C
   fNFilyZ1RnZADQFj+OwDBWTwgQenl5RO9VlOin4S0ltLjGAu3ny1Z240f
   rKyQiIKkMqHBTW9+4Ox+J9NprFTmjzOaJ2P1siod2P2wxF7KpZ5RKpUed
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="355336279"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="355336279"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 11:34:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10727"; a="707024242"
X-IronPort-AV: E=Sophos;i="6.00,207,1681196400"; 
   d="scan'208";a="707024242"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga002.jf.intel.com with ESMTP; 31 May 2023 11:34:29 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 11:34:28 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 31 May 2023 11:34:28 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 31 May 2023 11:34:28 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.171)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 31 May 2023 11:34:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ds/HZQhj1dCsaBJM2uRCODYzQurzFkYF/5dxL9Z1QimM1vecgaAbuE4ZpoXofE77bdOMRDnyPjoWFWE86i45yM/OTnWdIU3Qix0hEX/SnnsDLwo3UD60YzECauNzI7fRIhc4x2Fjd756Xm5S0Zod8yYt9A1+TJQ3YaS49yhz6rpqUB1Z6DKKilFbCwhe3OJGyTtc4ux7cKjDME2LlFB+T8RDQPkma3QuiC3qJ+iPClYQMA150NYBuaTaZyvbaNt1fOURWLAn5p6x//nouwhJwmzsYrW3cro7LPRKDsr8hwA9PRoVliru1JVvxQDFZgAO8BTtSmKO5IXxXMujWI7uDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QuSze70Uo4/Ej7HZ7lFp9ukGYAWx3HoKa3oHxsySEuk=;
 b=WFuceDcIgf/uKSCtYJpmmzG+/97a7q/tSSTeMs+dNLOx7pd9PpzMkjjIk52Hw+QsYUhKsjypWHjgW5x8i3Mwye+ctDac24aS/Dk6IW3zHQ9AcYAicgqdedWEU99IKtHJfU9sQtnqUfLe6CxjuXcTd/8kvrsLeGqs+wbUh+ttg4vm1dxpk3mcsER3El1NuSlMVU2j0P31oMyVZveuKmDcm4KCgO2sC8a+qnnMx3XT6+NwPIK+Jdfp9oY6D9lxW2xN364WxBLG+47UeyZhICEowSQhyNLWHqQBQl6RoNR0LT/kfxVp1aXm/khtXJk63WOiBBgPtoXGuL+r65UNEBqPVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB4914.namprd11.prod.outlook.com (2603:10b6:303:90::24)
 by MW4PR11MB5912.namprd11.prod.outlook.com (2603:10b6:303:18a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Wed, 31 May
 2023 18:34:26 +0000
Received: from CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::57f1:e14c:754d:bb00]) by CO1PR11MB4914.namprd11.prod.outlook.com
 ([fe80::57f1:e14c:754d:bb00%5]) with mapi id 15.20.6455.020; Wed, 31 May 2023
 18:34:26 +0000
Message-ID: <95b50b5a-4c76-ac02-37ae-afa176b4ea62@intel.com>
Date: Wed, 31 May 2023 11:34:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.11.1
Subject: Re: [PATCH net-next 02/15] idpf: add module register and probe
 functionality
To: "Michael S. Tsirkin" <mst@redhat.com>, Tony Nguyen
	<anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>, Phani Burra
	<phani.r.burra@intel.com>, <pavan.kumar.linga@intel.com>,
	<emil.s.tantilov@intel.com>, <sridhar.samudrala@intel.com>,
	<shiraz.saleem@intel.com>, <sindhu.devale@intel.com>, <willemb@google.com>,
	<decot@google.com>, <andrew@lunn.ch>, <leon@kernel.org>,
	<simon.horman@corigine.com>, <shannon.nelson@amd.com>,
	<stephen@networkplumber.org>, Alan Brady <alan.brady@intel.com>, "Madhu
 Chittim" <madhu.chittim@intel.com>, Shailendra Bhatnagar
	<shailendra.bhatnagar@intel.com>, Krishneil Singh
	<krishneil.k.singh@intel.com>
References: <20230530234501.2680230-1-anthony.l.nguyen@intel.com>
 <20230530234501.2680230-3-anthony.l.nguyen@intel.com>
 <20230531015711-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
In-Reply-To: <20230531015711-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0355.namprd03.prod.outlook.com
 (2603:10b6:a03:39c::30) To CO1PR11MB4914.namprd11.prod.outlook.com
 (2603:10b6:303:90::24)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB4914:EE_|MW4PR11MB5912:EE_
X-MS-Office365-Filtering-Correlation-Id: 46afdf2e-c106-49c4-3a81-08db6205a989
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +efV6s7WjfAniUK4/NTZ7M6kUej/OC49oJ9btxPosX8LU3Rna52DK2FZhQJYDLD2C1PS9QqeuoeXdBepJsC93jB6ZfEXh4my1+AV5phYqowxESTewQQVOsaYDDQY6nhjluAUFvxFzv6k7Apqf9ibdcpKY23VIkK/XiYEKWMDMXa69MjyDuFv8sJAYZa0R4HezLJeNeOnJIDVg1LjuBzsVtbv+XrfAsYgqGi/T1lYTmEgrlLhJETcPHurLDOxwMkT9kbXogz2NrbSXX82n/XnU5NgsP0b0E+gm3l6TUyjedp/sAgl1SlZBc4UcpT/Ek5THRtl06muFo87eu255qL50wXtkfmOW3Yk+rReYTGHhrCRoNcAdPklP1zewk0q8q7P0DpA22c9qWu3BWCXzKD7fRzOGF2iZv/8oMGwNKF06oKM/xu99AYgpMSVyyREZ6FIkPu6Nc2pU0Qxkk9/1HTAroZfbshVC68V18GMBgGNuAFji/dggolr3Z3Oka2952j70K+2flYckOzFwudRXXUA5mijuSUlMW5giws/jMAr4Xn/hJVlAm0CI9uGUbcCZc31uXds6PHI0C1l28SkpKsL3uYfkin6zRKdbmnMB4QwqDRUiHz1C7LVZF5cQHjIHpGCRl9PQA3EEV+9lN5fR+f+wQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4914.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(396003)(39860400002)(376002)(366004)(451199021)(186003)(107886003)(2616005)(41300700001)(38100700002)(31686004)(83380400001)(53546011)(6506007)(26005)(6666004)(6512007)(6486002)(110136005)(478600001)(54906003)(66946007)(66556008)(6636002)(66476007)(316002)(82960400001)(5660300002)(2906002)(8676002)(44832011)(8936002)(7416002)(31696002)(4326008)(36756003)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TW5tM29CTHIzcTlvWUZvUU9STVB2WkVqQnBkZHg4aDYvZUZoRXBXQ3AvNGQz?=
 =?utf-8?B?bXFlVXJMTmUwSytCMnNsNU1ncENWVE55VHlFT3dqNE1VRzZGclhXZjBtNkdW?=
 =?utf-8?B?azZ1WlVONTBBZUpzWGNIWGMwWEpzVUtEV0ZKQkdRelVBSFJSUDJFRnQyU1dw?=
 =?utf-8?B?c3hVaXRCUENoSERuc0RiRjVQcktQU0NhdzYyd3ljcEtxcjZmY0hUM0oycDM1?=
 =?utf-8?B?ekE4UEVvK3dRSFV2VS9QeHl5Wk9mb1FnUEdpTm1seFV3SmFLbVljOTUyWjNa?=
 =?utf-8?B?NzFtMlNEdVNxZ3N6azc4aTlhdFRER215Y2Q2b1l4dzQrRWRMMEFISzZoeWtJ?=
 =?utf-8?B?Ym40WC8xc3F2ZWZtU2V6dklhSS9sdkp0ME9Samd1cDlKUWJpS2JrM3hVY2tR?=
 =?utf-8?B?T1JUa1BvTGFxZ095OUJOT0dWVHA0OEQrVmx4UEFPYWlsdjE3WDhBMlY3TVcz?=
 =?utf-8?B?ZW90dVJQRlBGWWxFMWNJUUxraWJySlQyRjdhTTFCRlhXOE1QdVJYdnBZTmhR?=
 =?utf-8?B?L0F5cEtpb0hzbm9QSU9KQUFTWUU5M1UxdE9ObFh6RldyTWlycDdteGY0Y1Y3?=
 =?utf-8?B?SDhnWjh0VVpnMGlTNHFleUNnbC96WlVhRWVWWHNQMWJ4WUVOZzBqZk1oTGlT?=
 =?utf-8?B?aW5sVmI4TGtkMXBYMnJrdWk5b2g1SWJQVEpPN3VLdjM2aWpqRS9VK052UDBB?=
 =?utf-8?B?Mk8wOHpSclNLYzNsUW9sRDlVWkd1SWt1SnY3dmgwajNvZjJjdTBmSnllSjFs?=
 =?utf-8?B?U1liU3EzR0VleVJDNDBDVS8zL1MvZVNFZlVIZjdSWlNWbTZoS2J6ZUVoVFpn?=
 =?utf-8?B?NjRZQUdMUWxNN1RrRzdoUFVaaC9SdjZ6UmtjTHk1YTgyZXFPT3N5MzBBTnNH?=
 =?utf-8?B?R05sQStsazA1TDEwMHNGS3lkMVIvSnU2anZ2d2pyOFgxKzV3MGhoZk9Rdlky?=
 =?utf-8?B?U2NSVWZMcXhiWEVpY3lKYW5ac0VDbEREMzJ5T3o4OGY2WkJ3UGxLTHp0V3Zk?=
 =?utf-8?B?cXNSWmk0WjhEOWI1aGR4dUpid2hBQzh3bWgwNFNHK1R5T25pWlQ1aEpSM0h3?=
 =?utf-8?B?dmJhN3dDWWlkR2dxWmtmVEpES3RhNkx2RkM2QkRJM3FYSUpuQktmY052Rm56?=
 =?utf-8?B?ZXJXNjNyTEdSamJyV3RJUUFSOW9KVGhIc0laczFQcTZwS0JmS0w0SW5DSTI2?=
 =?utf-8?B?TUFLaEw4UnRhS2E3Mmdsc3kyMWVIZ3oybDQwK2swUGRHVGpVU2VoS1JtUDR0?=
 =?utf-8?B?M0lQdXJJUWxPbnhzVVJwWlVsWEg0ZVZyczRCODk1M0FTTzFsbGMyWVZWVWY3?=
 =?utf-8?B?a2RHNUozWkpoTWZoZlFRZ1lhKzZJNjZlTUpZT0tCQmk2N0N5ZytRMXJJWHZ3?=
 =?utf-8?B?QURtaXdaQlVNZ3BsYS9RUDZCRG9mTlhBNHV6cW5Ed1dEaU03OXZsUXN5SlQ1?=
 =?utf-8?B?U0N6OTZFMk5qYU8yQjlhU1dFU09ndE94dFhFOXQ2YWRrZWlmYnM3dHAwL2J3?=
 =?utf-8?B?Zy9pUWNBanNUVE13VlNPYjVaQUdGMUs2NTVISHozM1F5UmhLaklRT05lVmRM?=
 =?utf-8?B?cEZFUG9LZXlXZWZNemRQZ2lkT29lRC93ZjYvU2diZ3owZjZMKzYwb0RaWXpF?=
 =?utf-8?B?U1c1bXRhYnRVVmJWTFpVQi80SkxCT2tZUFRoN2pxWGVQQU56RkJwTWJ0ZGVk?=
 =?utf-8?B?QkI0cm5NMEF6eEZ2WGF2d240VDhnQ0hQSmRhLzhCdVV0YjlkT0pKS1pTaURU?=
 =?utf-8?B?UlFYTGZTemplN21uNmdiTnNUeGxLWkFPM2RETFpCUFRMcWdTOTBaZjF3NWxT?=
 =?utf-8?B?R1IxOEZkRmJzSFh4TDlmZ1dURUplL2tiTis3NG9QdlMyNmVIRjhpTWlqOGg1?=
 =?utf-8?B?V29ZN1lEVFVJVkQ2VHp1QTB6OTBuR3R1OGFBMU1aaDlrTUFFalpuN0JTeVMx?=
 =?utf-8?B?M3NtYzgzd3BlQmZsK2QxT01XTTE1d2VMUURRY0tlY2Q4cEpOYzFtTFJibkNa?=
 =?utf-8?B?Qm5ocDlWOUR4cjBlSjJBZ1pzQkhsczlYWEhlMnRtVnFsemtQeFF0NjZ1bHNr?=
 =?utf-8?B?UjdCZkNQVUlqTTVoT09rR0I0MnpQQzZHRGJMT2xHcnNMY2tOcmo4NUR4TlRD?=
 =?utf-8?B?SnVsQ2lrdzBCRlJickVOYjZvSDEveTNaSXFVVGRlT2tRSURNT0pQV1hYMHNW?=
 =?utf-8?B?RGc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 46afdf2e-c106-49c4-3a81-08db6205a989
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4914.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 18:34:26.4590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eRU4vJX3P9ZCB3gRC54h1Le6DJHcXgdqvcJVFfKZudEdp5+SK1IJ11NnVsCQL+prpVBgymuc+rvVt1N1isDsVqW0QWHiJKH+csamL7wmWJs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB5912
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/2023 11:05 PM, Michael S. Tsirkin wrote:
> On Tue, May 30, 2023 at 04:44:48PM -0700, Tony Nguyen wrote:
>> From: Phani Burra <phani.r.burra@intel.com>
...

>> diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c b/drivers/net/ethernet/intel/idpf/idpf_main.c
>> new file mode 100644
>> index 000000000000..e290f560ce14
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/idpf/idpf_main.c
>> @@ -0,0 +1,136 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/* Copyright (C) 2023 Intel Corporation */
>> +
>> +#include "idpf.h"
>> +#include "idpf_devids.h"
>> +
>> +#define DRV_SUMMARY	"Infrastructure Data Path Function Linux Driver"
> 
> Do you want to stick Intel(R) here as well?

That would be ok with me, we'll discuss internally.

> And did you say you wanted to add a version?

In-kernel drivers use the kernel version for the MODULE_VERSION field.

> The point being making it possible to distinguish
> between this one and the one we'll hopefully have down
> the road binding to the IDPF class/prog ifc.
> 
>> +
>> +MODULE_DESCRIPTION(DRV_SUMMARY);
>> +MODULE_LICENSE("GPL");
Just noticed that we appear to have missed the MODULE_AUTHOR("Intel
Corporation")



