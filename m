Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66B95177D88
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 18:33:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730403AbgCCRd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 12:33:28 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29203 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729404AbgCCRd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 12:33:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583256807;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=t3VUKeKMtCwkPgBiUPQfBvitvta7PhFFKojqZLwQqW8=;
        b=fBUL4OVArG7s6+HZub+qwgKizrFTCL81JOXG7R3Gll9WpRZnMES3SpZLW6KbjIr54MO6VF
        evYpW04CwvYNzH2EOlNTojeyCSto4hdKwC6d60Tx8VuIr8kpRQwOSfyh9mBICxw9s1VBor
        QGLbn6jz6VOSM/J6syIbWD341QH1lcU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-48-ceeY5CPdPUK73-ZoYSsq1Q-1; Tue, 03 Mar 2020 12:33:23 -0500
X-MC-Unique: ceeY5CPdPUK73-ZoYSsq1Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BCF7E107ACC4;
        Tue,  3 Mar 2020 17:33:21 +0000 (UTC)
Received: from krava (ovpn-206-59.brq.redhat.com [10.40.206.59])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02F405D9C9;
        Tue,  3 Mar 2020 17:33:17 +0000 (UTC)
Date:   Tue, 3 Mar 2020 18:33:14 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [RFC] libbpf,selftests: Question on btf_dump__emit_type_decl for
 BTF_KIND_FUNC
Message-ID: <20200303173314.GA74093@krava>
References: <20200303140837.90056-1-jolsa@kernel.org>
 <CAEf4BzY8_=wcL3N96eS-jcSPBL=ueMgQg+m=Fxiw+o0Tc7F23Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY8_=wcL3N96eS-jcSPBL=ueMgQg+m=Fxiw+o0Tc7F23Q@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 03, 2020 at 09:09:38AM -0800, Andrii Nakryiko wrote:
> On Tue, Mar 3, 2020 at 6:12 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > hi,
> > for bpftrace I'd like to print BTF functions (BTF_KIND_FUNC)
> > declarations together with their names.
> >
> > I saw we have btf_dump__emit_type_decl and added BTF_KIND_FUNC,
> > where it seemed to be missing, so it prints out something now
> > (not sure it's the right fix though).
> >
> > Anyway, would you be ok with adding some flag/bool to struct
> > btf_dump_emit_type_decl_opts, so I could get output like:
> >
> >   kfunc:ksys_readahead(int fd, long long int offset, long unsigned int count) = ssize_t
> >   kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t
> >
> > ... to be able to the arguments and return type separated,
> > so I could easily get to something like above?
> >
> > Current interface is just vfprintf callback and I'm not sure
> > I can rely that it will allywas be called with same arguments,
> > like having separated calls for parsed atoms like 'return type',
> > '(', ')', '(', 'arg type', 'arg name', ...
> >
> > I'm open to any suggestion ;-)
> 
> Hey Jiri!
> 
> Can you please elaborate on the use case and problem you are trying to solve?
> 
> I think we can (and probably even should) add such option and support
> to dump functions, but whatever we do it should be a valid C syntax
> and should be compilable.
> Example above:
> 
> kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t
> 
> Is this really the syntax you need to get? I think btf_dump, when
> (optionally) emitting function declaration, will have to emit that
> particular one as:
> 
> size_t ksys_read(unsigned int fd, char buf, long unsigned int count);
> 
> But I'd like to hear the use case before we add this. Thanks!

the use case is just for the 'bpftrace -l' output, which displays
the probe names that could be used.. for kernel BTF kernel functions
it's 'kfunc:function(args)'

	software:task-clock:
	hardware:backend-stalls:
	hardware:branch-instructions:
	...
	tracepoint:kvmmmu:kvm_mmu_pagetable_walk
	tracepoint:kvmmmu:kvm_mmu_paging_element
	...
	kprobe:console_on_rootfs
	kprobe:trace_initcall_start_cb
	kprobe:run_init_process
	kprobe:try_to_run_init_process
	...
	kfunc:x86_reserve_hardware
	kfunc:hw_perf_lbr_event_destroy
	kfunc:x86_perf_event_update

I dont want to print the return type as is in C, because it would
mess up the whole output, hence the '= <return type>'

	kfunc:ksys_readahead(int fd, long long int offset, long unsigned int count) = ssize_t
	kfunc:ksys_read(unsigned int fd, char buf, long unsigned int count) = size_t

also possible only in verbose mode ;-)

the final shape of the format will be decided in a bpftrace review,
but in any case I think I'll need some way to get these bits:
  <args> <return type>


thanks,
jirka

