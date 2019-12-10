Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50A1D11831D
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 10:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfLJJKd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 04:10:33 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:55125 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726890AbfLJJKc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 04:10:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575969031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hz5q2f2cSA6flYmyws+ZR3sP2R2kkyVQYZHtyGJaGmw=;
        b=OE+TZaUBzeCK8wZOOjTCrLMp7ARBKihEmoG8ucXPJ2Vp/P3rYU0bwq5J5zrT6zWYOBw4xu
        a9jbR/VAcMbqaKgVVXadpRkBxfuUH9XkkIMtfOhMJs+8n8x0eEBag5pzEPUs3u2jfCDk5z
        DZTMGaDs2k4A6+Z5gfP1u6Uu8Ucg0HE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-DbgC6R9-OP22xcA2heEXJw-1; Tue, 10 Dec 2019 04:10:30 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 411EADBE7;
        Tue, 10 Dec 2019 09:10:29 +0000 (UTC)
Received: from carbon (ovpn-200-56.brq.redhat.com [10.40.200.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3D70E1001925;
        Tue, 10 Dec 2019 09:10:21 +0000 (UTC)
Date:   Tue, 10 Dec 2019 10:10:20 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        bpf@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        daniel@iogearbox.net, netdev@vger.kernel.org, brouer@redhat.com
Subject: Re: Establishing /usr/lib/bpf as a convention for eBPF bytecode
 files?
Message-ID: <20191210101020.767622b7@carbon>
In-Reply-To: <20191210014018.ltmjgsaafve54o6w@ast-mbp.dhcp.thefacebook.com>
References: <87fthtlotk.fsf@toke.dk>
        <20191210014018.ltmjgsaafve54o6w@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: DbgC6R9-OP22xcA2heEXJw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Dec 2019 17:40:19 -0800
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> On Mon, Dec 09, 2019 at 12:29:27PM +0100, Toke H=C3=B8iland-J=C3=B8rgense=
n wrote:
> > Hi everyone
> >=20
> > As you have no doubt noticed, we have started thinking about how to
> > package eBPF-related applications in distributions. As a part of this,
> > I've been thinking about what to recommend for applications that ship
> > pre-compiled BPF byte-code files.
> >=20
> > The obvious place to place those would be somewhere in the system
> > $LIBDIR (i.e., /usr/lib or /usr/lib64, depending on the distro). But
> > since BPF byte code is its own binary format, different from regular
> > executables, I think having a separate path to put those under makes
> > sense. So I'm proposing to establish a convention that pre-compiled BPF
> > programs be installed into /usr/lib{,64}/bpf.
> >=20
> > This would let users discover which BPF programs are shipped on their
> > system, and it could be used to discover which package loaded a
> > particular BPF program, by walking the directory to find the file a
> > loaded program came from. It would not work for dynamically-generated
> > bytecode, of course, but I think at least some applications will end up
> > shipping pre-compiled bytecode files (we're doing that for xdp-tools,
> > for instance).
> >=20
> > As I said, this would be a convention. We're already using it for
> > xdp-tools[0], so my plan is to use that as the "first mover", try to ge=
t
> > distributions to establish the path as a part of their filesystem
> > layout, and then just try to encourage packages to use it. Hopefully it
> > will catch on.
> >=20
> > Does anyone have any objections to this? Do you think it is a complete
> > waste of time, or is it worth giving it a shot? :) =20
>=20
> What will be the name of file/directory ?
> What is going to be the mechanism to clean it up?
> What will be stored in there? Just .o files ?
>=20
> libbcc stores original C and rewritten C in /var/tmp/bcc/bpf_prog_TAG/
> It was useful for debugging. Since TAG is used as directory name
> reloading the same bcc script creates the same dir and /var/tmp
> periodically gets cleaned by reboot.
>=20
> Installing bpf .o into common location feels useful. Not sure though
> how you can convince folks to follow such convention.

I imagine the files under /usr/lib{,64}/bpf/ will be pre-compiled
binaries (fairly static file).  These will be delivered together with
the distro RPM file. The distro will detect/enforce that two packages
cannot use the same name for bpf .o files.

I see these files as part of the RPM software package binary files. In
my opinion, this means/imply that the BPF application should not update
these files runtime, because different consistency checksum tools
should be able to verify that this files comes from the original RPM
file.

More below on dynamic files.

> That was the main problem with libbcc. Not everything is using that lib.
> So teaching folks who debug bpf in production to look into /var/tmp/bcc
> wasn't enough. 'bpftool p s' is still the main mechanism.
> Some C++ services embed bpf .o as part of x86 binary and that binary
> is installed. They wouldn't want to split bpf .o into separate file
> since it will complicate dependency management, risk conflicts, etc.
> Just food for thought.

I see three different types of BPF-object files, which belong in
different places (suggestion in parentheses):

 1. Pre-compiled binaries via RPM. (/usr/lib? [1])
 2. Application "startup" compiled "cached" BPF-object (/var/cache? [2]).
 3. Runtime dynamic compiled BPF-objects short lived (/run? [3])

You can follow the links below, to see if match descriptions in
the Filesystem Hierarchy Standard[4].

I think that filetype 1 + 2 makes sense to store in files. For
filetype 3 (the highly dynamic runtime re-compiled files) I'm not
sure it makes sense to store those in any central place.  Applications
could use /run/application-name/, but it will be a pain to deal with
filename-clashes. As Alexei brings up cleanup; /run/ is cleared at the
beginning of the boot process[3].

For fileytpe 2, I suggest /var/cache/bpf/, but with an additional
application name as a subdir, this is to avoid name clashes (which then
becomes the applications responsibility with in its own dir).


Links:

[1] /usr/lib: "Libraries for programming and packages" https://refspecs.lin=
uxfoundation.org/FHS_3.0/fhs/ch04s06.html

[2] /var/cache: "Application cache data" https://refspecs.linuxfoundation.o=
rg/FHS_3.0/fhs/ch05s05.html

[3] /run: "Run-time variable data" https://refspecs.linuxfoundation.org/FHS=
_3.0/fhs/ch03s15.html

[4] https://refspecs.linuxfoundation.org/FHS_3.0/fhs/index.html
--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

