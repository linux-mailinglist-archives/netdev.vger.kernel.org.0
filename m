Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A112B0D8D
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 20:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgKLTLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 14:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbgKLTLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 14:11:46 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95AA5C0613D1;
        Thu, 12 Nov 2020 11:11:46 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id k65so6395991ybk.5;
        Thu, 12 Nov 2020 11:11:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UatfkCMnDMwBCdWWG+8VoYx8M+kV4jfTmDtlXc6p7hU=;
        b=GzKn7K+SOrWfGkSTo33Qe1tznQkHc+eECiN+qjzLD9Ejk85YGG27QnUrMqWlZ/wfPO
         2MQzi4BAZwesZCrNZWh0W9ygyOpHf47BdacHnCUImc6GnqBj37wtIAmWXMdllBFI6FTz
         U7vMDghFczjIsgAs2FSeLWVNzO/qTiyHLBlvb1JSBAXMN0V7IJB72KrBo5SYQV9GQC+S
         /LprQjOhjFa6FCk+qZFM4Zyffe8rZ0hu3DGlW9aYOFbWGiQ5Qd9UVGnGi/EqkaEv11FD
         8DweapiGvf7dP79Dk5DQykSAIhdZ5i028RxiU1XLqw1weBFasHPZFYzC53wo6YrZ2ZHt
         5i5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UatfkCMnDMwBCdWWG+8VoYx8M+kV4jfTmDtlXc6p7hU=;
        b=YKJz5MR7K4iEfmhwqnL2pVLozSv0I8kgI5nmX+9D9xzkKb2SdicsmSXCq4pnqPxUan
         E2XzxvxDqzB0OWWXXqSCwDrTrfuu84BsCHHb4RscoDrRfxtLfPpTfsnv8CK5slOHTR/Q
         5s6ag6qUBYFqVWPL2x5Cd704c89HYgoZIYutZ3npyZ6wlBerdrCMJNfyiPuzWNhJxHY4
         IGfAmAPQ7iVdt+8/bVveQSPT8XQ5hH8LrqEUXAkUpqZVQGVfSWyWw/FWzP4VeqtrhteW
         edTYZImvhRC8SCM8/r4uafbL8SryK6Pg90YaV3liQ/Vb4F1RkSxmfpr3Kvmf1S/va8cV
         HG9A==
X-Gm-Message-State: AOAM530B3zOO18ovER7UZQ0wXNLD6jni9DgZfUZj1dFp1cPR7zT9+dyi
        408IHJqKPrCoaKMmj2aCM8TZvbMlZpMhB26KZRI=
X-Google-Smtp-Source: ABdhPJw8ZP2CwBuHliiQqxLRHSHSdnAHFP4ynUVwACm4UTM5nI51kcTItKpg8G8KB3G1X55TlKlZIgb7aoZttW2EJEs=
X-Received: by 2002:a25:7717:: with SMTP id s23mr1300624ybc.459.1605208305880;
 Thu, 12 Nov 2020 11:11:45 -0800 (PST)
MIME-Version: 1.0
References: <20201112085854.3764-1-mariuszx.dudek@intel.com> <20201112085854.3764-2-mariuszx.dudek@intel.com>
In-Reply-To: <20201112085854.3764-2-mariuszx.dudek@intel.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 12 Nov 2020 11:11:35 -0800
Message-ID: <CAEf4Bzam8O=tUM-YZ=XHbJPVohYW9SfQL+ynNd5MnFF3mNREhw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/2] libbpf: separate XDP program load with
 xsk socket creation
To:     mariusz.dudek@gmail.com
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Mariusz Dudek <mariuszx.dudek@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 12:58 AM <mariusz.dudek@gmail.com> wrote:
>
> From: Mariusz Dudek <mariuszx.dudek@intel.com>
>
> Add support for separation of eBPF program load and xsk socket
> creation.
>
> This is needed for use-case when you want to privide as little
> privileges as possible to the data plane application that will
> handle xsk socket creation and incoming traffic.
>
> With this patch the data entity container can be run with only
> CAP_NET_RAW capability to fulfill its purpose of creating xsk
> socket and handling packages. In case your umem is larger or
> equal process limit for MEMLOCK you need either increase the
> limit or CAP_IPC_LOCK capability.
>
> To resolve privileges issue two APIs are introduced:
>
> - xsk_setup_xdp_prog - prepares bpf program if given and
> loads it on a selected network interface or loads the built in
> XDP program, if no XDP program is supplied. It can also return
> xsks_map_fd which is needed by unprivileged process to update
> xsks_map with AF_XDP socket "fd"
>
> - xsk_socket__update_xskmap - inserts an AF_XDP socket into an xskmap
> for a particular xsk_socket
>
> Signed-off-by: Mariusz Dudek <mariuszx.dudek@intel.com>
> ---
>  tools/lib/bpf/libbpf.map |   2 +
>  tools/lib/bpf/xsk.c      | 160 ++++++++++++++++++++++++++++++++-------
>  tools/lib/bpf/xsk.h      |  15 ++++
>  3 files changed, 151 insertions(+), 26 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 29ff4807b909..73aa12388055 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -336,6 +336,8 @@ LIBBPF_0.2.0 {
>                 perf_buffer__epoll_fd;
>                 perf_buffer__consume_buffer;
>                 xsk_socket__create_shared;
> +               xsk_setup_xdp_prog;
> +               xsk_socket__update_xskmap;
>  } LIBBPF_0.1.0;


New APIs have to go into LIBBPF_0.3.0 section now.

>
>  LIBBPF_0.3.0 {

[...]

> +static int __xsk_setup_xdp_prog(struct xsk_socket *_xdp,
> +                               struct bpf_prog_cfg_opts *cfg,
> +                               bool force_set_map,
> +                               int *xsks_map_fd)
>  {
> +       struct xsk_socket *xsk =3D _xdp;
>         struct xsk_ctx *ctx =3D xsk->ctx;
>         __u32 prog_id =3D 0;
>         int err;
> @@ -578,14 +633,17 @@ static int xsk_setup_xdp_prog(struct xsk_socket *xs=
k)
>                 return err;
>
>         if (!prog_id) {
> -               err =3D xsk_create_bpf_maps(xsk);
> -               if (err)
> -                       return err;
> +               if (!cfg || !cfg->insns_cnt) {

you can't do this, use OPTS_GET() macro to access fields of opts struct.

> +                       err =3D xsk_create_bpf_maps(xsk);
> +                       if (err)
> +                               return err;
> +               } else {
> +                       ctx->xsks_map_fd =3D cfg->xsks_map_fd;

same

> +               }
>
> -               err =3D xsk_load_xdp_prog(xsk);
> +               err =3D xsk_load_xdp_prog(xsk, cfg);
>                 if (err) {
> -                       xsk_delete_bpf_maps(xsk);
> -                       return err;
> +                       goto err_load_xdp_prog;
>                 }
>         } else {
>                 ctx->prog_fd =3D bpf_prog_get_fd_by_id(prog_id);

[...]

>  int xsk_socket__create_shared(struct xsk_socket **xsk_ptr,
>                               const char *ifname,
>                               __u32 queue_id, struct xsk_umem *umem,
> @@ -838,7 +946,7 @@ int xsk_socket__create_shared(struct xsk_socket **xsk=
_ptr,
>         ctx->prog_fd =3D -1;
>
>         if (!(xsk->config.libbpf_flags & XSK_LIBBPF_FLAGS__INHIBIT_PROG_L=
OAD)) {
> -               err =3D xsk_setup_xdp_prog(xsk);
> +               err =3D __xsk_setup_xdp_prog(xsk, NULL, false, NULL);
>                 if (err)
>                         goto out_mmap_tx;
>         }
> diff --git a/tools/lib/bpf/xsk.h b/tools/lib/bpf/xsk.h
> index 1069c46364ff..c852ec742437 100644
> --- a/tools/lib/bpf/xsk.h
> +++ b/tools/lib/bpf/xsk.h
> @@ -201,6 +201,21 @@ struct xsk_umem_config {
>         __u32 flags;
>  };
>
> +struct bpf_prog_cfg_opts {

The name of this struct doesn't really match an API it's used in, it
looks to be related to struct bpf_program, which is extremely
misleading. Why didn't you go with something like
xdp_setup_xdp_prog_opts?

Also, so far we've been following the convention that non-optional
parameters are passed directly as function arguments, with all the
optional things put into opts. Looking at this struct, prog and
insns_cnt look non-optional. Not sure about the license. Also, it
seems strange to have xsks_map_fd in opts struct and as an output
parameter... If that's really in/out param, you can do OPTS_SET() and
pass it back through the same opts struct.

But in general, I'm also surprised that this API is using the bpf_insn
array as an input. Do people really construct such a low-level set of
instructions manually? Seems like a rather painful API.

Bj=C3=B6rn, Magnus, please take a look as well and chime in on API design
(I have too little context on XSK use cases).


> +       size_t sz; /* size of this struct for forward/backward compatibil=
ity */
> +       struct bpf_insn *prog;
> +       const char *license;
> +       size_t insns_cnt;
> +       int xsks_map_fd;
> +};
> +#define bpf_prog_cfg_opts__last_field xsks_map_fd
> +
> +LIBBPF_API int xsk_setup_xdp_prog(int ifindex,
> +                                 struct bpf_prog_cfg_opts *opts,
> +                                 int *xsks_map_fd);
> +LIBBPF_API int xsk_socket__update_xskmap(struct xsk_socket *xsk,
> +                                int xsks_map_fd);
> +
>  /* Flags for the libbpf_flags field. */
>  #define XSK_LIBBPF_FLAGS__INHIBIT_PROG_LOAD (1 << 0)
>
> --
> 2.20.1
>
