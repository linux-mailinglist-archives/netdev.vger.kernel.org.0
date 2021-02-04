Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A35B30E869
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 01:21:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233530AbhBDASu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 19:18:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:55258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232867AbhBDASt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 19:18:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612397842;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aH1rhNhUTj2RKUZJRdsnzrFvXxO/fmeN1LzVYQPVogc=;
        b=AUozw4f4BipLwx/wLqMSrahHxPX12xwGNqJlFn164H9VNTLi+aJ3cDf8wB480ctrv7lQT6
        MQ+pM5hUNmMAWmlysAHoAkMheUYHqEUYPLtFUMdWIDKDc3ThEIj9gvSmKMOV5L7JA0Yubl
        sqIk3mqlwUgVVj33AraU1NZOk7C3nro=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-468-0rp0hcNIPm-QpktHhG4f4g-1; Wed, 03 Feb 2021 19:17:20 -0500
X-MC-Unique: 0rp0hcNIPm-QpktHhG4f4g-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7884A1934110;
        Thu,  4 Feb 2021 00:17:16 +0000 (UTC)
Received: from treble (ovpn-113-81.rdu2.redhat.com [10.10.113.81])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 911A2100AE4D;
        Thu,  4 Feb 2021 00:17:03 +0000 (UTC)
Date:   Wed, 3 Feb 2021 18:17:00 -0600
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     Ivan Babrou <ivan@cloudflare.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Ignat Korchagin <ignat@cloudflare.com>,
        Hailong liu <liu.hailong6@zte.com.cn>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Miroslav Benes <mbenes@suse.cz>,
        Julien Thierry <jthierry@redhat.com>,
        Jiri Slaby <jirislaby@kernel.org>, kasan-dev@googlegroups.com,
        linux-mm@kvack.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Robert Richter <rric@kernel.org>,
        "Joel Fernandes (Google)" <joel@joelfernandes.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>
Subject: Re: BUG: KASAN: stack-out-of-bounds in
 unwind_next_frame+0x1df5/0x2650
Message-ID: <20210204001700.ry6dpqvavcswyvy7@treble>
References: <CABWYdi3HjduhY-nQXzy2ezGbiMB1Vk9cnhW2pMypUa+P1OjtzQ@mail.gmail.com>
 <CABWYdi27baYc3ShHcZExmmXVmxOQXo9sGO+iFhfZLq78k8iaAg@mail.gmail.com>
 <YBrTaVVfWu2R0Hgw@hirez.programming.kicks-ass.net>
 <CABWYdi2ephz57BA8bns3reMGjvs5m0hYp82+jBLZ6KD3Ba6zdQ@mail.gmail.com>
 <20210203190518.nlwghesq75enas6n@treble>
 <CABWYdi1ya41Ju9SsHMtRQaFQ=s8N23D3ADn6OV6iBwWM6H8=Zw@mail.gmail.com>
 <20210203232735.nw73kugja56jp4ls@treble>
 <CABWYdi1zd51Jb35taWeGC-dR9SChq-4ixvyKms3KOKgV0idfPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABWYdi1zd51Jb35taWeGC-dR9SChq-4ixvyKms3KOKgV0idfPg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 03, 2021 at 03:30:35PM -0800, Ivan Babrou wrote:
> > > > Can you recreate with this patch, and add "unwind_debug" to the cmdline?
> > > > It will spit out a bunch of stack data.
> > >
> > > Here's the three I'm building:
> > >
> > > * https://github.com/bobrik/linux/tree/ivan/static-call-5.9
> > >
> > > It contains:
> > >
> > > * v5.9 tag as the base
> > > * static_call-2020-10-12 tag
> > > * dm-crypt patches to reproduce the issue with KASAN
> > > * x86/unwind: Add 'unwind_debug' cmdline option
> > > * tracepoint: Fix race between tracing and removing tracepoint
> > >
> > > The very same issue can be reproduced on 5.10.11 with no patches,
> > > but I'm going with 5.9, since it boils down to static call changes.
> > >
> > > Here's the decoded stack from the kernel with unwind debug enabled:
> > >
> > > * https://gist.github.com/bobrik/ed052ac0ae44c880f3170299ad4af56b
> > >
> > > See my first email for the exact commands that trigger this.
> >
> > Thanks.  Do you happen to have the original dmesg, before running it
> > through the post-processing script?
> 
> Yes, here it is:
> 
> * https://gist.github.com/bobrik/8c13e6a02555fb21cadabb74cdd6f9ab

It appears the unwinder is getting lost in crypto code.  No idea what
this has to do with static calls though.  Or maybe you're seeing
multiple issues.

Does this fix it?


diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index a31de0c6ccde..36c55341137c 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -2,7 +2,14 @@
 #
 # x86 crypto algorithms
 
-OBJECT_FILES_NON_STANDARD := y
+OBJECT_FILES_NON_STANDARD_sha256-avx2-asm.o		:= y
+OBJECT_FILES_NON_STANDARD_sha512-ssse3-asm.o		:= y
+OBJECT_FILES_NON_STANDARD_sha512-avx-asm.o		:= y
+OBJECT_FILES_NON_STANDARD_sha512-avx2-asm.o		:= y
+OBJECT_FILES_NON_STANDARD_crc32c-pcl-intel-asm_64.o	:= y
+OBJECT_FILES_NON_STANDARD_camellia-aesni-avx2-asm_64.o	:= y
+OBJECT_FILES_NON_STANDARD_sha1_avx2_x86_64_asm.o	:= y
+OBJECT_FILES_NON_STANDARD_sha1_ni_asm.o			:= y
 
 obj-$(CONFIG_CRYPTO_GLUE_HELPER_X86) += glue_helper.o
 
diff --git a/arch/x86/crypto/aesni-intel_avx-x86_64.S b/arch/x86/crypto/aesni-intel_avx-x86_64.S
index 5fee47956f3b..59c36b88954f 100644
--- a/arch/x86/crypto/aesni-intel_avx-x86_64.S
+++ b/arch/x86/crypto/aesni-intel_avx-x86_64.S
@@ -237,8 +237,8 @@ define_reg j %j
 .noaltmacro
 .endm
 
-# need to push 4 registers into stack to maintain
-STACK_OFFSET = 8*4
+# need to push 5 registers into stack to maintain
+STACK_OFFSET = 8*5
 
 TMP1 =   16*0    # Temporary storage for AAD
 TMP2 =   16*1    # Temporary storage for AES State 2 (State 1 is stored in an XMM register)
@@ -257,6 +257,8 @@ VARIABLE_OFFSET = 16*8
 
 .macro FUNC_SAVE
         #the number of pushes must equal STACK_OFFSET
+	push	%rbp
+	mov	%rsp, %rbp
         push    %r12
         push    %r13
         push    %r14
@@ -271,12 +273,14 @@ VARIABLE_OFFSET = 16*8
 .endm
 
 .macro FUNC_RESTORE
+        add     $VARIABLE_OFFSET, %rsp
         mov     %r14, %rsp
 
         pop     %r15
         pop     %r14
         pop     %r13
         pop     %r12
+	pop	%rbp
 .endm
 
 # Encryption of a single block

