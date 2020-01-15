Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D91513B6F7
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 02:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728880AbgAOBep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 20:34:45 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:40599 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbgAOBep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 20:34:45 -0500
Received: by mail-qt1-f195.google.com with SMTP id v25so14392767qto.7;
        Tue, 14 Jan 2020 17:34:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aTU0fuqgiVzPDtBDRAgLUQD6JAhl3bPev7AC09eClmQ=;
        b=fwb3Gz9yB/Cflt44p3dJXyBfK0QX29rFRDz9PkLrLAw9iSA3CVJE/QYTbthvVY8Sso
         DHpHzmBiaMcoWTtYvexM9j8NFPDTji0i/61kwg0AzVtv/0Ib04zXDPdSu129czzYF02t
         5/GcTU1KWxAXLb7UxZ8geVCrQ5sg+b0s9kntARzZe7WrXmbjBHo2Hv1bdstIaKrPBXGu
         lA6ilb+PVKb960neBZor4S0ncjDQC26LeeED/zgYp7S3VmhefE3U2eEnzPTBOIXaCOn1
         YF69WMt3hETjdyAOI2Xvx7aLqGG9gMuKh63U2+mggoMAlcEmN8nwHfcwXkkOVPjWuLIp
         wy7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aTU0fuqgiVzPDtBDRAgLUQD6JAhl3bPev7AC09eClmQ=;
        b=LN2V1Bw4g03bK1XmBoAL/GqgEMJCod0GFpIiqTYGHz17NKlBiJjwLRRQkUQBYUOGNt
         P4oED9fxZ+rOq1p3z5+Uoztxg6AIihBzxjx8D5hlFT03SNc0/d3gBy/JGBC8pL39hUb5
         xuzgT9MitgoD7RVt/NxUM3n0Llo41sAOtLFOhM+/CmnIIerGAqVGqVfz0hfrui+MDFAN
         7YxeIqEYoZpYzC6R7AslpJIpVPAC+PUiaBclQoqAWYySjKM5XbChAXJYbyEeDBJ77ThG
         XY5pFqe8gEOC8mTB5vhtWirH971SxzVWew5e4OaV7QHSwrjvmkMKC63k90x1RsWo7PPJ
         /B7A==
X-Gm-Message-State: APjAAAXs64dEm0lkLxIKUzuWxp2ONqisWHdFnewaaUGYpFP6PgfkatA8
        yXGh1X66r9fchPae49rAzIGHl8rfLttwu0EKMwU=
X-Google-Smtp-Source: APXvYqzsDp5+QK8GRG9ieSS1qze0LEhzgA5rmoJY4bpi9nrF12/wEXwPe6YdX9Yg2KIm5eClJlpPPQK+ojPqS4omxA4=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr1376367qtl.171.1579052084250;
 Tue, 14 Jan 2020 17:34:44 -0800 (PST)
MIME-Version: 1.0
References: <20200114224358.3027079-1-kafai@fb.com> <20200114224406.3027562-1-kafai@fb.com>
In-Reply-To: <20200114224406.3027562-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 17:34:33 -0800
Message-ID: <CAEf4BzbrcKLKvgKY+nSxV22T2nHgucmB2N01bEQiXS+g7npQfw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/5] bpftool: Fix missing BTF output for json
 during map dump
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

On Tue, Jan 14, 2020 at 2:45 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The btf availability check is only done for plain text output.
> It causes the whole BTF output went missing when json_output
> is used.
>
> This patch simplifies the logic a little by avoiding passing "int btf" to
> map_dump().
>
> For plain text output, the btf_wtr is only created when the map has
> BTF (i.e. info->btf_id != 0).  The nullness of "json_writer_t *wtr"
> in map_dump() alone can decide if dumping BTF output is needed.
> As long as wtr is not NULL, map_dump() will print out the BTF-described
> data whenever a map has BTF available (i.e. info->btf_id != 0)
> regardless of json or plain-text output.
>
> In do_dump(), the "int btf" is also renamed to "int do_plain_btf".
>
> Fixes: 99f9863a0c45 ("bpftool: Match maps by name")
> Cc: Paul Chaignon <paul.chaignon@orange.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

just one nit below

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/map.c | 42 ++++++++++++++++++++---------------------
>  1 file changed, 20 insertions(+), 22 deletions(-)
>
> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> index e00e9e19d6b7..45c1eda6512c 100644
> --- a/tools/bpf/bpftool/map.c
> +++ b/tools/bpf/bpftool/map.c
> @@ -933,7 +933,7 @@ static int maps_have_btf(int *fds, int nb_fds)
>
>  static int
>  map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
> -        bool enable_btf, bool show_header)
> +        bool show_header)
>  {
>         void *key, *value, *prev_key;
>         unsigned int num_elems = 0;
> @@ -950,18 +950,16 @@ map_dump(int fd, struct bpf_map_info *info, json_writer_t *wtr,
>
>         prev_key = NULL;
>
> -       if (enable_btf) {
> -               err = btf__get_from_id(info->btf_id, &btf);
> -               if (err || !btf) {
> -                       /* enable_btf is true only if we've already checked
> -                        * that all maps have BTF information.
> -                        */
> -                       p_err("failed to get btf");
> -                       goto exit_free;
> +       if (wtr) {
> +               if (info->btf_id) {

combine into if (wtr && info->btf_id) and reduce nestedness?


> +                       err = btf__get_from_id(info->btf_id, &btf);
> +                       if (err || !btf) {
> +                               err = err ? : -ESRCH;
> +                               p_err("failed to get btf");
> +                               goto exit_free;
> +                       }

[...]
