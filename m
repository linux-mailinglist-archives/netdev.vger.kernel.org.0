Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A5C2F3A62
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 20:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406881AbhALT2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 14:28:20 -0500
Received: from foss.arm.com ([217.140.110.172]:52412 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406826AbhALT2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 14:28:19 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F02241042;
        Tue, 12 Jan 2021 11:27:32 -0800 (PST)
Received: from e107158-lin (e107158-lin.cambridge.arm.com [10.1.194.78])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ABD263F66E;
        Tue, 12 Jan 2021 11:27:31 -0800 (PST)
Date:   Tue, 12 Jan 2021 19:27:29 +0000
From:   Qais Yousef <qais.yousef@arm.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf-next 2/2] selftests: bpf: Add a new test for bare
 tracepoints
Message-ID: <20210112192729.q47avnmnzl54nekg@e107158-lin>
References: <20210111182027.1448538-1-qais.yousef@arm.com>
 <20210111182027.1448538-3-qais.yousef@arm.com>
 <CAEf4BzYwOAHGOiZBUx86yZ1ofwJ1WqCDR3dyRMrTeQa2ZU7ftA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAEf4BzYwOAHGOiZBUx86yZ1ofwJ1WqCDR3dyRMrTeQa2ZU7ftA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/11/21 23:26, Andrii Nakryiko wrote:
> On Mon, Jan 11, 2021 at 10:20 AM Qais Yousef <qais.yousef@arm.com> wrote:
> >
> > Reuse module_attach infrastructure to add a new bare tracepoint to check
> > we can attach to it as a raw tracepoint.
> >
> > Signed-off-by: Qais Yousef <qais.yousef@arm.com>
> > ---
> >
> > Andrii
> >
> > I was getting the error below when I was trying to run the test.
> > I had to comment out all related fentry* code to be able to test the raw_tp
> > stuff. Not sure something I've done wrong or it's broken for some reason.
> > I was on v5.11-rc2.
> 
> Check that you have all the required Kconfig options from
> tools/testing/selftests/bpf/config. And also you will need to build

Yep I have merged this config snippet using merge_config.sh script.

> pahole from master, 1.19 doesn't have some fixes that add kernel
> module support. I think pahole is the reasons why you have the failure
> below.

I am using pahole 1.19. I have built it from tip of master though.

/trying using v1.19 tag

Still fails the same.

> 
> >
> >         $ sudo ./test_progs -v -t module_attach
> 
> use -vv when debugging stuff like that with test_progs, it will output
> libbpf detailed logs, that often are very helpful

I tried that but it didn't help me. Full output is here

	https://paste.debian.net/1180846

> 
> >         bpf_testmod.ko is already unloaded.
> >         Loading bpf_testmod.ko...
> >         Successfully loaded bpf_testmod.ko.
> >         test_module_attach:PASS:skel_open 0 nsec
> >         test_module_attach:PASS:set_attach_target 0 nsec
> >         test_module_attach:PASS:skel_load 0 nsec
> >         libbpf: prog 'handle_fentry': failed to attach: ERROR: strerror_r(-524)=22
> >         libbpf: failed to auto-attach program 'handle_fentry': -524
> >         test_module_attach:FAIL:skel_attach skeleton attach failed: -524
> >         #58 module_attach:FAIL
> >         Successfully unloaded bpf_testmod.ko.
> >         Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
> >
> 
> But even apart from test failure, there seems to be kernel build
> failure. See [0] for what fails in kernel-patches CI.
> 
>    [0] https://travis-ci.com/github/kernel-patches/bpf/builds/212730017

Sorry about that. I did a last minute change because of checkpatch.pl error and
it seems I either forgot to rebuild or missed that the rebuild failed :/

> 
> 
> >
> >  .../selftests/bpf/bpf_testmod/bpf_testmod-events.h     |  6 ++++++
> >  tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c  |  2 ++
> >  tools/testing/selftests/bpf/prog_tests/module_attach.c |  1 +
> >  tools/testing/selftests/bpf/progs/test_module_attach.c | 10 ++++++++++
> >  4 files changed, 19 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> > index b83ea448bc79..e1ada753f10c 100644
> > --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> > +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod-events.h
> > @@ -28,6 +28,12 @@ TRACE_EVENT(bpf_testmod_test_read,
> >                   __entry->pid, __entry->comm, __entry->off, __entry->len)
> >  );
> >
> > +/* A bare tracepoint with no event associated with it */
> > +DECLARE_TRACE(bpf_testmod_test_read_bare,
> > +       TP_PROTO(struct task_struct *task, struct bpf_testmod_test_read_ctx *ctx),
> > +       TP_ARGS(task, ctx)
> > +);
> > +
> >  #endif /* _BPF_TESTMOD_EVENTS_H */
> >
> >  #undef TRACE_INCLUDE_PATH
> > diff --git a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > index 2df19d73ca49..d63cebdaca44 100644
> > --- a/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > +++ b/tools/testing/selftests/bpf/bpf_testmod/bpf_testmod.c
> > @@ -22,6 +22,8 @@ bpf_testmod_test_read(struct file *file, struct kobject *kobj,
> >         };
> >
> >         trace_bpf_testmod_test_read(current, &ctx);
> > +       ctx.len++;
> > +       trace_bpf_testmod_test_read_bare(current, &ctx);
> 
> It's kind of boring to have two read tracepoints :) Do you mind adding

Hehe boring is good :p

> a write tracepoint and use bare tracepoint there? You won't need this
> ctx.len++ hack as well. Feel free to add identical
> bpf_testmod_test_write_ctx (renaming it is more of a pain).

It was easy to get this done. So I think it should be easy to make it a write
too :)

Thanks

--
Qais Yousef

> 
> >
> >         return -EIO; /* always fail */
> >  }
> > diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> > index 50796b651f72..7085a118f38c 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> > @@ -50,6 +50,7 @@ void test_module_attach(void)
> >         ASSERT_OK(trigger_module_test_read(READ_SZ), "trigger_read");
> >
> >         ASSERT_EQ(bss->raw_tp_read_sz, READ_SZ, "raw_tp");
> > +       ASSERT_EQ(bss->raw_tp_bare_read_sz, READ_SZ+1, "raw_tp_bare");
> >         ASSERT_EQ(bss->tp_btf_read_sz, READ_SZ, "tp_btf");
> >         ASSERT_EQ(bss->fentry_read_sz, READ_SZ, "fentry");
> >         ASSERT_EQ(bss->fentry_manual_read_sz, READ_SZ, "fentry_manual");
> > diff --git a/tools/testing/selftests/bpf/progs/test_module_attach.c b/tools/testing/selftests/bpf/progs/test_module_attach.c
> > index efd1e287ac17..08aa157afa1d 100644
> > --- a/tools/testing/selftests/bpf/progs/test_module_attach.c
> > +++ b/tools/testing/selftests/bpf/progs/test_module_attach.c
> > @@ -17,6 +17,16 @@ int BPF_PROG(handle_raw_tp,
> >         return 0;
> >  }
> >
> > +__u32 raw_tp_bare_read_sz = 0;
> > +
> > +SEC("raw_tp/bpf_testmod_test_read_bare")
> > +int BPF_PROG(handle_raw_tp_bare,
> > +            struct task_struct *task, struct bpf_testmod_test_read_ctx *read_ctx)
> > +{
> > +       raw_tp_bare_read_sz = BPF_CORE_READ(read_ctx, len);
> > +       return 0;
> > +}
> > +
> >  __u32 tp_btf_read_sz = 0;
> >
> >  SEC("tp_btf/bpf_testmod_test_read")
> > --
> > 2.25.1
> >
