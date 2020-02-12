Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5F1315A70A
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 11:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgBLKxF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 05:53:05 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:41046 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725821AbgBLKxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 05:53:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581504783;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cYy5ZesNeuoMyvhxjO67yiIhOj9c7xYorYYNb501pKk=;
        b=DH3ksUENT5tZDuL/O4D+dGy3GebUe1LS9MTMSdD3dFXvzFTpyMeUUCfx3uRa9pqRqpHkWe
        1CYMlN2fwbRXZy3x6TK8RGfUmUJznoILlo4JMAxqsPUkO6Cupn9iuDspbZKxKKIC88AcUo
        tH/OlbEiK9lVIL1XmpHEpSeYwUbDVMc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-88-auPzfwm0O1q7T0IcdWzf7A-1; Wed, 12 Feb 2020 05:52:59 -0500
X-MC-Unique: auPzfwm0O1q7T0IcdWzf7A-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8BC421B2C984;
        Wed, 12 Feb 2020 10:52:57 +0000 (UTC)
Received: from krava (ovpn-204-247.brq.redhat.com [10.40.204.247])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id ADA6E26FA9;
        Wed, 12 Feb 2020 10:52:54 +0000 (UTC)
Date:   Wed, 12 Feb 2020 11:52:52 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 13/14] bpf: Add dispatchers to kallsyms
Message-ID: <20200212105252.GD183981@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <20200208154209.1797988-14-jolsa@kernel.org>
 <CAEf4BzZM-pc4Yva8kKsuD6QjOY8bVCGUzDJCdoeZzVOTc2zV2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAEf4BzZM-pc4Yva8kKsuD6QjOY8bVCGUzDJCdoeZzVOTc2zV2A@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 11:03:23AM -0800, Andrii Nakryiko wrote:
> On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > Adding dispatchers to kallsyms. It's displayed as
> >   bpf_dispatcher_<NAME>
> >
> > where NAME is the name of dispatcher.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  include/linux/bpf.h     | 19 ++++++++++++-------
> >  kernel/bpf/dispatcher.c |  6 ++++++
> >  2 files changed, 18 insertions(+), 7 deletions(-)
> >
> > diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> > index b91bac10d3ea..837cdc093d2c 100644
> > --- a/include/linux/bpf.h
> > +++ b/include/linux/bpf.h
> > @@ -520,6 +520,7 @@ struct bpf_dispatcher {
> >         int num_progs;
> >         void *image;
> >         u32 image_off;
> > +       struct bpf_ksym ksym;
> >  };
> >
> >  static __always_inline unsigned int bpf_dispatcher_nop_func(
> > @@ -535,13 +536,17 @@ struct bpf_trampoline *bpf_trampoline_lookup(u6=
4 key);
> >  int bpf_trampoline_link_prog(struct bpf_prog *prog);
> >  int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
> >  void bpf_trampoline_put(struct bpf_trampoline *tr);
> > -#define BPF_DISPATCHER_INIT(name) {                    \
> > -       .mutex =3D __MUTEX_INITIALIZER(name.mutex),       \
> > -       .func =3D &name##_func,                           \
> > -       .progs =3D {},                                    \
> > -       .num_progs =3D 0,                                 \
> > -       .image =3D NULL,                                  \
> > -       .image_off =3D 0                                  \
> > +#define BPF_DISPATCHER_INIT(_name) {                           \
> > +       .mutex =3D __MUTEX_INITIALIZER(_name.mutex),              \
> > +       .func =3D &_name##_func,                                  \
> > +       .progs =3D {},                                            \
> > +       .num_progs =3D 0,                                         \
> > +       .image =3D NULL,                                          \
> > +       .image_off =3D 0,                                         \
> > +       .ksym =3D {                                               \
> > +               .name =3D #_name,                                 \
> > +               .lnode =3D LIST_HEAD_INIT(_name.ksym.lnode),      \
> > +       },                                                      \
> >  }
> >
> >  #define DEFINE_BPF_DISPATCHER(name)                                 =
   \
> > diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> > index b3e5b214fed8..8771d2cc5840 100644
> > --- a/kernel/bpf/dispatcher.c
> > +++ b/kernel/bpf/dispatcher.c
> > @@ -152,6 +152,12 @@ void bpf_dispatcher_change_prog(struct bpf_dispa=
tcher *d, struct bpf_prog *from,
> >         if (!changed)
> >                 goto out;
> >
> > +       if (!prev_num_progs)
> > +               bpf_image_ksym_add(d->image, &d->ksym);
> > +
> > +       if (!d->num_progs)
> > +               bpf_ksym_del(&d->ksym);
> > +
> >         bpf_dispatcher_update(d, prev_num_progs);
>=20
> On slightly unrelated note: seems like bpf_dispatcher_update won't
> propagate any lower-level errors back, which seems pretty bad as a
> bunch of stuff can go wrong.
>=20
> Bj=F6rn, was it a conscious decision or this just slipped through the c=
racks?
>=20
> Jiri, reason I started looking at this was twofold:
> 1. you add/remove symbol before dispatcher is updated, which is
> different order from BPF trampoline updates. I think updating symbols
> after successful update makes more sense, no?

right, I guess I did not care, because there's no error returned
from bpf_dispatcher_update as you pointed out.. I'll check if we
can add that and add/del symbols afterwards

> 2. I was wondering if bpf_dispatcher_update() could return 0/1 (and <0
> on error, of course), depending on whether dispatcher is present or
> not. Though I'm not hard set on this.

yes, that might be a way.. I'll check

thanks,
jirka

