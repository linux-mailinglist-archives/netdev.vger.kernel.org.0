Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEAAC64F696
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 01:53:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiLQAxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 19:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiLQAwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 19:52:42 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A13486E9FC;
        Fri, 16 Dec 2022 16:52:09 -0800 (PST)
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BGNH4Yg022177;
        Fri, 16 Dec 2022 16:51:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=kIeJNwjN0y3bCm4FZkrKcgn/uPh2d0LROT9ML1JHNRM=;
 b=h2ju2jDVeF2FeDr+8hbqV4mx0dO+sMXx2EZBURF2PrijQSl6LYeUuDAf67zth9VPBFwg
 NJcvAwNDIVGqCBv+ZKtyCfoqiOMNHA2Q12LSqHCGI83TRzZ22sZMg/3ukECY9IFpYJB1
 533AFE8wyk6d5Mf/XlikYdw/xCla8cM1f278958Fxgr0LIurzw3tFVjCJURy9i2sper6
 saVZbciT8jUDuX0egkprByZ4zc8Y4sza+Lx+kVB2SAID7recdWdke/Fc/zu6BCU8/9yh
 ARUQQH0b/LtaI1Am/3gZqx1AYRQPZtMz0qIthdgc96qMKix3n8YP5NHUHnTkqeYgNnqs 4w== 
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2177.outbound.protection.outlook.com [104.47.73.177])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3mg3hj3xed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 16:51:54 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=amGZxNYBezURPccLYPMXPpjIrbevzDEkquvuCm8V2EEMTYzwwnVEoPXEEVIhqsREnFDGj4afBRLXJZwnXsL6fg4DqKd54kuGQjEon1Ywe+x0pWkwCsSXDFePaV49RKtyZUsjx7KyvP3w80Y2zGYjw9t6pDIDsq76sxh49CJoL2ryWmgXvgtAoxNgMBcRmat0PYNUDezDFZP3fwGxW6hMAN0ncKH4vms20bD99ZmT6dTn/9FbgHdhaIEFbax+WWR8pdxOebvhb1yZLHDxUIt7c7LVOS7dtYPGHR3mIpxnJek8w9kXaOtgRxYzpIXO6CdkwVk0mPSUH/9BnBxyHyv/RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kIeJNwjN0y3bCm4FZkrKcgn/uPh2d0LROT9ML1JHNRM=;
 b=ET+fj8lAGhCqOuwgsuhsvL7WAvRagrQaVezjfn1dFvLBE44qCbG/yv5Vn2d7MVEZ1QuJC+fFdZhtyjLn5rMjYSeNqfJvZ7/Plu+YJ2thS4AM1QIPIDXNu3+Pih1h3erHGDPwpgic3K/akjKd8NbrsI+jk6sdubVaSRd25pqVoxFK/29Y8BmFphYT9EBMitpEXyHo3GcruIpow3Xk1ZUc/8rRFvz5s8tq+aFE4KwxbBdTsPExiJNst5RDDbKCIWLCE0Fd6hCNUd8sDL9Mf3/3VGNS/niLolqii7TaVDCAHaDVz8q/+2/X0OdxEfaxo06YSpO6cLQFAJ1pQtqJQ4QI7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CY4PR15MB1367.namprd15.prod.outlook.com (2603:10b6:903:fa::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.12; Sat, 17 Dec
 2022 00:51:51 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0%4]) with mapi id 15.20.5924.015; Sat, 17 Dec 2022
 00:51:51 +0000
Message-ID: <b4506cd4-41b0-9358-0b96-dda84c72cd17@meta.com>
Date:   Fri, 16 Dec 2022 16:51:48 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [bpf-next 0/5] samples: bpf: enhance syscall tracing program
Content-Language: en-US
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Yonghong Song <yhs@fb.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20221215113937.113936-1-danieltimlee@gmail.com>
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <20221215113937.113936-1-danieltimlee@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|CY4PR15MB1367:EE_
X-MS-Office365-Filtering-Correlation-Id: 9993b860-de79-4ffe-f8b5-08dadfc8e27a
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IJPWcIEPgaemB5MA3WvCt6ipylIdLxfoMeQS4ibWSKpQWiqdmwTMWQOu0EEOv5DpxZviYrtK9KqwQKasB90IL14ta91VACwE4BZHIf847/NeONJJYxkg8zOOfTxjxyOjpH7/JNNVuxTkqPiKwofne53KXs5Z5Zp72BCeng0NlMYzX1aqBriU+W8fYgFtzcKzPEbEAdAFeYJxZobI9rSg1ahlCSTmPCMTS034xuoMx3/6zpHh98AS0e+W/jFnDKZfpnacT55Ukp+Lm9wcR6L8enu7arlFat8b80OQD25yfQ4p2ifDEuA47W6y0M5eOr7k1HFHo6byK6IsjzwAX8oVbGkzqe+SgWmx+GibkznIgsMwcxteLlMw4XVUpvSuELEn/rq9k6/H4z1Ini4RawF+MprOmIxbWeNR/YYKVbzNuRW73MBS3gCTTMJHcNGhkX8q/YgGFrPjNE+vRd48Idl6kRCmJJZ8tBosM11wKbaZh5159prwQ/OnfkpM9dM0Lz6scVcAZokNEQgl36OoCNcGemeU3srmPhH1iXEcvvNijglK6E76Awm+0cHTYIwUDAbwcyqCHoG5vitmG5HUM4RJZhsyVtA14nYGADLDF54E2/E7tPVclsrcdZ1q+A1dH1WSz7yoVVj1s75N8U3AShwcO/wrVo/7nCdMKDcgcve9XJdYcqh0ElTToeqPImYrPCogf0rRMQtG1LEjG60vudS/0mcR7tMMjaIQ1UtceelFx4sFLdNKnFK05zyPG/H5U8eah6q6Q5XfPhcRhR68NO3sLKALA4EzmC2eYDaNIT9Un9r2klz1wER15QNO3klxw/C6
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(451199015)(53546011)(6506007)(66476007)(66556008)(186003)(5660300002)(6512007)(36756003)(8676002)(83380400001)(2616005)(4326008)(8936002)(31686004)(66946007)(6486002)(316002)(966005)(478600001)(2906002)(6666004)(38100700002)(86362001)(31696002)(41300700001)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?djhXVTkrVSszTVdJNkFscGNVa3FtSkM3N05hVHlvUnFKbnJjVXkxQ09Kc3cv?=
 =?utf-8?B?MkxxZytiTURVcVNVc010ZkdRSWZGVkpWUys0b3ZhOUdoZzBnTy9UM0JJUFdF?=
 =?utf-8?B?Ky9SYXQzWWVxa09CMkYyb0pHbHIvQTNQVTNtZFlqV01td1RZeFlCMmhYWE80?=
 =?utf-8?B?Mmd3MWtBZExXY0dYMEV6bXEwdE9yTWoyb0JhWjQ0UkVyYnVNQWYvWWxsUC83?=
 =?utf-8?B?ZzB6NTNlbVAwQTBFUE1LQlUvNTN6YjlkTmNpdW1BV3JUaWMyaGFMKzhxRzM0?=
 =?utf-8?B?amovUmRYbVJoQ0hOQzNTTXNRczdtdkNsK3laS1JiTkJyNUM5T1ZJUGx1OVNG?=
 =?utf-8?B?bzRzS1ZvZDBHMHNUMEY2UFFESk8rdGZNV0pTdzBjZEdaSEFNdURCeG44dGNN?=
 =?utf-8?B?WHF2aHhtYndyeDVicXZldks2R0d6KzF6REtST3BkR3JEdmwrdFMvNDVYQll1?=
 =?utf-8?B?RW9ScTc2Z21PUnIvbTgwTXRMQnBlcWhiMnRrTlFDcEI0SWhJT2p3bDVhaW5J?=
 =?utf-8?B?QjdJTkFrQXhhekMrK1pCSWF4ZXNqbnZ3emJkN1l1QmZ6dFVJRFFkQWRkQWd1?=
 =?utf-8?B?dDAwK2RLNXdXYXk3bGs3UDY5bEpERnlUejFqWTJBQzViMFRocFhNdzRGR2Z3?=
 =?utf-8?B?ZCtjY2g3eWQxUXQ5dWRFKzRZeDl1a0lFbFNGT2VKenFVVFV3Nmk2alhhSHd5?=
 =?utf-8?B?ZVovYm9oMERNS0h3QlRveUhQbTZhbC9nMVlYekNEMmxkeUtYV1V5TnBQZzNQ?=
 =?utf-8?B?TlA5STZ1cW5aWWhkbDhVU2pQdkVNTGFKazZ3UWNDQTdLY1RnMVJDcU5tUWZp?=
 =?utf-8?B?Uys5b04yT3IzT3RDY2FwSHhQY0FIRnlaZFpOM2JEdFVBOENuK3h5NllMQ0R0?=
 =?utf-8?B?OFZVa2ZPRHNsT0w2d2IzWEdtbnBBUEE1L2hlYXZBaHl2aGRaZTh4d1Z3UXgz?=
 =?utf-8?B?OHZBN1UycDQ0TkQ5bkh6SmdwcVNoZ3NCZVJDSzUva3dHQ3cxYlREb3gyYWtl?=
 =?utf-8?B?RFBkbXFFd0wyOHJIcFJEb1NERExTdFArelJYM2IxTjVNVUpiSVM4VGtuWkcz?=
 =?utf-8?B?TGxPbko2cnBNbklqZGxVcGhrazJmRmhHOURLOHBWd1M2b0VmQndKSUVDK21x?=
 =?utf-8?B?YkVDQUU3R3JOMDZpWWFwY2o1ODFvRE5maUZObnEwSmRzMXJCNjEwK29NTWxH?=
 =?utf-8?B?REZPNUZENURzS1cweStKcmtrMmhkVWgyQk8yaHc2b0dCaW05OTZiNzQrcGM2?=
 =?utf-8?B?V0VidlZsUzRiRy9tRDFDN0l6aEpUTmVZVmRNc21GbFpDLzBFY2J0N3dhcjlW?=
 =?utf-8?B?ZEM3ZmRzbVlDam9GeHVadmxaSWNnSVZacG1HNlJIbHRuL2Q1bjVZNWpZRXNq?=
 =?utf-8?B?V2duVE43YnkzZ1dsb2RBR0E2bWxwVXlHK0JDSzdUWURMTldDTktCaTlkVzhI?=
 =?utf-8?B?SzNzdFR2Wm5jK1dYRDNRQmtiMFg2S2hOcmJuOFlBcm9qdE1JZCt2YTJZUjIy?=
 =?utf-8?B?ek5IMmVHNndOL1ZFbmNPTmszL2tGMk5QdjhyV2R2SzZTT0ZYa3IvSE5nSW9w?=
 =?utf-8?B?d1pycmsvRGZ5WUVNcEVVL0ZRNG9sSVlTUG5NdDM0L0FLTmJQc1p5L0MzYTFS?=
 =?utf-8?B?MlBDMXg4ZFcvMmJSOU56elRJWkJZY3hxclBYUzA3OHpVS3RjVlNSZmQ1SmV0?=
 =?utf-8?B?NXZoSGZuZW1rMXVmSjB6RjFZcG5VN0dVWVpJUkNvSlRQbXZNTHEySnBXcks2?=
 =?utf-8?B?ZkFZV0w2dW9SRlhsRHNnNWRZNlc4YjdjTUsvUFRTNk1pcVljUVM3bldXdFV6?=
 =?utf-8?B?RXhsZUVxcndDRnVKUjAyM0FMdGxGRHlmQ1FTUGRlaFozZkp4Uy8rN1YxKzdo?=
 =?utf-8?B?R2hBaGxJWE5mazl3TEFrUStoVW1OYWpzRmE2Z1hTbHhKcGMzZWpycmp3YVJX?=
 =?utf-8?B?R0FNUXludVpRWGJ5MEFmMDNDOFR5eVRoenVLckQxYzdKVzhva3RSbmdJck13?=
 =?utf-8?B?cmo0TUI1YUNoRTRCT2wxNXFiNHp3TXU1SHVSc2NERVNjcjdDN3QvV3Fkd2tM?=
 =?utf-8?B?MnFyRlc1b3F0bGR1WmY3SGJKd0t5SWRFcUZzUExhdFRIL2lJanpPanJqTjRK?=
 =?utf-8?B?YXlvTlhDdEdTenJONEsvd0xXYkt2aTY0MFlLa29JeEltYVF2cDRiaVVOWkRG?=
 =?utf-8?B?QlE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9993b860-de79-4ffe-f8b5-08dadfc8e27a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2022 00:51:51.3915
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kilgaYVNFAqeW5razsuON+qDztrg/xTsWoVFJlrOKXhM1GtgTnXd1ATcNNPCofbM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1367
X-Proofpoint-GUID: 6dt-VEfAQDrbhNhEl5cEgNaD1QFhb7wI
X-Proofpoint-ORIG-GUID: 6dt-VEfAQDrbhNhEl5cEgNaD1QFhb7wI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-16_15,2022-12-15_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/15/22 3:39 AM, Daniel T. Lee wrote:
> Syscall tracing using kprobe is quite unstable. Since it uses the exact
> name of the kernel function, the program might broke due to the rename
> of a function. The problem can also be caused by a changes in the
> arguments of the function to which the kprobe connects. This commit
> enhances syscall tracing program with the following instruments.
> 
> In this patchset, ksyscall is used instead of kprobe. By using
> ksyscall, libbpf will detect the appropriate kernel function name.
> (e.g. sys_write -> __s390_sys_write). This eliminates the need to worry
> about which wrapper function to attach in order to parse arguments.
> Also ksyscall provides more fine method with attaching system call, the
> coarse SYSCALL helper at trace_common.h can be removed.
> 
> Next, BPF_SYSCALL is used to reduce the inconvenience of parsing
> arguments. Since the nature of SYSCALL_WRAPPER function wraps the
> argument once, additional process of argument extraction is required
> to properly parse the argument. The BPF_SYSCALL macro will reduces the
> hassle of parsing arguments from pt_regs.
> 
> Lastly, vmlinux.h is applied to syscall tracing program. This change
> allows the bpf program to refer to the internal structure as a single
> "vmlinux.h" instead of including each header referenced by the bpf
> program.
> 
> Additionally, this patchset changes the suffix of _kern to .bpf to make
> use of the new compile rule (CLANG-BPF) which is more simple and neat.
> By just changing the _kern suffix to .bpf will inherit the benefit of
> the new CLANG-BPF compile target.
> 
> Daniel T. Lee (5):
>    samples: bpf: use kyscall instead of kprobe in syscall tracing program
>    samples: bpf: use vmlinux.h instead of implicit headers in syscall
>      tracing program
>    samples: bpf: change _kern suffix to .bpf with syscall tracing program
>    samples: bpf: fix tracex2 by using BPF_KSYSCALL macro
>    samples: bpf: use BPF_KSYSCALL macro in syscall tracing programs

Please change 'samples: bpf" to "samples/bpf".
Also, bpf CI reported some new warnings and failures:

https://github.com/kernel-patches/bpf/actions/runs/3708274678/jobs/6285674300

     CLANG-bpf  /tmp/work/bpf/bpf/samples/bpf/tracex4_kern.o
   /tmp/work/bpf/bpf/samples/bpf/xdp_fwd_user.c: In function ‘main’:
   /tmp/work/bpf/bpf/samples/bpf/xdp_fwd_user.c:85:44: warning: ‘_prog’ 
directive output may be truncated writing 5 bytes into a region of size 
between 2 and 9 [-Wformat-truncation=]
      85 |  snprintf(prog_name, sizeof(prog_name), "%s_prog", app_name);
         |                                            ^~~~~
   In file included from /usr/include/stdio.h:867,
                    from /tmp/work/bpf/bpf/samples/bpf/xdp_fwd_user.c:19:
   /usr/include/x86_64-linux-gnu/bits/stdio2.h:67:10: note: 
‘__builtin___snprintf_chk’ output between 13 and 20 bytes into a 
destination of size 16
      67 |   return __builtin___snprintf_chk (__s, __n, 
__USE_FORTIFY_LEVEL - 1,
         | 
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      68 |        __bos (__s), __fmt, __va_arg_pack ());
         |        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     CC      /tmp/work/bpf/bpf/samples/bpf/syscall_nrs.s

...

     CLANG-BPF 
/tmp/work/bpf/bpf/samples/bpf/test_current_task_under_cgroup.bpf.o
   In file included from 
/tmp/work/bpf/bpf/samples/bpf/test_probe_write_user.bpf.c:8:
   In file included from /usr/include/string.h:26:
   In file included from 
/usr/include/x86_64-linux-gnu/bits/libc-header-start.h:33:
   In file included from /usr/include/features.h:485:
   /usr/include/x86_64-linux-gnu/gnu/stubs.h:7:11: fatal error: 
'gnu/stubs-32.h' file not found
   # include <gnu/stubs-32.h>
             ^~~~~~~~~~~~~~~~
   1 error generated.
   make[3]: *** [/tmp/work/bpf/bpf/samples/bpf/Makefile:394: 
/tmp/work/bpf/bpf/samples/bpf/test_probe_write_user.bpf.o] Error 1
   make[3]: *** Waiting for unfinished jobs....
   In file included from 
/tmp/work/bpf/bpf/samples/bpf/map_perf_test.bpf.c:8:
   In file included from /usr/include/errno.h:25:
   In file included from /usr/include/features.h:485:
   /usr/include/x86_64-linux-gnu/gnu/stubs.h:7:11: fatal error: 
'gnu/stubs-32.h' file not found
   # include <gnu/stubs-32.h>
             ^~~~~~~~~~~~~~~~
   1 error generated.
   make[3]: *** [/tmp/work/bpf/bpf/samples/bpf/Makefile:394: 
/tmp/work/bpf/bpf/samples/bpf/map_perf_test.bpf.o] Error 1
   make[2]: *** [/tmp/work/bpf/bpf/Makefile:1994: 
/tmp/work/bpf/bpf/samples/bpf] Error 2
   make[2]: Leaving directory '/tmp/work/bpf/bpf/kbuild-output'
   make[1]: *** [Makefile:231: __sub-make] Error 2
   make[1]: Leaving directory '/tmp/work/bpf/bpf'
   make: *** [Makefile:269: all] Error 2
   make: Leaving directory '/tmp/work/bpf/bpf/samples/bpf'
   Error: Process completed with exit code 2.

Please check bpf ci https://github.com/kernel-patches/bpf
and fix the above issues properly.

> 
>   samples/bpf/Makefile                          | 10 ++--
>   ...p_perf_test_kern.c => map_perf_test.bpf.c} | 48 ++++++++-----------
>   samples/bpf/map_perf_test_user.c              |  2 +-
>   ...c => test_current_task_under_cgroup.bpf.c} | 11 ++---
>   .../bpf/test_current_task_under_cgroup_user.c |  2 +-
>   samples/bpf/test_map_in_map_kern.c            |  1 -
>   ...ser_kern.c => test_probe_write_user.bpf.c} | 20 ++++----
>   samples/bpf/test_probe_write_user_user.c      |  2 +-
>   samples/bpf/trace_common.h                    | 13 -----
>   ...trace_output_kern.c => trace_output.bpf.c} |  6 +--
>   samples/bpf/trace_output_user.c               |  2 +-
>   samples/bpf/{tracex2_kern.c => tracex2.bpf.c} | 13 ++---
>   samples/bpf/tracex2_user.c                    |  2 +-
>   13 files changed, 51 insertions(+), 81 deletions(-)
>   rename samples/bpf/{map_perf_test_kern.c => map_perf_test.bpf.c} (85%)
>   rename samples/bpf/{test_current_task_under_cgroup_kern.c => test_current_task_under_cgroup.bpf.c} (84%)
>   rename samples/bpf/{test_probe_write_user_kern.c => test_probe_write_user.bpf.c} (71%)
>   delete mode 100644 samples/bpf/trace_common.h
>   rename samples/bpf/{trace_output_kern.c => trace_output.bpf.c} (82%)
>   rename samples/bpf/{tracex2_kern.c => tracex2.bpf.c} (89%)
> 
