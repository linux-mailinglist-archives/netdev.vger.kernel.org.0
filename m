Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8168397463
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 15:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233584AbhFANfw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 09:35:52 -0400
Received: from mail-mw2nam10on2094.outbound.protection.outlook.com ([40.107.94.94]:35649
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233797AbhFANfv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 09:35:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XlDDzO81C7puh+ZKLVy7W+lB4zFmhuVQGPQ1JXKbdzSAC+7vqI3JoUT4bfjxvHc99zBCRTlHbOO9P5t2JYtKPj1cjO+R4m5Ufk/WEdWWGyx8n4sKSpdjAa7BpLXQNq30tI5dVc+OWznUfCk4pI0SbR7TA/3Do5v/Qebyb24GAKGYeGxSAZQcpGrBGaFQxaWjht5BWVwDSDxbcVSr3WqDxuWmOePgZxiE+wtlh40vQnoXzE03bOB/XzczLTE2quOCPcS85zetv5/eCMu56zzRnwl8YQrRW7di2Q2Mr5pHNu3bnqjYnc+RIjGO/TNphyTt8QWW4Kd3KTBjW4QFWP9Aqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnJjnAHHFioDGrVlzIUiliEqdxcFzvYrIfqhDJNdDaE=;
 b=P4Y9Yq0R4tojZfE4l2Zbb/HqQrq+8zYuoWD6gphe1UrieIjtlK367kfoX5VX+XqvbuWpTo3Bs5IXdRHo92G4eLMH0fXvGw/g5K7Ky2+4oeY3MoFYPUegWBF2snrgikyxSF+Xt8OEnyDD7xBP8DPnpiGarR2daHmvY32gvfB/0bFiCcLDN9Hm5hC9H0Gl6moi9gX3m+nKpIInCIqzxLFgpTrAbqh+sgUsA99GwvPFw5Ht7qBEI4Nk5x8HGcdi2XuDsT1kV9PzVnqjIFuz7WnyodqG5Gtki6wBeXg+bfZSDHzmZRsU0+E6KOPVXTsM6wIqm3GWuy+esaPSQ2QZzo08Wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnJjnAHHFioDGrVlzIUiliEqdxcFzvYrIfqhDJNdDaE=;
 b=nkfxrq80q0fOEbFD1lOp6M5c7tVLnh6Pk0WV+uG7VlKmtK/DaXjiEVdpbFtBI1hzYfyHAXxwUvi56KazzavpM8k3XiWFmmQ5RuxHUbocGaikYyZF+lj1OaLhuz4OIgeNQUfUsSXcTiTVU0eNXs2EMpXGSq6zPxGfctHrCAeDqEA=
Authentication-Results: corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 DM6PR13MB2329.namprd13.prod.outlook.com (2603:10b6:5:bd::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4195.14; Tue, 1 Jun 2021 13:34:08 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::596b:d416:7a7f:6a34]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::596b:d416:7a7f:6a34%6]) with mapi id 15.20.4195.018; Tue, 1 Jun 2021
 13:34:07 +0000
Subject: Re: [PATCH net-next v2 0/8] Introduce conntrack offloading to the nfp
 driver
To:     Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>
References: <20210531124607.29602-1-simon.horman@corigine.com>
 <CALnP8ZZyckUuefLMf+oS4m5OE_PJc6+RvLh_9w81MmKFNpoQrw@mail.gmail.com>
From:   Louis Peens <louis.peens@corigine.com>
Message-ID: <5fb76dbd-ade8-4bd4-ba13-c0fffa1aee5e@corigine.com>
Date:   Tue, 1 Jun 2021 15:33:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <CALnP8ZZyckUuefLMf+oS4m5OE_PJc6+RvLh_9w81MmKFNpoQrw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [169.0.222.115]
X-ClientProxiedBy: LNXP265CA0034.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5c::22) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.10.103] (169.0.222.115) by LNXP265CA0034.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:5c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.26 via Frontend Transport; Tue, 1 Jun 2021 13:34:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: efc98662-2330-4845-daa0-08d92501ee61
X-MS-TrafficTypeDiagnostic: DM6PR13MB2329:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR13MB23291781CAB5E3FC9E8C1D4D883E9@DM6PR13MB2329.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gTX6y16BueTtuq2aXiGBLzR+FOHLevoLsD8AL4pQESjDB16indmzvpJDZongi1TEDBwPyKdU87jfQY93tjbUxe586FYDetudtiW0eYtuAMSrO6GoiUed7WNQYgkqL2kGNfksETOr3F5VbClTmUnxaTSdV7zPdfLmxCkGUmwM2K6N6LdB0xEMH0ymhlDChe1eST2I4hMPE3NNxvpLLCjq2+KumHDKUKl0Jt/PoGSeH1T6S9E+bpTvjqcjRREZ9gfgHTwNck8VbfYcXRebpi68xrtRQ4+97BDXDxw/wEQ54RshDnWbsF3RxYuGGbqgBPfHj3n+bcktVNMXkkdO4Soymz8o/ZHQ36/6Yuop2NmTjwqKlxroBgGG6dSVmi0wZAVWQDJtRBBA+/HW/2xAA6+9UkcvYTaNiU6jXECxL8V9Ghdl52vqPus+cxOLLEk8SU+5ArRSrr5D3mWWlT8p9+bW7/uKk+e9WDm2i007jSEn2PNNF9y4X/kDUw2K44bEoDjfcu9Nk6ZTK8pUyJeRrFAbgszcTEP1hHHEBLKVW3w2jKst3kRm4/83RY1NO111ZzSnUYQ1pl3G+3B5HYlopdkZ8JrplyYa0gcJ1LD+WpxH7Q1ZxB5K1A0MoYmm4JLNB6F45olZFDSe4blm9h3xYXkZ9+/Eakr45HyZvYez7UzUjRFgKXiBpZBrU6YlWJHoUM9MCy2d5rfUNBru+iQf1Q/skQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(39830400003)(346002)(396003)(66946007)(6666004)(31696002)(36756003)(44832011)(6486002)(83380400001)(38350700002)(31686004)(54906003)(110136005)(4326008)(8676002)(66556008)(66476007)(2906002)(16576012)(478600001)(86362001)(38100700002)(316002)(52116002)(16526019)(8936002)(107886003)(5660300002)(956004)(26005)(2616005)(53546011)(6636002)(55236004)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NnYxQUw1VnQyUVdOdEg0aWZ5MFlldFdhZTExa3J2ODNDTEdWVC9vaDRIaEU0?=
 =?utf-8?B?VE52a0RQVDRjRUhLaFZJakd0aGo1Ky9KUnQ1RjVTMCtHczNJcmNaaTdNaVli?=
 =?utf-8?B?YnB2YjVkZlNhamFDdWJiSnBtOGNsNU9MVER0MTZiMDJ6ZmRSRDJ6WWNiaUds?=
 =?utf-8?B?SkpTckNIcHdILzZLNVZhVnVUdE94NzN4NGY1L0dieHVqUlU4MXh4MEtkYThR?=
 =?utf-8?B?UUMreStobEhmQ2REcFBFV1lzQ2lIVFpPajJ6RlhUZmhoUE1FRDBURGs5OEFu?=
 =?utf-8?B?M3RoZFRldG9WUEt4bUN2VFpWcmFnQlE2czBVL1hLc3Rhd2pid0VQSnFnQ2ph?=
 =?utf-8?B?VFdEYyszNlg4WGh5MmtVRklJOGZXQW1Ob2hhY2lEVUJ4WlBCSWlxTEg3S1RU?=
 =?utf-8?B?UHYrelRDM25TV09MbVhpM011OTU5OW02R2pnVVpUSENmRHZvMXY4Y0t2Y2lw?=
 =?utf-8?B?U3dmTGJZMWNGeVR5RE04VTVYQUhVL3FqOEV0dCsxWU9NeHEvMmVQQ0VvZzM0?=
 =?utf-8?B?UG5wK0xST1cxazhOM3B2U01kUjdkWjgyQzA3ejdxUEZMdHFYOFlmNVh4eGlu?=
 =?utf-8?B?SEtDaTJqbjNSOXFZRTcyTVBzSHZ1SUUwVTZKMjFaODlkMTRpeitvdFFZR2FN?=
 =?utf-8?B?U3hxbmw4OFJzMTljMkgrZm9CU3dWdXloRTA3dHB1c1JsMVNGUjk4OVU3cVdH?=
 =?utf-8?B?TDB4RVJTU20vWWdrV1dpeHZGd0FZdUlGb1VNVnB2TXhnSTVBdGRQZ3piekFY?=
 =?utf-8?B?cHJ6ZEVNYkZKcHZHQy9lMlJsZ0hjKys1a280QUJVOWxvVkVKZS8xd1dnWkdp?=
 =?utf-8?B?VHo3Z3Jhem1OT2t4d2M4Z0ZUakxhYmxtQ2ZPK0svVmdwbTU2UEdIK2xOQjNQ?=
 =?utf-8?B?QzNkUjVJcFVuVW8rNy9HWVdYQzBxaGdsOTBmeDJKSzJlWDVOTmxUa0UyOVg4?=
 =?utf-8?B?ZXRzYVRMNW1JdzVuSFpRZW90RG9IcHNmTFNKck13ZFRJR21kbFJrYTJEeDUy?=
 =?utf-8?B?dXE5S2tBa3J5enNuL0hscXB1ZHB6WDBDVGpvUEwvUXNOb1FQSW1LdkNsSzRo?=
 =?utf-8?B?eFZ6L1dwdzhIaHJYYkpJZzl2VzdZbkNKRTB0UG1JdHpJdUp1TzY1bTB0TmxR?=
 =?utf-8?B?Sll4ZmR4bm1JMmdFMURVNXpHZWdvbFJoR2x2cWEzR2RBNVM2ODIyV1hZNWI1?=
 =?utf-8?B?aDFRQlJSTi9hVmViTExQbFBaZmtMeDBTOERjWnJpUHAvQ3gwQlpKQzNWQWRK?=
 =?utf-8?B?T0FXaEJYWVpYTXFYM1pWa3RBbW9qWVRTZ29yZzl5WXpLeTdDUjdtR0I4SjYy?=
 =?utf-8?B?NisvUE9UcmVwaE9ZQzRQc1krZHpvYlYzZm15ZFRObHNWRVhHSERReEY1YlEv?=
 =?utf-8?B?M2RDNVVzZmd4V1NpWjF4VENKMUN5RnhKbG51Z2hUQWljcU1zQXV2eHZGU3lm?=
 =?utf-8?B?R3IvT01RNGY1RlE4SXp0ZXFxT3ZjbHhmRzR5azNzZkFDUWE4WGEvR3Z4Nm44?=
 =?utf-8?B?ZVIwTHNjMDdiQXN1cTZMV29GME51N21tV1R1LzNsTUpoajI4QnFUL1VqNGl5?=
 =?utf-8?B?NVoxVnlLWHV2ZWkvdlV2Zml4RmdYQmpoWm16aFJENHpXZnMwWHlUVUo2NURH?=
 =?utf-8?B?b0JMR2J3dW1PM0xCbXA4OWF3N1MxTEVUcnZnYW02eTkzRmJtZ0xDaHlJSWVT?=
 =?utf-8?B?NWFMV2dncjRWZVlmcjdrL2g1dWpXeGU4ZklsYTZITG5wS3pKbjBCeFZRUmd5?=
 =?utf-8?Q?blUlSomkgJwHLrpYKs/4ruFBFMNV3PXID7Sz/h8?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: efc98662-2330-4845-daa0-08d92501ee61
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jun 2021 13:34:07.6210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yn4W3aFGr/ptNcYFnUCWdQEjEya+qj/1LQ80RddNvSIiDsnyBjxF8kmkWGYC/oNF+2yu4zxtiJu3jNthYjigXyddHF+pL2mGDfoZ85T10kY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB2329
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2021/05/31 20:20, Marcelo Ricardo Leitner wrote:
> On Mon, May 31, 2021 at 02:45:59PM +0200, Simon Horman wrote:
>> Louis Peens says:
>>
>> This is the first in a series of patches to offload conntrack
>> to the nfp. The approach followed is to flatten out three
>> different flow rules into a single offloaded flow. The three
>> different flows are:
>>
>> 1) The rule sending the packet to conntrack (pre_ct)
>> 2) The rule matching on +trk+est after a packet has been through
>>    conntrack. (post_ct)
> 
> I think this part (matching on +trk+est) was left to another series,
> but anyway, supporting only +trk+est is not very effective, btw.
> +rpl/-rpl is also welcomed.
The plan is to expand to other flags in the future as well, thanks
for highlighting these specific ones, they will likely be investigated
next after all the patches of the current version has been released.
> 
>> 3) The rule received via callback from the netfilter (nft)
>>
>> In order to offload a flow we need a combination of all three flows, but
>> they could be added/deleted at different times and in different order.
>>
>> To solve this we save potential offloadable CT flows in the driver,
>> and every time we receive a callback we check against these saved flows
>> for valid merges. Once we have a valid combination of all three flows
>> this will be offloaded to the NFP. This is demonstrated in the diagram
>> below.
>>
>> 	+-------------+                      +----------+
>> 	| pre_ct flow +--------+             | nft flow |
>> 	+-------------+        v             +------+---+
>> 	                  +----------+              |
>> 	                  | tc_merge +--------+     |
>> 	                  +----------+        v     v
>> 	+--------------+       ^           +-------------+
>> 	| post_ct flow +-------+       +---+nft_tc merge |
>> 	+--------------+               |   +-------------+
>> 	                               |
>> 	                               |
>> 	                               |
>> 	                               v
>> 	                        Offload to nfp
> 
> Sounds like the offloading of new conntrack entries is quite heavy
> this way. Hopefully not.
This is can indeed tend towards the heavy side, there is likely room for some
performance enhancements in the future, but it does seem to work well enough
in the scenarios we've encountered so far.

Thanks for the input
> 
>>
>> This series is only up to the point of the pre_ct and post_ct
>> merges into the tc_merge. Follow up series will continue
>> to add the nft flows and merging of these flows with the result
>> of the pre_ct and post_ct merged flows.
>>
>> Changes since v1:
>> - nfp: flower-ct: add ct zone table
>>     Fixed unused variable compile warning
>>     Fixed missing colon in struct description
>>
>> Louis Peens (8):
>>   nfp: flower: move non-zero chain check
>>   nfp: flower-ct: add pre and post ct checks
>>   nfp: flower-ct: add ct zone table
>>   nfp: flower-ct: add zone table entry when handling pre/post_ct flows
>>   nfp: flower-ct: add nfp_fl_ct_flow_entries
>>   nfp: flower-ct: add a table to map flow cookies to ct flows
>>   nfp: flower-ct: add tc_merge_tb
>>   nfp: flower-ct: add tc merge functionality
>>
>>  drivers/net/ethernet/netronome/nfp/Makefile   |   3 +-
>>  .../ethernet/netronome/nfp/flower/conntrack.c | 486 ++++++++++++++++++
>>  .../ethernet/netronome/nfp/flower/conntrack.h | 155 ++++++
>>  .../net/ethernet/netronome/nfp/flower/main.h  |   6 +
>>  .../ethernet/netronome/nfp/flower/metadata.c  | 101 +++-
>>  .../ethernet/netronome/nfp/flower/offload.c   |  31 +-
>>  6 files changed, 775 insertions(+), 7 deletions(-)
>>  create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.c
>>  create mode 100644 drivers/net/ethernet/netronome/nfp/flower/conntrack.h
>>
>> --
>> 2.20.1
>>
> 
