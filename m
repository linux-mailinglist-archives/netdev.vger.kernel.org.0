Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D93A0D8139
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 22:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388357AbfJOUoL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 16:44:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55972 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727673AbfJOUoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Oct 2019 16:44:11 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6B1FD10DCCA5;
        Tue, 15 Oct 2019 20:44:10 +0000 (UTC)
Received: from krava (ovpn-204-61.brq.redhat.com [10.40.204.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id D45D4101E68F;
        Tue, 15 Oct 2019 20:44:07 +0000 (UTC)
Date:   Tue, 15 Oct 2019 22:44:07 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>, Daniel Xu <dxu@dxuuu.xyz>
Subject: Re: [RFC] libbpf: Allow to emit all dependent definitions
Message-ID: <20191015204407.GA16674@krava>
References: <20191015130117.32292-1-jolsa@kernel.org>
 <CAEf4BzYdJ-hPHVehZriS_synLWtgad9wx_eoN6-JDBUUHFjfgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYdJ-hPHVehZriS_synLWtgad9wx_eoN6-JDBUUHFjfgQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.64]); Tue, 15 Oct 2019 20:44:10 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 15, 2019 at 09:22:35AM -0700, Andrii Nakryiko wrote:
> On Tue, Oct 15, 2019 at 6:03 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Currently the bpf dumper does not emit definitions
> > of pointers to structs. It only emits forward type
> > declarations.
> >
> > Having 2 structs like:
> >
> >    struct B {
> >      int b;
> >    };
> >
> >    struct A {
> >      struct B *ptr;
> >    };
> >
> > the call to btf_dump__dump_type(id = struct A) dumps:
> >
> >    struct B;
> >    struct A {
> >      struct B *ptr;
> >    };
> >
> > It'd ease up bpftrace code if we could dump definitions
> > of all dependent types, like:
> >
> >    struct B {
> >      int b;
> >    };
> >    struct A {
> >      struct B *ptr;
> >    };
> >
> > So we could dereference all the pointers easily, instead
> > of searching for each access member's type and dumping it
> > separately.
> >
> > Adding struct btf_dump_opts::emit_all to do that.
> >
> 
> Hey Jiri,
> 
> Yeah, Daniel Xu mentioned that this would be useful. I haven't thought
> this through very well yet, but I suspect that this simple change
> might not be enough to make this work. There are cases where you are
> not yet allowed to emit definition and have to emit
> forward-declaration first. I suggest trying to use this on vmlinux BTF
> and see if resulting header files still compiles with both Clang and
> GCC. Do you mind checking?

agh right, my test fails for vmlinux BTF

> 
> But also, as we learned over last few months, just adding extra field
> to an opts struct is not backwards-compatible, so we'll need to add
> new API and follow the pattern that we used for
> bpf_object__open_{file,mem).

will check, thanks
jirka
