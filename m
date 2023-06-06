Return-Path: <netdev+bounces-8447-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1202B724197
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:01:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5CF571C20F8A
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94D071D2C0;
	Tue,  6 Jun 2023 12:01:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FF5B15ACE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:01:33 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACEBD10D9
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686052890; x=1717588890;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=CrOX1usa8e5Lkol11A6hboFMXW6EUIIUjstDf7Apb0U=;
  b=eRRsdxMpqXIacxSjBcN+dewsNkS/2wo7FCXWnDhdoVOiZWGaD2FoTfWI
   qd5kPHn7f6TwTmgnEDMggMHxg5UjQ8cauA/3wVKCmyXk1dGyu/KlOcdkH
   b71VygAos5swriqq0d1E3WaBObOh+n5IM866GdRYq1JWgKgnsan5tmCv2
   y23RP7L5UOoYVLCjsZ4NgcdcQpIPMgA6Xc5x/K0XEyVDHPK8Ew0qax7oJ
   msuND+glitg2oA5DJZkN0lKM06sXGpLqQIarTtkUHyHpUZU+weQYchFgY
   G8a0kBo9SlLC+szss+8P6HnUD59TzgzrL0AXqacL4vZXtAKGl8kg6soXa
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="337002740"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="337002740"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2023 05:00:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="742122865"
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="scan'208";a="742122865"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 06 Jun 2023 05:00:02 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 05:00:01 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 6 Jun 2023 05:00:01 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 6 Jun 2023 05:00:01 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 6 Jun 2023 05:00:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XjkeurJ5YCd2khB7jB75YFu/Fm0hPZ17wa3LogkaQGMeGDRdJrwIGc+hrCVZy5SqpsL6TsqDolP8Dq/T1hctImlq97in/LFgfVlnn93TaYo7UotlPVPIZupqyo/vlI9YA2KmQxChKBJyLaUKGsWrXzHwJVaf2dYbH76ZahKSGbhKvOyNtcTB5+K8toUkmobk2Q5vmhJlestHU/sc4G9Rpa478GN5/htulJZuQwWK9E63ZkK4GC+zFUGeDa+DMrPqN/H9jFQ8nk/62Nmii6nVOKj/3KTMl28cndyz2DSYokQ+8VRjAbd+wNPAb/uLLsL4h0D0v7oGGm8Y9pojwhCPlA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=agi+I89QRJBBZfxDwwDBgI4vh9w4QgXYHznO5Onwbgs=;
 b=UZgoJfm6OjN0Qo+YRfC+NocEk/wxmgJaahAPh9JPWWARnW+gT9uVzQ0jBT9UK0x+pW3AhFVSypCRawO4ZN4VBEEOPxnNOoPLP/EYaG6oYir3YUxxfh7hiUc60jTd/qXumBeEcGYthwsADIELWpHuxpvJVvAV6qnXvv8npIOVZlHd05sDtm/DRzQ9ZO/lGtl+0FabRVu0+tb3DcdF9++9dvCpRqnJ+3O9ByGbQZSvtod+itf3ieI1RP8S6tt4Ei4X/eQ8fD+CbRGrjACNKv2ISZ2UcepQeBEuPhzcEtGdSygTuEv1MEsGOfgZH5uoTsTPT7Wd+/IRPu52XQPnINFmxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by IA1PR11MB6100.namprd11.prod.outlook.com (2603:10b6:208:3d4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 11:59:58 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::87ad:6b1:f9f4:9299%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 11:59:58 +0000
Message-ID: <9cfeffae-e0f8-0cd1-2f62-b28d3227869c@intel.com>
Date: Tue, 6 Jun 2023 13:59:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH net-next 2/3] iavf: fix err handling for MAC replace
Content-Language: en-US
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC: Tony Nguyen <anthony.l.nguyen@intel.com>, <davem@davemloft.net>,
	<kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
	<netdev@vger.kernel.org>, Piotr Gardocki <piotrx.gardocki@intel.com>, "Michal
 Swiatkowski" <michal.swiatkowski@linux.intel.com>, Rafal Romanowski
	<rafal.romanowski@intel.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-3-anthony.l.nguyen@intel.com> <ZH40yOEyy4DLkOYt@boxer>
 <29e3a779-2051-d4bd-08fc-2835b05de55c@intel.com> <ZH8JBgiZAvNdfg4+@boxer>
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
In-Reply-To: <ZH8JBgiZAvNdfg4+@boxer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0224.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a6::13) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|IA1PR11MB6100:EE_
X-MS-Office365-Filtering-Correlation-Id: a38ef225-bc80-459c-4af3-08db66858cb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kh65jRjrG+l/HpNod36RVVqDJ4BsnpVHOx4TMGLx69vAy5U4s5kAHBlnj6zycII8BMUUD0Z7sG5e8eT03Oi4gpksHk7RIvyJTbYODFZMcq2OtneZAdeGtpqpVQ39e5L2UxzAb+DlZaDvBpO9+zEWv4PlwqCHpId43iZSTlYlga0lt7YWYTg49MgdHXLGXub2vwfEP5ts46eaJLxAkAug94ZvNaGN5FDgCOB+yetUk8so+sxR6wAyAA87/5mGttfWBD9VolA4CMqJpAZQm36HYGZp+y3Hz9J3lRQvuaTHH/b32NbRKQKtlhBHYtswS/1LrOr4qlxbXAe8iqmIzY2jahgjXomfPUl9NbsBZHj5eVnnl6yd5SVOBmZJohB30WjAynXLjO4Qo3gUxOyGvQOwgMTpPYSsCG4xzpPA0/O/tFvBP7hWkihUhIR28DTynSLH4bsknfGSjGshdskOmLe69JV6Hn/Gv9FEt6qB7Ipqq/lrmtUSD9VYya2iEcOrm/WHeTe0sxm5i6UP9RS6hGjLofH4qmddSJN5MwJaMfoUGM8w2Y+xTH3ILPULInrpXyYiGHTfCXNOlQxn9zxO6OIyMiIkZOLAFG0PIjtND/63+frafaWwnMxMJjLyOXo5OjkmchBxxJAzf5tCX9CiEBSBAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(376002)(39860400002)(346002)(396003)(451199021)(6666004)(86362001)(31696002)(31686004)(5660300002)(186003)(26005)(6506007)(6512007)(36756003)(2906002)(53546011)(8936002)(316002)(8676002)(37006003)(6862004)(41300700001)(4326008)(6636002)(38100700002)(82960400001)(66946007)(66476007)(66556008)(54906003)(2616005)(6486002)(478600001)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjdRUXhPNWtnNHcvdjJUenBGb1hMOTJTdjlpWXFCMy9TRDJOUWg2d053SC9p?=
 =?utf-8?B?U1lLdW44dXlncmZSUzQ4ajRuNHJXTHpQNHpJMTJBMVg1RnZSZWZjRHJpemdt?=
 =?utf-8?B?bTBJcHZqU2doRkN4MW9hclhDQm9XOTRBMHhXK3BWdUcwd1ZHVHpkS09UOW9T?=
 =?utf-8?B?eThTMmZEWjRZQXlkaUg3ZG9DNUkyTkZNK21UcFpPenRzam0yWlJmZDM1RkRM?=
 =?utf-8?B?NjJES2tteVFmOGdqenViVWpMSFNpckhZZCtZSUdGTEdtUVY0NEhlQWZEdmJI?=
 =?utf-8?B?d214U0VGaXMvNkRRMnpsdUtBZDFidXUxVGhGK3p5ZUhsalFFWktFd3VPSVFV?=
 =?utf-8?B?dkpqYnBzWElxYWNYQ21OdGtBVmVlcE1rd2daYkZXSzZtcC81Y0QxcnNSb3pQ?=
 =?utf-8?B?RXZuUkRMYWpXcG1ZK0R4REhIS2VZZHRMSC9aeStjZE44bWlibzdKS2RJbnNu?=
 =?utf-8?B?RXZFc3NSeHhnZUgwakY1emh4S2JkVzNzbXRXS0U2aS9YemwyTXJWdHJzVzZF?=
 =?utf-8?B?ZXJRbDlzZC80c0cwTnlzMm9IalV0cm9RcmFmYXRVWnlwTGQ2NkpXZVBTUFht?=
 =?utf-8?B?V2w4YmhvWExTZ1RZVU1Ub01aRG0xRUUxT0RETklPWG9JdzRHNmdYcFZ6Ym1n?=
 =?utf-8?B?T25sb2t5Q2dOb2xtNnB2dENybGwvejM4RTY0S1VMOWNEOEVtenExM3JSaHFj?=
 =?utf-8?B?dk1MZmtjZGFRdWlqREVqVlJLU1J2U2NGdzJEdXEwQW5MVCtkM3J0VGRvOTJs?=
 =?utf-8?B?YzNVZjNvNnBNZTZjaDVycTMvRWxZT0NQL3hSUXNRQ2l4OUtLU1BXVnB0dFF4?=
 =?utf-8?B?ZHdKeXlrWEIxa0l5cDZROXNTemY0MHFvSktpdThnRTJucEtKVHAxTUFObzNm?=
 =?utf-8?B?ZWtKRmZyeERkd0FRWGdWNFNhamNXMUlsZFViTEVjUHgxNXlyYWc1ZXIzT29E?=
 =?utf-8?B?U0x0Y1hRVXVld0tlN3BicDNmc3FIbHhwdGNHOEhHaFdSTVZyOU5sNjAzZC9E?=
 =?utf-8?B?RlBJSGV3ZC9aZ1ZaUmNUeUxJb0FIN2UyUk43ZERlVjk1R2JJeFN1bUVCSVh1?=
 =?utf-8?B?RGNJM2V5alM0a1I2OXgvUEFySVQ4UlEyaVNSZ1dPS2d5VzZheC9MRExhQnVJ?=
 =?utf-8?B?UTZNdkVXaGQydHJSZU5DNUlOYjcxZ3hDNGFPUUJzRzhldU9iRTRPcU52Vkky?=
 =?utf-8?B?TVJRUzAxWStvMlFDYW9vVW93Vjc3cktVWTc4Q1QvRGtTZ1pBUGd0ME43ay93?=
 =?utf-8?B?UzJWdUVISGNIWW9FQ3NZNWMxckVHamN0Q3hOY21oUXIydjNLd1c2R0tVdUFJ?=
 =?utf-8?B?TVFEdk9tRXpRYWJtT0xXdzV0VjNTSFJUQkJMQ01TUVBlcnlTdWJkYlZpYmtt?=
 =?utf-8?B?eVVVQjNxY2hpVW5jb2xmRUFzWVpOUFlZNjA2S1I4YmxBWGNuUzdTYi8vY2NP?=
 =?utf-8?B?eHRDNmxIMkRtRVFNaXl3Z2E5aEp1T0d6QVVPd1Axd1g1M0p2c2lqcTAvcnU5?=
 =?utf-8?B?Z0pSM3JYcVAya0ZkUnFzWnRFbEJaeVNvVDBpN0c5RnpYNUJ0QmZTT1FIcDAw?=
 =?utf-8?B?RzluMzRHV0V5UlFpekkrTUQ4bFhpZVVSOWNJbmx0TkpISW82dHIreDJRejdr?=
 =?utf-8?B?bzI0UjNIZUx4YXgzWnFjREJlTEIxQkFwSXBBOGJkLzE4NlRHbHkwblBlZUNt?=
 =?utf-8?B?bzNXaTBhczFDb0d0TTdobDRyaVM3U3lHOU41WU1OT0xYcHRZTmJNU3Z1UEx0?=
 =?utf-8?B?Z2xXbFFEbjlpN2RYeDhLK25CWjlJOVZZT050YXM0ZnpXcGlMdCt1QUpuRlRI?=
 =?utf-8?B?VFI3b2FiN2s3TEViVXVkcWFlVXJZcTBwbmxDRnhJY083WnpaV3ZBVjJvanVj?=
 =?utf-8?B?MXBiMjNSMjJnRlh5MVFxNjFsaVN2ZDVRc2kzVmF6YnRDdFpZZWpRSktZTUlI?=
 =?utf-8?B?OEhaWTJWWjNHZ05iODZqNTVhRCtDdXJsRmZSWjNhVi8rUTJtQzd4N29NVSta?=
 =?utf-8?B?c2xnbjhSOVJhYlpxRjMrdEhQZFE4blFPa1grM2JJWm44aWcvelBZWmR1VEdn?=
 =?utf-8?B?Q2o3Z3U1MG83K0ZGQ3I1bWRsSTVUSDBaRnhLR0lQc1FHRmwwcnB2SGNkOVda?=
 =?utf-8?B?VEVRVkhhM0hJQ1p3ZElhWHh6STg3NmEyU3F5THlLdUt0ejZxcFJCSDJPNW5a?=
 =?utf-8?B?UXc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: a38ef225-bc80-459c-4af3-08db66858cb6
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 11:59:58.3060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+H7GhRjc08rMq5f9EtpAvic5+WY/H9sMm6Z4+16dkgbeX6FVsScK0GTeNTXiB4iuHuZDRkP3J4Sls+rcyWPHNAKuvAq+We1XdStV0CsAPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6100
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/6/23 12:23, Maciej Fijalkowski wrote:
> On Tue, Jun 06, 2023 at 12:14:49PM +0200, Przemek Kitszel wrote:
>> On 6/5/23 21:17, Maciej Fijalkowski wrote:
>>> On Fri, Jun 02, 2023 at 10:13:01AM -0700, Tony Nguyen wrote:
>>>> From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
>>>>
>>>> Defer removal of current primary MAC until a replacement is successfully added.
>>>> Previous implementation would left filter list with no primary MAC.
>>>
>>> and this opens up for what kind of issues? do you mean that
>>> iavf_add_filter() could break and existing primary filter has been marked
>>> for removal?
>>
>> Yes, prior to the patch the flow was:
>> 1. mark all MACs non-primary;
>> 2. mark current HW MAC for removal;
>> 3. try to add new MAC, say it fails, so that's an end with -ENOMEM;
>> 4. ::is_primary and ::remove fields for the ::mac_filter_list, alongside
>> with ::aq_required are left modified, to be finalized next time
>> user/watchdog processes that.
>>
>> For me it was enough to treat it as a bug, and for sure a "bad smell".
> 
> Thanks,
> Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
>>
>>
>>>
>>>> This was found while reading the code.
>>>>
>>>> The patch takes advantage of the fact that there can only be a single primary
>>>> MAC filter at any time.
>>>>
>>>> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
>>>> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
>>>> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>>>> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
>>>> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
>>>> ---
>>>>    drivers/net/ethernet/intel/iavf/iavf_main.c | 42 ++++++++++-----------
>>>>    1 file changed, 19 insertions(+), 23 deletions(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
>>>> index 420aaca548a0..3a78f86ba4f9 100644
>>>> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
>>>> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
>>>> @@ -1010,40 +1010,36 @@ int iavf_replace_primary_mac(struct iavf_adapter *adapter,
>>>
>>> from what i'm looking at, iavf_replace_primary_mac() could be scoped only
>>> to iavf_main.c and become static func.
>>>
>>
>> makes sense, thanks
> 
> are you going to followup on this? probably there are some more low
> hanging fruits out in iavf such as this one.

Sure, after some digging it looks like static-whats-possible warrants 
another patch ;) (will send soon as separate series)

> 
>>
>>>>    			     const u8 *new_mac)
>>>>    {
>>>>    	struct iavf_hw *hw = &adapter->hw;
>>>> -	struct iavf_mac_filter *f;
>>>> +	struct iavf_mac_filter *new_f;
>>>> +	struct iavf_mac_filter *old_f;
>>>>    	spin_lock_bh(&adapter->mac_vlan_list_lock);
>>>> -	list_for_each_entry(f, &adapter->mac_filter_list, list) {
>>>> -		f->is_primary = false;
>>>> +	new_f = iavf_add_filter(adapter, new_mac);
>>>> +	if (!new_f) {
>>>> +		spin_unlock_bh(&adapter->mac_vlan_list_lock);
>>>> +		return -ENOMEM;
>>>>    	}
>>>> -	f = iavf_find_filter(adapter, hw->mac.addr);
>>>> -	if (f) {
>>>> -		f->remove = true;
>>>> +	old_f = iavf_find_filter(adapter, hw->mac.addr);
>>>> +	if (old_f) {
>>>> +		old_f->is_primary = false;
>>>> +		old_f->remove = true;
>>>>    		adapter->aq_required |= IAVF_FLAG_AQ_DEL_MAC_FILTER;
>>>>    	}
>>>> -
>>>> -	f = iavf_add_filter(adapter, new_mac);
>>>> -
>>>> -	if (f) {
>>>> -		/* Always send the request to add if changing primary MAC
>>>> -		 * even if filter is already present on the list
>>>> -		 */
>>>> -		f->is_primary = true;
>>>> -		f->add = true;
>>>> -		adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
>>>> -		ether_addr_copy(hw->mac.addr, new_mac);
>>>> -	}
>>>> +	/* Always send the request to add if changing primary MAC,
>>>> +	 * even if filter is already present on the list
>>>> +	 */
>>>> +	new_f->is_primary = true;
>>>> +	new_f->add = true;
>>>> +	adapter->aq_required |= IAVF_FLAG_AQ_ADD_MAC_FILTER;
>>>> +	ether_addr_copy(hw->mac.addr, new_mac);
>>>>    	spin_unlock_bh(&adapter->mac_vlan_list_lock);
>>>>    	/* schedule the watchdog task to immediately process the request */
>>>> -	if (f) {
>>>> -		mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
>>>> -		return 0;
>>>> -	}
>>>> -	return -ENOMEM;
>>>> +	mod_delayed_work(adapter->wq, &adapter->watchdog_task, 0);
>>>> +	return 0;
>>>>    }
>>>>    /**
>>>> -- 
>>>> 2.38.1
>>>>
>>>>
>>


