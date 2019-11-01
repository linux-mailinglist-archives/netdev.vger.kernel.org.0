Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58E87EBE75
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 08:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729968AbfKAH1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 03:27:25 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:52960 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728989AbfKAH1Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 03:27:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572593243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=laDWjvNbXIFKYvploSabRjOsKUCAu+GBR5BrNsrJUVQ=;
        b=eHVj03bzVbwVfvapXg9MLFmqKlA6NA8lfjpOSbNLo0iYov4BO4m98BppT7+aaHNOWxZB4K
        CPcgXPrZ5Z2eq++JC2GC0cib8MyiEpQwIhA5D2ZlOsa9BejnxUEmV+Ub6s1vWEjIcX99bc
        nS94m+hL10EEthCIpA8be0RULhgTi6U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-54-aCO756TxPDidFuTNT5AzGA-1; Fri, 01 Nov 2019 03:27:17 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 682B41800D67;
        Fri,  1 Nov 2019 07:27:15 +0000 (UTC)
Received: from krava (ovpn-204-176.brq.redhat.com [10.40.204.176])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C37E7600D1;
        Fri,  1 Nov 2019 07:27:08 +0000 (UTC)
Date:   Fri, 1 Nov 2019 08:27:07 +0100
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
Message-ID: <20191101072707.GE2794@krava>
References: <87lft1ngtn.fsf@toke.dk>
 <CAADnVQLrg6f_zjvNfiEVfdjcx9+DW_RFjVGetavvMNo=VXAR+g@mail.gmail.com>
 <87imo5ng7w.fsf@toke.dk>
 <CAADnVQLJ2JTsbxd2am6XY0EiocMgM29JqFVRnZ9PBcwqd7-dAQ@mail.gmail.com>
 <87d0ednf0t.fsf@toke.dk>
 <CAADnVQ+V4OMjJqSdE_OQ1Vr99kqTF=ZB3UUMKiCSg=3=c+exqg@mail.gmail.com>
 <20191031174208.GC2794@krava>
 <CAADnVQJ=cEeFdYFGnfu6hLyTABWf2==e_1LEhBup5Phe6Jg5hw@mail.gmail.com>
 <20191031191815.GD2794@krava>
 <CAADnVQJdAZS9AHx_B3SZTcWRdigZZsK1ccsYZK0qUsd1yZQqbw@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAADnVQJdAZS9AHx_B3SZTcWRdigZZsK1ccsYZK0qUsd1yZQqbw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: aCO756TxPDidFuTNT5AzGA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 01:39:12PM -0700, Alexei Starovoitov wrote:
> On Thu, Oct 31, 2019 at 12:18 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > >
> > > yes. older vmlinux and newer installed libbpf.so
> > > or any version of libbpf.a that is statically linked into apps
> > > is something that libbpf code has to support.
> > > The server can be rebooted into older than libbpf kernel and
> > > into newer than libbpf kernel. libbpf has to recognize all these
> > > combinations and work appropriately.
> > > That's what backward and forward compatibility is.
> > > That's what makes libbpf so difficult to test, develop and code revie=
w.
> > > What that particular server has in /usr/include is irrelevant.
> >
> > sure, anyway we can't compile following:
> >
> >         tredaell@aldebaran ~ $ echo "#include <bpf/xsk.h>" | gcc -x c -
> >         In file included from <stdin>:1:
> >         /usr/include/bpf/xsk.h: In function =E2=80=98xsk_ring_prod__nee=
ds_wakeup=E2=80=99:
> >         /usr/include/bpf/xsk.h:82:21: error: =E2=80=98XDP_RING_NEED_WAK=
EUP=E2=80=99 undeclared (first use in this function)
> >            82 |  return *r->flags & XDP_RING_NEED_WAKEUP;
> >         ...
> >
> >         XDP_RING_NEED_WAKEUP is defined in kernel v5.4-rc1 (77cd0d7b3f2=
57fd0e3096b4fdcff1a7d38e99e10).
> >         XSK_UNALIGNED_BUF_ADDR_MASK and XSK_UNALIGNED_BUF_OFFSET_SHIFT =
are defined in kernel v5.4-rc1 (c05cd3645814724bdeb32a2b4d953b12bdea5f8c).
> >
> > with:
> >   kernel-headers-5.3.6-300.fc31.x86_64
> >   libbpf-0.0.5-1.fc31.x86_64
> >
> > if you're saying this is not supported, I guess we could be postponing
> > libbpf rpm releases until we have the related fedora kernel released
>=20
> why? github/libbpf is the source of truth for building packages
> and afaik it builds fine.

because we will get issues like above if there's no kernel
avilable that we could compile libbpf against

>=20
> > or how about inluding uapi headers in libbpf-devel.. but that might
> > actualy cause more confusion
>=20
> Libraries (libbpf or any other) should not install headers that
> typically go into /usr/include/
> if_xdp.h case is not unique.
> We'll surely add another #define, enum, etc to uapi/linux/bpf.h tomorrow.
> And we will not copy paste these constants and types into tools/lib/bpf/.
> In kernel tree libbpf development is using kernel tree headers.
> No problem there for libbpf developers.
> Packages are built out of github/libbpf that has a copy of uapi headers
> necessary to create packages.
> No problem there for package builders either.
> But libbpf package is not going to install those uapi headers.
> libbpf package installs only libbpf own headers (like libbpf.h)
> The users that want to build against the latest libbpf package need
> to install corresponding uapi headers package.
> I don't think such dependency is specified in rpm scripts.
> May be it is something to fix? Or may be not.

I'll check if we can add some kernel version/package dependency

> Some folks might not want to update all of /usr/include to bring libbpf-d=
evel.
> Then it would be their responsibility to get fresh /usr/include headers.

jirka

