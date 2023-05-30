Return-Path: <netdev+bounces-6583-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F98D717072
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:10:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A9C11281247
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:10:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEA0D31F16;
	Tue, 30 May 2023 22:10:33 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E3B200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:10:33 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB0CEC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:10:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685484629; x=1717020629;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bq+XbJ2C4XQ5sI0bLo4RkNkdxPUfSN5KgsD3AR36fHY=;
  b=VVNIBAVNqj2p8vu5oQtumtDV8dSnMIg2T3udE4rILt4ZgidX2J2Rfytl
   SUNx4zpFKExNVUfituiohzScBAoPCJYDNsEZUHliWMICcRV0+uqB3VZkm
   77z8Rl99fIjm1Gzdo/FHZmejB9F/5UPG8hQpUi7Gd8mDzXAUeN/lIVgV5
   AmBuGJSLzd/MXrmzkzak21mMSdRuWvKvNktCxzdxNnNhMpYpSwllOcWGp
   hMIyc9A4nE7mzM+Stu7OZtsQXp3MZiv8Kcouv751VJoVQQcJzR3HsgjnU
   78rb4xO9RptMe2TZbqcmXSI2ekYkiKLIpfb36zjGJy2Eiq3BEhUASRCj/
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="335409496"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="335409496"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2023 15:10:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="830939378"
X-IronPort-AV: E=Sophos;i="6.00,205,1681196400"; 
   d="scan'208";a="830939378"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga004.jf.intel.com with ESMTP; 30 May 2023 15:10:28 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 30 May 2023 15:10:27 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 30 May 2023 15:10:27 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 30 May 2023 15:10:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z0pNSQ0uAAp9KD+Jr89WbuBBfrleZ1yjY1F/UyE94jiP5n4keIroFAyU8SJ9LoQuRczSZ3+30EkBW871g0jTBS1dGG3FbNvN2wD4AgDb0ddu11oSC1zaHOga0C6JYsvDvX/V+4STZO9xb2B8PxOIuikjAoqzRRzE6wyY2fKAzvBJAD0f0gxdPyvkrWkH4B40f9ZCNbaeKO8teJ9RZrZ5hZkFUwsgB3zbDJb8Ijodhvug5+bIptQXeUAywoP2BGWWcKygYfV5Yo2B1Yi6MUQNYUkcjKHzwAs1vKWkXPBIg+FWMdg4F3i7+4f1SdDe5v5c/OYmEv+zYmQF9+fYYHr93Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HK9oTFTjDYlgmkxTrILsgg0MUeojcicr5oh7k6ZVQB0=;
 b=UiMn7UHlCH0iIeqzQgwapmiRRnm4masuDL4Nby8gbecXVYObWTjPIIFBPEhy8oicrJIESogYIsd8uBiVoXGCJNhcq8jGJn1unD5UbwjjaDwge4ZBMJvQsbOQixZPCeWudow2/hORE/YCc/fYkN3Z5xuNJujz0ssrA3SKweRX8tboNaJlc5mDaH3wkwmoelkNmQK2Y2cricLiK6/UWoWWD0vII4OjlqbQT4lUDUgRrGVALPhkoRFSilCU1rtXPODoXIjBQEJu6U49cb4h3u8Ef2KPuCohM2lYR4Q1E0U5ueooIdjIrbsyextPGAe4cv86FgJhAKDODs8ilp2+dzyCgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by CY5PR11MB6259.namprd11.prod.outlook.com (2603:10b6:930:24::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 22:10:26 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::bdec:3ca4:b5e1:2b84%7]) with mapi id 15.20.6433.020; Tue, 30 May 2023
 22:10:26 +0000
Message-ID: <dc877c61-a8d8-af1e-41d5-35b8329aacdf@intel.com>
Date: Tue, 30 May 2023 15:10:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH iwl-next] ice: remove null checks before devm_kfree()
 calls
To: Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	<intel-wired-lan-bounces@osuosl.org>
CC: Jesse Brandeburg <jesse.brandeburg@intel.com>, Anirudh Venkataramanan
	<anirudh.venkataramanan@intel.com>, Victor Raj <victor.raj@intel.com>,
	"Michal Swiatkowski" <michal.swiatkowski@linux.intel.com>, Jacob Keller
	<jacob.e.keller@intel.com>, Martyna Szapar-Mudlaw
	<martyna.szapar-mudlaw@linux.intel.com>, Michal Wilczynski
	<michal.wilczynski@intel.com>, <netdev@vger.kernel.org>
References: <20230530112549.20916-1-przemyslaw.kitszel@intel.com>
 <8a60b531-09b2-2df4-a7bb-02e3a98e7591@intel.com>
 <ebcaf661-a6c3-518e-bbd0-f4c65b83056f@intel.com>
Content-Language: en-US
From: Tony Nguyen <anthony.l.nguyen@intel.com>
In-Reply-To: <ebcaf661-a6c3-518e-bbd0-f4c65b83056f@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0163.namprd13.prod.outlook.com
 (2603:10b6:a03:2c7::18) To SN6PR11MB3229.namprd11.prod.outlook.com
 (2603:10b6:805:ba::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR11MB3229:EE_|CY5PR11MB6259:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b80aeae-1bee-4161-39fb-08db615aab75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: viD3yBkpepTSA7LkfkDn2NYRD71jVdhbiULgnzfOYeh719lAJUQ9ys1dnnNqMCv1l+RpiE0RHK3+1Ab4o+Qt1ld/aW1AVQ7RHCXbHJYcJwEV9NOyvQD89YYX8WQvpeunFpxzlhUP1uxAHsznEbpd981ngH+xtsy9dfsZJAyF/iNEHsMCpPShVdemE4ZqOGIgs4uHBkIZ3Tme9uSfWBstEX0BuPnVStadO5F4ft8rf6T+3s3BoxCw74DpjmRmTAgL385LYmpdMyPARamBrm03FiOiiUokCYLkepkO1+OnkHfMjIpk7AcdVEIwiU3z2ELiFQnbMZI3NeE60Kw9e/Faxkf7MDYLVyAqfV6jAswfvdwVPS/76oHUBh71D9gTz6/nFAnYKFddeE+7YaWfxhlPRND8FbsN+W1MX+HmmQga0yy0OQF7xE0W0+4loIytOdPSfa/Au+S7vLZ1baqHA+7TA5NsVoWuO3rGgShJahv5pMENEX83OP+Hwhr3t94hTdjTLSNxlvd9X+Wvl20uVE+n6B0dP7dS2AKWK6BnXe262Lf9UyFhNkMZr/vf9f0fmeBsnW+Q95PWy5WpqliF6rj+gY3tz/oPrtRRGHuOdP4gSEo3Jb5EEso7w+I8/wB9FmcyP7D3J3ICweF+RuY59Pz/AQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199021)(2616005)(186003)(38100700002)(83380400001)(41300700001)(31686004)(6486002)(6506007)(6666004)(26005)(6512007)(478600001)(54906003)(66556008)(66476007)(66946007)(4326008)(82960400001)(316002)(8676002)(8936002)(5660300002)(4744005)(2906002)(36756003)(31696002)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cTNoMCtIMzlvaWNlSXJtUXJWUktqR25yWUZDSVhjb3RkL2Ric3Qra0VwczBO?=
 =?utf-8?B?ZU9TWDRnc2ZjbUJJUDEwVGdqbFJzSjZqZEJBUEpWdys4TVZsMjM2NzdLYUpk?=
 =?utf-8?B?MnV5RGw3Y29pNXNUQzZSRkJXQTBNSTdGUytzUDRQQ0taRmxMWE5aUndLUmRp?=
 =?utf-8?B?OEt2ZnI2bHZDc21QL3U3d2U0QndGTGt3aythUjVSbWVHcUQ3NU12dlpOMDN1?=
 =?utf-8?B?ZFdWYzZ2S0I1bE5JMTAwbkh5Y09zY0VGQmNiVUY1a29HTCs3V3plVThxZ2tW?=
 =?utf-8?B?U2F5ampFaERLUnEzR0ZocUV4SlBnRUwvcWNTV3NrREVEY3RiWm9iVkdSL24v?=
 =?utf-8?B?REU2Vkh4RTRTVHFPMXlBZ2NhRXF1VkJnU3VKYmxkd3RkUG5iSGRwNVQrQWtz?=
 =?utf-8?B?elhnM2dWTG1NUy8vWjczT3JRd3VOY2FzV2ZvM2FPdGFPLzFoN1FJcUd1VnRq?=
 =?utf-8?B?V1VhTkw0UFJVeFJoZzRIc1F4a0svR1lTZGFpSkFFcFBwK0tERkppMDdsOWpk?=
 =?utf-8?B?WnNQWWtPYThLMXdDOFF1UXlPc0pxUG1zZk9zK20xdjN5dGk3bmxjVmVieDFT?=
 =?utf-8?B?bXFmclAvM2tGT2xITzM5R3ZMNzNiQ0lmSjhKcHRNbXI0aHppM1p1VlJ3V0kv?=
 =?utf-8?B?R2ZaMlFHTkNOdU5IMkNmMXN5cDZ5NWNlcEZ4RFpQYUtYWmJmdUw4TzdLMjlm?=
 =?utf-8?B?WjRWUGhEendqS2tyWkVnWjFKdVpzbG1VUU9NVjFpVmUwZzcrVDA3WG5YVk1U?=
 =?utf-8?B?SktUeUZaY1hqb2hCUkhvUEdDeHBEY0xSZWdVVzJ1TGlCUkxMNXdWME55Yms2?=
 =?utf-8?B?UWpHQTFYL1FtTXEzUDN3MitBR0NVdEZlUnR4T1RjN0lHWjJnWmRWOXM3clV6?=
 =?utf-8?B?OENqU2ZpZVdDSjEyTEhmVW16UUVyT21HU3ZIVHdpbmtTeEtNWXF5NnJzQjRh?=
 =?utf-8?B?Tk5xaWZrNkpKMGdlWW5mNWwxM2dVdHhaZDU5eHlxNzJkazFVeVR5UXJNeUU0?=
 =?utf-8?B?eHYvM0VVN002M21ndkRxa2NjZiswQTZXcC9YczJlNmpiMm5XUlRmU0t6S2lu?=
 =?utf-8?B?ZVgzMWtIRGtrZHZMVkRHcEc1S0p2Unh3YXg5bTEwdENSak5Ua0lLYk1sQWVV?=
 =?utf-8?B?OHkxaytKZXQzU3N1WTl3NXFGUithVG1OeVFVNHdaQlRETmE3WGNPRmFkNVNk?=
 =?utf-8?B?L01zOCt0YTVvKy9DMEVPNzI2NFhQYkV3Q3hOY29LZDVtZ0N6MzJHelh5MXV2?=
 =?utf-8?B?RnRna0cyMDZoZkVwdFRWUmowNDNKM1ByVTlmd291NS9qcWp4NUZrVElyRWdD?=
 =?utf-8?B?dlEzb3o0LzNvUEdYVnVlMWQvR3lxT3IvWXRUYUhRTXhLVTR1ODJnMC9RdkZR?=
 =?utf-8?B?L2hFTVNoWnBISU9veUs5cEl6djdqdGFhT05LdThGcHFYMlF5OHI5cW9OUjZQ?=
 =?utf-8?B?TGxpd0pHTUFuZGdBeGIxK0NGbzRibmpQM2J2MUcyOTBRNHgrWDJNMTV0Yndy?=
 =?utf-8?B?eVRIZ0h2VEcxRkFMSnlTQVNpSEk2amljSGpOZGpQTU5WaGxwSWdXendRQ1do?=
 =?utf-8?B?UkhKSEhGOTROMGZsaUdiOUxMeGZla0tLVndkOG9FcS9ZdXFTM3ZGZnZDVzla?=
 =?utf-8?B?OUJmUXM0M2tvdHgxdDBFZDRyNFhVVS9SUnJucjlEQkNhTjhBK2FDSCtkU2xZ?=
 =?utf-8?B?aVJCVzIrRzM0RUdnV1EzTTR4THRxQ24wa0hlZi9ZVXpTcSt1YlBVbHpkQWlP?=
 =?utf-8?B?Uk1JREZpNEZZSVJzbDZTZzNXQUZOeDNjR2JqOEpxbWNsNDdpYWwxeEh6V2RL?=
 =?utf-8?B?OUFMUEEwNlNyMVlnT0FCb0g2Wk9rNmllSHVLaWs1cWttMzMxRU03emF0Yjdp?=
 =?utf-8?B?ZGR5bVkxd1J5b2dXcmJ6OXJIZmJZbUVOYk8rVytGRE5iQkRrK3B5aE9tRHZZ?=
 =?utf-8?B?bHdKNlhCc0ZMcDFqR1VLZTIyYmN1QklFM0ozMGRxT3NGZzhjajVwT2M1UlpZ?=
 =?utf-8?B?bGFzelBDQzByK21TWmlYclpUZDVRWWlYRUs4VVZUeVhPN3N4TVBlc1Jpa21h?=
 =?utf-8?B?cElIWDNnaFdXSTJrOW5CNlhSQms1aStMcEluazJxVDV3L21XN2dhQmFwTlNl?=
 =?utf-8?B?YS9hU1FNNGlyUG9ZczN3R1V1cTdyNXdTc1NoSzZFR3B0S2FyTStWV2wyZTlT?=
 =?utf-8?B?cmc9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b80aeae-1bee-4161-39fb-08db615aab75
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 22:10:25.7833
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kBjThRbFeqjNWtSnqsftgm1uQ440TSDrDuy1/HlLa9WVesTaCjgNuBScWJKK/srLlBitfA91t6IuSXsspA31IE5Qi6bJ16zZ9qsYsAI0AyE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR11MB6259
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/2023 2:54 PM, Przemek Kitszel wrote:>
> Oh, sorry, I had bad address copy-pasted into my bashrc, updated now.
> 
> Should I repost?

Yes please as IWL patchworks hasn't picked this up. However, since it 
did make it to netdev, I'd recommend waiting the 24 hours for any 
feedback from there.

Thanks,
Tony

