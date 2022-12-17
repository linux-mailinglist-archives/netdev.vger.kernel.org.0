Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 170A464FB60
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 18:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbiLQRsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 12:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLQRsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 12:48:39 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C33563C4;
        Sat, 17 Dec 2022 09:48:36 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2BHGIZbq018484;
        Sat, 17 Dec 2022 09:48:22 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=0ou0UkvjWdjXyVjXaCoK6RJqgCz6QMv35Gh2AwdeTMg=;
 b=FE/RGKH/yHETC2OcBrxgPN/m/5jElgE1vCqQx/0kgG+99+Iis/vbzLUQ/4vnEZRrzwNG
 p6t+92i9OUy3ZPjGMZ3D4iTPx6icwWVoG0Fjwk1+ZtLOvneQX2egRXmoenQNZs2Il1BD
 bZTfcWIeB00BatYc9SS0pbMRd5YEH9xC6t8eDBux0Llo5HEKmPihUaTkSnBKsDjhqbkL
 K7lzZSXBww0rZFBEo3RozSEbQAiKfa5PFvQAPrMuY3Gaishgo2CmREG+Max7SjJDXOsr
 xRrDlf6qDIQmtQdo684fRJdX310n2q8fS2//y/EOWmgcl2C4JqT7n1oPFUZSJzjVbI2m ng== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by m0089730.ppops.net (PPS) with ESMTPS id 3mha5bsgfe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Dec 2022 09:48:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MKTZIDuh5WO5dKf/AIOfY934XnqreLfP50egAHeLXrz1D8IJVC2q/OGb5oyZ7dyxcNhicgh9vlhvgGRnD8bnXeC9t5R8jTxmieZ0kYjd7zz+uHn4IiBT9yvmd3kbdN2/F4M+9dGNL1Np6CztmYjzu1udyw6ZFo2K6LZLgQgbXUJHR2gGeXGLUBfrwuWxrP6byFU9C++JyanOrtuzQ6pk+NqJ5Qzwdf51Bko05SfCQ1v7Avk98cFIyy2BZyABVzexNz2tTY+hVdaQppAkhAhw4wFg7kz/F7BDnX6QIHiq7uWHEq8Up0yIj65PquTPirA6nrUWBDPmLyvHkSfSlmQqSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0ou0UkvjWdjXyVjXaCoK6RJqgCz6QMv35Gh2AwdeTMg=;
 b=n0/o03Nu8AUIPs3JPvLLpad8wxgPxnjyDUqERXosyUQa39t8ZPzCQuAUu6O3STPfQh18vYRWksMRFSD84KbNsnFU7xh5zZHJZOfJbi34YOG2uN+yT/g9lg5N8Z4TLSKXWROVDL5y27vppdP/IX2yHxDu/RM5F8tyiqBxopaHdwuKIfAaHLDdAIWD3TE54G/t9Jv5jwLsEEP3SOveSQTzLrBSazSK9Z9EVDEZUCJT2N4rOz0z/0p4wyBTI3Od6KD6svr0upq91DwdyYVCp59UUH+YwQR/5CBCNm4EAyKOZjmd2q8D+Wo/c/VrT5OQDDIue9mnc+gg/ROXAsdpGux4XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by SA1PR15MB4823.namprd15.prod.outlook.com (2603:10b6:806:1e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sat, 17 Dec
 2022 17:48:17 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0%4]) with mapi id 15.20.5924.015; Sat, 17 Dec 2022
 17:48:17 +0000
Message-ID: <fe2bf0e5-9b5e-51fe-d6c8-55390f75313d@meta.com>
Date:   Sat, 17 Dec 2022 09:48:14 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [bpf-next 0/3] samples/bpf: fix LLVM compilation warning with
Content-Language: en-US
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20221217153821.2285-1-danieltimlee@gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221217153821.2285-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR05CA0209.namprd05.prod.outlook.com
 (2603:10b6:a03:330::34) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|SA1PR15MB4823:EE_
X-MS-Office365-Filtering-Correlation-Id: c95ad440-67ce-43ff-e5a1-08dae056e130
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vtgsY9W5Maemw+bbJeDvKQ5id6ioX/T2AzdmYG9OWj9KDnoSKMKXi8XKluEriVCovswUgMRxl9o4akGXczVfgNsXh95WtGjl/bGKIhA+H7zxzOrwaBtRKNoaubeQ9w5mezzYMEan6qIwzw/7lh9HalUdJ1D6bnrfB2s0garNepSQvXrCD68ZiEjJovKn++1euxdthpP6TLkVWVOo+iAzncV2eIwTGFiyEvvjHS/UlRYlirmnpB1X0Kzgputd9cbXCOtg9QiX/EzJZOEFqBsrLyn+xMN49Q21hqQcjA7x0tNq+GvQmK8l8c4Knw9FOX4kLtR8AS8WWuu6HuZTPl0hpjyULUn61mp4CdLRT69guT4VMwZDpIHm/gzkwlPxqQPXcPCtmgwfMM1qUpo8LLa+nGLwxijq9HqqqaxUUgwa2wuEmJSyStJzW7fUFxkPD82PyFmzvLBbGCDN7vEBao061GUvFU35X/d0ZwvwOxJFo+3qZJ8WveBYfwxO+CgeO1rFQqiwpL4vAwRNzdh7r/Cqzf79V7gVK72NczRMv1mlPaSr67lkiy4UU6joMKnoqsuTjb9xSh1UKGl0+5qCVZx7M0hiTOwhUpWOHGbhmnuHPItwc/x+kagYCad3g8FiivhTwTkA1l5fBwPKtguloU21eKKLOpWo95Cwcg26idBEptnDUvxE6oGpUW/w4SDopyngKRSpL7miNs8PaIWqWhZSWBn6oOYHPOApw1T1RxFkRKM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(451199015)(41300700001)(4326008)(8676002)(36756003)(38100700002)(5660300002)(8936002)(2906002)(4744005)(83380400001)(31686004)(53546011)(6506007)(6666004)(478600001)(6486002)(316002)(110136005)(66476007)(66556008)(66946007)(2616005)(86362001)(31696002)(186003)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QU03TEdLZENlQ0tQZGsvTSsraEhIZ01OWTNTSFp0dU9pamVuWkVjcTlmZkIr?=
 =?utf-8?B?N0VPR2ovV2s2ZzJTbkZyUEwzTS9zZ3ZzaThSam4wQ0R1YXFxOTZySDdQamtD?=
 =?utf-8?B?MjVmak5WSytVZlBrWWZRTGs3MmFGeUZ3bU1FRCthc0x5M09DSkJYR3NlaDBw?=
 =?utf-8?B?dGx0OWpzaHRnckpZVVlLcC9MUEw5c0JkZlh1K044MjA0ZVFyeGw2N2VVM2xB?=
 =?utf-8?B?MEd4akNLRUVRSVZSRkpKMXc4UWkzTVFEU2h1dDBsWFVLL0Y1THhkOGsrUUdW?=
 =?utf-8?B?ZXRTWnVVeDV2V05wWWo4U3FkZG00bnFmUWxrbWxacjIyOGtBZmpSSDUzMEUx?=
 =?utf-8?B?TDE1aFVnNWlVY1hhUFZ3QmErZGNlVXVRODFaaGtKUjh2dDlncXNqOXpvWFNt?=
 =?utf-8?B?UEQ2Q3ByL25adUJ4SWVmemxhT0twZ1MwbDZ5ZHY5MUlFWENSWjNNTEZqdEND?=
 =?utf-8?B?QTdERHc3NEVpSXJ0OG9vMDJSSUlodHUzSmpRY0JpVXpKUlR1dmoyMVFlTTNj?=
 =?utf-8?B?MWNuMWNQZVpueWRISFNlNDNaRnJhSTRzMmVJZDVETmNZZEhNNXg0MnZLZjZI?=
 =?utf-8?B?QXk4dG1CMWt0cWQ2OWU3L1MrVXdoSk1iRE5odHVSbDVnN0QwNWtFRmFBdDJ4?=
 =?utf-8?B?UlZ6Y3lOcExKa0V2bHk0RDFETGcvbnhCcFMrbDhPYUtWNkwvbjZLRElHZUpv?=
 =?utf-8?B?N1p4SllPVkpuT1lvM0dwSWxqZzFiQ3BERGN0TFRMb0x4MzUrVjFJQmRpcmdI?=
 =?utf-8?B?RXpaWTZOMFRmb3BIL0hlYjVFT09hUGpBTlZkK1BIV095SDFDU203TWs1NkRG?=
 =?utf-8?B?US9UVFJEVkxMMUI4N1NtaXkwRlhyaTRTMlhVVld6bS83LzdHU3doUEk2NGI2?=
 =?utf-8?B?eVJZa3VFYUh1ZXZOZTlJa2puSkM4QXNVZG8weDRtNUJZUlAvbmdyVWZhY3l0?=
 =?utf-8?B?eHdIaXhlcEd6TmV6RzFDQXl0TEdnb1BOdUZnbGc4bE9EM3RPdGR2dUF3KzFz?=
 =?utf-8?B?SVdPSnROV2d4S0llQVRsanpjL3JvNVMzaUV6UFBqZmE3cUZzT3ZHd09MYi9n?=
 =?utf-8?B?d1d0Q0g5d1FDZnowZWdzaTVaTFlNUEsrNzJrSFl4UmhPcVdRSHNucGpDUFZx?=
 =?utf-8?B?bXI2NlQ3MXFoOUhsU3JSK3VJYkVYV0g0dVE0b2VDemZFZ1NhS1c5TGdXakpV?=
 =?utf-8?B?T05tY3BIZkNNL04xb096SDJXWkp3T29Lc2QwWWttbWhiSXNnUkhjcmZOd2hN?=
 =?utf-8?B?UjR4aWRQN2ZKWFk2dEx5SzB4ajZlMFNhTUxJajg5aW5NOUY0dHF1SVlCZU91?=
 =?utf-8?B?ZU1JSllBaitrMVk1SDh2bjFwWmVMSm9RRTdnY2l2UHNwbWNhTzZhYUdWM2hL?=
 =?utf-8?B?U3F6ZkdXMk94RWk3SEFYRkdXbWd0RHpqbWU1T3FaQkRZa2ZMMW9weHZJV3dX?=
 =?utf-8?B?cUFtQ0JTbzU0dEhIUkRVYjFMOXVicG5selVBaUNsR3hVR0NubC9XNzRHOFFt?=
 =?utf-8?B?OEpiVXEvRnBIMmI1TFFBczZaekpFNTdwcTNITFdyWmlwbW8zdEl0WU5CRjhW?=
 =?utf-8?B?YWpKR3plTjhaVTdIeWR3bjdnYzdWazQ0bnZNSVYxR2hjQ1RCaS8wWDF1V0ly?=
 =?utf-8?B?RnhnRHVsTmlBMXJZWG1FSU50RFl6ckd6QUhZU0svRG1ONVJFTExvTlBnZk9j?=
 =?utf-8?B?RHFyS21zSEl0bkVPTlBnM3lKYm4rcHBET2N4UCtEekRyOGxVYithbXp6b1VF?=
 =?utf-8?B?bkYyNjh2OTVFMXRzQUsxTElUYldCdTQ1TmQwOUR3SnBmZnhzdmR0VjJXUTV4?=
 =?utf-8?B?SnowNU9nYS9aK0JjUE8wRFYzTlR6cm1Vb2FLaVVaTWJtblN2aFIza21TQXkz?=
 =?utf-8?B?OWg2K2Y5U2grM1YxQlc2bWdOOGtpVTQ3bm1rOGhVYldxenU3WFBycmZ2L1VR?=
 =?utf-8?B?V1FpdU0vVGhJMmtyUGZrNWc3ckZZUTNZNElXMTJicjduMHVHcVByT0s4dlhi?=
 =?utf-8?B?eWdYM0g5YnF4emc3Z3A5SEJUY1ZMNkgxUVV0aUVSZkdTY0tXdlRHeFpZTHhh?=
 =?utf-8?B?NWtqTFp2WXZXL1RyeVZBL3QySEV6eW5kWlBDaFRPUlpCejhVNmM3YmdYU2dV?=
 =?utf-8?B?LzJkRGl3VHQ1cDVBb2Zkc25IMFFhcDNQNEtiQmx4dU9JeWs1cnUwT1NRSlhH?=
 =?utf-8?B?b1E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c95ad440-67ce-43ff-e5a1-08dae056e130
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2022 17:48:17.7796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xail4I8mwUuWBJj9wqs9DACYnHuilchJ1QK4BfG2bZXpmbZ06UGCkWQy7DLBRNJE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR15MB4823
X-Proofpoint-GUID: SU6gtY2mgYqJTXtT7TplLDQ5uBjspbu0
X-Proofpoint-ORIG-GUID: SU6gtY2mgYqJTXtT7TplLDQ5uBjspbu0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-17_09,2022-12-15_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/17/22 7:38 AM, Daniel T. Lee wrote:
> Currently, compiling samples/bpf with LLVM emits several warning. They
> are only small details, but they do not appear when compiled with GCC.
> Detailed compilation command and warning logs can be found from bpf CI.

Could you change the subject line to
   samples/bpf: fix LLVM compilation warning

> 
> Daniel T. Lee (3):
>    samples/bpf: remove unused function with test_lru_dist
>    samples/bpf: replace meaningless counter with tracex4
>    samples/bpf: fix uninitialized warning with
>      test_current_task_under_cgroup
> 
>   samples/bpf/test_current_task_under_cgroup_user.c | 6 ++++--
>   samples/bpf/test_lru_dist.c                       | 5 -----
>   samples/bpf/tracex4_user.c                        | 4 ++--
>   3 files changed, 6 insertions(+), 9 deletions(-)
> 
