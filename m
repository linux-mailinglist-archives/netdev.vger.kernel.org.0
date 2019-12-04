Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45043112D40
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 15:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728009AbfLDOIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 09:08:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:38996 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727828AbfLDOIl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 09:08:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575468520;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KlU8G1NVqsI7cVMGLZrHpzxB9UZVHsr2EbX8kLpf83Y=;
        b=NIGeZ1/LrGNtkCj0W3nW7CYs0HP3NfTvItH+vJtqqKRiYsU3rOklCUo9Y/Cp0WatDvuEIy
        OEwNd7AWsGiX10dFgeTwYbQK+v0TLcOdrRFghqSIqEK3/FsMkoM5VVrOjK9gUPk+rwgxDo
        rxAbB3TSzM4nzcf6mF5Z/yv7hsM4GSk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-H7PLXD9xMBG6GBFyxQFPJA-1; Wed, 04 Dec 2019 09:08:37 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1221D100EC2E;
        Wed,  4 Dec 2019 14:08:35 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 10EEF19C68;
        Wed,  4 Dec 2019 14:08:29 +0000 (UTC)
Date:   Wed, 4 Dec 2019 15:08:27 +0100
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
Message-ID: <20191204140827.GB12431@krava>
References: <20191128091633.29275-1-jolsa@kernel.org>
 <CAHC9VhQ7zkXdz1V5hQ8PN68-NnCn56TjKA0wCL6ZjHy9Up8fuQ@mail.gmail.com>
 <20191203093837.GC17468@krava>
 <CAHC9VhRhMhsRPj1D2TY3O=Nc6Rx9=o1-Z5ZMjrCepfFY6VtdbQ@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRhMhsRPj1D2TY3O=Nc6Rx9=o1-Z5ZMjrCepfFY6VtdbQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: H7PLXD9xMBG6GBFyxQFPJA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 03, 2019 at 09:53:16PM -0500, Paul Moore wrote:

SNIP

> > >
> > > static inline void audit_foo(...)
> > > {
> > >   if (unlikely(!audit_dummy_context()))
> > >     __audit_foo(...)
> > > }
> >
> > bpf_audit_prog might be called outside of syscall context for UNLOAD ev=
ent,
> > so that would prevent it from being stored
>=20
> Okay, right.  More on this below ...
>=20
> > I can see audit_log_start checks on value of audit_context() that we pa=
ss in,
>=20
> The check in audit_log_start() is for a different reason; it checks
> the passed context to see if it should associate the record with
> others in the same event, e.g. PATH records associated with the
> matching SYSCALL record.  This way all the associated records show up
> as part of the same event (as defined by the audit timestamp).
>=20
> > should we check for audit_dummy_context just for load event? like:
> >
> >
> > static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_audit =
op)
> > {
> >         struct audit_buffer *ab;
> >
> >         if (audit_enabled =3D=3D AUDIT_OFF)
> >                 return;
> >         if (op =3D=3D BPF_AUDIT_LOAD && audit_dummy_context())
> >                 return;
> >         ab =3D audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
> >         if (unlikely(!ab))
> >                 return;
> >         ...
> > }
>=20
> Ignoring the dummy context for a minute, there is likely a larger
> issue here with using audit_context() when bpf_audit_prog() is called
> outside of a syscall, e.g. BPF_AUDIT_UNLOAD.  In this case we likely
> shouldn't be taking the audit context from the current task, we
> shouldn't be taking it from anywhere, it should be NULL.
>=20
> As far as the dummy context is concerned, you might want to skip the
> dummy context check since you can only do that on the LOAD side, which
> means that depending on the system's configuration you could end up
> with a number of unbalanced LOAD/UNLOAD events.  The downside is that
> you are always going to get the BPF audit records on systemd based
> systems, since they ignore the admin's audit configuration and always
> enable audit (yes, we've tried to get systemd to change, they don't
> seem to care).

ok, so something like below?

thanks,
jirka


---
 include/uapi/linux/audit.h |  1 +
 kernel/bpf/syscall.c       | 30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index c89c6495983d..32a5db900f47 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -116,6 +116,7 @@
 #define AUDIT_FANOTIFY=09=091331=09/* Fanotify access decision */
 #define AUDIT_TIME_INJOFFSET=091332=09/* Timekeeping offset injected */
 #define AUDIT_TIME_ADJNTPVAL=091333=09/* NTP value adjustment */
+#define AUDIT_BPF=09=091334=09/* BPF subsystem */
=20
 #define AUDIT_AVC=09=091400=09/* SE Linux avc denial or grant */
 #define AUDIT_SELINUX_ERR=091401=09/* Internal SE Linux Errors */
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e3461ec59570..81f1a6308aa8 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -23,6 +23,7 @@
 #include <linux/timekeeping.h>
 #include <linux/ctype.h>
 #include <linux/nospec.h>
+#include <linux/audit.h>
 #include <uapi/linux/btf.h>
=20
 #define IS_FD_ARRAY(map) ((map)->map_type =3D=3D BPF_MAP_TYPE_PERF_EVENT_A=
RRAY || \
@@ -1306,6 +1307,33 @@ static int find_prog_type(enum bpf_prog_type type, s=
truct bpf_prog *prog)
 =09return 0;
 }
=20
+enum bpf_audit {
+=09BPF_AUDIT_LOAD,
+=09BPF_AUDIT_UNLOAD,
+};
+
+static const char * const bpf_audit_str[] =3D {
+=09[BPF_AUDIT_LOAD]   =3D "LOAD",
+=09[BPF_AUDIT_UNLOAD] =3D "UNLOAD",
+};
+
+static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_audit op)
+{
+=09struct audit_context *ctx =3D NULL;
+=09struct audit_buffer *ab;
+
+=09if (audit_enabled =3D=3D AUDIT_OFF)
+=09=09return;
+=09if (op =3D=3D BPF_AUDIT_LOAD)
+=09=09ctx =3D audit_context();
+=09ab =3D audit_log_start(ctx, GFP_ATOMIC, AUDIT_BPF);
+=09if (unlikely(!ab))
+=09=09return;
+=09audit_log_format(ab, "prog-id=3D%u op=3D%s",
+=09=09=09 prog->aux->id, bpf_audit_str[op]);
+=09audit_log_end(ab);
+}
+
 int __bpf_prog_charge(struct user_struct *user, u32 pages)
 {
 =09unsigned long memlock_limit =3D rlimit(RLIMIT_MEMLOCK) >> PAGE_SHIFT;
@@ -1421,6 +1449,7 @@ static void __bpf_prog_put(struct bpf_prog *prog, boo=
l do_idr_lock)
 {
 =09if (atomic64_dec_and_test(&prog->aux->refcnt)) {
 =09=09perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_UNLOAD, 0);
+=09=09bpf_audit_prog(prog, BPF_AUDIT_UNLOAD);
 =09=09/* bpf_prog_free_id() must be called first */
 =09=09bpf_prog_free_id(prog, do_idr_lock);
 =09=09__bpf_prog_put_noref(prog, true);
@@ -1830,6 +1859,7 @@ static int bpf_prog_load(union bpf_attr *attr, union =
bpf_attr __user *uattr)
 =09 */
 =09bpf_prog_kallsyms_add(prog);
 =09perf_event_bpf_event(prog, PERF_BPF_EVENT_PROG_LOAD, 0);
+=09bpf_audit_prog(prog, BPF_AUDIT_LOAD);
=20
 =09err =3D bpf_prog_new_fd(prog);
 =09if (err < 0)
--=20
2.23.0

