Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7B0B125B08
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 06:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfLSFxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 00:53:07 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:46001 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSFxH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 00:53:07 -0500
Received: by mail-qk1-f196.google.com with SMTP id x1so3681952qkl.12;
        Wed, 18 Dec 2019 21:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sY7kXZgof7kBpv2nRNAA3pzkX6v7x1JkY9eB+ySk0ZI=;
        b=dj9L7rjVc+eenQztxoeE7n+EBFcyZ/k1p8SeUM+PFcteKKrItaKLlvNC3zBPDxOmcH
         of0YTWZf1+Ngj2PdHKDhyUXQt4j4BJp3l6O/VUdvqRC8RUeVxfdCFtURuNkg2+R75T+4
         zjz2xdJ6Qw68ETkDh4+T2H5WeNQDSpqdm+9U1wR+B85GzOtikxzYKJW/bKaFzsr2dNtp
         b99LWTfXEIVprUKOCNgQNrAX19wmJvna9/gZ4gzhSCfY87YRAiVj/TIUohLTnDUAU56b
         YJybi78+Ox5fzPrSnRIPm/jduvQ6LGd1KOOKwGo9CaX9NKw22cBpA9CJAMdZZGXlLJ/r
         unQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sY7kXZgof7kBpv2nRNAA3pzkX6v7x1JkY9eB+ySk0ZI=;
        b=VZd8fHhT+XFu0MiIGQgoes7ffZP+0SaKrr9dq4m2GCZrflfF8n4w6No1rB92d9t4VO
         QbyLg/W4r2NWYUcA7yw0HVgjx7hEf5XwbVH9e8zEpouuuCAh5abdNNX85c1uAi+zMHyl
         xV4XAHZ0HbMIrCcvJsYcZhXT/KaAgfCbPpJCXXSFgB4ZMPWXc151C+G3U44V4of35fYR
         lJ6DGFSmZdiJU5Zni8chHlbOp/raVA8rgm9lOd5xyAdHQU75qjXddf+cAimEHuE4qs4u
         9jagWl50TZ6gBefJcz6V3xNhwFJm858+OGDCfNtA6YtOVOZnJt54N1gemAWwVcbGVipx
         dy+A==
X-Gm-Message-State: APjAAAVDHo7ukffKozB6MiFsmcQFUiiAaSNvxwI5qCY7b1szuxe6kPfF
        vBCet1XKuFSEOxWoJU9/DFE6GGnvNRkYOYYJM68=
X-Google-Smtp-Source: APXvYqzM46Wp+cFp49N3qdXM0/1vLmZjKzW8CXyJ8ZHSzdqiO30WmcXCh1nQjT0kQpVVA/eCr2SE2oJYyn0Jdb7CbZQ=
X-Received: by 2002:a37:a685:: with SMTP id p127mr6703397qke.449.1576734786581;
 Wed, 18 Dec 2019 21:53:06 -0800 (PST)
MIME-Version: 1.0
References: <20191219020442.1922617-1-ast@kernel.org>
In-Reply-To: <20191219020442.1922617-1-ast@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Dec 2019 21:52:55 -0800
Message-ID: <CAEf4BzZvUQtqXWZvBrZp_H17TDwYaU1RRAbdBqcYZJN7NAz-zA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Fix test_attach_probe
To:     Alexei Starovoitov <ast@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 6:04 PM Alexei Starovoitov <ast@kernel.org> wrote:
>
> Fix two issues in test_attach_probe:
> 1. it was not able to parse /proc/self/maps beyond the first line,
>    since %s means parse string until white space.
> 2. offset has to be accounted for otherwise uprobed address is incorrect.
>
> Fixes: 1e8611bbdfc9 ("selftests/bpf: add kprobe/uprobe selftests")
> Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> ---

Thanks for fixing!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/prog_tests/attach_probe.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/attach_probe.c b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> index 5ed90ede2f1d..a0ee87c8e1ea 100644
> --- a/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> +++ b/tools/testing/selftests/bpf/prog_tests/attach_probe.c
> @@ -3,7 +3,7 @@
>  #include "test_attach_probe.skel.h"
>
>  ssize_t get_base_addr() {
> -       size_t start;
> +       size_t start, offset;
>         char buf[256];
>         FILE *f;
>
> @@ -11,10 +11,11 @@ ssize_t get_base_addr() {
>         if (!f)
>                 return -errno;
>
> -       while (fscanf(f, "%zx-%*x %s %*s\n", &start, buf) == 2) {
> +       while (fscanf(f, "%zx-%*x %s %zx %*[^\n]\n",

never new [^<chars>] is possible, very nice!

> +                     &start, buf, &offset) == 3) {
>                 if (strcmp(buf, "r-xp") == 0) {
>                         fclose(f);
> -                       return start;
> +                       return start - offset;
>                 }
>         }
>
> --
> 2.23.0
>
