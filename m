Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E15457867F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235592AbiGRPhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiGRPhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:37:12 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CBADBC81;
        Mon, 18 Jul 2022 08:37:10 -0700 (PDT)
Received: from kwepemi500013.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4LmmHt66YzzlW4M;
        Mon, 18 Jul 2022 23:35:22 +0800 (CST)
Received: from [10.67.111.192] (10.67.111.192) by
 kwepemi500013.china.huawei.com (7.221.188.120) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 18 Jul 2022 23:37:02 +0800
Message-ID: <b0e740c4-9630-c539-e811-a4ad93fcca5c@huawei.com>
Date:   Mon, 18 Jul 2022 23:37:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH bpf-next v9 3/4] bpf, arm64: Implement
 bpf_arch_text_poke() for arm64
Content-Language: en-US
To:     Jon Hunter <jonathanh@nvidia.com>, <bpf@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Will Deacon <will@kernel.org>, KP Singh <kpsingh@kernel.org>
CC:     Mark Rutland <mark.rutland@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Zi Shen Lim <zlim.lnx@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
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
References: <20220711150823.2128542-1-xukuohai@huawei.com>
 <20220711150823.2128542-4-xukuohai@huawei.com>
 <8de014c1-aa63-5783-e5fd-53b7fdece805@nvidia.com>
From:   Xu Kuohai <xukuohai@huawei.com>
In-Reply-To: <8de014c1-aa63-5783-e5fd-53b7fdece805@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.111.192]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500013.china.huawei.com (7.221.188.120)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/18/2022 9:52 PM, Jon Hunter wrote:

[..]
> 
> This change appears to be causing the build to fail ...
> 
> /tmp/cc52xO0c.s: Assembler messages:
> /tmp/cc52xO0c.s:8: Error: operand 1 should be an integer register --
> `mov lr,x9'
> /tmp/cc52xO0c.s:7: Error: undefined symbol lr used as an immediate value
> make[2]: *** [scripts/Makefile.build:250: arch/arm64/net/bpf_jit_comp.o]
> Error 1
> make[1]: *** [scripts/Makefile.build:525: arch/arm64/net] Error 2
> 
> Let me know if you have any thoughts.
> 

Sorry for this failure, but I can't reproduce it.

I guess maybe your assembler doesn't recognize "lr". Could you give a
try to replace "lr" with "x30"?

 #if IS_ENABLED(CONFIG_ARM64_BTI_KERNEL)
 "      bti j\n" /* dummy_tramp is called via "br x10" */
 #endif
-"      mov x10, lr\n"
-"      mov lr, x9\n"
+"      mov x10, x30\n"
+"      mov x30, x9\n"
 "      ret x10\n"
 "      .size dummy_tramp, .-dummy_tramp\n"
 "      .popsection\n

Thanks.

> Cheers
> Jon
> 

