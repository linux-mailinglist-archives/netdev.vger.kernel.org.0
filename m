Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B688D644ADD
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 19:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229621AbiLFSJq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 13:09:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiLFSJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 13:09:45 -0500
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392A73AC37;
        Tue,  6 Dec 2022 10:09:44 -0800 (PST)
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B6I8dl2019481;
        Tue, 6 Dec 2022 10:09:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=message-id : date :
 subject : from : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=s2048-2021-q4;
 bh=9XFW+Z2abH0rfvN4fqT3CxHNDqUKdDHChbaEB/0uXyg=;
 b=NMQHbeG5ud5uN8HY5tWl6ppbGXiV3UNJh/XELiWHOY5Ck6VHVERCfJ8z+4S25MQJw+5f
 L782b2zM2s2kF3fcovuHHdwPdqaKkW6wK8SJ2eanLh8ShINSox4Iap2IqcYqcZPamGrq
 AP9KOKZv4F9e3ybtVK/+6n2iJBjCh3aiMQROHK2/vpOzA15NHAF/ofV/R5CE+tJK2Exh
 ANGuUWcRmUwQD4YHZwmtI6Mz3s27+smC+zeSmiWBFk2g32m6CwsuQZ+bNI5BUwCbWSmG
 rNJ1TZPYOkFAKKAJl2m2kF5bwOAdXcetg/pR9Ke4U3afNd8DA4u8+DzBhuYjtQh7Euwk BQ== 
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3ma9j88m2x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 06 Dec 2022 10:09:25 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xjv+eV+JOJyQXQsjJ0YvqbDhEljS8Xov+uGiQZ9IodxWes27dm1dgI7CpoCcy8jKiFQdvFRmbFG6T027+pbbp/ZpTEMokHN8FSnUzAn+m/NPgZYEsFJfwZqX4pDpUdB44rY9Lawci7CVeOVWEEpuQBDnbDAUviS8pckVggcuh7X7/Vod0rAyt0cMEE8bZG+SeqtIXJ/LgP1DVS9CiMk34wGOy49F9bcBHT3hNPG8et+PSzk0SNt2O74y5zBXkhSc+ZIGzIp5eTeZ5iysfF0DivP4CM9eVsmoqZsm5aaG6+qAxJDi0AZNQ/RJlhNAh7F6xasLNYUBOxUpjYtthWqccQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xc6AdEK4np9HOSkr5RdFhK+fB34ECTyAsnWIBg2D3t4=;
 b=L7tnz6nhU1h3Fr366/9o5HZYdbY4FcUzteJhDrRoKCiYQfl8/DJq8U7oxMZfxMXF9W4/47ax4rGy/suKbCHUY+r/iwfBNwWzbd7Jfz2KVzgbAP/XcUNGqDGxxpBrrkeU/Oj7qEpxxqROudNF645B2u8cnGVtITMiJFDmpVtyDFF4YwnsmFBuxuNG37HopP+WPS/hJ1I+O5VwnFsNT9GCXNTOHtoUvbtaBbEFiNaZBQAjk4COC/fprmKFJKPGfu31rO1cPWg2/om0Aw/svmC6T/Ch+kGFAgJ7siKwNjzwJ7IjrAap/rAkKCASPmm3fR/Zrx9xbG8IKQUnffa1A8ZxXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=meta.com; dmarc=pass action=none header.from=meta.com;
 dkim=pass header.d=meta.com; arc=none
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com (2603:10b6:805:d::27)
 by CY4PR15MB1638.namprd15.prod.outlook.com (2603:10b6:903:137::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Tue, 6 Dec
 2022 18:09:22 +0000
Received: from SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf]) by SN6PR1501MB2064.namprd15.prod.outlook.com
 ([fe80::d665:7e05:61d1:aebf%7]) with mapi id 15.20.5880.014; Tue, 6 Dec 2022
 18:09:22 +0000
Message-ID: <9af1b919-ea15-e44c-b9cc-765c743dd617@meta.com>
Date:   Tue, 6 Dec 2022 10:09:20 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH bpf] bpf: Proper R0 zero-extension for BPF_CALL
 instructions
Content-Language: en-US
From:   Yonghong Song <yhs@meta.com>
To:     Ilya Leoshkevich <iii@linux.ibm.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Brendan Jackman <jackmanb@google.com>
References: <20221202103620.1915679-1-bjorn@kernel.org>
 <3b77aa12a864ab2db081e99aec1bfad78e3b9b51.camel@linux.ibm.com>
 <d26622c6-d51e-e280-6c8a-38c893c49446@meta.com>
In-Reply-To: <d26622c6-d51e-e280-6c8a-38c893c49446@meta.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-ClientProxiedBy: BY3PR10CA0027.namprd10.prod.outlook.com
 (2603:10b6:a03:255::32) To SN6PR1501MB2064.namprd15.prod.outlook.com
 (2603:10b6:805:d::27)
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR1501MB2064:EE_|CY4PR15MB1638:EE_
X-MS-Office365-Filtering-Correlation-Id: 433cd098-e15c-4283-ca4a-08dad7b50093
X-FB-Source: Internal
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8GAxUCp6nfJS9IN1wEz8GRRoMZ8VkULBWD3GGEkW4kJvcIiIMzszR4v6zU2L0iiL5bQJvyEyS0NgYvYtwrlPiWKw0toBMkTcWeAcnxjVqwLtRkjPs1F6wdm7Csm2dH8XnhXKnUb5R6klD3KqUDzDLoDwTniEYuZBdbfxTfMOPEzxodYHaDdcWGK83OwqxPij7n3TtxACHtluGFbrMeWKtKvBC/+OPNeai9ddq/i6NZWRKurtWyVmOG3QXWx+4ORDy2xgYU5j475sHzt1ASVWh346L0aPM+Z1k5PrRsmZBLu6+2oLB6l/kg2jeKTgOx0h0qaNo7nWStFyAqM0FujMgCfb973aHCqXtW59oOxkuiQBiQ+k0wBR21Av4zZz8m+0bCDLEU9OOlyo1k6JBMbCY11TGwGpazTor7fn30J8+KFKEaXUIzo6gccBFtCJI32tEvZCQCyo5LhN88YWy4kyGQmIJCEKjGRvj829g3wqk0h2BQ9M4Zqt5oq53o/91b+AnJzcsF75UJkOWTHtfgV90xz6VKn8BG6aba6iI+2/qTKHRL2c1vwG76uiRxLQ+EbtPMXKGvGDq/VKOGK2wQZMG+qN1fTWlyUGw8mkTXg1ZrUaWIzMjQ2W2ZRBw+prOA8CNCC+8Wz5modPSm0SZU126QR0m+4hbprwaHf3d2xtF5L5bH4B0XjASGaX6kucelxoZqsQtOaoJJSPb+qj1OqT2Pf45N7kCloGH8WrG72cBGO6XtXNxG45OxE+NLs7WiAP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR1501MB2064.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199015)(66574015)(8936002)(31686004)(83380400001)(54906003)(186003)(316002)(41300700001)(86362001)(31696002)(66899015)(38100700002)(36756003)(2616005)(4326008)(2906002)(8676002)(478600001)(66556008)(5660300002)(966005)(66476007)(110136005)(6506007)(53546011)(6486002)(6512007)(66946007)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?azRMUEZTZVVrT2JBQjIyWWdKWUo5Q1RPR3JrMk9LSThPa25OWDBvdmFmZ0RP?=
 =?utf-8?B?akdWeE9PYVZCYXVZTTlsZnlNZG9pQVhpOVh4YUlBdGN6dTZMendVSkJnUTZ0?=
 =?utf-8?B?RStraHV0MGlsaUM3TitZWXJEalBCQUxxSGdUSWpBeU5FTnJERFJUdWtMeVdw?=
 =?utf-8?B?MEpGcWQyTnJBYXFWTGViUUxwcVBzUlBKUkFveWxJbUlMN04zOHBSTVJXc2Vr?=
 =?utf-8?B?WmsxWCs4UjZYcC9vNDNEazgycnB3QThCVG5iMkxScVFNTHAwdkx6RzVrN2Ix?=
 =?utf-8?B?bGZwbWhnbTJlUFcyMkdrQ292WHZqeWxSYUNJSmtBV0dNdkZBdDl1TC84cXc3?=
 =?utf-8?B?djg0ZWtXczZzdzQ1NnF6THl6dklwWVhIRFdXYXdOKyt2UWRsdDF3SGJrSUZK?=
 =?utf-8?B?U1ZLOStpUjgwVldGSXZYUW14YlliVzZhMnNQWEQzZlhqMTIzUldsb3puN3Uw?=
 =?utf-8?B?QUhqL0h3dElSKzFRemtaNFRwcHZBRFBYWnVmUW1ld2IydVViZUxrb3crWG5E?=
 =?utf-8?B?d2dFQVZ2dUNwMzJoUCsrbi9ZdGl1cFM4RGdGNWc1aU1aT2ZzS2Q5Z3Yydlhw?=
 =?utf-8?B?L1NQT0w2NTNqRTN0a3lEVDl2SUxhRkh3T1RtaTcwQ3cvTTZaZGtRc1puZEJG?=
 =?utf-8?B?NVlKTzZWSXEzdzdQRTJoTkZBQWlPWjJnSldVLzZBay9NODFJaC9yWDh5VEx4?=
 =?utf-8?B?cnhKZzFiTWlkTzBWUzlpUURxRll5WjUvM1MvaDQxalFtcmN3NEtEdG0zV1VB?=
 =?utf-8?B?Qkk1UytqeTJ2cnJ5Z1hMcUxEOTFtVXBpTTVtVWhvOUNMU2N2TUVHVTVxWklX?=
 =?utf-8?B?REVMK1huZEhxa0tOSEVhY3JsR3FqK01nNXN0NEFsK1VvbUxzQURRbEJBVFRE?=
 =?utf-8?B?OTJwK0dIZnQvZnNFbFBQd0hXQ3VDUVNGTDcwa3A0K3cvZmZjcGFpaXpXT1RK?=
 =?utf-8?B?dmxDKzVMYnFJT3l3Ynpac0xUTlVseUZNQ2hJWTNIVTlUVnRZK3UySEp3cC80?=
 =?utf-8?B?SlNqNEdoaG9ZNHQ4L0xuMTltRXl6dUxBYjNvYlIybm5acW9sQU9NZ3RKbzBp?=
 =?utf-8?B?TXNQbzljcFRLWnBaSXNFREt1allzeG1kbEh2NXQ3Yk95eS9iSzRHUlNCOEJo?=
 =?utf-8?B?NWk1YW4ybVhETlcra0MrS3daMjgzV3JQbnlNT0Jjdk8vMHozT2JLcnlKMExQ?=
 =?utf-8?B?ekFwZnVUSjliZzBuQmFHdDFhc2FQZVJYVENLY214K2pBdkt5OFhlV0xmK3Nk?=
 =?utf-8?B?Nk5aZXBCdjJ3YWNuazlybGxQM096bDdtT2duT0lPMjB0Q3dKblR6aGZPaU1x?=
 =?utf-8?B?RnJ1RFg1WkYvOGtqalEvRi8zRms2cnFMcUxOYzlDOHVKYkE0ak5mRERCVzRo?=
 =?utf-8?B?VXQ4M00vcmpHSXBCTGh6b2IzMlo2bUZIdVdwNXZRcHFacVAxdFlraDBDdFN3?=
 =?utf-8?B?bk5RUFlNdEJFd0tlRThWWEJGcGNxdGlIclRpYnN1d1lRdkI3VGN6d1JuMU9v?=
 =?utf-8?B?MWx3b0NzbjN6dlBiR1lzdlhjT2w1eCtZR2IzWWFyRDljbExrTzlhaEl1T2ly?=
 =?utf-8?B?V0hOWGI2NkdhN21PWmxSWDQwNFprTDRuUWpxdmg0bjlSaThNcnZNbDM5ejRN?=
 =?utf-8?B?Z2hHQkNvMEtQQm12S1ZCMHh0MjhwR3duSm5KV2J4U2h0clJNcCtibDhFTTB2?=
 =?utf-8?B?M1NGYVhiTzNGdDBQR1M3SGZxbUJ4T0ZFRjErY21Ic3JqckF4TzFsbGZaUGRC?=
 =?utf-8?B?ZUFkd3NManIrc3FsbkU1bVp4UVRkcFBZeTJOdVRRVU4rcytDRDVlalJvOTF3?=
 =?utf-8?B?NXNJNjFCSlM2SnJOWWUrU1JENU1pR0pGU1JUZ1NjQ0p3ZjFKTzdNbXJ2TDdE?=
 =?utf-8?B?ZXBpK2Z6RktDdzc1cjNhT25GQmNTR3JRcXpWOHpRbHFHNWVyNTZWWVUzRnNm?=
 =?utf-8?B?SG4rd2dhNmptZzd6RXhZcHN5czJzRHF4ZDU2T3FWaFFDNU5PcjdxRkszWjdR?=
 =?utf-8?B?QWJnMDRwWStmV2Z0ck4yTDJEQ09DQXp6UUxJLzYySWRxL3g5azRzRmhjODFY?=
 =?utf-8?B?VHBBRWZ2bjFXUGVwOUV3WXl6Q0RPeTA2Z0x6RkZERXNVTUQrU2dLNld5dGth?=
 =?utf-8?B?aFVHRjBQMlJDcW1GaHBmNmFQeVJEZXdLb2FHTCtyMm1jSDI5TlU3NWluN3B3?=
 =?utf-8?B?UVE9PQ==?=
X-OriginatorOrg: meta.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 433cd098-e15c-4283-ca4a-08dad7b50093
X-MS-Exchange-CrossTenant-AuthSource: SN6PR1501MB2064.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 18:09:22.6334
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1k+sF3zXq43SEDFgB7oQC+PRUXzHmV4t/MJTjSHFzQH0nKDJwYGDeYhvo+djqC+N
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1638
X-Proofpoint-ORIG-GUID: OK8xZcNR3LMtCUDR8Kv7k8yhVlz-dK_k
X-Proofpoint-GUID: OK8xZcNR3LMtCUDR8Kv7k8yhVlz-dK_k
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 1 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-06_11,2022-12-06_01,2022-06-22_01
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/6/22 9:47 AM, Yonghong Song wrote:
> 
> 
> On 12/6/22 5:21 AM, Ilya Leoshkevich wrote:
>> On Fri, 2022-12-02 at 11:36 +0100, Björn Töpel wrote:
>>> From: Björn Töpel <bjorn@rivosinc.com>
>>>
>>> A BPF call instruction can be, correctly, marked with zext_dst set to
>>> true. An example of this can be found in the BPF selftests
>>> progs/bpf_cubic.c:
>>>
>>>    ...
>>>    extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
>>>
>>>    __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
>>>    {
>>>            return tcp_reno_undo_cwnd(sk);
>>>    }
>>>    ...
>>>
>>> which compiles to:
>>>    0:  r1 = *(u64 *)(r1 + 0x0)
>>>    1:  call -0x1
>>>    2:  exit
>>>
>>> The call will be marked as zext_dst set to true, and for some
>>> backends
>>> (bpf_jit_needs_zext() returns true) expanded to:
>>>    0:  r1 = *(u64 *)(r1 + 0x0)
>>>    1:  call -0x1
>>>    2:  w0 = w0
>>>    3:  exit
>>
>> In the verifier, the marking is done by check_kfunc_call() (added in
>> e6ac2450d6de), right? So the problem occurs only for kfuncs?
>>
>>          /* Check return type */
>>          t = btf_type_skip_modifiers(desc_btf, func_proto->type, NULL);
>>
>>          ...
>>
>>          if (btf_type_is_scalar(t)) {
>>                  mark_reg_unknown(env, regs, BPF_REG_0);
>>                  mark_btf_func_reg_size(env, BPF_REG_0, t->size);
>>
>> I tried to find some official information whether the eBPF calling
>> convention requires sign- or zero- extending return values and
>> arguments, but unfortunately [1] doesn't mention this.
>>
>> LLVM's lib/Target/BPF/BPFCallingConv.td mentions both R* and W*
>> registers, but since assigning to W* leads to zero-extension, it seems
>> to me that this is the case.
> 
> We actually follow the clang convention, the zero-extension is either
> done in caller or callee, but not both. See 
> https://reviews.llvm.org/D131598  how the convention could be changed.
> 
> The following is an example.
> 
> $ cat t.c
> extern unsigned foo(void);
> unsigned bar1(void) {
>      return foo();
> }
> unsigned bar2(void) {
>      if (foo()) return 10; else return 20;
> }
> $ clang -target bpf -mcpu=v3 -O2 -c t.c && llvm-objdump -d t.o
> 
> t.o:    file format elf64-bpf
> 
> Disassembly of section .text:
> 
> 0000000000000000 <bar1>:
>         0:       85 10 00 00 ff ff ff ff call -0x1
>         1:       95 00 00 00 00 00 00 00 exit
> 
> 0000000000000010 <bar2>:
>         2:       85 10 00 00 ff ff ff ff call -0x1
>         3:       bc 01 00 00 00 00 00 00 w1 = w0
>         4:       b4 00 00 00 14 00 00 00 w0 = 0x14
>         5:       16 01 01 00 00 00 00 00 if w1 == 0x0 goto +0x1 <LBB1_2>
>         6:       b4 00 00 00 0a 00 00 00 w0 = 0xa
> 
> 0000000000000038 <LBB1_2>:
>         7:       95 00 00 00 00 00 00 00 exit
> $
> 
> If the return value of 'foo()' is actually used in the bpf program, the
> proper zero extension will be done. Otherwise, it is not done.
> 
> This is with latest llvm16. I guess we need to check llvm whether
> we could enforce to add a w0 = w0 in bar1().
> 
> Otherwise, with this patch, it will add w0 = w0 in all cases which
> is not necessary in most of practical cases.
> 
>>
>> If the above is correct, then shouldn't we rather use sizeof(void *) in
>> the mark_btf_func_reg_size() call above?
>>
>>> The opt_subreg_zext_lo32_rnd_hi32() function which is responsible for
>>> the zext patching, relies on insn_def_regno() to fetch the register
>>> to
>>> zero-extend. However, this function does not handle call instructions
>>> correctly, and opt_subreg_zext_lo32_rnd_hi32() fails the
>>> verification.
>>>
>>> Make sure that R0 is correctly resolved for (BPF_JMP | BPF_CALL)
>>> instructions.
>>>
>>> Fixes: 83a2881903f3 ("bpf: Account for BPF_FETCH in
>>> insn_has_def32()")
>>> Signed-off-by: Björn Töpel <bjorn@rivosinc.com>
>>> ---
>>> I'm not super happy about the additional special case -- first
>>> cmpxchg, and now call. :-( A more elegant/generic solution is
>>> welcome!
>>> ---
>>>   kernel/bpf/verifier.c | 3 +++
>>>   1 file changed, 3 insertions(+)
>>>
>>> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
>>> index 264b3dc714cc..4f9660eafc72 100644
>>> --- a/kernel/bpf/verifier.c
>>> +++ b/kernel/bpf/verifier.c
>>> @@ -13386,6 +13386,9 @@ static int
>>> opt_subreg_zext_lo32_rnd_hi32(struct bpf_verifier_env *env,
>>>                  if (!bpf_jit_needs_zext() && !is_cmpxchg_insn(&insn))
>>>                          continue;
>>> +               if (insn.code == (BPF_JMP | BPF_CALL))
>>> +                       load_reg = BPF_REG_0;

Want to double check. Do we actually have a problem here?
For example, on x64, we probably won't have this issue.

 >>>    ...
 >>>    extern __u32 tcp_reno_undo_cwnd(struct sock *sk) __ksym;
 >>>
 >>>    __u32 BPF_STRUCT_OPS(bpf_cubic_undo_cwnd, struct sock *sk)
 >>>    {
 >>>            return tcp_reno_undo_cwnd(sk);
 >>>    }

The native code will return a 32-bit subreg to bpf program,
and bpf didn't do anything and return r0 to the kernel func.
In the kernel func, the kernel will take 32-bit subreg by
x86_64 convention. This applies to some other return types
like u8/s8/u16/s16/u32/s32.

Which architecture you actually see the issue?


>>> +
>>>                  if (WARN_ON(load_reg == -1)) {
>>>                          verbose(env, "verifier bug. zext_dst is set,
>>> but no reg is defined\n");
>>>                          return -EFAULT;
>>>
>>> base-commit: 01f856ae6d0ca5ad0505b79bf2d22d7ca439b2a1
>>
>> [1]
>> https://docs.kernel.org/bpf/instruction-set.html#registers-and-calling-convention
