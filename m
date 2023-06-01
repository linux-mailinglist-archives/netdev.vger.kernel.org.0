Return-Path: <netdev+bounces-7073-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4404A719A85
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:07:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CC7F51C20ADE
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:07:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D67A92341E;
	Thu,  1 Jun 2023 11:07:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83C8423404;
	Thu,  1 Jun 2023 11:07:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A781FC433D2;
	Thu,  1 Jun 2023 11:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685617670;
	bh=+Yjm8puKI4qcOhrAjHQoPXnOlN6+/fj9nQ2KMrVKq+A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RhP2k+/FQSvli7tGw2eOKlboTIMhAX1rWIMmQojkSItsf7Pbu27Voz4XKQfKsJMv+
	 yk64a7+GnLa0AXm5NTg7oxgCbiU/vvM5YtvO42iXWm3c1dvWeuqaT9QYECD04AjLI8
	 +kurm3Gcj765DCLAHDCbNzTJmkHWERuX8j+NWUQrH79TGx2XeQSd0dO1NOebia9EMt
	 dJu6ZE7ylH9284d9jqvK6St/2YUkHNw8jD2OIGo2TbwtTLSoShdT9QABDGhevJVWTD
	 pUczYlcvfwWLpOJgcn012xrthp2r+mfy68euX8CFvo6UC393XjO1m9JQnHYF6C6kEn
	 C9f6ivmZ7x+Ew==
Date: Thu, 1 Jun 2023 14:07:13 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"David S. Miller" <davem@davemloft.net>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Heiko Carstens <hca@linux.ibm.com>, Helge Deller <deller@gmx.de>,
	Huacai Chen <chenhuacai@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Russell King <linux@armlinux.org.uk>, Song Liu <song@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org,
	linux-modules@vger.kernel.org, linux-parisc@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	loongarch@lists.linux.dev, netdev@vger.kernel.org,
	sparclinux@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 12/13] x86/jitalloc: prepare to allocate exectuatble
 memory as ROX
Message-ID: <20230601110713.GE395338@kernel.org>
References: <20230601101257.530867-1-rppt@kernel.org>
 <20230601101257.530867-13-rppt@kernel.org>
 <20230601103050.GT4253@hirez.programming.kicks-ass.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230601103050.GT4253@hirez.programming.kicks-ass.net>

On Thu, Jun 01, 2023 at 12:30:50PM +0200, Peter Zijlstra wrote:
> On Thu, Jun 01, 2023 at 01:12:56PM +0300, Mike Rapoport wrote:
> 
> > +static void __init_or_module do_text_poke(void *addr, const void *opcode, size_t len)
> > +{
> > +	if (system_state < SYSTEM_RUNNING) {
> > +		text_poke_early(addr, opcode, len);
> > +	} else {
> > +		mutex_lock(&text_mutex);
> > +		text_poke(addr, opcode, len);
> > +		mutex_unlock(&text_mutex);
> > +	}
> > +}
> 
> So I don't much like do_text_poke(); why?

I believe the idea was to keep memcpy for early boot before the kernel
image is protected without going and adding if (is_module_text_address())
all over the place.

I think this can be used instead without updating all the call sites of
text_poke_early():

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 91057de8e6bc..f994e63e9903 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -1458,7 +1458,7 @@ void __init_or_module text_poke_early(void *addr, const void *opcode,
 		 * code cannot be running and speculative code-fetches are
 		 * prevented. Just change the code.
 		 */
-		memcpy(addr, opcode, len);
+		text_poke_copy(addr, opcode, len);
 	} else {
 		local_irq_save(flags);
 		memcpy(addr, opcode, len);
 
> > diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
> > index aa99536b824c..d50595f2c1a6 100644
> > --- a/arch/x86/kernel/ftrace.c
> > +++ b/arch/x86/kernel/ftrace.c
> > @@ -118,10 +118,13 @@ ftrace_modify_code_direct(unsigned long ip, const char *old_code,
> >  		return ret;
> >  
> >  	/* replace the text with the new text */
> > -	if (ftrace_poke_late)
> > +	if (ftrace_poke_late) {
> >  		text_poke_queue((void *)ip, new_code, MCOUNT_INSN_SIZE, NULL);
> > -	else
> > -		text_poke_early((void *)ip, new_code, MCOUNT_INSN_SIZE);
> > +	} else {
> > +		mutex_lock(&text_mutex);
> > +		text_poke((void *)ip, new_code, MCOUNT_INSN_SIZE);
> > +		mutex_unlock(&text_mutex);
> > +	}
> >  	return 0;
> >  }
> 
> And in the above case it's actively wrong for loosing the _queue()
> thing.

-- 
Sincerely yours,
Mike.

