Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3A640C81D
	for <lists+netdev@lfdr.de>; Wed, 15 Sep 2021 17:19:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234300AbhIOPU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Sep 2021 11:20:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234024AbhIOPU5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Sep 2021 11:20:57 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550B7C061574;
        Wed, 15 Sep 2021 08:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=TLIEOTF8nbdYtQPS+pB+CF0PUqkM+qVm09D9CfIy4g0=; b=kZ8i4QtJ8teNEnNCGLodt0lYVR
        vCNXiV+7GGltWy9Ll936ySZ56NN1926GqHnyUDPW4xXaT4fudGfrsLlBoKm7OOttSb97HAMu3lu97
        A+psiODluiXR8wYNQydAHmKI1frxrabeUBUU4oyerooIuFnNUiiwc+w4HXoMigOzvXqOBltN08PaY
        IBgML0DvAx5HlAFH/bb8A+kezbQiccRQpTOVaepNEcB74JT6oL4yrPtp5NO7YhCr+O4VNO+5Xn9M4
        7Ao2mJVyGFbDj/FOSh/lzVtgwryjtfbHaOcDrNLgAzCecJPF4oIW9OtRGzwj+lNPfWuHg3qvrP8p3
        +5NTIZYg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQWgw-003QBa-9h; Wed, 15 Sep 2021 15:19:18 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6B1D23000A3;
        Wed, 15 Sep 2021 17:19:17 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 0FA7A234E53A1; Wed, 15 Sep 2021 17:19:17 +0200 (CEST)
Date:   Wed, 15 Sep 2021 17:19:17 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     =?utf-8?B?546L6LSH?= <yun.wang@linux.alibaba.com>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:X86 MM" <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>
Subject: [PATCH] x86: Increase exception stack sizes
Message-ID: <YUIO9Ye98S5Eb68w@hirez.programming.kicks-ass.net>
References: <d16e7188-1afa-7513-990c-804811747bcb@linux.alibaba.com>
 <d85f9710-67c9-2573-07c4-05d9c677d615@intel.com>
 <d8853e49-8b34-4632-3e29-012eb605bea9@linux.alibaba.com>
 <09777a57-a771-5e17-7e17-afc03ea9b83b@linux.alibaba.com>
 <4f63c8bc-1d09-1717-cf81-f9091a9f9fb0@linux.alibaba.com>
 <18252e42-9c30-73d4-e3bb-0e705a78af41@intel.com>
 <4cba7088-f7c8-edcf-02cd-396eb2a56b46@linux.alibaba.com>
 <bbe09ffb-08b7-824c-943f-dffef51e98c2@intel.com>
 <ac31b8c7-122e-3467-566b-54f053ca0ae2@linux.alibaba.com>
 <09d0190b-f2cc-9e64-4d3a-4eb0def22b7b@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <09d0190b-f2cc-9e64-4d3a-4eb0def22b7b@linux.alibaba.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 15, 2021 at 03:34:20PM +0800, 王贇 wrote:
> Hi, Dave, Peter
> 
> What if we just increase the stack size when ftrace enabled?

I think we can do an unconditional increase. But please first test that
guard page patch :-)

---
Subject: x86: Increase exception stack sizes
From: Peter Zijlstra <peterz@infradead.org>
Date: Wed Sep 15 16:19:46 CEST 2021

It turns out that a single page of stack is trivial to overflow with
all the tracing gunk enabled. Raise the exception stacks to 2 pages,
which is still half the interrupt stacks, which are at 4 pages.

Reported-by: Michael Wang <yun.wang@linux.alibaba.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 arch/x86/include/asm/page_64_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -15,7 +15,7 @@
 #define THREAD_SIZE_ORDER	(2 + KASAN_STACK_ORDER)
 #define THREAD_SIZE  (PAGE_SIZE << THREAD_SIZE_ORDER)
 
-#define EXCEPTION_STACK_ORDER (0 + KASAN_STACK_ORDER)
+#define EXCEPTION_STACK_ORDER (1 + KASAN_STACK_ORDER)
 #define EXCEPTION_STKSZ (PAGE_SIZE << EXCEPTION_STACK_ORDER)
 
 #define IRQ_STACK_ORDER (2 + KASAN_STACK_ORDER)
