Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC9762DD70
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 15:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbiKQOAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 09:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234641AbiKQOAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 09:00:25 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2042.outbound.protection.outlook.com [40.107.243.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD25941995
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 06:00:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KVBxLdg+d+IYV8t/mncTDNGsNo9jA7fCh81TAJ4ea8HbMUjLjv5UFTsLMQJWbwdZBIfrbKLZgvcryn9U67g4LyQpHV+rwl+DVcgesJpyp+A/mnu92NZehl8y3lukFvWwLhRYMKWm/unpyAUeRpwzmsROdod+2LVzaGgZIss0hn5iQwTvLZc9TXe8NxVcOUMBuh7erNDqgf4RlI6a/YexBB8h5mEVjwz8c8azz+EFyYSwh01J6wtmhEkY3+RLbl+FmF8WSMeGzEWLC5J/oQj9geLm0+vZ0J3dSqYP8COF5k7hfiYsqLiFNgRv+eOiGmvuIdNx0C+6siGXaikVPc1/tA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3ua0y/CC28WUIomr8s66Sih3mgTorPKnTlC3418Cn2w=;
 b=Oy1IIsTJl8gcqDTQ5h6t8MTTQ3gjW91kVdlOX6OrIGYr4+2/Aaq7f0kbu1AfxOcor518uBIyfvEIjTcm963BK5agdV3v1TdfxsSzaGD2CZlVthFQkgAaobHyWz8ja1uQ4DPfdjosIfPI4VsGNa3o0LEEo6kwYMdikF0EoFNw1/1KW236DNHIBDhO/ogyMGsYSyyGK/agWjSrTho8uVVMmgN4sa2eT8nPMH7qO1JXE8Xr7Ye/2I9mCe8IBbEYspJPk+01tXq+Llx9tY1q/3Ha9A+TuUdCVhU8R0YInMD3MgF/NT+6j9QFh1BRSbB7Qac+DRMgHC/nn6+Qcrl464CZ2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3ua0y/CC28WUIomr8s66Sih3mgTorPKnTlC3418Cn2w=;
 b=W5SNeyxOeaKcgICUw9v+X1xfgeFtsiJ4sSZFqZ6yaDZKzI7srC1xnH0z71ePWRmhGk2kUe4gpGpM3KncWdEgRifHa3xY3DdZlOENc7zuXGOYGjbD/bMHgngTx3yvjpdwaPE9UBEfqapC2xIqt9OOyiW6gThJl6EFfv1YbHjjooSCpeVkJcwhtNOjX0rWdJKWkpYOZlfu0nlPE5FvsQvwlfT3dGkNh9KmTRMlsp+PN2wXjZ2BNzdBTdR0Sv4OQVZ4dbtjukIFu4PfM3med2i5OIzQAW3R+QrggqBLuv09M9muumGbxrkdSqRyNkG07gl15aITBMbwEQOfEuSb9PdN6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CH0PR12MB5330.namprd12.prod.outlook.com (2603:10b6:610:d5::7)
 by SN7PR12MB7024.namprd12.prod.outlook.com (2603:10b6:806:262::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.20; Thu, 17 Nov
 2022 14:00:21 +0000
Received: from CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::eabd:c1b9:a96f:9bfa]) by CH0PR12MB5330.namprd12.prod.outlook.com
 ([fe80::eabd:c1b9:a96f:9bfa%6]) with mapi id 15.20.5813.020; Thu, 17 Nov 2022
 14:00:21 +0000
Message-ID: <5200b531-c3e4-cd27-ef30-8d4080b235b3@nvidia.com>
Date:   Thu, 17 Nov 2022 16:00:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:107.0) Gecko/20100101
 Thunderbird/107.0
Subject: Re: [PATCH iproute2 1/2] tc: ct: Fix ct commit nat forcing addr
Content-Language: en-US
From:   Roi Dayan <roid@nvidia.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@nvidia.com>,
        David Ahern <dsahern@kernel.org>
References: <20221116073312.177786-1-roid@nvidia.com>
 <20221116073312.177786-2-roid@nvidia.com>
 <20221116102102.72599e40@hermes.local>
 <5fa2b47a-67bb-6a45-525f-0af9fc15e1ab@nvidia.com>
In-Reply-To: <5fa2b47a-67bb-6a45-525f-0af9fc15e1ab@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ZR0P278CA0145.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::15) To CH0PR12MB5330.namprd12.prod.outlook.com
 (2603:10b6:610:d5::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR12MB5330:EE_|SN7PR12MB7024:EE_
X-MS-Office365-Filtering-Correlation-Id: df96863a-5c5b-41b9-7b8a-08dac8a4110f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oDcLYxCY6b2i5i23N9KvemFleWb5FJd31+udzTSvPaHTAW2bnGOswKLBKfMs/paRI4Zj0sWO7ogFvADQVA177ApeQJAbgTARqItAiE7m/XMHKGRcPMkbcBxwAECQDiGYQWyM7djVsKLVNamU+cP72I8lnbpxTlp3yk5khXwyX1x8Jnna8CJAipMYj8Q8p0lQI1BtMuGWf1aUc5GHVkiO0T9TRC7MDlVZ3PNeL3ACBNvD4s17q9bZyVs8r5s1MeXjqEo003t+gXEknN+GAd7SsvObAdps8dexMmabpsJ8eBhmnKJw3jz6TmVR57VVmjBkSuU26unC7i68HJ7sZFlKKFNyblhzGGQJi5v/751znmrChIWGjPif3WjYaAOlxOyrx7x9ILHhoyHUjg09r9FaeOxfFvAxRWC3bP5140sczOEwJ1deKJH47utZCiVFRdc3yD0V8jw475S5JKnsYDt19MzETPA3nltT6mDafegYE84iWvnAoc5nqAG1Ioi+kHTMPTl4DE/qzonUAsAJUc6qjTVPPI4x4TpMkbCrvKGNyadrUUXHJCqnVNcJCchy/A5IzvUngO6idNejmb1vDvNV6KnDl7yl5Yv5+UGwNXKjfHy7ZM79+Qp0MIoeQ2v+sTrljq3xeA8fsvltOidrHC0ijhH1EWM+YL2C30gbDZC75NioCNXpWXaM1P00jSWyfuer2UIFlnq8zlUxaDB8vFOO2vzQckeJV8hi8xcmwDM6kw8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR12MB5330.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(366004)(396003)(136003)(346002)(451199015)(86362001)(31696002)(36756003)(38100700002)(316002)(6512007)(26005)(31686004)(53546011)(6916009)(6666004)(54906003)(2906002)(6506007)(478600001)(83380400001)(41300700001)(8676002)(66946007)(66556008)(66476007)(4326008)(8936002)(6486002)(186003)(5660300002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TE1GNlNHR1JBTlk3U2tXUko0Zk1XR3AweGdWK0Y3THZpWExEczBVd3ZmdVE1?=
 =?utf-8?B?clg0dnNRNFVyUEtVM1RnQzhsV29CQ2hkN0U0dlBkQkluMG9SVUplNHZkZElr?=
 =?utf-8?B?U0JMbUw4dTU5eGN2bFF0YnpGaTExd1VFS3Jua25tZFI2bm1mMGJqRm9BaWJp?=
 =?utf-8?B?alVHWGh5SlcwelN0M2JvcDlzNTVjS3hNNlpjYUdWL21GRFJSSWlRU29oNHpV?=
 =?utf-8?B?MWY4aWNLaUhVdzhuNWhla3NlUUdNVGN2dHdHMm8ra3JWUThCL3hSRExLMngx?=
 =?utf-8?B?eGJWQUhHNGozWnRKMEFDcEF6TUNiK3d3WDdSUFFLWjh6aXBtbUwzY2EvSFBk?=
 =?utf-8?B?b1R4OGJBSW5mdWZIdWN1c2QvOHhlYTU0ZjFlSHdEZ1o0ZmNzUWRqSEE1elZM?=
 =?utf-8?B?QTMrbzZzYjYwZGh1clVxcWI3TE1mWmMrUFVUb2xlL1BJcS81TjJlemFjdzNK?=
 =?utf-8?B?VytvdEZUdDZrUzZPM2REZlE0ZGdselpZV3VKbXpVaHVRcXRyN3pxdUhYWmM0?=
 =?utf-8?B?Y2N6ZUFDVGtHbktxN3YrYUZFWW42THhnZDgrRWR6bitWcnFxaTRlalBKdFRk?=
 =?utf-8?B?MGdKdkNrNGtKRkpZNlpRMmpDSG1DR1FzdXVuYnJuejAvK0dnWjhQWTAzVDN2?=
 =?utf-8?B?dHZJaldsVi9rZ2NhTUEwUU8yMUVFMEhMb3JiVUIyMkZNbDNQZEhrMGpTRGlI?=
 =?utf-8?B?SXB4TFc4M0YwL003QkNCQmQ2cmNvZjU4NEdMdE5QMGZKY1lQVDU5Tkc1NW9X?=
 =?utf-8?B?ZHIwNVpveHdINGlNTmUyRkhjSHZoQVZiaXZaeXFYbVhHNCtDNDAvKzdlQ2xn?=
 =?utf-8?B?SkFiNkVRZVFmSnB6UGVUU3dHZ1RZTUtpck91RlpIeVB0OWRZWXZuRy91N0Jo?=
 =?utf-8?B?NEx6aWVXRmd0eEpHUkJUVTQwUkVOem1qaE5SNkJ0azVnT0ZOZDNNRktsM0FB?=
 =?utf-8?B?aVpnT0tjWllnRklHL3pnN2loVDBISjlxWFZCNWUyaWZJWVNud0I3VXh2ajlz?=
 =?utf-8?B?R2ZHUTRZdEhMdFVNOU5tc1BMVERoK3VDbzJ4YmI5Uk1IN004WTlsTUlvUU5z?=
 =?utf-8?B?cW8wcGJBVklqVXB1V1dZNWRvWnlPU2VpcnFEZytSenBGbjZlQUoxc0toeENS?=
 =?utf-8?B?UFVTbEVHMlJWaDJCQ2ZYejBZN2plL0RmOVdIN1o3aHFpWUZoVkNIemZBQ0Yx?=
 =?utf-8?B?Z3FLOFh6VzJWWklTYzBuVzgySE1pZFVYTTUrdzJGM1J6U3FRSEg1aStCQUxR?=
 =?utf-8?B?TTIxcTdHcExqbFN5b3lCcjRyazVsQ3VKV3dDaEo3Q3k4UjgvMmEyV3N3NFpN?=
 =?utf-8?B?YXUxZTBnSDV4eTdBQXQwZDd2cGhoNDkrekdKMFB3R3hQSkg0RTMvTTlUeWNQ?=
 =?utf-8?B?RUZhZnYxejRNUTIzbnVFeWk0ZEJpRlE2d21EWUhlRmFsYUo5REphTHUyd0V5?=
 =?utf-8?B?ak5DZmlnT1A5bUpsaVIxa2JkR25lTVFTbEZYRXBYMzhvQjkybGhWQkF2MER1?=
 =?utf-8?B?djRZTThXbXl0aDFJb3cwWE1VcHBWNE9JWWpJS3JLbUN2N0c1MTQzQlhPTjRm?=
 =?utf-8?B?QWp1MlhQLzNyWG5KaDFwT0RnTW8veFAxcENVNTBIY3JoSC9SYWJwelVweUpw?=
 =?utf-8?B?VUwycDhTT21nY20wK2tDYnZsRXVnL0NGQUtWQWg1YzE3eHlieXloUDdEOEZ1?=
 =?utf-8?B?YmE2d0cybDZodkVZRDdqWEpBV0RyLzBOUGNEdXk4aG8zNytnVDNwdkYxSHVk?=
 =?utf-8?B?cFlZWjZJb3hUUHl0TDVjcVIwdFpzWVZSODVVUkVzZGFCMHAzL3FSd3FPb3Jk?=
 =?utf-8?B?MFNsU1d1UUs3MVBTSDFoL2Q1VkpRR3Z5THl4RytRbjNaRDgxcHhvd1RLREUv?=
 =?utf-8?B?MUorWG5JN05VK2R2S1FmN2pwUkR1aTA3bDlPaVViWnlaS1p0WC8zYzBvQ2ky?=
 =?utf-8?B?ZjV4NVAzckI1Nk1WOXkxT2x6Rk9MaDhMZzVtOGlSKzhMejV2RStQdDhXSlJs?=
 =?utf-8?B?ZzAzNmJxVG0wWFhaL0dPNnRYR1hiaURBaWpIbDR4T25WTjc3d0RvYzVIbHVZ?=
 =?utf-8?B?Y05xSldWRHk1L2VDdnAzYktlTVcvVzF4bU1pRlNTMCtTd0dZZGtJUlV1WnpD?=
 =?utf-8?Q?IhLv3HeJHx/n4CJ/0Mumby6Mb?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: df96863a-5c5b-41b9-7b8a-08dac8a4110f
X-MS-Exchange-CrossTenant-AuthSource: CH0PR12MB5330.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Nov 2022 14:00:21.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zZhZjxdQtNnsqLuwoR67ffWInNVprbcVS6VqFa6F/9gddF7i5HfIVOgGSiWqKLbx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB7024
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 17/11/2022 7:35, Roi Dayan wrote:
> 
> 
> On 16/11/2022 20:21, Stephen Hemminger wrote:
>> On Wed, 16 Nov 2022 09:33:11 +0200
>> Roi Dayan <roid@nvidia.com> wrote:
>>
>>> Action ct commit should accept nat src/dst without an addr. Fix it.
>>>
>>> Fixes: c8a494314c40 ("tc: Introduce tc ct action")
>>> Signed-off-by: Roi Dayan <roid@nvidia.com>
>>> Reviewed-by: Paul Blakey <paulb@nvidia.com>
>>> ---
>>>  man/man8/tc-ct.8 | 2 +-
>>>  tc/m_ct.c        | 4 ++--
>>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/man/man8/tc-ct.8 b/man/man8/tc-ct.8
>>> index 2fb81ca29aa4..78d05e430c36 100644
>>> --- a/man/man8/tc-ct.8
>>> +++ b/man/man8/tc-ct.8
>>> @@ -47,7 +47,7 @@ Specify a masked 32bit mark to set for the connection (only valid with commit).
>>>  Specify a masked 128bit label to set for the connection (only valid with commit).
>>>  .TP
>>>  .BI nat " NAT_SPEC"
>>> -.BI Where " NAT_SPEC " ":= {src|dst} addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]"
>>> +.BI Where " NAT_SPEC " ":= {src|dst} [addr" " addr1" "[-" "addr2" "] [port " "port1" "[-" "port2" "]]]"
>>>  
>>>  Specify src/dst and range of nat to configure for the connection (only valid with commit).
>>>  .RS
>>> diff --git a/tc/m_ct.c b/tc/m_ct.c
>>> index a02bf0cc1655..1b8984075a67 100644
>>> --- a/tc/m_ct.c
>>> +++ b/tc/m_ct.c
>>> @@ -23,7 +23,7 @@ usage(void)
>>>  		"	ct commit [force] [zone ZONE] [mark MASKED_MARK] [label MASKED_LABEL] [nat NAT_SPEC]\n"
>>>  		"	ct [nat] [zone ZONE]\n"
>>>  		"Where: ZONE is the conntrack zone table number\n"
>>> -		"	NAT_SPEC is {src|dst} addr addr1[-addr2] [port port1[-port2]]\n"
>>> +		"	NAT_SPEC is {src|dst} [addr addr1[-addr2] [port port1[-port2]]]\n"
>>>  		"\n");
>>>  	exit(-1);
>>>  }
>>> @@ -234,7 +234,7 @@ parse_ct(struct action_util *a, int *argc_p, char ***argv_p, int tca_id,
>>>  
>>>  			NEXT_ARG();
>>>  			if (matches(*argv, "addr") != 0)
>>> -				usage();
>>> +				continue;
>>>  
>>
>> This confuses me. Doing continue here will cause the current argument to be reprocessed so
>> it would expect it to be zone | nat | clear | commit | force | index | mark | label
>> which is not right.
>>
>>
> 
> its the opposite. "nat" came first. if matches() didn't find "addr"
> it continues the loop of args. if matches did find "addr" it continues
> to next line which is ct_parse_nat_addr_range() to parse the address.
> 
> 

Got your comment wrong so yes the current arg will be reprocessed
and this is what we want.
This will make "addr" optional and there should be some action
after ct commit nat. next loop iteration should break and
continue parse next action usually a goto action.

