Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D40239E64F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:15:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbhFGSRg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:17:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37007 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230316AbhFGSRf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:17:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623089743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nmsvIH7jJcORAKoc1AzQ0n7U+J/SmLHSILZ4a3vgCdo=;
        b=RkHYHcUK+5Xu0oaSXkI7vGdZfRcoMoM3MkcfRZTNGdc17g2yknyTRSa45rThG4d3Jeqco7
        SOvbi2CDmB2TGy6SpwmrHCiMfo0guWX12XkW+RsY6WA1A5QPe/a93VZJqCdF/P+JMQy/EK
        zICNmWOrC58sPpGE0LYG+H1eN5RK9qw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-KEzEeyYeOQGZv6QW_cC4rw-1; Mon, 07 Jun 2021 14:15:39 -0400
X-MC-Unique: KEzEeyYeOQGZv6QW_cC4rw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9242C101371C;
        Mon,  7 Jun 2021 18:15:37 +0000 (UTC)
Received: from krava (unknown [10.40.192.167])
        by smtp.corp.redhat.com (Postfix) with SMTP id DC6A0620DE;
        Mon,  7 Jun 2021 18:15:34 +0000 (UTC)
Date:   Mon, 7 Jun 2021 20:15:33 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [PATCH 10/19] bpf: Allow to store caller's ip as argument
Message-ID: <YL5iRT59TpOiUWe3@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-11-jolsa@kernel.org>
 <03777e58-a2b0-83b5-959f-3ae4afadb191@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03777e58-a2b0-83b5-959f-3ae4afadb191@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 08:21:51PM -0700, Yonghong Song wrote:
> 
> 
> On 6/5/21 4:10 AM, Jiri Olsa wrote:
> > When we will have multiple functions attached to trampoline
> > we need to propagate the function's address to the bpf program.
> > 
> > Adding new BPF_TRAMP_F_IP_ARG flag to arch_prepare_bpf_trampoline
> > function that will store origin caller's address before function's
> > arguments.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   arch/x86/net/bpf_jit_comp.c | 18 ++++++++++++++----
> >   include/linux/bpf.h         |  5 +++++
> >   2 files changed, 19 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index b77e6bd78354..d2425c18272a 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -1951,7 +1951,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >   				void *orig_call)
> >   {
> >   	int ret, i, cnt = 0, nr_args = m->nr_args;
> > -	int stack_size = nr_args * 8;
> > +	int stack_size = nr_args * 8, ip_arg = 0;
> >   	struct bpf_tramp_progs *fentry = &tprogs[BPF_TRAMP_FENTRY];
> >   	struct bpf_tramp_progs *fexit = &tprogs[BPF_TRAMP_FEXIT];
> >   	struct bpf_tramp_progs *fmod_ret = &tprogs[BPF_TRAMP_MODIFY_RETURN];
> > @@ -1975,6 +1975,9 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >   		 */
> >   		orig_call += X86_PATCH_SIZE;
> > +	if (flags & BPF_TRAMP_F_IP_ARG)
> > +		stack_size += 8;
> > +
> >   	prog = image;
> >   	EMIT1(0x55);		 /* push rbp */
> > @@ -1982,7 +1985,14 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >   	EMIT4(0x48, 0x83, 0xEC, stack_size); /* sub rsp, stack_size */
> >   	EMIT1(0x53);		 /* push rbx */
> > -	save_regs(m, &prog, nr_args, stack_size);
> > +	if (flags & BPF_TRAMP_F_IP_ARG) {
> > +		emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> > +		EMIT4(0x48, 0x83, 0xe8, X86_PATCH_SIZE); /* sub $X86_PATCH_SIZE,%rax*/
> 
> Could you explain what the above EMIT4 is for? I am not quite familiar with
> this piece of code and hence the question. Some comments here
> should help too.

it's there to generate the 'sub $X86_PATCH_SIZE,%rax' instruction
to get the real IP address of the traced function, and it's stored
to stack on the next line

I'll put more comments in there

jirka

> 
> > +		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -stack_size);
> > +		ip_arg = 8;
> > +	}
> > +
> > +	save_regs(m, &prog, nr_args, stack_size - ip_arg);
> >   	if (flags & BPF_TRAMP_F_CALL_ORIG) {
> >   		/* arg1: mov rdi, im */
> > @@ -2011,7 +2021,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >   	}
> >   	if (flags & BPF_TRAMP_F_CALL_ORIG) {
> > -		restore_regs(m, &prog, nr_args, stack_size);
> > +		restore_regs(m, &prog, nr_args, stack_size - ip_arg);
> >   		if (flags & BPF_TRAMP_F_ORIG_STACK) {
> >   			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> > @@ -2052,7 +2062,7 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >   		}
> >   	if (flags & BPF_TRAMP_F_RESTORE_REGS)
> > -		restore_regs(m, &prog, nr_args, stack_size);
> > +		restore_regs(m, &prog, nr_args, stack_size - ip_arg);
> >   	/* This needs to be done regardless. If there were fmod_ret programs,
> >   	 * the return value is only updated on the stack and still needs to be
> [...]
> 

