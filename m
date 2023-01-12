Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79845666B55
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 08:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235441AbjALHAB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 02:00:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235024AbjALG75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 01:59:57 -0500
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB264BD4C;
        Wed, 11 Jan 2023 22:59:56 -0800 (PST)
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30C6Xi9d017007;
        Wed, 11 Jan 2023 22:59:37 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=4VztaHvaidMTCVDkSb+KTu1oQEw3rwThX2EOSX90ZHQ=;
 b=mqgToq34HIEuQnxdcwdVuZC7MfS15G8TiP3jFgV40XA8j+MhQZ/AJZ5vzZYQTE9ourTD
 Z4DBN8AUSp7DRT+9Ov3bEW6GrNUNlyTT12fXkt8ns0sVD3GZg6X5sQZkRWYpoxupIJUO
 CcwaVqXxo7tn49cwRTj3fD7NbKJziw8jUcswCMmaDOtL8A5u3JKVu3zfYJoICWl/U+Kq
 DNkUGt8VsdC5YmXdmkYRYGsRDc6o46h5jpEH3d9d2En4/UHtrpiQDfMuI/5O+7ekxP9K
 vfV1VeDBG+vqMePQ7QoAM6GRxt12V0+c6ukclM3TNxe65kcFSJYAIiMLoOxIbeK+1x4K rg== 
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2106.outbound.protection.outlook.com [104.47.70.106])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3n2d1j8287-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Jan 2023 22:59:36 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVD2ZZVrDdbyesTdHVlCsiS4VPocAUphE3NPXy6SLDxIXkkbGqFabDQP34VQm2bI5VKJLQuohlCmcvXGgkCRUA7R6UmJKe1p76C1gwh1/7uUUK5L50J5CfkSxqztKjZcRto4bo8BHPpBTZGvSg7ElWd3rMw9CrjdUWRXs3IrnL/XdlL/uuezRc0j+5cshAKaoEGOc/3voMSGznGjmNWmFEt2odc3jFlVxOwu4MCfHB+XhinyoFx9IVcXRSMpL1u8B+X93SD5KWcQjXfMzWCuLa53+gW08EZCpjXwbb/5v2r18+1lyLum+AquO77bB/yMuVP2HUb3uut3KdM9aYWRCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oTtNjYQRd2v6jCm5jzflYFZxSLvAigX8WpmYsxgvg+4=;
 b=K3VVE139PJKhjL0sYMFWzUQjO5J1r68ZQvq9y1dZunG8VdhNce0a7foGXKph7X9u2z58jtsF5elv4i6DKedZo3oWvbR1plBNBMDCHarrJhi/UJMUPwTNVab+kNCdODs1aZbfPITEwoyyudswWb+uaTsklHuOdUTUs6NIyp358K/+7Pz56PExQWnBuP7j14rvNwswrt7f2msRO27j3CieYlfCouTcPfsN7WrQGNJfun+23Z1K2Z9FICEJivv/kkT+dFuMHJBeviyDQwQvCUP6uxea+YyQpCvN9adZmteVc4GappiKqi6zsdw9aPO/BgQiUh0L5Nb/iny+ZD0OnyGa9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BY3PR15MB4884.namprd15.prod.outlook.com (2603:10b6:a03:3c3::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.19; Thu, 12 Jan
 2023 06:59:34 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0%4]) with mapi id 15.20.5986.018; Thu, 12 Jan 2023
 06:59:33 +0000
Message-ID: <0f1d2e35-b027-43c9-067f-5e5e177071ed@meta.com>
Date:   Wed, 11 Jan 2023 22:59:30 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: KASAN: use-after-free Read in ___bpf_prog_run
To:     Hao Sun <sunhao.th@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
References: <CACkBjsbS0jeOUFzxWH-bBay9=cTQ_S2JbMnAa7V2sHpp_19PPw@mail.gmail.com>
 <52379286-960e-3fcd-84a2-3cab4d3b7c4e@meta.com>
 <5B270DBF-E305-4C86-B246-F5C8A5D942CA@gmail.com>
 <501fb848-5211-7706-aee2-4eac6310f1ae@meta.com>
 <933A445C-725E-4BC2-8860-2D0A92C34C58@gmail.com>
Content-Language: en-US
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <933A445C-725E-4BC2-8860-2D0A92C34C58@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0295.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::30) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BY3PR15MB4884:EE_
X-MS-Office365-Filtering-Correlation-Id: ee4989e5-0fe5-41f0-0318-08daf46a8f40
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HQ7OvmKf6aZG8q6xUyotoLZeotovUq88JHSZ/IFgyakcOYO6e+YLPoy3saDCvygMWLPSHIk84pJwmmoudE0L66e/zr25D+5y7rqMutnqV3XQFjV7YxCEsvS46XxgRXZexLfLW/XwzPbk29E67DV67MHTEORh49d83fFe5ukjoK07kBt6vBM5bymSP4M3izy84kPLracAqjOGMFBcbQdGoc8WcN+mKzPEVUsQf9RQoZfndepbiIBBXKRhChh8Iw0SuD5FQydtNyIiMb1B3aBoiciBRZP7zQWbg4NeM6d3J4L9UCHA2faInXXRq3oz0fGvtmz1KD01KZVJdxccpsmd4heocOZLmgaZQqWf23w8XbtEaXg9nXWSaZOJF+mLXC3i0+Z9GlRYs8NrhWRZSQlIPuOeH/vpJiz+ej+EhviDiFquRDhW6/FjYPs1y83RWbksE9+3io5TdFi9DFW/ea63a1puhFVDQV/DOyE6Or3HBgTK/zWpClNDvYH22nBrRPsVKhYiOh+l9NJD62FaNaAbeF8iwmg2QXgCCNrwGUgTJ4oy9nvo6f1VYpBKEkPDznSuA8ZxVypYgi1pe3c+mVwLXxTocg8XLrey+Wu/vL8vYFvy80gLoRP2YYqMftXESjJbMaKT9/21H8nEeUUtVyfWZIwDYB/Wp7DhOSjnRLaVDJjXMJTt4chSUvaBNTq/sUKHjmjBmP4MaBe44CyG/ubgCS6rlmMjpNwii6u7Z42A7jzZnnGkm7YzSNEAnk7uxTUGT+pJKWBQ7P8Q4UXoTfjbCPLIkCGQ2NpZ4oCi1WYsOwzDGBUpU9x2ECi5ag7jY1ppbw3YoYgyNHS0IG/SR6TR4yawRTlb1teeAcCMs6sGd6E=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(8936002)(5660300002)(7416002)(83380400001)(41300700001)(38100700002)(36756003)(2906002)(31696002)(86362001)(6486002)(478600001)(966005)(31686004)(6512007)(186003)(6506007)(8676002)(6916009)(4326008)(66476007)(66946007)(66556008)(53546011)(316002)(2616005)(54906003)(10126625003)(101420200003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2Y0MXFERzE2ZkQzTEEyUXlsODhuaDNXMWpZVUp4bmQ4bTc5TGhjREM1TTZK?=
 =?utf-8?B?eXNPSVJNM0M5dnhoaFpBRG9VbWEyNUFjQzNhdTlKOG5kN2JXWmhRM211Uys2?=
 =?utf-8?B?bFFZNGl1WVM5VHdKN2FWdmVEcHd5ZGxGVHlTcUx4akR5YUlZV3dZSkdoNERF?=
 =?utf-8?B?YWlUWWNQQVc0bG8rdkJtSVNyR3lDWDBoTlRBLzlPbG1hSzV3QVZKOVYrK3BH?=
 =?utf-8?B?N2ExN0orTEkzYXNmb2E4a3JFamtZeXB6ZGVTWklPc0pMbXJrWVUrc3Jib2ZG?=
 =?utf-8?B?RElVVm5TVmd5OG9DLzZhU0pRd3ExaVdabzNQM1lVWHo0TVhkcS9sdEJEbTll?=
 =?utf-8?B?NzdSdkhyUnMzL2ozV1loR0tSb1c2WVZmVlVZNDhKQVgwRFI4cE9BMkx4RFE5?=
 =?utf-8?B?dDlBZWgzRURjT1VvMkwyYXhDUS95RXY3TVF3NzN5NTluVnJoU1RKMWE1Smo1?=
 =?utf-8?B?Q1hEcVFUenZ0N05FM0dJNFBFY1NIT2dJUTFmZndHQkRUZzhLbm5NSzdrZVNB?=
 =?utf-8?B?eEh0QWhTa3FTL3RNbFZZSC81K2V4Z0NaUVN0MDJtMWFrbVl4ZzRkSDd4SHdp?=
 =?utf-8?B?VnlqdnA3cURVUElUcFJBOU12ZmNTZjlac2d2OWZORzREaXRjcGZkbGx3emJs?=
 =?utf-8?B?M0pYZHN4aXNYOXZWTlpyMmZFVGZjZ3d2WVpuZnpXbENFRnRwQXpVSWwwcDJi?=
 =?utf-8?B?aHRJY1ZaaVVvSHgzTmltNE9sZHF2Y0d4TVcwQURvNEtSbjhaNTVWeUVBRDFz?=
 =?utf-8?B?Rm16Y1JaS05OTjUvZFRVREVlSWROWC9ROWhaQjRUYW9PMjN1RVo5TFpkMm04?=
 =?utf-8?B?T2E4Q1p3KyttOHlabVRaTStTNDdwK2o1NmFiZFhvU210VEJhZUxYNWpXb3VM?=
 =?utf-8?B?UlVQYWszeXhRMVJvcU4yK0tHajloWGY2Z2lYRkpKUEozV0JCcUJ6d2xWdk44?=
 =?utf-8?B?SVRRK3NJWkppQkVWYUJMZW9LZWZBSVhHU2FMRmY2M29wcXJTSWJna2tNSjNi?=
 =?utf-8?B?Qno5UnY0UzJtcmtEM2dVZlkvUGVLVndZS3NvQ1dQWGhFS1FhaHN4b1VRNVNE?=
 =?utf-8?B?OHE3bWRUc25nOUxpajRRZFJUVFkrTURxam1PQnl3VlRYN1FVVEtIYWVrbkxG?=
 =?utf-8?B?UnBjeVRHdVFPUmUzTWhDZVFMVzVjZTBxZ0RyeHR4YkoybzRQQmY4SzRrU3JZ?=
 =?utf-8?B?cW9FcUZIaFFDb0JTRVJtYzA5QVRGQ3RNVmpwVmRQaFBaTFlnZHI3Mm10ak9T?=
 =?utf-8?B?T2dNc1BQTnQrblhQMDNzeElYV3F6OThiVlovSlhKOXYxTTQ5NVpHaVRONGwr?=
 =?utf-8?B?aEFHdm01Ykh5Zy9sZVl2dlZlZGQvbHdnM0liTVFMTndTcVhFNTJwdWozS2tm?=
 =?utf-8?B?UDJxdFNUNE5pTDhjRm9QUGN5VUxUb0ZEQ3JCTjhjb0NhTnJzT28wVjZxdERy?=
 =?utf-8?B?MjIxemZ1bXg1Ym81SzVBUTVjMHpGY2hybFdhV2FXN0tZZjRzL0NtMk8xN3RH?=
 =?utf-8?B?MFUwaXhrMzJ2QjdzSVFsTHBGM1Z5M1NlNkloOEhwYnNPTzhEZHlZRnJocC9i?=
 =?utf-8?B?aHJINkNxQ056M0NNYUxVYUtyLzhqQlR0Zk5FRDJFeVJmblIvWEROcW9MSXJh?=
 =?utf-8?B?djRoaHpFeFAyOXFyd05VeFJpcm0xTXQ3MHJYVjFRQkFib0FyRlpHdTl6MGlq?=
 =?utf-8?B?RHYzY25tUWVncGJjbExFeEdQWHdJdFZPZWFzNEcxWUlzNXJSTlZQSFdHQjN4?=
 =?utf-8?B?ZjQyaDh5YWJlNzAvYUpXY1dSVGduR3Bpd2ZmS1JlcHVDdkR3bFZOdWRNQnQw?=
 =?utf-8?B?MkRhZzBxdW1YTlhEbUo4RjlYMUVBZnhmREROK1VhN1VhK1N2T0FETTc1cFQz?=
 =?utf-8?B?WDZyajVjMzdGa2FhVzhXOW9qS3FMbkpwVG4ydGcwbTNIdDVtVXVFZTArL0pP?=
 =?utf-8?B?ZG1qNGtTbTY2NHQrbkE4RE13cS9FR2lUanAzcG5qVkZhci9nYXphUTkyUU5Q?=
 =?utf-8?B?emFMMGpreGlHNkZGNlczK0l0NlkrdExrbFRZb3RQclN4amtUeGg1MExXcmM0?=
 =?utf-8?B?TU1qUm1PWXJGZGE1TWVoRHovaXpXL21EZ0JvdkVjYmIrcmN0ZWxBOWdLVHVh?=
 =?utf-8?B?dDlTdFVmd0EwLzh6UDJ2cTRYbWNPcm4xYUp0T0VURERQYUZzZ0p1N3dFeVlR?=
 =?utf-8?B?a1E9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee4989e5-0fe5-41f0-0318-08daf46a8f40
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 06:59:33.5269
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V6bHiwzGkbXHYiqfUYOLUszdYdh+fnBNp0cikPJ+ilvaDvmEFx9Rj8RMro4Fd8K/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR15MB4884
X-Proofpoint-ORIG-GUID: 8itLRcv2H6Q2UEEIrjxxIdU4K2rU4T_G
X-Proofpoint-GUID: 8itLRcv2H6Q2UEEIrjxxIdU4K2rU4T_G
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 5 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-12_03,2023-01-11_03,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/9/23 5:21 AM, Hao Sun wrote:
> 
> 
> Yonghong Song <yhs@meta.com> 于2022年12月18日周日 00:57写道：
>>
>>
>>
>> On 12/16/22 10:54 PM, Hao Sun wrote:
>>>
>>>
>>>> On 17 Dec 2022, at 1:07 PM, Yonghong Song <yhs@meta.com> wrote:
>>>>
>>>>
>>>>
>>>> On 12/14/22 11:49 PM, Hao Sun wrote:
>>>>> Hi,
>>>>> The following KASAN report can be triggered by loading and test
>>>>> running this simple BPF prog with a random data/ctx:
>>>>> 0: r0 = bpf_get_current_task_btf      ;
>>>>> R0_w=trusted_ptr_task_struct(off=0,imm=0)
>>>>> 1: r0 = *(u32 *)(r0 +8192)       ;
>>>>> R0_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
>>>>> 2: exit
>>>>> I've simplified the C reproducer but didn't find the root cause.
>>>>> JIT was disabled, and the interpreter triggered UAF when executing
>>>>> the load insn. A slab-out-of-bound read can also be triggered:
>>>>> https://pastebin.com/raw/g9zXr8jU
>>>>> This can be reproduced on:
>>>>> HEAD commit: b148c8b9b926 selftests/bpf: Add few corner cases to test
>>>>> padding handling of btf_dump
>>>>> git tree: bpf-next
>>>>> console log: https://pastebin.com/raw/1EUi9tJe
>>>>> kernel config: https://pastebin.com/raw/rgY3AJDZ
>>>>> C reproducer: https://pastebin.com/raw/cfVGuCBm
>>>>
>>>> I I tried with your above kernel config and C reproducer and cannot reproduce the kasan issue you reported.
>>>>
>>>> [root@arch-fb-vm1 bpf-next]# ./a.out
>>>> func#0 @0
>>>> 0: R1=ctx(off=0,imm=0) R10=fp0
>>>> 0: (85) call bpf_get_current_task_btf#158     ; R0_w=trusted_ptr_task_struct(off=0,imm=0)
>>>> 1: (61) r0 = *(u32 *)(r0 +8192)       ; R0_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
>>>> 2: (95) exit
>>>> processed 3 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
>>>>
>>>> prog fd: 3
>>>> [root@arch-fb-vm1 bpf-next]#
>>>>
>>>> Your config indeed has kasan on.
>>>
>>> Hi,
>>>
>>> I can still reproduce this on a latest bpf-next build: 0e43662e61f25
>>> (“tools/resolve_btfids: Use pkg-config to locate libelf”).
>>> The simplified C reproducer sometime need to be run twice to trigger
>>> the UAF. Also note that interpreter is required. Here is the original
>>> C reproducer that loads and runs the BPF prog continuously for your
>>> convenience:
>>> https://pastebin.com/raw/WSJuNnVU
>>>
>>
>> I still cannot reproduce with more than 10 runs. The config has jit off
>> so it already uses interpreter. It has kasan on as well.
>> # CONFIG_BPF_JIT is not set
>>
>> Since you can reproduce it, I guess it would be great if you can
>> continue to debug this.
>>
> 
> The load insn ‘r0 = *(u32*) (current + 8192)’ is OOB, because sizeof(task_struct)
> is 7240 as shown in KASAN report. The issue is that struct task_struct is special,
> its runtime size is actually smaller than it static type size. In X86:
> 
> task_struct->thread_struct->fpu->fpstate->union fpregs_state is
> /*
> * ...
> * The size of the structure is determined by the largest
> * member - which is the xsave area. The padding is there
> * to ensure that statically-allocated task_structs (just
> * the init_task today) have enough space.
> */
> union fpregs_state {
> 	struct fregs_state fsave;
> 	struct fxregs_state fxsave;
> 	struct swregs_state soft;
> 	struct xregs_state xsave;
> 	u8 __padding[PAGE_SIZE];
> };
> 
> In btf_struct_access(), the resolved size for task_struct is 10496, much bigger
> than its runtime size, so the prog in reproducer passed the verifier and leads
> to the oob. This can happen to all similar types, whose runtime size is smaller
> than its static size.
> 
> Not sure how many similar cases are there, maybe special check to task_struct
> is enough. Any hint on how this should be addressed?

This should a corner case, I am not aware of other allocations like this.

For a normal program, if the access chain looks
like
 
task_struct->thread_struct->fpu->fpstate->fpregs_state->{fsave,fxsave, 
soft, xsave},
we should not hit this issue. So I think we don't need to address this
issue in kernel. The test itself should filter this out.
