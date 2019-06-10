Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E04D3BBA7
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 20:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388615AbfFJSIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 14:08:36 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46455 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388052AbfFJSIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 14:08:36 -0400
Received: by mail-qt1-f196.google.com with SMTP id h21so11488208qtn.13;
        Mon, 10 Jun 2019 11:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nflauVPbyLwusFZ5ad+DiuoA3+GtaC/q+NMse3a4k0w=;
        b=fqpDvOWOPi8y993zxviCiViaVgAdAu8bW+exWEji9NlXblzm5j0fb85xkQhkaYDnLI
         egNpmQ12fmPcAjvng194Hs36qBtJb1pC6aZPDJs/znSa/Jol/HfX4jMitXRgrtg8OEx3
         fvga83KL/gcuVnPf1sz7jzS6QJtBXB1v1ApghrnOCnkplhnoMZU3eRaInjZPQFu/akiH
         aLkuSyVVQPnXC51ZdbzvahWLrajv7aRJc4iMn0Zwgbi+PGBI5/O9dMwThMl3m7ApggbZ
         s1LoCvkMMIEVfRj+8nhZsoJ3bqw6sgZ7++FarCCP7UV4od/uNDk4mIm6a8FwaIcyyjDU
         a2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nflauVPbyLwusFZ5ad+DiuoA3+GtaC/q+NMse3a4k0w=;
        b=pRsj4LlWVTYwVhY/ADbGNv9nmc06EPYVNEXDmT6wS4/x2k3OkvMyKcooENrWOJ4Wos
         vVR+9UzyoWi8pCrmuCThS4od63bMzBFNnp6xeNX0ww6bJMSDLfYT6jMktUK5dUcOqP2A
         LDC3HHd3OeyfYZLl5kIYtOHMc5I60QngB7vEt9dFCpVISmjyHIZrF1+zWnbNwrl3j8NW
         /Z3JoyepYFU1rXmv8BDUTtajGzfcYlgVB54ht93Cz3BctJBS0cmibcGtBjF8u5EZi/fo
         B2gLAmu4n8VK2ya6GAkrJgJ8B/LeDaDVxc2Ip5mnSdjeHCiLgzkkc6/tKiJR9s60XtbN
         8ahw==
X-Gm-Message-State: APjAAAVdq77MZb+Kjji/toYupfMrGBhKbOeXBPrvNXogVXBiqMa0+tzA
        W4pnHjAz4L5ir+FR2IduIb16FIkHKOOcOEbysn0=
X-Google-Smtp-Source: APXvYqzQM5gP/cYHAuzGMFZYP1qbaIpfdL32LdHP383dg0libIFE+s6iGNJX947GCszOLxkWqTsz1dP4dZLCkY7G/l4=
X-Received: by 2002:a0c:ae50:: with SMTP id z16mr7880056qvc.60.1560190115567;
 Mon, 10 Jun 2019 11:08:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190610163421.208126-1-sdf@google.com>
In-Reply-To: <20190610163421.208126-1-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 10 Jun 2019 11:08:24 -0700
Message-ID: <CAEf4BzYvvBwWP9qaCc=saJx-tPmX1qz8TXACfKwBOUW4Q_7bcA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 0/8] bpf: getsockopt and setsockopt hooks
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        davem@davemloft.net, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 9:39 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> This series implements two new per-cgroup hooks: getsockopt and
> setsockopt along with a new sockopt program type. The idea is pretty
> similar to recently introduced cgroup sysctl hooks, but
> implementation is simpler (no need to convert to/from strings).
>
> What this can be applied to:
> * move business logic of what tos/priority/etc can be set by
>   containers (either pass or reject)
> * handle existing options (or introduce new ones) differently by
>   propagating some information in cgroup/socket local storage
>
> Compared to a simple syscall/{g,s}etsockopt tracepoint, those
> hooks are context aware. Meaning, they can access underlying socket
> and use cgroup and socket local storage.

It's customary to include version change log for the whole patch set
in a cover letter vs first patch. Please include it in the future.
Thanks!

>
> Stanislav Fomichev (8):
>   bpf: implement getsockopt and setsockopt hooks
>   bpf: sync bpf.h to tools/
>   libbpf: support sockopt hooks
>   selftests/bpf: test sockopt section name
>   selftests/bpf: add sockopt test
>   selftests/bpf: add sockopt test that exercises sk helpers
>   bpf: add sockopt documentation
>   bpftool: support cgroup sockopt
>
>  Documentation/bpf/index.rst                   |   1 +
>  Documentation/bpf/prog_cgroup_sockopt.rst     |  39 +
>  include/linux/bpf-cgroup.h                    |  29 +
>  include/linux/bpf.h                           |  45 +
>  include/linux/bpf_types.h                     |   1 +
>  include/linux/filter.h                        |  13 +
>  include/uapi/linux/bpf.h                      |  13 +
>  kernel/bpf/cgroup.c                           | 262 ++++++
>  kernel/bpf/core.c                             |   9 +
>  kernel/bpf/syscall.c                          |  19 +
>  kernel/bpf/verifier.c                         |  15 +
>  net/core/filter.c                             |   2 +-
>  net/socket.c                                  |  18 +
>  .../bpftool/Documentation/bpftool-cgroup.rst  |   7 +-
>  .../bpftool/Documentation/bpftool-prog.rst    |   2 +-
>  tools/bpf/bpftool/bash-completion/bpftool     |   8 +-
>  tools/bpf/bpftool/cgroup.c                    |   5 +-
>  tools/bpf/bpftool/main.h                      |   1 +
>  tools/bpf/bpftool/prog.c                      |   3 +-
>  tools/include/uapi/linux/bpf.h                |  14 +
>  tools/lib/bpf/libbpf.c                        |   5 +
>  tools/lib/bpf/libbpf_probes.c                 |   1 +
>  tools/testing/selftests/bpf/.gitignore        |   2 +
>  tools/testing/selftests/bpf/Makefile          |   4 +-
>  .../testing/selftests/bpf/progs/sockopt_sk.c  |  67 ++
>  .../selftests/bpf/test_section_names.c        |  10 +
>  tools/testing/selftests/bpf/test_sockopt.c    | 773 ++++++++++++++++++
>  tools/testing/selftests/bpf/test_sockopt_sk.c | 156 ++++
>  28 files changed, 1514 insertions(+), 10 deletions(-)
>  create mode 100644 Documentation/bpf/prog_cgroup_sockopt.rst
>  create mode 100644 tools/testing/selftests/bpf/progs/sockopt_sk.c
>  create mode 100644 tools/testing/selftests/bpf/test_sockopt.c
>  create mode 100644 tools/testing/selftests/bpf/test_sockopt_sk.c
>
> --
> 2.22.0.rc2.383.gf4fbbf30c2-goog
