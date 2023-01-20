Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 855F8675B10
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 18:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbjATRVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 12:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjATRVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 12:21:20 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558BE10D8
        for <netdev@vger.kernel.org>; Fri, 20 Jan 2023 09:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674235279; x=1705771279;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z25azFAomVlffhnN4zG/lPpBcoEirakUdLep+SUFlWM=;
  b=JP0Eo4D4ZQH0Trw/V2K/UJywZqj1b1EcRVngnGJIjcgZXvIc45tukwgJ
   OtnmNxa9v2thUMwv/k8Vc1naHJkCXz443/xw84iYoAG45Sm2ReGDZ1Zz6
   GI2eRn0/dAzO8DsJhZAe2ss3vXHYOdGK5cf621oh7xkKyjcjbmlj4ah+Q
   SKbOS9E/n9MFeapzLNmxYBBkpynr/vAEfS6ei8lJpoDSFydiNnn2dslxX
   q8tjyTxICmOiVh1HYzB3XhHRGXjyTxI8u0AkesjT4tc/1/RuK3hXzNr+Z
   E3PQ+R8PKbhQiexAU5K4kWdlPAS+hN51BGYw377HMSHwqBW2K9UQU/l81
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="325673329"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="325673329"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2023 09:21:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10596"; a="768747978"
X-IronPort-AV: E=Sophos;i="5.97,232,1669104000"; 
   d="scan'208";a="768747978"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga002.fm.intel.com with ESMTP; 20 Jan 2023 09:21:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 09:21:18 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 09:21:17 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 09:21:17 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.43) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 20 Jan 2023 09:21:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hyr+o9pnjRqk9/p0sZC/WkFQBFUBOx2EOhXiR+IGtVmrn3KdaClkqshoiiAaXbSioYUv3633pwksrcGtYOaTpf/O8wOb7JxAGwLiWHdOlZC+g2/zNEwqGRm+D+/vUXvrsqEqndUkXNIOh/Rk78NSrtes4WxLJbu8X7ItFB1E+cMW2hq8q78M5gUBXHtGqPKkO+dZMOsPhgPA1CqkojGwPfgwZwpH1kcn8fieGM0NbYUoSmys/gbXfuH7d7y8TG+DvpwJ1pcFO4LYbZU2abYQ+G9FbjYZdiSmtRIIA4IcMkIIGCI7Thc5TqmhlEVnb+exswH/ZaH7jbyKRpt/bV34Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hbkSxa05XaWCATJ0e64q+fR3ZjRG4v/mHRzAQRm7WNw=;
 b=TE0xo2qia4pND/U1WJY+/Km2bchqPUvDD9qqh+Vm0SbeS5kuwlVeirNB9eHUXUoSpUDy0qOrGfEk1oU17446c4BEPvaAP1SE1PN8HvKYuslOQTqex4RBvzGSdb8Qtn6n3hLwtdopyomicmylo0klI5Kad0oUvap8pSDxfNhn00Pc4Hod/rVa5xF/78b+CLZtyyAvBiZfvyX8tVJ7hxfVLLkjbxEWlUaEbK6kRjTa2gat1SCoNiA66VpPlXJk3v6ibKDv8loH3iT0d/DSHnWZ9INRzsUC/n+kIVihlqBjd9RjZAjUhTpkGauygATwSqO0mHiZcI2nIv9OvFC2zU2dWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by SA0PR11MB4766.namprd11.prod.outlook.com (2603:10b6:806:92::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 17:21:12 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%5]) with mapi id 15.20.6002.024; Fri, 20 Jan 2023
 17:21:12 +0000
Message-ID: <8da8ed6a-af78-a797-135d-1da2d5a08ca1@intel.com>
Date:   Fri, 20 Jan 2023 09:21:09 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [net-next 03/15] net/mlx5: Add adjphase function to support
 hardware-only offset control
Content-Language: en-US
To:     Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Vincent Cheng <vincent.cheng.xh@renesas.com>
References: <20230118183602.124323-1-saeed@kernel.org>
 <20230118183602.124323-4-saeed@kernel.org>
 <739b308c-33ec-1886-5e9d-6c5059370d15@intel.com>
 <20230119194631.1b9fef95@kernel.org> <87tu0luadz.fsf@nvidia.com>
 <20230119200343.2eb82899@kernel.org> <87pmb9u90j.fsf@nvidia.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <87pmb9u90j.fsf@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0041.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::16) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|SA0PR11MB4766:EE_
X-MS-Office365-Filtering-Correlation-Id: 5b6672ba-53af-4c0a-28b8-08dafb0aba69
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Po6qBdDxlv1WIfoOGLe0lUzRXrW9rMIaiF6V1YijZiBKq9AP9/PaF7cvY9EzYaoEp7ADfDrdLgUCb3Qc4S2NUCY2hhYaAEuoZF3ZqXIix9RkZKd0Qi9BHfQde0yFBuxLBXYKL09rCwkje8MG2m408twYLkwJ2AOVOqREL68FORNUL4yqKbwc79rrA3vTHJLr4/FHeGeFWbg1wm+N4gFNOPyhJqYhtoGQ/KoP9EofqTAhAdjLTTsR6gHjw9qs9oRbQvtdL25Q6cVj4onT8LcGo13SUVO8+dhKRYgdEWvXZMfF0UDtpmGHP4AVy9zTfDClhlD6A083nJVc9g4k2Owdwj2Qluu7f68IDmmEZr/OOl44DUThmAaP4UUup8C9sfDflSrQyQjjmoXPGYuGDoxjVy03tnWhdMfBr7AVuLtX+fE63PBKqT0BdW0WOvNHFw48KeDFMWihCTjj3w0rGmqOQ99yqFMU63BdAtxbMhg62EFRfJy2OqGSpCaz50K+G8BVMQ67RIgEgdOgjCBYSb76hF52Dg2lTBuyMu7qX9vgD+ytG6uomG0HHVrde7ghdZ+28IgzCNfgnE1X/p6WHXKNphw0YwPz4Dz198y6PzAChkZnA6jwaR4a4SoRk2qlXHb20k0xyHaNWzxZVCnQ7WUYBw8nEtkYWN0HN9Xb/quDcJsrrPZUWUVbtkq4MORgbcoZbWaAv9vZ9F+3epQzZafRRlnHwBghZGI7hu+FsASK3R8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(346002)(366004)(136003)(376002)(451199015)(2906002)(186003)(26005)(6512007)(54906003)(110136005)(6506007)(2616005)(6486002)(316002)(36756003)(478600001)(31696002)(6666004)(53546011)(38100700002)(86362001)(82960400001)(83380400001)(41300700001)(7416002)(4326008)(5660300002)(31686004)(8936002)(8676002)(66946007)(66476007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dERBeVZZUzg2aldQSEFYWnBjUFkyeDIySTBLazEzQnp2OXk3QUEvQmZic3k0?=
 =?utf-8?B?UElwQ0xNZ0lGUEtjSTBvRHBZNXpDcjZ0OUZHSGM0aXV2aW9wYWJ1eThEUFFB?=
 =?utf-8?B?OUZhekFtKzVlVU41RjVUaFMwZ0VoN0JRQVYwRlNVNDZzZUFVZXc4Y2VuMlZH?=
 =?utf-8?B?RE1TVVZ4bDlvN0xrUmVMRXE2RW5YYmZMcURlYXFObHBnbDh0Y080SFUwYVY1?=
 =?utf-8?B?Z2pxWS9GZ2pEK29xemt0Wlh3UU9IemlzYUFLT2FzWXVzUkVYVjJhbE9KMERY?=
 =?utf-8?B?aHRVUE1rcjVPT1ZPY3U1clZPNy90VWdocnY2elBWK1NPcE5YUTM0VmZMSUtu?=
 =?utf-8?B?VDd0blZRYk4vcjJsZjJtNXZqQXU3cDlIbkdkckorQVZRZDRHY2dIZGZoQ3JB?=
 =?utf-8?B?R1c0dFByRlMrTTR2eW85U09nRkRxU1VOclBNaVk4UkpvRFJkazhyUWdYQ0Q1?=
 =?utf-8?B?eE9USmhBdjlFRUVxVURNSVllY0VuQmRQSGNYRGhLT0RKd2drQmlJcmRaMzho?=
 =?utf-8?B?Z0F2S2pXaEZIaVpua0lQZ3Z5TlNxVisxV1pFalZCYjBEb2o1Zk96UTErb3Bx?=
 =?utf-8?B?b1ZpRCtCWmRwSFlmWUxjZHkzbGVHdmRBRW5PUm9UaWpNczV3WUpQZm5WS3hR?=
 =?utf-8?B?dkRtMXJiNlUxTEJEZ3ZUZDZ4RE5rTkFOR1JpZUZ0b3FxYUFWS3lsaEs1SVM1?=
 =?utf-8?B?SDhQSXVHM3NaK05SRzhHTUZxaDU4SzRDM0ZzMG5uTldmY2RKU2E2T1pQQ3NK?=
 =?utf-8?B?bWoyNTl5c3ZRMU1xMFhJTERkSnBkZmJNWUMrQkJYck9ySExkeVRCT1B3bm1m?=
 =?utf-8?B?SllzQ0pKNHdoTExCMmw0eUV6aklKTW10b1ArbVUvWW1BbDZrT3R4ZTlKQS9Q?=
 =?utf-8?B?b2g5VWlFTUhZcGpUV1IrTmJhb0ZJcjgvZkZwYzZYdUtsMVRLaElqYWVxOGpp?=
 =?utf-8?B?YzE3VllOQThqQXdzZVh4T3BiYkpOZ3ZxbEhIOTJOSzFTTmFieUdFZURTWjAz?=
 =?utf-8?B?RzhtWjFPdjZmNE5MRWtESllRU3I3Tm9YM2Y3Q3lSMlBWekdPZHVTRTEwWTNE?=
 =?utf-8?B?ZENkRmUrSytBYm9RQ2hoRTEvTWM0L2VwclFEeHlNWGFnUzFGRHpVaG8zeFl4?=
 =?utf-8?B?b2J1ZFJCanh3ZFZxd044WFVweVYvSTkyZjhJSEU5ZGp3Ry9KN2RRbXUxWkZ4?=
 =?utf-8?B?eExxcWI0SFNFbXdYSEpLdERaWFk4RmtaK3p1ZTVqV0FsbDc5NzRFT2hUZDkv?=
 =?utf-8?B?YVpvakkzYnJsMjBDYnJqbDFRUmtoZUprL29Cdkw3dUNxSzFyRWVacFJISkZi?=
 =?utf-8?B?Rmg3dUtBTnB4SlJWSi9ra0ZTU0xEZE1uMzd5OURyOUlhS2k0dHY1aHlLNzJ5?=
 =?utf-8?B?ZmZ3QXBmWjVUS0FOck9VSG5BUFdCelZORmRmejI0QzhMa2R0THpNOGVLeXNx?=
 =?utf-8?B?QzRXRk5tRS9ka2RNYkkyc1FUZVAvVWxoRVVNbGNqN2ZQNk41ZklJZTR0VGhV?=
 =?utf-8?B?SWZZTmxuUGhCSWJnN2txY1dEQmsvd0pmR28vRDVCbDlhRHVIZGtWbVN3QWhv?=
 =?utf-8?B?cWFCcUdveDNBdHdVYmw4RDlYa1VFRzdmbFpLTUluempaUklyZjBXODh1TEhH?=
 =?utf-8?B?VkpJYW5kdVlxeTQ2NWZNS1JjbEg5aThhVVhhWTZQQmk2eG5QeUowMEJzakNs?=
 =?utf-8?B?UkhIR1FmRTdJRmppWjhkbmxHem56aDh0MGlzSlR2Z2g2dzVjcWtaU2h6OTcx?=
 =?utf-8?B?V0VwYVhNUXNGc1VuNnpuK2cwVVZwMTdEeHd6NDBZYkhqWjRXbnJ0b3RJL2Nm?=
 =?utf-8?B?VFA0RTFublBxN2wyZnNDWU1pVHZoQmk5YmhmU1lmTVBDWldhWnJ2eEdEdDBv?=
 =?utf-8?B?elJqNmY2dytMOUcvY0hSTGFLWS9HSDJSOVdncG1Iby90M1hIOVh1b0xiM3B4?=
 =?utf-8?B?Wk0xT2NZVWZSbDNHWjY0QVdjZHdZZmMyVDh1MklUSko5d21ncHVVRG15ZzY2?=
 =?utf-8?B?eWdrbCtqbTJTYXVmb3BrRVFtMlpzZFVsRHJhUmJVRUhZclp6VWNzZXF6Z3Bk?=
 =?utf-8?B?aVNxVXF1bGsvQ1pxaWtLV04rN0xmemJWR252M25VMEUyUlcycnh5WGNNQkxs?=
 =?utf-8?B?bmFOVytqckJMTnlnTFM2MTNpczZqakNKNVM4TXg2SGljRkhMREphVUE4aXZB?=
 =?utf-8?B?ZFE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b6672ba-53af-4c0a-28b8-08dafb0aba69
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2023 17:21:12.3607
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Ghb4mlzs0MLTCGGMSLwenSYRVEjyLaT/dU9lnGniHte/k3Y9BnH7ZHFLVYaGecHFRHWwS/h/pSyqj1/WR9LRDuzw50FYwUHqVg9aaSmxUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4766
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



On 1/19/2023 8:26 PM, Rahul Rameshbabu wrote:
> On Thu, 19 Jan, 2023 20:03:43 -0800 Jakub Kicinski <kuba@kernel.org> wrote:
>> The other question is about the exact semantics of ->adjphase
>> - do all timecounter based clock implementations support it
>> by definition?
> 
> My understanding is no (though anyone is free to jump in to correct me
> on this). Only implementations with support for precisely handling small
> PPS corrections can support adjphase (being able to adjust small offsets
> without causing same or worse drift).

I guess I'm missing something here? timecounters allow adjusting time in
an atomic way. They don't lose any time when making an adjustment
because its a change to the wrapping around a fixed cycle counter.

How does that not comply with adjphase? and if it doesn't, then whats
the difference between adjphase and just correcting offset using adjfine
for frequency adjustment?

I guess adjusting phase will do the small corrections in hardware
(perhaps by temporarily adjusting the nominal frequency of the clock)
but will then return to the normal frequency once complete?

So adjphase is more than just being atomic...?
