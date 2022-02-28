Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A68E4C6097
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 02:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231851AbiB1BPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Feb 2022 20:15:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbiB1BPv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Feb 2022 20:15:51 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0575F5C360;
        Sun, 27 Feb 2022 17:15:09 -0800 (PST)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.53])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4K6Mnq6G1yzBrKH;
        Mon, 28 Feb 2022 09:13:19 +0800 (CST)
Received: from [10.174.176.117] (10.174.176.117) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Feb 2022 09:15:05 +0800
Subject: Re: [PATCH bpf-next v4 0/2] bpf, arm64: fix bpf line info
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Will Deacon <will@kernel.org>
CC:     Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>, Zi Shen Lim <zlim.lnx@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Ard Biesheuvel <ard.biesheuvel@arm.com>,
        <linux-arm-kernel@lists.infradead.org>
References: <20220226121906.5709-1-houtao1@huawei.com>
From:   Hou Tao <houtao1@huawei.com>
Message-ID: <eca26e28-a087-b189-2242-5d9378c5c86e@huawei.com>
Date:   Mon, 28 Feb 2022 09:15:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20220226121906.5709-1-houtao1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.174.176.117]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 2/26/2022 8:19 PM, Hou Tao wrote:
> Hi,
>
> The patchset addresses two issues in bpf line info for arm64:
>
> (1) insn_to_jit_off only considers the body itself and ignores
>     prologue before the body. Fixed in patch #1.
>
> (2) insn_to_jit_off passed to bpf_prog_fill_jited_linfo() is
>     calculated in instruction granularity instead of bytes
>     granularity. Fixed in patch #2.
>
> Comments are always welcome.
>
> Regards,
> Tao
>
> Change Log:
> v4:
>  * patch #2: convert ctx.offset into byte offset before call
>    bpf_prog_fill_jited_linfo() instead of converting it back and forth.
Oops, forget to add Acked-by tag from Martin
>
> v3: https://lore.kernel.org/bpf/20220208012539.491753-1-houtao1@huawei.com
>  * patch #2: explain why bpf2a64_offset() needs update
>  * add Fixes tags in both patches
>
> v2: https://lore.kernel.org/bpf/20220125105707.292449-1-houtao1@huawei.com
>  * split into two independent patches (from Daniel)
>  * use AARCH64_INSN_SIZE instead of defining INSN_SIZE
>
> v1: https://lore.kernel.org/bpf/20220104014236.1512639-1-houtao1@huawei.com
>
> Hou Tao (2):
>   bpf, arm64: call build_prologue() first in first JIT pass
>   bpf, arm64: feed byte-offset into bpf line info
>
>  arch/arm64/net/bpf_jit_comp.c | 18 +++++++++++++-----
>  1 file changed, 13 insertions(+), 5 deletions(-)
>

