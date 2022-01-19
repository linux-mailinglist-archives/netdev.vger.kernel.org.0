Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE6A2493C1C
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 15:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355242AbiASOpm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 09:45:42 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:30288 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355236AbiASOpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jan 2022 09:45:41 -0500
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Jf7hj4JLDzbjxh;
        Wed, 19 Jan 2022 22:44:53 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 19 Jan 2022 22:45:38 +0800
Subject: Re: [PATCH bpf] bpf, arm64: calculate offset as byte-offset for bpf
 line info
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
CC:     Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
References: <20220104014236.1512639-1-houtao1@huawei.com>
 <2091c1ac-2863-cdd6-5de9-d264ab54c9be@iogearbox.net>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <02963800-ca3d-7b4b-3e4d-b4fb7678a0b1@huawei.com>
Date:   Wed, 19 Jan 2022 22:45:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <2091c1ac-2863-cdd6-5de9-d264ab54c9be@iogearbox.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 1/7/2022 6:00 AM, Daniel Borkmann wrote:
> On 1/4/22 2:42 AM, Hou Tao wrote:
>> The bpf line info for arm64 is broken due to two reasons:
>> (1) insn_to_jit_off passed to bpf_prog_fill_jited_linfo() is
>>      calculated in instruction granularity instead of bytes
>>      granularity.
>> (2) insn_to_jit_off only considers the body itself and ignores
>>      prologue before the body.
>>
>> So fix it by calculating offset as byte-offset and do build_prologue()
>> first in the first JIT pass.
>>
[snip]
>> -    /* Fake pass to fill in ctx->offset. */
>> -    if (build_body(&ctx, extra_pass)) {
>> +    /*
>> +     * 1. Initial fake pass to compute ctx->idx and ctx->offset.
>> +     *
>> +     * BPF line info needs ctx->offset[i] to be the byte offset
>> +     * of instruction[i] in jited image, so build prologue first.
>> +     */
>> +    if (build_prologue(&ctx, was_classic)) {
>>           prog = orig_prog;
>>           goto out_off;
>>       }
>>   -    if (build_prologue(&ctx, was_classic)) {
>> +    if (build_body(&ctx, extra_pass)) {
>>           prog = orig_prog;
>>           goto out_off;
>
> Could you split this into two logical patches? Both 1/2 seem independent
> of each other and should have been rather 2 patches instead of 1.
>
Sorry for the later reply. Splitting into two patches make sense for me. Will do
it in v2.
> Did you check if also other JITs could be affected?
It seems sparc also doesn't represent offset by bytes and I can check other
arches as well,
but it is sad that I don't have the environments for these arches.

> Thanks,
> Daniel
> .

