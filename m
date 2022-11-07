Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA20661F0BE
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 11:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbiKGKd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 05:33:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231807AbiKGKdu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 05:33:50 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CD3B6EA6;
        Mon,  7 Nov 2022 02:33:49 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDB7A1FB;
        Mon,  7 Nov 2022 02:33:54 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.69.132])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 96A1D3F534;
        Mon,  7 Nov 2022 02:33:46 -0800 (PST)
Date:   Mon, 7 Nov 2022 10:33:25 +0000
From:   Mark Rutland <mark.rutland@arm.com>
To:     Alexander Potapenko <glider@google.com>
Cc:     Baisong Zhong <zhongbaisong@huawei.com>, elver@google.com,
        Catalin Marinas <catalin.marinas@arm.com>, edumazet@google.com,
        keescook@chromium.org, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, pabeni@redhat.com,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH -next,v2] bpf, test_run: fix alignment problem in
 bpf_prog_test_run_skb()
Message-ID: <Y2je9dJxUjEchB9k@FVFF77S0Q05N>
References: <20221102081620.1465154-1-zhongbaisong@huawei.com>
 <CAG_fn=UDAjNd2xFrRxSVyLTZOAGapjSq2Zu5Xht12JNq-A7S=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=UDAjNd2xFrRxSVyLTZOAGapjSq2Zu5Xht12JNq-A7S=A@mail.gmail.com>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 04, 2022 at 06:06:05PM +0100, Alexander Potapenko wrote:
> On Wed, Nov 2, 2022 at 9:16 AM Baisong Zhong <zhongbaisong@huawei.com> wrote:
> >
> > we got a syzkaller problem because of aarch64 alignment fault
> > if KFENCE enabled.
> >
> > When the size from user bpf program is an odd number, like
> > 399, 407, etc, it will cause the struct skb_shared_info's
> > unaligned access. As seen below:
> >
> > BUG: KFENCE: use-after-free read in __skb_clone+0x23c/0x2a0 net/core/skbuff.c:1032
> 
> It's interesting that KFENCE is reporting a UAF without a deallocation
> stack here.
> 
> Looks like an unaligned access to 0xffff6254fffac077 causes the ARM
> CPU to throw a fault handled by __do_kernel_fault()

Importantly, an unaligned *atomic*, which is a bug regardless of KFENCE.

> This isn't technically a page fault, but anyway the access address
> gets passed to kfence_handle_page_fault(), which defaults to a
> use-after-free, because the address belongs to the object page, not
> the redzone page.
> 
> Catalin, Mark, what is the right way to only handle traps caused by
> reading/writing to a page for which `set_memory_valid(addr, 1, 0)` was
> called?

That should appear as a translation fault, so we could add an
is_el1_translation_fault() helper for that. I can't immediately recall how
misaligned atomics are presented, but I presume as something other than a
translation fault.

If the below works for you, I can go spin that as a real patch.

Mark.

---->8----
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index 5b391490e045b..1de4b6afa8515 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -239,6 +239,11 @@ static bool is_el1_data_abort(unsigned long esr)
        return ESR_ELx_EC(esr) == ESR_ELx_EC_DABT_CUR;
 }
 
+static bool is_el1_translation_fault(unsigned long esr)
+{
+       return (esr & ESR_ELx_FSC_TYPE) == ESR_ELx_FSC_FAULT;
+}
+
 static inline bool is_el1_permission_fault(unsigned long addr, unsigned long esr,
                                           struct pt_regs *regs)
 {
@@ -385,7 +390,8 @@ static void __do_kernel_fault(unsigned long addr, unsigned long esr,
        } else if (addr < PAGE_SIZE) {
                msg = "NULL pointer dereference";
        } else {
-               if (kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
+               if (is_el1_translation_fault(esr) &&
+                   kfence_handle_page_fault(addr, esr & ESR_ELx_WNR, regs))
                        return;
 
                msg = "paging request";
