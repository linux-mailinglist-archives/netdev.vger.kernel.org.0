Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C42564B95BB
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 02:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231409AbiBQBz3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 20:55:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbiBQBz1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 20:55:27 -0500
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B24A23D5F8;
        Wed, 16 Feb 2022 17:55:14 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Jzd896mdkz1FDH3;
        Thu, 17 Feb 2022 09:50:49 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 17 Feb 2022 09:55:11 +0800
Subject: Re: [PATCH bpf-next v3 2/4] arm64: insn: add encoders for atomic
 operations
To:     Will Deacon <will@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Julien Thierry <jthierry@redhat.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20220129220452.194585-1-houtao1@huawei.com>
 <20220129220452.194585-3-houtao1@huawei.com>
 <4524da71-3977-07db-bd6e-cebd1c539805@iogearbox.net>
 <20220216171602.GA10877@willie-the-truck>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <9f515f08-6360-0dde-5d26-80b36b7ac525@huawei.com>
Date:   Thu, 17 Feb 2022 09:55:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220216171602.GA10877@willie-the-truck>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/17/2022 1:16 AM, Will Deacon wrote:
> On Fri, Feb 11, 2022 at 03:39:48PM +0100, Daniel Borkmann wrote:
>> On 1/29/22 11:04 PM, Hou Tao wrote:
>>> It is a preparation patch for eBPF atomic supports under arm64. eBPF
>>> needs support atomic[64]_fetch_add, atomic[64]_[fetch_]{and,or,xor} and
>>> atomic[64]_{xchg|cmpxchg}. The ordering semantics of eBPF atomics are
>>> the same with the implementations in linux kernel.
>>>
>>> Add three helpers to support LDCLR/LDEOR/LDSET/SWP, CAS and DMB
>>> instructions. STADD/STCLR/STEOR/STSET are simply encoded as aliases for
>>> LDADD/LDCLR/LDEOR/LDSET with XZR as the destination register, so no extra
>>> helper is added. atomic_fetch_add() and other atomic ops needs support for
>>> STLXR instruction, so extend enum aarch64_insn_ldst_type to do that.
>>>
>>> LDADD/LDEOR/LDSET/SWP and CAS instructions are only available when LSE
>>> atomics is enabled, so just return AARCH64_BREAK_FAULT directly in
>>> these newly-added helpers if CONFIG_ARM64_LSE_ATOMICS is disabled.
>>>
>>> Signed-off-by: Hou Tao <houtao1@huawei.com>
>> Hey Mark / Ard / Will / Catalin or others, could we get an Ack on patch 1 & 2
>> at min if it looks good to you?
> I checked the instruction encodings in patches 1 and 2 and they all look
> fine to me. However, after applying those two locally I get a build failure:
>
>   | In file included from arch/arm64/net/bpf_jit_comp.c:23:
>   | arch/arm64/net/bpf_jit_comp.c: In function ‘build_insn’:
>   | arch/arm64/net/bpf_jit.h:94:2: error: implicit declaration of function ‘aarch64_insn_gen_stadd’; did you mean ‘aarch64_insn_gen_adr’? [-Werror=implicit-function-declaration]
>   |    94 |  aarch64_insn_gen_stadd(Rn, Rs, A64_SIZE(sf))
>   |       |  ^~~~~~~~~~~~~~~~~~~~~~
>   | arch/arm64/net/bpf_jit_comp.c:912:9: note: in expansion of macro ‘A64_STADD’
>   |   912 |    emit(A64_STADD(isdw, reg, src), ctx);
>   |       |         ^~~~~~~~~
>   | cc1: some warnings being treated as errors
Thanks for your review. The build failure is my fault. I update A64_STADD() in
patch 3 instead of patch 2
after replacing aarch64_insn_get_stadd() by aarch64_insn_gen_atomic_ld_op(), and
will fix it in v4. If you
are trying to test the encoder, I suggest you to apply patch 1~3.

Regards,
Tao
> Will
> .

