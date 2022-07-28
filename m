Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D58825845A3
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 20:25:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbiG1SJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 14:09:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbiG1SJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 14:09:07 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B17A252E65;
        Thu, 28 Jul 2022 11:09:05 -0700 (PDT)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26SHXIZk014883;
        Thu, 28 Jul 2022 11:08:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=facebook;
 bh=VrEk5g4ZbmjxSSZPD8gGWHrSc/agOfw98W2dKSrOGvM=;
 b=NY8HR885Tbx6VCI2QHJI0UUrSDt3WDrQlSSiF0foUYalVwT2JEBD4pbs2knFwn3RcQnZ
 tk3FhW7jWGFQyi84gj2lzCpxjWjjoxUHZC/V1sR7jBrgzMBsy7389QCatpvXc5/f5s7S
 34zn/QJZkMHz76taOB1DnRgaeIZxG7EQJSs= 
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2102.outbound.protection.outlook.com [104.47.58.102])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3hk3703d0b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 28 Jul 2022 11:08:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ekjpZxn+ZluSqUAWHT2k5ZHRQXudemms7QcVIG/lFIAg7WL2N83B2cpC8+setObBqd1q6bqVzPQcXkH07oSfV5p6s9j77FqPtPa/FZWSx9hAo5dc9xQinOLO9FmctGfOkg2gtl6Y/PAkIi6JwCEtrhgVJsMudcOsMkZpnZsRbSs/G/vjiXmcrjoCLAsPR+5nIu46xn1EFvSVNCQq/2DPtKqWZd3hIrsj/ktrBzvawsQ4UKZL9g51uzIS3wLaTycc9uqgBR7u2grhIjDB4vC9f8pGNHaPZEcVH2k3FXuvB8X60c7F6Py00bAOZTicao16RFwdrYlHUpQulhv4vuA9IQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VrEk5g4ZbmjxSSZPD8gGWHrSc/agOfw98W2dKSrOGvM=;
 b=B/UhmTZSS9nkMlYT1x0dbF8YnQ922Zca0NoiyxyASwUZS0VWHH4CIeuAXa/hFfWP2PcQ5Ka6HfS3m3u62WpdIO9kals9lK4EIaXBnoEAkwXz4IGURuL79iAzYF09evGe9eWJrZR81IL5oWGKLlIo1bJOiByRCkAEP7uChvFprd7sdaHR8jO9APbXZehFiZJtGw+jxo/5Uaceoh2iuUCbxtp5Ii5r+mA0r329ADjr2w9nWBZxya4sBug7lyxb0/ltrPKLyGx0nS9Tac8nBff1SjuteuP82sm++uGGBta1KLHCdC8SEftfjztTVGvfOaq6HAW2MWN65sD9vFvnCk9k2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BN8PR15MB2706.namprd15.prod.outlook.com (2603:10b6:408:c5::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Thu, 28 Jul
 2022 18:08:34 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::9568:e5d9:b8ab:bb23%6]) with mapi id 15.20.5458.024; Thu, 28 Jul 2022
 18:08:34 +0000
Message-ID: <1c4bac1c-ba65-5033-6271-6f79e3ca0cb0@fb.com>
Date:   Thu, 28 Jul 2022 11:08:16 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH bpf-next v5 4/8] bpf: Introduce cgroup iter
Content-Language: en-US
To:     Hao Luo <haoluo@google.com>
Cc:     Yosry Ahmed <yosryahmed@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
References: <20220722174829.3422466-1-yosryahmed@google.com>
 <20220722174829.3422466-5-yosryahmed@google.com>
 <c7ebc0c6-b301-de70-b5ae-1f62d360acb6@fb.com>
 <CA+khW7hvLgCKVA0kiKhREW-PZ4aOYvkGHoEqKAggEdyY9TRp7Q@mail.gmail.com>
From:   Yonghong Song <yhs@fb.com>
In-Reply-To: <CA+khW7hvLgCKVA0kiKhREW-PZ4aOYvkGHoEqKAggEdyY9TRp7Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: ME3P282CA0059.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:220:f3::10) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50175fce-3a1c-4eda-8f83-08da70c42f55
X-MS-TrafficTypeDiagnostic: BN8PR15MB2706:EE_
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gbcyx/YjHze1Av6PN0BmGrMBYs8iTNIgu+GOgUlOp2GaSIU0VlSdJhtaVt2D//ji2qJP+9Q2Q1zz7faXaWzx/YGluWguTYTQ2gNLLr8rHoEZ8uKFSftDkko+JwqaUL5+H5l3LgHcIcS29T3ITZuuln9yWSKChyKKdJLVRplhj7EUzAFCZuGRK+PL41NCzOqOxbcphTdDKQCAXB/iE+C28VMKUeUkSfBtmcwOrUCYpp29QRawTjMFMdN0cFwYupFsRUsYgMMrcwsDSiuhnb6VOY+xcWnt63CPlrT8J3LSza6n7ADMZBqt5EekW+Jq6zrD5ff490uAOIOryEEuglvqJld40MQTT7JTPrPH2QzaepaJbW/lbqpoJl+vVOBIjtE2c/sje78avCGiUqluvL+OtO3qQDA8YUsPWimctctdIIoW5yQ4ZKgr9myuh+XaEbfG/CZ9V9yz0a6KTxH4WITFdMZhhcNaylcnW2E0QAcXFQY9LdeDRLZok8EdHRxUeWtPjb9kU60KqIIGmMJQFe4UwSLGjyVn6BOCFxTOTqctidpe1MssamKLRBeFI/6eFQDzU0/7cPbGzc9bPPVW1IxI12tbmFr9wSfvHiXK2EjojMojRqABqrVCQBey5Idil49MXXyuTl+z9olLL+BPNft8KvKz2n0gq+4XL3cy7puQKfqQcckbVxcXeE+0gOh0890XY9dKgB5VrQtx8w6VY/CL7k9B5H54NuNNeexSRC6IA1W1LdURROG1dIgW/AUqhTAXlmRYayNRaMoZTGKcSciKXyfDTufBSv7zsObxnbWPzrmcv7eDfYnXZzZjyhhYpAyiu8ijsgxW8FqUn5rwgfTLWIQm6/fGcd9oE6jbDCKTx3/qdWiN7tZhEUz7s67ZEUSz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(6506007)(6666004)(31696002)(6512007)(53546011)(86362001)(38100700002)(2616005)(186003)(41300700001)(83380400001)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(36756003)(8936002)(7416002)(31686004)(5660300002)(6486002)(54906003)(2906002)(478600001)(6916009)(43860200002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dHRSMTZUcml5Y2UxamovYkVrQ3RSVkNHakw2YjNMMnQ4OE5Ia3hveG5GTVdS?=
 =?utf-8?B?dWtaOSsrc0lVNzQweHNwTXIrbGRxcTlxUUVpNHVmQy81Sk1TR3doMDluTUNa?=
 =?utf-8?B?UVBWLy9iYjFDTnlTOWNqYVZNa0hGNTdTdXR3UHM4bVZGMmlaajhBaW82UG95?=
 =?utf-8?B?MkNwSTVQVXlPT0NnaVlqdWlaODBMdXNvWVdhbTc4S2xIblVwRndCQ1FvRGlQ?=
 =?utf-8?B?bmRTQ2Q3RGJhSE54MXl5MC81K3NsY1I5NlNUS2pwRVF0U3dEeFpySFF3Ui9K?=
 =?utf-8?B?NW80ZnJxY1lxdWRqM1ZZcmF1Sm10ZnVJR0pJUW5ER0VnR2JBRjczay9pYi9W?=
 =?utf-8?B?TjBtL2hKM1NibFZVY3BvVVdMLy9ZYmdsY3pTYWc0Mi91dE1ZWEVJTjdaN045?=
 =?utf-8?B?N2FsVVlueGZudFROWHpzOW9Ib01udzNKNGw4Y0N1TXlvYTlOZnUyN3laQ2hC?=
 =?utf-8?B?YURiRVJPZmt6NjU2T25EOHN5dmU5bVIrbnhZWHBQcWdSZnAwMk56dUFTbEF4?=
 =?utf-8?B?SE85UWR1MEEvUlZXUm5rcGxpQ3hUQUNKTER3YXVvM2diY1BZRkptb0d0TGlz?=
 =?utf-8?B?cTZGdzVEaXN6bWdkQVgvQzFGamVxL2hWVmVoaDZxWjZXOTBOclRwU0VoN2lj?=
 =?utf-8?B?OFRJbm5ydmV5cTAwWjBwTE9vYXFhYklZNFA0SXFybVFXeEl1MmZMbG1SVXUr?=
 =?utf-8?B?aU40QmFmT2FYOGxvdWdtNkkrSzJWRnNUOStGd2VwS2pOU0NTQjMrSVQ5NVo0?=
 =?utf-8?B?UHlrZnVWM2RKZzFpYkVHbEFhd3BRUUlMb2JmcktCTldJVkZOZ2hGZVVuVnFa?=
 =?utf-8?B?QkRXZ0lDanA3WnZYMHBYTVBQYTRrcjBiajNtQUpYQzVxcS84V0w1SUo2Y284?=
 =?utf-8?B?Z1MrSTl2Z0tQNU5jblJEMDQremIvNVN0Q1F3ZHZqcTRtdklFQWdiZEdvSmc2?=
 =?utf-8?B?VmVxTXo3Zjdsb2g4NXE0a0pWSUJ6bENXc0JkNmIxakFVa0EzdUZNNjViT3E3?=
 =?utf-8?B?Y2ZWbW0yRjhPY0Z0YmNMWVZMTkg5ZWI5ejNyOFF1VGV0eTlBeEdyajVVUURa?=
 =?utf-8?B?dzJEdnBnYzh4aU9XZWdZU1l5Y0FFWnlkdm53STBQV05wdGlzRkpwNlg5eDJX?=
 =?utf-8?B?R29qSWJ1Ulh1MVl0cWk4U01NQ0xsR0UzVERIdGoySnh1R3VWODZoSDRWY1Rj?=
 =?utf-8?B?VE1KMUJoVmNUTENDY2d3emdkOXNaZFdXU0NORS9za3hyVEttSXp5ZG5CU2NU?=
 =?utf-8?B?OGxuZzJnczRCL20xclVueDhMTUdyUDVzYXdrKytyOVZubnRNM2wrU2NxeEk1?=
 =?utf-8?B?dGxaNktDNjArcG50Z3djbVo1UXJjbzNYSS92cCtHbjM0WWZKY2tFVi9OWWZ5?=
 =?utf-8?B?dDlUSm1zYWF3eUNadHVKSkF5SkVmNVZLZnhuKy9HNTB1eTJNOWVOaFlWR2dq?=
 =?utf-8?B?dVFVTHJxdi9Ua3htSnN2ekFScGI0MnRjMGFEZkQvbFZmU3gwZ0QzRDNiUkxC?=
 =?utf-8?B?OC96M3B3Z0VOd1J3dytrVEk3L3BmN1NibXFnaDlGZisxdzNDK2FUbW5DUys0?=
 =?utf-8?B?d1dJTTNPVERqYStSQlczZ2NXdnVEaW1YUEc2b0Joejd2MHJGSTBTZG0yQXFw?=
 =?utf-8?B?bDc0NWRFejJFeThnZ2FNV3hyWW9UcVM0RDhCT1JFa0Y4SXFtQjJWdjc2SGU2?=
 =?utf-8?B?Yk1QZHZ3Q0E5aExUbVV0aFVKV0dxVDNPa3pjZi9JYUNoMXNqcFFnZGFFenBa?=
 =?utf-8?B?N2tjQlJIZjhzWUVCMm41YWZGY0pWQ2JpaS81M2s1RnVkZmo2YVI1QWJ6K2Ux?=
 =?utf-8?B?Z0RjVTZCTVplLzh6bURsOERhaW5jR2E2ZTdNejBEelB4VXJPWkl0TWI3WVh0?=
 =?utf-8?B?UHU2QXZkRWIrc2Nya2VhQ005YWx1UmpkYWs5b2hwcXRjUVRzSWRMUFBxb3Fn?=
 =?utf-8?B?ZXZHS3hkYWlOZEh6eWRqQ0pZTU1nTDRLM1plZlBpelk4anRNM1ZwVnIxemU0?=
 =?utf-8?B?cDM4T3I0NGxhSkhnSVZZTDdiZ29tZUk0RXR4MjVwMHBEclJQd2hvdXRSN3E3?=
 =?utf-8?B?NlJqNzJjeUZMMUlnYUFkMkYzZGtqVUNadlgyRnMvZDc4MVVGTmpuVWhiMGY0?=
 =?utf-8?B?KytYc0ppU3N5aStzZmxSVVkyWVhoTGk1czJPSlZPN3RiaVhaTFRjcWI0VzlQ?=
 =?utf-8?B?OHc9PQ==?=
X-OriginatorOrg: fb.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50175fce-3a1c-4eda-8f83-08da70c42f55
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 18:08:34.0446
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/syRJKZ1OeB/RVq7ZdicmaHn7zjvOSKXyM6DRev/eKsB7lXEekIDGsyjbfar4Xp
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR15MB2706
X-Proofpoint-GUID: 4npFMq8R7xk3748_QigpEycbuM5oJKel
X-Proofpoint-ORIG-GUID: 4npFMq8R7xk3748_QigpEycbuM5oJKel
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-28_06,2022-07-28_02,2022-06-22_01
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/22 10:25 AM, Hao Luo wrote:
> On Wed, Jul 27, 2022 at 10:49 PM Yonghong Song <yhs@fb.com> wrote:
>>
>>
>>
>> On 7/22/22 10:48 AM, Yosry Ahmed wrote:
>>> From: Hao Luo <haoluo@google.com>
>>>
>>> Cgroup_iter is a type of bpf_iter. It walks over cgroups in three modes:
>>>
>>>    - walking a cgroup's descendants in pre-order.
>>>    - walking a cgroup's descendants in post-order.
>>>    - walking a cgroup's ancestors.
>>>
>>> When attaching cgroup_iter, one can set a cgroup to the iter_link
>>> created from attaching. This cgroup is passed as a file descriptor and
>>> serves as the starting point of the walk. If no cgroup is specified,
>>> the starting point will be the root cgroup.
>>>
>>> For walking descendants, one can specify the order: either pre-order or
>>> post-order. For walking ancestors, the walk starts at the specified
>>> cgroup and ends at the root.
>>>
>>> One can also terminate the walk early by returning 1 from the iter
>>> program.
>>>
>>> Note that because walking cgroup hierarchy holds cgroup_mutex, the iter
>>> program is called with cgroup_mutex held.
>>>
>>> Currently only one session is supported, which means, depending on the
>>> volume of data bpf program intends to send to user space, the number
>>> of cgroups that can be walked is limited. For example, given the current
>>> buffer size is 8 * PAGE_SIZE, if the program sends 64B data for each
>>> cgroup, the total number of cgroups that can be walked is 512. This is
>>
>> PAGE_SIZE needs to be 4KB in order to conclude that the total number of
>> walked cgroups is 512.
>>
> 
> Sure. Will change that.
> 
>>> a limitation of cgroup_iter. If the output data is larger than the
>>> buffer size, the second read() will signal EOPNOTSUPP. In order to work
>>> around, the user may have to update their program to reduce the volume
>>> of data sent to output. For example, skip some uninteresting cgroups.
>>> In future, we may extend bpf_iter flags to allow customizing buffer
>>> size.
>>>
>>> Signed-off-by: Hao Luo <haoluo@google.com>
>>> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
>>> Acked-by: Yonghong Song <yhs@fb.com>
>>> ---
>>>    include/linux/bpf.h                           |   8 +
>>>    include/uapi/linux/bpf.h                      |  30 +++
>>>    kernel/bpf/Makefile                           |   3 +
>>>    kernel/bpf/cgroup_iter.c                      | 252 ++++++++++++++++++
>>>    tools/include/uapi/linux/bpf.h                |  30 +++
>>>    .../selftests/bpf/prog_tests/btf_dump.c       |   4 +-
>>>    6 files changed, 325 insertions(+), 2 deletions(-)
>>>    create mode 100644 kernel/bpf/cgroup_iter.c
>>
>> This patch cannot apply to bpf-next cleanly, so please rebase
>> and post again.
>>
> 
> Sorry about that. Will do.
> 
>>>
>>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>>> index a97751d845c9..9061618fe929 100644
>>> --- a/include/linux/bpf.h
>>> +++ b/include/linux/bpf.h
>>> @@ -47,6 +47,7 @@ struct kobject;
>>>    struct mem_cgroup;
>>>    struct module;
>>>    struct bpf_func_state;
>>> +struct cgroup;
>>>
>>>    extern struct idr btf_idr;
>>>    extern spinlock_t btf_idr_lock;
>>> @@ -1717,7 +1718,14 @@ int bpf_obj_get_user(const char __user *pathname, int flags);
>>>        int __init bpf_iter_ ## target(args) { return 0; }
>>>
>>>    struct bpf_iter_aux_info {
>>> +     /* for map_elem iter */
>>>        struct bpf_map *map;
>>> +
>>> +     /* for cgroup iter */
>>> +     struct {
>>> +             struct cgroup *start; /* starting cgroup */
>>> +             int order;
>>> +     } cgroup;
>>>    };
>>>
>>>    typedef int (*bpf_iter_attach_target_t)(struct bpf_prog *prog,
>>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>>> index ffcbf79a556b..fe50c2489350 100644
>>> --- a/include/uapi/linux/bpf.h
>>> +++ b/include/uapi/linux/bpf.h
>>> @@ -87,10 +87,30 @@ struct bpf_cgroup_storage_key {
>>>        __u32   attach_type;            /* program attach type (enum bpf_attach_type) */
>>>    };
>>>
>>> +enum bpf_iter_cgroup_traversal_order {
>>> +     BPF_ITER_CGROUP_PRE = 0,        /* pre-order traversal */
>>> +     BPF_ITER_CGROUP_POST,           /* post-order traversal */
>>> +     BPF_ITER_CGROUP_PARENT_UP,      /* traversal of ancestors up to the root */
>>> +};
>>> +
>>>    union bpf_iter_link_info {
>>>        struct {
>>>                __u32   map_fd;
>>>        } map;
>>> +
>>> +     /* cgroup_iter walks either the live descendants of a cgroup subtree, or the
>>> +      * ancestors of a given cgroup.
>>> +      */
>>> +     struct {
>>> +             /* Cgroup file descriptor. This is root of the subtree if walking
>>> +              * descendants; it's the starting cgroup if walking the ancestors.
>>> +              * If it is left 0, the traversal starts from the default cgroup v2
>>> +              * root. For walking v1 hierarchy, one should always explicitly
>>> +              * specify the cgroup_fd.
>>> +              */
>>
>> I did see how the above cgroup v1/v2 scenarios are enforced.
>>
> 
> Do you mean _not_ see? Yosry and I experimented a bit. We found even

Ya, I mean 'not see'...

> on systems where v2 is not enabled, cgroup v2 root always exists and
> can be attached to, and can be iterated on (only trivially). We didn't
> find a way to tell v1 and v2 apart and deemed a comment to instruct v1
> users is fine?

So, cgroup_fd = 0, start from cgroup v2 root.
     cgroup_fd != 0, start from that particular cgroup (cgroup_v1 or v2)
Okay, since cgroup v2 root is always available and can be iterated,
I think comments should be okay.

> 
>>> +             __u32   cgroup_fd;
>>> +             __u32   traversal_order;
>>> +     } cgroup;
>>>    };
>>>
>>>    /* BPF syscall commands, see bpf(2) man-page for more details. */
[...]
