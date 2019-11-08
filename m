Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B307F5B15
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731622AbfKHWkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:40:17 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:47097 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731470AbfKHWkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:40:16 -0500
Received: by mail-qk1-f193.google.com with SMTP id h15so6708385qka.13;
        Fri, 08 Nov 2019 14:40:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fu78PzF9UWPSdHn2CMCZAnQUPRcI3AzWHQi4lBbBThQ=;
        b=e8PQYvQG/kg45MrxHc1qp5BQ+WKBuRec229TO0CQ5dNPCLp94/DFGaEwiKtyu6yLuc
         NNsFtUeOoCH6AQKh/ezEjwZbiiZujHFMgq8yV5PIzph0C+ASM0ygSuGjxJcIf2vWE1u+
         KjsdURSbfUJ0xaCSE9os5VJlil2fLJRL1FwbLIw/I3R9ECgUERA8wXzTU0odaPRk1SLE
         tLZMln4ECp0QvViwkXFGlQOmrOM9cHnbfsBPhsI5Ys9mrBsSx3jfIw5Ywa+ncq3s19sg
         c4iecKV8pDlDb0OCP2rnZfbiPsPJFfXE0ou+TnHfq7CoCwkzauTiD+rMMSHlExEuzW/e
         IR/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fu78PzF9UWPSdHn2CMCZAnQUPRcI3AzWHQi4lBbBThQ=;
        b=gxHeGYm/oBFiXbfiU2nYVIFArlmdHjEtNnE4LqIHhEU6osDe1/zcpnBm/PYDBbewD0
         lY1zVxBv/cR6PvhMQBVOMB/n/SO95wD7pzALzzZKFurZV/5qp82dYKaVKCN2hAfxj/93
         Jco1E/h14N0hxLIi8og9qD6nctVkUr4yUdwp8NsXFFeQnOeH1PiH5j7C4EkxkX8GyxBp
         fHTUl7Q1KrU4FTfBEnJrrHMYiQDNk+KzHkjneauBXJZ9EaejPR0QL3VlD49vv2bqffVi
         2lN/Du9iZGCZbLWQnwJMhEwZGLOE4xA3CyGpKk8VapZO8eB2LB8IkgC3lYB7EAQgheo5
         YdNg==
X-Gm-Message-State: APjAAAU88BdHDZMzbordxrUe2anw9kwr8WAIzNwRk8aClQkULCDBpX0/
        qz9YLBpD9+DFXpX85PI5SN5Jx6sD2S5SlAJcF0g=
X-Google-Smtp-Source: APXvYqyP4Tsa9n6t2AV3DdnCfjbvh68e09/rY/xyk1hKTPhdCviFy91z4RXN/MU0jW/baiF9RasRJW83xQVgW9nA1TE=
X-Received: by 2002:a05:620a:1011:: with SMTP id z17mr11612141qkj.39.1573252815442;
 Fri, 08 Nov 2019 14:40:15 -0800 (PST)
MIME-Version: 1.0
References: <157324878503.910124.12936814523952521484.stgit@toke.dk> <157324878624.910124.5124587166846797199.stgit@toke.dk>
In-Reply-To: <157324878624.910124.5124587166846797199.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 Nov 2019 14:40:04 -0800
Message-ID: <CAEf4BzbqwpxtDRkYZLNsM7POc9WHAVpM-vvMX5jnEtYUV2PQaA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/6] libbpf: Unpin auto-pinned maps if loading fails
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 1:33 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redha=
t.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Since the automatic map-pinning happens during load, it will leave pinned
> maps around if the load fails at a later stage. Fix this by unpinning any
> pinned maps on cleanup. To avoid unpinning pinned maps that were reused
> rather than newly pinned, add a new boolean property on struct bpf_map to
> keep track of whether that map was reused or not; and only unpin those ma=
ps
> that were not reused.
>
> Fixes: 57a00f41644f ("libbpf: Add auto-pinning of maps when loading BPF o=
bjects")
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  tools/lib/bpf/libbpf.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index be4af95d5a2c..cea61b2ec9d3 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -229,6 +229,7 @@ struct bpf_map {
>         enum libbpf_map_type libbpf_type;
>         char *pin_path;
>         bool pinned;
> +       bool was_reused;

nit: just reused, similar to pinned?

>  };
>
>  struct bpf_secdata {
> @@ -1995,6 +1996,7 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
>         map->def.map_flags =3D info.map_flags;
>         map->btf_key_type_id =3D info.btf_key_type_id;
>         map->btf_value_type_id =3D info.btf_value_type_id;
> +       map->was_reused =3D true;
>
>         return 0;
>
> @@ -4007,15 +4009,18 @@ bpf_object__open_buffer(const void *obj_buf, size=
_t obj_buf_sz,
>         return bpf_object__open_mem(obj_buf, obj_buf_sz, &opts);
>  }
>
> -int bpf_object__unload(struct bpf_object *obj)
> +static int __bpf_object__unload(struct bpf_object *obj, bool unpin)
>  {
>         size_t i;
>
>         if (!obj)
>                 return -EINVAL;
>
> -       for (i =3D 0; i < obj->nr_maps; i++)
> +       for (i =3D 0; i < obj->nr_maps; i++) {
>                 zclose(obj->maps[i].fd);
> +               if (unpin && obj->maps[i].pinned && !obj->maps[i].was_reu=
sed)
> +                       bpf_map__unpin(&obj->maps[i], NULL);
> +       }
>
>         for (i =3D 0; i < obj->nr_programs; i++)
>                 bpf_program__unload(&obj->programs[i]);
> @@ -4023,6 +4028,11 @@ int bpf_object__unload(struct bpf_object *obj)
>         return 0;
>  }
>
> +int bpf_object__unload(struct bpf_object *obj)
> +{
> +       return __bpf_object__unload(obj, false);
> +}
> +
>  int bpf_object__load_xattr(struct bpf_object_load_attr *attr)
>  {
>         struct bpf_object *obj;
> @@ -4047,7 +4057,7 @@ int bpf_object__load_xattr(struct bpf_object_load_a=
ttr *attr)
>
>         return 0;
>  out:
> -       bpf_object__unload(obj);
> +       __bpf_object__unload(obj, true);

giving this is the only (special) case of auto-unpinning auto-pinned
maps, why not do a trivial loop here, instead of having this extra
unpin flag and extra __bpf_object__unload function?

>         pr_warn("failed to load object '%s'\n", obj->path);
>         return err;
>  }
>
