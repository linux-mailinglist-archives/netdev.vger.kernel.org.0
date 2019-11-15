Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7B4FE889
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 00:19:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727118AbfKOXTz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 18:19:55 -0500
Received: from mail-qv1-f65.google.com ([209.85.219.65]:39522 "EHLO
        mail-qv1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727081AbfKOXTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 18:19:54 -0500
Received: by mail-qv1-f65.google.com with SMTP id v16so4411581qvq.6;
        Fri, 15 Nov 2019 15:19:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5H0upJD85LsJpWb47KRfmawzG2aF86f9AGuL1KKMF0I=;
        b=btmaDFindbK7PDHirwFL8bxorvmApxLla6bM63XANakU5UJ1y3Cq8Jrd8vMqg4t6EW
         yY5Pmncu3A/joX4UpmXaMD92cPgJ4o7M061IhKnBOMTIjQJgaSOIbCQzCQltg6A7uhbn
         Esg5XSHUgOpasT4/QEFIEbzVzLqMjUfNM2myv8a+WSCMF8Dp7M3GpClp8Cvl7D0blqGf
         S5S17+p4bF+RpOYtSzrVkSoCYV/koKFEnsu0qjox6c9jUWBlTZhdGqZ6PwTK6Wc15LES
         KjeOsmvgeAmAO40sdA2e9TRTHWuqbTd5wlYcjorLOXuW17jilw9FEqG8GAAKRd5QtdOY
         AWCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5H0upJD85LsJpWb47KRfmawzG2aF86f9AGuL1KKMF0I=;
        b=ReNPhqj8074WNnw8xuyWTVJAp+kKfoGkun6rZ5WPz7+qe4Mn4QNZ9gt8xINEsKSeXm
         TDxbWy+tC0d8bAdt4u+UST97fK4GcQL1wWeFjVZgVXqhQr2NtDdnPB05hPZFn0HEmPRG
         CH3/7DKOgaQ0eT1d+0J76kpjoADzrjeltE/Ep5xsh+C6faPteM/VfvaWiCnhICpf5i++
         6kBgiRalsPM2J3mBbdBSeOwumeRLJPga6Ba+Ln9OttRWaCuq2i/BXtsSY9p2LG6LwDo+
         fC/7nuqxJOEilCn9L6XQL76RgHa9zms805A8GxxW8BX8rgv3Pd8g6Sj1CHAob1IqYuKJ
         KnxQ==
X-Gm-Message-State: APjAAAX1RW/APrhH8KQUUNRcLSbWh5l4zLnVvbwq4OCq/rGwmU2quv+C
        lMbYfIhhfen+BnJfA2+snYEJed4uJZf3XveNYN0=
X-Google-Smtp-Source: APXvYqxx6WtC2yZ5iBDwau8E1o/p67sFS0efLfev2x3wVeEQAo/+GpS/4hdA0QRWWvfiR7baCUI5LMIcl9YhK3q5los=
X-Received: by 2002:ad4:4042:: with SMTP id r2mr5678247qvp.196.1573859993414;
 Fri, 15 Nov 2019 15:19:53 -0800 (PST)
MIME-Version: 1.0
References: <cover.1573779287.git.daniel@iogearbox.net> <ba2d30018f57b5608e04e105c6f6692e687698b4.1573779287.git.daniel@iogearbox.net>
In-Reply-To: <ba2d30018f57b5608e04e105c6f6692e687698b4.1573779287.git.daniel@iogearbox.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 Nov 2019 15:19:42 -0800
Message-ID: <CAEf4BzZmdWmkAU72eYA8U9=XN2TerUeVySgEpQ7E9cNPRcm6_w@mail.gmail.com>
Subject: Re: [PATCH rfc bpf-next 4/8] bpf: move owner type,jited info into
 array auxillary data
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 14, 2019 at 5:04 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> We're going to extend this with further information which is only
> relevant for prog array at this point. Given this info is not used
> in critical path, move it into its own structure such that the main
> array map structure can be kept on diet.
>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---

Looks good.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  include/linux/bpf.h     | 18 +++++++++++-------
>  kernel/bpf/arraymap.c   | 32 ++++++++++++++++++++++++++++++--
>  kernel/bpf/core.c       | 11 +++++------
>  kernel/bpf/map_in_map.c |  5 ++---
>  kernel/bpf/syscall.c    | 16 ++++++----------
>  5 files changed, 54 insertions(+), 28 deletions(-)
>

[...]
