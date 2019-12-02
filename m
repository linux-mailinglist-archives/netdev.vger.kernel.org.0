Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BE8310E74B
	for <lists+netdev@lfdr.de>; Mon,  2 Dec 2019 09:59:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726443AbfLBI7r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Dec 2019 03:59:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59230 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726142AbfLBI7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Dec 2019 03:59:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575277184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rqUhLYNVakxLZv9wvfIxbDIemSFX/PcA3x0PAcyj2AI=;
        b=EQbHYK6RUHsWN2+qhkCpfj3eAyT0+4VaMPuOX1CsmHVSWhoszv9IR94TZ3o2/B2RlbBfLr
        IFLjYfaKCrHpvc5A/hNuAYWZFcarngMI23yBE4+AXzbSAZbc5TSEdF0fMfl+vRYzCIcUKn
        yZ4FuY9iMvca7mWtQ6HUA2eHGe9YFhg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-lFiTp444MaORIzOiSLocmw-1; Mon, 02 Dec 2019 03:59:43 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 72A42800D53;
        Mon,  2 Dec 2019 08:59:40 +0000 (UTC)
Received: from krava (unknown [10.43.17.48])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3C1885D6A0;
        Mon,  2 Dec 2019 08:59:30 +0000 (UTC)
Date:   Mon, 2 Dec 2019 09:59:30 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Petlan <mpetlan@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>, kubakici@wp.pl
Subject: Re: [PATCH bpf v3] bpftool: Allow to link libbpf dynamically
Message-ID: <20191202085930.GB5849@krava>
References: <20191128160712.1048793-1-toke@redhat.com>
 <f6e8f6d2-6155-3b20-9975-81e29e460915@iogearbox.net>
 <87a78evl2v.fsf@toke.dk>
 <9853054b-dc1f-35ba-ba3c-4d0ab01c8f14@iogearbox.net>
MIME-Version: 1.0
In-Reply-To: <9853054b-dc1f-35ba-ba3c-4d0ab01c8f14@iogearbox.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: lFiTp444MaORIzOiSLocmw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 30, 2019 at 12:56:49AM +0100, Daniel Borkmann wrote:
> On 11/29/19 3:00 PM, Toke H=F8iland-J=F8rgensen wrote:
> > Daniel Borkmann <daniel@iogearbox.net> writes:
> > > On 11/28/19 5:07 PM, Toke H=F8iland-J=F8rgensen wrote:
> > > > From: Jiri Olsa <jolsa@kernel.org>
> [...]
> > > >    ifeq ($(srctree),)
> > > >    srctree :=3D $(patsubst %/,%,$(dir $(CURDIR)))
> > > > @@ -63,6 +72,19 @@ RM ?=3D rm -f
> > > >    FEATURE_USER =3D .bpftool
> > > >    FEATURE_TESTS =3D libbfd disassembler-four-args reallocarray zli=
b
> > > >    FEATURE_DISPLAY =3D libbfd disassembler-four-args zlib
> > > > +ifdef LIBBPF_DYNAMIC
> > > > +  FEATURE_TESTS   +=3D libbpf
> > > > +  FEATURE_DISPLAY +=3D libbpf
> > > > +
> > > > +  # for linking with debug library run:
> > > > +  # make LIBBPF_DYNAMIC=3D1 LIBBPF_DIR=3D/opt/libbpf
> > >=20
> > > The Makefile already has BPF_DIR which points right now to
> > > '$(srctree)/tools/lib/bpf/' and LIBBPF_PATH for the final one and
> > > where $(LIBBPF_PATH)libbpf.a is expected to reside. Can't we improve
> > > the Makefile to reuse and work with these instead of adding yet
> > > another LIBBPF_DIR var which makes future changes in this area more
> > > confusing? The libbpf build spills out libbpf.{a,so*} by default
> > > anyway.
> >=20
> > I see what you mean; however, LIBBPF_DIR is meant to be specifically an
> > override for the dynamic library, not just the path to libbpf.
> >=20
> > Would it be less confusing to overload the LIBBPF_DYNAMIC variable
> > instead? I.e.,
> >=20
> > make LIBBPF_DYNAMIC=3D1
> >=20
> > would dynamically link against the libbpf installed in the system, but
> >=20
> > make LIBBPF_DYNAMIC=3D/opt/libbpf
> >=20
> > would override that and link against whatever is in /opt/libbpf instead=
?
> > WDYT?
>=20
> Hm, given perf tool has similar LIB*_DIR vars in place for its libs, it p=
robably
> makes sense to stick with this convention as well then. Perhaps better in=
 this
> case to just rename s/BPF_DIR/BPF_SRC_DIR/, s/LIBBPF_OUTPUT/LIBBPF_BUILD_=
OUTPUT/,
> and s/LIBBPF_PATH/LIBBPF_BUILD_PATH/ to make their purpose more clear.

ok, will have separate patch for this

>=20
> One thing that would be good to do as well for this patch is to:
>=20
>  i) Document both LIBBPF_DYNAMIC and LIBBPF_DIR in the Makefile comment y=
ou
>     added at the top along with a simple usage example.

ok

>=20
> ii) Extend tools/testing/selftests/bpf/test_bpftool_build.sh with a dynam=
ic
>     linking test case, e.g. building libbpf into a temp dir and pointing
>     LIBBPF_DIR to it for bpftool LIBBPF_DYNAMIC=3D1 build.

ok, will send new version soon

thanks,
jirka

>=20
> Thanks,
> Daniel
>=20

