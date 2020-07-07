Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278E021731F
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 17:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgGGP5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 11:57:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27109 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727793AbgGGP5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 11:57:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594137451;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dtGNLc1tHWWgsmUP2aqUpXS3nos98OKUm7L6gRgzKOM=;
        b=fXFMqn4xvyk4ZYybaZFOh6QPB1KhsYwrlS1yict4Su8eruWstZhDja6Aaz5A/RAjQ4oyZn
        76D4Z2Wu8dDdG/xp/uWckzbeJqQxL1i1IH7iCY8JttozCpiM7qrwWCYH/Hl/r0UH/TcwkT
        tMmwkIS9PHQjT8vJSeUkGhOzajJehP0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-60TtRPgkPRSPa4WAoZgsNQ-1; Tue, 07 Jul 2020 11:57:27 -0400
X-MC-Unique: 60TtRPgkPRSPa4WAoZgsNQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E95EFEC1A0;
        Tue,  7 Jul 2020 15:57:24 +0000 (UTC)
Received: from krava (unknown [10.40.195.209])
        by smtp.corp.redhat.com (Postfix) with SMTP id 87C2E10013D7;
        Tue,  7 Jul 2020 15:57:21 +0000 (UTC)
Date:   Tue, 7 Jul 2020 17:57:20 +0200
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
Subject: Re: [PATCH v5 bpf-next 9/9] selftests/bpf: Add test for
 resolve_btfids
Message-ID: <20200707155720.GI3424581@krava>
References: <20200703095111.3268961-1-jolsa@kernel.org>
 <20200703095111.3268961-10-jolsa@kernel.org>
 <CAEf4BzYuDU2mARcP5GVAv+WiknSnWuzGyNqQx0TiJ23CWA8NiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYuDU2mARcP5GVAv+WiknSnWuzGyNqQx0TiJ23CWA8NiA@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 06, 2020 at 06:26:28PM -0700, Andrii Nakryiko wrote:
> On Fri, Jul 3, 2020 at 2:54 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding resolve_btfids test under test_progs suite.
> >
> > It's possible to use btf_ids.h header and its logic in
> > user space application, so we can add easy test for it.
> >
> > The test defines BTF_ID_LIST and checks it gets properly
> > resolved.
> >
> > For this reason the test_progs binary (and other binaries
> > that use TRUNNER* macros) is processed with resolve_btfids
> > tool, which resolves BTF IDs in .BTF.ids section.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/testing/selftests/bpf/Makefile          |  22 ++-
> >  .../selftests/bpf/prog_tests/resolve_btfids.c | 170 ++++++++++++++++++
> >  2 files changed, 190 insertions(+), 2 deletions(-)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/resolve_btfids.c
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> > index 1f9c696b3edf..b47a685d12bd 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -190,6 +190,16 @@ else
> >         cp "$(VMLINUX_H)" $@
> >  endif
> >
> > +$(SCRATCH_DIR)/resolve_btfids: $(BPFOBJ)                               \
> > +                              $(TOOLSDIR)/bpf/resolve_btfids/main.c    \
> > +                              $(TOOLSDIR)/lib/rbtree.c                 \
> > +                              $(TOOLSDIR)/lib/zalloc.c                 \
> > +                              $(TOOLSDIR)/lib/string.c                 \
> > +                              $(TOOLSDIR)/lib/ctype.c                  \
> > +                              $(TOOLSDIR)/lib/str_error_r.c
> > +       $(Q)$(MAKE) $(submake_extras) -C $(TOOLSDIR)/bpf/resolve_btfids \
> > +       OUTPUT=$(SCRATCH_DIR)/ BPFOBJ=$(BPFOBJ)
> > +
> 
> please indent OUTPUT, so it doesn't look like it's a separate command

ok

> 
> >  # Get Clang's default includes on this system, as opposed to those seen by
> >  # '-target bpf'. This fixes "missing" files on some architectures/distros,
> >  # such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
> > @@ -333,7 +343,8 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:                   \
> >                       $(TRUNNER_BPF_SKELS)                              \
> >                       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
> >         $$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
> > -       cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
> > +       cd $$(@D) && $$(CC) -I. $$(CFLAGS) $(TRUNNER_EXTRA_CFLAGS)      \
> > +       -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
> >
> >  $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:                          \
> >                        %.c                                              \
> > @@ -355,6 +366,7 @@ $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)                   \
> >                              | $(TRUNNER_BINARY)-extras
> >         $$(call msg,BINARY,,$$@)
> >         $$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
> > +       $(TRUNNER_BINARY_EXTRA_CMD)
> 
> no need to make this generic, just write out resolve_btfids here explicitly

currently resolve_btfids fails if there's no .BTF.ids section found,
but we can make it silently pass i nthis case and then we can invoke
it for all the binaries

> 
> >
> >  endef
> >
> > @@ -365,7 +377,10 @@ TRUNNER_EXTRA_SOURCES := test_progs.c cgroup_helpers.c trace_helpers.c     \
> >                          network_helpers.c testing_helpers.c            \
> >                          flow_dissector_load.h
> >  TRUNNER_EXTRA_FILES := $(OUTPUT)/urandom_read                          \
> > -                      $(wildcard progs/btf_dump_test_case_*.c)
> > +                      $(wildcard progs/btf_dump_test_case_*.c)         \
> > +                      $(SCRATCH_DIR)/resolve_btfids
> > +TRUNNER_EXTRA_CFLAGS := -D"BUILD_STR(s)=\#s" -DVMLINUX_BTF="BUILD_STR($(VMLINUX_BTF))"
> > +TRUNNER_BINARY_EXTRA_CMD := $(SCRATCH_DIR)/resolve_btfids --btf $(VMLINUX_BTF) test_progs
> 
> I hope we can get rid of this, see suggestion below.
> 
> >  TRUNNER_BPF_BUILD_RULE := CLANG_BPF_BUILD_RULE
> >  TRUNNER_BPF_CFLAGS := $(BPF_CFLAGS) $(CLANG_CFLAGS)
> >  TRUNNER_BPF_LDFLAGS := -mattr=+alu32
> > @@ -373,6 +388,7 @@ $(eval $(call DEFINE_TEST_RUNNER,test_progs))
> >
> 
> [...]
> 
> > +
> > +static int duration;
> > +
> > +static struct btf *btf__parse_raw(const char *file)
> 
> another copy here...

ok

> 
> > +{
> > +       struct btf *btf;
> > +       struct stat st;
> > +       __u8 *buf;
> > +       FILE *f;
> > +
> 
> [...]
> 
> > +
> > +BTF_ID_LIST(test_list)
> > +BTF_ID_UNUSED
> > +BTF_ID(typedef, pid_t)
> > +BTF_ID(struct,  sk_buff)
> > +BTF_ID(union,   thread_union)
> > +BTF_ID(func,    memcpy)
> > +
> > +struct symbol {
> > +       const char      *name;
> > +       int              type;
> > +       int              id;
> > +};
> > +
> > +struct symbol test_symbols[] = {
> > +       { "unused",       -1,                0 },
> 
> could use BTF_KIND_UNKN here instead of -1

ok

> 
> > +       { "pid_t",        BTF_KIND_TYPEDEF, -1 },
> > +       { "sk_buff",      BTF_KIND_STRUCT,  -1 },
> > +       { "thread_union", BTF_KIND_UNION,   -1 },
> > +       { "memcpy",       BTF_KIND_FUNC,    -1 },
> > +};
> > +
> 
> [...]
> 
> > +
> > +static int resolve_symbols(void)
> > +{
> > +       const char *path = VMLINUX_BTF;
> 
> 
> This build-time parameter passing to find the original VMLINUX_BTF
> really sucks, IMO.
> 
> Why not use the btf_dump tests approach and have our own small
> "vmlinux BTF", which resolve_btfids would use to resolve these IDs?
> See how btf_dump_xxx.c files define BTFs that are used in tests. You
> can do something similar here, and use a well-known BPF object file as
> a source of BTF, both here in a test and in Makefile for --btf param
> to resolve_btfids?

well VMLINUX_BTF is there and those types are used are not going
away any time soon ;-) but yea, we can do that.. we do this also
for bpftrace, it's nicer

jirka

