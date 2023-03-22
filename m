Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC5B6C4908
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 12:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbjCVLYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 07:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbjCVLYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 07:24:44 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2082.outbound.protection.outlook.com [40.107.102.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D81261305
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 04:24:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SU6QZOwjM4AEpiCj6MkaQa1DMYhmwKnrm9GkPz7gWWpXpnpjKRDd+QDjD8nlVmiT3/He3XQrI2qMGLLsSOPAAzAT+nBItkhQcHvFEExc6gn7X96OJOAtSrTL+LvAOQShKlmTyWzfoDvSohfEvqsRxwdahIL5oIy9flDAFo1GxFji0vPtZSOHd2EPRMSEgcBuYKcg6onK6Ei74Tsw2Nyvc0N8323kCeaz4raXJle4FD0erC5DX0sUM/PCmlqZpH4Vpuhi+YA7nkH72PvBYCbVnyR1WC05o90e3mqbHgBsmeEQ1Xq+KNDivQX6hNdaF4jUDvoqggVLkecKfJzFysMOTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cy02LF+vz1hQuv5hSMKsTxQgFbSDak7QPu94QpxWlVk=;
 b=jUnoVRwUpWmhe9Q7vg1IRgGSuzcVQ6Mus1SJCmvRN0jt/K08jFOB5o4Gzvs4vHRPqqZ3Tzfks5/JDkT00VvyPJpAeDhjEIzNt8oA8v95d6aPpCWuWKgiBT5i22qJn2V7OVmuUW12adbxLLxPDWsXvjtkhtJ/kjCuGqzDH6nBZG1PCJaQDXav+RSUuOygKyC6dzh4YkroF+DX5p00c2ZUWKJUpbDK+UboO52bbEdnoZ08R46v2s5POggrgPPvwq7tnT2vuZLHIZ6O5JAwtyHv3t1vbqIGDQSFHP0eQwTQYfkPhJDh0CkUjj2wlOtm7KXvs+E4xJXWvBnw0GaEOF4rNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cy02LF+vz1hQuv5hSMKsTxQgFbSDak7QPu94QpxWlVk=;
 b=KhaMqCnVxNzcmHmdoNRnxuQaJJ+4Ph/fEePIkdPSBpPKycot6pk07xCsjIlIDctPPYrDh+gNlCS7eYulV8SV5nT+MEf2J4Ij78XlnFCAVWPJf7YwgYVs4lD+frfeAymZ+kxzF5BfFftg4TknJ2fdP5Gkm4C3wBA6QwlEkS2CViwsD4tZU1nVjwK25X+xegjqH+zon73dQB9ASH3XPcgvjbn0lUXKrXlSzFM5CP/YYR4PAEVeG8lQVHByhJF1yh7UKsJ8t7cu8YOCRb3z0WeGdBHRJsKyrWiHiHLboMYHblrIWRzwNzx7h2cuS3qWrfr5yeG208s06q+x1Xzx7WjEgg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 MN0PR12MB5929.namprd12.prod.outlook.com (2603:10b6:208:37c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 11:24:40 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ff9c:7a7e:87ba:6314]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::ff9c:7a7e:87ba:6314%9]) with mapi id 15.20.6178.037; Wed, 22 Mar 2023
 11:24:40 +0000
Message-ID: <87aa5292-d59b-9789-1326-91805da34831@nvidia.com>
Date:   Wed, 22 Mar 2023 13:24:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [net-next 03/14] lib: cpu_rmap: Add irq_cpu_rmap_remove to
 complement irq_cpu_rmap_add
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>
References: <20230320175144.153187-1-saeed@kernel.org>
 <20230320175144.153187-4-saeed@kernel.org>
 <20230321204631.0f8bc64e@kernel.org>
From:   Eli Cohen <elic@nvidia.com>
In-Reply-To: <20230321204631.0f8bc64e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0159.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::15) To DM8PR12MB5400.namprd12.prod.outlook.com
 (2603:10b6:8:3b::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM8PR12MB5400:EE_|MN0PR12MB5929:EE_
X-MS-Office365-Filtering-Correlation-Id: 509405d3-cdc9-4559-7336-08db2ac806a7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u2LZASNsKGf2Otr1HjXQ4QlIM4KFxdOFdl43MIGfoGpbXDvGmvBRdhLvrL86EMCIqNSEE0hD11dUgc/j+5Y5bPpbSwgJQnYrrxUI7u9EmVVn/c8h7yguaFzdX1WkE6QQNdbo5PQQIlECb02s1a14AgNIFquPmJCmDfZzavZjeHRhV1DOIMWX5AvDat+49LEqihiwpK31FGjbK/zS/21E4hXXusmT5vQoAOm8INN9THBUVa7AjE3CHbYMcettvD8XL8kgbusZ/lYvpoYiZgUKlLsQNQAx9I2UJeDBFUm9he8q1tA3mO/vDI7YIlJ9crgtIfnluQehxHnHq/OoWsLUDdXePYF9lzWQTS2SpALhy8XCrvtSieaTZUaV//1KfeQI+e9mEckAIzl6T05dun1mTcsU3kdivOsM5Fk2m8sksCVkLSdBx6hK0bVrs1GpmBuaXIRLItFDkZmc8THiVBjkr0U+NvRAy/UN5coZK4CbkE2p7U7h7LCWCveS8LnGEGYUxYKMvr14HSLFhzx6kwt3M0dXF+hSpVixQrR75eMkOT6NaLH1PFpOx+HuyX0bMM9pUUh44PuWkwR9+kDkJq+22PmdF5/lpWB+e0RN1I/fzjgjM23muV6jMkBFeOi2Kx4/yY5ZjlWp1e8IImbxKiZOwr1cFQksn473OFcK95gszArKLxd+h+0ZIAEMN7VX7K4+m9lmSs6xa4l03N1Ju9jHXCGquSobDHL9xopnKgiNlos=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199018)(2616005)(6512007)(6666004)(6506007)(54906003)(26005)(107886003)(83380400001)(31686004)(6486002)(186003)(66476007)(4326008)(66946007)(316002)(53546011)(110136005)(8676002)(66556008)(478600001)(5660300002)(41300700001)(2906002)(8936002)(66899018)(38100700002)(31696002)(86362001)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VmJNK2pNSzVvSzA5Nmppa3dGUGI2UXFud3BlZmsrbWFaU0ppNmdGNlRKOTYv?=
 =?utf-8?B?ZkRSbDJGY3pqSU9NVW4wK0ZVTERkbGwwZ1VyU05GWVZ4dVgwUXVUYXcyZE14?=
 =?utf-8?B?Y24vY3dCZE44STNzS2RTMlo2Q0hTeUFPdEhkbkRQQk1HN0pXcldsc3dmYTJC?=
 =?utf-8?B?blRKc0xBMHVqVFJ2K244R2hML05tbFQ4RnpKcWRmZmdXajltaGNEL3cxQThy?=
 =?utf-8?B?eU0xVUYwWXQrUVdTVi80MUpOT1ZXOGo3RmpkUSswRFF5eXRtaDI0M0ZUdG1G?=
 =?utf-8?B?TUVSd24xWHU5SlhsNlpFZ1RXYmpmYS9wcmtZOHRIL0x4QllDU1FGcXBzdzJr?=
 =?utf-8?B?aHVjVEpSak9SMEtrU0VOY1J2VWMybysrVmxjTEt6cHVHYnVrY2NhRWFFQXVh?=
 =?utf-8?B?eFZlUW05VFBiTzhrL1MvNnAvdm5KWlpKUjhWRDNXY3pKVlpaR0JQRFdYV1ZF?=
 =?utf-8?B?em5oNk9LU21OYVdHKzM2NzJ6VzNnVllONTZnVW1XTERPa2dPalpWYW5ab1Vh?=
 =?utf-8?B?azRpNE5SYU43RWdJVTdLcTJpUndaM05UZ0RtdTVTY2szL1p6VWNJZUV6T3c1?=
 =?utf-8?B?VEJydXpuZ3NmdnQvcUpqV0hYMEVtcFM2OTAxRS8zeS9Ga1V2dXg4N1oydVlR?=
 =?utf-8?B?aE1sN3hYTWJ1bEo2ZFo2NjNQWFQrRWVicDBBNHNtQ3dwZWxOSGFSbDFzS1Vs?=
 =?utf-8?B?YTVGQlkxbDIxR0FmWWNOTmsxak91V3pwSUdXWEN6OGJKSEhBQmpmQ2FNeG9I?=
 =?utf-8?B?N29SZ2hpMVp5RTlkNUFqcitHRGJjZi9ER3dENkFaY2VabjVDdElNbldEbndN?=
 =?utf-8?B?WjBDS3piNU1WbDhPSXM3NFRsd2VsZGE2T3dDVUNJOE11OVkvRDc3ZVI3djVR?=
 =?utf-8?B?S0JXRmtROXY4MHFVOVB4M0J6bGNCU2p6NDNpVnQrZk9WUDBSZXhSRDk2OVRk?=
 =?utf-8?B?T2p1UUdnV2NDaXlNaUlVMHIvSUhWVm9kOVB0SitEZ3ZnZWl5aytJNzJrdVYx?=
 =?utf-8?B?RDVIMUs0YUtJTmc2N29GcnlyTkhFb2tzd2ZHaktxUFdHL0NsQndpTVUxL01h?=
 =?utf-8?B?bmtxaXA1b0szSks3bmljTS95QTllaDZrQnRxbng5aG9GR1VKeXROVWdENzZz?=
 =?utf-8?B?dVlIeTVrZmpWeFlzQm45cFZTaXE1NjR1eVM3bmgyNGhxSXo2Sit6ZXFDMGJU?=
 =?utf-8?B?V0FLUTZrK1BZdDFBNTFRRmZKV3ZUZmJkSGJnM0RzaCs2MHFvbjhCWTVmYVpY?=
 =?utf-8?B?ZkdrT3plWVd1aWRYQlBEWngyS1AyNHFDUmFZK2toNVhZV2lPbTFQVzZ0WUc3?=
 =?utf-8?B?MUVHaUt3T2w3R1JHQ1psQ0FkT2JkZGlyMEJhdndHNmJEckJmdkloMkVhZ0Ux?=
 =?utf-8?B?RWM3cVA0NTJubWF3aitLNTBxc1BuNlVEQit4WUxsYUxFTkFNTXVIOXoyZTBq?=
 =?utf-8?B?bUlYNDF2czNpNGFxT0VONm80NWo2czJlckNHVkh3akRWWlBMaCsva0srdDNv?=
 =?utf-8?B?Z1FJUGVKRmZYU3FOTE83TVlYV0ZZTTRxMWtaUFYyYjlmblZRMVFkNXAxdm91?=
 =?utf-8?B?N0grQnVaM1FTREo0T0g4QUZ5ZkI1SGdxNVpBeTB3R1I2ZkJiODBqV2pNOWJm?=
 =?utf-8?B?K0VRQVpXdnBrcVZDNUhVNEdVUEdiOS9CQXBUNStPRmtTejU0SjRjNGNFaDlk?=
 =?utf-8?B?YldoZGpwWllOSVpFVk5zS080S0RsSkRNTnRtL0hKemp1VVdPbUx0TlhMV0Fi?=
 =?utf-8?B?VE0vaTFRRnoraHVlaFhTdUxhNE55cWNaSE1IWUIzZVNSTVNuUHUxR0pVMG8z?=
 =?utf-8?B?RzlEMGxFdG5mK1U1dUp2R2ZIekxDWlVlVEI0ZXFSUTJzWlpwWVFlbjMwQThE?=
 =?utf-8?B?QmhsL3ZvamdTbUxMbkRhYkxkL2Jic0QvamlSeE9JbU1rcVBFOTlySkNxOGtS?=
 =?utf-8?B?L0YvYnlBYjZDN2pGaitMKzN3K1Q5dWdhK2NRNlBraCs1ZXc2OUNrK1p5K0hI?=
 =?utf-8?B?TnBHZHlNaFVJaHROdHNpUUUwTmxSOGpxcGh4SllGbGN5VjNxUTVsMnU5THVL?=
 =?utf-8?B?bnZXbyttTTFmc0l2TUJyTGpCKyt4cjdrY1Fsa241SHFkUUd1Ykh4WmdyYnJi?=
 =?utf-8?Q?TsI5XI46wOTDtCHQcICDP/Sex?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 509405d3-cdc9-4559-7336-08db2ac806a7
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 11:24:39.9020
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N9WbOofh4Ifg8h2ujbiwH0ICajFLdJ+ODL81ACa7Ycc6wL3SnmmBvJbynW/CKkWc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5929
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 22/03/2023 5:46, Jakub Kicinski wrote:
> On Mon, 20 Mar 2023 10:51:33 -0700 Saeed Mahameed wrote:
>> From: Eli Cohen <elic@nvidia.com>
>>
>> Add a function to complement irq_cpu_rmap_add(). It removes the irq from
>> the reverse mapping by setting the notifier to NULL.
> Poor commit message. You should mention that glue is released and
> cleared via the kref.

Why is it necessary to mention glue which is internal to the 
implementation and is not part of the API?


>
> BTW who can hold the kref? What are the chances that user will call:

The glue kref is used to ensure the glue is not remove when the callback 
is called in the workqueue context.

Re chances, not really high since a driver usually deals with rmap at 
load and unload time.

>
> 	irq_cpu_rmap_remove()
> 	irq_cpu_rmap_add()
>
> and the latter will fail because glue was held?
The kref is taken for the duration of the callback
>
>> diff --git a/include/linux/cpu_rmap.h b/include/linux/cpu_rmap.h
>> index 0ec745e6cd36..58284f1f3a58 100644
>> --- a/include/linux/cpu_rmap.h
>> +++ b/include/linux/cpu_rmap.h
>> @@ -60,6 +60,8 @@ static inline struct cpu_rmap *alloc_irq_cpu_rmap(unsigned int size)
>>   }
>>   extern void free_irq_cpu_rmap(struct cpu_rmap *rmap);
>>   
>> +extern int irq_cpu_rmap_remove(struct cpu_rmap *rmap, int irq);
>>   extern int irq_cpu_rmap_add(struct cpu_rmap *rmap, int irq);
>>   
>> +
> use checkpatch, please :(
Sorry about this :-)

