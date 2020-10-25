Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 935E2298345
	for <lists+netdev@lfdr.de>; Sun, 25 Oct 2020 20:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1418410AbgJYTCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 15:02:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32458 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1418292AbgJYTCA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 15:02:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603652518;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BGYYbeOUVxMYaHuYkxjYEJkD6yPBT01Arx7rxv8kaXk=;
        b=SyzP599cG9a4rX8JOpi447lX3jLkvLooAzS8FXhf0p5mizGnW4/ocMxKC7EuchLVG59LMa
        0P5vE2j7zb+mEDDG+4PGthtvrCc5Y8VWCe0Xl2RgasV40TuZW5xHYRpw/pvdCsh+CLcMtw
        6jzQKMSd+Y50y30Dn/kF60VNIzQmjuo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-161-a8x1wfycPiWSy-On5nKisw-1; Sun, 25 Oct 2020 15:01:56 -0400
X-MC-Unique: a8x1wfycPiWSy-On5nKisw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6B3741DDFA;
        Sun, 25 Oct 2020 19:01:54 +0000 (UTC)
Received: from krava (unknown [10.40.192.51])
        by smtp.corp.redhat.com (Postfix) with SMTP id 204A45D9CD;
        Sun, 25 Oct 2020 19:01:47 +0000 (UTC)
Date:   Sun, 25 Oct 2020 20:01:47 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, Daniel Xu <dxu@dxuuu.xyz>,
        Jesper Brouer <jbrouer@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Viktor Malik <vmalik@redhat.com>
Subject: Re: [RFC bpf-next 00/16] bpf: Speed up trampoline attach
Message-ID: <20201025190147.GA2681365@krava>
References: <20201022082138.2322434-1-jolsa@kernel.org>
 <20201022093510.37e8941f@gandalf.local.home>
 <20201022141154.GB2332608@krava>
 <20201022104205.728dd135@gandalf.local.home>
 <20201022122150.45e81da0@gandalf.local.home>
 <20201022165229.34cd5141@gandalf.local.home>
 <20201023060932.GF2332608@krava>
 <20201023095020.3793cf22@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023095020.3793cf22@gandalf.local.home>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 23, 2020 at 09:50:20AM -0400, Steven Rostedt wrote:

SNIP

> Is there something to keep an eBPF program from tracing a function with 6
> args? If the program saves only 5 args, but traces a function that has 6
> args, then the tracing program may end up using the register that the 6
> argument is in, and corrupting it.
> 
> I'm looking at bpf/trampoline.c, that has:
> 
> 	arch_prepare_bpf_trampoline(new_image, ...)
> 
> and that new_image is passed into:
> 
> 	register_ftrace_direct(ip, new_addr);
> 
> where new_addr == new_image.
> 
> And I don't see anywhere in the creating on that new_image that saves the
> 6th parameter.

  arch_prepare_bpf_trampoline
    ...
    save_regs(m, &prog, nr_args, stack_size);

> 
> The bpf program calls some helper functions which are allowed to clobber
> %r9 (where the 6th parameter is stored on x86_64). That means, when it
> returns to the function it traced, the 6th parameter is no longer correct.
> 
> At a minimum, direct callers must save all the parameters used by the
> function, not just what the eBPF code may use.
> 
> > 
> > > 
> > > The code in question is this:
> > > 
> > > int btf_distill_func_proto(struct bpf_verifier_log *log,
> > > 			   struct btf *btf,
> > > 			   const struct btf_type *func,
> > > 			   const char *tname,
> > > 			   struct btf_func_model *m)
> > > {
> > > 	const struct btf_param *args;
> > > 	const struct btf_type *t;
> > > 	u32 i, nargs;
> > > 	int ret;
> > > 
> > > 	if (!func) {
> > > 		/* BTF function prototype doesn't match the verifier types.
> > > 		 * Fall back to 5 u64 args.
> > > 		 */
> > > 		for (i = 0; i < 5; i++)
> > > 			m->arg_size[i] = 8;
> > > 		m->ret_size = 8;
> > > 		m->nr_args = 5;
> > > 		return 0;
> > > 	}

the fallback code in btf_distill_func_proto you're reffering to
is for case of tracing another ebpf program, when hooking to
kernel function, all args are used with no fallback to 5 args

I'm not sure what are the rules wrt args count when tracing
another ebpf program

jirka

