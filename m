Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 252DEE4B12
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 14:32:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440228AbfJYMcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 08:32:22 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27188 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726484AbfJYMcW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 08:32:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572006741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g04fRvWpLJOl6APLyZDpLmq+uVvPo5Fylj6B2BnXRdA=;
        b=Sf3zVVaKFrzshZtYJ+U6Xl6bs+xZkitajYLTybhIrD4mIVsIx8NCnTJi5806f8/6BXITAc
        m1Y1oshe2/BuYtRQKyyoAOaZ/kgdTIVe3habp1sjCkyC3kqclxpNaPGK7NBhDtblskQHlg
        kVrNCoHS2czF/QioE6LuehlDGSUY7hY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-gb1Fe7ouMZ6a8wiQmDKI7Q-1; Fri, 25 Oct 2019 08:32:17 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BF2B11800E00;
        Fri, 25 Oct 2019 12:32:14 +0000 (UTC)
Received: from carbon (ovpn-200-21.brq.redhat.com [10.40.200.21])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D88960852;
        Fri, 25 Oct 2019 12:32:05 +0000 (UTC)
Date:   Fri, 25 Oct 2019 14:32:03 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, brouer@redhat.com
Subject: Re: [PATCH bpf-next v2 3/4] libbpf: Support configurable pinning of
 maps from BTF annotations
Message-ID: <20191025143203.7e8fd0b4@carbon>
In-Reply-To: <157192270077.234778.5965993521171571751.stgit@toke.dk>
References: <157192269744.234778.11792009511322809519.stgit@toke.dk>
        <157192270077.234778.5965993521171571751.stgit@toke.dk>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: gb1Fe7ouMZ6a8wiQmDKI7Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Oct 2019 15:11:40 +0200
Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>=20
> This adds support to libbpf for setting map pinning information as part o=
f
> the BTF map declaration. We introduce a version new
> bpf_object__map_pin_opts() function to pin maps based on this setting, as
> well as a getter and setter function for the pin information that callers
> can use after map load.
>=20
> The pinning type currently only supports a single PIN_BY_NAME mode, where
> each map will be pinned by its name in a path that can be overridden, but
> defaults to /sys/fs/bpf.
>=20
> The pinning options supports a 'pin_all' setting, which corresponds to th=
e
> old bpf_object__map_pin() function with an explicit path. In addition, th=
e
> function now defaults to just skipping over maps that are already
> pinned (since the previous commit started recording this in struct
> bpf_map). This behaviour can be turned off with the 'no_skip_pinned' opti=
on.
>=20
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/bpf_helpers.h |    6 ++
>  tools/lib/bpf/libbpf.c      |  134 ++++++++++++++++++++++++++++++++++---=
------
>  tools/lib/bpf/libbpf.h      |   26 ++++++++
>  tools/lib/bpf/libbpf.map    |    3 +
>  4 files changed, 142 insertions(+), 27 deletions(-)
>=20
> diff --git a/tools/lib/bpf/bpf_helpers.h b/tools/lib/bpf/bpf_helpers.h
> index 2203595f38c3..0c7d28292898 100644
> --- a/tools/lib/bpf/bpf_helpers.h
> +++ b/tools/lib/bpf/bpf_helpers.h
> @@ -38,4 +38,10 @@ struct bpf_map_def {
>  =09unsigned int map_flags;
>  };
> =20
> +enum libbpf_pin_type {
> +=09LIBBPF_PIN_NONE,
> +=09/* PIN_BY_NAME: pin maps by name (in /sys/fs/bpf by default) */
> +=09LIBBPF_PIN_BY_NAME,
> +};
> +
>  #endif
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 848e6710b8e6..179c9911458d 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -226,6 +226,7 @@ struct bpf_map {
>  =09void *priv;
>  =09bpf_map_clear_priv_t clear_priv;
>  =09enum libbpf_map_type libbpf_type;
> +=09enum libbpf_pin_type pinning;
>  =09char *pin_path;
>  =09bool pinned;
>  };
> @@ -1271,6 +1272,22 @@ static int bpf_object__init_user_btf_map(struct bp=
f_object *obj,
>  =09=09=09}
>  =09=09=09map->def.value_size =3D sz;
>  =09=09=09map->btf_value_type_id =3D t->type;
> +=09=09} else if (strcmp(name, "pinning") =3D=3D 0) {
> +=09=09=09__u32 val;
> +
> +=09=09=09if (!get_map_field_int(map_name, obj->btf, def, m,
> +=09=09=09=09=09       &val))
> +=09=09=09=09return -EINVAL;
> +=09=09=09pr_debug("map '%s': found pinning =3D %u.\n",
> +=09=09=09=09 map_name, val);
> +
> +=09=09=09if (val !=3D LIBBPF_PIN_NONE &&
> +=09=09=09    val !=3D LIBBPF_PIN_BY_NAME) {
> +=09=09=09=09pr_warning("map '%s': invalid pinning value %u.\n",
> +=09=09=09=09=09   map_name, val);
> +=09=09=09=09return -EINVAL;
> +=09=09=09}
> +=09=09=09map->pinning =3D val;
>  =09=09} else {
>  =09=09=09if (strict) {
>  =09=09=09=09pr_warning("map '%s': unknown field '%s'.\n",
[...]

How does this prepare for being compatible with iproute2 pinning?

iproute2 have these defines (in include/bpf_elf.h):

 /* Object pinning settings */
 #define PIN_NONE                0
 #define PIN_OBJECT_NS           1
 #define PIN_GLOBAL_NS           2

I do know above strcmp(name, "pinning") look at BTF info 'name' and not
directly at the ELF struct for maps.  I don't know enough about BTF
(yet), but won't BTF automatically create a "pinning" info 'name' ???
(with above defines as content/values)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

From above enum:
 LIBBPF_PIN_BY_NAME =3D 1=20

iproute2 ELF map struct:

/* ELF map definition */
struct bpf_elf_map {
        __u32 type;
        __u32 size_key;
        __u32 size_value;
        __u32 max_elem;
        __u32 flags;
        __u32 id;
        __u32 pinning;
        __u32 inner_id;
        __u32 inner_idx;
};

