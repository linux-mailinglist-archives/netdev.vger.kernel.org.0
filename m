Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE5215A770
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 12:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727347AbgBLLN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 06:13:59 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:56731 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726135AbgBLLN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 06:13:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581506038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dCm1QcljRNqoJRRTewmtTan9vvxIIVIVsEI5I1bO+e4=;
        b=QxAnngMlpfsgYQcGyZj/ugS8i/Gv4DySUqFUNIIUuuP6R2itaQLrJqUHZNOemAUh8wljpc
        3VqNX6pK9TnJ4jK4vtgWPzipGvuuN2msGEJ7Uzf7CXbty7Hi9TZ0+658a4t9CZFIov328W
        OMnKyzrbejJqJ6HYe0piNv7/m0+aNFs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-353-gtVSRAGwN966G1onu8cJlg-1; Wed, 12 Feb 2020 06:13:54 -0500
X-MC-Unique: gtVSRAGwN966G1onu8cJlg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F09B918A8C8D;
        Wed, 12 Feb 2020 11:13:51 +0000 (UTC)
Received: from krava (ovpn-204-247.brq.redhat.com [10.40.204.247])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id F2B0D60BF4;
        Wed, 12 Feb 2020 11:13:48 +0000 (UTC)
Date:   Wed, 12 Feb 2020 12:13:46 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Subject: Re: [PATCH 00/14] bpf: Add trampoline and dispatcher to
 /proc/kallsyms
Message-ID: <20200212111346.GF183981@krava>
References: <20200208154209.1797988-1-jolsa@kernel.org>
 <CAJ+HfNhBDU9c4-0D5RiHFZBq_LN7E=k8=rhL+VbmxJU7rdDBxQ@mail.gmail.com>
 <20200210161751.GC28110@krava>
 <20200211193223.GI3416@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20200211193223.GI3416@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 11, 2020 at 04:32:23PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Feb 10, 2020 at 05:17:51PM +0100, Jiri Olsa escreveu:
> > On Mon, Feb 10, 2020 at 04:51:08PM +0100, Bj=F6rn T=F6pel wrote:
> > > On Sat, 8 Feb 2020 at 16:42, Jiri Olsa <jolsa@kernel.org> wrote:
> > > > this patchset adds trampoline and dispatcher objects
> > > > to be visible in /proc/kallsyms. The last patch also
> > > > adds sorting for all bpf objects in /proc/kallsyms.
>=20
> > > Thanks for working on this!
>=20
> > > I'm probably missing something with my perf setup; I've applied you=
r
> > > patches, and everything seem to work fine from an kallsyms
> > > perspective:
>=20
> > > # grep bpf_dispatcher_xdp /proc/kallsyms
> > > ...
> > > ffffffffc0511000 t bpf_dispatcher_xdp   [bpf]
> > >=20
> > > However, when I run
> > > # perf top
> > >=20
> > > I still see the undecorated one:
> > > 0.90%  [unknown]                  [k] 0xffffffffc0511037
> > >=20
> > > Any ideas?
> =20
> > yea strange.. it should be picked up from /proc/kallsyms as
> > fallback if there's no other source, I'll check on that
> > (might be the problem with perf depending on address going
> > only higher in /proc/kallsyms, while bpf symbols are at the
> > end and start over from the lowest bpf address)
> >=20
> > anyway, in perf we enumerate bpf_progs via the perf events
> > PERF_BPF_EVENT_PROG_LOAD,PERF_BPF_EVENT_PROG_UNLOAD interface
> > together with PERF_RECORD_KSYMBOL_TYPE_BPF events
> >=20
> > we might need to add something like:
> >   PERF_RECORD_KSYMBOL_TYPE_BPF_TRAMPOLINE
> >   PERF_RECORD_KSYMBOL_TYPE_BPF_DISPATCHER
> >=20
> > to notify about the area, I'll check on that
> >=20
> > however the /proc/kallsyms fallback should work in any
> > case.. thanks for report ;-)
>=20
> We should by now move kallsyms to be the preferred source of symbols,
> not vmlinux, right?
>=20
> Perhaps what is happening is:
>=20
> [root@quaco ~]# strace -f -e open,openat -o /tmp/bla perf top
> [root@quaco ~]# grep vmlinux /tmp/bla
> 11013 openat(AT_FDCWD, "vmlinux", O_RDONLY) =3D -1 ENOENT (No such file=
 or directory)
> 11013 openat(AT_FDCWD, "/boot/vmlinux", O_RDONLY) =3D -1 ENOENT (No suc=
h file or directory)
> 11013 openat(AT_FDCWD, "/boot/vmlinux-5.5.0+", O_RDONLY) =3D -1 ENOENT =
(No such file or directory)
> 11013 openat(AT_FDCWD, "/usr/lib/debug/boot/vmlinux-5.5.0+", O_RDONLY) =
=3D -1 ENOENT (No such file or directory)
> 11013 openat(AT_FDCWD, "/lib/modules/5.5.0+/build/vmlinux", O_RDONLY) =3D=
 152
> [root@quaco ~]#
>=20
> I.e. it is using vmlinux for resolving symbols and he should try with:
>=20
> [root@quaco ~]# strace -f -e open,openat -o /tmp/bla perf top --ignore-=
vmlinux
> [root@quaco ~]# perf top -h vmlinux
>=20
>  Usage: perf top [<options>]
>=20
>     -k, --vmlinux <file>  vmlinux pathname
>         --ignore-vmlinux  don't load vmlinux even if found
>=20
> [root@quaco ~]# grep vmlinux /tmp/bla
> [root@quaco ~]#
>=20
> Historically vmlinux was preferred because it contains function sizes,
> but with all these out of the blue symbols, we need to prefer starting
> with /proc/kallsyms and, as we do now, continue getting updates via
> PERF_RECORD_KSYMBOL.
>=20
> Humm, but then trampolines don't generate that, right? Or does it? If i=
t
> doesn't, then we will know about just the trampolines in place when the
> record/top session starts, reparsing /proc/kallsyms periodically seems
> excessive?

I plan to extend the KSYMBOL interface to contain trampolines/dispatcher
data, plus we could do some inteligent fallback to /proc/kallsyms in case
vmlinux won't have anything

jirka

