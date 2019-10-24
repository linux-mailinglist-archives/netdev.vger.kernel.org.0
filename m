Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD5FE3436
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 15:31:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393597AbfJXNbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 09:31:09 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:44350 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389547AbfJXNbI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 09:31:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571923867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LalParPU2WMpYAPZzmTBU6nWHiI/R/JcjzcF9G5styA=;
        b=Z1ZsMA8BIKSUeuSWsTacWsPMqco/TdhfwTJY8yZ4QCRx01pJAJOp1DQqldczKOIpE2gtWi
        txEQOXHL1exUQ4p5MG1TGJ383EPV/RVGD/7xPwQkmZZFPHZUHZ76rvJHCa5grya3L8JxCV
        GUYFmymduQhvHypXEDXtq/wnJcAnfVg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-jYnoGcB3OhuxVilolf718g-1; Thu, 24 Oct 2019 09:31:04 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAB93800D49;
        Thu, 24 Oct 2019 13:31:02 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id DEB87600CC;
        Thu, 24 Oct 2019 13:31:00 +0000 (UTC)
Date:   Thu, 24 Oct 2019 15:31:00 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCHv2] bpftool: Try to read btf as raw data if elf read fails
Message-ID: <20191024133100.GA31679@krava>
References: <20191024132341.8943-1-jolsa@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20191024132341.8943-1-jolsa@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: jYnoGcB3OhuxVilolf718g-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 03:23:41PM +0200, Jiri Olsa wrote:
> The bpftool interface stays the same, but now it's possible
> to run it over BTF raw data, like:
>=20
>   $ bpftool btf dump file /sys/kernel/btf/vmlinux
>   [1] INT '(anon)' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3D(none=
)
>   [2] INT 'long unsigned int' size=3D8 bits_offset=3D0 nr_bits=3D64 encod=
ing=3D(none)
>   [3] CONST '(anon)' type_id=3D2
>=20
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

ugh, wrong title.. I sent v3 :-\ sry

jirka

> v2 changes:
>  - added is_btf_raw to find out which btf__parse_* function to call
>  - changed labels and error propagation in btf__parse_raw=20
>  - drop the err initialization, which is not needed under this change
>=20
>  tools/bpf/bpftool/btf.c | 57 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 56 insertions(+), 1 deletion(-)
>=20
> diff --git a/tools/bpf/bpftool/btf.c b/tools/bpf/bpftool/btf.c
> index 9a9376d1d3df..a7b8bf233cf5 100644
> --- a/tools/bpf/bpftool/btf.c
> +++ b/tools/bpf/bpftool/btf.c
> @@ -12,6 +12,9 @@
>  #include <libbpf.h>
>  #include <linux/btf.h>
>  #include <linux/hashtable.h>
> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <unistd.h>
> =20
>  #include "btf.h"
>  #include "json_writer.h"
> @@ -388,6 +391,54 @@ static int dump_btf_c(const struct btf *btf,
>  =09return err;
>  }
> =20
> +static struct btf *btf__parse_raw(const char *file)
> +{
> +=09struct btf *btf;
> +=09struct stat st;
> +=09__u8 *buf;
> +=09FILE *f;
> +
> +=09if (stat(file, &st))
> +=09=09return NULL;
> +
> +=09f =3D fopen(file, "rb");
> +=09if (!f)
> +=09=09return NULL;
> +
> +=09buf =3D malloc(st.st_size);
> +=09if (!buf) {
> +=09=09btf =3D ERR_PTR(-ENOMEM);
> +=09=09goto exit_close;
> +=09}
> +
> +=09if ((size_t) st.st_size !=3D fread(buf, 1, st.st_size, f)) {
> +=09=09btf =3D ERR_PTR(-EINVAL);
> +=09=09goto exit_free;
> +=09}
> +
> +=09btf =3D btf__new(buf, st.st_size);
> +
> +exit_free:
> +=09free(buf);
> +exit_close:
> +=09fclose(f);
> +=09return btf;
> +}
> +
> +static bool is_btf_raw(const char *file)
> +{
> +=09__u16 magic =3D 0;
> +=09int fd;
> +
> +=09fd =3D open(file, O_RDONLY);
> +=09if (fd < 0)
> +=09=09return false;
> +
> +=09read(fd, &magic, sizeof(magic));
> +=09close(fd);
> +=09return magic =3D=3D BTF_MAGIC;
> +}
> +
>  static int do_dump(int argc, char **argv)
>  {
>  =09struct btf *btf =3D NULL;
> @@ -465,7 +516,11 @@ static int do_dump(int argc, char **argv)
>  =09=09}
>  =09=09NEXT_ARG();
>  =09} else if (is_prefix(src, "file")) {
> -=09=09btf =3D btf__parse_elf(*argv, NULL);
> +=09=09if (is_btf_raw(*argv))
> +=09=09=09btf =3D btf__parse_raw(*argv);
> +=09=09else
> +=09=09=09btf =3D btf__parse_elf(*argv, NULL);
> +
>  =09=09if (IS_ERR(btf)) {
>  =09=09=09err =3D PTR_ERR(btf);
>  =09=09=09btf =3D NULL;
> --=20
> 2.21.0
>=20

