Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B78EEB7E7
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 20:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729515AbfJaTSb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 15:18:31 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38743 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729380AbfJaTSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 15:18:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572549509;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z1RO4I/4jdEzscBd4h7vo0/gknedRYXjuJXt2oE2lmM=;
        b=B1HO99ue7SBFqiHg6kZZYqHrTx3q10Jj7PEcN6R5p2a0HM2QSn5Xs35IvQm8dfSEOapK+V
        /dPzoevOg/i93MdkY02v9Q1CUIIZxhPrQRB8gf4ZRdAf3v5cuuWMLj1vEFCknOZnfCMvTk
        /XKu4r+ORJ4QIEkFwUo1loFQGoNxLkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-MjNOMBPYN3CLeiHudvBuiA-1; Thu, 31 Oct 2019 15:18:27 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 512602AD;
        Thu, 31 Oct 2019 19:18:25 +0000 (UTC)
Received: from krava (ovpn-204-176.brq.redhat.com [10.40.204.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A491A7C5;
        Thu, 31 Oct 2019 19:18:17 +0000 (UTC)
Date:   Thu, 31 Oct 2019 20:18:15 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, degeneloy@gmail.com,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH bpf-next v3] libbpf: fix compatibility for kernels
 without need_wakeup
Message-ID: <20191031191815.GD2794@krava>
References: <CAJ+HfNimRqftmKASOdceXFJmgbLvXnNBZATTnfA9LMF2amGzzA@mail.gmail.com>
 <CAADnVQJRe4Pm-Rxx9zobn8YRHh9i+xQp7HX4gidqq9Mse7PJ5g@mail.gmail.com>
 <87lft1ngtn.fsf@toke.dk>
 <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
 <87imo5ng7w.fsf@toke.dk>
 <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
 <87d0ednf0t.fsf@toke.dk>
 <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com>
 <20191031174208.GC2794@krava>
 <CAADnVQJ=cEeFdYFGnfu6hLyTABWf2==e_1LEhBup5Phe6Jg5hw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAADnVQJ=cEeFdYFGnfu6hLyTABWf2==e_1LEhBup5Phe6Jg5hw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: MjNOMBPYN3CLeiHudvBuiA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 11:19:21AM -0700, Alexei Starovoitov wrote:
> On Thu, Oct 31, 2019 at 10:42 AM Jiri Olsa <jolsa@redhat.com> wrote:
> >
> > On Thu, Oct 31, 2019 at 08:17:43AM -0700, Alexei Starovoitov wrote:
> > > On Thu, Oct 31, 2019 at 7:52 AM Toke H=C3=B8iland-J=C3=B8rgensen <tok=
e@redhat.com> wrote:
> > > >
> > > > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > > >
> > > > > On Thu, Oct 31, 2019 at 7:26 AM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@redhat.com> wrote:
> > > > >>
> > > > >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > > > >>
> > > > >> > On Thu, Oct 31, 2019 at 7:13 AM Toke H=C3=B8iland-J=C3=B8rgens=
en <toke@redhat.com> wrote:
> > > > >> >>
> > > > >> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> > > > >> >>
> > > > >> >> > On Thu, Oct 31, 2019 at 1:03 AM Bj=C3=B6rn T=C3=B6pel <bjor=
n.topel@gmail.com> wrote:
> > > > >> >> >>
> > > > >> >> >> On Thu, 31 Oct 2019 at 08:17, Magnus Karlsson <magnus.karl=
sson@gmail.com> wrote:
> > > > >> >> >> >
> > > > >> >> >> > On Wed, Oct 30, 2019 at 2:36 PM Toke H=C3=B8iland-J=C3=
=B8rgensen <toke@redhat.com> wrote:
> > > > >> >> >> > >
> > > > >> >> >> > > Magnus Karlsson <magnus.karlsson@intel.com> writes:
> > > > >> >> >> > >
> > > > >> >> >> > > > When the need_wakeup flag was added to AF_XDP, the f=
ormat of the
> > > > >> >> >> > > > XDP_MMAP_OFFSETS getsockopt was extended. Code was a=
dded to the
> > > > >> >> >> > > > kernel to take care of compatibility issues arrising=
 from running
> > > > >> >> >> > > > applications using any of the two formats. However, =
libbpf was
> > > > >> >> >> > > > not extended to take care of the case when the appli=
cation/libbpf
> > > > >> >> >> > > > uses the new format but the kernel only supports the=
 old
> > > > >> >> >> > > > format. This patch adds support in libbpf for parsin=
g the old
> > > > >> >> >> > > > format, before the need_wakeup flag was added, and e=
mulating a
> > > > >> >> >> > > > set of static need_wakeup flags that will always wor=
k for the
> > > > >> >> >> > > > application.
> > > > >> >> >> > >
> > > > >> >> >> > > Hi Magnus
> > > > >> >> >> > >
> > > > >> >> >> > > While you're looking at backwards compatibility issues=
 with xsk: libbpf
> > > > >> >> >> > > currently fails to compile on a system that has old ke=
rnel headers
> > > > >> >> >> > > installed (this is with kernel-headers 5.3):
> > > > >> >> >> > >
> > > > >> >> >> > > $ echo "#include <bpf/xsk.h>" | gcc -x c -
> > > > >> >> >> > > In file included from <stdin>:1:
> > > > >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_=
prod__needs_wakeup=E2=80=99:
> > > > >> >> >> > > /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING=
_NEED_WAKEUP=E2=80=99 undeclared (first use in this function)
> > > > >> >> >> > >    82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> > > > >> >> >> > >       |                     ^~~~~~~~~~~~~~~~~~~~
> > > > >> >> >> > > /usr/include/bpf/xsk.h:82:21: note: each undeclared id=
entifier is reported only once for each function it appears in
> > > > >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem_=
_extract_addr=E2=80=99:
> > > > >> >> >> > > /usr/include/bpf/xsk.h:173:16: error: =E2=80=98XSK_UNA=
LIGNED_BUF_ADDR_MASK=E2=80=99 undeclared (first use in this function)
> > > > >> >> >> > >   173 |  return addr & XSK_UNALIGNED_BUF_ADDR_MASK;
> > > > >> >> >> > >       |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > >> >> >> > > /usr/include/bpf/xsk.h: In function =E2=80=98xsk_umem_=
_extract_offset=E2=80=99:
> > > > >> >> >> > > /usr/include/bpf/xsk.h:178:17: error: =E2=80=98XSK_UNA=
LIGNED_BUF_OFFSET_SHIFT=E2=80=99 undeclared (first use in this function)
> > > > >> >> >> > >   178 |  return addr >> XSK_UNALIGNED_BUF_OFFSET_SHIFT=
;
> > > > >> >> >> > >       |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > >> >> >> > >
> > > > >> >> >> > >
> > > > >> >> >> > >
> > > > >> >> >> > > How would you prefer to handle this? A patch like the =
one below will fix
> > > > >> >> >> > > the compile errors, but I'm not sure it makes sense se=
mantically?
> > > > >> >> >> >
> > > > >> >> >> > Thanks Toke for finding this. Of course it should be pos=
sible to
> > > > >> >> >> > compile this on an older kernel, but without getting any=
 of the newer
> > > > >> >> >> > functionality that is not present in that older kernel.
> > > > >> >> >>
> > > > >> >> >> Is the plan to support source compatibility for the header=
s only, or
> > > > >> >> >> the whole the libbpf itself? Is the usecase here, that you=
've built
> > > > >> >> >> libbpf.so with system headers X, and then would like to us=
e the
> > > > >> >> >> library on a system with older system headers X~10? XDP so=
ckets? BTF?
> > > > >> >> >
> > > > >> >> > libbpf has to be backward and forward compatible.
> > > > >> >> > Once compiled it has to run on older and newer kernels.
> > > > >> >> > Conditional compilation is not an option obviously.
> > > > >> >>
> > > > >> >> So what do we do, then? Redefine the constants in libbpf/xsh.=
h if
> > > > >> >> they're not in the kernel header file?
> > > > >> >
> > > > >> > why? How and whom it will help?
> > > > >> > To libbpf.rpm creating person or to end user?
> > > > >>
> > > > >> Anyone who tries to compile a new libbpf against an older kernel=
. You're
> > > > >> saying yourself that "libbpf has to be backward and forward comp=
atible".
> > > > >> Surely that extends to compile time as well as runtime?
> > > > >
> > > > > how old that older kernel?
> > > > > Does it have up-to-date bpf.h in /usr/include ?
> > > > > Also consider that running kernel is often not the same
> > > > > thing as installed in /usr/include
> > > > > vmlinux and /usr/include are different packages.
> > > >
> > > > In this case, it's a constant introduced in the kernel in the curre=
nt
> > > > (5.4) cycle; so currently, you can't compile libbpf with
> > > > kernel-headers-5.3. And we're discussing how to handle this in a
> > > > backwards compatible way in libbpf...
> > >
> > > you simply don't.
> > > It's not a problem to begin with.
> >
> > hum, that's possible case for distro users.. older kernel, newer libbpf
>=20
> yes. older vmlinux and newer installed libbpf.so
> or any version of libbpf.a that is statically linked into apps
> is something that libbpf code has to support.
> The server can be rebooted into older than libbpf kernel and
> into newer than libbpf kernel. libbpf has to recognize all these
> combinations and work appropriately.
> That's what backward and forward compatibility is.
> That's what makes libbpf so difficult to test, develop and code review.
> What that particular server has in /usr/include is irrelevant.

sure, anyway we can't compile following:

=09tredaell@aldebaran ~ $ echo "#include <bpf/xsk.h>" | gcc -x c -=20
=09In file included from <stdin>:1:
=09/usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__needs_wakeup=
=E2=80=99:
=09/usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAKEUP=E2=80=
=99 undeclared (first use in this function)
=09   82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
=09...

=09XDP_RING_NEED_WAKEUP is defined in kernel v5.4-rc1 (77cd0d7b3f257fd0e309=
6b4fdcff1a7d38e99e10).
=09XSK_UNALIGNED_BUF_ADDR_MASK and XSK_UNALIGNED_BUF_OFFSET_SHIFT are defin=
ed in kernel v5.4-rc1 (c05cd3645814724bdeb32a2b4d953b12bdea5f8c).

with:
  kernel-headers-5.3.6-300.fc31.x86_64
  libbpf-0.0.5-1.fc31.x86_64

if you're saying this is not supported, I guess we could be postponing
libbpf rpm releases until we have the related fedora kernel released

or how about inluding uapi headers in libbpf-devel.. but that might
actualy cause more confusion

jirka

