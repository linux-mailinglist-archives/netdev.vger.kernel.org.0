Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A473E35E5CC
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 20:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347455AbhDMSA6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 14:00:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:47172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237095AbhDMSA5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 14:00:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AAB07613B6;
        Tue, 13 Apr 2021 18:00:35 +0000 (UTC)
Date:   Tue, 13 Apr 2021 19:00:33 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Liam Howlett <liam.howlett@oracle.com>
Cc:     Andre Przywara <andre.przywara@arm.com>,
        Will Deacon <will@kernel.org>,
        Peter Collingbourne <pcc@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Amit Daniel Kachhap <amit.kachhap@arm.com>
Subject: Re: [PATCH] arch/arm64/kernel/traps: Use find_vma_intersection() in
 traps for setting si_code
Message-ID: <20210413180030.GA31164@arm.com>
References: <20210407150940.542103-1-Liam.Howlett@Oracle.com>
 <20210412174343.GG2060@arm.com>
 <20210413143035.7zrct6a3up42uaoo@revolver>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210413143035.7zrct6a3up42uaoo@revolver>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 13, 2021 at 04:52:34PM +0000, Liam Howlett wrote:
> * Catalin Marinas <catalin.marinas@arm.com> [210412 13:44]:
> > On Wed, Apr 07, 2021 at 03:11:06PM +0000, Liam Howlett wrote:
> > > find_vma() will continue to search upwards until the end of the virtual
> > > memory space.  This means the si_code would almost never be set to
> > > SEGV_MAPERR even when the address falls outside of any VMA.  The result
> > > is that the si_code is not reliable as it may or may not be set to the
> > > correct result, depending on where the address falls in the address
> > > space.
> > > 
> > > Using find_vma_intersection() allows for what is intended by only
> > > returning a VMA if it falls within the range provided, in this case a
> > > window of 1.
> > > 
> > > Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
> > > ---
> > >  arch/arm64/kernel/traps.c | 3 ++-
> > >  1 file changed, 2 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
> > > index a05d34f0e82a..a44007904a64 100644
> > > --- a/arch/arm64/kernel/traps.c
> > > +++ b/arch/arm64/kernel/traps.c
> > > @@ -383,9 +383,10 @@ void force_signal_inject(int signal, int code, unsigned long address, unsigned i
> > >  void arm64_notify_segfault(unsigned long addr)
> > >  {
> > >  	int code;
> > > +	unsigned long ut_addr = untagged_addr(addr);
> > >  
> > >  	mmap_read_lock(current->mm);
> > > -	if (find_vma(current->mm, untagged_addr(addr)) == NULL)
> > > +	if (find_vma_intersection(current->mm, ut_addr, ut_addr + 1) == NULL)
> > >  		code = SEGV_MAPERR;
> > >  	else
> > >  		code = SEGV_ACCERR;
[...]
> > I don't think your change is entirely correct either. We can have a
> > fault below the vma of a stack (with VM_GROWSDOWN) and
> > find_vma_intersection() would return NULL but it should be a SEGV_ACCERR
> > instead.
> 
> I'm pretty sure I am missing something.  From what you said above, I
> think this means that there can be a user cache fault below the stack
> which should notify the user application that they are not allowed to
> expand the stack by sending a SIGV_ACCERR in the si_code?  Is this
> expected behaviour or am I missing a code path to this function?

My point was that find_vma() may return a valid vma where addr < vm_end
but also addr < vm_addr. It's the responsibility of the caller to check
that that vma can be expanded (VM_GROWSDOWN) and we do something like
this in __do_page_fault(). find_vma_intersection(), OTOH, requires addr
>= vm_start.

If we hit this case (addr < vm_start), normally we'd first need to check
whether it's expandable and, if not, return MAPERR. If it's expandable,
it should be ACCERR since something else caused the fault.

Now, I think at least for user_cache_maint_handler(), we can assume that
__do_page_fault() handled any expansion already, so we don't need to
check it here. In this case, your find_vma_intersection() check should
work.

Are there other cases where we invoke arm64_notify_segfault() without a
prior fault? I think in swp_handler() we can bail out early before we
even attempted the access so we may report MAPERR but ACCERR is a better
indication. Also in sys_rt_sigreturn() we always call it as
arm64_notify_segfault(regs->sp). I'm not sure that's correct in all
cases, see restore_altstack().

I guess this code needs some tidying up.

> > Maybe this should employ similar checks as __do_page_fault() (with
> > expand_stack() and VM_GROWSDOWN).
> 
> You mean the code needs to detect endianness and to check if this is an
> attempt to expand the stack for both cases?

Nothing to do with endianness, just the relation between the address and
the vma->vm_start and whether the vma can be expanded down.

-- 
Catalin
