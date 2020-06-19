Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CCA200A35
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 15:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732703AbgFSNdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 09:33:04 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44430 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731661AbgFSNdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 09:33:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592573579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TVgPD+WOoayd75ZUMV+EBfysFWdmf/tU8Wvtw0tElZw=;
        b=H+yYat9bTOTy+aVdEjCcjTq6w7LnEu79X4NYIfMvxYp1hO8a2PzDk3BAxvkPKUp/UmEqlv
        VXWnLt83bz8SQTYtHbkDBoi9HNSbiW8J26vw/ChxQdy/P7/b6ymDX9hMsDxgeXiDvuQD2s
        XGQEJ/+YWh8NUq+kD/C/Zk+qXKUFl2w=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-V2PRrXNqP_askGN3eXLbWw-1; Fri, 19 Jun 2020 09:32:55 -0400
X-MC-Unique: V2PRrXNqP_askGN3eXLbWw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 571D8184D144;
        Fri, 19 Jun 2020 13:32:53 +0000 (UTC)
Received: from krava (unknown [10.40.195.134])
        by smtp.corp.redhat.com (Postfix) with SMTP id F2B5110013D7;
        Fri, 19 Jun 2020 13:32:49 +0000 (UTC)
Date:   Fri, 19 Jun 2020 15:32:49 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 10/11] selftests/bpf: Add verifier test for d_path helper
Message-ID: <20200619133249.GK2465907@krava>
References: <20200616100512.2168860-1-jolsa@kernel.org>
 <20200616100512.2168860-11-jolsa@kernel.org>
 <CAEf4BzYr6hwS5-XKAJt-QEyPiofNvj2M1WA_B-F29QCFoZU2jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYr6hwS5-XKAJt-QEyPiofNvj2M1WA_B-F29QCFoZU2jw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 09:38:56PM -0700, Andrii Nakryiko wrote:
> On Tue, Jun 16, 2020 at 3:06 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding verifier test for attaching tracing program and
> > calling d_path helper from within and testing that it's
> > allowed for dentry_open function and denied for 'd_path'
> > function with appropriate error.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/testing/selftests/bpf/test_verifier.c   | 13 ++++++-
> >  tools/testing/selftests/bpf/verifier/d_path.c | 38 +++++++++++++++++++
> >  2 files changed, 50 insertions(+), 1 deletion(-)
> >  create mode 100644 tools/testing/selftests/bpf/verifier/d_path.c
> >
> > diff --git a/tools/testing/selftests/bpf/test_verifier.c b/tools/testing/selftests/bpf/test_verifier.c
> > index 78a6bae56ea6..3cce3dc766a2 100644
> > --- a/tools/testing/selftests/bpf/test_verifier.c
> > +++ b/tools/testing/selftests/bpf/test_verifier.c
> > @@ -114,6 +114,7 @@ struct bpf_test {
> >                 bpf_testdata_struct_t retvals[MAX_TEST_RUNS];
> >         };
> >         enum bpf_attach_type expected_attach_type;
> > +       const char *kfunc;
> >  };
> >
> >  /* Note we want this to be 64 bit aligned so that the end of our array is
> > @@ -984,8 +985,18 @@ static void do_test_single(struct bpf_test *test, bool unpriv,
> >                 attr.log_level = 4;
> >         attr.prog_flags = pflags;
> >
> > +       if (prog_type == BPF_PROG_TYPE_TRACING && test->kfunc) {
> > +               attr.attach_btf_id = libbpf_find_vmlinux_btf_id(test->kfunc,
> > +                                               attr.expected_attach_type);
> 
> if (!attr.attach_btf_id)
>   emit more meaningful error, than later during load?

ok

> 
> > +       }
> > +
> >         fd_prog = bpf_load_program_xattr(&attr, bpf_vlog, sizeof(bpf_vlog));
> > -       if (fd_prog < 0 && !bpf_probe_prog_type(prog_type, 0)) {
> > +
> > +       /* BPF_PROG_TYPE_TRACING requires more setup and
> > +        * bpf_probe_prog_type won't give correct answer
> > +        */
> > +       if (fd_prog < 0 && (prog_type != BPF_PROG_TYPE_TRACING) &&
> 
> nit: () are redundant

ok

> 
> > +           !bpf_probe_prog_type(prog_type, 0)) {
> >                 printf("SKIP (unsupported program type %d)\n", prog_type);
> >                 skips++;
> >                 goto close_fds;
> > diff --git a/tools/testing/selftests/bpf/verifier/d_path.c b/tools/testing/selftests/bpf/verifier/d_path.c
> > new file mode 100644
> > index 000000000000..e08181abc056
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/verifier/d_path.c
> > @@ -0,0 +1,38 @@
> > +{
> > +       "d_path accept",
> > +       .insns = {
> > +       BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
> > +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> > +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> > +       BPF_MOV64_IMM(BPF_REG_6, 0),
> > +       BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6, 0),
> > +       BPF_LD_IMM64(BPF_REG_3, 8),
> > +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_d_path),
> > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > +       BPF_EXIT_INSN(),
> > +       },
> > +       .errstr = "R0 max value is outside of the array range",
> > +       .result = ACCEPT,
> 
> accept with error string expected?

oops, probably lefover, will check

thanks,
jirka

> 
> 
> > +       .prog_type = BPF_PROG_TYPE_TRACING,
> > +       .expected_attach_type = BPF_TRACE_FENTRY,
> > +       .kfunc = "dentry_open",
> > +},
> > +{
> > +       "d_path reject",
> > +       .insns = {
> > +       BPF_LDX_MEM(BPF_W, BPF_REG_1, BPF_REG_1, 0),
> > +       BPF_MOV64_REG(BPF_REG_2, BPF_REG_10),
> > +       BPF_ALU64_IMM(BPF_ADD, BPF_REG_2, -8),
> > +       BPF_MOV64_IMM(BPF_REG_6, 0),
> > +       BPF_STX_MEM(BPF_DW, BPF_REG_2, BPF_REG_6, 0),
> > +       BPF_LD_IMM64(BPF_REG_3, 8),
> > +       BPF_RAW_INSN(BPF_JMP | BPF_CALL, 0, 0, 0, BPF_FUNC_d_path),
> > +       BPF_MOV64_IMM(BPF_REG_0, 0),
> > +       BPF_EXIT_INSN(),
> > +       },
> > +       .errstr = "helper call is not allowed in probe",
> > +       .result = REJECT,
> > +       .prog_type = BPF_PROG_TYPE_TRACING,
> > +       .expected_attach_type = BPF_TRACE_FENTRY,
> > +       .kfunc = "d_path",
> > +},
> > --
> > 2.25.4
> >
> 

