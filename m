Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C064FB8218
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 22:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404564AbfISUCx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 16:02:53 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37015 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404554AbfISUCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 16:02:52 -0400
Received: by mail-qk1-f196.google.com with SMTP id u184so4769393qkd.4;
        Thu, 19 Sep 2019 13:02:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8tiLUzdYi4ITB45WucLNW+ND66QoXoPlA91lr3mWY0I=;
        b=sbqDMqvcvX3x6cU1Bdz+6qPbXVu92Hlw7FpYhWcmNu2nb76PWtUJQnkwE98baOLrmI
         0MY5otAgmrOc07A8Yw0QDg6TYwqi+mvnIXIpvyl6ZrblMCiJXvmVj9lbRaDSVNV+QHG4
         67cVb+vU6c/ZsY1HTtHGdmiK6rFizS7IbGORW4k/+nBbjcSQiGBXcGYtSYOW62F56AGF
         KTtEt9mAPo7t9Y4oJBowYtKY56XThUbC2h6tYPXdFXFriLnIeZRzsQoKFno5YPPTQq/7
         CElIzcWjG2FWQf2DczVSoq2MHQxMYDCoemtFPqe2+IrN1xGdhKayesdkq08nUYx3ZwOQ
         WysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8tiLUzdYi4ITB45WucLNW+ND66QoXoPlA91lr3mWY0I=;
        b=lhHDaapT72xnTD1PFTZvH6rcMz/4SQ6Bb4sZLixz/vDTHUqzbImYkB17pXYFMJXBzy
         zcKqv7KqFM69FWIKxbWuYY9O4WjXd1JO25HtGEZF/xEFAE6ZkTjTYM6gPJH8ahzVj26m
         H7mFeva/pCmzUEnTVnrwnnZyXsgpTLwAQCcjnTq7qv/FEpkwz1RotZywGv/CTTkXKFxF
         eevnZjIR3OuAqNOdRYhUjEgd4B396ND9DhpPziG5Gd0gcT3u4NenjB2hHrbn7zJf3dLH
         c/mZ4RG++oFUsW9XgJia50rzpsZdMpYkHqj447NmYMWzz+F4ZefFqDIvb1Wk3hNwvGwM
         1KRA==
X-Gm-Message-State: APjAAAWap6OViTOZDrOKTCeSr6gXXkiXY0toFNPWoevLXQkwC6ogFrfK
        8zg5E/Wx1wTAT6RlE7xYqh11denF3pgATfNdfes=
X-Google-Smtp-Source: APXvYqwvmENtZwqOUjQyedETgKcY0/COJMPAGFK2CXOq7iyOjkYW6yMxk6opBKWcdNrSSEZYulbmcSZPLeNxXGPRIvE=
X-Received: by 2002:a05:620a:119a:: with SMTP id b26mr4913032qkk.39.1568923371419;
 Thu, 19 Sep 2019 13:02:51 -0700 (PDT)
MIME-Version: 1.0
References: <20190919160518.25901-1-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190919160518.25901-1-ivan.khoronzhuk@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Sep 2019 13:02:40 -0700
Message-ID: <CAEf4BzbCjCYr5NMPctDkUggwpehnqZPVBSqZOsd9MvSq6WmnZQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix version identification on busybox
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 11:22 AM Ivan Khoronzhuk
<ivan.khoronzhuk@linaro.org> wrote:
>
> It's very often for embedded to have stripped version of sort in
> busybox, when no -V option present. It breaks build natively on target
> board causing recursive loop.
>
> BusyBox v1.24.1 (2019-04-06 04:09:16 UTC) multi-call binary. \
> Usage: sort [-nrugMcszbdfimSTokt] [-o FILE] [-k \
> start[.offset][opts][,end[.offset][opts]] [-t CHAR] [FILE]...
>
> Lets modify command a little to avoid -V option.
>
> Fixes: dadb81d0afe732 ("libbpf: make libbpf.map source of truth for libbpf version")
>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
> ---
>
> Based on bpf/master
>
>  tools/lib/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index c6f94cffe06e..a12490ad6215 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -3,7 +3,7 @@
>
>  LIBBPF_VERSION := $(shell \
>         grep -oE '^LIBBPF_([0-9.]+)' libbpf.map | \
> -       sort -rV | head -n1 | cut -d'_' -f2)
> +       cut -d'_' -f2 | sort -r | head -n1)

You can't just sort alphabetically, because:

1.2
1.11

should be in that order. See discussion on mailing thread for original commit.

>  LIBBPF_MAJOR_VERSION := $(firstword $(subst ., ,$(LIBBPF_VERSION)))
>
>  MAKEFLAGS += --no-print-directory
> --
> 2.17.1
>
