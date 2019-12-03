Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADD7D10FAE1
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 10:38:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfLCJiu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 04:38:50 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36106 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725774AbfLCJiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 04:38:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575365928;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6BkH/Hha6NENFb+yLeWkcNK71QocV96kHQcX3xYoLr4=;
        b=N2PIohbTTfGtZzuin7TNfV+6MaDzowhY/FPyVCfdZhj4RLhdKejRHdunS7WIA9kK/Zb78j
        jlDvA9Lnpe1odvle7OpUT7OndKcp/nTq6TsCcltcWL5bseJVHqg1cXGNeguTO/KPpwi/B3
        XTsGNkS50STkSHtYgrvzHe8wb+3MHJ8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-49-c8T0I2u_NxyAjS-fCU-NNg-1; Tue, 03 Dec 2019 04:38:45 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2714E18B5F69;
        Tue,  3 Dec 2019 09:38:43 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with SMTP id 06D0060C05;
        Tue,  3 Dec 2019 09:38:37 +0000 (UTC)
Date:   Tue, 3 Dec 2019 10:38:37 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-audit@redhat.com,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [RFC] bpf: Emit audit messages upon successful prog load and
 unload
Message-ID: <20191203093837.GC17468@krava>
References: <20191128091633.29275-1-jolsa@kernel.org>
 <CAHC9VhQ7zkXdz1V5hQ8PN68-NnCn56TjKA0wCL6ZjHy9Up8fuQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhQ7zkXdz1V5hQ8PN68-NnCn56TjKA0wCL6ZjHy9Up8fuQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: c8T0I2u_NxyAjS-fCU-NNg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 02, 2019 at 06:00:14PM -0500, Paul Moore wrote:
> On Thu, Nov 28, 2019 at 4:16 AM Jiri Olsa <jolsa@kernel.org> wrote:
> > From: Daniel Borkmann <daniel@iogearbox.net>
> >
> > Allow for audit messages to be emitted upon BPF program load and
> > unload for having a timeline of events. The load itself is in
> > syscall context, so additional info about the process initiating
> > the BPF prog creation can be logged and later directly correlated
> > to the unload event.
> >
> > The only info really needed from BPF side is the globally unique
> > prog ID where then audit user space tooling can query / dump all
> > info needed about the specific BPF program right upon load event
> > and enrich the record, thus these changes needed here can be kept
> > small and non-intrusive to the core.
> >
> > Raw example output:
> >
> >   # auditctl -D
> >   # auditctl -a always,exit -F arch=3Dx86_64 -S bpf
> >   # ausearch --start recent -m 1334
> >   ...
> >   ----
> >   time->Wed Nov 27 16:04:13 2019
> >   type=3DPROCTITLE msg=3Daudit(1574867053.120:84664): proctitle=3D"./bp=
f"
> >   type=3DSYSCALL msg=3Daudit(1574867053.120:84664): arch=3Dc000003e sys=
call=3D321   \
> >     success=3Dyes exit=3D3 a0=3D5 a1=3D7ffea484fbe0 a2=3D70 a3=3D0 item=
s=3D0 ppid=3D7477    \
> >     pid=3D12698 auid=3D1001 uid=3D1001 gid=3D1001 euid=3D1001 suid=3D10=
01 fsuid=3D1001    \
> >     egid=3D1001 sgid=3D1001 fsgid=3D1001 tty=3Dpts2 ses=3D4 comm=3D"bpf=
"                \
> >     exe=3D"/home/jolsa/auditd/audit-testsuite/tests/bpf/bpf"           =
       \
> >     subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3D=
(null)
> >   type=3DUNKNOWN[1334] msg=3Daudit(1574867053.120:84664): prog-id=3D76 =
op=3DLOAD
> >   ----
> >   time->Wed Nov 27 16:04:13 2019
> >   type=3DUNKNOWN[1334] msg=3Daudit(1574867053.120:84665): prog-id=3D76 =
op=3DUNLOAD
> >   ...
> >
> > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > Co-developed-by: Jiri Olsa <jolsa@kernel.org>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/uapi/linux/audit.h |  1 +
> >  kernel/bpf/syscall.c       | 27 +++++++++++++++++++++++++++
> >  2 files changed, 28 insertions(+)
>=20
> Hi all, sorry for the delay; the merge window in combination with the
> holiday in the US bumped this back a bit.  Small comments inline below

np, thanks for review

> ...
>=20
> > --- a/kernel/bpf/syscall.c
> > +++ b/kernel/bpf/syscall.c
> > @@ -23,6 +23,7 @@
> >  #include <linux/timekeeping.h>
> >  #include <linux/ctype.h>
> >  #include <linux/nospec.h>
> > +#include <linux/audit.h>
> >  #include <uapi/linux/btf.h>
> >
> >  #define IS_FD_ARRAY(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_PERF_EVE=
NT_ARRAY || \
> > @@ -1306,6 +1307,30 @@ static int find_prog_type(enum bpf_prog_type typ=
e, struct bpf_prog *prog)
> >         return 0;
> >  }
> >
> > +enum bpf_audit {
> > +       BPF_AUDIT_LOAD,
> > +       BPF_AUDIT_UNLOAD,
> > +};
> > +
> > +static const char * const bpf_audit_str[] =3D {
> > +       [BPF_AUDIT_LOAD]   =3D "LOAD",
> > +       [BPF_AUDIT_UNLOAD] =3D "UNLOAD",
> > +};
> > +
> > +static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_audit=
 op)
> > +{
> > +       struct audit_buffer *ab;
> > +
> > +       if (audit_enabled =3D=3D AUDIT_OFF)
> > +               return;
>=20
> I think you would probably also want to check the results of
> audit_dummy_context() here as well, see all the various audit_XXX()
> functions in include/linux/audit.h as an example.  You'll see a
> pattern similar to the following:
>=20
> static inline void audit_foo(...)
> {
>   if (unlikely(!audit_dummy_context()))
>     __audit_foo(...)
> }

bpf_audit_prog might be called outside of syscall context for UNLOAD event,
so that would prevent it from being stored

I can see audit_log_start checks on value of audit_context() that we pass i=
n,
should we check for audit_dummy_context just for load event? like:


static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_audit op)
{
        struct audit_buffer *ab;

        if (audit_enabled =3D=3D AUDIT_OFF)
                return;
        if (op =3D=3D BPF_AUDIT_LOAD && audit_dummy_context())
                return;
        ab =3D audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
        if (unlikely(!ab))
                return;
=09...
}


>=20
> > +       ab =3D audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
> > +       if (unlikely(!ab))
> > +               return;
> > +       audit_log_format(ab, "prog-id=3D%u op=3D%s",
> > +                        prog->aux->id, bpf_audit_str[op]);
>=20
> Is it worth putting some checks in here to make sure that you don't
> blow past the end of the bpf_audit_str array?
>=20
> > +       audit_log_end(ab);
> > +}
>=20
> The audit record format looks much better now, thank you.  Although I
> do wonder if you want bpf_audit_prog() to live in kernel/bpf/syscall.c
> or in kernel/auditsc.c?  There is plenty of precedence for moving it
> into auditsc.c and defining a no-op version for when
> CONFIG_AUDITSYSCALL is not enabled, but I personally don't feel that
> strongly about either option.  I just wanted to mention this in case
> you weren't already aware.
>=20
> If you do keep it in syscall.c, I don't think there is a need to
> implement a no-op version dependent on CONFIG_AUDITSYSCALL; that will
> just clutter the code.
>=20
> If you do move it to auditsc.c please change the name to
> audit_bpf()/__audit_bpf() so it matches the other functions; if you
> keep it in syscall.c you can name it whatever you like :)

ok, so far I think we'll keep it kernel/bpf/syscall.c

thanks,
jirka

