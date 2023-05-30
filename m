Return-Path: <netdev+bounces-6579-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 54767717002
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:55:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 00595281071
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:55:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1B0A31F0B;
	Tue, 30 May 2023 21:55:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE780200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 21:55:06 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B43FAA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 14:55:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685483705; x=1717019705;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=8/Q7rrvt1TsdaVZ8cSGUrMq2y6b9F1qi3xY90yhRy9s=;
  b=mU3IkJ9AXbxcJtkGkLnWQ35vL+fQqAMPN/L7v5TIVIKAniCFLjtgFp4H
   HHEzrr35ZZBmguhFAM33OQpNwvd2NKEtISB72UJfSMgokb+BmTGJht8nZ
   yizLCPZSm306XDwD1C4IlELopNGetfDzfZUZ32fY8URlvMtI1XbtFp1pu
   BQRRP3IjTRhzD4ldnQJEs3xafziG6JJJ2ReZJEvA2mACo+izdTBOF2Nz8
   LJjBy7QdvO4UxDNI/MwlqOsn2y3WQyr6empHrCE9HVkwRvPUWmJDHr6uY
   SeWakTl6h9GsSJP09NH4eEWsbeDpPvb3vRWstrHiNA2BFwkupzsO64uxM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="353900421"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="353900421"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 14:55:05 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="776515168"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="776515168"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga004.fm.intel.com with ESMTP; 30 May 2023 14:55:04 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 14:55:04 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 14:55:04 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 14:55:04 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 14:55:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nQ8mUtcVy9tZy5GVFKlEZjVytkedsmPnLKYkEsrMT/+uD26r0ULyMlGjryCLGLGEcUPn83oOvfDFuXnaIgrzSJSXcOLXU4RDbXLnW/mykq7H+Fyhf2o89g0cmlOGCp432TQ0y7r+aa+7gJbviBRE9mrE7yKY45+1Ja0sUu2pmhDEwQVylPaN+vmAUsfWQ/r2SEkfZdJiEKL2mlD9iFRvTazscmXor5U4AWnsIFzOHD2q+akD3XrIHPHRZ3C5FS4s01g18KyYQ5muxoo4BKi/DGF6EgcQlMxxMGBwvExbbseMnGfPTWH6BelIMiVlCRqbcT55BR1BQMOgPKJXYL1dRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hvD8VVdO4s2dny7dOuyebrXJ0cKcm2WsDaPFmXMr31s=;
 b=TrsMnBNFJx9TN0Z4DrLwk4dr78PIdzDts4oNeyQmySc3Uo6SzcuBiUkUowR2vgbeMA5BrBSd00nLEEsClkYrU6VROfOj7BYjYPYuZE6klXBMtI98H5+HuzhgCo5AZfZgt6nviMe8gUyI73St6Vz2H7FjDlMrRVOSQ7CMdGaIVVRJYBtSXPFcmA6z4wP2nthBHDMuBIA5od1Xi237OGehPFPSDC3UaGZo6SjY2nVo6G+eUrLKrp3tAaagADLVNovEATyTYcRhJHfA3a7rtIN0KSiQ+ahyMHGfkzt0KAeOCimA8qhNEWlTq01IB6AeM0KCG9/dy3xuWirMR8AhJ7i0BQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from BYAPR11MB3672.namprd11.prod.outlook.com (2603:10b6:a03:fa::30)
 by DM4PR11MB5296.namprd11.prod.outlook.com (2603:10b6:5:393::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 21:55:02 +0000
Received: from BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::61ad:23be:da91:9c65]) by BYAPR11MB3672.namprd11.prod.outlook.com
 ([fe80::61ad:23be:da91:9c65%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 21:55:02 +0000
Message-ID: <ebcaf661-a6c3-518e-bbd0-f4c65b83056f@intel.com>
Date: Tue, 30 May 2023 23:54:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH iwl-next] ice: remove null checks before devm_kfree()
 calls
To: Tony Nguyen <anthony.l.nguyen@intel.com>,
	<intel-wired-lan-bounces@osuosl.org>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>, Anirudh Venkataramanan
	<anirudh.venkataramanan@intel.com>, Victor Raj <victor.raj@intel.com>, Michal
 Swiatkowski <michal.swiatkowski@linux.intel.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Martyna Szapar-Mudlaw
	<martyna.szapar-mudlaw@linux.intel.com>, Michal Wilczynski
	<michal.wilczynski@intel.com>, <netdev@vger.kernel.org>
References: <20230530112549.20916-1-przemyslaw.kitszel@intel.com>
 <8a60b531-09b2-2df4-a7bb-02e3a98e7591@intel.com>
Content-Language: en-US
From: Przemek Kitszel <przemyslaw.kitszel@intel.com>
In-Reply-To: <8a60b531-09b2-2df4-a7bb-02e3a98e7591@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR2P278CA0090.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:65::14) To BYAPR11MB3672.namprd11.prod.outlook.com
 (2603:10b6:a03:fa::30)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR11MB3672:EE_|DM4PR11MB5296:EE_
X-MS-Office365-Filtering-Correlation-Id: b4c99cd1-e763-4c9c-25fe-08db61588506
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gEGpXBWhACarLK53nK1/n7QICyh5zeyjQ/QEVG5NUrWsTvOeCRJ05DhHvxfALbaEXYi+/EwYFpN/w8ZQgZUTQ60bSclXVq5cY/alHwgAufO5AO7LABD/bKO+9NZwqlmySBMIDESOJr2LE2tODfbDtOpgVMkpJuz+QVPus1PHqClUMfuKAfoT4ejpNrlQrGwihaqLLHIxBC/n4WVjwg3uebpCGhyES4NnKOxbp9sNSJZmVEQQaOSrCL4+wYcR/ut+bkevH/CVZPoZ8ZxAbIot9e/ZTsgng/ROdaKL5/FD0gvF2AL/gUddOrtJmCZNq8mgo3uQdLMP+E6nLdRKjGPv0Lo2viF9p7iIdNfo5fD/j0D7hLCfZUHFqdspsf3WyLT88oXjdaZhNmraU46FJOlTZIMu+utW6gffSItT4fKp7p+cP/Eyxhe4zp8oL9bSvbONNJbgOHhlipSlxrRDnh7hYF8izVawnG9Vldaxg23oK7LKs02LE14RVSAfDucHnAjjsrxxSPkvLMBZKAr7oHv47dhWa7N4ePV0WJiFUwm7UGZ9P1ZYQ+ZXeHrWmyQUQidMebsrkR76koqjalAXa2nFKgSFLi2Mv8F+9Lae32kJdI5siZx+l+hKo/e1qbEigF5u+21hBUgSdf0B9FcoBUcmMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3672.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199021)(4744005)(2906002)(186003)(53546011)(6506007)(6512007)(31686004)(5660300002)(8676002)(82960400001)(8936002)(38100700002)(2616005)(54906003)(83380400001)(26005)(86362001)(6486002)(31696002)(41300700001)(316002)(4326008)(6666004)(66946007)(36756003)(66476007)(66556008)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjNBdHZhL1FhZXRiVGt5QXJkQzZLbnZORkNNZEd3WnZtcUdxZnAwRFZYTGto?=
 =?utf-8?B?T2xhMzdmWVJrcHluTTF3Skx0UC9mYnFhaHJ0NjY4ZGM0S09SeUZvWWRSSVRl?=
 =?utf-8?B?clBxdldGMlkrYkw5NU0zcGRGMUNpZ3FvRlU1dzMrRG9NQmk2N0htNkNwSThh?=
 =?utf-8?B?MXZMRnM5QTVRdGhDZXBEb0QzQlJxSFJxZm9NU3lSQnUxUmoyTk9IWlRGdHQ0?=
 =?utf-8?B?dGFja3Y1b00wTEtHWGJ0WmxwTlczRHVBUHl6dWlrcDFRQkErS1FaWVFMNCtZ?=
 =?utf-8?B?bm9vN3JRdlVvWUlLbnFCOXJ1UUVQOWNNQlJEelNKZ0FPcU9ld3AxaWhzQmVv?=
 =?utf-8?B?amtRQjBENU1SaXp5Z1YwNTRRQUx6emg5UlRuYmtFR0NPVTBYWVBLL3N3RkNY?=
 =?utf-8?B?dXZXS2NzeDlRMDhmcEgrVVpTeFI2ZG5NY1RnemFabVpHT0hETkl1Sk1uRDE3?=
 =?utf-8?B?ekhOMXN3SkozdmJxN0Q1aWQ4eG9RcC9LNlQzaGR3NVhKNVJYTDJuQTFaUjZU?=
 =?utf-8?B?Y3h4TWhCOXg3N2xQNGpHVkgzOUFmRFlkU0cvZFg2ckQ0USt6QTllWXBwbzll?=
 =?utf-8?B?b1dmdWtYdk1YY0N3SktXS3JPOUVvcWxXTTV4WlJaTTB0TEp2TTRTYWxrNkdl?=
 =?utf-8?B?VVVVb0ZkVmlVRE5vbXNXMURsTjZNQWVsdEI4QlR0Zlk5ZUdnQ0czeFFrZ3U2?=
 =?utf-8?B?U3UrV1FwVS9rVElManBEQVF5TEdiRXdKcFNBMThEODdFb0R5eGlreEJiQnNv?=
 =?utf-8?B?a2xpdXEvbGtHRENxUGpRZmQyUGpYUzVBZTdKMHZ5MzRZYUNTYjFjUzh5ZE9D?=
 =?utf-8?B?YTRzaTZvdHNNeGV0RFZNU3FUQ2RCWDh4V2YvTjk4bXAxRkRUNUpVWUtueFpm?=
 =?utf-8?B?Nk5yVjI3TmtjVURnUFE0OHdYVGV2OStwYnhaL1JKbXIwaDNSSWUzajBXd3hF?=
 =?utf-8?B?YjhrSXZIaFp1NFRpQXBvaWRrZVRFMjloZ2xSMFF3KzMyaHFiVElYSWoyVWdQ?=
 =?utf-8?B?SWRtbkJvMW9kL0dRWVl3M2tYdE5EU3hwaURSaDBlaGhrcEZwSGpaNVFkMnNN?=
 =?utf-8?B?b0hVNnRPdkNuTHpMVXVsUUc5V3NqMlhiWlpQeUpQVEVjQWt5NGdZN1NvSHQx?=
 =?utf-8?B?WFBTMWJnMThYcDVkNmUrLzBOeFp2dmpmVS9TbVdTbkQ2MU1BS0ZjVDJYcklY?=
 =?utf-8?B?cnBmWE94T1J2RHljelBSYkx3WVdRVU5sMUtaZGNCSjdIZFhHbUt0T0ZxOUdn?=
 =?utf-8?B?L1Nsa1BaaExZRGpxRFEyT3ozVG5pb0dDQ0hHZU5SQzRFRVBVcGxYc3g5OGlS?=
 =?utf-8?B?M1F4cGhoN2hKd0x1WHpCTURmaTlUbmNkTisyUzVJNjFJandvVXFvNE1xTWNF?=
 =?utf-8?B?aDFOMERySXRjZTVEMWlnbGdCSmlHbnRoeHBDcGhJVW5vT05MckZZT2lhdUZU?=
 =?utf-8?B?WnlzeEpvN2wzR0lyNmQvNVhheWRYVW81M0FxVDF5Mzdmd29mSm5iaTFQbUVx?=
 =?utf-8?B?Nm00NDIxVmtIRWNyVmwxd2xSNFZJRUVESUhmb0NKUlNzTi9oQUlzWWlETnVm?=
 =?utf-8?B?N2dENE1XQU5VMzlDYmQyMlN4b2oxVWEwYUZyU3R3Q2NJUGQrNEZQc1hEN0lE?=
 =?utf-8?B?bEhCRU45YzFPU3JVM0NHaFNrazJ1NXlvdGNzdE50SzNsOEpPQVkybWt5SEtr?=
 =?utf-8?B?cmVPS1JGZDlsaTZ2TUp1VHA2K2VycHNiblJzejlEUzNaSjI3NklQQU9OYjhE?=
 =?utf-8?B?UTViQ1R5UVZDMjlUb1R6UmVEVSthSmpwSXJtT2Fkak5DeVUxUEVnVXhaNzZE?=
 =?utf-8?B?ZWcrS2M3MldFQ2pJYkRpTHZPVDZTVFNMenI4UXgyRzVwckR0ZDByelJ3UUda?=
 =?utf-8?B?bWJpMEtuMlJyR3lpeGpJaXFqM1grbUJBNS9FcWg4QjNHWWpSMHRScnNKRmRq?=
 =?utf-8?B?aytKRjZaV05oSzhoZ2hEa0ljOXVvL1J5SU1oZWNPNWdyRng2T3I3bnBnR3pn?=
 =?utf-8?B?cmZ1M0dBNkJ6WDc2di84bXoyYUVHQndjRWN1QXZMVXhoaUpDa2FxemNJQXVJ?=
 =?utf-8?B?ajkvQWF5K2x2RzhISXowMU8wUnVRZ0FURTJoUCtkU0dLY0wycnRvVnM5RW5s?=
 =?utf-8?B?NUlXSElkdHd6TjdPUEVSYVZkSmpmeGkxWHVSR0lTOWFnMitFMDBHdWVqcEtD?=
 =?utf-8?B?bmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c99cd1-e763-4c9c-25fe-08db61588506
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3672.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 21:55:02.3612
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V95WZU6txqivCUXfvQK9gXDBlEyqFrz+dOKLSPZYOUjGW5k1+NXwUL33qZaX7DqhGSJyB65OYwpmCxe1EC8jleQbEYjo+OXOoJlENsUfOjE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5296
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 22:24, Tony Nguyen wrote:
> On 5/30/2023 4:25 AM, Przemek Kitszel wrote:
> 
> This wasn't received by IWL; you shouldn't be send sending to the 
> bounces address, please use intel-wired-lan@lists.osuosl.org
> 
> Thanks,
> Tony
> 
>> We all know they are redundant.
>>
>> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
>> Reviewed-by: Michal Wilczynski <michal.wilczynski@intel.com>
>> Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
> 

Oh, sorry, I had bad address copy-pasted into my bashrc, updated now.

Should I repost?

