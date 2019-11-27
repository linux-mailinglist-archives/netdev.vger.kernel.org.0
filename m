Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1899F10B0EF
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 15:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726985AbfK0OPo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 09:15:44 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:30085 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726593AbfK0OPm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 09:15:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574864140;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=53cOmksCYXpfOMFyUAKABXaw+6aT23kyKZNlnHGL0ko=;
        b=W1Z5aeZBZPzeD2KBxUAbxKyNC165MN3DM6O4jT2wlF9EA/b2q06jHbnfQjGWPowYwVUEfz
        u3saTiIiA7gs4+5PFkzS7T5SRd5x/cQFtIGUWF0jEeAlyPF7W86zm2JuS/Xfu1NDF4UNPp
        pT01M12kiVzy8JyqYavYdaLACgp83gA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-nuwJXhXVOJSWpsuYi26DAw-1; Wed, 27 Nov 2019 09:15:35 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 95E14108C310;
        Wed, 27 Nov 2019 14:15:33 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with SMTP id 4A2E5619DB;
        Wed, 27 Nov 2019 14:15:21 +0000 (UTC)
Date:   Wed, 27 Nov 2019 15:15:20 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH 3/3] bpftool: Allow to link libbpf dynamically
Message-ID: <20191127141520.GJ32367@krava>
References: <20191127094837.4045-1-jolsa@kernel.org>
 <20191127094837.4045-4-jolsa@kernel.org>
 <fd22660f-2f70-4ffa-b45f-bb417d006d0a@netronome.com>
MIME-Version: 1.0
In-Reply-To: <fd22660f-2f70-4ffa-b45f-bb417d006d0a@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: nuwJXhXVOJSWpsuYi26DAw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 27, 2019 at 01:38:55PM +0000, Quentin Monnet wrote:
> 2019-11-27 10:48 UTC+0100 ~ Jiri Olsa <jolsa@kernel.org>
> > Currently we support only static linking with kernel's libbpf
> > (tools/lib/bpf). This patch adds LIBBPF_DYNAMIC compile variable
> > that triggers libbpf detection and bpf dynamic linking:
> >=20
> >   $ make -C tools/bpf/bpftool make LIBBPF_DYNAMIC=3D1
> >=20
> > If libbpf is not installed, build (with LIBBPF_DYNAMIC=3D1) stops with:
> >=20
> >   $ make -C tools/bpf/bpftool LIBBPF_DYNAMIC=3D1
> >     Auto-detecting system features:
> >     ...                        libbfd: [ on  ]
> >     ...        disassembler-four-args: [ on  ]
> >     ...                          zlib: [ on  ]
> >     ...                        libbpf: [ OFF ]
> >=20
> >   Makefile:102: *** Error: libbpf-devel is missing, please install it. =
 Stop.
> >=20
> > Adding specific bpftool's libbpf check for libbpf_netlink_open (LIBBPF_=
0.0.6)
> > which is the latest we need for bpftool at the moment.
> >=20
> > Adding LIBBPF_DIR compile variable to allow linking with
> > libbpf installed into specific directory:
> >=20
> >   $ make -C tools/lib/bpf/ prefix=3D/tmp/libbpf/ install_lib install_he=
aders
> >   $ make -C tools/bpf/bpftool/ LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/tmp/lib=
bpf/
> >=20
> > It might be needed to clean build tree first because features
> > framework does not detect the change properly:
> >=20
> >   $ make -C tools/build/feature clean
> >   $ make -C tools/bpf/bpftool/ clean
> >=20
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/bpf/bpftool/Makefile        | 40 ++++++++++++++++++++++++++++++-
> >  tools/build/feature/test-libbpf.c |  9 +++++++
> >  2 files changed, 48 insertions(+), 1 deletion(-)
> >=20
> > diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
> > index 39bc6f0f4f0b..2b6ed08cb31e 100644
> > --- a/tools/bpf/bpftool/Makefile
> > +++ b/tools/bpf/bpftool/Makefile
>=20
> > @@ -55,7 +64,7 @@ ifneq ($(EXTRA_LDFLAGS),)
> >  LDFLAGS +=3D $(EXTRA_LDFLAGS)
> >  endif
> > =20
> > -LIBS =3D $(LIBBPF) -lelf -lz
> > +LIBS =3D -lelf -lz
>=20
> Hi Jiri,
>=20
> This change seems to be breaking the build with the static library for
> me. I know you add back $(LIBBPF) later in the Makefile, see at the end
> of this email...
>=20
> > =20
> >  INSTALL ?=3D install
> >  RM ?=3D rm -f
> > @@ -64,6 +73,23 @@ FEATURE_USER =3D .bpftool
> >  FEATURE_TESTS =3D libbfd disassembler-four-args reallocarray zlib
> >  FEATURE_DISPLAY =3D libbfd disassembler-four-args zlib
> > =20
> > +ifdef LIBBPF_DYNAMIC
> > +  # Add libbpf check with the flags to ensure bpftool
> > +  # specific version is detected.
>=20
> Nit: We do not check for a specific bpftool version, we check for a
> recent enough libbpf version?

hi,
we check for a version that has the latest exported function
that bpftool needs, which is currently libbpf_netlink_open

please check the '#ifdef BPFTOOL' in feature/test-libbpf.c

it's like that because there's currently no support to check
for particular library version in the build/features framework

I'll make that comment more clear

>=20
> > +  FEATURE_CHECK_CFLAGS-libbpf :=3D -DBPFTOOL
> > +  FEATURE_TESTS   +=3D libbpf
> > +  FEATURE_DISPLAY +=3D libbpf
> > +
> > +  # for linking with debug library run:
> > +  # make LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/opt/libbpf
> > +  ifdef LIBBPF_DIR
> > +    LIBBPF_CFLAGS  :=3D -I$(LIBBPF_DIR)/include
> > +    LIBBPF_LDFLAGS :=3D -L$(LIBBPF_DIR)/$(libdir_relative)
> > +    FEATURE_CHECK_CFLAGS-libbpf  :=3D $(LIBBPF_CFLAGS)
> > +    FEATURE_CHECK_LDFLAGS-libbpf :=3D $(LIBBPF_LDFLAGS)
> > +  endif
> > +endif
> > +
> >  check_feat :=3D 1
> >  NON_CHECK_FEAT_TARGETS :=3D clean uninstall doc doc-clean doc-install =
doc-uninstall
> >  ifdef MAKECMDGOALS
> > @@ -88,6 +114,18 @@ ifeq ($(feature-reallocarray), 0)
> >  CFLAGS +=3D -DCOMPAT_NEED_REALLOCARRAY
> >  endif
> > =20
> > +ifdef LIBBPF_DYNAMIC
> > +  ifeq ($(feature-libbpf), 1)
> > +    LIBS    +=3D -lbpf
> > +    CFLAGS  +=3D $(LIBBPF_CFLAGS)
> > +    LDFLAGS +=3D $(LIBBPF_LDFLAGS)
> > +  else
> > +    dummy :=3D $(error Error: No libbpf devel library found, please in=
stall libbpf-devel)
>=20
> libbpf-devel sounds like a RH/Fedora package name, but other
> distributions might have different names (Debian/Ubuntu would go by
> libbpf-dev I suppose, although I don't believe such package exists at
> the moment). Maybe use a more generic message?

sure, actually in perf we use both package names like:

  Error: No libbpf devel library found, please install libbpf-devel or libb=
pf-dev.

or we can go with generic message:

  Error: No libbpf devel library found, please install.

>=20
> > +  endif
> > +else
> > +  LIBS +=3D $(LIBBPF)
>=20
> ... I believe the order of the libraries is relevant, and it seems the
> static libbpf should be passed before the dynamic libs. Here I could fix
> the build with the static library on my setup by prepending the library
> path instead, like this:
>=20
> =09LIBS :=3D $(LIBBPF) $(LIBS)

could you please paste the build error? I don't see any on Fedora,
anyway I can make the change you're proposing

>=20
> On the plus side, all build attempts from
> tools/testing/selftests/bpf/test_bpftool_build.sh pass successfully on
> my setup with dynamic linking from your branch.

cool, had no idea there was such test ;-)

thanks,
jirka

