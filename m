Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D176135DF7E
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 14:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240321AbhDMMzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 08:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231493AbhDMMzu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 08:55:50 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5674A613B3;
        Tue, 13 Apr 2021 12:55:24 +0000 (UTC)
Date:   Tue, 13 Apr 2021 08:55:22 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Yonghong Song <yhs@fb.com>,
        syzbot <syzbot+774c590240616eaa3423@syzkaller.appspotmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, andrii@kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Borislav Petkov <bp@alien8.de>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Joerg Roedel <joro@8bytes.org>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, masahiroy@kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        rafael.j.wysocki@intel.com,
        Sean Christopherson <seanjc@google.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Thomas Gleixner <tglx@linutronix.de>, vkuznets@redhat.com,
        wanpengli@tencent.com, will@kernel.org, x86@kernel.org
Subject: Re: [syzbot] WARNING in bpf_test_run
Message-ID: <20210413085522.2caee809@gandalf.local.home>
In-Reply-To: <CACT4Y+ZYEVsycyzDW9+tXYw-5feZS8otgMWGGZRUCLR=czWtqQ@mail.gmail.com>
References: <000000000000d9fefa05bee78afd@google.com>
        <97b5573f-9fcc-c195-f765-5b1ed84a95bd@fb.com>
        <d947c28c-6ede-5950-87e7-f56b8403535a@fb.com>
        <CACT4Y+ZYEVsycyzDW9+tXYw-5feZS8otgMWGGZRUCLR=czWtqQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 13 Apr 2021 09:56:40 +0200
Dmitry Vyukov <dvyukov@google.com> wrote:

> Thanks for looking into this.
> If this is not a kernel bug, then it must not use WARN_ON[_ONCE]. It
> makes the kernel untestable for both automated systems and humans:
> 
> https://lwn.net/Articles/769365/
> 
> <quote>
> Greg Kroah-Hartman raised the problem of core kernel API code that
> will use WARN_ON_ONCE() to complain about bad usage; that will not
> generate the desired result if WARN_ON_ONCE() is configured to crash
> the machine. He was told that the code should just call pr_warn()
> instead, and that the called function should return an error in such
> situations. It was generally agreed that any WARN_ON() or
> WARN_ON_ONCE() calls that can be triggered from user space need to be
> fixed.
> </quote>

I agree. WARN_ON(_ONCE) should be reserved for anomalies that should not
happen ever. Anything that the user could trigger, should not trigger a
WARN_ON.

A WARN_ON is perfectly fine for detecting an accounting error inside the
kernel. I have them scattered all over my code, but they should never be
hit, even if something in user space tries to hit it. (with an exception of
an interface I want to deprecate, where I want to know if it's still being
used ;-) Of course, that wouldn't help bots testing the code. And I haven't
done that in years)

Any anomaly that can be triggered by user space doing something it should
not be doing really needs a pr_warn().

Thanks,

-- Steve
