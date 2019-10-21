Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C3B8DEEA6
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 16:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbfJUOCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 10:02:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44525 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727152AbfJUOCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 10:02:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571666558;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E76Ncd4hkPdyEmWthnzq2lnetFoG06/DZ+e4atVNaro=;
        b=K2/+Xnxcpv0eyDsIKfxsORqxsjfQF1IOpBTR5ueKtKfb/WGsp29ciHiwnJTY/rR+sXoaHb
        a31Ll4J8gbHchj2l4txmGk22N0dxA5QdfKrmRFKetresPyM70naZ9VSoSvpsWCK9+UGQlw
        k+29hJqm78LwSX92PEVHOG9wGZ5DfRQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-42IKWHNWNBWdYFohri2Hfw-1; Mon, 21 Oct 2019 10:02:36 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D63EB107AD33;
        Mon, 21 Oct 2019 14:02:29 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 09CAB60166;
        Mon, 21 Oct 2019 14:02:27 +0000 (UTC)
Date:   Mon, 21 Oct 2019 16:02:27 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH] bpftool: Try to read btf as raw data if elf read fails
Message-ID: <20191021140227.GD32718@krava>
References: <20191018103404.12999-1-jolsa@kernel.org>
 <20191018153905.600d7c8a@cakuba.netronome.com>
MIME-Version: 1.0
In-Reply-To: <20191018153905.600d7c8a@cakuba.netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 42IKWHNWNBWdYFohri2Hfw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 03:39:05PM -0700, Jakub Kicinski wrote:
> On Fri, 18 Oct 2019 12:34:04 +0200, Jiri Olsa wrote:
> > The bpftool interface stays the same, but now it's possible
> > to run it over BTF raw data, like:
> >=20
> >   $ bpftool btf dump file /sys/kernel/btf/vmlinux
> >   libbpf: failed to get EHDR from /sys/kernel/btf/vmlinux
> >   [1] INT '(anon)' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3D(no=
ne)
> >   [2] INT 'long unsigned int' size=3D8 bits_offset=3D0 nr_bits=3D64 enc=
oding=3D(none)
> >   [3] CONST '(anon)' type_id=3D2
> >=20
> > I'm also adding err init to 0 because I was getting uninitialized
> > warnings from gcc.
> >=20
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  tools/bpf/bpftool/btf.c | 47 ++++++++++++++++++++++++++++++++++++-----
> >  1 file changed, 42 insertions(+), 5 deletions(-)
> >=20
> > diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> > index 9a9376d1d3df..100fb7e02329 100644
> > --- a/tools/bpf/bpftool/btf.c
> > +++ b/tools/bpf/bpftool/btf.c
> > @@ -12,6 +12,9 @@
> >  #include <libbpf.h>
> >  #include <linux/btf.h>
> >  #include <linux/hashtable.h>
> > +#include <sys/types.h>
> > +#include <sys/stat.h>
> > +#include <unistd.h>
> > =20
> >  #include "btf.h"
> >  #include "json_writer.h"
> > @@ -388,6 +391,35 @@ static int dump_btf_c(const struct btf *btf,
> >  =09return err;
> >  }
> > =20
> > +static struct btf *btf__parse_raw(const char *file)
> > +{
> > +=09struct btf *btf =3D ERR_PTR(-EINVAL);
> > +=09__u8 *buf =3D NULL;
>=20
> Please drop the inits
>=20
> > +=09struct stat st;
> > +=09FILE *f;
> > +
> > +=09if (stat(file, &st))
> > +=09=09return btf;
>=20
> And return constants here
>=20
> > +=09f =3D fopen(file, "rb");
> > +=09if (!f)
> > +=09=09return btf;
>=20
> and here
>=20
> > +=09buf =3D malloc(st.st_size);
> > +=09if (!buf)
> > +=09=09goto err;
>=20
> and jump to the right place here.
>=20
> > +=09if ((size_t) st.st_size !=3D fread(buf, 1, st.st_size, f))
> > +=09=09goto err;
> > +
> > +=09btf =3D btf__new(buf, st.st_size);
> > +
> > +err:
>=20
> The prefix for error labels which is shared with non-error path is exit_
>=20
> > +=09free(buf);
> > +=09fclose(f);
> > +=09return btf;
> > +}
> > +

ok for all above

> >  static int do_dump(int argc, char **argv)
> >  {
> >  =09struct btf *btf =3D NULL;
> > @@ -397,7 +429,7 @@ static int do_dump(int argc, char **argv)
> >  =09__u32 btf_id =3D -1;
> >  =09const char *src;
> >  =09int fd =3D -1;
> > -=09int err;
> > +=09int err =3D 0;
>=20
> This change looks unnecessary.

I'm getting confusing warnings from gcc about this,
but there is a code path where do_dump would return
untouched err:

  do_dump
     int err;

     } else if (is_prefix(src, "file")) {
       btf =3D btf__parse_elf(*argv, NULL);   // succeeds

     }

     while (argc) {
       if (is_prefix(*argv, "format")) {
       else {                                // in here
          goto done;
       }

     done:
       return err;

thanks,
jirka

