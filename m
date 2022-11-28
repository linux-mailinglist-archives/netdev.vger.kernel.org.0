Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99D4163A568
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:51:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiK1JvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:51:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiK1JvN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:51:13 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04EC8192AE
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669629073; x=1701165073;
  h=message-id:date:subject:to:cc:references:from:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zDxur/ilwCCaFjrTiuPXcyZF08oW/MIS06de/T4zge0=;
  b=I/NOirNUZ9Jq819mi6NXXrYhpuohG2TuJgsBkZS2NMaI6GUlNGlWY1xo
   Geg7OPCyn368NjFvaWpRpW8lxlgjlk5ULKt3LAAW9uQ/Fs0OMeD239H0q
   jbkCSgHjjaug5c5lOWS69Q/H43AVSBaFl9Zrz3RXsSderIuyTJL+PLysy
   rKGwyXW0L6ILcbniQrDYhIAsRKKYbu4u2bPlxp71RnqrAvIIQ5Iqg5kt/
   ur43ebZvcC/J6QYbqMbvydF21lAPMZy8eOfDWDPmInvk56IDN8QhD0c09
   9wV/gRwAUIpPG/irbGad1poo6AXccG0V5LLQ9B5jYhaEdNsU4JSUtjzcl
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="315948744"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="315948744"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2022 01:51:12 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10544"; a="888354896"
X-IronPort-AV: E=Sophos;i="5.96,200,1665471600"; 
   d="scan'208";a="888354896"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 28 Nov 2022 01:51:12 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:51:11 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 28 Nov 2022 01:51:10 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 28 Nov 2022 01:51:10 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.169)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 28 Nov 2022 01:51:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l994nZt+5Vv78wfBVcuz/ZpqwUD70RMeS8H7kX4TgCmwZ0skhPmmjt6G2a82qfCSUB/2meJz0ZTvUF20X23RhqBuYKQoFha8JUlO2VAjV9H6D9OoLRir/2psENVTm1gIkAFjlGKp5jZkwWjKNm0hJwzCyed1Z5opwDjEK61jALQKEqfzqGVWKOdPOc1vw3q0YXcU0sdW2VsJunBJ+wEO8lBzfAQkgFej/9gz7UaOsxK/Lry4Fe1K9gU/Q+hNxuvhHmOudZKRB+thyVfQ46IP/IoEJ0IlFtf6Ct3+m1U8AN0gMFRuC3fapm4urGreuoKfHmW6KFnn3hynbrSIZDP/og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IBUYUy0lH8D+/DXvayKDo6bNDeXdo4PFoGIzwcJfiyw=;
 b=WBnESaZ3J9UUAm+zKsYt2CdbQAt+75V+jSkU+slul3bnLxGlP42PdyyCFXO6AvUCc3SCbcWiZyQxB5HVn/1GvnneGU/jZ7dZ3tV0pilHInFZuQ8wtAfucxoKmbMfoW6v1g0ZVRg9HfBboZuERiuarC9DFZLLfwzgaeuZ25jbelazWC1M1Y5h/asoEo/C5vjSOmCm2+lOKd0OMwbgG7SASyU/ZMvlAcNQI7ERjWKe++m7kxC8J1PRfnH1kOtLVR2DqZWo0B03uILtW9+k+eYeriwOuLZvNIo4o5eVTe7YA3ymcrHvYU+syfAZR+kif8viHK/0XHj3n/3CaEW+9ccKCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from CO6PR11MB5603.namprd11.prod.outlook.com (2603:10b6:5:35c::12)
 by MN2PR11MB4728.namprd11.prod.outlook.com (2603:10b6:208:261::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Mon, 28 Nov
 2022 09:51:08 +0000
Received: from CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::57ba:a303:f12f:95e9]) by CO6PR11MB5603.namprd11.prod.outlook.com
 ([fe80::57ba:a303:f12f:95e9%3]) with mapi id 15.20.5857.023; Mon, 28 Nov 2022
 09:51:07 +0000
Message-ID: <1ef2766b-10d8-344b-da1d-c8ddc5a9023e@intel.com>
Date:   Mon, 28 Nov 2022 10:51:01 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH iproute2-next 1/5] devlink: Fix setting parent for 'rate
 add'
Content-Language: en-US
To:     David Ahern <dsahern@gmail.com>, <netdev@vger.kernel.org>
CC:     <alexandr.lobakin@intel.com>, <przemyslaw.kitszel@intel.com>,
        <jiri@resnulli.us>, <wojciech.drewek@intel.com>,
        <stephen@networkplumber.org>
References: <20221125123421.36297-1-michal.wilczynski@intel.com>
 <20221125123421.36297-2-michal.wilczynski@intel.com>
 <0f75a656-97f8-5f90-ab86-258fadc7ae63@gmail.com>
From:   "Wilczynski, Michal" <michal.wilczynski@intel.com>
In-Reply-To: <0f75a656-97f8-5f90-ab86-258fadc7ae63@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR3P281CA0144.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:95::15) To CO6PR11MB5603.namprd11.prod.outlook.com
 (2603:10b6:5:35c::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR11MB5603:EE_|MN2PR11MB4728:EE_
X-MS-Office365-Filtering-Correlation-Id: 24b53753-c4a5-46b5-8164-08dad126127e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gXwubbwYfB4Uv2c6a3zXrdoTv1TzaEfaQkMu8MYoU4GhfqNOb1N9H1MSFDaNxlL9bOycJ0V5npDVrc6t6R+jYRyG5ExTjiLg0Rzuol6SGF8rOxTgkNRBmZKWcjVu1fwVzV9rl95ooaU2UCNyBRsQd2cCIAuBCIcVmeMl5Sny6qN7ntHGZGUQmb4dMMh9stYUI34ie4LxgQjgFvyLUzQn8nBhHadzzMKhIgM4iKqEt+Am4TN3/yObcC7bl70rh0/2xFX5QFiq3Jq2qcl3IMoQLASJAJ4k/7p7k9f+sr9Lwy90udsJbmcImw6Owshmk3kREK25SZ0yk2tr47rUAdR5VTfMIUtFbeawpdfedvfAPoiWfdwziy5uya5QnzQ3+v3HWJQJsQuKgu5xH3y3FaR7xZ86Po3tdvkuy3IERDNTrFK9CmyYYu37cwg9WpyJkp6ykmRBbXHTU1wM9SgW0h1VHhwCSiJcUcXdH4BNz6aDFzf7M7qKUUgpIf6ba4t2x9yWlhgmxCXQFm8DGE9ezYceq4TESnSAmUbUwKtUmjYTJiVAyHsqN9t8psuV0Tste4ISiNZB2iBdT7NOQltZcGwG8NC2TdW+non6gpFnDVdKgtiuqxQoMUPj6LXXcFwWut7SF4/j/NFyMto29g998HotW9ZAww7AtuYBeGvjJ/C/9Hyoz5pHdMCbaVMUbTyZMyLpDBlmzC8pwKnxa1wTKxhMkc4+tqt9PQhxvP7I5a8m928=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5603.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(346002)(366004)(376002)(451199015)(83380400001)(86362001)(31696002)(82960400001)(2906002)(38100700002)(41300700001)(5660300002)(8936002)(4326008)(6506007)(53546011)(6512007)(6666004)(26005)(186003)(316002)(2616005)(66476007)(66556008)(66946007)(8676002)(6486002)(478600001)(36756003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SHV3Q0twRE8zV0ppVy9oMUphdXVQMEROQ3RXOWhFLzJoWjRteEo1cktEbnQv?=
 =?utf-8?B?Ky82WUZzamxVS0pOWGMxeG5xM1plbnZUN2dzT0NmVGJ6R0FSSU5pbG5raWww?=
 =?utf-8?B?SllOM0Qwc1BaZFpEdFNWTVU4VXZJaHQzb1BieW53TzFBWVMzTTFrOWFoY3BP?=
 =?utf-8?B?ZmlkU3NkOVd1Um00eTBET085YVZLNTd1SVhETndNZFh4WmFwd2dES2hIMVlm?=
 =?utf-8?B?eTVxNkNjb1N0Sm5ibEpRZFFQMnVRRnU0YkNwbDRtQWppUjJYMStqenVITHli?=
 =?utf-8?B?L0VvZ2lFckZFNnFaYVFwTE0zeitMTGxndGhLM3JSTVFKTFV1cWpIdEEydGNw?=
 =?utf-8?B?b3VUSkNTb21Ic2l1cWkyamltUEFiQ1ZSSnUvRCtveXBnMzl2WHRzOFlNRk1Q?=
 =?utf-8?B?T0FaSEwvTTNHNFNGZlkxS2RncFNyYUw2ZXl2YW85ZGdmV2p5YmNaS2wyamdJ?=
 =?utf-8?B?YUhRSG1nbzk3M2ZWNW9ITXBscEZBZlFqZ281YzlDbkIyQjhDQ283NkZtOWh4?=
 =?utf-8?B?c0U2VSthamRQVUFyVDdza2dmNUROc1QyKzZHWlprRWo3WFR4Y2FZVE5VdWs3?=
 =?utf-8?B?VUJwYkJnY242dng2d0lVdTYvVTdEVU04L2xBSXBpaHNHWmRBd3lWeDRJaTBN?=
 =?utf-8?B?azA0WWF1UVZJTWw5dzcraG5Sd1lmTTVzbHl3Qitna2lFUVF6K2lBYmlNRHZB?=
 =?utf-8?B?d1R1dG5qODQxcVY3YkpmaUk1TlE0bGtpYzY3QUdkR04wQ2hkcHhJTVNTWGJh?=
 =?utf-8?B?NE95ZERBNnpYdlJxaXkvU0NPelVhZ3N2cnRwVDV0ZWw4MkgwdzJzcnNmOFRu?=
 =?utf-8?B?V1lFdHlERDZlMFFVbjduOURnRTRrc3BzV2g4bllSVFJYZ1hXNEhQZDRSMXJk?=
 =?utf-8?B?MCtmMkpTdWlUcHJXNW45Zk1sR0hRaTU4QmFvSE9yTURoWXE1N1lTQTNPUUtE?=
 =?utf-8?B?aE5CQzNzTENZMm9ER1FTdVRadEZtS3JvLzRVUVJ6OVJTb2NhbjVoeCs5bmlR?=
 =?utf-8?B?QlUxWSt0YlJadHRNbnVId3dxSlJiTFdFQmpSK2RBZGM3UUozbUVqWTBtbXFl?=
 =?utf-8?B?WjVDWkZJL1BKNWZHSE9xQmRpRTA3N3BuSlcvU0c1VUhiM3RrNGpqU0k0aHJD?=
 =?utf-8?B?bTI3VG9lc2ZTTURqRHZHWHJ6VkltdXBnM1RJcTRPbjZESWNxSGY2Yisrd011?=
 =?utf-8?B?NUd6UHJUbXdYRFdEa0hiQk1rWUY5bmxKQUpDekJheFYrbDNrQjdLaVo1MHo5?=
 =?utf-8?B?S2FoaGxoUVlndi8yVFYxMVVOQkVBNElodnNuTzhDNGdEZGlqS0VOUG5iRHlY?=
 =?utf-8?B?QlJNRmVXU0xuT2hzOWNhQUFERlFHaTdzMTBJaVJuQ29laEtqOW1VMzFBYmlX?=
 =?utf-8?B?SmNzU2RTSTBrYjFlZXpWbHAzWWExdXJnVlhMUEVrTmlNVE1FZVhIaG1ZMk5t?=
 =?utf-8?B?clI1ZVVJUll6Tm54L1l3VHZvVnVMbmphOEtERkZURThhenloZS9jNDBSWFhz?=
 =?utf-8?B?blNHRSt5cmVoeHRHWXdZK0xEc2ZUVWVjZ0RURlhlT3hWV3VCeWVONlAySmJY?=
 =?utf-8?B?TWFPNWVveGczNlAyUVNNbDNsUVU3dndIdXVQZ0E4V281cnJ0dmhjVGVQU21W?=
 =?utf-8?B?K3RzL2pYdU5iMEN0THc2bWRvYXZBMUZJZ0dTb0FsOE1DYkNUbTJtUkdDRzk3?=
 =?utf-8?B?R293aXJuK2k5cFZCQk5DeDNZNmxrY2Y3dDVHaEFrUzBGbUJvUzY3T1NaWU1N?=
 =?utf-8?B?eXhZWGVSYlRpam85aEgwSXhla3Y0WU1sVHFibmFObFQ2Z2RWUldMYkk4TWJP?=
 =?utf-8?B?NWxJb0lzV2t1eVNVM0hsSUQrQW85bm43TnlEV0NESHVwaTJPQ0p1c0NjVHhH?=
 =?utf-8?B?bEM3WVFRd0MvU1dQc0YyZGJwc0RhTWdVZFBVcW5YWEkzTWlrNjNhNTFUaWpU?=
 =?utf-8?B?bWdBZFZzeUljbGg1TWo2QVB3YlVFUGUvSnZVUURzNk8ydDd0MjMwRjRGcnNO?=
 =?utf-8?B?NURyaWJQSHkwVG1ESUpJRk4zbU1RdTY4LzlDTXBUMjZPZ3hkMXBaSTVKUzNW?=
 =?utf-8?B?QWw2VndlUldNNlFSaHlaakxkZXEzWXFpVXVpai8xSGVpbkh2YWMxNUZCNUdo?=
 =?utf-8?B?OWNhMGNOa3U1dVozdWgrdDBYTVFKRWFYMkYzV2FhcWFja3MxcXdKTHNoZ01l?=
 =?utf-8?B?Z0E9PQ==?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b53753-c4a5-46b5-8164-08dad126127e
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5603.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Nov 2022 09:51:07.7944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: AOKQCUJsxPCeY2CAMEEzuWm8Sw6b8Zh9BXHvFT7lAeqD+In/YoFBEdqC44ep3UQDX41StMq0Y6jM5Mhp9tVFYXum4BBOnbAfGLRPdw9Es2k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4728
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/2022 3:38 AM, David Ahern wrote:
> On 11/25/22 5:34 AM, Michal Wilczynski wrote:
>> Setting a parent during creation of the node doesn't work, despite
>> documentation [1] clearly saying that it should.
>>
>> [1] man/man8/devlink-rate.8
>>
>> Example:
>> $ devlink port function rate add pci/0000:4b:00.0/node_custom parent node_0
>>   Unknown option "parent"
>>
>> Fix this by passing DL_OPT_PORT_FN_RATE_PARENT as an argument to
>> dl_argv_parse() when it gets called from cmd_port_fn_rate_add().
>>
>> Fixes: 6c70aca76ef2 ("devlink: Add port func rate support")
> so this is a bug fix that needs to go in main branch first?

I'm fine with this going to main branch first.
Would you like me to re-send this patch separately targeting iproute2 instead
of iproute2-next ?

Thanks,
Michał

>
>
>> Signed-off-by: Michal Wilczynski <michal.wilczynski@intel.com>
>> Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
>> ---
>>  devlink/devlink.c | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/devlink/devlink.c b/devlink/devlink.c
>> index 8aefa101b2f8..5cff018a2471 100644
>> --- a/devlink/devlink.c
>> +++ b/devlink/devlink.c
>> @@ -5030,7 +5030,8 @@ static int cmd_port_fn_rate_add(struct dl *dl)
>>  	int err;
>>  
>>  	err = dl_argv_parse(dl, DL_OPT_PORT_FN_RATE_NODE_NAME,
>> -			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX);
>> +			    DL_OPT_PORT_FN_RATE_TX_SHARE | DL_OPT_PORT_FN_RATE_TX_MAX |
>> +			    DL_OPT_PORT_FN_RATE_PARENT);
>>  	if (err)
>>  		return err;
>>  

