Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825072E31E
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 19:24:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbfE2RYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 13:24:04 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36622 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfE2RYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 13:24:04 -0400
Received: by mail-qt1-f193.google.com with SMTP id u12so3589573qth.3;
        Wed, 29 May 2019 10:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jseR0G1MK8l+SedwWAn1+xBXO7oEnZiUpZgmshuXjz0=;
        b=Qn7GudkzA3xXSobCXURVJJ6+nQeYz/Kz6q6xjwWs1qW07xGQ4sdIYFNhDOxjhixm2s
         HL1DEQjUwjQQuKFgpZpBPYPuu8Mlh3DP27rrBkXFZL9IxsGQF/l0VDLH2E6GaxbQ45VG
         qNKBZvEU9+BLTdGgR5RDb2+XCCpDbSnN/9A2QB0g9Yg9lyr3sfR+VgdEHhnP7iGwWdhR
         PRrDJGgzoWSM9MBem67FERstpmwPo/GBa+Q8RJ6dyBI4yoeh7B+5TAeaRdy//NTsxK2M
         vRCMI1nFHs66timVejLVNIHDBsuoM662LnLMoVJxOFZ8QFXspWvSJZd9QCjfPmU6sMu+
         BB5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jseR0G1MK8l+SedwWAn1+xBXO7oEnZiUpZgmshuXjz0=;
        b=gz1ITQYHf0vDIWiKE0+/QA+IuTHCW6TuAZ7ciQ4+dnWma9UsUKcFnqEpyr3e38h/Gv
         0zXIszMfTDss2SHmbwK4zNE2pOOdYBw4QoO1LZqNHQ/HOaSJgYOm1O6+3whb2QryphG4
         dSbVAugas5omtpe9JHA/dt4sP6dGrdA0JgH1kCUwmXidFplYCxNBUBCkf17JwFYeE07/
         gAEJ0+eqqszf9Wxiit+4oc+xV/U289kLj9vEjXPLiv6bvvtysNoqZZBnofAC5F6gk/Q7
         Ni+OCFE5i2IauSYIo88OOmPJ1/9N8T4Ye6yO1AMpumHSUIaCoYkPR5l/UxqQJ5zJ0W1O
         weRQ==
X-Gm-Message-State: APjAAAWDukBmiNdO0uzraya3jxg1u7dlgf+Cthvy7mhXGybV61UqmToE
        jeEO/IZOZiLQ6lvtv8HyvYCVNrlmjnlU82ucAslHCA+vsVc=
X-Google-Smtp-Source: APXvYqwqaQkbWkSA9n7gxYchfWrtWbi4aBYWgcjg5ty6Myz0wvTm9z0q5Gz3sYg/WktolcsEvCxlcdgPVZSSAJ7SHEs=
X-Received: by 2002:aed:3bd7:: with SMTP id s23mr21030065qte.139.1559150643071;
 Wed, 29 May 2019 10:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190529011426.1328736-1-andriin@fb.com> <20190529011426.1328736-7-andriin@fb.com>
In-Reply-To: <20190529011426.1328736-7-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 29 May 2019 10:23:51 -0700
Message-ID: <CAPhsuW4UGQ1MRzmA5YLkQ_cem70BvNLQXimXjVVej46+TZ+=Hw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/9] libbpf: use negative fd to specify missing BTF
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 6:14 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> 0 is a valid FD, so it's better to initialize it to -1, as is done in
> other places. Also, technically, BTF type ID 0 is valid (it's a VOID
> type), so it's more reliable to check btf_fd, instead of
> btf_key_type_id, to determine if there is any BTF associated with a map.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/lib/bpf/libbpf.c | 13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 9c45856e7fd6..292ea9a2dc3d 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -1751,7 +1751,7 @@ bpf_object__create_maps(struct bpf_object *obj)
>                 create_attr.key_size = def->key_size;
>                 create_attr.value_size = def->value_size;
>                 create_attr.max_entries = def->max_entries;
> -               create_attr.btf_fd = 0;
> +               create_attr.btf_fd = -1;
>                 create_attr.btf_key_type_id = 0;
>                 create_attr.btf_value_type_id = 0;
>                 if (bpf_map_type__is_map_in_map(def->type) &&
> @@ -1765,11 +1765,11 @@ bpf_object__create_maps(struct bpf_object *obj)
>                 }
>
>                 *pfd = bpf_create_map_xattr(&create_attr);
> -               if (*pfd < 0 && create_attr.btf_key_type_id) {
> +               if (*pfd < 0 && create_attr.btf_fd >= 0) {
>                         cp = libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
>                         pr_warning("Error in bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n",
>                                    map->name, cp, errno);
> -                       create_attr.btf_fd = 0;
> +                       create_attr.btf_fd = -1;
>                         create_attr.btf_key_type_id = 0;
>                         create_attr.btf_value_type_id = 0;
>                         map->btf_key_type_id = 0;
> @@ -2053,6 +2053,9 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>         char *log_buf;
>         int ret;
>
> +       if (!insns || !insns_cnt)
> +               return -EINVAL;
> +
>         memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
>         load_attr.prog_type = prog->type;
>         load_attr.expected_attach_type = prog->expected_attach_type;
> @@ -2063,7 +2066,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>         load_attr.license = license;
>         load_attr.kern_version = kern_version;
>         load_attr.prog_ifindex = prog->prog_ifindex;
> -       load_attr.prog_btf_fd = prog->btf_fd >= 0 ? prog->btf_fd : 0;
> +       load_attr.prog_btf_fd = prog->btf_fd;
>         load_attr.func_info = prog->func_info;
>         load_attr.func_info_rec_size = prog->func_info_rec_size;
>         load_attr.func_info_cnt = prog->func_info_cnt;
> @@ -2072,8 +2075,6 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
>         load_attr.line_info_cnt = prog->line_info_cnt;
>         load_attr.log_level = prog->log_level;
>         load_attr.prog_flags = prog->prog_flags;
> -       if (!load_attr.insns || !load_attr.insns_cnt)
> -               return -EINVAL;
>
>  retry_load:
>         log_buf = malloc(log_buf_size);
> --
> 2.17.1
>
