Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BABEC3EA3C7
	for <lists+netdev@lfdr.de>; Thu, 12 Aug 2021 13:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236877AbhHLLdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Aug 2021 07:33:37 -0400
Received: from mail-oi1-f178.google.com ([209.85.167.178]:33665 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233613AbhHLLdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Aug 2021 07:33:36 -0400
Received: by mail-oi1-f178.google.com with SMTP id h11so9906782oie.0;
        Thu, 12 Aug 2021 04:33:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=njZPSmHfA5zoCliKmUp/d0fg44MW+GCyFpr9USFM3ak=;
        b=Z65yRWFQ82yGBjojJqx6E9iJvGO9VGJnQgJ0yIwTS2QxEelrCZPToNnoBwiUz/98Qz
         GlksIlM7Ta6GqO/L77HEcFst6N6MHGnrl93pIBkrKPzP0rGQM/FF/MqsJZ+uQlsNZXy4
         sRmCrcuhXT19yImDETWl8VPg5s37tVLGZFrKo3vYIeOp428/WeEH6OM598chnftuiZjq
         8p5Xz9gBv/ImhZwjkKucan/63WOM2sDAGCzTT/m+C9D/g043kevQlnmYWAq05UYq5oYn
         vxf5IuSH5SJPa30hqHZprzVgMHyydfPDoV49MOiyKYmLEQKXtqzS78rVs/6scfXFUeaq
         D8YA==
X-Gm-Message-State: AOAM530aAFd9fe1nptH7gIpVMr6JGx9QWT9pXDNDdwQYR+rKIC7ZVsP0
        5ybxmjPlT5MmJRMRLKm3c7xWT3QuYjN9/ZSQBnay6zpQcao=
X-Google-Smtp-Source: ABdhPJx9L4bp13VO5Q8Czb8nhWBOUK8buhij6kzIJCIkKrqA0mAhkAZ5cpjl48Rr/tmV1Zoac0upMiqJQ15rTewjb9A=
X-Received: by 2002:aca:af0d:: with SMTP id y13mr271805oie.161.1628767990675;
 Thu, 12 Aug 2021 04:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210723082932.3570396-1-jk@codeconstruct.com.au>
 <20210723082932.3570396-2-jk@codeconstruct.com.au> <alpine.DEB.2.22.394.2108121139490.530553@ramsan.of.borg>
 <63a6e8ad8a8ae908aa73a3f910b98692c1a9aa37.camel@codeconstruct.com.au>
In-Reply-To: <63a6e8ad8a8ae908aa73a3f910b98692c1a9aa37.camel@codeconstruct.com.au>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Thu, 12 Aug 2021 13:32:59 +0200
Message-ID: <CAMuHMdUjn8H8651XVOjBrBFqQs1bKR8kZbSPJWRhr071xk_kaw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 01/16] mctp: Add MCTP base
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeremy,

On Thu, Aug 12, 2021 at 1:15 PM Jeremy Kerr <jk@codeconstruct.com.au> wrote:
> > When building an allmodconfig kernel, I got:
>
> [...]
>
> I don't see this on a clean allmodconfig build, nor when building the
> previous commit then the MCTP commit with something like:
>
>   git checkout bc49d81^
>   make O=obj.allmodconfig allmodconfig
>   make O=obj.allmodconfig -j16
>   git checkout bc49d81
>   make O=obj.allmodconfig -j16
>
> - but it seems like it might be up to the ordering of a parallel build.
>
> From your description, it does sound like it's not regenerating flask.h;
> the kbuild rules would seem to have a classmap.h -> flask.h dependency:
>
>   $(addprefix $(obj)/,$(selinux-y)): $(obj)/flask.h
>
>   quiet_cmd_flask = GEN     $(obj)/flask.h $(obj)/av_permissions.h
>         cmd_flask = scripts/selinux/genheaders/genheaders $(obj)/flask.h $(obj)/av_permissions.h
>
>   targets += flask.h av_permissions.h
>   $(obj)/flask.h: $(src)/include/classmap.h FORCE
>         $(call if_changed,flask)
>
> however, classmap.h is #include-ed as part of the genheaders binary
> build, rather than read at runtime; maybe $(obj)/flask.h should depend
> on the genheaders binary, rather than $(src)/include/classmap.h ?
>
> If you can reproduce, can you compare the ctimes with:
>
>   stat scripts/selinux/genheaders/genheaders security/selinux/flask.h
>
> in your object dir?

Unfortunately I can't seem to reproduce this anymore.
Goodbye, Heisenbug!

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
