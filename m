Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2B8219248
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 23:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgGHVSz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 17:18:55 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:41508 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725903AbgGHVSy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 17:18:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594243132;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sSibTsf2Tmt/F++kFCgdv25YlYSJRrS5Z/yFkhUz0yA=;
        b=guPGUHVmXhDambeq6Ml0KfVbFyHoEsXEJcncjBumAUvV3SUHsR7M1dmzST1H6UQC1PWUZ3
        X3sYmKNClyNOCu4gkuyWmFF03Pgh8oKaSJbWUOBgAs8lOSM1h6RC9VFCCLNk9CsKtP2BuG
        NlAtJFjtH6q1cp/mAd7sJXW+z1oyKSM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-hcoEgA-sMxOcnH7LvnHgXA-1; Wed, 08 Jul 2020 17:18:49 -0400
X-MC-Unique: hcoEgA-sMxOcnH7LvnHgXA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A3511107ACCD;
        Wed,  8 Jul 2020 21:18:46 +0000 (UTC)
Received: from krava (unknown [10.40.195.124])
        by smtp.corp.redhat.com (Postfix) with SMTP id 60FF36FEC7;
        Wed,  8 Jul 2020 21:18:40 +0000 (UTC)
Date:   Wed, 8 Jul 2020 23:18:39 +0200
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
Message-ID: <20200708211839.GE3581918@krava>
References: <20200703095111.3268961-1-jolsa@kernel.org>
 <20200703095111.3268961-10-jolsa@kernel.org>
 <CAEf4BzYuDU2mARcP5GVAv+WiknSnWuzGyNqQx0TiJ23CWA8NiA@mail.gmail.com>
 <20200707155720.GI3424581@krava>
 <CAEf4BzYYHEwDZ9YqqyfzSZsk-8=DrL-WVEee-gisBLQRZWUTHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYYHEwDZ9YqqyfzSZsk-8=DrL-WVEee-gisBLQRZWUTHw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 07, 2020 at 10:49:22AM -0700, Andrii Nakryiko wrote:

SNIP

> > > >  # Get Clang's default includes on this system, as opposed to those seen by
> > > >  # '-target bpf'. This fixes "missing" files on some architectures/distros,
> > > >  # such as asm/byteorder.h, asm/socket.h, asm/sockios.h, sys/cdefs.h etc.
> > > > @@ -333,7 +343,8 @@ $(TRUNNER_TEST_OBJS): $(TRUNNER_OUTPUT)/%.test.o:                   \
> > > >                       $(TRUNNER_BPF_SKELS)                              \
> > > >                       $$(BPFOBJ) | $(TRUNNER_OUTPUT)
> > > >         $$(call msg,TEST-OBJ,$(TRUNNER_BINARY),$$@)
> > > > -       cd $$(@D) && $$(CC) -I. $$(CFLAGS) -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
> > > > +       cd $$(@D) && $$(CC) -I. $$(CFLAGS) $(TRUNNER_EXTRA_CFLAGS)      \
> > > > +       -c $(CURDIR)/$$< $$(LDLIBS) -o $$(@F)
> > > >
> > > >  $(TRUNNER_EXTRA_OBJS): $(TRUNNER_OUTPUT)/%.o:                          \
> > > >                        %.c                                              \
> > > > @@ -355,6 +366,7 @@ $(OUTPUT)/$(TRUNNER_BINARY): $(TRUNNER_TEST_OBJS)                   \
> > > >                              | $(TRUNNER_BINARY)-extras
> > > >         $$(call msg,BINARY,,$$@)
> > > >         $$(CC) $$(CFLAGS) $$(filter %.a %.o,$$^) $$(LDLIBS) -o $$@
> > > > +       $(TRUNNER_BINARY_EXTRA_CMD)
> > >
> > > no need to make this generic, just write out resolve_btfids here explicitly
> >
> > currently resolve_btfids fails if there's no .BTF.ids section found,
> > but we can make it silently pass i nthis case and then we can invoke
> > it for all the binaries
> 
> ah, I see. Yeah, either we can add an option to resolve_btfids to not
> error when .BTF_ids is missing (probably best), or we can check
> whether the test has .BTF_ids section, and if it does - run
> resolve_btfids on it. Just ignoring errors always is more error-prone,
> because we won't know if it's a real problem we are ignoring, or
> missing .BTF_ids.

ok, sounds good

> > > > +static int resolve_symbols(void)
> > > > +{
> > > > +       const char *path = VMLINUX_BTF;
> > >
> > >
> > > This build-time parameter passing to find the original VMLINUX_BTF
> > > really sucks, IMO.
> > >
> > > Why not use the btf_dump tests approach and have our own small
> > > "vmlinux BTF", which resolve_btfids would use to resolve these IDs?
> > > See how btf_dump_xxx.c files define BTFs that are used in tests. You
> > > can do something similar here, and use a well-known BPF object file as
> > > a source of BTF, both here in a test and in Makefile for --btf param
> > > to resolve_btfids?
> >
> > well VMLINUX_BTF is there and those types are used are not going
> > away any time soon ;-) but yea, we can do that.. we do this also
> > for bpftrace, it's nicer
> 
> 
> "VMLINUX_BTF is there" is not really true in a lot of more complicated
> setups, which is why I'd like to avoid that assumption. E.g., for
> libbpf Travis CI, we build self-tests in one VM, but run the binary in
> a different VM. So either vmlinux itself or the path to it might
> change.

ok

> 
> Also, having full control over **small** BTF allows to create various
> test situations that might be harder to pinpoint in real vmlinux BTF,
> e.g., same-named entities with different KINDS (typedef vs struct,
> etc). Then if that fails, debugging this on a small BTF is much-much
> easier than on a real thing. Real vmlinux BTF is being tested each
> time you build a kernel and run selftests inside VM either way, so I
> don't think we lose anything in terms of coverage.

agreed, will add that

thanks,
jirka

