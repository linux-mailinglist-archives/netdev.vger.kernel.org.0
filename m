Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112C764FB22
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 17:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229947AbiLQQ5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 11:57:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLQQ5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 11:57:34 -0500
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B9B140C4;
        Sat, 17 Dec 2022 08:57:33 -0800 (PST)
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.17.1.19/8.17.1.19) with ESMTP id 2BHGKue9025687;
        Sat, 17 Dec 2022 08:57:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=D23754eaLG289ben6Sx5Chh+XTTPFwV+ZShl44LxhpI=;
 b=cSOyd2xZ8C1GkHfamdKapBZDcxMFXZVXgbJzWeHwie9cdQfLjWCbe3a/9Qd7CGSwLxIZ
 EUlIG09y62u1YOOoTyo3enKYn4bxD/dInEbWWziXAhcdRZ8+0oqQhrB3dppoqy88U/fB
 +uLvukpL6F+E+N8v9JRzc781nAV1RLmQayyyBsVkC3fA9J8pPuOZwcZ3aUXveA+wNzx/
 Pd/AHpyit3EjuMKkM39PP1BrkewkrqvDMXIvKTEBE+YZFjbdNPlUJ3kU+1WupaqfrdNT
 qWARmVQgBMC42PlpUwM2o3naufajCZmOUKx32JHwXkgIP+RhBWSTS/+GRMAsjJ1iPcM6 MA== 
Received: from nam04-dm6-obe.outbound.protection.outlook.com (mail-dm6nam04lp2042.outbound.protection.outlook.com [104.47.73.42])
        by m0089730.ppops.net (PPS) with ESMTPS id 3mha5bscyv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 17 Dec 2022 08:57:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XTbEPqTkfn9YkmJc8Y5rzwCo3m5MTgEaMEJIzVMAag5MRSNm3uTT6UZFWdM6KCp79v3MCy5Okge92RpLn6Ca5wI2w4usDw1xAE19VI8aTMqmo+5EYF35Q0g+9i9reBXXl51DUEjZfx0VF6KBdpwyxK+8cHR7lSUgKpFvraVf2K542vqUVmZq/PnRnMsrZfA+g6eWgsQeDYYyZAMRArzRvDb9GqMPup7LQW+aFWhe+hiecT3JZaDM2D8z5vcM8abBXS9uhdkVa7ynZuG9N3nw1XTnii/xmZADXjMLkAZg7c4ctItLKBClTBzWlOtaqurv3GikwMdk+kX0NE/Yxw9LeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bGEJtdDtlQgVh4Z0Cy/JNOCR8hcLi1uqRqJnxRBhV6M=;
 b=C6WVqTpJ8mdD7BjuxmkVeszeiFQR6vCcNDuPCMsWssTLztvZZ1YRedG92NIFRf+mUKHzG6WXSAcEP453KLji9hd0M6bhCpVBhFO0XPy7sdTWJ5JXBQJQj6xKaNGkhHqCETcvWOSQk1abXwzMwdO+1guPoAyUPsfodMCVfoPGK62qX0TE/y0VmF6v9XxAn5ajoqJX3p4oV7DGbmePHyEocYoWBDwbWk/eSp8o56U98yBXlnkOLsJD8b7AImNy88z0XOA7bN39G0mL7nDKwDrsefy+54W87b0itQDK4qWHq2ehG/aT1enuPvMwWl9Z+dTYDORbRy+MOIFsMpEDxXU3cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by BYAPR15MB2197.namprd15.prod.outlook.com (2603:10b6:a02:8e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Sat, 17 Dec
 2022 16:57:11 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0%4]) with mapi id 15.20.5924.015; Sat, 17 Dec 2022
 16:57:11 +0000
Message-ID: <501fb848-5211-7706-aee2-4eac6310f1ae@meta.com>
Date:   Sat, 17 Dec 2022 08:57:07 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: KASAN: use-after-free Read in ___bpf_prog_run
Content-Language: en-US
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
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <5B270DBF-E305-4C86-B246-F5C8A5D942CA@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR06CA0072.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::49) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|BYAPR15MB2197:EE_
X-MS-Office365-Filtering-Correlation-Id: 400e230c-7db2-4970-0239-08dae04fbdaa
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtvKSLBjL7JSrQg+FVVduA0C7QJkPBapefXcv8dWwiC/vecw9x2Gwx0NHXCxHSznAX9Ui6gTCkWeyR0fc+pxxLCww2mHhCoonF9oquIZsfw39wENDrCsG/Jik/tHg3tI+2kGBovNxANC7+rBXWGI1ELXk2cFF4nBEhL7Oza1M+NGr1/81qhHVQn1fz5SzaKQJ83dAzWQOQjfz32ZZ7WuI7PQGOj4/5U5XUGtFLcGsx0bJJbMI6DwgJuI1c8VxMVlAILrp86yv3dFoD+7P7vuvL4924CzaRBAyloOC7SVKkOLfznFj30ZnYCE7igpEaaIMJIbusNogBpy6fC6OQCAFGcxCwTJmvTMDlYwiFPEGXq2P8oX2QUF6j+ZPQj3fDSttzJRFlLSz2TraMPSNVDRmvhuCZdE06Z4dOt1g/Ti/2tdAejvacgHTfePlpACJhdfryBrqQvWGxImopvhBxhqT5bm2QWThjhNAiJUQwqaBDhTuiBNBKbVFDMwQcUvlrJKlScTi1L84Yf58CcqQSiZwlz4bIASUe22JxHZNZIaXBGNGhbA6Ai1sgDMQR3dmFcQCbssSrsNUPGSl7QR+WXruR5Bv62g8IDR8PObynqBVcH1TecR5AqyPsP3O9PxBWhWLRW3i79j3YGlzIm9871gpwh3lD7Lea2+fM9dsCs1CjXREiURK8Zun0vTD1b+4nWdbeO43hLsGKbMrwx2FsE/2wesTC/8pm7/qnpYLbnehvVf3owxg2CJ9Rjk3OB2zJfWWV9kCKtlC5fTVXi267/IHU/9oZcCRfP7TX/nvmsLKhBkvNDIQhRhXcZn5xEah/GQ/aH/smtO8GNFoIUCEuMn8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(346002)(366004)(376002)(396003)(451199015)(54906003)(31686004)(7416002)(2906002)(5660300002)(84970400001)(316002)(6916009)(966005)(478600001)(8936002)(41300700001)(66556008)(66476007)(66946007)(8676002)(36756003)(4326008)(31696002)(6486002)(83380400001)(86362001)(6512007)(2616005)(6666004)(186003)(6506007)(38100700002)(53546011)(10126625003)(101420200003)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlBOeGEwN2ZPc0J1ZDIvUW96VE13WTlnVFRVV2UzbE13Q0h2WDl0SFF4MHNX?=
 =?utf-8?B?WHlDZGtONlkxN0VPTmR2aW03SVBYYXFIOW93Wm1KcUNNaVd2WWE3VDE5Zmpl?=
 =?utf-8?B?MHlvZmZueGczUEROdFlFRlhlMk1ZM0FYWXJJOEdQUGtUZVZUK2RCcEZ2WHo4?=
 =?utf-8?B?bmtuVEJJSVZ5SlFXRTNQejAxdko3Z0pKcStwbFBzb2MxelBrbThwdUs1RDZU?=
 =?utf-8?B?a2dBeUpOb2dHR0s4OVVuSGVER0hxSi9lWk1EYmVGQm1ybWFsRkhJRnRyaUdU?=
 =?utf-8?B?VFJNZkhnVjU0SFkrUDFrNExHSkhXQnpkeTJ4Y0xhU3Z4WTN1YVROQUZuUW1m?=
 =?utf-8?B?L1AvME1PS1NoZlFLYUtBeWpCTkI0bXFaZFU1TEgrQ1M3ZjZtMlNsS2hPOFdW?=
 =?utf-8?B?bm00TWY1RXFsWER4OGNDanRMb0VQZW4zZWxBWVBvbi9EeVFPa2FEUU1CZlEr?=
 =?utf-8?B?emtwbEV5RU9UKy85K1ZRM2RGZ3ZQMjl3SE9RQlhzeFBhKzU5ODR0NWFyb3VU?=
 =?utf-8?B?QVZyemRxZVlCTG16enlyTDlQN1UyOVRRbXlvQUNSQlhMS3BPclNSRjVJN0NV?=
 =?utf-8?B?N3dUbCt1RFFUK0J2WnF3Z2xscEtwR0xHRlppZEYzc21nVWdScE5qbmQxQXJM?=
 =?utf-8?B?S240cHcxbkl4dktTaGc4Y0FaS1NBWXdSS1lCcEs5cXJPYUZESzVFTk56dncw?=
 =?utf-8?B?d2VhYkRtRXh6Y0NSWm9YUmhTNkwzUGZTc3RNKytJMFJ1c28zYWY2TFNuUjV1?=
 =?utf-8?B?MDhkQTZDQmlzQndMQ2dDb09RZ0JmMjJ6WTJMVGowQTBaWkxWbGZjVlJKZWpz?=
 =?utf-8?B?dllId010Y3RFSDl3SWJEenJsZW1mWmlmZ2FwV1RaTU53Y1lUNjd3MVIxZUFQ?=
 =?utf-8?B?WlJtNytOTTN2bU1NakNmdmgyeFpVblRyblMzUy82WmhaOGlEY2dOY2JLSVFk?=
 =?utf-8?B?K09yeU5IeEp2djVpdUxvR1RVaVhDU1QyYTU2V2FwNnI4THNNOVBiZVBlN1dj?=
 =?utf-8?B?bXZKL1R0R1RyK0M0UWh2VVJvWWd1VE16SjZzMklkRlRvOEQ3MTFEWnRXOVlW?=
 =?utf-8?B?U25HYVJxTW4wNGpnU0MzYURqUmxqS0k0bHJYaEdLU2txMFNuOWY1WmVsUGw5?=
 =?utf-8?B?emNDRUtlREd4ZTA5c1BpcjgzVEZnR2oxVzJLTjViNVZhYjBLRHYzN2hYKzZ5?=
 =?utf-8?B?elJ4SjJrczBaQ21aZVhLUm1qWUhWbFpBV010Z3NIbEh3dGxDZTlLZFRldTNw?=
 =?utf-8?B?Wmc0K0llVmhxZzV1SXdKK1ZSQm1VbTl6djJtRWVHV3N2bktxQ1FiZmQzVWtq?=
 =?utf-8?B?cS9GQmN3SUlIeGhoRHFvdGMzZHg1dzAvSmpYRWJIUUxrb01BWGlEOUxRa2Rl?=
 =?utf-8?B?OVJnWnZqWE9CYnJmVDNFOVFyR1g4OEwxQWliU0tLZ05LRHpHWE9uVmJGN0sw?=
 =?utf-8?B?bTlXMzZHNitObnZNMTJkWHhqSlptbzhIQXJIUTdOQUsrTUsweStVNmpKQ1ZC?=
 =?utf-8?B?Y1oyWlVSMk1vRnczWjBQTnNVMmc3aEtqZGFDUkhDWHhHcDlLMmdsL2lZQ2Fy?=
 =?utf-8?B?eEkrTDIwYitnY1kzL0UxbU1DTzJ5SURsMXFMdlAvYkE3bUVnZmVtZWFOWENu?=
 =?utf-8?B?WnRYb1pRVmwxalNRb2s3MGhOanBGVXorWDJrdHpjMDN0R3MybzJ3V3Z3SVEy?=
 =?utf-8?B?TjdzTG16RlFBOWJwZGV1SXR3MlVQdDN4cENhOXladDBCRnVtRXFnWnpSVkVo?=
 =?utf-8?B?QXMvZXpKUnhWMmRnem01ZEN3RWNpWm9JdkdzeEphSkZTWHVqeTRxa2VoN1JN?=
 =?utf-8?B?Z2hrZmlrRTVZUWd2bW9wbFE2U3JVZTFHTnBCamVHWk9ZZDZTLy93YXFjd0lp?=
 =?utf-8?B?Qk95YzEwSWpaT2F4TVZlL0FQOTAvRDZVd25vcSsyMW5JZDZaUTIvczJXYVJN?=
 =?utf-8?B?WmdJbFN6YlVPZEhLSENDUnZXbFAxQ0VOYjdKZExFRTgvK0N3LzR1RlpWYjlE?=
 =?utf-8?B?eTNDOFAyRE9iSy84UmVxV05na0FybzhQNHQ4dzVraXRobjhoVnVtcno3VWRp?=
 =?utf-8?B?eGY3NGJtT1V2VlRIRUpaazlsUW9RUFZ5bHZHTzJwcWFFU1k0ZUJPc2pMQzhX?=
 =?utf-8?B?b0JXT2lhMnhySFBmT0wyTXJPSjR0TzMycWNwWUE1bmtHRmZnZDNCdmxxWXNS?=
 =?utf-8?B?Mnc9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 400e230c-7db2-4970-0239-08dae04fbdaa
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2022 16:57:11.6357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yF+nscuZmNjM4n6cKP1UnJofLZTG+Fl7hPDazguGnMLrLCTVPvxo1uFFFEl18rsb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2197
X-Proofpoint-GUID: ysaLcd5Be8gWyHgbrQzwP_P2Xp5FqmbL
X-Proofpoint-ORIG-GUID: ysaLcd5Be8gWyHgbrQzwP_P2Xp5FqmbL
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 5 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-17_08,2022-12-15_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/22 10:54 PM, Hao Sun wrote:
> 
> 
>> On 17 Dec 2022, at 1:07 PM, Yonghong Song <yhs@meta.com> wrote:
>>
>>
>>
>> On 12/14/22 11:49 PM, Hao Sun wrote:
>>> Hi,
>>> The following KASAN report can be triggered by loading and test
>>> running this simple BPF prog with a random data/ctx:
>>> 0: r0 = bpf_get_current_task_btf      ;
>>> R0_w=trusted_ptr_task_struct(off=0,imm=0)
>>> 1: r0 = *(u32 *)(r0 +8192)       ;
>>> R0_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
>>> 2: exit
>>> I've simplified the C reproducer but didn't find the root cause.
>>> JIT was disabled, and the interpreter triggered UAF when executing
>>> the load insn. A slab-out-of-bound read can also be triggered:
>>> https://pastebin.com/raw/g9zXr8jU
>>> This can be reproduced on:
>>> HEAD commit: b148c8b9b926 selftests/bpf: Add few corner cases to test
>>> padding handling of btf_dump
>>> git tree: bpf-next
>>> console log: https://pastebin.com/raw/1EUi9tJe
>>> kernel config: https://pastebin.com/raw/rgY3AJDZ
>>> C reproducer: https://pastebin.com/raw/cfVGuCBm
>>
>> I I tried with your above kernel config and C reproducer and cannot reproduce the kasan issue you reported.
>>
>> [root@arch-fb-vm1 bpf-next]# ./a.out
>> func#0 @0
>> 0: R1=ctx(off=0,imm=0) R10=fp0
>> 0: (85) call bpf_get_current_task_btf#158     ; R0_w=trusted_ptr_task_struct(off=0,imm=0)
>> 1: (61) r0 = *(u32 *)(r0 +8192)       ; R0_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
>> 2: (95) exit
>> processed 3 insns (limit 1000000) max_states_per_insn 0 total_states 0 peak_states 0 mark_read 0
>>
>> prog fd: 3
>> [root@arch-fb-vm1 bpf-next]#
>>
>> Your config indeed has kasan on.
> 
> Hi,
> 
> I can still reproduce this on a latest bpf-next build: 0e43662e61f25
> (“tools/resolve_btfids: Use pkg-config to locate libelf”).
> The simplified C reproducer sometime need to be run twice to trigger
> the UAF. Also note that interpreter is required. Here is the original
> C reproducer that loads and runs the BPF prog continuously for your
> convenience:
> https://pastebin.com/raw/WSJuNnVU
> 

I still cannot reproduce with more than 10 runs. The config has jit off 
so it already uses interpreter. It has kasan on as well.
# CONFIG_BPF_JIT is not set

Since you can reproduce it, I guess it would be great if you can 
continue to debug this.

>>
>>> ==================================================================
>>> BUG: KASAN: use-after-free in ___bpf_prog_run+0x7f35/0x8fd0
>>> kernel/bpf/core.c:1937
>>> Read of size 4 at addr ffff88801f1f2000 by task a.out/7137
>>> CPU: 3 PID: 7137 Comm: a.out Not tainted
>>> 6.1.0-rc8-02212-gef3911a3e4d6-dirty #137
>>> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux
>>> 1.16.1-1-1 04/01/2014
>>> Call Trace:
[...]
