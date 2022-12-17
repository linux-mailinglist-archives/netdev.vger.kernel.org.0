Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEBAF64F7BC
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 06:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiLQFIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 00:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiLQFIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 00:08:04 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D73A6C704;
        Fri, 16 Dec 2022 21:08:02 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BH4XYdf012432;
        Fri, 16 Dec 2022 21:07:41 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=Pr4TBrdCvhF+Ufnu/pgPoOxzyOqMNrxUISYvNuiy1pk=;
 b=ULdp88gwTCIh41QvYOaD/bxi9g311i0ZvCgJuiUUl0r7lawx0hqHP43ax4aYd/DrRX3x
 Rs0AthOuVLrd2jPImB5JA4wms7fFoT7XvqBJ05Kj9Bo5a6N4JfLEAJJIjMTxpaLmPwfT
 bLmeHKYYukAUj81SQn8jea9/7V5OlwEHRNjgGYjl7ywL0pnA7inOutWEiGpDVsZwd9D+
 raq8fEeOQolDrOarXbuTamH8MmAAQlpV/hIg4fDW86YnUmDkdYfbw5TExeDDBh2rAKf1
 8DJhfwTrbrT7BfzXRTiWLEhdE6L4c5eUNMziLTFTDoxofJeqAiLwZVUh5B23CBXCfPve GQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3mh6uj830a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 16 Dec 2022 21:07:41 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jGiQyYDYxXyCtxNEf33uonUAkXRXz2fdhw2igy01BkTBs0sHM6Q71Uatx1sw21hDYQiNMQ+1VgCpj+C8+SJ1ZZxUnl3wDCVuVt8JJUnqssirSMKWSTiKsawcQ4jucx7fzcPpKMhvkh+vNVdYvfJxcrG6QM5xPoP+xtkTtU3IlbC+dHtSPADoxuFvkm7YIDmh/SXx9+RPk5efMA9D3eKo/nHxV/P6bl4J5SB/h+wQkswZUdj3agUoiCDIuMgeEuAnrcnKInhy+KQxAslWdlfalRGpU1dTi+WcwKfqWddz976gkP9wy02vimFqx1Gb/p3UACJE7Q39hBvbOOMtvDwIZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cayQxYKHVZ4jTByTt4PiaRS5Rl2r2t9EyHz+96NoSVw=;
 b=mk+DXwhUI/T6TID0+JianHVW8PwAv6EJatXE0rn5QPE/CdLj5Vi9K+RU3jL9S2ekgFvFNjz1LWq2I71xcRKFG14XnjicXACR2rd3qjOlwJDLTXhTeb2exctL5H1en6orugSTbh/xqbQPe95C3lXVVmLk1PPpS+IvxT3XKgUBhG1vgUrljzD9ZruZQ6GaVbrh2o+VyMXdwtRsYXCiNaChkaIwECeh6EKBQTJ0FN7Nmx3Wd21MjjnkjROlLdEZ5Z9abC1oemOeo1X1nTAoCXQupVcOTx9HGjhEPWqnS4hYBaycti0oXgp5v9lv++oJKgD0OtE7L4yu/1+Rjg7JbbWdNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by MW4PR15MB4681.namprd15.prod.outlook.com (2603:10b6:303:10a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Sat, 17 Dec
 2022 05:07:35 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::3cc9:4d23:d516:59f0%4]) with mapi id 15.20.5924.015; Sat, 17 Dec 2022
 05:07:35 +0000
Message-ID: <52379286-960e-3fcd-84a2-3cab4d3b7c4e@meta.com>
Date:   Fri, 16 Dec 2022 21:07:32 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: KASAN: use-after-free Read in ___bpf_prog_run
Content-Language: en-US
To:     Hao Sun <sunhao.th@gmail.com>, bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
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
From:   Yonghong Song <yhs@meta.com>
In-Reply-To: <CACkBjsbS0jeOUFzxWH-bBay9=cTQ_S2JbMnAa7V2sHpp_19PPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: SJ0PR03CA0213.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::8) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|MW4PR15MB4681:EE_
X-MS-Office365-Filtering-Correlation-Id: 58b917bc-d7db-40b5-b655-08dadfec9c47
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xoX1wbbXm2hSjOfdEn3vjTfTi2R/17m8kOy57w5y9lGmEDD95NyQ5HshP2GfBGPCbtQ8XIdEt6LOxEl5BgydF6igXQA9FJNG7W2av+7TGusmXg8+qD99/nP49zV0N1hmUvY5TgSQz6jYWjllZQRWHw/nrqIkeUxEDH7ERh3Rhs+GjbCvKHwJBG0u5LNXKuYCYseDs59J56q81eHeSrDBmHZuJKOd/+ZeLomw/84OeVAPVUwICWLGF1nQDv7Sd4qMGIb0kNFMzveNDdYBUnGgpJpuQ0KgnmBk6LP/GDkA05N/T2YDYU4BPjv9zdQpOL2NtpIukkKeSHdZmptwk2FKANae/1UULXMO2i5eoWcF8srNaRMylCq0uXQ90p2TazyRJ2cGM3PhHOBDk70lFZ2M9k3QAi0XdX2BqfVyt7jHdVhKB4zWD8gpjpDfZbSBgWlVcutpKz91xTgYG4P29jXDUkpH7jMh+CExd+k57eGhKf4H8u77dbDc/SpDuRECDYrfR4vriGDMolO1tjf+9xNfqZpHP+k1evHhikRx/sCXaq5vaUWNGqyIEifTX+b6rQUMMqSwxHspUee0yBQy0nlZCSor2oi9kKbcjgEUyBouWbM6pmIfX3NG6i3UfaSifXL82sg9KEM/+yOPfJxcq3tQM0dh+Qz7+YdohoptmOAWqmAMD7nZospVqZDW8DNihbFHv7QR75u6DfNxqJEgYWx+TWAs07YlngmbOsxPNNojty3KiaGfC8ZSTUfEfrSnlWFTKc7+0k7MX6gCuiNwmJseGyOJqncydNbAaqGFI5LS5A1QmlTwuRX+CQH1q2Rnr+OEqAg1r/Sgyw1+CMbGdmVRDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(136003)(396003)(39860400002)(376002)(451199015)(4326008)(2616005)(66946007)(5660300002)(66476007)(66556008)(8676002)(36756003)(38100700002)(6512007)(83380400001)(7416002)(186003)(54906003)(110136005)(41300700001)(316002)(8936002)(31686004)(86362001)(31696002)(6666004)(84970400001)(478600001)(2906002)(53546011)(966005)(6506007)(6486002)(10126625003)(101420200003)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R2xXTjdGdnl0UEEzQmJZVmNYSGxFN3o3U2c2dlBLcXZTckpvUFpYdGM4NUxX?=
 =?utf-8?B?LzlCTDFXUFV5T3lML3RGUnF1UWZLNkZZOG5iVjQxMjd0QW4rajZGaDJYQjJC?=
 =?utf-8?B?Yk04S3JFZlg3WVM0bTFXK0RIRXFmWk93N25zekc1WGxhclY1d2hQSWxJUTRQ?=
 =?utf-8?B?OXhxbWx4NG9DbXpBVHpnSmh0Mk9Ka0hBd1YvRDJBelZyZk1Bcy8rVUZ6TzhC?=
 =?utf-8?B?UjV0RCtuQUtYVmpocHd1cFd1T3RwOVFLY2hsWnUvZERXVE9NQmlXakxPdGx5?=
 =?utf-8?B?RkZOSktMN3hvQXVic25xNGFyVzV0SnpHTkdPUEFaeWtBZzRDOFRDREx0TUt5?=
 =?utf-8?B?b2ZRbVZMcndtRmlxaXEzd3liWjE1ajZISmx5R1ZnOUIwSzRmV09ydTJ5NWk3?=
 =?utf-8?B?WDFwRXYvbHRacnNMeTBpTjVNSXQ1TUJnZXkxN2tHWWJ5RFlWQ2RHWmdFSGxC?=
 =?utf-8?B?eVFWc3FuU1FrNHU5S21seTNHTTlnRDl4U3Q1UnowcmdxM0taYlhha0RJQ1U2?=
 =?utf-8?B?SVBoakZZMWxBQ2dmS2tGV1h1Q2cySGFYNHRUQjJPVlJmdldKZ0xENXMwNXBI?=
 =?utf-8?B?eEE4TUFxL1ZUN2FwempwcnUyUGh3OS9haDJpekVBc3M2ZHBuaTYwMUF2T1Ra?=
 =?utf-8?B?L3VkNlVLTVRjZXVLNWtHNkliQVBkbWl1UnRPOThqb2cwV2dKMmdXekhuQ2Q3?=
 =?utf-8?B?cS8ydEhYbVQ1L29NTjc4VnhaWHRHaXh0WkxQZ2l4S1ZOOUJrRHJpa044K3NW?=
 =?utf-8?B?eFVHSU1nbzBGY0hSUXlORGtPc1ZjVS9maVlqR0p1ODlFcVNUYytkYTFWS2Rq?=
 =?utf-8?B?bTVCT0RLTVAxYzBzQ2ZEa1gwaXFEeXZGcW41TXg0MXA3TUFDb2RnQW1rdmFG?=
 =?utf-8?B?c3A0NTd2WU1EY2NJbS9HR3VIRjdOQWxGTjB0WnZGbmlFc3U5WUsrbDJJbDRx?=
 =?utf-8?B?NGVGNXlvOVE1OXBuUGlDVjJrNTg5b0haemV3ODhpQkxJSkNQSlowaERWbU9v?=
 =?utf-8?B?VW5LQTFiaWU0aTJtQVlIbkNnVmRsRXBiZ20wazRaMHcrd01zeVlkSmV4V015?=
 =?utf-8?B?ZVhVS2ZxRlRyRnNpekNQN1FEN29LWlMrd1daaVpGcGgyeDl5TzJvTTVDdVVo?=
 =?utf-8?B?SFQvWWdPQ3U0NzhTMlBGNm1BQVJMWDIxSVY2azlGL3Y2VDREN3UrR3pqV1JQ?=
 =?utf-8?B?UEtoNkhOb3ZSaTdpRlFCc0RyUnN3MU51UWNMMm5za0RWZ3JDV1dtZDF0bmk1?=
 =?utf-8?B?TGQwb2IyWUNON2dZRkUzQW5GNGwrOHAybXZodGkvQjFReWI3d3ltVm9FSjVT?=
 =?utf-8?B?aWNkVDJwZ1VlOU1TdlptbWhWcHZNRUVJZythRkVsWS84Z0M2aDQ4OEZ3WXhL?=
 =?utf-8?B?UUFDSlgzQkpvakZhMDUva1hGcWFEVnVZUENMS2MxRm5Ua0dOSjlCK3dreFNH?=
 =?utf-8?B?THQzQkhWQjg3MDZmQ3VHQjZkclJSTTc5SkpTSThJVHRSYVRMTnhFVWxuQXFL?=
 =?utf-8?B?a3U1RjBSK2kyaHV5ZDFXUFZBOFNjVnZ4OUM2YnBkTGRpMmpnZ25kTUgxM256?=
 =?utf-8?B?NUtCZGN3a1h0T0JiQ0tkWW1iMklGc1hzM0p4RXdDZnJoZVZWa3FrQVBvQm5x?=
 =?utf-8?B?cTRFa1dRaUVDYVJKK3pQVUtLSjV0dTBjaDdiN1VPZEIrenBwRTN6djJFQUxz?=
 =?utf-8?B?dWo3NjkwSll6eWFTQm5BTXZrS1ZUVlZmRjc1bk96dlk3MTB5Vk80cmpHRC9k?=
 =?utf-8?B?QkRPcitpaFN3bVgySjNJWWlLQ21jTS9menRZSFlPa0pWOVdRcS9xQXhCeG9y?=
 =?utf-8?B?RHZEdytjQzQvSEZicUFvbVFhZi9rc2l3ZnlIVDU0LytwdWlNZ3pnYytZbmpO?=
 =?utf-8?B?cjd3aTZ6Y0liZ0xsN3pkak84bjVSaytJeHRXVExpc1RMR09rV2FUQlh2QXpF?=
 =?utf-8?B?cTY5UjlSa1cyeTBvTENFMkh5dExlVTF2cjhSdFM3aFdHVmM4YmpPS2VROEIr?=
 =?utf-8?B?Z1NwZURUdGFabzlHR1hDNVVJWkF0ZmFnYnRqU2pqeW52Nlg4TEZOcUhpc3d3?=
 =?utf-8?B?cjBTWjYyajdhRnd4MFFEc3ZvZnJUS3ptQVc2ZWdiQmZQSGtoQmRmQzE2N3F6?=
 =?utf-8?B?UjdGQ0ZRQXRzdWQxU2VvanVWZG53NXMyZGoraEkzVUtPVVdZN1d4QURkTE1S?=
 =?utf-8?B?TlE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b917bc-d7db-40b5-b655-08dadfec9c47
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2022 05:07:35.4973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4pc1UMSnkFmAONm/JmbeKSgEZluNA12TRv8PQ3Xt+zZuCedec94uA+QE1vbI+tQU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR15MB4681
X-Proofpoint-ORIG-GUID: mZA3qaigmorQwNpjT3JwayhjuDeKltbG
X-Proofpoint-GUID: mZA3qaigmorQwNpjT3JwayhjuDeKltbG
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 4 URL's were un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-17_01,2022-12-15_02,2022-06-22_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/14/22 11:49 PM, Hao Sun wrote:
> Hi,
> 
> The following KASAN report can be triggered by loading and test
> running this simple BPF prog with a random data/ctx:
> 
> 0: r0 = bpf_get_current_task_btf      ;
> R0_w=trusted_ptr_task_struct(off=0,imm=0)
> 1: r0 = *(u32 *)(r0 +8192)       ;
> R0_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
> 2: exit
> 
> I've simplified the C reproducer but didn't find the root cause.
> JIT was disabled, and the interpreter triggered UAF when executing
> the load insn. A slab-out-of-bound read can also be triggered:
> https://pastebin.com/raw/g9zXr8jU
> 
> This can be reproduced on:
> 
> HEAD commit: b148c8b9b926 selftests/bpf: Add few corner cases to test
> padding handling of btf_dump
> git tree: bpf-next
> console log: https://pastebin.com/raw/1EUi9tJe
> kernel config: https://pastebin.com/raw/rgY3AJDZ
> C reproducer: https://pastebin.com/raw/cfVGuCBm

I I tried with your above kernel config and C reproducer and cannot 
reproduce the kasan issue you reported.

[root@arch-fb-vm1 bpf-next]# ./a.out
func#0 @0
0: R1=ctx(off=0,imm=0) R10=fp0
0: (85) call bpf_get_current_task_btf#158     ; 
R0_w=trusted_ptr_task_struct(off=0,imm=0)
1: (61) r0 = *(u32 *)(r0 +8192)       ; 
R0_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
2: (95) exit
processed 3 insns (limit 1000000) max_states_per_insn 0 total_states 0 
peak_states 0 mark_read 0

prog fd: 3
[root@arch-fb-vm1 bpf-next]#

Your config indeed has kasan on.

> 
> ==================================================================
> BUG: KASAN: use-after-free in ___bpf_prog_run+0x7f35/0x8fd0
> kernel/bpf/core.c:1937
> Read of size 4 at addr ffff88801f1f2000 by task a.out/7137
> 
> CPU: 3 PID: 7137 Comm: a.out Not tainted
> 6.1.0-rc8-02212-gef3911a3e4d6-dirty #137
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux
> 1.16.1-1-1 04/01/2014
> Call Trace:
> <TASK>
> __dump_stack lib/dump_stack.c:88 [inline]
> dump_stack_lvl+0x100/0x178 lib/dump_stack.c:106
> print_address_description mm/kasan/report.c:284 [inline]
> print_report+0x167/0x46c mm/kasan/report.c:395
> kasan_report+0xbf/0x1e0 mm/kasan/report.c:495
> ___bpf_prog_run+0x7f35/0x8fd0 kernel/bpf/core.c:1937
> __bpf_prog_run32+0x9d/0xe0 kernel/bpf/core.c:2045
> bpf_dispatcher_nop_func include/linux/bpf.h:1082 [inline]
> __bpf_prog_run include/linux/filter.h:600 [inline]
> bpf_prog_run include/linux/filter.h:607 [inline]
> bpf_test_run+0x38e/0x980 net/bpf/test_run.c:402
> bpf_prog_test_run_skb+0xb67/0x1dc0 net/bpf/test_run.c:1187
> bpf_prog_test_run kernel/bpf/syscall.c:3644 [inline]
> __sys_bpf+0x1293/0x5840 kernel/bpf/syscall.c:4997
> __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
> __se_sys_bpf kernel/bpf/syscall.c:5081 [inline]
> __x64_sys_bpf+0x78/0xc0 kernel/bpf/syscall.c:5081
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fb8adae4469
> Code: 00 f3 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48
> 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
> 01 f0 ff ff 73 01 c3 48 8b 0d ff 49 2b 00 f7 d8 64 89 01 48
> RSP: 002b:00007fff514ad148 EFLAGS: 00000203 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb8adae4469
> RDX: 0000000000000025 RSI: 0000000020000200 RDI: 000000000000000a
> RBP: 00007fff514ae2f0 R08: 00007fb8adb2dd70 R09: 00000b4100000218
> R10: e67c061720b91d86 R11: 0000000000000203 R12: 000055ed87c00760
> R13: 00007fff514ae3d0 R14: 0000000000000000 R15: 0000000000000000
> </TASK>
> 
> Allocated by task 7128:
> kasan_save_stack+0x20/0x40 mm/kasan/common.c:45
> kasan_set_track+0x25/0x30 mm/kasan/common.c:52
> __kasan_slab_alloc+0x84/0x90 mm/kasan/common.c:325
> kasan_slab_alloc include/linux/kasan.h:201 [inline]
> slab_post_alloc_hook mm/slab.h:737 [inline]
> slab_alloc_node mm/slub.c:3398 [inline]
> kmem_cache_alloc_node+0x166/0x410 mm/slub.c:3443
> alloc_task_struct_node kernel/fork.c:171 [inline]
> dup_task_struct kernel/fork.c:966 [inline]
> copy_process+0x5db/0x6f40 kernel/fork.c:2084
> kernel_clone+0xe8/0x980 kernel/fork.c:2671
> __do_sys_clone+0xc0/0x100 kernel/fork.c:2812
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Freed by task 0:
> kasan_save_stack+0x20/0x40 mm/kasan/common.c:45
> kasan_set_track+0x25/0x30 mm/kasan/common.c:52
> kasan_save_free_info+0x2e/0x40 mm/kasan/generic.c:511
> ____kasan_slab_free mm/kasan/common.c:236 [inline]
> ____kasan_slab_free+0x15e/0x1b0 mm/kasan/common.c:200
> kasan_slab_free include/linux/kasan.h:177 [inline]
> slab_free_hook mm/slub.c:1724 [inline]
> slab_free_freelist_hook+0x10b/0x1e0 mm/slub.c:1750
> slab_free mm/slub.c:3661 [inline]
> kmem_cache_free+0xee/0x5b0 mm/slub.c:3683
> put_task_struct include/linux/sched/task.h:119 [inline]
> delayed_put_task_struct+0x274/0x3e0 kernel/exit.c:178
> rcu_do_batch kernel/rcu/tree.c:2250 [inline]
> rcu_core+0x835/0x1980 kernel/rcu/tree.c:2510
> __do_softirq+0x1f7/0xaf6 kernel/softirq.c:571
> 
> Last potentially related work creation:
> kasan_save_stack+0x20/0x40 mm/kasan/common.c:45
> __kasan_record_aux_stack+0xbf/0xd0 mm/kasan/generic.c:481
> call_rcu+0x9e/0x790 kernel/rcu/tree.c:2798
> put_task_struct_rcu_user kernel/exit.c:184 [inline]
> put_task_struct_rcu_user+0x83/0xc0 kernel/exit.c:181
> release_task+0xe9e/0x1ae0 kernel/exit.c:234
> wait_task_zombie kernel/exit.c:1136 [inline]
> wait_consider_task+0x17d8/0x3e70 kernel/exit.c:1363
> do_wait_thread kernel/exit.c:1426 [inline]
> do_wait+0x75f/0xdc0 kernel/exit.c:1543
> kernel_wait4+0x153/0x260 kernel/exit.c:1706
> __do_sys_wait4+0x147/0x160 kernel/exit.c:1734
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> Second to last potentially related work creation:
> kasan_save_stack+0x20/0x40 mm/kasan/common.c:45
> __kasan_record_aux_stack+0xbf/0xd0 mm/kasan/generic.c:481
> call_rcu+0x9e/0x790 kernel/rcu/tree.c:2798
> put_task_struct_rcu_user kernel/exit.c:184 [inline]
> put_task_struct_rcu_user+0x83/0xc0 kernel/exit.c:181
> release_task+0xe9e/0x1ae0 kernel/exit.c:234
> wait_task_zombie kernel/exit.c:1136 [inline]
> wait_consider_task+0x17d8/0x3e70 kernel/exit.c:1363
> do_wait_thread kernel/exit.c:1426 [inline]
> do_wait+0x75f/0xdc0 kernel/exit.c:1543
> kernel_wait4+0x153/0x260 kernel/exit.c:1706
> __do_sys_wait4+0x147/0x160 kernel/exit.c:1734
> do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> do_syscall_64+0x38/0xb0 arch/x86/entry/common.c:80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> 
> The buggy address belongs to the object at ffff88801f1f1d80
> which belongs to the cache task_struct of size 7240
> The buggy address is located 640 bytes inside of
> 7240-byte region [ffff88801f1f1d80, ffff88801f1f39c8)
> 
> The buggy address belongs to the physical page:
> page:ffffea00007c7c00 refcount:1 mapcount:0 mapping:0000000000000000
> index:0x0 pfn:0x1f1f0
> head:ffffea00007c7c00 order:3 compound_mapcount:0 compound_pincount:0
> memcg:ffff888013b2c081
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 ffffea00005e4200 dead000000000002 ffff88801322a000
> raw: 0000000000000000 0000000080040004 00000001ffffffff ffff888013b2c081
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask
> 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
> pid 16, tgid 16 (kworker/u17:1), ts 3731671201, free_ts 0
> prep_new_page mm/page_alloc.c:2539 [inline]
> get_page_from_freelist+0x10ce/0x2db0 mm/page_alloc.c:4291
> __alloc_pages+0x1c8/0x5c0 mm/page_alloc.c:5558
> alloc_pages+0x1a9/0x270 mm/mempolicy.c:2285
> alloc_slab_page mm/slub.c:1794 [inline]
> allocate_slab+0x24e/0x340 mm/slub.c:1939
> new_slab mm/slub.c:1992 [inline]
> ___slab_alloc+0x89a/0x1400 mm/slub.c:3180
> __slab_alloc.constprop.0+0x56/0xa0 mm/slub.c:3279
> slab_alloc_node mm/slub.c:3364 [inline]
> kmem_cache_alloc_node+0x12e/0x410 mm/slub.c:3443
> alloc_task_struct_node kernel/fork.c:171 [inline]
> dup_task_struct kernel/fork.c:966 [inline]
> copy_process+0x5db/0x6f40 kernel/fork.c:2084
> kernel_clone+0xe8/0x980 kernel/fork.c:2671
> user_mode_thread+0xb4/0xf0 kernel/fork.c:2747
> call_usermodehelper_exec_work kernel/umh.c:175 [inline]
> call_usermodehelper_exec_work+0xcb/0x170 kernel/umh.c:161
> process_one_work+0xa33/0x1720 kernel/workqueue.c:2289
> worker_thread+0x67d/0x10e0 kernel/workqueue.c:2436
> kthread+0x2e4/0x3a0 kernel/kthread.c:376
> ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
> page_owner free stack trace missing
> 
> Memory state around the buggy address:
> ffff88801f1f1f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88801f1f1f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ffff88801f1f2000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ^
> ffff88801f1f2080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ffff88801f1f2100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
