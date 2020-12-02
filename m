Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3FF72CC9E6
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 23:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387674AbgLBWrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 17:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725985AbgLBWrY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 17:47:24 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3710BC0617A7;
        Wed,  2 Dec 2020 14:46:38 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id k65so214545ybk.5;
        Wed, 02 Dec 2020 14:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pwUrm+QxZOyCRgJeV0KGuo8maVGL8VcTOqbtjUVUc4M=;
        b=DW3osq6sdBMOn22Q8+G8ESf1ZwIpr7BvB0oNcR0zR8ymcDatlCiA66snZNCdTt+T7O
         OP+ymdctYzM5dPSBU6g0871k1lJxryB4KnRroRuTe54UU4s0M5aDmIdYobjBNillD+6L
         WbHqy3Z1KpA1writWrTXgxgHjQ+3rK97gAWGQAqBBvqEinsP+IB/tUOxBgNiqHcWt/zN
         h0HDP2zmN9iBKCDw23NRTEiDsDBsVRmilq1htY5nN0tUhEfqptLOhxZaRlVESw1cWetC
         Ftkass+hJXu/p25UM5RKqkg4X/z/DoFtKP7HvxqQ2NXljCZY9amBgzHHKQgUWshe7TWy
         KjOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pwUrm+QxZOyCRgJeV0KGuo8maVGL8VcTOqbtjUVUc4M=;
        b=SpRIZqGR3SlABAWJWoIByNlXC4rLT2bcJwNqbK5wuPTrwO9bCb0V9p3IgG4Jh7z52H
         lsgDz/+k3By9b9EffzJ9w0N5JXgZ3QT9V9bq9bl0U5UIi7B40fXCDeBKfBSwJ1aR3EKv
         RuUU7kAb6w9oe6o1I5OU/3USwchJ69mjRyBlZsPhXmLcWAHEqHXIMZxPgHgUpbPH7SLH
         ++s1WGKYCvQ49rNZStKIG4UvK98prnm+OQ1hTpTpEaLdSIJZ/r68op+GLnDMSdQh43+E
         GdM/zzXLkPuXJQzc/j5xcFrBalnQyo8vf4sB0jNvZ7DAaqn4b67TUmZje1fkuGS0aCSz
         y2Fg==
X-Gm-Message-State: AOAM531NRUyDU0DzQrre+BlRAKT1dXweKmjrDFktRUjs0KlcC+On8Viz
        lHWyVe0CsBON2KtbbWOfuUIi3LvddGuTOm1xI9qyrpllAseyJA==
X-Google-Smtp-Source: ABdhPJyyw0EE7Mm36RoxgKGrpVn2B6cdckJ8/NFZzhS3AIJG6/UvXGNKM/FbI3J+3aDiZT6umhsKhHNSDll7qyjNte0=
X-Received: by 2002:a25:c089:: with SMTP id c131mr550780ybf.510.1606949197557;
 Wed, 02 Dec 2020 14:46:37 -0800 (PST)
MIME-Version: 1.0
References: <20201202175039.3625166-1-sdf@google.com>
In-Reply-To: <20201202175039.3625166-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 2 Dec 2020 14:46:26 -0800
Message-ID: <CAEf4BzZKPvO+b-_WARYcs1Y3mckgT_OJKh7K7LSh2orSL5AG8g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: add retries in sys_bpf_prog_load
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 2, 2020 at 9:52 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> I've seen a situation, where a process that's under pprof constantly
> generates SIGPROF which prevents program loading indefinitely.
> The right thing to do probably is to disable signals in the upper
> layers while loading, but it still would be nice to get some error from
> libbpf instead of an endless loop.
>
> Let's add some small retry limit to the program loading:
> try loading the program 10 (arbitrary) times and give up.
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---

The subject is misleading as hell. You are not adding retries, you are
limiting the number of retries.

Otherwise, LGTM. I'd probably go with an even smaller number, can't
imagine any normal use case having more than once EAGAIN. So I'd say
feel free to reduce it to 5 even.

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  tools/lib/bpf/bpf.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index d27e34133973..31ebd6b3ec7c 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -67,11 +67,12 @@ static inline int sys_bpf(enum bpf_cmd cmd, union bpf_attr *attr,
>
>  static inline int sys_bpf_prog_load(union bpf_attr *attr, unsigned int size)
>  {
> +       int retries = 10;
>         int fd;
>
>         do {
>                 fd = sys_bpf(BPF_PROG_LOAD, attr, size);
> -       } while (fd < 0 && errno == EAGAIN);
> +       } while (fd < 0 && errno == EAGAIN && retries-- > 0);
>
>         return fd;
>  }
> --
> 2.29.2.454.gaff20da3a2-goog
>
