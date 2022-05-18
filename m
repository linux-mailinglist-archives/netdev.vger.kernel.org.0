Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A4052C3D5
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 21:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbiERT6I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 15:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242217AbiERT6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 15:58:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73951227817;
        Wed, 18 May 2022 12:58:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA5686191F;
        Wed, 18 May 2022 19:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21195C34113;
        Wed, 18 May 2022 19:58:01 +0000 (UTC)
Date:   Wed, 18 May 2022 15:57:59 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Xu Kuohai <xukuohai@huawei.com>
Cc:     <bpf@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@redhat.com>,
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, <x86@kernel.org>,
        <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Daniel Kiss <daniel.kiss@arm.com>,
        Steven Price <steven.price@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        Mark Brown <broonie@kernel.org>,
        Delyan Kratunov <delyank@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: Re: [PATCH bpf-next v4 2/6] ftrace: Fix deadloop caused by direct
 call in ftrace selftest
Message-ID: <20220518155759.4054d9a2@gandalf.local.home>
In-Reply-To: <20220517071838.3366093-3-xukuohai@huawei.com>
References: <20220517071838.3366093-1-xukuohai@huawei.com>
        <20220517071838.3366093-3-xukuohai@huawei.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 03:18:34 -0400
Xu Kuohai <xukuohai@huawei.com> wrote:

> After direct call is enabled for arm64, ftrace selftest enters a
> dead loop:
> 
> <trace_selftest_dynamic_test_func>:
> 00  bti     c
> 01  mov     x9, x30                            <trace_direct_tramp>:
> 02  bl      <trace_direct_tramp>    ---------->     ret
>                                                      |
>                                          lr/x30 is 03, return to 03
>                                                      |
> 03  mov     w0, #0x0   <-----------------------------|
>      |                                               |
>      |                   dead loop!                  |
>      |                                               |
> 04  ret   ---- lr/x30 is still 03, go back to 03 ----|
> 
> The reason is that when the direct caller trace_direct_tramp() returns
> to the patched function trace_selftest_dynamic_test_func(), lr is still
> the address after the instrumented instruction in the patched function,
> so when the patched function exits, it returns to itself!
> 
> To fix this issue, we need to restore lr before trace_direct_tramp()
> exits, so rewrite a dedicated trace_direct_tramp() for arm64.
> 
> Reported-by: Li Huafei <lihuafei1@huawei.com>
> Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
> ---

Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve
