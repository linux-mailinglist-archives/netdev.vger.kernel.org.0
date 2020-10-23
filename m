Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF352970E1
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 15:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1750121AbgJWNuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 09:50:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:49428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750116AbgJWNuZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 09:50:25 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B63420FC3;
        Fri, 23 Oct 2020 13:50:22 +0000 (UTC)
Date:   Fri, 23 Oct 2020 09:50:20 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 00/16] bpf: Speed up trampoline attach
Message-ID: <20201023095020.3793cf22@gandalf.local.home>
In-Reply-To: <20201023060932.GF2332608@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
        <20201022093510.37e8941f@gandalf.local.home>
        <20201022141154.GB2332608@krava>
        <20201022104205.728dd135@gandalf.local.home>
        <20201022122150.45e81da0@gandalf.local.home>
        <20201022165229.34cd5141@gandalf.local.home>
        <20201023060932.GF2332608@krava>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 08:09:32 +0200
Jiri Olsa <jolsa@redhat.com> wrote:
> > 
> > The below is a quick proof of concept patch I whipped up. It will always
> > save 6 arguments, so if BPF is really interested in just saving the bare
> > minimum of arguments before calling, it can still use direct. But if you
> > are going to have a generic callback, you'll need to save all parameters
> > otherwise you can corrupt the function's parameter if traced function uses
> > more than you save.  
> 
> nice, I'll take a look, thanks for quick code ;-)

Playing with it more, I have it where I don't add a new ARGS flag, but just
make that the default (if arch supports it). And with this change, I even
have function graph working directly with the function tracer, and I can
now get rid of the function graph trampoline! Of course, this will be a
slow process because it has to be changed across architectures, but with a
HAVE_FTRACE_ARGS flag, I can do it one by one.

> 
> > 
> > Which looking at the bpf trampoline code, I noticed that if the verifier
> > can't find the btf func, it falls back to saving 5 parameters. Which can be
> > a bug on x86 if the function itself uses 6 or more. If you only save 5
> > parameters, then call a bpf program that calls a helper function that uses
> > more than 5 parameters, it will likely corrupt the 6th parameter of the
> > function being traced.  
> 
> number of args from eBPF program to in-kernel function is
> restricted to 5, so we should be fine

Is there something to keep an eBPF program from tracing a function with 6
args? If the program saves only 5 args, but traces a function that has 6
args, then the tracing program may end up using the register that the 6
argument is in, and corrupting it.

I'm looking at bpf/trampoline.c, that has:

	arch_prepare_bpf_trampoline(new_image, ...)

and that new_image is passed into:

	register_ftrace_direct(ip, new_addr);

where new_addr == new_image.

And I don't see anywhere in the creating on that new_image that saves the
6th parameter.

The bpf program calls some helper functions which are allowed to clobber
%r9 (where the 6th parameter is stored on x86_64). That means, when it
returns to the function it traced, the 6th parameter is no longer correct.

At a minimum, direct callers must save all the parameters used by the
function, not just what the eBPF code may use.

> 
> > 
> > The code in question is this:
> > 
> > int btf_distill_func_proto(struct bpf_verifier_log *log,
> > 			   struct btf *btf,
> > 			   const struct btf_type *func,
> > 			   const char *tname,
> > 			   struct btf_func_model *m)
> > {
> > 	const struct btf_param *args;
> > 	const struct btf_type *t;
> > 	u32 i, nargs;
> > 	int ret;
> > 
> > 	if (!func) {
> > 		/* BTF function prototype doesn't match the verifier types.
> > 		 * Fall back to 5 u64 args.
> > 		 */
> > 		for (i = 0; i < 5; i++)
> > 			m->arg_size[i] = 8;
> > 		m->ret_size = 8;
> > 		m->nr_args = 5;
> > 		return 0;
> > 	}
> > 
> > Shouldn't it be falling back to 6, not 5?  
> 
> but looks like this actualy could fallback to 6, jit would
> allow that, but I'm not sure if there's another restriction


Either way, the direct trampoline must save all registers used by
parameters of the function, and if it doesn't know how many parameters are
used, it must save all possible ones (like ftrace does).

-- Steve
