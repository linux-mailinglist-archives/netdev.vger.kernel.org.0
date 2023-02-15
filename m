Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD0416973AC
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 02:33:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbjBOBdj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 20:33:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjBOBde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 20:33:34 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43C2531E3E
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 17:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676424812; x=1707960812;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+kLoJpuRD1wewl72Wk2GLZPd70I+Vg/3YGTbWdIbcLo=;
  b=aIzvmAbKDhQIWaprxVwa7yuadFOBNrf/i635UE01sj82n1PZ7opplE5q
   Omb+fO89lGBteRvuFv57OzQH0x/sAUjOplw82FkQtAJqyzqJHHiWaUAVP
   CSsCT4opSvo9f0vg//al1vIHcCWjPZluaZya44GRZA8BiXf1hk9734q6V
   +gFopuKXBxzV9Aq39WEzorZVGYT3y2Nll9JSMyLZ5wy+PSLZXBi5E/M6Z
   EocNhSUsWfym6KQiWBxyLjdPqu31SBFoeMHbUlGLczTiqOnHQzAPY0dKt
   MmLTf++diqfm5k0Y8PUpi427IsYFn7JM1a45721YdXuLqA2eitrWMrvMk
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="331323612"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="331323612"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 17:33:31 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="914963610"
X-IronPort-AV: E=Sophos;i="5.97,298,1669104000"; 
   d="scan'208";a="914963610"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga006.fm.intel.com with ESMTP; 14 Feb 2023 17:33:31 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 17:33:31 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 17:33:30 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 17:33:30 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 17:33:30 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j9HVCLvS8DK+W+8TTe+wINXaDu8QODaqOCKMwA2WNHQdUEuV3O+Pklks+HlIWTEWNEmMNO1uRoRg0uvyZKtnvcNeatx21nH5zqjRmzb8YTFxKdP0HcCb7PKn+BBJn7+H3OK/tK2eKG04M3YSbWXbBfzwxq8hb2KhIxn4yjlzAbYup4si8WRm1j4Th7srmmlk8nqS4PjiMi7S3XSnyiAF5IwIhz9HC6XMocYQSOm4wcU1R7B6/0yCsuXInQrEjVNpMyxr5YE2zPJnLnQhNdyicjO08sASw5/rDRsM6Th7zpkgPg4oMyhh1AdX7i3/g2ycrszkqZYp/Ki+hgSv2lsF8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FH/9crGOigWqX4oTXuFbeZwpHgpsS/4V+35JSlEV2t4=;
 b=l+IZRT23vkwyDsdfwEJ9bJcUGGjwfMeePx7jgfqwUswGFiNPLZzzfb0eiPUYxGp2VqvVsBWCbxxZ11Ha70gH0ZH/+wNKD96FvV6qpt2hZ9DGdn5N5hwOdzFEZMlH46bzck3jwTyfCUmChEpptL6NnR+ylycXCKrcKbSxJvDgF3un8zDcXER9eStcObltgmvEY+THc4bw3REva4lpPbdecmykfyAtSHfUh4A/Kk+2I6LXIM/+TPlC9uqTMcPfIBT9H6HEJMcwlYhwQOax+nq5ZHNrC0+lJ+NMLKjWTe9bSZFbLnwdL4oyRNjP1V0scWQdC+HUSn0lQ3mt4+yTUOleog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DS0PR11MB7998.namprd11.prod.outlook.com (2603:10b6:8:126::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 15 Feb
 2023 01:33:28 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 01:33:28 +0000
Message-ID: <ac41759b-29d1-acfd-7165-96bbac1840c7@intel.com>
Date:   Tue, 14 Feb 2023 17:33:25 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 0/5][pull request] add v2 FW logging for ice
 driver
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        <davem@davemloft.net>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <jiri@nvidia.com>, <idosch@idosch.org>
References: <20230209190702.3638688-1-anthony.l.nguyen@intel.com>
 <20230210202358.6a2e890b@kernel.org>
 <319b4a93-bdaf-e619-b7ae-2293b2df0cca@intel.com>
 <20230213164034.406c921d@kernel.org>
 <bb0d1ef5-3045-919b-adb9-017c86c862ec@intel.com>
 <6198f4e4-51ac-a71a-ba20-b452e42a7b42@intel.com>
 <20230214151910.419d72cf@kernel.org>
 <8098982f-1488-8da2-3db1-27eecf9741ce@intel.com>
 <20230214171643.10f1590f@kernel.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
In-Reply-To: <20230214171643.10f1590f@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR04CA0031.namprd04.prod.outlook.com
 (2603:10b6:a03:40::44) To CO1PR11MB5089.namprd11.prod.outlook.com
 (2603:10b6:303:9b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR11MB5089:EE_|DS0PR11MB7998:EE_
X-MS-Office365-Filtering-Correlation-Id: 74c1eaab-24e4-4ce3-4264-08db0ef4a348
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x/JND6KiFoSFDJmj6rffF/gpYIsP3b46xAn7//O0Y6ggICAskTYFA7IWWuPiIEMZAh58mL/8QEDD6wL3F14IfqdCdh+flake4TTwuR2XfmiHjF80S7CbGPuXAWGgTvn3V3SgPFLLW8inbHnO2SxZRgdfQQOC80+F+eo4f20/K/Q/uQhrrC4JtR6BRPCMvS8962DKqRQM2g+AVX+et2NhHlyK+z2Xd+qjPx56IPgPYq/K0N3o3CMOo/ZhImIkXB6yby4VHTdfJpw+lx1uKr7vcaUOcRrP5Ux/B480a/qiUhox1z2++invX/h8DwNQQkLhMBSVlRGRbprV2+qy4Hc37iXMcFsipFYFMKGCDCJQXtAoVFXCWUKQqfGL/PH4Ed8ZCli65cieF3xw7cEOqH1ZLpUqEibPZyHdP1fObS+S4SyMOjkf7+cGOeA+2xA/eRBK2J2p4EZ5usOp3VRp1+p2FlY2/7Ll0xLIZHdN5z+Skl/FqA/ZD1OiWMFywGZLaC2Fq/XBX0ZApNMdwlD/TRoATUDKyFspjWbC2fLFz/lO/OaIhyL3Q2VpVqnbLr+Rw+ct0iSB0Q6NMn/hndgRXnGycFTEcPhixRxXo/dRZX7sWEpFEGFoWG9wrZ9qfMvmdJNc3CH3f6Jkqls0bo5MBQ6f/0yarqpFFGgBqcC0ebUnPbXfat12n4IEpiweOqNiNh3WByfM5e2CBXgc8lxNLP/oI+jvPJakDuFOp4r8FORIb3I=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(136003)(346002)(39860400002)(396003)(451199018)(6666004)(478600001)(2616005)(6512007)(186003)(6486002)(6506007)(36756003)(26005)(41300700001)(4326008)(82960400001)(38100700002)(8676002)(8936002)(83380400001)(66946007)(6916009)(66476007)(316002)(53546011)(31686004)(66556008)(54906003)(5660300002)(2906002)(31696002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dnYxUDY3UEhtQ1VtRFE0NVBjWElqS3pZNW8wQ2diT0tSNUhQdlN0NjBJRnRR?=
 =?utf-8?B?QzFZL2s2OE1iQldaVzh3N2RWQkJkeGhMRE9wbHRZaFgzL0NESDQvOVdaZFpF?=
 =?utf-8?B?Y0tpUFNFbWZCc05LSTVJRDJQb096QlBXQ0pkY2dEUHpJTHpYN3dqWlFRQ3kz?=
 =?utf-8?B?dk1EOUNGeUk5VVRaMmhJd0MvOHFrOEVQYmt5Wm45V3NoZm5icm1TSldoMTdO?=
 =?utf-8?B?T3JRbmJQaVVkQ1FOdmJVUkxzWXRQc2VGTHZsOUh2Tkk5cjg4TjFRNk1qQUFs?=
 =?utf-8?B?akFGTFVVdFRFUWNmTUFvT1pVL0UxYUdzT1VNSzJGanNySnlLa0ZmVnoyQW1F?=
 =?utf-8?B?YmlaSlA3UlRyN1JkM0YzZFpiNU1FMFRyUjIrSldObjJRc1gzNmtXOXE1a3NP?=
 =?utf-8?B?Z2pzckhNMXBHVW9xMDczeVN5dDlHR2xkU1JCN2cyMlU1ekd4K0gxdkRhbTRl?=
 =?utf-8?B?RUxGc3NXcWladXdrYmNuZDRDeW8xSWR4ejdGYWgrOFNQN1ZlUXNMRlRRYldj?=
 =?utf-8?B?aUhRZkpLQXFjZGZDa2gybWswRjYrN251TzFFUVljaU5VWUUwTy9Ga091aUtl?=
 =?utf-8?B?TjlFYVJpRHgvSjBtRjB6US9GR0J3Vit1aHgrQklvWUpKQ2Nxa1laY1VPaDZk?=
 =?utf-8?B?dExjWE1kSW8zSXI0TWIwcWZ6N2VKUUJPNXA3L0NPOFhYU05ZMldPZ2pmU1pK?=
 =?utf-8?B?VC9tODVaT2xTQkpIY1d0N1JGYStIUDdLSFVqTVVyeEtEVGtZS0tjZVkxMzE0?=
 =?utf-8?B?M0VKQ1RiU0dYZFR5WTR2d0JmRWtNd1U4Z0hBM0JkTEIySjVBTW56RjV5VDZi?=
 =?utf-8?B?ZEoyVldKV2pXK0hzTGlIUlNYYkpiVzBNN0ZibnRWb204QUZMOVl1Nm4yVHVP?=
 =?utf-8?B?WXFidDd2K0tqdnNoeXZSVW5aQXB1RkpMaTBRWEtQM2l1YnJxUDF4andXOHdK?=
 =?utf-8?B?NHRiNnJiQnA3aUs4dTJhM2tHTU9WOUhFemVaQnVHZ28wQUZWdVk0WGpUTUhI?=
 =?utf-8?B?Q1FlODVpS3ZxV213RTdUVm0rcU9XMlJENzJMVGxvaUYwbXdteUJsNzd1bHlU?=
 =?utf-8?B?U0ZsSmFtc3kvbTZlNnNSWmY1S2Y1LzUrTkplZWJ1ckk5WWNMR0FQeVBPODg4?=
 =?utf-8?B?a1o4bTBKdGlDNStncWM4REUzakdzRm55NjVQU3lMRk1YQkZ3UlVzKzRiYlE4?=
 =?utf-8?B?UWZ0dnQ5bHI4NVp2NEdXZ2x1KzlUb1BLeExxQjBMSllRRFlwUXFwUGJIdXRv?=
 =?utf-8?B?bEFWaDhWZ3hRUWI2RndUNS9USzRRb0NJdFlGM2RWeDJvSUoxaGNoRnVsUTNG?=
 =?utf-8?B?R0FLRXArTHdMSWk1cHdIN3o2TENyR2czVUtIRDhaMEpiL1VZcTExOEd3R0Y5?=
 =?utf-8?B?OVIzeUczbDQ4NzB6NllvUWRWV0xkMm9nUU1obTRDSldBaDE4d0xpSUgybVFP?=
 =?utf-8?B?bXRqS2NiSnRLbzRYM2xFY0UvOVA5VmFWd2g5enIvdUdBSlBNRjlkQTZkWUJR?=
 =?utf-8?B?Q3YyUzZKOUg0ZGpZZEhKcHI4QkxsWnJoRU5tUnBkZ05DTW1DMXRXRzBVOGNE?=
 =?utf-8?B?bVBoYzFvakpkeHV3V1RNMjRTcWhURGJCRkFJVHJaRmlVZ1JyNjJMV2Zib1NZ?=
 =?utf-8?B?TVpScUs0RUV3eFVHa3BvTXcyL0ZyWUdzNzY3VVYzR3VkQXQxZWIyWFZCQnBp?=
 =?utf-8?B?d1FrS0JwWU9kM0gwL1VCQ0Y1eVpuTTNYdCtWb0d5bCt0N2E5NlFGanBvaXo5?=
 =?utf-8?B?R0txck82Y2lxcUJ3YnF6a1pmeWtJTzFTQUhnem1GbEZoNllNdDlLdVIyOGYy?=
 =?utf-8?B?b3ZBMnh0cVNST0thdnZjRzRtdTNaTktEVGlvZDJLcGkwajJkdHppQ25mcmZE?=
 =?utf-8?B?RUhiUVJJZ2tRSUd1WXluMjlsTS9aVFE4T0dLQ3BMbDVUV3puTGcyU05kbUpC?=
 =?utf-8?B?dWxxRldwTi9HdnhFWjRQdmg4T1V2UWY1VUZDUVEwVGJGQUc5WW1ia01pc05j?=
 =?utf-8?B?WEZPMW1Nc2krK0ltYkVqb21vdDAycnlpK0N4MCtmUk5UWC9YbTdzUHVZRjNp?=
 =?utf-8?B?UHZPYnJ5VjMza3dPcTQyVm03SlduOFFnSXJMRUpIanFaU2Z4eUlITjdTakRS?=
 =?utf-8?B?TmlJK0hKMDVWTVk0em5VdEd3TUhidElpR3BKcithdllBMWFtUUNJcUJkVThn?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 74c1eaab-24e4-4ce3-4264-08db0ef4a348
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 01:33:28.1527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: on52cSCcIHc0R2OSy2OFtHanywYS11wdNay5L90j3/r7JOip/Bw1v+X1dDXoIYOC8tG61XGGcHkritvkHR2Dz71S8JUHSfx7M+OrVoBW6v0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7998
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/14/2023 5:16 PM, Jakub Kicinski wrote:
> On Tue, 14 Feb 2023 16:07:04 -0800 Jacob Keller wrote:
>>>> 2b) add some firmware logging specific knobs as a "build on top of
>>>> health reporters" or by creating a separate firmware logging bit that
>>>> ties into a reporter. These knows would be how to set level, etc.  
>>>
>>> Right, the level setting is the part that I'm the least sure of.
>>> That sounds like something more fitting to ethtool dumps.
>>
>> I don't feel like this fits into ethtool at all as its not network
>> specific and tying it to a netdev feels weird.
> 
> Yes, I know, all NICs are generic IO devices now. While the only
> example of what can go wrong we heard so far is a link flap...
> 
> Reimplementing a similar API in devlink with a backward compat
> is definitely an option.
> 

Sure. Well the interface is more of a way for firmware team to get
debugging information out of the firmware. Its sort of like a "print"
debugging, where information about the state of firmware during
different activities can be recorded.

The idea is that when a problem is detected by a user, they can enable
firmware logging to capture this data and then that can aid us in
determining what really went wrong.

It isn't a "we detected a problem" interface. It's a "here's a bunch of
debugging logging you asked for!" interface.

>> I believe when a firmware dev adds a log message they choose an
>> appropriate section and log level for when it should be reported.
>>
>> This makes me think the right approach is to add a new "devlink fwlog"
>> section entirely where we can define its semantics. It doesn't quite
>> line up with the current intention of health reporters.
>>
>> We also considered some sort of extension to devlink regions, where each
>> new batch of messages from firmware would be a new snapshot.
>>
>> Again this still requires some form of controls for whether to enable
>> logging, how many snapshots to store, how to discard old snapshots if we
>> run out of space, and what modules and log levels to enable.
> 
> Yeah, it doesn't fit into health or regions if there's no signal on 
> when things go wrong. If ethtool set_dump / get_dump doesn't fit a new
> command may be better.

I am not sure how ETHTOOL_SET_DUMP works for configuring the settings of
what modules to enable or what log level. I guess it has "@flag" which
would be the settings. This is u32 which might not be enough information
to specify the log level and the module config. It also doesn't expose
those values to allow users to actually understand what they're
configuring on or off.

It does look like it would work for this patch set via the following flow:

ETHTOOL_SET_DUMP -> enable dumping with the appropriate flags (driver
defined...)

Once activated, the driver would then capture and store data as we do
now, and user space could retrieve it via ETHTOOL_GET_DUMP_FLAG and
ETHTOOL_GET_DUMP_DATA

But this doesn't really help solve the problem of how to expose the
module and log levels. Are we accepting just a binary flags that are
driver specific?
