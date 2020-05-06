Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F62C1C7CDD
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 23:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729759AbgEFVx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 17:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729684AbgEFVxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 17:53:54 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E1BC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 14:53:54 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id d128so1818412ybb.2
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 14:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=v0EebI0wRb/tvCNXlsGxxNrmG0tMY7mj+ffgbYSbdE0=;
        b=UFXjgemcco3wS+VML2EXMGYsw4wBSNxjKeNKGP2VQLQpBCDRbOWS3ejRsjb8/MLwVB
         i44cyTIAOyIGEL+wG8PZ0kJ9esTwBGXdx1zh1tGCCnHhNK7xnhqyfssDgOfJsCnc6LBq
         Y/o2XLAjh5ZzlmDVZ4/xuF759eOvsb+adnnL9vX2PtjVSDSxvuwI/7S3i836Ws1zEaJr
         HttwrrK4q8cCP7sMvkDPaC9kC2+rXJ9azKf15LY7RvcFueycEHCNZ6g32E2lhLfRpyFn
         GwI02VwqdYfZze5r4HE4SrZYbdMcWEv54HwOEWeME7Qh0f2TtH+Y7LpKH2iSuGul9/Hw
         hjrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=v0EebI0wRb/tvCNXlsGxxNrmG0tMY7mj+ffgbYSbdE0=;
        b=B/hKhWH9EWqAi0w7FZZZteOnjl2B5Cg43a6nz7nX2S/rK7vW7Iv/Xi7PtfjjrojErt
         qe1dLO+9ZDe7ETrPwwLFRUl5xqJMywM73aQyMyfT9n+RAR40iAkBjtC2kX3+ecZNFe3l
         vpp5d9Clqmm66zMxh3SiGXX0XlBL2eLDADzrJc0d5q9vQdFO+i5QmVqdFbVCaHLhRHeV
         m9f/7C6np6rt4JWXLRihg6GIC/wJOeQkJQ12YhGX1HR+tnrm/omq7MMGNWi2hkN9KCyv
         gM+jBRiLGQqVv8KTPWkU4w9wNs0tA8U6HRlu3bLgQeMmipJ0RvI+QH+J6xbXYmCV4lle
         Lmew==
X-Gm-Message-State: AGi0PuZo575NDxN2Kz+MZ3AfYd2CZ9SaUPl28BOlovSGk0OO0xwdNIRa
        n8jvzvQF4HSWR68NXcuVW/FJ/TK8SS6ryZtwjVchRg==
X-Google-Smtp-Source: APiQypIZ2lS5JPETs/hxM32Qe7xXAMoWoXTnHt9xQRKtH2nGeflyJrnujdzb/J6oXE99NJCr1duB3JFM88kNT6eEST0=
X-Received: by 2002:a25:77d8:: with SMTP id s207mr15709759ybc.47.1588802033385;
 Wed, 06 May 2020 14:53:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200506205257.8964-1-irogers@google.com> <20200506205257.8964-3-irogers@google.com>
 <CAEf4BzYJanGO+XrTBQoEzGoB_D6xQYYm9tT70+Kie4hyKCxhjQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYJanGO+XrTBQoEzGoB_D6xQYYm9tT70+Kie4hyKCxhjQ@mail.gmail.com>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 6 May 2020 14:53:41 -0700
Message-ID: <CAP-5=fW97DB0CTLN=5iKPUF_tJW-yZgC+jiikdU0goSD_ADYkQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] lib/bpf hashmap: fixes to hashmap__clear
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 2:36 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Wed, May 6, 2020 at 1:55 PM Ian Rogers <irogers@google.com> wrote:
> >
> > hashmap_find_entry assumes that if buckets is NULL then there are no
> > entries. NULL the buckets in clear to ensure this.
> > Free hashmap entries and not just the bucket array.
> >
> > Signed-off-by: Ian Rogers <irogers@google.com>
> > ---
>
> This is already fixed in bpf-next ([0]). Seems to be 1-to-1 character
> by character :)
>
>   [0] https://patchwork.ozlabs.org/project/netdev/patch/20200429012111.277390-5-andriin@fb.com/

Thanks!
Ian

> >  tools/lib/bpf/hashmap.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> >
> > diff --git a/tools/lib/bpf/hashmap.c b/tools/lib/bpf/hashmap.c
> > index 54c30c802070..1a1bca1ff5cd 100644
> > --- a/tools/lib/bpf/hashmap.c
> > +++ b/tools/lib/bpf/hashmap.c
> > @@ -59,7 +59,13 @@ struct hashmap *hashmap__new(hashmap_hash_fn hash_fn,
> >
> >  void hashmap__clear(struct hashmap *map)
> >  {
> > +       struct hashmap_entry *cur, *tmp;
> > +       size_t bkt;
> > +
> > +       hashmap__for_each_entry_safe(map, cur, tmp, bkt)
> > +               free(cur);
> >         free(map->buckets);
> > +       map->buckets = NULL;
> >         map->cap = map->cap_bits = map->sz = 0;
> >  }
> >
> > --
> > 2.26.2.526.g744177e7f7-goog
> >
