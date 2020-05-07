Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71FDF1C852E
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 10:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgEGIzR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 04:55:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725893AbgEGIzR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 May 2020 04:55:17 -0400
Received: from devnote2 (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3802920747;
        Thu,  7 May 2020 08:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588841716;
        bh=2rRtBeEe+O1amTFJUbeUMeJ0XI46x1e1eUXvVqKp1hE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=plo2REbd4A2bWBKbDHeIg7laLyZSQ4qCyoG5uA746OXoYcDDe9h2eu7Dk76h0KnGl
         jMsZc6JYFuIZa/l5v7OuQHT9VEyq0H/mdTXKkEiX8GBwV975Vb14OysRe7UTLuTl2Z
         wdP2UthEHWeoYoqhGorpWjX7UvBh3hPPVI7T2ptU=
Date:   Thu, 7 May 2020 17:55:12 +0900
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [RFC PATCH bpf-next 0/3] bpf: add tracing for XDP programs
 using the BPF_PROG_TEST_RUN API
Message-Id: <20200507175512.b2a01b872750dbfe94f6642b@kernel.org>
In-Reply-To: <CAADnVQKyfJPujoef6+sV7hJf9kVBjZKur_yjW8GJtTYS-c_Knw@mail.gmail.com>
References: <158453675319.3043.5779623595270458781.stgit@xdp-tutorial>
        <819b1b3a-c801-754b-e805-7ec8266e5dfa@fb.com>
        <D0164AC9-7AF7-4434-B6D1-0A761DC626FB@redhat.com>
        <fefda00a-1a08-3a53-efbc-93c36292b77d@fb.com>
        <CAADnVQ+SCu97cF5Li6nBBCkshjF45U-nPEO5jO8DQrY5PqPqyg@mail.gmail.com>
        <F97A3E80-9C99-49CF-84C5-F09C940F7029@redhat.com>
        <20200428040424.wvozrsy6uviz33ha@ast-mbp.dhcp.thefacebook.com>
        <78EFC9DD-48A2-49BB-8C76-1E6FDE808067@redhat.com>
        <20200428121947.GC2245@kernel.org>
        <20200501114420.5a33d7483f43aaeff95d31dc@kernel.org>
        <CAADnVQKyfJPujoef6+sV7hJf9kVBjZKur_yjW8GJtTYS-c_Knw@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 May 2020 18:25:38 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Thu, Apr 30, 2020 at 7:44 PM Masami Hiramatsu <mhiramat@kernel.org> wrote:
> >
> > On Tue, 28 Apr 2020 09:19:47 -0300
> > Arnaldo Carvalho de Melo <acme@kernel.org> wrote:
> >
> > > Em Tue, Apr 28, 2020 at 12:47:53PM +0200, Eelco Chaudron escreveu:
> > > > On 28 Apr 2020, at 6:04, Alexei Starovoitov wrote:
> > > > > On Fri, Apr 24, 2020 at 02:29:56PM +0200, Eelco Chaudron wrote:
> > >
> > > > > > > But in reality I think few kprobes in the prog will be enough to
> > > > > > > debug the program and XDP prog may still process millions of
> > > > > > > packets because your kprobe could be in error path and the user
> > > > > > > may want to capture only specific things when it triggers.
> > >
> > > > > > > kprobe bpf prog will execute in such case and it can capture
> > > > > > > necessary state from xdp prog, from packet or from maps that xdp
> > > > > > > prog is using.
> > >
> > > > > > > Some sort of bpf-gdb would be needed in user space.  Obviously
> > > > > > > people shouldn't be writing such kprob-bpf progs that debug
> > > > > > > other bpf progs by hand. bpf-gdb should be able to generate them
> > > > > > > automatically.
> > >
> > > > > > See my opening comment. What you're describing here is more when
> > > > > > the right developer has access to the specific system. But this
> > > > > > might not even be possible in some environments.
> > >
> > > > > All I'm saying that kprobe is a way to trace kernel.
> > > > > The same facility should be used to trace bpf progs.
> > >
> > > > perf doesn’t support tracing bpf programs, do you know of any tools that
> > > > can, or you have any examples that would do this?
> > >
> > > I'm discussing with Yonghong and Masami what would be needed for 'perf
> > > probe' to be able to add kprobes to BPF jitted areas in addition to
> > > vmlinux and modules.
> >
> > At a grance, at first we need a debuginfo which maps the source code and
> > BPF binaries. We also need to get a map from the kernel indicating
> > which instructions the bpf code was jited to.
> > Are there any such information?
> 
> it's already there. Try 'bpftool prog dump jited id N'
> It will show something like this:
> ; data = ({typeof(errors.leaf) *leaf =
> bpf_map_lookup_elem_(bpf_pseudo_fd(1, -11), &type_key); if (!leaf) {
> bpf_map_update_elem_(bpf_pseudo_fd(1, -11), &type_key, &zero,
> BPF_NOEXIST); leaf = bpf_map_lookup_elem_(bpf_pseudo_fd(1, -11), &t;
>  81d:    movabs $0xffff8881a0679000,%rdi
> ; return bpf_map_lookup_elem((void *)map, key);
>  827:    mov    %rbx,%rsi
>  82a:    callq  0xffffffffe0f7f448
>  82f:    test   %rax,%rax
>  832:    je     0x0000000000000838
>  834:    add    $0x40,%rax
> ; if (!data)
>  838:    test   %rax,%rax
>  83b:    je     0x0000000000000846
>  83d:    mov    $0x1,%edi
> ; lock_xadd(data, 1);
>  842:    lock add %edi,0x0(%rax)

Hm, so bpftool or libbpf has some source-address (offset) mapping
APIs, that will help for me.

BTW, I would like to confirm that if the kernel has jited code,
it will not fall back to xlated code. Is it correct?

> > Also, I would like to know the target BPF (XDP) is running in kprobes
> > context or not. BPF tracer sometimes use the kprobes to hook the event
> > and run in the kprobe (INT3) context. That will be need more work to
> > probe it.
> > For the BPF code which just runs in tracepoint context, it will be easy
> > to probe it. (we may need to break a limitation of notrace, which we
> > already has a kconfig)
> 
> yeah. this mechanism won't be able to debug bpf progs that are
> attached to kprobes via int3. But that is rare case.
> Most kprobe+bpf are for function entry and adding int3 to jited bpf code
> will work just like for normal kernel functions.

OK, anyway, I've done the nested kprobe support on x86/arm/arm64 :)
That will make it easy.

Thank you,

-- 
Masami Hiramatsu <mhiramat@kernel.org>
