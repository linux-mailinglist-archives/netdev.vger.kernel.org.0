Return-Path: <netdev+bounces-5389-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62744711046
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:02:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1B5561C20F18
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 16:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C32F719E7B;
	Thu, 25 May 2023 16:02:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F5B18C11
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 16:02:52 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 116EB1A6
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 09:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685030571; x=1716566571;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Se7ghCDt1DbY+zWCzYpw8ul/YvRhx/IoB+cM9MuFka0=;
  b=SBwCzpFLwiOfYnYYLk7yTU/lNIQWHgzYniSJzpnlX2XUfkSH0hqUv//m
   yvxY3l0CZAPO0hw+OcKUoDiomGfK6urcQYNThIyV2rocoPMQaWYAoOOKg
   F+stMcP/F6vSr9SYESTZt5au/pcrO+kv9kK639+Z3nkW1nQqpaV3l6mhg
   MQnxDa7pOklDhKKZl14I6SxEpFK96455hTusjilz1d+dNoFkkbjNFBn78
   H0IXYRrPH8Cf5hZH7xQVe73H46XarBZIhQbncjfw3I2Xf0D+BABdPLQeb
   /9tZo4U7hxfuk+eo7KMwuI2mX+hLRhx8RaPpszzXxMmE0MF1R0k3z2F/m
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="419674852"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="419674852"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 09:01:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="849247587"
X-IronPort-AV: E=Sophos;i="6.00,191,1681196400"; 
   d="scan'208";a="849247587"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga001.fm.intel.com with ESMTP; 25 May 2023 09:01:50 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 09:01:49 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 25 May 2023 09:01:49 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 25 May 2023 09:01:49 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.169)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 25 May 2023 09:01:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SpnUDcMBkAjzYuOkBoJ2s2Aju0zNLhKbfZolQa1dOSyS7ei+JK2e+cAdMDZUsN6l+MlywgrgiwY+/1bcWpV7Fmw3FIP9v/xzFU8BuvVb3JQ+4nGQStmW3GqfJ55+CxNKy7pvLtvjJEXkk9DL8NHIcBgPcK17fSVT9IJbgqosIvA6Fi2SRmGSI37B+oJKNaQ2qVpMKkWe+1ReV20SUn5Yywa+DMCQFu+ZIryD2qC+a3AmSUb0UJFk30Sx3DPy8b80UbjA4jRmkD53iSoWeW/VpDsz/gscJVeF4UtJgdhowUcEXzDYW++Tb3joiXafj8VGZukEWjSbhgBUKJscN8pY4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WZ7llJYV2XcvjXukNUg6YZQcEugWxEbw4rCFKsdJzaY=;
 b=V1b2Hn9b96IxkqgdhC4ixZdZ2Z2gV45LSeiMB89mPPozpdHJHNCTdi3Ks1+o8/FPVZWgInw6p1msdWlqj10evESu25G00qqp0f38ZhDhT7pLPi5P/qj9u9cBNtGXyJGke1HN3KHlXIrZUWdXlnqtn7SDYxu9Ssf7Rrspgg++YJC0TVIbIU7ApXuR/h5r1FAqS0JS/4PnEoFo9FztOJ9C1q9TmLxaRgGdejE4bjOVx1/98M4f03iAZB9Zhiaw1aCwdsVuJw0ux1cCzjNWf/jCO09IbLmni0f/uXTBRh/y5TQa7EIxySXEKG4Py2ZkgxfFC7e41XHujOaBIT3FAYJ2Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from IA1PR11MB6267.namprd11.prod.outlook.com (2603:10b6:208:3e5::8)
 by PH8PR11MB6754.namprd11.prod.outlook.com (2603:10b6:510:1c9::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Thu, 25 May
 2023 16:01:47 +0000
Received: from IA1PR11MB6267.namprd11.prod.outlook.com
 ([fe80::9f74:a73e:4a25:fc8f]) by IA1PR11MB6267.namprd11.prod.outlook.com
 ([fe80::9f74:a73e:4a25:fc8f%5]) with mapi id 15.20.6433.017; Thu, 25 May 2023
 16:01:47 +0000
Message-ID: <962833bd-8238-2695-ca40-e815ed178a94@intel.com>
Date: Thu, 25 May 2023 18:01:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 4/5] ice: Add txbalancing devlink param
Content-Language: en-US
To: Jiri Pirko <jiri@resnulli.us>, Tony Nguyen <anthony.l.nguyen@intel.com>
CC: <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<edumazet@google.com>, <netdev@vger.kernel.org>,
	<przemyslaw.kitszel@intel.com>, Michal Wilczynski
	<michal.wilczynski@intel.com>, Pucha Himasekhar Reddy
	<himasekharx.reddy.pucha@intel.com>
References: <20230523174008.3585300-1-anthony.l.nguyen@intel.com>
 <20230523174008.3585300-5-anthony.l.nguyen@intel.com>
 <ZG37nuqjiZdjQADm@nanopsycho>
From: Lukasz Czapnik <lukasz.czapnik@intel.com>
In-Reply-To: <ZG37nuqjiZdjQADm@nanopsycho>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0124.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:94::15) To IA1PR11MB6267.namprd11.prod.outlook.com
 (2603:10b6:208:3e5::8)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA1PR11MB6267:EE_|PH8PR11MB6754:EE_
X-MS-Office365-Filtering-Correlation-Id: de4708ac-1874-4080-b079-08db5d3957d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qlr3/odY6jPX+oa3YDsKDgpOVM8aNsQejVMIvopxEbW6Q0qzIvOYCr9pAnF/nahIinVax607j9THSu707qDP4DtaF/WyGQaYaG3iB4upxjEEtPezPD3wziw1I7NUG04g7vNo35I/7Nfo9JovoPZOPyXuE4Ku9Eyfs+FAlYo5rGtID70mw5YkkjD+UaQaL6oam2zenKC/D9rqYusDA3tYvztlGZKwXIidTCMTBR02HmOBSpA567eSUF6pGESskMKT2zEpHvF5ACHlqEaRqXQEZsOJlvgZUA3h7T7rG0r9jfoBBobuJDNXiW8/ZwG4cg9a6l9OPvoU2jpNGKzPPLVMf2+aFp715/nXbHE+9OgYNpdcfAaLvezRPPcR9CLxYxcKsBNOSTUbHH9EThhuqinkJxsLR+EKXaD1mNziBkm/0DbN4VVqCecjaa2aY3Z3ywmxRoLQjhMgE4MEOL1tnvLs+aZfa7cbFvp2Pi+jt9IsqlJgUBeQ6Cz5ZTJv10if4h6YDAe69swE6+1z0yfro71VFxYKVPE25btnI063e0TQ2kHZmi5uKEwwqziht2RbWLOut9g7ZxGkROF/vIHvZ/h10aBmxrzJAL8e5ti72XPG0paHl8ZY0BrPtiQpA5QkGflTAI3pNd7EQNNqaWv7ASC3Zw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6267.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(39860400002)(346002)(366004)(451199021)(31686004)(31696002)(2906002)(107886003)(6666004)(478600001)(26005)(6506007)(6512007)(41300700001)(44832011)(110136005)(6636002)(54906003)(4326008)(66476007)(66946007)(66556008)(83380400001)(82960400001)(38100700002)(2616005)(53546011)(86362001)(186003)(5660300002)(36756003)(316002)(8936002)(8676002)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z3I2V2ZDM0Yrd2hkelNhZHI2ZnZEOHkwcTIzRW1jMlVyL21RdUloQ1pDMDVw?=
 =?utf-8?B?eWJsVDV3aEI1MUljbGxRdkxNSXNEMkhadHpseTB1K3p5VmVPNEdOVmplT0RZ?=
 =?utf-8?B?a21QK1B6a0UyZysxMWZLdWtDdnp3QzRxdlpiWjhUbitWcWtzNnd1aDE4bTFI?=
 =?utf-8?B?UjlxZTFiNHB5Z1lWV051Tk9RVG54VC9jUlcrenVYd0R5WVRxYXJyRzZMclNF?=
 =?utf-8?B?YVhRT1Q1eno3RURsNGFKSjVaYWk1U2RJWGZGSWZEa0NFVnhYR29IY2x6ZW93?=
 =?utf-8?B?ZHlNRjRyWUNjWUlzWVEyQUVUNE5pbmtnNXBscis3V0diZ2ZHZE00NTRpTUJB?=
 =?utf-8?B?em9tRnpraUV6Z2F6ZGVzNlpBTGZlc3YwSmhqbS81UVpKa2c5VnNpK3EwREpX?=
 =?utf-8?B?VytYcEVSMTRzMXl3YWVqUWxPRFMrUjY0MkZ5Y3F0aXhObm9NeW1Zb3BvSHlM?=
 =?utf-8?B?QkphODhMVWRoeEoxM1kvR29xdW1WV1lEU3BmN21CMUNDTWttSE5QTVY2QUNt?=
 =?utf-8?B?cFc5aW5iTWp0TTlGV04rTXA1NFJOeCtiUFBsWlh1YU9lVEg2emRpR2IrUXor?=
 =?utf-8?B?aGxXL2owdmkwMGxkUFRHUkpIeXlXclFGazNlcE05R1pEQjJ5VVhydTdLcURO?=
 =?utf-8?B?aFJhdWpMYmFYQUxmdTZNR1NvZUhsdGdPQ01jTURHWm12N09NQXVESlByRm5Y?=
 =?utf-8?B?OFByR0FwOHlXN3VUL3E4WENKaUdaWTZ5L1U2ZE5TRHJkV29GMFJTbWd6RUJ3?=
 =?utf-8?B?cUZ0MWtmVEhkdnVCWXh4bUVlMGtnV25QK2tVQmhhK3lRQTZZR0p1Z3hqVmp4?=
 =?utf-8?B?QXlwRkZNczhVa2NudytKZW9mQU9ObU5LUmkySHlRN3IvOTY2bmJxQjduT3Q2?=
 =?utf-8?B?M0xlUUFWNWJWY0VZSHg0SVp2WlNjWXA5dkJOdFNrdmdZUzhEMUV6YjF2QWNQ?=
 =?utf-8?B?VmNGSE91eFZPQTJsN3lyY0V4TzVoMnNhZHdpa0VHRU9uNzByNUttYzFsSHkr?=
 =?utf-8?B?aUZyNlhaSHNoU3F2TmUxY094ZklTbDFLbVVWcWJaVTQwMXhpYXA4MGVTN25w?=
 =?utf-8?B?dWJ1SmRORlRhcWtaWXJ5R3p6MURkUTJaK2hoeUo3eENCNFZ4VEVBbmFIajVm?=
 =?utf-8?B?ejZndk9qZEh3VlhJd0VEWlR3RVFQOEp3UzNqME1BZ0l2QmxtZmZsRFEvU2VH?=
 =?utf-8?B?T3RiSVhHUUQ3TTloYnNhSzhpWHVqeWFpT3ZnYmxBWkttOWhDa3YvamppNVU4?=
 =?utf-8?B?Vms5UFl6aU9vOVI1aFd0UVVzSXQ3RjgrWEx5ZFloM0R0VG9XZE9lTEgzblRM?=
 =?utf-8?B?bEc4TTJoK3FPR21paVN2d3ExY2c5dmZNK2xoMWhLZVV6eXY1SFg3VW5pcHZK?=
 =?utf-8?B?dzVsYXprT011amNiKzBMblppZVcvQlI3ejduYWhkS05ER2kyWTBsdDN2dnRX?=
 =?utf-8?B?M1o2dU5ScFhzMjlKc2QvQ3B6cnlPenJNUW1CODA0b2JZVFV1UGh0Y0ZZMUZX?=
 =?utf-8?B?NXRNSTZpOStTeU9GeGN2RGcxRUhPNVlxemFndVN1T2xhMUVoWitoVWR1QlJy?=
 =?utf-8?B?OGs2MmxUWjA0OUJUeGVNS0tUZDA2RW5zemlsUDFnNzl1RkQyOE9WZi9tZFQ5?=
 =?utf-8?B?ajVYTjhGL3NLdTJnOVJ6RDV0VTdJVVVhUnpUeCthZWZNZUloTWZUcVFjalFx?=
 =?utf-8?B?Z1krdHg2dDBZRHYyTFhHRUI4RmVvK3JVNldkSWFkZmNXbFRiQzhETDZXN0Zs?=
 =?utf-8?B?MHMvMTBTa2YxUmQ5VDdVdmJOeTdpeGFyZ1JWRjVnemlKUUJWc2NpTHFyMEVP?=
 =?utf-8?B?SFdwNVFVTFY1VEFrdGJZcSswd3B5Umw1Q0JQS0gwSk9FZWpZQmhtbmUzRENy?=
 =?utf-8?B?Z2hsOCtoZDBDVWF4L2hrUHp1OG5IL3V6RDQreFJhMkZSdms5SC8zRHdtSUtB?=
 =?utf-8?B?cTlhODg3bCs4Y1FIZ0xtdEw3QWxzUmNaNzQxeUtJaXhWbXE5ZDRhOGc0NzFT?=
 =?utf-8?B?dmxrNnd2OVJRbTFQcmNMdnVJM0JYQWJibVF3Rk9vMXFzK0NxQnZIMFZHQjRR?=
 =?utf-8?B?aVJqUm5TdlFTeHIybEtKcHpnRUNNOVZSNDl6d3FtQ3hkS0M0b1RPS1dFayto?=
 =?utf-8?B?K0RUTkFianFROXQvSU9yYmZmd0NBZUVEdmFQMEtrMXkyYWFGNHNqbkMrdWh3?=
 =?utf-8?B?anc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: de4708ac-1874-4080-b079-08db5d3957d6
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6267.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2023 16:01:47.3881
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ym8yQB+GHAAmOHGdqToqNZ7tPgR76SwSvXHZBFYd7kWD9ZNn5xZj0HI07tEEtfIW3kW6q12JOVoQBmlDjr/iPdZ/NWRHwO+sN8cAMpRAju8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6754
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/24/2023 1:57 PM, Jiri Pirko wrote:
> Tue, May 23, 2023 at 07:40:07PM CEST, anthony.l.nguyen@intel.com wrote:
>> From: Lukasz Czapnik <lukasz.czapnik@intel.com>
>>
>> It was observed that Tx performance was inconsistent across all queues
>> and/or VSIs and that it was directly connected to existing 9-layer
>> topology of the Tx scheduler.
>>
>> Introduce new private devlink param - txbalance. This parameter gives user
>> flexibility to choose the 5-layer transmit scheduler topology which helps
>> to smooth out the transmit performance.
>>
>> Allowed parameter values are true for enabled and false for disabled.
>>
>> Example usage:
>>
>> Show:
>> devlink dev param show pci/0000:4b:00.0 name txbalancing
>> pci/0000:4b:00.0:
>>   name txbalancing type driver-specific
>>     values:
>>       cmode permanent value true
> 
> "TXbalancing" sounds quite generic. Also, TXbalancing==false might sound
> there is no tx balancing. That is confusing.
> 

Right, agree this can be confusing. Also discussion under other patch
suggest txbalancing is not the best name for this feature.

We'll rename it. Open to suggestions.

Thank you!

