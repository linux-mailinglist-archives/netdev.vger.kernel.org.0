Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 351B413B6B1
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 02:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgAOBKP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 20:10:15 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46710 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728824AbgAOBKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 20:10:15 -0500
Received: by mail-qk1-f193.google.com with SMTP id r14so14157433qke.13;
        Tue, 14 Jan 2020 17:10:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qtGRCHCTEMrYI0dapSAaJ8F4Dq1twtUKjbRbZ5wXw6I=;
        b=Wir09snb6xDM/jw9+G9k2n9gDAK9f9WguNPYryCEilpCd7YdFswBCXIaDjErqBpAaR
         VZxIud0H5Loxr1TTGC8RiLou7CzextAv6o1i6EVVJ+dbI1okG7Yr/SlCCblHnSjDcMYc
         ALNt14vv69ywR0olWs+grd+hooKbasARNauGr1PI44sdcDmCRx2SRa6KLtCpsMYnSHge
         a7cJP8jxf7R9g9QvMkXpILs4UnzlnkWTnT5A5cbMhUHVBFkoUTksOrypo41gPeABsN2X
         EtpnZYq1Kd5XEcHPl48I0vBWA4ISX5kAzRR//FhilsXGf8ME/AKm2AjkaaqFqaS7vNFb
         D3dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qtGRCHCTEMrYI0dapSAaJ8F4Dq1twtUKjbRbZ5wXw6I=;
        b=XbFfxdmnlEHfCu5AAFJFwLgJQgBSvsZunpDbNXystwL9grYJOL6aaQSVicmdBWAF0f
         X2c0ccxZ5CTQBN+Lgd0MOKr5PuStfStkpUPMbASK3XK2JANXGua6mq53uu9YJZpR1WH6
         PZ2fEoiQ/6fFp+2yQzVIT8cNq3HhcP1/AI7XVtVfgd4Dajg0OhdLk0yQxANaetmmPo5j
         YZlzGuJtaMJV75mGiOZD3W0APUrrXIloMod9uSW8dwUKG1LvH8Hbxcj2YwxDpnPvo/vZ
         PNoKif1GWhcfUUf59QuwF3WCFikQbdy/7mOGpCvUxgDr0SCPtDh5nDHB+0KgYGTwuhYU
         vNdA==
X-Gm-Message-State: APjAAAW/F16/eh38jjk6qKuNoeb9XwcgWOvQ7f33WAWQxRs566pesvSG
        HCpvMwbN9Wce6inTP7ajFRc1UPT/9niPRONE0r8=
X-Google-Smtp-Source: APXvYqziXaySvA/eS9Ji+z80tz7X3E4oBU+NKaFp6x9liCgFH4t3XFOgy9k5L1WcXBRnvdk6K5ukFbsJN7M7o1U7e0c=
X-Received: by 2002:a37:e408:: with SMTP id y8mr24768199qkf.39.1579050614544;
 Tue, 14 Jan 2020 17:10:14 -0800 (PST)
MIME-Version: 1.0
References: <20200114224358.3027079-1-kafai@fb.com> <20200114224400.3027140-1-kafai@fb.com>
In-Reply-To: <20200114224400.3027140-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 17:10:03 -0800
Message-ID: <CAEf4BzZd-NmpJqYStpDTSAFmN=EDCLftqoYBaSAKECOY8ooR_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/5] bpftool: Fix a leak of btf object
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Paul Chaignon <paul.chaignon@orange.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 2:44 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> When testing a map has btf or not, maps_have_btf() tests it by actually
> getting a btf_fd from sys_bpf(BPF_BTF_GET_FD_BY_ID). However, it
> forgot to btf__free() it.
>
> In maps_have_btf() stage, there is no need to test it by really
> calling sys_bpf(BPF_BTF_GET_FD_BY_ID). Testing non zero
> info.btf_id is good enough.
>
> Also, the err_close case is unnecessary, and also causes double
> close() because the calling func do_dump() will close() all fds again.
>
> Fixes: 99f9863a0c45 ("bpftool: Match maps by name")
> Cc: Paul Chaignon <paul.chaignon@orange.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

this is clearly a simplification, but isn't do_dump still buggy? see below

>  tools/bpf/bpftool/map.c | 16 ++--------------
>  1 file changed, 2 insertions(+), 14 deletions(-)
>
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index c01f76fa6876..e00e9e19d6b7 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -915,32 +915,20 @@ static int maps_have_btf(int *fds, int nb_fds)
>  {
>         struct bpf_map_info info = {};
>         __u32 len = sizeof(info);
> -       struct btf *btf = NULL;
>         int err, i;
>
>         for (i = 0; i < nb_fds; i++) {
>                 err = bpf_obj_get_info_by_fd(fds[i], &info, &len);
>                 if (err) {
>                         p_err("can't get map info: %s", strerror(errno));
> -                       goto err_close;
> -               }
> -
> -               err = btf__get_from_id(info.btf_id, &btf);
> -               if (err) {
> -                       p_err("failed to get btf");
> -                       goto err_close;
> +                       return -1;
>                 }
>
> -               if (!btf)
> +               if (!info.btf_id)
>                         return 0;

if info.btf_id is non-zero, shouldn't we immediately return 1 and be
done with it?

I'm also worried about do_dump logic. What's the behavior when some
maps do have BTF and some don't? Should we use btf_writer for all,
some or none maps for that case? I'd expect we'd use BTF info for
those maps that have BTF and fall back to raw output for those that
don't, but I'm not sure that how code behaves right now.

Maybe Paul can clarify...


>         }
>
>         return 1;
> -
> -err_close:
> -       for (; i < nb_fds; i++)
> -               close(fds[i]);
> -       return -1;
>  }
>
>  static int
> --
> 2.17.1
>
