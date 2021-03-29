Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C516834D5F7
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 19:24:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbhC2RXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 13:23:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:50958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhC2RXa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Mar 2021 13:23:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE91C61927;
        Mon, 29 Mar 2021 17:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617038610;
        bh=GXaysGhfaLdk/KpFUAKNubm7EQUrHb2S6afCoqSazSw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Skgh61+mHWHO55giZyDkgHMzqEqM0GXUZBH8KvU+R8NHm2IAmBG5teosB3xXn2lDk
         WxQMxNCkDkk8mnQMX5d8Dp0xQBcngpATGgrrW9adYLG66P9KxikqRXtUNS7kqGuIo0
         6qss/CM97qOZ84sTMxWbl2hB0q4oNkWPrJuJbxpwljVOb+7AWMv40Pv7ymJ6CffSsc
         ZdtHb1nK265lqBe6lqYnvTrgQQW38ZkEF4dGBwmGlZISS4DYTlmBfOkuKw4K2i3i+m
         jAB90knUczn6HXWJH4a5Q+ma61hIf+qrG1GZIMjRs7yF+lOwho97O/i0BCdkGFySDt
         qDMbCSfKUlApw==
Received: by mail-lj1-f181.google.com with SMTP id u4so16828369ljo.6;
        Mon, 29 Mar 2021 10:23:29 -0700 (PDT)
X-Gm-Message-State: AOAM531c4W/t0mjDTMMPoJcNqVzo9gj+RLciQ/Jfhe3hZo+Nhzb34fuJ
        l262Tcd8E0es1aIT7cVTydOBaNvLrzahB5zwlrE=
X-Google-Smtp-Source: ABdhPJxD/JFAObN7DzQhGxIGns37u8u4wv7Yq1Gq6EwnhFp8nSdArd7f4I0WljwF2qqyvnH5wyr4KU7SGu9XTbDQS0I=
X-Received: by 2002:a2e:7a08:: with SMTP id v8mr18848615ljc.344.1617038608105;
 Mon, 29 Mar 2021 10:23:28 -0700 (PDT)
MIME-Version: 1.0
References: <20210329164541.3240579-1-sdf@google.com>
In-Reply-To: <20210329164541.3240579-1-sdf@google.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 29 Mar 2021 10:23:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6fw8Zsh=jvUbwxfRrtKSCR9wwF6KXyWLb=z_xPHGVMAw@mail.gmail.com>
Message-ID: <CAPhsuW6fw8Zsh=jvUbwxfRrtKSCR9wwF6KXyWLb=z_xPHGVMAw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] tools/resolve_btfids: Fix warnings
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 29, 2021 at 9:46 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> * make eprintf static, used only in main.c
> * initialize ret in eprintf
> * remove unused *tmp
> * remove unused 'int err = -1'
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/bpf/resolve_btfids/main.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
>
> diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> index 80d966cfcaa1..be74406626b7 100644
> --- a/tools/bpf/resolve_btfids/main.c
> +++ b/tools/bpf/resolve_btfids/main.c
> @@ -115,10 +115,10 @@ struct object {
>
>  static int verbose;
>
> -int eprintf(int level, int var, const char *fmt, ...)
> +static int eprintf(int level, int var, const char *fmt, ...)
>  {
>         va_list args;
> -       int ret;
> +       int ret = 0;
>
>         if (var >= level) {
>                 va_start(args, fmt);
> @@ -403,10 +403,9 @@ static int symbols_collect(struct object *obj)
>          * __BTF_ID__* over .BTF_ids section.
>          */
>         for (i = 0; !err && i < n; i++) {
                    ^^^^ This err is also not used.

> -               char *tmp, *prefix;
> +               char *prefix;
>                 struct btf_id *id;
>                 GElf_Sym sym;
> -               int err = -1;
>
>                 if (!gelf_getsym(obj->efile.symbols, i, &sym))
>                         return -1;
> --
> 2.31.0.291.g576ba9dcdaf-goog
>
