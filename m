Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F23567BA1
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230077AbiGFBnj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbiGFBnh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:43:37 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DA718B06;
        Tue,  5 Jul 2022 18:43:36 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Ld2Lr5gnxzhYyF;
        Wed,  6 Jul 2022 09:41:08 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 6 Jul 2022 09:43:33 +0800
Message-ID: <2194026a-c958-039e-7b26-b84cfa30a3d0@huawei.com>
Date:   Wed, 6 Jul 2022 09:43:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v6 2/4] arm64: Add LDR (literal) instruction
Content-Language: en-US
To:     Will Deacon <will@kernel.org>
CC:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        James Morse <james.morse@arm.com>,
        Hou Tao <houtao1@huawei.com>,
        Jason Wang <wangborong@cdjrlc.com>
References: <20220625161255.547944-1-xukuohai@huawei.com>
 <20220625161255.547944-3-xukuohai@huawei.com>
 <20220705163941.GA1339@willie-the-truck>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <20220705163941.GA1339@willie-the-truck>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/6/2022 12:39 AM, Will Deacon wrote:
> On Sat, Jun 25, 2022 at 12:12:53PM -0400, Xu Kuohai wrote:
>> Add LDR (literal) instruction to load data from address relative to PC.
>> This instruction will be used to implement long jump from bpf prog to
>> bpf rampoline in the follow-up patch.
> 
> typo: trampoline
>

will fix

>>
>> The instruction encoding:
>>
>>     3       2   2     2                                     0        0
>>     0       7   6     4                                     5        0
>> +-----+-------+---+-----+-------------------------------------+--------+
>> | 0 x | 0 1 1 | 0 | 0 0 |                imm19                |   Rt   |
>> +-----+-------+---+-----+-------------------------------------+--------+
>>
>> for 32-bit, variant x == 0; for 64-bit, x == 1.
>>
>> branch_imm_common() is used to check the distance between pc and target
>> address, since it's reused by this patch and LDR (literal) is not a branch
>> instruction, rename it to aarch64_imm_common().
> 
> nit, but I think "label_imm_common()" would be a better name.
> 

will rename

> Anyway, I checked the encodings and the code looks good, so:
> 
> Acked-by: Will Deacon <will@kernel.org>
> 
> Will
> .

