Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE5F39E647
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 20:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhFGSPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 14:15:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38225 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230212AbhFGSPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 14:15:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623089595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=asb/9Oxq6iV6eknKm5P2s6yb7SzFrvOXop8qlFBN3c4=;
        b=QyA8jldDco6czzGF4xjpL8+LFit1gdTjcCmQf16ztgS+XS2Xwm/ON6qxHVtzCGCTgNHhZ1
        qvrdPSbTRD/JPX7OxP61pciWp2jpw38WlE8RDEoBEqAjK9S8OpG5SRhkXfxp47oskz/0yh
        JkXV3YvEv5ETHFXB5jIyUeeJEE2RvNM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-kJga-Xd1OcaTyCfV1CIyKg-1; Mon, 07 Jun 2021 14:13:14 -0400
X-MC-Unique: kJga-Xd1OcaTyCfV1CIyKg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EAD52106BAB9;
        Mon,  7 Jun 2021 18:13:11 +0000 (UTC)
Received: from krava (unknown [10.40.192.167])
        by smtp.corp.redhat.com (Postfix) with SMTP id A731C620DE;
        Mon,  7 Jun 2021 18:13:08 +0000 (UTC)
Date:   Mon, 7 Jun 2021 20:13:07 +0200
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
Subject: Re: [PATCH 09/19] bpf, x64: Allow to use caller address from stack
Message-ID: <YL5hs/xi3RpbLlKy@krava>
References: <20210605111034.1810858-1-jolsa@kernel.org>
 <20210605111034.1810858-10-jolsa@kernel.org>
 <e590aa58-bdfa-86c1-eaca-79b4e5bff1f3@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e590aa58-bdfa-86c1-eaca-79b4e5bff1f3@fb.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 06, 2021 at 08:07:44PM -0700, Yonghong Song wrote:
> 
> 
> On 6/5/21 4:10 AM, Jiri Olsa wrote:
> > Currently we call the original function by using the absolute address
> > given at the JIT generation. That's not usable when having trampoline
> > attached to multiple functions. In this case we need to take the
> > return address from the stack.
> 
> Here, it is mentioned to take the return address from the stack.
> 
> > 
> > Adding support to retrieve the original function address from the stack
> 
> Here, it is said to take original funciton address from the stack.

sorry if the description is confusing as always, the idea
is to take the function's return address from fentry call:

   function
     call fentry
     xxxx             <---- this address 

and use it to call the original function body before fexit handler

jirka

> 
> > by adding new BPF_TRAMP_F_ORIG_STACK flag for arch_prepare_bpf_trampoline
> > function.
> > 
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >   arch/x86/net/bpf_jit_comp.c | 13 +++++++++----
> >   include/linux/bpf.h         |  5 +++++
> >   2 files changed, 14 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/net/bpf_jit_comp.c b/arch/x86/net/bpf_jit_comp.c
> > index 2a2e290fa5d8..b77e6bd78354 100644
> > --- a/arch/x86/net/bpf_jit_comp.c
> > +++ b/arch/x86/net/bpf_jit_comp.c
> > @@ -2013,10 +2013,15 @@ int arch_prepare_bpf_trampoline(struct bpf_tramp_image *im, void *image, void *i
> >   	if (flags & BPF_TRAMP_F_CALL_ORIG) {
> >   		restore_regs(m, &prog, nr_args, stack_size);
> > -		/* call original function */
> > -		if (emit_call(&prog, orig_call, prog)) {
> > -			ret = -EINVAL;
> > -			goto cleanup;
> > +		if (flags & BPF_TRAMP_F_ORIG_STACK) {
> > +			emit_ldx(&prog, BPF_DW, BPF_REG_0, BPF_REG_FP, 8);
> 
> This is load double from base_pointer + 8 which should be func return
> address for x86, yet we try to call it.
> I guess I must have missed something
> here. Could you give some explanation?
> 
> > +			EMIT2(0xff, 0xd0); /* call *rax */
> > +		} else {
> > +			/* call original function */
> > +			if (emit_call(&prog, orig_call, prog)) {
> > +				ret = -EINVAL;
> > +				goto cleanup;
> > +			}
> >   		}
> >   		/* remember return value in a stack for bpf prog to access */
> >   		emit_stx(&prog, BPF_DW, BPF_REG_FP, BPF_REG_0, -8);
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index 86dec5001ae2..16fc600503fb 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -554,6 +554,11 @@ struct btf_func_model {
> >    */
> >   #define BPF_TRAMP_F_SKIP_FRAME		BIT(2)
> > +/* Get original function from stack instead of from provided direct address.
> > + * Makes sense for fexit programs only.
> > + */
> > +#define BPF_TRAMP_F_ORIG_STACK		BIT(3)
> > +
> >   /* Each call __bpf_prog_enter + call bpf_func + call __bpf_prog_exit is ~50
> >    * bytes on x86.  Pick a number to fit into BPF_IMAGE_SIZE / 2
> >    */
> > 
> 

